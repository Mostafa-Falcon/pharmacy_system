import 'package:drift/drift.dart';

class AppSettingsTable extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

class ReceiptCountersTable extends Table {
  TextColumn get branchId => text()();
  TextColumn get counterType => text()();
  IntColumn get currentValue => integer()();

  @override
  Set<Column> get primaryKey => {branchId, counterType};
}
