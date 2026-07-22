import 'package:drift/drift.dart';

class OutboxTable extends Table {
  TextColumn get id => text()();
  TextColumn get operation => text()();
  TextColumn get targetTable => text()();
  TextColumn get recordId => text()();
  TextColumn get data => text()();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get retryCount => integer()();
  TextColumn get lastError => text().nullable()();
  DateTimeColumn get syncedAt => dateTime().nullable()();
  TextColumn get branchId => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class SyncStateTable extends Table {
  TextColumn get syncTable => text()();
  DateTimeColumn get lastWatermark => dateTime()();
  DateTimeColumn get lastSyncAt => dateTime()();
  TextColumn get branchId => text()();

  @override
  Set<Column> get primaryKey => {syncTable, branchId};
}
