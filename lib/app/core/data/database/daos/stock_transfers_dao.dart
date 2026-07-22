import 'package:drift/drift.dart';
import '../database.dart';

class StockTransfersDao {
  final AppDatabase db;
  StockTransfersDao(this.db);

  Future<List<StockTransfersTableData>> getAll() =>
      db.select(db.stockTransfersTable).get();

  Future<List<StockTransfersTableData>> getByBranch(String branchId) =>
      (db.select(db.stockTransfersTable)
            ..where((t) =>
                t.branchId.equals(branchId) & t.isDeleted.not())
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

  Future<StockTransfersTableData?> getById(String id) =>
      (db.select(db.stockTransfersTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<void> upsert(StockTransfersTableCompanion entry) async {
    await db.into(db.stockTransfersTable).insertOnConflictUpdate(entry);
  }

  Future<void> upsertBatch(List<StockTransfersTableCompanion> entries) async {
    await db.batch((batch) {
      for (final entry in entries) {
        batch.insert(db.stockTransfersTable, entry,
            mode: InsertMode.insertOrReplace);
      }
    });
  }

  Future<void> softDelete(String id) async {
    await (db.update(db.stockTransfersTable)..where((t) => t.id.equals(id)))
        .write(StockTransfersTableCompanion(isDeleted: const Value(true)));
  }
}
