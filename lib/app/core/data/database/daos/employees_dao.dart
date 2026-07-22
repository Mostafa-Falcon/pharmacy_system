import 'package:drift/drift.dart';
import '../database.dart';

class EmployeesDao {
  final AppDatabase db;
  EmployeesDao(this.db);

  Future<List<EmployeesTableData>> getAll() =>
      db.select(db.employeesTable).get();

  Future<List<EmployeesTableData>> getByBranch(String branchId) =>
      (db.select(db.employeesTable)
            ..where((t) => t.branchId.equals(branchId) & t.isDeleted.not()))
          .get();

  Future<List<EmployeesTableData>> getByDepartment(String departmentId) =>
      (db.select(db.employeesTable)
            ..where((t) =>
                t.departmentId.equals(departmentId) & t.isDeleted.not()))
          .get();

  Future<EmployeesTableData?> getById(String id) =>
      (db.select(db.employeesTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<void> upsert(EmployeesTableCompanion entry) async {
    await db.into(db.employeesTable).insertOnConflictUpdate(entry);
  }

  Future<void> upsertBatch(List<EmployeesTableCompanion> entries) async {
    await db.batch((batch) {
      for (final entry in entries) {
        batch.insert(db.employeesTable, entry,
            mode: InsertMode.insertOrReplace);
      }
    });
  }

  Future<void> softDelete(String id) async {
    await (db.update(db.employeesTable)..where((t) => t.id.equals(id))).write(
      EmployeesTableCompanion(
        isDeleted: const Value(true),
        lastModified: Value(DateTime.now()),
      ),
    );
  }
}
