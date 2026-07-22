import 'package:drift/drift.dart';

class InventoryTable extends Table {
  TextColumn get id => text()();
  TextColumn get medicineId => text()();
  TextColumn get branchId => text()();
  IntColumn get currentQuantity => integer()();
  IntColumn get minStock => integer()();
  IntColumn get maxStock => integer()();
  DateTimeColumn get lastRestocked => dateTime()();
  IntColumn get syncVersion => integer()();
  DateTimeColumn get lastModified => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class DamagedStockTable extends Table {
  TextColumn get id => text()();
  TextColumn get medicineId => text()();
  TextColumn get medicineName => text()();
  IntColumn get quantity => integer()();
  TextColumn get reason => text()();
  TextColumn get notes => text().nullable()();
  TextColumn get branchId => text()();
  TextColumn get recordedBy => text()();
  DateTimeColumn get recordedAt => dateTime()();
  DateTimeColumn get lastModified => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class OpeningStockTable extends Table {
  TextColumn get id => text()();
  TextColumn get medicineId => text()();
  TextColumn get medicineName => text()();
  IntColumn get quantity => integer()();
  RealColumn get buyPrice => real()();
  TextColumn get branchId => text()();
  TextColumn get recordedBy => text()();
  DateTimeColumn get recordedAt => dateTime()();
  DateTimeColumn get lastModified => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
