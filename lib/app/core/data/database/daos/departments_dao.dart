import 'package:drift/drift.dart';
import '../database.dart';

class DepartmentsDao {
  final AppDatabase db;
  DepartmentsDao(this.db);

  Future<List<DepartmentsTableData>> getAll() =>
      db.select(db.departmentsTable).get();

  Future<List<DepartmentsTableData>> getByBranch(String branchId) =>
      (db.select(db.departmentsTable)
            ..where((t) => t.branchId.equals(branchId) & t.isDeleted.not()))
          .get();

  Future<DepartmentsTableData?> getById(String id) =>
      (db.select(db.departmentsTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<void> upsert(DepartmentsTableCompanion entry) async {
    await db.into(db.departmentsTable).insertOnConflictUpdate(entry);
  }

  Future<void> upsertBatch(List<DepartmentsTableCompanion> entries) async {
    await db.batch((batch) {
      for (final entry in entries) {
        batch.insert(db.departmentsTable, entry,
            mode: InsertMode.insertOrReplace);
      }
    });
  }

  Future<void> softDelete(String id) async {
    await (db.update(db.departmentsTable)..where((t) => t.id.equals(id)))
        .write(DepartmentsTableCompanion(isDeleted: const Value(true)));
  }
}
