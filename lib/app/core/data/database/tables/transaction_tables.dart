import 'package:drift/drift.dart';

class SalesTable extends Table {
  TextColumn get id => text()();
  TextColumn get branchId => text()();
  TextColumn get customerId => text().nullable()();
  TextColumn get customerName => text().nullable()();
  TextColumn get items => text()();
  RealColumn get totalAmount => real()();
  RealColumn get discount => real().nullable()();
  RealColumn get finalAmount => real()();
  RealColumn get taxAmount => real().nullable()();
  TextColumn get paymentMethod => text()();
  TextColumn get notes => text().nullable()();
  TextColumn get createdBy => text()();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get syncVersion => integer()();
  DateTimeColumn get lastModified => dateTime()();
  BoolColumn get isDeleted => boolean()();
  RealColumn get paidAmount => real().nullable()();
  TextColumn get receiptNumber => text().nullable()();
  TextColumn get salesRepId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class PurchasesTable extends Table {
  TextColumn get id => text()();
  TextColumn get branchId => text()();
  TextColumn get supplierName => text()();
  TextColumn get supplierPhone => text().nullable()();
  TextColumn get items => text()();
  RealColumn get totalAmount => real()();
  RealColumn get discount => real().nullable()();
  RealColumn get tax => real().nullable()();
  RealColumn get finalAmount => real()();
  TextColumn get paymentMethod => text()();
  RealColumn get paidAmount => real().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get createdBy => text()();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get syncVersion => integer()();
  DateTimeColumn get lastModified => dateTime()();
  BoolColumn get isDeleted => boolean()();
  TextColumn get status => text()();
  TextColumn get supplierId => text().nullable()();
  TextColumn get sourceType => text().nullable()();
  TextColumn get receiptNumber => text().nullable()();
  RealColumn get shippingAmount => real().nullable()();
  RealColumn get deliveryAmount => real().nullable()();
  TextColumn get supplierPartyType => text().nullable()();
  TextColumn get invoiceDiscountType => text().nullable()();
  RealColumn get invoiceDiscountValue => real().nullable()();
  RealColumn get invoiceDiscountAmount => real().nullable()();
  TextColumn get invoiceTaxType => text().nullable()();
  RealColumn get invoiceTaxValue => real().nullable()();
  RealColumn get invoiceTaxAmount => real().nullable()();
  TextColumn get paymentAccountId => text().nullable()();
  TextColumn get paymentAccountName => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class ReturnsTable extends Table {
  TextColumn get id => text()();
  TextColumn get branchId => text()();
  TextColumn get returnType => text()(); // sales, purchase
  TextColumn get partyId => text().nullable()();
  TextColumn get partyName => text().nullable()();
  TextColumn get partyType => text().nullable()(); // cash, customer, supplier
  TextColumn get saleId => text().nullable()();
  TextColumn get purchaseId => text().nullable()();
  TextColumn get items => text()();
  RealColumn get totalAmount => real()();
  RealColumn get discountPercent => real()();
  RealColumn get finalAmount => real()();
  TextColumn get safeId => text().nullable()();
  TextColumn get reason => text()();
  TextColumn get notes => text().nullable()();
  TextColumn get createdBy => text()();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get syncVersion => integer()();
  DateTimeColumn get lastModified => dateTime()();
  BoolColumn get isDeleted => boolean()();

  @override
  Set<Column> get primaryKey => {id};
}

class QuotesTable extends Table {
  TextColumn get id => text()();
  TextColumn get branchId => text()();
  IntColumn get number => integer()();
  TextColumn get customerName => text()();
  TextColumn get notes => text().nullable()();
  TextColumn get items => text()();
  RealColumn get subtotal => real()();
  RealColumn get discount => real()();
  RealColumn get total => real()();
  TextColumn get status => text()();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get syncVersion => integer()();
  DateTimeColumn get lastModified => dateTime()();
  BoolColumn get isDeleted => boolean()();

  @override
  Set<Column> get primaryKey => {id};
}

class CashierShiftsTable extends Table {
  TextColumn get id => text()();
  TextColumn get branchId => text()();
  IntColumn get shiftNumber => integer()();
  TextColumn get cashierId => text()();
  TextColumn get cashierName => text()();
  TextColumn get deviceId => text()();
  DateTimeColumn get openedAt => dateTime()();
  RealColumn get openingCash => real()();
  TextColumn get status => text()();
  DateTimeColumn get closedAt => dateTime().nullable()();
  RealColumn get expectedCash => real().nullable()();
  RealColumn get countedCash => real().nullable()();
  RealColumn get difference => real().nullable()();
  TextColumn get notes => text().nullable()();
  IntColumn get syncVersion => integer()();
  DateTimeColumn get lastModified => dateTime()();
  BoolColumn get isDeleted => boolean()();

  @override
  Set<Column> get primaryKey => {id};
}
