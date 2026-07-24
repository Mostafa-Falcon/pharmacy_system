import 'dart:async';

import 'package:drift/drift.dart';
import 'package:get_it/get_it.dart';

import 'package:pharmacy_system/app/core/sync/config/sync_config.dart';
import 'package:pharmacy_system/app/core/data/database/daos/sync_dao.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/core/sync/engine/sync_engine.dart';
import 'package:pharmacy_system/app/core/sync/models/sync_models.dart';

export 'package:pharmacy_system/app/core/sync/models/sync_models.dart';

/// A bridge service that exposes SyncEngine functionality to the UI and other modules.
class SyncService {
  static SyncDao get _syncDao => GetIt.instance<SyncDao>();
  static AppDatabase get _db => GetIt.instance<AppDatabase>();

  static Stream<bool> get onlineStream => SyncEngine.instance.onlineStream;
  static Stream<SyncProgress> get progressStream =>
      SyncEngine.instance.progressStream;
  static Stream<SyncStatus> get statusStream =>
      SyncEngine.instance.statusStream;

  static bool get isOnline => SyncEngine.instance.isOnline;
  static bool get isSyncing => SyncEngine.instance.isSyncing;
  static DateTime? get lastSyncTime => SyncEngine.instance.lastSyncTime;
  static String? get lastSyncError => SyncEngine.instance.lastSyncError;

  /// Returns the number of pending operations in the sync queue (Synchronous for UI)
  static int get pendingOperationsCount =>
      SyncEngine.instance.pendingOperationsCount;

  /// Stream of table updates (table, branchId)
  static Stream<(String, String)> get tableUpdateStream =>
      SyncEngine.instance.tableUpdateStream;

  /// Compatibility getter for repositories
  static void Function(String table, String branchId)? get onTableUpdated =>
      SyncEngine.instance.onTableUpdated;
  static set onTableUpdated(void Function(String table, String branchId)? v) =>
      SyncEngine.instance.onTableUpdated = v;

  static void notifyTableUpdated(String table, String branchId) {
    SyncEngine.instance.onTableUpdated?.call(table, branchId);
    // Note: tableUpdateStream is automatically notified via SyncEngine if we centralize it there,
    // but for manual repository updates we might need this.
  }

  static Future<void> initialize() async {
    await SyncEngine.instance.initialize();
  }

  static Future<void> syncAll() => SyncEngine.instance.syncAll();

  static Future<void> queueOperation({
    required SyncOperationType type,
    required String table,
    required Map<String, dynamic> data,
    String? branchId,
    String? recordId,
  }) async {
    await SyncEngine.instance.queueOperation(
      type: type,
      table: table,
      data: data,
      branchId: branchId,
      recordId: recordId,
    );
  }

  // ─── Legacy Support Helpers ──────────────────────────────────────────

  static Future<List<dynamic>> getLocalData({
    required String boxName,
    String? branchId,
  }) async {
    // Bridges to the new database logic for specific tables if needed,
    // or returns empty list for deprecated boxes.
    return [];
  }

  static Future<List<dynamic>> getAllLocalData({
    required String boxName,
  }) async {
    return [];
  }

  static Future<void> create({
    required String boxName,
    required dynamic entity,
    required String branchId,
    required Map<String, dynamic> toJson,
  }) async {
    await queueOperation(
      type: SyncOperationType.create,
      table: boxName,
      data: toJson,
      branchId: branchId,
    );
  }

  static Future<void> update({
    required String boxName,
    required dynamic entity,
    required String branchId,
    required Map<String, dynamic> toJson,
  }) async {
    await queueOperation(
      type: SyncOperationType.update,
      table: boxName,
      data: toJson,
      branchId: branchId,
    );
  }

  static Future<void> softDelete({
    required String boxName,
    String? id,
    String? key,
    required String branchId,
    Map<String, dynamic>? currentData,
  }) async {
    final recordId =
        id ??
        key ??
        (currentData != null ? currentData['id']?.toString() : null) ??
        '';
    await queueOperation(
      type: SyncOperationType.delete,
      table: boxName,
      data: (currentData ?? {'id': recordId})..['is_deleted'] = true,
      branchId: branchId,
      recordId: recordId,
    );
  }

  // ─── Queue Management ─────────────────────────────────────────────

  static Future<List<SyncOutboxTableData>> getPendingItems() async {
    return _syncDao.peekPending(10000);
  }

  static Future<int> getPendingCount() async {
    return SyncEngine.instance.pendingOperationsCount;
  }

  static Future<void> clearQueue() async {
    await _syncDao.purgeSynced();
    await SyncEngine.instance.updatePendingCount();
  }

  static Future<void> removePendingItem(String id) async {
    await _syncDao.markSynced(id);
    await SyncEngine.instance.updatePendingCount();
  }

  static Future<int> get deadLetterCount async {
    final items = await getDeadLetterItems();
    return items.length;
  }

  static Future<List<SyncOutboxTableData>> getDeadLetterItems() async {
    return (_db.select(_db.syncOutboxTable)..where(
          (t) =>
              t.status.equals('failed') |
              t.retryCount.isBiggerThan(Variable(SyncConfig.maxRetryCount - 1)),
        ))
        .get();
  }

  static Future<void> retryDeadLetterItem(String id) async {
    await (_db.update(_db.syncOutboxTable)..where((t) => t.id.equals(id))).write(
      SyncOutboxTableCompanion(
        status: const Value('pending'),
        retryCount: const Value(0),
        errorMessage: const Value(null),
      ),
    );
    await SyncEngine.instance.updatePendingCount();
  }

  static Future<bool> get hasPendingOperations =>
      SyncEngine.hasPendingOperations;

  static Future<void> pullOnly({List<String>? tables, String? branchId}) =>
      SyncEngine.instance.pullOnly(tables: tables, branchId: branchId);

  static Future<void> pushOnly() => SyncEngine.instance.pushOnly();

  static Future<void> syncSmart() => SyncEngine.instance.syncSmart();

  static Future<void> pullAll() async {
    await SyncEngine.instance.pullOnly();
  }

  static Future<void> pushAll() async {
    await SyncEngine.instance.pushOnly();
  }

  static Future<int> getLocalTableCount(String tableName) async {
    return _syncDao.getTableCount(tableName);
  }
}




