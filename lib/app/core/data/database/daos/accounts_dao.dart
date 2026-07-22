import 'package:drift/drift.dart';
import '../database.dart';

class AccountsDao {
  final AppDatabase db;
  AccountsDao(this.db);

  Future<List<AccountsTableData>> getAll() =>
      db.select(db.accountsTable).get();

  Future<List<AccountsTableData>> getByBranch(String branchId) =>
      (db.select(db.accountsTable)
            ..where((t) => t.branchId.equals(branchId) & t.isDeleted.not()))
          .get();

  Future<AccountsTableData?> getById(String id) =>
      (db.select(db.accountsTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<void> upsert(AccountsTableCompanion entry) async {
    await db.into(db.accountsTable).insertOnConflictUpdate(entry);
  }

  Future<void> upsertBatch(List<AccountsTableCompanion> entries) async {
    await db.batch((batch) {
      for (final entry in entries) {
        batch.insert(db.accountsTable, entry,
            mode: InsertMode.insertOrReplace);
      }
    });
  }

  Future<void> softDelete(String id) async {
    await (db.update(db.accountsTable)..where((t) => t.id.equals(id))).write(
      AccountsTableCompanion(
        isDeleted: const Value(true),
        lastModified: Value(DateTime.now()),
      ),
    );
  }
}
