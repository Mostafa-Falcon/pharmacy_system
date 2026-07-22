import 'package:drift/drift.dart';
import '../database.dart';

class CashierShiftsDao {
  final AppDatabase db;
  CashierShiftsDao(this.db);

  Future<List<CashierShiftsTableData>> getAll() =>
      db.select(db.cashierShiftsTable).get();

  Future<List<CashierShiftsTableData>> getByBranch(String branchId) =>
      (db.select(db.cashierShiftsTable)
            ..where((t) => t.branchId.equals(branchId) & t.isDeleted.not())
            ..orderBy([(t) => OrderingTerm.desc(t.openedAt)]))
          .get();

  Future<CashierShiftsTableData?> getById(String id) =>
      (db.select(db.cashierShiftsTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<CashierShiftsTableData?> getActiveByDevice(String deviceId) =>
      (db.select(db.cashierShiftsTable)
            ..where((t) =>
                t.deviceId.equals(deviceId) &
                t.status.equals('open') &
                t.isDeleted.not())
            ..limit(1))
          .getSingleOrNull();

  Future<void> upsert(CashierShiftsTableCompanion entry) async {
    await db.into(db.cashierShiftsTable).insertOnConflictUpdate(entry);
  }

  Future<void> upsertBatch(List<CashierShiftsTableCompanion> entries) async {
    await db.batch((batch) {
      for (final entry in entries) {
        batch.insert(db.cashierShiftsTable, entry,
            mode: InsertMode.insertOrReplace);
      }
    });
  }

  Future<void> softDelete(String id) async {
    await (db.update(db.cashierShiftsTable)
          ..where((t) => t.id.equals(id)))
        .write(CashierShiftsTableCompanion(
          isDeleted: const Value(true),
          lastModified: Value(DateTime.now()),
        ));
  }

  Future<int> count() => db.select(db.cashierShiftsTable).get().then((r) => r.length);
}
