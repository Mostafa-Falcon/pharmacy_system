import 'package:drift/drift.dart';

class SuppliersTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get type => text()();
  TextColumn get phone => text().nullable()();
  TextColumn get address => text().nullable()();
  BoolColumn get isActive => boolean()();
  BoolColumn get isDeleted => boolean()();
  DateTimeColumn get lastModified => dateTime()();
  TextColumn get partyType => text()();
  TextColumn get companyName => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get taxId => text().nullable()();
  RealColumn get creditLimit => real()();
  RealColumn get discountPercent => real()();
  IntColumn get paymentTermDays => integer()();
  TextColumn get notes => text().nullable()();
  TextColumn get branchId => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class SupplierLedgersTable extends Table {
  TextColumn get id => text()();
  TextColumn get supplierId => text()();
  TextColumn get branchId => text()();
  TextColumn get type => text()();
  RealColumn get debit => real()();
  RealColumn get credit => real()();
  RealColumn get balanceAfter => real()();
  TextColumn get referenceId => text().nullable()();
  TextColumn get referenceNumber => text().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get createdBy => text().nullable()();
  DateTimeColumn get entryDate => dateTime()();
  IntColumn get syncVersion => integer()();
  DateTimeColumn get lastModified => dateTime()();
  BoolColumn get isDeleted => boolean()();

  @override
  Set<Column> get primaryKey => {id};
}
