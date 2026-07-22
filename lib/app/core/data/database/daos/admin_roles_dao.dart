import 'package:drift/drift.dart';
import '../database.dart';

class AdminRolesDao {
  final AppDatabase db;
  AdminRolesDao(this.db);

  Future<List<AdminRolesTableData>> getAll() =>
      db.select(db.adminRolesTable).get();

  Future<List<AdminRolesTableData>> getByBranch(String branchId) =>
      (db.select(db.adminRolesTable)
            ..where((t) => t.branchId.equals(branchId) & t.isDeleted.not()))
          .get();

  Future<AdminRolesTableData?> getById(String id) =>
      (db.select(db.adminRolesTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<void> upsert(AdminRolesTableCompanion entry) async {
    await db.into(db.adminRolesTable).insertOnConflictUpdate(entry);
  }

  Future<void> upsertBatch(List<AdminRolesTableCompanion> entries) async {
    await db.batch((batch) {
      for (final entry in entries) {
        batch.insert(db.adminRolesTable, entry,
            mode: InsertMode.insertOrReplace);
      }
    });
  }

  Future<void> softDelete(String id) async {
    await (db.update(db.adminRolesTable)..where((t) => t.id.equals(id))).write(
      AdminRolesTableCompanion(
        isDeleted: const Value(true),
        lastModified: Value(DateTime.now()),
      ),
    );
  }
}
