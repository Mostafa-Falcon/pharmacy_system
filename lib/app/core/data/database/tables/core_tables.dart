import 'package:drift/drift.dart';

class UsersTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get email => text()();
  TextColumn get passwordHash => text()();
  TextColumn get role => text()();
  TextColumn get assignedBranchId => text().nullable()();
  BoolColumn get isActive => boolean()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get lastLogin => dateTime().nullable()();
  IntColumn get syncVersion => integer()();
  DateTimeColumn get lastModified => dateTime()();
  BoolColumn get isDeleted => boolean()();
  TextColumn get activeDeviceId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class BranchesTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get address => text().nullable()();
  TextColumn get phone => text().nullable()();
  BoolColumn get isActive => boolean()();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get syncVersion => integer()();
  DateTimeColumn get lastModified => dateTime()();
  BoolColumn get isDeleted => boolean()();

  @override
  Set<Column> get primaryKey => {id};
}

class PermissionsTable extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get permissionKey => text()();
  BoolColumn get isAllowed => boolean()();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get syncVersion => integer()();
  BoolColumn get isDeleted => boolean()();
  DateTimeColumn get lastModified => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
