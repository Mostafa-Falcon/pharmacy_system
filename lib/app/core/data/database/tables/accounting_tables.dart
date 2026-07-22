import 'package:drift/drift.dart';

class AccountsTable extends Table {
  TextColumn get id => text()();
  TextColumn get code => text()();
  TextColumn get name => text()();
  TextColumn get type => text()();
  TextColumn get parentId => text().nullable()();
  RealColumn get balance => real()();
  BoolColumn get isActive => boolean()();
  TextColumn get branchId => text()();
  BoolColumn get isDeleted => boolean()();
  DateTimeColumn get lastModified => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class JournalEntriesTable extends Table {
  TextColumn get id => text()();
  TextColumn get branchId => text()();
  IntColumn get entryNumber => integer()();
  DateTimeColumn get entryDate => dateTime()();
  TextColumn get entryType => text()();
  TextColumn get referenceId => text().nullable()();
  TextColumn get referenceNumber => text().nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get lines => text()();
  RealColumn get totalDebit => real()();
  RealColumn get totalCredit => real()();
  TextColumn get createdById => text()();
  TextColumn get createdByName => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isDeleted => boolean()();

  @override
  Set<Column> get primaryKey => {id};
}

class ExpensesTable extends Table {
  TextColumn get id => text()();
  TextColumn get branchId => text()();
  IntColumn get expenseNumber => integer()();
  DateTimeColumn get expenseDate => dateTime()();
  TextColumn get category => text()();
  TextColumn get description => text().nullable()();
  RealColumn get amount => real()();
  TextColumn get paymentMethod => text()();
  TextColumn get createdById => text()();
  TextColumn get createdByName => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isDeleted => boolean()();

  @override
  Set<Column> get primaryKey => {id};
}

class PartyPaymentsTable extends Table {
  TextColumn get id => text()();
  TextColumn get branchId => text()();
  IntColumn get number => integer()();
  DateTimeColumn get paymentDate => dateTime()();
  TextColumn get kind => text()();
  TextColumn get partyId => text()();
  TextColumn get partyName => text()();
  RealColumn get amount => real()();
  TextColumn get paymentMethod => text()();
  TextColumn get balanceEffect => text().nullable()();
  TextColumn get purchaseReceiptId => text().nullable()();
  TextColumn get purchaseReceiptNumber => text().nullable()();
  TextColumn get referenceNumber => text().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get createdById => text()();
  TextColumn get createdByName => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isDeleted => boolean()();

  @override
  Set<Column> get primaryKey => {id};
}
