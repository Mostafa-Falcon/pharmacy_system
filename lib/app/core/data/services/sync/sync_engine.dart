import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../config/sync_config.dart';
import 'sync_pull_service.dart';
import 'sync_push_service.dart';
import 'sync_dead_letter_service.dart';
import 'sync_compaction_service.dart';
import 'sync_models.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/core/data/database/daos/sync_dao.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/core/utils/app_utils.dart';

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
  bool _isSyncing = false;
  int _pendingCount = 0;
  DateTime? _lastSyncTime;
  String? _lastSyncError;
  Timer? _periodicTimer;
  Timer? _pushDebouncer;

  /// Stream of table updates (table, branchId)
  Stream<(String, String)> get tableUpdateStream => _tableUpdateController.stream;

  /// Legacy Callback (maintained for compatibility, but prefer tableUpdateStream)
  void Function(String table, String branchId)? onTableUpdated;

  bool get isSyncing => _isSyncing;
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
      _db.outboxTable,
    )..where((t) => t.syncedAt.isNull())).get();
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

  void _startPeriodicSync() {
    _periodicTimer?.cancel();
    _periodicTimer = Timer.periodic(SyncConfig.periodicInterval, (_) {
      if (isOnline && !_isSyncing) {
        pullAllTables();
      }
    });
  }

  void _initConnectivityListener({Connectivity? connectivity}) {
    (connectivity ?? Connectivity()).onConnectivityChanged.listen((result) {
      final isConnected = result != ConnectivityResult.none;
      isOnline = isConnected;
      _onlineController.add(isConnected);
      _emitStatus();
      if (isConnected) {
        pullAllTables();
      }
    });
  }

  void _emitStatus() {
    _statusController.add(
      SyncStatus(
        isOnline: isOnline,
        isSyncing: _isSyncing,
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
    if (!isOnline || _isSyncing) return;
    _pushDebouncer?.cancel();
    _pushDebouncer = Timer(const Duration(seconds: 3), () {
      if (isOnline && !_isSyncing) {
        syncAll();
      }
    });
  }

  /// Refresh the pending operations count from DB and emit it.
  Future<void> updatePendingCount() async {
    try {
      final items = await (_db.select(
        _db.outboxTable,
      )..where((t) => t.syncedAt.isNull())).get();
      _pendingCount = items.length;
      _emitStatus();
    } catch (e) {
      safeDebugPrint('SyncEngine.updatePendingCount error: $e');
    }
  }

  // ─── Sync Operations ──────────────────────────────────────────────────

  /// إرسال التغيرات المحلية المعلقة فقط إلى السحابة مع التجميع والضغط أولاً.
  Future<void> pushOnly() async {
    if (_isSyncing || !isOnline) return;
    _isSyncing = true;
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
      _isSyncing = false;
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

    _isSyncing = true;
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
            lastSyncedAt: watermark?.lastWatermark,
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
      _isSyncing = false;
      _emitStatus();
    }
  }

  /// مزامنة كاملة ذكية ومزدوجة الاتجاه (تجميع ← إرسال ← سحب الفروقات)
  Future<void> syncAll() async {
    if (!isOnline) return;
    await pushOnly();
    await pullOnly();
  }

  /// الاسم المعرف الجديد للمزامنة الشاملة الذكية
  Future<void> syncSmart() => syncAll();

  static const List<String> _syncTables = [
    'branches',
    'users',
    'permissions',
    'customers',
    'suppliers',
    'supplier_customers',
    'customer_groups',
    'medicines',
    'medicine_units',
    'item_batches',
    'inventory',
    'stock_transfers',
    'sales',
    'purchases',
    'returns',
    'quotes',
    'cashier_shifts',
    'customer_ledgers',
    'supplier_ledgers',
  ];

  Future<void> pullAllTables() => pullOnly();

  void reportProgress(SyncProgress progress) {
    _progressController.add(progress);
  }
}

