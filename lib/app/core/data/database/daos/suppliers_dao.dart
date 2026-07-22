import 'package:drift/drift.dart';
import '../database.dart';

class SuppliersDao {
  final AppDatabase db;
  SuppliersDao(this.db);

  Future<List<SuppliersTableData>> getAll() =>
      db.select(db.suppliersTable).get();

  Future<SuppliersTableData?> getById(String id) =>
      (db.select(db.suppliersTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<List<SuppliersTableData>> search(String query) {
    final like = '%$query%';
    return (db.select(db.suppliersTable)
          ..where((t) =>
              t.isDeleted.not() &
              (t.name.like(like) | t.phone.like(like) | t.companyName.like(like)))
          ..limit(20))
        .get();
  }

  Future<void> upsert(SuppliersTableCompanion entry) async {
    await db.into(db.suppliersTable).insertOnConflictUpdate(entry);
  }

  Future<void> upsertBatch(List<SuppliersTableCompanion> entries) async {
    await db.batch((batch) {
      for (final entry in entries) {
        batch.insert(db.suppliersTable, entry,
            mode: InsertMode.insertOrReplace);
      }
    });
  }

  Future<void> softDelete(String id) async {
    await (db.update(db.suppliersTable)..where((t) => t.id.equals(id))).write(
      SuppliersTableCompanion(
        isDeleted: const Value(true),
        lastModified: Value(DateTime.now()),
      ),
    );
  }

  Future<void> restore(String id) async {
    await (db.update(db.suppliersTable)..where((t) => t.id.equals(id))).write(
      SuppliersTableCompanion(
        isDeleted: const Value(false),
        lastModified: Value(DateTime.now()),
      ),
    );
  }

  Future<void> hardDelete(String id) async {
    await (db.delete(db.suppliersTable)..where((t) => t.id.equals(id))).go();
  }

  Future<int> count() => db.select(db.suppliersTable).get().then((r) => r.length);
}
