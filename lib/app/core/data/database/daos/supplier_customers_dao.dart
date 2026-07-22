import 'package:drift/drift.dart';
import '../database.dart';

class SupplierCustomersDao {
  final AppDatabase db;
  SupplierCustomersDao(this.db);

  Future<List<SupplierCustomersTableData>> getAll() =>
      db.select(db.supplierCustomersTable).get();

  Future<SupplierCustomersTableData?> getById(String id) =>
      (db.select(db.supplierCustomersTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<void> upsert(SupplierCustomersTableCompanion entry) async {
    await db.into(db.supplierCustomersTable).insertOnConflictUpdate(entry);
  }

  Future<void> upsertBatch(
      List<SupplierCustomersTableCompanion> entries) async {
    await db.batch((batch) {
      for (final entry in entries) {
        batch.insert(db.supplierCustomersTable, entry,
            mode: InsertMode.insertOrReplace);
      }
    });
  }

  Future<void> softDelete(String id) async {
    await (db.update(db.supplierCustomersTable)
          ..where((t) => t.id.equals(id)))
        .write(SupplierCustomersTableCompanion(
          isDeleted: const Value(true),
          lastModified: Value(DateTime.now()),
        ));
  }

  Future<void> restore(String id) async {
    await (db.update(db.supplierCustomersTable)
          ..where((t) => t.id.equals(id)))
        .write(SupplierCustomersTableCompanion(
          isDeleted: const Value(false),
          lastModified: Value(DateTime.now()),
        ));
  }

  Future<void> hardDelete(String id) async {
    await (db.delete(db.supplierCustomersTable)..where((t) => t.id.equals(id))).go();
  }

  Future<int> count() => db.select(db.supplierCustomersTable).get().then((r) => r.length);
}
