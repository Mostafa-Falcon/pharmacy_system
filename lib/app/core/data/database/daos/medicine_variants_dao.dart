import 'package:drift/drift.dart';
import '../database.dart';

class MedicineVariantsDao {
  final AppDatabase db;
  MedicineVariantsDao(this.db);

  Future<List<MedicineVariantsTableData>> getByMedicine(String medicineId) =>
      (db.select(db.medicineVariantsTable)
            ..where((t) => t.medicineId.equals(medicineId)))
          .get();

  Future<MedicineVariantsTableData?> getById(String id) =>
      (db.select(db.medicineVariantsTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<void> upsert(MedicineVariantsTableCompanion entry) async {
    await db.into(db.medicineVariantsTable).insertOnConflictUpdate(entry);
  }

  Future<void> upsertBatch(
      List<MedicineVariantsTableCompanion> entries) async {
    await db.batch((batch) {
      for (final entry in entries) {
        batch.insert(db.medicineVariantsTable, entry,
            mode: InsertMode.insertOrReplace);
      }
    });
  }

  Future<void> delete(String id) async {
    await (db.delete(db.medicineVariantsTable)..where((t) => t.id.equals(id)))
        .go();
  }
}
