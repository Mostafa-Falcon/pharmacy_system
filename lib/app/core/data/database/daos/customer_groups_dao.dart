import 'package:drift/drift.dart';
import '../database.dart';

class CustomerGroupsDao {
  final AppDatabase db;
  CustomerGroupsDao(this.db);

  Future<List<CustomerGroupsTableData>> getAll() =>
      db.select(db.customerGroupsTable).get();

  Future<CustomerGroupsTableData?> getById(String id) =>
      (db.select(db.customerGroupsTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<void> upsert(CustomerGroupsTableCompanion entry) async {
    await db.into(db.customerGroupsTable).insertOnConflictUpdate(entry);
  }

  Future<void> upsertBatch(List<CustomerGroupsTableCompanion> entries) async {
    await db.batch((batch) {
      for (final entry in entries) {
        batch.insert(db.customerGroupsTable, entry,
            mode: InsertMode.insertOrReplace);
      }
    });
  }

  Future<void> softDelete(String id) async {
    await (db.update(db.customerGroupsTable)
          ..where((t) => t.id.equals(id)))
        .write(CustomerGroupsTableCompanion(
          isDeleted: const Value(true),
          lastModified: Value(DateTime.now()),
        ));
  }

  Future<void> restore(String id) async {
    await (db.update(db.customerGroupsTable)
          ..where((t) => t.id.equals(id)))
        .write(CustomerGroupsTableCompanion(
          isDeleted: const Value(false),
          lastModified: Value(DateTime.now()),
        ));
  }

  Future<void> hardDelete(String id) async {
    await (db.delete(db.customerGroupsTable)..where((t) => t.id.equals(id))).go();
  }
}
