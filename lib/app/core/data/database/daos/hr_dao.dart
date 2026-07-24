import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/hr_tables.dart';

part 'hr_dao.g.dart';

/// 🕒 كائن الاستعلامات والتنفيذ المباشر لموديول الموارد البشرية والرواتب والبصمة
@DriftAccessor(tables: [
  AttendanceTable,
  PayrollTable,
  EmployeeMessagesTable,
])
class HrDao extends DatabaseAccessor<AppDatabase> with _$HrDaoMixin {
  HrDao(super.db);

  // ─── 1. الحضور والانصراف والبصمة ───
  Future<List<AttendanceTableData>> getAttendanceByDate(DateTime date) =>
      (select(attendanceTable)..where((t) => t.date.equals(date))).get();

  Future<AttendanceTableData?> getEmployeeAttendance(String employeeId, DateTime date) =>
      (select(attendanceTable)
            ..where((t) => t.employeeId.equals(employeeId) & t.date.equals(date)))
          .getSingleOrNull();

  Future<void> upsertAttendance(AttendanceTableCompanion record) async {
    await into(attendanceTable).insertOnConflictUpdate(record);
  }

  // ─── 2. الرواتب الشهرية ومسير الرواتب ───
  Future<List<PayrollTableData>> getPayrollByMonth(String monthYear) =>
      (select(payrollTable)..where((t) => t.period.equals(monthYear))).get();

  Future<void> upsertPayroll(PayrollTableCompanion record) async {
    await into(payrollTable).insertOnConflictUpdate(record);
  }

  // ─── 3. رسائل الموظفين ───
  Future<List<EmployeeMessagesTableData>> getMessagesForEmployee(String employeeId) =>
      (select(employeeMessagesTable)
            ..where((t) => t.isBroadcast.equals(true) | t.recipientEmployeeIds.contains(employeeId))
            ..orderBy([(t) => OrderingTerm.desc(t.sentAt)]))
          .get();

  Future<void> insertMessage(EmployeeMessagesTableCompanion message) async {
    await into(employeeMessagesTable).insertOnConflictUpdate(message);
  }
}


