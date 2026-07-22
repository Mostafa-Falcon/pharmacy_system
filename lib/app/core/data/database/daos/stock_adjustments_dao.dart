import 'package:drift/drift.dart';
import '../database.dart';

class StockAdjustmentsDao {
  final AppDatabase db;
  StockAdjustmentsDao(this.db);

  Future<List<StockAdjustmentsTableData>> getAll() =>
      db.select(db.stockAdjustmentsTable).get();

  Future<List<StockAdjustmentsTableData>> getByBranch(String branchId) =>
      (db.select(db.stockAdjustmentsTable)
            ..where((t) =>
                t.branchId.equals(branchId) & t.isDeleted.not())
            ..orderBy([(t) => OrderingTerm.desc(t.adjustmentDate)]))
          .get();

  Future<StockAdjustmentsTableData?> getById(String id) =>
      (db.select(db.stockAdjustmentsTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<void> upsert(StockAdjustmentsTableCompanion entry) async {
    await db.into(db.stockAdjustmentsTable).insertOnConflictUpdate(entry);
  }

  Future<void> upsertBatch(
      List<StockAdjustmentsTableCompanion> entries) async {
    await db.batch((batch) {
      for (final entry in entries) {
        batch.insert(db.stockAdjustmentsTable, entry,
            mode: InsertMode.insertOrReplace);
      }
    });
  }

  Future<void> softDelete(String id) async {
    await (db.update(db.stockAdjustmentsTable)
          ..where((t) => t.id.equals(id)))
        .write(StockAdjustmentsTableCompanion(isDeleted: const Value(true)));
  }
}
