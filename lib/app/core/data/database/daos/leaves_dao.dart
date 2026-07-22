import 'package:drift/drift.dart';
import '../database.dart';

class LeavesDao {
  final AppDatabase db;
  LeavesDao(this.db);

  Future<List<LeavesTableData>> getAll() =>
      db.select(db.leavesTable).get();

  Future<List<LeavesTableData>> getByEmployee(String employeeId) =>
      (db.select(db.leavesTable)
            ..where((t) =>
                t.employeeId.equals(employeeId) & t.isDeleted.not())
            ..orderBy([(t) => OrderingTerm.desc(t.startDate)]))
          .get();

  Future<List<LeavesTableData>> getByStatus(String status) =>
      (db.select(db.leavesTable)
            ..where((t) => t.status.equals(status) & t.isDeleted.not())
            ..orderBy([(t) => OrderingTerm.desc(t.startDate)]))
          .get();

  Future<LeavesTableData?> getById(String id) =>
      (db.select(db.leavesTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<void> upsert(LeavesTableCompanion entry) async {
    await db.into(db.leavesTable).insertOnConflictUpdate(entry);
  }

  Future<void> upsertBatch(List<LeavesTableCompanion> entries) async {
    await db.batch((batch) {
      for (final entry in entries) {
        batch.insert(db.leavesTable, entry,
            mode: InsertMode.insertOrReplace);
      }
    });
  }

  Future<void> softDelete(String id) async {
    await (db.update(db.leavesTable)..where((t) => t.id.equals(id))).write(
      LeavesTableCompanion(
        isDeleted: const Value(true),
        lastModified: Value(DateTime.now()),
      ),
    );
  }
}
