import 'package:drift/drift.dart';
import '../database.dart';

class BranchesDao {
  final AppDatabase db;
  BranchesDao(this.db);

  Future<List<BranchesTableData>> getAll() => db.select(db.branchesTable).get();

  Future<BranchesTableData?> getById(String id) =>
      (db.select(db.branchesTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<void> upsert(BranchesTableCompanion entry) async {
    await db.into(db.branchesTable).insertOnConflictUpdate(entry);
  }

  Future<void> upsertBatch(List<BranchesTableCompanion> entries) async {
    await db.batch((batch) {
      for (final entry in entries) {
        batch.insert(db.branchesTable, entry, mode: InsertMode.insertOrReplace);
      }
    });
  }

  Future<void> softDelete(String id) async {
    await (db.update(db.branchesTable)..where((t) => t.id.equals(id))).write(
      BranchesTableCompanion(
        isDeleted: const Value(true),
        lastModified: Value(DateTime.now()),
      ),
    );
  }

  Future<int> count() => db.select(db.branchesTable).get().then((r) => r.length);
}
