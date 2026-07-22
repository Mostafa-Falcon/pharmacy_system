import 'package:drift/drift.dart';
import '../database.dart';

class StocktakingItemsDao {
  final AppDatabase db;
  StocktakingItemsDao(this.db);

  Future<List<StocktakingItemsTableData>> getAll() =>
      db.select(db.stocktakingItemsTable).get();

  Future<List<StocktakingItemsTableData>> getByStocktaking(
          String stocktakingId) =>
      (db.select(db.stocktakingItemsTable)
            ..where((t) =>
                t.stocktakingId.equals(stocktakingId) & t.isDeleted.not()))
          .get();

  Future<StocktakingItemsTableData?> getById(String id) =>
      (db.select(db.stocktakingItemsTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<void> upsert(StocktakingItemsTableCompanion entry) async {
    await db.into(db.stocktakingItemsTable).insertOnConflictUpdate(entry);
  }

  Future<void> upsertBatch(
      List<StocktakingItemsTableCompanion> entries) async {
    await db.batch((batch) {
      for (final entry in entries) {
        batch.insert(db.stocktakingItemsTable, entry,
            mode: InsertMode.insertOrReplace);
      }
    });
  }

  Future<void> softDelete(String id) async {
    await (db.update(db.stocktakingItemsTable)
          ..where((t) => t.id.equals(id)))
        .write(StocktakingItemsTableCompanion(
          isDeleted: const Value(true),
          lastModified: Value(DateTime.now()),
        ));
  }
}
