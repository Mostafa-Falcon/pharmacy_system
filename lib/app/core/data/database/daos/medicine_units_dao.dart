import 'package:drift/drift.dart';
import '../database.dart';

class MedicineUnitsDao {
  final AppDatabase db;
  MedicineUnitsDao(this.db);

  Future<List<MedicineUnitsTableData>> getAll() =>
      db.select(db.medicineUnitsTable).get();

  Future<List<MedicineUnitsTableData>> getByMedicine(String medicineId) =>
      (db.select(db.medicineUnitsTable)
            ..where((t) => t.medicineId.equals(medicineId)))
          .get();

  Future<MedicineUnitsTableData?> getById(String id) =>
      (db.select(db.medicineUnitsTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<void> upsert(MedicineUnitsTableCompanion entry) async {
    await db.into(db.medicineUnitsTable).insertOnConflictUpdate(entry);
  }

  Future<void> upsertBatch(List<MedicineUnitsTableCompanion> entries) async {
    await db.batch((batch) {
      for (final entry in entries) {
        batch.insert(db.medicineUnitsTable, entry,
            mode: InsertMode.insertOrReplace);
      }
    });
  }

  Future<void> delete(String id) async {
    await (db.delete(db.medicineUnitsTable)..where((t) => t.id.equals(id))).go();
  }
}
