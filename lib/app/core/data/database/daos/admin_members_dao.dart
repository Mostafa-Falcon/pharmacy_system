import 'package:drift/drift.dart';
import '../database.dart';

class AdminMembersDao {
  final AppDatabase db;
  AdminMembersDao(this.db);

  Future<List<AdminMembersTableData>> getAll() =>
      db.select(db.adminMembersTable).get();

  Future<List<AdminMembersTableData>> getByBranch(String branchId) =>
      (db.select(db.adminMembersTable)
            ..where((t) => t.branchId.equals(branchId) & t.isDeleted.not()))
          .get();

  Future<List<AdminMembersTableData>> getByUser(String userId) =>
      (db.select(db.adminMembersTable)
            ..where((t) => t.userId.equals(userId) & t.isDeleted.not()))
          .get();

  Future<AdminMembersTableData?> getById(String id) =>
      (db.select(db.adminMembersTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<void> upsert(AdminMembersTableCompanion entry) async {
    await db.into(db.adminMembersTable).insertOnConflictUpdate(entry);
  }

  Future<void> upsertBatch(List<AdminMembersTableCompanion> entries) async {
    await db.batch((batch) {
      for (final entry in entries) {
        batch.insert(db.adminMembersTable, entry,
            mode: InsertMode.insertOrReplace);
      }
    });
  }

  Future<void> softDelete(String id) async {
    await (db.update(db.adminMembersTable)
          ..where((t) => t.id.equals(id)))
        .write(AdminMembersTableCompanion(
          isDeleted: const Value(true),
          lastModified: Value(DateTime.now()),
        ));
  }
}
