import 'package:drift/drift.dart';

class StockTransfersTable extends Table {
  TextColumn get id => text()();
  TextColumn get branchId => text()();
  TextColumn get fromBranchId => text()();
  TextColumn get toBranchId => text()();
  TextColumn get fromBranchName => text()();
  TextColumn get toBranchName => text()();
  IntColumn get transferNumber => integer()();
  TextColumn get items => text()();
  TextColumn get status => text()();
  TextColumn get notes => text().nullable()();
  TextColumn get createdBy => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get receivedAt => dateTime().nullable()();
  TextColumn get receivedBy => text().nullable()();
  IntColumn get syncVersion => integer()();
  BoolColumn get isDeleted => boolean()();

  @override
  Set<Column> get primaryKey => {id};
}
