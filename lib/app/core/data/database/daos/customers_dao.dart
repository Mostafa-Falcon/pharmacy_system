import 'package:drift/drift.dart';
import '../database.dart';

class CustomersDao {
  final AppDatabase db;
  CustomersDao(this.db);

  Future<List<CustomersTableData>> getAll() =>
      db.select(db.customersTable).get();

  Future<CustomersTableData?> getById(String id) =>
      (db.select(db.customersTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<List<CustomersTableData>> search(String query) {
    final like = '%$query%';
    return (db.select(db.customersTable)
          ..where((t) =>
              t.isDeleted.not() &
              (t.name.like(like) | t.phone.like(like) | t.companyName.like(like)))
          ..limit(20))
        .get();
  }

  Future<void> upsert(CustomersTableCompanion entry) async {
    await db.into(db.customersTable).insertOnConflictUpdate(entry);
  }

  Future<void> upsertBatch(List<CustomersTableCompanion> entries) async {
    await db.batch((batch) {
      for (final entry in entries) {
        batch.insert(db.customersTable, entry,
            mode: InsertMode.insertOrReplace);
      }
    });
  }

  Future<void> softDelete(String id) async {
    await (db.update(db.customersTable)..where((t) => t.id.equals(id))).write(
      CustomersTableCompanion(
        isDeleted: const Value(true),
        lastModified: Value(DateTime.now()),
      ),
    );
  }

  Future<void> restore(String id) async {
    await (db.update(db.customersTable)..where((t) => t.id.equals(id))).write(
      CustomersTableCompanion(
        isDeleted: const Value(false),
        lastModified: Value(DateTime.now()),
      ),
    );
  }

  Future<void> hardDelete(String id) async {
    await (db.delete(db.customersTable)..where((t) => t.id.equals(id))).go();
  }

  Future<int> countByRep(String repId) =>
      (db.select(db.customersTable)
            ..where((t) => t.salesRepId.equals(repId) & t.isDeleted.not()))
          .get()
          .then((rows) => rows.length);

  Future<int> count() => db.select(db.customersTable).get().then((r) => r.length);
}
