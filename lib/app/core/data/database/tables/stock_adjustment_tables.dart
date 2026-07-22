import 'package:drift/drift.dart';

class StockAdjustmentsTable extends Table {
  TextColumn get id => text()();
  TextColumn get branchId => text()();
  TextColumn get adjustmentNumber => text()();
  DateTimeColumn get adjustmentDate => dateTime()();
  TextColumn get items => text()();
  TextColumn get createdById => text().nullable()();
  TextColumn get createdByName => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isDeleted => boolean()();

  @override
  Set<Column> get primaryKey => {id};
}
