import 'package:drift/drift.dart';
import '../database.dart';

class PermissionsDao {
  final AppDatabase db;
  PermissionsDao(this.db);

  Future<List<PermissionsTableData>> getAll() =>
      db.select(db.permissionsTable).get();

  Future<List<PermissionsTableData>> getByUser(String userId) =>
      (db.select(db.permissionsTable)
            ..where((t) => t.userId.equals(userId) & t.isDeleted.not()))
          .get();

  Future<PermissionsTableData?> getById(String id) =>
      (db.select(db.permissionsTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<void> upsert(PermissionsTableCompanion entry) async {
    await db.into(db.permissionsTable).insertOnConflictUpdate(entry);
  }

  Future<void> upsertBatch(List<PermissionsTableCompanion> entries) async {
    await db.batch((batch) {
      for (final entry in entries) {
        batch.insert(db.permissionsTable, entry,
            mode: InsertMode.insertOrReplace);
      }
    });
  }

  Future<void> softDelete(String id) async {
    await (db.update(db.permissionsTable)..where((t) => t.id.equals(id))).write(
      PermissionsTableCompanion(
        isDeleted: const Value(true),
        lastModified: Value(DateTime.now()),
      ),
    );
  }

  Future<int> count() => db.select(db.permissionsTable).get().then((r) => r.length);
}
