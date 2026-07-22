import 'package:drift/drift.dart';

class ItemsArchiveTable extends Table {
  TextColumn get id => text()();
  TextColumn get medicineId => text()();
  TextColumn get medicineName => text()();
  TextColumn get barcodes => text()();
  RealColumn get buyPrice => real()();
  RealColumn get sellPrice => real()();
  TextColumn get archivedBy => text()();
  DateTimeColumn get archivedAt => dateTime()();
  TextColumn get reason => text().nullable()();
  TextColumn get branchId => text()();
  BoolColumn get isDeleted => boolean()();

  @override
  Set<Column> get primaryKey => {id};
}
