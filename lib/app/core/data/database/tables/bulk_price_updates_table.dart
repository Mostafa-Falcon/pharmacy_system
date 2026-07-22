import 'package:drift/drift.dart';

class BulkPriceUpdatesTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get type => text()();
  RealColumn get value => real()();
  TextColumn get filterCriteria => text()();
  IntColumn get affectedCount => integer()();
  TextColumn get createdBy => text()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get branchId => text()();
  BoolColumn get isDeleted => boolean()();

  @override
  Set<Column> get primaryKey => {id};
}
