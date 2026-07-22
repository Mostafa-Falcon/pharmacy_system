import 'package:drift/drift.dart';
import '../database.dart';

class OpeningStockDao {
  final AppDatabase db;
  OpeningStockDao(this.db);

  Future<List<OpeningStockTableData>> getAll() =>
      db.select(db.openingStockTable).get();

  Future<List<OpeningStockTableData>> getByBranch(String branchId) =>
      (db.select(db.openingStockTable)
            ..where((t) => t.branchId.equals(branchId))
            ..orderBy([(t) => OrderingTerm.desc(t.recordedAt)]))
          .get();

  Future<OpeningStockTableData?> getById(String id) =>
      (db.select(db.openingStockTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<void> upsert(OpeningStockTableCompanion entry) async {
    await db.into(db.openingStockTable).insertOnConflictUpdate(entry);
  }

  Future<void> upsertBatch(List<OpeningStockTableCompanion> entries) async {
    await db.batch((batch) {
      for (final entry in entries) {
        batch.insert(db.openingStockTable, entry,
            mode: InsertMode.insertOrReplace);
      }
    });
  }

  Future<void> delete(String id) async {
    await (db.delete(db.openingStockTable)..where((t) => t.id.equals(id))).go();
  }
}
