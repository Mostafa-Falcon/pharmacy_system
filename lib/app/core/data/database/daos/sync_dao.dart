import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../database.dart';

class SyncDao {
  final AppDatabase db;
  SyncDao(this.db);

  static const _uuid = Uuid();

  Future<void> enqueue({
    required String operation,
    required String tableName,
    required String recordId,
    required String data,
    required String branchId,
  }) async {
    await db.into(db.outboxTable).insert(OutboxTableCompanion.insert(
      id: _uuid.v4(),
      operation: operation,
      targetTable: tableName,
      recordId: recordId,
      data: data,
      createdAt: DateTime.now(),
      retryCount: 0,
      branchId: branchId,
    ));
  }

  Future<List<OutboxTableData>> peekPending(int limit) async {
    return (db.select(db.outboxTable)
          ..where((t) => t.syncedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)])
          ..limit(limit))
        .get();
  }

  Future<void> markSynced(String id) async {
    await (db.update(db.outboxTable)..where((t) => t.id.equals(id)))
        .write(OutboxTableCompanion(
          syncedAt: Value(DateTime.now()),
          retryCount: const Value(0),
        ));
  }

  Future<void> markFailed(String id, String error) async {
    final existing = await (db.select(db.outboxTable)
          ..where((t) => t.id.equals(id)))
        .getSingle();
    await (db.update(db.outboxTable)..where((t) => t.id.equals(id)))
        .write(OutboxTableCompanion(
          retryCount: Value(existing.retryCount + 1),
          lastError: Value(error),
        ));
  }

  Future<void> purgeSynced() async {
    await (db.delete(db.outboxTable)..where((t) => t.syncedAt.isNotNull()))
        .go();
  }

  Future<void> purgeDeadLetters(int maxRetries) async {
    await (db.delete(db.outboxTable)
          ..where((t) => t.retryCount.isBiggerThan(Variable(maxRetries - 1))))
        .go();
  }

  Future<List<OutboxTableData>> getUnsyncedItems() async {
    return (db.select(db.outboxTable)
          ..where((t) => t.syncedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
  }

  Future<bool> hasUnsyncedForRecord(String targetTable, String recordId) async {
    final rows = await (db.select(db.outboxTable)
          ..where((t) =>
              t.syncedAt.isNull() &
              t.targetTable.equals(targetTable) &
              t.recordId.equals(recordId)))
        .get();
    return rows.isNotEmpty;
  }

  Future<void> deleteOutboxItems(List<String> ids) async {
    if (ids.isEmpty) return;
    await (db.delete(db.outboxTable)..where((t) => t.id.isIn(ids))).go();
  }

  Future<void> updateOutboxItem(String id, String newData, String newOperation) async {
    await (db.update(db.outboxTable)..where((t) => t.id.equals(id)))
        .write(OutboxTableCompanion(
          data: Value(newData),
          operation: Value(newOperation),
          createdAt: Value(DateTime.now()),
        ));
  }

  Future<SyncStateTableData?> getWatermark(String table, String branchId) async {
    final rows = await (db.select(db.syncStateTable)
          ..where((t) =>
              t.syncTable.equals(table) & t.branchId.equals(branchId)))
        .get();
    return rows.isEmpty ? null : rows.first;
  }

  Future<void> upsertWatermark({
    required String tableName,
    required DateTime watermark,
    required String branchId,
  }) async {
    await db.into(db.syncStateTable).insertOnConflictUpdate(
      SyncStateTableCompanion.insert(
        syncTable: tableName,
        lastWatermark: watermark,
        lastSyncAt: DateTime.now(),
        branchId: branchId,
      ),
    );
  }

  Future<int> getTableCount(String tableName) async {
    try {
      final actualTable = _resolveSqliteTableName(tableName);
      final result = await db.customSelect(
        'SELECT COUNT(*) as c FROM $actualTable',
      ).getSingle();
      return result.read<int>('c');
    } catch (e) {
      return 0;
    }
  }

  String _resolveSqliteTableName(String name) {
    switch (name) {
      case 'branches': return 'branches_table';
      case 'users': return 'users_table';
      case 'permissions': return 'permissions_table';
      case 'customers': return 'customers_table';
      case 'suppliers': return 'suppliers_table';
      case 'customer_groups': return 'customer_groups_table';
      case 'medicines': return 'medicines_table';
      case 'medicine_units': return 'medicine_units_table';
      case 'item_batches': return 'item_batches_table';
      case 'inventory': return 'inventory_table';
      case 'stock_transfers': return 'stock_transfers_table';
      case 'sales': return 'sales_table';
      case 'purchases': return 'purchases_table';
      case 'returns': return 'returns_table';
      case 'quotes': return 'quotes_table';
      case 'cashier_shifts': return 'cashier_shifts_table';
      case 'customer_ledgers': return 'customer_ledgers_table';
      case 'supplier_ledgers': return 'supplier_ledgers_table';
      case 'supplier_customers': return 'supplier_customers_table';
      default:
        return name.endsWith('_table') ? name : '${name}_table';
    }
  }
}

