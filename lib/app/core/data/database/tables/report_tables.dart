import 'package:drift/drift.dart';

class ReportDefinitionsTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get type => text()();
  TextColumn get config => text()();
  TextColumn get branchId => text().withDefault(const Constant(''))();
  TextColumn get createdBy => text()();
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get isDeleted => boolean()();

  @override
  Set<Column> get primaryKey => {id};
}
