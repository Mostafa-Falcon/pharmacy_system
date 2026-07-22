import 'package:drift/drift.dart';

class CustomersTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get phone => text().nullable()();
  TextColumn get address => text().nullable()();
  BoolColumn get isActive => boolean()();
  TextColumn get kind => text()();
  TextColumn get companyName => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get taxId => text().nullable()();
  RealColumn get creditLimit => real()();
  RealColumn get discountPercent => real()();
  IntColumn get paymentTermDays => integer()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get lastModified => dateTime()();
  BoolColumn get isDeleted => boolean()();
  TextColumn get salesRepId => text().nullable()();
  TextColumn get branchId => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class CustomerGroupsTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  RealColumn get discountPercent => real()();
  TextColumn get priceGroupId => text().nullable()();
  TextColumn get description => text().nullable()();
  BoolColumn get isActive => boolean()();
  DateTimeColumn get lastModified => dateTime()();
  BoolColumn get isDeleted => boolean()();

  @override
  Set<Column> get primaryKey => {id};
}

class CustomerLedgersTable extends Table {
  TextColumn get id => text()();
  TextColumn get customerId => text()();
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

class SupplierCustomersTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get phone => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get companyName => text().nullable()();
  TextColumn get taxId => text().nullable()();
  BoolColumn get isActive => boolean()();
  TextColumn get notes => text().nullable()();
  IntColumn get customerKindIndex => integer()();
  RealColumn get creditLimit => real()();
  RealColumn get discountPercent => real()();
  IntColumn get paymentTermDays => integer()();
  IntColumn get supplierPartyTypeIndex => integer()();
  DateTimeColumn get lastModified => dateTime()();
  BoolColumn get isDeleted => boolean()();
  TextColumn get branchId => text()();

  @override
  Set<Column> get primaryKey => {id};
}
