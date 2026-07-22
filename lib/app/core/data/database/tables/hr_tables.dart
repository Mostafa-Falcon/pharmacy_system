import 'package:drift/drift.dart';

class DepartmentsTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get branchId => text()();
  BoolColumn get isActive => boolean()();
  BoolColumn get isDeleted => boolean()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class EmployeesTable extends Table {
  TextColumn get id => text()();
  TextColumn get code => text()();
  TextColumn get name => text()();
  TextColumn get phone => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get departmentId => text().nullable()();
  TextColumn get position => text().nullable()();
  RealColumn get baseSalary => real()();
  TextColumn get bankAccount => text().nullable()();
  TextColumn get nationalId => text().nullable()();
  DateTimeColumn get hireDate => dateTime()();
  BoolColumn get isActive => boolean()();
  TextColumn get branchId => text()();
  BoolColumn get isDeleted => boolean()();
  DateTimeColumn get lastModified => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class AttendanceTable extends Table {
  TextColumn get id => text()();
  TextColumn get employeeId => text()();
  DateTimeColumn get date => dateTime()();
  TextColumn get checkIn => text().nullable()();
  TextColumn get checkOut => text().nullable()();
  TextColumn get status => text()();
  TextColumn get notes => text().nullable()();
  TextColumn get branchId => text()();
  BoolColumn get isDeleted => boolean()();

  @override
  Set<Column> get primaryKey => {id};
}

class LeavesTable extends Table {
  TextColumn get id => text()();
  TextColumn get employeeId => text()();
  TextColumn get type => text()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  TextColumn get status => text()();
  TextColumn get reason => text().nullable()();
  TextColumn get approvedBy => text().nullable()();
  TextColumn get branchId => text()();
  BoolColumn get isDeleted => boolean()();
  DateTimeColumn get lastModified => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class PayrollTable extends Table {
  TextColumn get id => text()();
  TextColumn get employeeId => text()();
  TextColumn get period => text()();
  DateTimeColumn get payDate => dateTime()();
  RealColumn get baseSalary => real()();
  RealColumn get bonuses => real()();
  RealColumn get deductions => real()();
  RealColumn get netSalary => real()();
  TextColumn get status => text()();
  TextColumn get notes => text().nullable()();
  TextColumn get branchId => text()();
  BoolColumn get isDeleted => boolean()();
  DateTimeColumn get lastModified => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
