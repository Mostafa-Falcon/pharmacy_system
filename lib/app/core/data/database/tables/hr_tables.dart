import 'package:drift/drift.dart';

/// 🕒 1. جدول سجل وبصمة الحضور والانصراف
class AttendanceTable extends Table {
  TextColumn get id => text()();
  TextColumn get employeeId => text()();
  TextColumn get employeeName => text().withDefault(const Constant(''))();
  DateTimeColumn get date => dateTime()();
  DateTimeColumn get checkInTime => dateTime()();
  DateTimeColumn get checkOutTime => dateTime().nullable()();
  RealColumn get workHours => real().withDefault(const Constant(0.0))();
  RealColumn get overtimeHours => real().withDefault(const Constant(0.0))();
  IntColumn get lateMinutes => integer().withDefault(const Constant(0))();
  TextColumn get status => text().withDefault(const Constant('present'))();
  
  TextColumn get accountId => text().nullable()();
  TextColumn get branchId => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get lastModified => dateTime()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  IntColumn get syncVersion => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}

/// 💵 2. جدول مسير الرواتب الشهرية
class PayrollTable extends Table {
  TextColumn get id => text()();
  TextColumn get employeeId => text()();
  TextColumn get employeeName => text().withDefault(const Constant(''))();
  TextColumn get period => text()(); // month-year
  RealColumn get basicSalary => real().withDefault(const Constant(0.0))();
  RealColumn get allowances => real().withDefault(const Constant(0.0))();
  RealColumn get deductions => real().withDefault(const Constant(0.0))();
  RealColumn get advances => real().withDefault(const Constant(0.0))();
  RealColumn get netSalary => real().withDefault(const Constant(0.0))();
  BoolColumn get isPaid => boolean().withDefault(const Constant(false))();
  DateTimeColumn get paidAt => dateTime().nullable()();
  
  TextColumn get accountId => text().nullable()();
  TextColumn get branchId => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get lastModified => dateTime()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  IntColumn get syncVersion => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}

/// ✉️ 3. جدول رسائل وتوجيهات الموظفين الداخليّة
class EmployeeMessagesTable extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get content => text()();
  TextColumn get senderName => text().withDefault(const Constant('الإدارة'))();
  TextColumn get recipientEmployeeIds => text().nullable()(); // JSON
  BoolColumn get isBroadcast => boolean().withDefault(const Constant(true))();
  TextColumn get readByEmployeeIds => text().withDefault(const Constant('[]'))();
  
  TextColumn get accountId => text().nullable()();
  TextColumn get branchId => text().nullable()();
  DateTimeColumn get sentAt => dateTime()();
  DateTimeColumn get lastModified => dateTime()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  IntColumn get syncVersion => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}


