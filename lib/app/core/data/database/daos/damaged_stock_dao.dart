import 'package:drift/drift.dart';
import '../database.dart';

class DamagedStockDao {
  final AppDatabase db;
  DamagedStockDao(this.db);

  Future<List<DamagedStockTableData>> getAll() =>
      db.select(db.damagedStockTable).get();

  Future<List<DamagedStockTableData>> getByBranch(String branchId) =>
      (db.select(db.damagedStockTable)
            ..where((t) => t.branchId.equals(branchId))
            ..orderBy([(t) => OrderingTerm.desc(t.recordedAt)]))
          .get();

  Future<DamagedStockTableData?> getById(String id) =>
      (db.select(db.damagedStockTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<void> upsert(DamagedStockTableCompanion entry) async {
    await db.into(db.damagedStockTable).insertOnConflictUpdate(entry);
  }

  Future<void> upsertBatch(List<DamagedStockTableCompanion> entries) async {
    await db.batch((batch) {
      for (final entry in entries) {
        batch.insert(db.damagedStockTable, entry,
            mode: InsertMode.insertOrReplace);
      }
    });
  }

  Future<void> delete(String id) async {
    await (db.delete(db.damagedStockTable)..where((t) => t.id.equals(id))).go();
  }
}
