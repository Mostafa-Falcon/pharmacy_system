import 'package:drift/drift.dart';
import '../database.dart';

class CustomerLedgersDao {
  final AppDatabase db;
  CustomerLedgersDao(this.db);

  Future<List<CustomerLedgersTableData>> getAll() =>
      db.select(db.customerLedgersTable).get();

  Future<List<CustomerLedgersTableData>> getByBranch(String branchId) =>
      (db.select(db.customerLedgersTable)
            ..where((t) => t.branchId.equals(branchId) & t.isDeleted.not()))
          .get();

  Future<List<CustomerLedgersTableData>> getByCustomer(String customerId) =>
      (db.select(db.customerLedgersTable)
            ..where((t) => t.customerId.equals(customerId) & t.isDeleted.not())
            ..orderBy([(t) => OrderingTerm.desc(t.entryDate)]))
          .get();

  Future<CustomerLedgersTableData?> getById(String id) =>
      (db.select(db.customerLedgersTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<double> getBalance(String customerId) async {
    final rows = await (db.select(db.customerLedgersTable)
          ..where((t) => t.customerId.equals(customerId) & t.isDeleted.not()))
        .get();
    return rows.fold<double>(0.0, (sum, r) => sum + r.debit - r.credit);
  }

  Future<void> upsert(CustomerLedgersTableCompanion entry) async {
    await db.into(db.customerLedgersTable).insertOnConflictUpdate(entry);
  }

  Future<void> softDelete(String id) async {
    await (db.update(db.customerLedgersTable)
          ..where((t) => t.id.equals(id)))
        .write(CustomerLedgersTableCompanion(
          isDeleted: const Value(true),
          lastModified: Value(DateTime.now()),
        ));
  }

  Future<int> count() => db.select(db.customerLedgersTable).get().then((r) => r.length);
}
