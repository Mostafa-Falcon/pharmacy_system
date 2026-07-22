import 'package:drift/drift.dart';
import '../database.dart';

class AttendanceDao {
  final AppDatabase db;
  AttendanceDao(this.db);

  Future<List<AttendanceTableData>> getAll() =>
      db.select(db.attendanceTable).get();

  Future<List<AttendanceTableData>> getByEmployee(String employeeId) =>
      (db.select(db.attendanceTable)
            ..where((t) =>
                t.employeeId.equals(employeeId) & t.isDeleted.not())
            ..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .get();

  Future<List<AttendanceTableData>> getByDateRange(
          DateTime start, DateTime end) =>
      (db.select(db.attendanceTable)
            ..where((t) =>
                t.date.isBetweenValues(start, end) & t.isDeleted.not())
            ..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .get();

  Future<AttendanceTableData?> getById(String id) =>
      (db.select(db.attendanceTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<void> upsert(AttendanceTableCompanion entry) async {
    await db.into(db.attendanceTable).insertOnConflictUpdate(entry);
  }

  Future<void> upsertBatch(List<AttendanceTableCompanion> entries) async {
    await db.batch((batch) {
      for (final entry in entries) {
        batch.insert(db.attendanceTable, entry,
            mode: InsertMode.insertOrReplace);
      }
    });
  }

  Future<void> softDelete(String id) async {
    await (db.update(db.attendanceTable)..where((t) => t.id.equals(id)))
        .write(AttendanceTableCompanion(isDeleted: const Value(true)));
  }
}
