import 'package:drift/drift.dart';
import '../database.dart';

class StocktakingDao {
  final AppDatabase db;
  StocktakingDao(this.db);

  Future<List<StocktakingTableData>> getAll() =>
      db.select(db.stocktakingTable).get();

  Future<List<StocktakingTableData>> getByBranch(String branchId) =>
      (db.select(db.stocktakingTable)
            ..where((t) => t.branchId.equals(branchId) & t.isDeleted.not())
            ..orderBy([(t) => OrderingTerm.desc(t.startDate)]))
          .get();

  Future<StocktakingTableData?> getById(String id) =>
      (db.select(db.stocktakingTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<void> upsert(StocktakingTableCompanion entry) async {
    await db.into(db.stocktakingTable).insertOnConflictUpdate(entry);
  }

  Future<void> upsertBatch(List<StocktakingTableCompanion> entries) async {
    await db.batch((batch) {
      for (final entry in entries) {
        batch.insert(db.stocktakingTable, entry,
            mode: InsertMode.insertOrReplace);
      }
    });
  }

  Future<void> softDelete(String id) async {
    await (db.update(db.stocktakingTable)..where((t) => t.id.equals(id))).write(
      StocktakingTableCompanion(
        isDeleted: const Value(true),
        lastModified: Value(DateTime.now()),
      ),
    );
  }
}
