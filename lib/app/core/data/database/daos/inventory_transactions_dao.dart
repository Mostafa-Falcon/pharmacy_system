import 'package:drift/drift.dart';
import '../database.dart';

class InventoryTransactionsDao {
  final AppDatabase db;
  InventoryTransactionsDao(this.db);

  Future<List<InventoryTransactionsTableData>> getAll() =>
      db.select(db.inventoryTransactionsTable).get();

  Future<List<InventoryTransactionsTableData>> getByBranch(
          String branchId) =>
      (db.select(db.inventoryTransactionsTable)
            ..where((t) =>
                t.branchId.equals(branchId) & t.isDeleted.not())
            ..orderBy([(t) => OrderingTerm.desc(t.occurredAt)]))
          .get();

  Future<List<InventoryTransactionsTableData>> getByMedicine(
          String medicineId) =>
      (db.select(db.inventoryTransactionsTable)
            ..where((t) => t.medicineId.equals(medicineId))
            ..orderBy([(t) => OrderingTerm.desc(t.occurredAt)]))
          .get();

  Future<InventoryTransactionsTableData?> getById(String id) =>
      (db.select(db.inventoryTransactionsTable)
            ..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<void> upsert(InventoryTransactionsTableCompanion entry) async {
    await db.into(db.inventoryTransactionsTable).insertOnConflictUpdate(entry);
  }

  Future<void> upsertBatch(
      List<InventoryTransactionsTableCompanion> entries) async {
    await db.batch((batch) {
      for (final entry in entries) {
        batch.insert(db.inventoryTransactionsTable, entry,
            mode: InsertMode.insertOrReplace);
      }
    });
  }

  Future<void> softDelete(String id) async {
    await (db.update(db.inventoryTransactionsTable)
          ..where((t) => t.id.equals(id)))
        .write(InventoryTransactionsTableCompanion(
            isDeleted: const Value(true)));
  }
}
