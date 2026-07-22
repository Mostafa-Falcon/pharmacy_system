import 'package:drift/drift.dart';

class AdminRolesTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get permissions => text()();
  TextColumn get branchId => text()();
  BoolColumn get isActive => boolean()();
  BoolColumn get isDeleted => boolean()();
  DateTimeColumn get lastModified => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class AdminMembersTable extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get roleId => text()();
  TextColumn get branchId => text()();
  BoolColumn get isActive => boolean()();
  BoolColumn get isDeleted => boolean()();
  DateTimeColumn get lastModified => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class AuditLogsTable extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get action => text()();
  TextColumn get entityType => text()();
  TextColumn get entityId => text()();
  TextColumn get details => text().nullable()();
  TextColumn get branchId => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
