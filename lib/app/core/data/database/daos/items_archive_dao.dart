import 'package:drift/drift.dart';
import '../database.dart';

class ItemsArchiveDao {
  final AppDatabase db;
  ItemsArchiveDao(this.db);

  Future<List<ItemsArchiveTableData>> getAll() =>
      db.select(db.itemsArchiveTable).get();

  Future<List<ItemsArchiveTableData>> getByBranch(String branchId) =>
      (db.select(db.itemsArchiveTable)
            ..where((t) =>
                t.branchId.equals(branchId) & t.isDeleted.not())
            ..orderBy([(t) => OrderingTerm.desc(t.archivedAt)]))
          .get();

  Future<List<ItemsArchiveTableData>> getByMedicine(String medicineId) =>
      (db.select(db.itemsArchiveTable)
            ..where((t) => t.medicineId.equals(medicineId))
            ..orderBy([(t) => OrderingTerm.desc(t.archivedAt)]))
          .get();

  Future<ItemsArchiveTableData?> getById(String id) =>
      (db.select(db.itemsArchiveTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<void> upsert(ItemsArchiveTableCompanion entry) async {
    await db.into(db.itemsArchiveTable).insertOnConflictUpdate(entry);
  }

  Future<void> upsertBatch(List<ItemsArchiveTableCompanion> entries) async {
    await db.batch((batch) {
      for (final entry in entries) {
        batch.insert(db.itemsArchiveTable, entry,
            mode: InsertMode.insertOrReplace);
      }
    });
  }

  Future<void> softDelete(String id) async {
    await (db.update(db.itemsArchiveTable)
          ..where((t) => t.id.equals(id)))
        .write(ItemsArchiveTableCompanion(isDeleted: const Value(true)));
  }
}
