import 'package:drift/drift.dart';
import '../database.dart';

class UsersDao {
  final AppDatabase db;
  UsersDao(this.db);

  Future<List<UsersTableData>> getAll() => db.select(db.usersTable).get();

  Future<List<UsersTableData>> getByBranch(String branchId) =>
      (db.select(db.usersTable)
            ..where((t) => t.assignedBranchId.equals(branchId) & t.isDeleted.not()))
          .get();

  Future<UsersTableData?> getById(String id) =>
      (db.select(db.usersTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<UsersTableData?> getByEmail(String email) =>
      (db.select(db.usersTable)..where((t) => t.email.equals(email)))
          .getSingleOrNull();

  Future<void> upsert(UsersTableCompanion entry) async {
    await db.into(db.usersTable).insertOnConflictUpdate(entry);
  }

  Future<void> upsertBatch(List<UsersTableCompanion> entries) async {
    await db.batch((batch) {
      for (final entry in entries) {
        batch.insert(db.usersTable, entry, mode: InsertMode.insertOrReplace);
      }
    });
  }

  Future<void> softDelete(String id) async {
    await (db.update(db.usersTable)..where((t) => t.id.equals(id))).write(
      UsersTableCompanion(
        isDeleted: const Value(true),
        lastModified: Value(DateTime.now()),
      ),
    );
  }

  Future<int> count() => db.select(db.usersTable).get().then((r) => r.length);
}
