import 'package:drift/drift.dart';

class MedicineBrandsTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get logo => text().nullable()();
  TextColumn get branchId => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class MedicineVariantsTable extends Table {
  TextColumn get id => text()();
  TextColumn get medicineId => text()();
  TextColumn get name => text()();
  RealColumn get price => real()();
  RealColumn get cost => real()();
  TextColumn get sku => text()();
  TextColumn get attributes => text()();
  TextColumn get branchId => text().withDefault(const Constant(''))();

  @override
  Set<Column> get primaryKey => {id};
}

class PriceGroupsTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  RealColumn get markupPercentage => real()();
  RealColumn get discountPercentage => real()();
  BoolColumn get isDefault => boolean()();
  TextColumn get branchId => text().withDefault(const Constant(''))();

  @override
  Set<Column> get primaryKey => {id};
}
