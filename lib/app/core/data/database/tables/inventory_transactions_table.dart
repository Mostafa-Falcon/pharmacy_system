import 'package:drift/drift.dart';

class InventoryTransactionsTable extends Table {
  TextColumn get id => text()();
  TextColumn get branchId => text()();
  TextColumn get medicineId => text()();
  TextColumn get medicineName => text().nullable()();
  TextColumn get batchId => text().nullable()();
  TextColumn get unitId => text().nullable()();
  TextColumn get type => text()();
  RealColumn get quantity => real()();
  RealColumn get unitCost => real()();
  RealColumn get beforeQuantity => real().nullable()();
  RealColumn get afterQuantity => real().nullable()();
  TextColumn get referenceType => text()();
  TextColumn get referenceId => text()();
  TextColumn get actorId => text()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get occurredAt => dateTime()();
  BoolColumn get isDeleted => boolean()();

  @override
  Set<Column> get primaryKey => {id};
}
