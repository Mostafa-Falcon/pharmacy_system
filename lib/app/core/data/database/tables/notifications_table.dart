import 'package:drift/drift.dart';

class NotificationsTable extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get message => text()();
  DateTimeColumn get timestamp => dateTime()();
  TextColumn get category => text()();
  TextColumn get priority => text()();
  BoolColumn get isRead => boolean()();
  TextColumn get metadata => text().nullable()();
  TextColumn get actionRoute => text().nullable()();
  TextColumn get branchId => text().nullable()();
  BoolColumn get isDeleted => boolean()();

  @override
  Set<Column> get primaryKey => {id};
}
