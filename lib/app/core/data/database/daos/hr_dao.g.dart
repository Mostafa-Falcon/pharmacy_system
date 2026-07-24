// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hr_dao.dart';

// ignore_for_file: type=lint
mixin _$HrDaoMixin on DatabaseAccessor<AppDatabase> {
  $AttendanceTableTable get attendanceTable => attachedDatabase.attendanceTable;
  $PayrollTableTable get payrollTable => attachedDatabase.payrollTable;
  $EmployeeMessagesTableTable get employeeMessagesTable =>
      attachedDatabase.employeeMessagesTable;
  HrDaoManager get managers => HrDaoManager(this);
}

class HrDaoManager {
  final _$HrDaoMixin _db;
  HrDaoManager(this._db);
  $$AttendanceTableTableTableManager get attendanceTable =>
      $$AttendanceTableTableTableManager(
        _db.attachedDatabase,
        _db.attendanceTable,
      );
  $$PayrollTableTableTableManager get payrollTable =>
      $$PayrollTableTableTableManager(_db.attachedDatabase, _db.payrollTable);
  $$EmployeeMessagesTableTableTableManager get employeeMessagesTable =>
      $$EmployeeMessagesTableTableTableManager(
        _db.attachedDatabase,
        _db.employeeMessagesTable,
      );
}
