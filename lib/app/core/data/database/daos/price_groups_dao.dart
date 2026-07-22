import 'package:drift/drift.dart';
import '../database.dart';

class PriceGroupsDao {
  final AppDatabase db;
  PriceGroupsDao(this.db);

  Future<List<PriceGroupsTableData>> getAll() =>
      db.select(db.priceGroupsTable).get();

  Future<PriceGroupsTableData?> getDefault() =>
      (db.select(db.priceGroupsTable)..where((t) => t.isDefault.equals(true)))
          .getSingleOrNull();

  Future<PriceGroupsTableData?> getById(String id) =>
      (db.select(db.priceGroupsTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<void> upsert(PriceGroupsTableCompanion entry) async {
    await db.into(db.priceGroupsTable).insertOnConflictUpdate(entry);
  }

  Future<void> upsertBatch(List<PriceGroupsTableCompanion> entries) async {
    await db.batch((batch) {
      for (final entry in entries) {
        batch.insert(db.priceGroupsTable, entry,
            mode: InsertMode.insertOrReplace);
      }
    });
  }

  Future<void> delete(String id) async {
    await (db.delete(db.priceGroupsTable)..where((t) => t.id.equals(id)))
        .go();
  }
}
