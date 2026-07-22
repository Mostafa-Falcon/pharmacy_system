import 'package:drift/drift.dart';
import '../database.dart';

class InventoryDao {
  final AppDatabase db;
  InventoryDao(this.db);

  Future<List<InventoryTableData>> getAll() =>
      db.select(db.inventoryTable).get();

  Future<List<InventoryTableData>> getByBranch(String branchId) =>
      (db.select(db.inventoryTable)
            ..where((t) => t.branchId.equals(branchId)))
          .get();

  Future<InventoryTableData?> getById(String id) =>
      (db.select(db.inventoryTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<InventoryTableData?> getByMedicineAndBranch(
    String medicineId,
    String branchId,
  ) =>
      (db.select(db.inventoryTable)
            ..where((t) =>
                t.medicineId.equals(medicineId) & t.branchId.equals(branchId)))
          .getSingleOrNull();

  Future<void> upsert(InventoryTableCompanion entry) async {
    await db.into(db.inventoryTable).insertOnConflictUpdate(entry);
  }

  Future<void> delete(String id) async {
    await (db.delete(db.inventoryTable)..where((t) => t.id.equals(id))).go();
  }

  Future<int> count() => db.select(db.inventoryTable).get().then((r) => r.length);
}
