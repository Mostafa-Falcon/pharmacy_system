import 'package:drift/drift.dart';

class TasksTable extends Table {
  TextColumn get id => text()();
  TextColumn get branchId => text()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  TextColumn get priority => text()();
  TextColumn get status => text()();
  TextColumn get assignedTo => text().nullable()();
  TextColumn get assignedName => text().nullable()();
  DateTimeColumn get dueDate => dateTime().nullable()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  IntColumn get syncVersion => integer()();
  DateTimeColumn get lastModified => dateTime()();
  BoolColumn get isDeleted => boolean()();

  @override
  Set<Column> get primaryKey => {id};
}

class NotesTable extends Table {
  TextColumn get id => text()();
  TextColumn get branchId => text()();
  TextColumn get title => text()();
  TextColumn get content => text()();
  BoolColumn get pinned => boolean()();
  TextColumn get color => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  IntColumn get syncVersion => integer()();
  DateTimeColumn get lastModified => dateTime()();
  BoolColumn get isDeleted => boolean()();

  @override
  Set<Column> get primaryKey => {id};
}

class RemindersTable extends Table {
  TextColumn get id => text()();
  TextColumn get branchId => text()();
  TextColumn get title => text()();
  TextColumn get message => text()();
  DateTimeColumn get remindAt => dateTime()();
  TextColumn get repeat => text()();
  BoolColumn get dismissed => boolean()();
  DateTimeColumn get lastTriggered => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get syncVersion => integer()();
  DateTimeColumn get lastModified => dateTime()();
  BoolColumn get isDeleted => boolean()();

  @override
  Set<Column> get primaryKey => {id};
}

class MessagesTable extends Table {
  TextColumn get id => text()();
  TextColumn get branchId => text()();
  TextColumn get fromUserId => text()();
  TextColumn get fromName => text()();
  TextColumn get toUserId => text()();
  TextColumn get toName => text()();
  TextColumn get subject => text()();
  TextColumn get body => text()();
  TextColumn get priority => text()();
  DateTimeColumn get readAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get syncVersion => integer()();
  DateTimeColumn get lastModified => dateTime()();
  BoolColumn get isDeleted => boolean()();

  @override
  Set<Column> get primaryKey => {id};
}
