import 'package:drift/drift.dart';
import '../database.dart';

class ItemBatchesDao {
  final AppDatabase db;
  ItemBatchesDao(this.db);

  Future<List<ItemBatchesTableData>> getAll() =>
      db.select(db.itemBatchesTable).get();

  Future<List<ItemBatchesTableData>> getByMedicine(String medicineId) =>
      (db.select(db.itemBatchesTable)
            ..where((t) => t.medicineId.equals(medicineId) & t.isDeleted.not()))
          .get();

  Future<ItemBatchesTableData?> getById(String id) =>
      (db.select(db.itemBatchesTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<void> upsert(ItemBatchesTableCompanion entry) async {
    await db.into(db.itemBatchesTable).insertOnConflictUpdate(entry);
  }

  Future<void> upsertBatch(List<ItemBatchesTableCompanion> entries) async {
    await db.batch((batch) {
      for (final entry in entries) {
        batch.insert(db.itemBatchesTable, entry,
            mode: InsertMode.insertOrReplace);
      }
    });
  }

  Future<void> softDelete(String id) async {
    await (db.update(db.itemBatchesTable)..where((t) => t.id.equals(id))).write(
      ItemBatchesTableCompanion(
        isDeleted: const Value(true),
      ),
    );
  }
}
