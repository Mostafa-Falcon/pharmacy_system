import 'package:drift/drift.dart';

@DataClassName('ArchiveRecord')
class ArchiveRecords extends Table {
  TextColumn get id => text()();
  TextColumn get entityType => text()();
  TextColumn get entityId => text()();
  TextColumn get entityTitle => text()();
  TextColumn get entityData => text()();
  TextColumn get deletedBy => text()();
  TextColumn get deletedByName => text()();
  DateTimeColumn get deletedAt => dateTime()();
  TextColumn get branchId => text()();
  TextColumn get restoredAt => text().nullable()();
  TextColumn get restoredBy => text().nullable()();
  TextColumn get permanentlyDeletedAt => text().nullable()();
  IntColumn get syncVersion => integer()();
  DateTimeColumn get lastModified => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
