import 'package:drift/drift.dart';

/// 🧾 1. جدول فواتير المشتريات
class PurchaseInvoicesTable extends Table {
  TextColumn get id => text()();
  TextColumn get invoiceNumber => text()();
  TextColumn get supplierId => text()();
  TextColumn get supplierName => text()();
  
  // JSON Fields (Matching Seed Models)
  TextColumn get items => text()(); // List<PurchaseItemModel>
  
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

/// 📦 2. جدول سجل الأصناف الموردة (Supplied Items Analytics)
class SuppliedItemsTable extends Table {
  TextColumn get id => text()();
  TextColumn get supplierId => text()();
  TextColumn get medicineId => text()();
  TextColumn get medicineName => text()();
  RealColumn get lastPurchasePrice => real().withDefault(const Constant(0.0))();
  DateTimeColumn get lastPurchaseDate => dateTime()();
  IntColumn get totalQuantitySupplied => integer().withDefault(const Constant(0))();
  
  TextColumn get branchId => text().withDefault(const Constant(''))();
  TextColumn get accountId => text().nullable()();
  DateTimeColumn get lastModified => dateTime()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  IntColumn get syncVersion => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}


