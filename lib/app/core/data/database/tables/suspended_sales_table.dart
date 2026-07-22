import 'package:drift/drift.dart';

class SuspendedSalesTable extends Table {
  TextColumn get id => text()();
  TextColumn get branchId => text()();
  TextColumn get items => text()();
  RealColumn get subtotal => real()();
  RealColumn get discount => real()();
  RealColumn get total => real()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get isDeleted => boolean()();

  @override
  Set<Column> get primaryKey => {id};
}
