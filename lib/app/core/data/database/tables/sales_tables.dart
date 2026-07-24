import 'package:drift/drift.dart';

/// 🧾 1. جدول فواتير المبيعات
class SaleInvoicesTable extends Table {
  TextColumn get id => text()();
  TextColumn get invoiceNumber => text()();
  TextColumn get customerName => text().withDefault(const Constant('زبون نقدي'))();
  TextColumn get customerId => text().nullable()();
  TextColumn get cashRegisterId => text().withDefault(const Constant(''))();
  
  // JSON Fields (Matching Seed Models)
  TextColumn get items => text()(); // List<SaleItemModel>
  
  RealColumn get subtotalAmount => real().withDefault(const Constant(0.0))();
  RealColumn get discountAmount => real().withDefault(const Constant(0.0))();
  RealColumn get finalAmount => real().withDefault(const Constant(0.0))();
  RealColumn get paidAmount => real().withDefault(const Constant(0.0))();
  RealColumn get remainingAmount => real().withDefault(const Constant(0.0))();
  
  TextColumn get paymentMethod => text().withDefault(const Constant('cash'))();
  TextColumn get createdBy => text()();
  TextColumn get branchId => text().withDefault(const Constant(''))();
  TextColumn get accountId => text().withDefault(const Constant(''))();
  TextColumn get notes => text().nullable()();
  
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get lastModified => dateTime()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  IntColumn get syncVersion => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}

/// 🔄 2. جدول المرتجع المربوط بالفاتورة
class InvoiceReturnsTable extends Table {
  TextColumn get id => text()();
  TextColumn get returnNumber => text()();
  TextColumn get originalInvoiceNumber => text()();
  TextColumn get originalInvoiceId => text()();
  TextColumn get customerName => text().withDefault(const Constant('زبون نقدي'))();
  TextColumn get customerId => text().nullable()();
  
  // JSON Fields
  TextColumn get items => text()(); // List<InvoiceReturnItemModel>
  
  RealColumn get returnDiscount => real().withDefault(const Constant(0.0))();
  RealColumn get totalReturnAmount => real().withDefault(const Constant(0.0))();
  
  TextColumn get createdBy => text()();
  TextColumn get branchId => text().withDefault(const Constant(''))();
  TextColumn get accountId => text().withDefault(const Constant(''))();
  TextColumn get notes => text().nullable()();
  
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get lastModified => dateTime()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  IntColumn get syncVersion => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}

/// 🔄 3. جدول المرتجع الحر المباشر
class FreeReturnsTable extends Table {
  TextColumn get id => text()();
  TextColumn get returnNumber => text()();
  TextColumn get returnCategory => text()();
  TextColumn get partyType => text().withDefault(const Constant('cash'))();
  TextColumn get partyId => text().nullable()();
  TextColumn get partyName => text().withDefault(const Constant('نقدي'))();
  TextColumn get cashRegisterId => text().withDefault(const Constant(''))();
  
  // JSON Fields
  TextColumn get items => text()(); // List<FreeReturnItemModel>
  
  TextColumn get reasonNotes => text().nullable()();
  RealColumn get totalAmount => real().withDefault(const Constant(0.0))();
  
  TextColumn get createdBy => text()();
  TextColumn get branchId => text().withDefault(const Constant(''))();
  TextColumn get accountId => text().withDefault(const Constant(''))();
  
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get lastModified => dateTime()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  IntColumn get syncVersion => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}

/// 💵 4. جدول وراديات وسجل الكاشير الخزينة
class CashierShiftsTable extends Table {
  TextColumn get id => text()();
  IntColumn get shiftNumber => integer().withDefault(const Constant(1))();
  TextColumn get branchId => text().withDefault(const Constant(''))();
  TextColumn get cashierId => text()();
  TextColumn get cashierName => text().withDefault(const Constant(''))();
  TextColumn get deviceId => text().withDefault(const Constant('POS-1'))();
  DateTimeColumn get openedAt => dateTime()();
  RealColumn get openingCash => real().withDefault(const Constant(0.0))();
  TextColumn get status => text().withDefault(const Constant('open'))();
  DateTimeColumn get closedAt => dateTime().nullable()();
  RealColumn get expectedCash => real().nullable()();
  RealColumn get countedCash => real().nullable()();
  RealColumn get difference => real().nullable()();
  TextColumn get accountId => text().nullable()();
  TextColumn get notes => text().nullable()();
  
  DateTimeColumn get lastModified => dateTime()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  IntColumn get syncVersion => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}

/// 🚚 5. جدول طلبات وإذونات الشحن والتوصيل
class ShippingOrdersTable extends Table {
  TextColumn get id => text()();
  TextColumn get invoiceNumber => text()();
  TextColumn get invoiceId => text()();
  DateTimeColumn get shippingDate => dateTime()();
  TextColumn get customerName => text()();
  TextColumn get customerPhone => text().nullable()();
  TextColumn get shippingAddress => text()();
  TextColumn get shippingDetails => text().nullable()();
  TextColumn get deliveredTo => text().nullable()();
  TextColumn get deliveryAgentId => text().nullable()();
  TextColumn get deliveryAgentName => text().nullable()();
  TextColumn get shippingStatus => text().withDefault(const Constant('pending'))();
  BoolColumn get isPaid => boolean().withDefault(const Constant(false))();
  TextColumn get notes => text().nullable()();
  TextColumn get documentUrls => text().nullable()(); // JSON
  
  TextColumn get createdBy => text()();
  TextColumn get branchId => text().withDefault(const Constant(''))();
  TextColumn get accountId => text().withDefault(const Constant(''))();
  DateTimeColumn get lastModified => dateTime()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  IntColumn get syncVersion => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}

/// 📄 6. جدول عروض الأسعار
class QuotationsTable extends Table {
  TextColumn get id => text()();
  TextColumn get quotationNumber => text()();
  TextColumn get customerId => text().nullable()();
  TextColumn get customerName => text()();
  TextColumn get customerPhone => text().nullable()();
  
  // JSON Fields
  TextColumn get items => text()(); // QuotationItemModel[]
  
  RealColumn get subtotalAmount => real().withDefault(const Constant(0.0))();
  RealColumn get discountAmount => real().withDefault(const Constant(0.0))();
  RealColumn get finalAmount => real().withDefault(const Constant(0.0))();
  RealColumn get paidAmount => real().withDefault(const Constant(0.0))();
  RealColumn get remainingAmount => real().withDefault(const Constant(0.0))();
  TextColumn get paymentMethod => text().nullable()();
  TextColumn get paymentStatus => text().withDefault(const Constant('unpaid'))();
  TextColumn get shippingStatus => text().withDefault(const Constant('pending'))();
  RealColumn get totalQuantity => real().withDefault(const Constant(0.0))();
  TextColumn get status => text().withDefault(const Constant('draft'))();
  TextColumn get createdBy => text()();
  TextColumn get branchId => text().withDefault(const Constant(''))();
  TextColumn get accountId => text().withDefault(const Constant(''))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get lastModified => dateTime()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  IntColumn get syncVersion => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}

/// 🎁 7. جدول العروض والخصومات الترويجية
class PromotionsTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get selectedMedicineIds => text().nullable()(); // JSON
  TextColumn get categoryId => text().nullable()();
  TextColumn get brandId => text().nullable()();
  IntColumn get priority => integer().withDefault(const Constant(1))();
  TextColumn get discountType => text().withDefault(const Constant('percentage'))();
  RealColumn get discountValue => real().withDefault(const Constant(0.0))();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  TextColumn get branchId => text().withDefault(const Constant(''))();
  TextColumn get accountId => text().withDefault(const Constant(''))();
  DateTimeColumn get lastModified => dateTime()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  IntColumn get syncVersion => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}

/// ↩️ 8. جدول المرتجعات العامة (يشمل مبيعات ومشتريات)
class ReturnsTable extends Table {
  TextColumn get id => text()();
  TextColumn get branchId => text()();
  TextColumn get saleId => text().nullable()();
  TextColumn get purchaseId => text().nullable()();
  TextColumn get items => text()(); // JSON
  RealColumn get totalAmount => real().withDefault(const Constant(0.0))();
  TextColumn get reason => text()();
  TextColumn get notes => text().nullable()();
  TextColumn get createdBy => text()();
  TextColumn get accountId => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get syncVersion => integer().withDefault(const Constant(1))();
  DateTimeColumn get lastModified => dateTime()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

/// ⏸️ 9. جدول الفواتير المعلقة (Suspended POS Sales)
class SuspendedSalesTable extends Table {
  TextColumn get id => text()();
  TextColumn get referenceNumber => text()();
  TextColumn get customerName => text().withDefault(const Constant('زبون نقدي'))();
  TextColumn get customerId => text().nullable()();
  TextColumn get itemsJson => text()(); // JSON
  RealColumn get totalAmount => real().withDefault(const Constant(0.0))();
  TextColumn get cashierId => text()();
  TextColumn get branchId => text().withDefault(const Constant(''))();
  TextColumn get accountId => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get lastModified => dateTime()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  IntColumn get syncVersion => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}


