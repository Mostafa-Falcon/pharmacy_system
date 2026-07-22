import 'package:drift/drift.dart';
import '../database.dart';

class SupplierLedgersDao {
  final AppDatabase db;
  SupplierLedgersDao(this.db);

  Future<List<SupplierLedgersTableData>> getAll() =>
      db.select(db.supplierLedgersTable).get();

  Future<List<SupplierLedgersTableData>> getByBranch(String branchId) =>
      (db.select(db.supplierLedgersTable)
            ..where((t) => t.branchId.equals(branchId) & t.isDeleted.not()))
          .get();

  Future<List<SupplierLedgersTableData>> getBySupplier(String supplierId) =>
      (db.select(db.supplierLedgersTable)
            ..where((t) => t.supplierId.equals(supplierId) & t.isDeleted.not())
            ..orderBy([(t) => OrderingTerm.desc(t.entryDate)]))
          .get();

  Future<SupplierLedgersTableData?> getById(String id) =>
      (db.select(db.supplierLedgersTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<double> getBalance(String supplierId) async {
    final rows = await (db.select(db.supplierLedgersTable)
          ..where((t) => t.supplierId.equals(supplierId) & t.isDeleted.not()))
        .get();
    return rows.fold<double>(0.0, (sum, r) => sum + r.debit - r.credit);
  }

  Future<void> upsert(SupplierLedgersTableCompanion entry) async {
    await db.into(db.supplierLedgersTable).insertOnConflictUpdate(entry);
  }

  Future<void> softDelete(String id) async {
    await (db.update(db.supplierLedgersTable)
          ..where((t) => t.id.equals(id)))
        .write(SupplierLedgersTableCompanion(
          isDeleted: const Value(true),
          lastModified: Value(DateTime.now()),
        ));
  }

  Future<int> count() => db.select(db.supplierLedgersTable).get().then((r) => r.length);
}
