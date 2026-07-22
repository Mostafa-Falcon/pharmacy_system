import 'package:drift/drift.dart';

class PromotionsTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get type => text()();
  RealColumn get value => real()();
  BoolColumn get isPercentage => boolean()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  TextColumn get medicineIds => text()();
  TextColumn get categoryFilters => text()();
  TextColumn get customerGroupId => text().nullable()();
  TextColumn get branchId => text()();
  BoolColumn get isActive => boolean()();
  DateTimeColumn get lastModified => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
