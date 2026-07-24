import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'sync_config.dart';
import 'sync_pull_service.dart';
import 'sync_push_service.dart';
import 'sync_dead_letter_service.dart';
import 'sync_compaction_service.dart';
import 'sync_models.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/core/data/database/daos/sync_dao.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/shared/ui_core.dart';

/// المحرك الأساسي لإدارة عملية المزامنة الحية المنسقة (Sync Engine Coordinator)
class SyncEngine {
  static final SyncEngine instance = SyncEngine._internal();
  SyncEngine._internal();

  late SyncPullService pullService;
  late SyncPushService pushService;
  late SyncDeadLetterService deadLetterService;
  late SyncCompactionService compactionService;

  // ─── Stream Controllers ───────────────────────────────────────────────

  final StreamController<bool> _onlineController =
      StreamController<bool>.broadcast();
  final StreamController<SyncProgress> _progressController =
      StreamController<SyncProgress>.broadcast();
  final StreamController<SyncStatus> _statusController =
      StreamController<SyncStatus>.broadcast();
  final StreamController<(String, String)> _tableUpdateController =
      StreamController<(String, String)>.broadcast();

  bool isOnline = true;
  bool _isPushing = false;
  bool _isPulling = false;
  bool _isSyncing = false;
  int _pendingCount = 0;
  DateTime? _lastSyncTime;
  String? _lastSyncError;
  Timer? _periodicTimer;
  Timer? _pushDebouncer;
  Timer? _retryTimer;
  int _retryAttempt = 0;
  bool _initialSyncDone = false;

  /// Stream of table updates (table, branchId)
  Stream<(String, String)> get tableUpdateStream => _tableUpdateController.stream;

  /// Legacy Callback (maintained for compatibility, but prefer tableUpdateStream)
  void Function(String table, String branchId)? onTableUpdated;

  bool get isSyncing => _isPushing || _isPulling || _isSyncing;
  int get pendingOperationsCount => _pendingCount;
  DateTime? get lastSyncTime => _lastSyncTime;
  String? get lastSyncError => _lastSyncError;

  Stream<bool> get onlineStream => _onlineController.stream;
  Stream<SyncProgress> get progressStream => _progressController.stream;
  Stream<SyncStatus> get statusStream => _statusController.stream;

  /// Legacy connectivity stream alias
  Stream<bool> get connectivityStream => _onlineController.stream;

  // ─── Static Helpers ───────────────────────────────────────────────────

  static AppDatabase get _db => GetIt.instance<AppDatabase>();
  static SyncDao get _syncDao => GetIt.instance<SyncDao>();

  static Future<bool> get hasPendingOperations async {
    final count = await (_db.select(
      _db.syncOutboxTable,
    )..where((t) => t.status.equals('pending'))).get();
    return count.isNotEmpty;
  }

  // ─── Initialization ───────────────────────────────────────────────────

  Future<void> initialize({
    SupabaseClient? supabaseClient,
    Connectivity? connectivity,
    SyncPullService? pull,
    SyncPushService? push,
    SyncDeadLetterService? deadLetter,
    SyncCompactionService? compaction,
  }) async {
    final supabase = supabaseClient ?? Supabase.instance.client;
    pullService = pull ?? SyncPullService(supabase);
    pushService = push ?? SyncPushService(supabase);
    deadLetterService = deadLetter ?? SyncDeadLetterService();
    compactionService = compaction ?? SyncCompactionService();

    await updatePendingCount();
    _initConnectivityListener(connectivity: connectivity);
    _startPeriodicSync();
    _emitStatus();
  }

  Future<void> initialSync({int delaySeconds = 5}) async {
    if (_initialSyncDone) return;
    _initialSyncDone = true;

    await Future.delayed(Duration(seconds: delaySeconds));
    if (!isOnline) return;

    safeDebugPrint('SyncEngine: Starting initial sync...');
    await syncAll();
    safeDebugPrint('SyncEngine: Initial sync complete.');
  }

  void _startPeriodicSync() {
    _periodicTimer?.cancel();
    _periodicTimer = Timer.periodic(SyncConfig.periodicInterval, (_) {
      if (isOnline && !_isPulling) {
        pullAllTables();
      }
    });
  }

  void _initConnectivityListener({Connectivity? connectivity}) {
    (connectivity ?? Connectivity()).onConnectivityChanged.listen((result) {
      final wasOffline = !isOnline;
      final isConnected = result != ConnectivityResult.none;
      isOnline = isConnected;
      _onlineController.add(isConnected);
      _emitStatus();

      if (isConnected) {
        _retryAttempt = 0;
        _retryTimer?.cancel();
        if (wasOffline) {
          safeDebugPrint('SyncEngine: Connection restored. Running sync...');
        }
        pullAllTables();
      } else {
        _startRetryBackoff();
      }
    });
  }

  void _startRetryBackoff() {
    _retryTimer?.cancel();
    if (_retryAttempt >= 5) return;

    final delay = Duration(seconds: [10, 30, 60, 120, 300][_retryAttempt]);
    _retryAttempt++;
    safeDebugPrint('SyncEngine: Retry $_retryAttempt/5 in ${delay.inSeconds}s...');

    _retryTimer = Timer(delay, () async {
      try {
        final connectivity = await Connectivity().checkConnectivity();
        if (connectivity != ConnectivityResult.none) {
          isOnline = true;
          _onlineController.add(true);
          _emitStatus();
          _retryAttempt = 0;
          pullAllTables();
        } else {
          _startRetryBackoff();
        }
      } catch (_) {
        _startRetryBackoff();
      }
    });
  }

  void _emitStatus() {
    _statusController.add(
      SyncStatus(
        isOnline: isOnline,
        isSyncing: isSyncing,
        lastSyncTime: _lastSyncTime,
        lastSyncError: _lastSyncError,
      ),
    );
  }

  // ─── Queue Management ─────────────────────────────────────────────────

  /// Queue a sync operation (create, update, delete) to be pushed later.
  Future<void> queueOperation({
    required SyncOperationType type,
    required String table,
    required Map<String, dynamic> data,
    String? branchId,
    String? recordId,
  }) async {
    try {
      await _syncDao.enqueue(
        operation: type.name,
        tableName: table,
        recordId: recordId ?? data['id']?.toString() ?? '',
        data: jsonEncode(data),
        branchId: branchId ?? '',
      );
      
      // Notify local listeners that a table has changed locally
      final bid = branchId ?? AuthService.currentBranchId ?? '';
      _tableUpdateController.add((table, bid));
      onTableUpdated?.call(table, bid);

      await updatePendingCount();
      _triggerAutoPush();
    } catch (e) {
      safeDebugPrint('SyncEngine.queueOperation error: $e');
    }
  }

  void _triggerAutoPush() {
    if (!isOnline || _isPushing || _isPulling) return;
    _pushDebouncer?.cancel();
    _pushDebouncer = Timer(const Duration(seconds: 3), () {
      if (isOnline && !_isPushing && !_isPulling) {
        syncAll();
      }
    });
  }

  /// Refresh the pending operations count from DB and emit it.
  Future<void> updatePendingCount() async {
    try {
      final items = await (_db.select(
        _db.syncOutboxTable,
      )..where((t) => t.status.equals('pending'))).get();
      _pendingCount = items.length;
      _emitStatus();
    } catch (e) {
      safeDebugPrint('SyncEngine.updatePendingCount error: $e');
    }
  }

  // ─── Sync Operations ──────────────────────────────────────────────────

  /// إرسال التغيرات المحلية المعلقة فقط إلى السحابة مع التجميع والضغط أولاً.
  Future<void> pushOnly() async {
    if (_isPushing || !isOnline) return;
    _isPushing = true;
    _lastSyncError = null;
    _emitStatus();
    try {
      safeDebugPrint('SyncEngine: Compacting outbox queue...');
      final eliminated = await compactionService.compactOutboxQueue();
      safeDebugPrint('SyncEngine: Outbox compacted ($eliminated redundant ops eliminated). Pushing queue...');

      await pushService.processPushQueue(
        syncBoxName: 'sync_queue',
        onFailedItem: (item) => deadLetterService.handleFailedItem(item),
        onItemProcessed: (table, success, isPending) {
          _progressController.add(SyncProgress(
            operation: SyncOperationType.create, 
            table: table, 
            isPending: isPending, 
            isSuccess: success,
          ));
        },
      );
      _lastSyncTime = DateTime.now();
      safeDebugPrint('SyncEngine: Push operation completed successfully.');
    } catch (e, s) {
      _lastSyncError = e.toString();
      safeDebugPrint('SyncEngine: Push operation failed: $e\n$s');
    } finally {
      _isPushing = false;
      await updatePendingCount();
      _emitStatus();
    }
  }

  /// سحب التغيرات السحابية الجديدة فقط دون إرسال المعلقات المحلية.
  Future<void> pullOnly({List<String>? tables, String? branchId}) async {
    if (!isOnline) return;
    
    final bid = branchId ?? AuthService.currentBranchId ?? '';
    if (bid.isEmpty) {
      safeDebugPrint('SyncEngine: Cannot pull tables without a branchId');
      return;
    }

    _isPulling = true;
    _lastSyncError = null;
    _emitStatus();

    try {
      final targetTables = tables ?? _syncTables;
      safeDebugPrint('SyncEngine: Starting PULL-ONLY cycle for ${targetTables.length} tables...');
      
      int totalUpdated = 0;
      for (final table in targetTables) {
        try {
          _progressController.add(SyncProgress(operation: SyncOperationType.update, table: table, isPending: true));
          final watermark = await _syncDao.getWatermark(table, bid);
          final count = await pullService.pullTable(
            tableName: table,
            branchId: bid,
            lastSyncedAt: watermark?.lastSyncedAt,
          );
          totalUpdated += count;
          _progressController.add(SyncProgress(operation: SyncOperationType.update, table: table, isPending: false, isSuccess: true));
          
          if (count > 0) {
            _tableUpdateController.add((table, bid));
            onTableUpdated?.call(table, bid);
          }

          await Future.delayed(Duration(milliseconds: SyncConfig.pullTableDelayMs));
        } catch (e) {
          safeDebugPrint('SyncEngine: Error pulling table $table: $e');
          _progressController.add(SyncProgress(operation: SyncOperationType.update, table: table, isPending: false, isSuccess: false, error: e.toString()));
          continue;
        }
      }

      _lastSyncTime = DateTime.now();
      safeDebugPrint('SyncEngine: PULL-ONLY cycle completed. Total updated: $totalUpdated');
    } catch (e, s) {
      _lastSyncError = e.toString();
      safeDebugPrint('SyncEngine: pullOnly failed: $e\n$s');
    } finally {
      _isPulling = false;
      _emitStatus();
    }
  }

  /// مزامنة كاملة ذكية ثنائية الاتجاه بالتوازي:
  /// الإرسال والسحب شغالين مع بعض بدون dependency.
  /// كل عملية ليها timeout خاص عشان مفيش حاجة تعلق.
  Future<void> syncAll() async {
    if (!isOnline || _isSyncing) return;
    _isSyncing = true;
    _lastSyncError = null;
    _emitStatus();

    try {
      await Future.wait([
        _pushWithTimeout(),
        _pullWithTimeout(),
      ]);
      _lastSyncTime = DateTime.now();
      safeDebugPrint('SyncEngine: Full sync cycle completed successfully.');
    } catch (e) {
      _lastSyncError = e.toString();
      safeDebugPrint('SyncEngine: Full sync cycle failed: $e');
    } finally {
      _isSyncing = false;
      await updatePendingCount();
      _emitStatus();
    }
  }

  Future<void> _pushWithTimeout() async {
    try {
      await pushOnly().timeout(SyncConfig.pushTimeout);
    } on TimeoutException catch (e) {
      safeDebugPrint('SyncEngine: Push timed out after ${SyncConfig.pushTimeout}');
      _lastSyncError = 'Push timed out: $e';
    }
  }

  Future<void> _pullWithTimeout() async {
    try {
      await pullOnly().timeout(SyncConfig.pullTimeout);
    } on TimeoutException catch (e) {
      safeDebugPrint('SyncEngine: Pull timed out after ${SyncConfig.pullTimeout}');
      _lastSyncError ??= 'Pull timed out: $e';
    }
  }

  /// الاسم المعرف الجديد للمزامنة الشاملة الذكية
  Future<void> syncSmart() => syncAll();

  static const List<String> _syncTables = [
    'branches',
    'users',
    'permissions',
    'item_categories',
    'medicine_brands',
    'item_variants',
    'item_warranties',
    'price_groups',
    'barcode_settings',
    'medicines',
    'item_batches',
    'stocktaking',
    'stock_adjustments',
    'item_swaps',
    'opening_stock',
    'inventory_transactions',
    'customer_groups',
    'customers',
    'suppliers',
    'supplier_customers',
    'sales_agents',
    'contact_ledger',
    'purchase_invoices',
    'supplied_items',
    'promotions',
    'cashier_shifts',
    'sale_invoices',
    'free_returns',
    'invoice_returns',
    'quotations',
    'shipping_orders',
    'account_tree',
    'expense_categories',
    'expenses',
    'journal_entries',
    'payment_vouchers',
    'attendance',
    'employee_messages',
    'payroll',
    'app_settings',
    'app_notifications',
    'archive_records',
    'audit_logs',
    'receipt_counters',
  ];

  Future<void> pullAllTables() => pullOnly();

  void reportProgress(SyncProgress progress) {
    _progressController.add(progress);
  }
}




