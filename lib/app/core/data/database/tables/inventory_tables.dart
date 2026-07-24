import 'package:drift/drift.dart';

/// 💊 1. جدول الأصناف والأدوية الرئيسي
class MedicinesTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get nameEn => text().nullable()();
  
  // JSON Fields (Matching Seed Models)
  TextColumn get itemTypes => text().withDefault(const Constant('[]'))();
  TextColumn get therapeuticGroup => text().withDefault(const Constant('{}'))();
  TextColumn get barcodes => text().withDefault(const Constant('[]'))();
  TextColumn get itemLevels => text().withDefault(const Constant('{}'))();
  TextColumn get expiryDates => text().nullable()(); // List of dates as JSON

  TextColumn get supplierId => text().nullable()();
  TextColumn get manufacturer => text().nullable()();
  TextColumn get dosageForm => text().nullable()();
  TextColumn get strength => text().nullable()();
  TextColumn get packageSize => text().nullable()();
  TextColumn get containerShape => text().nullable()();
  TextColumn get location => text().nullable()();
  
  BoolColumn get isTaxable => boolean().withDefault(const Constant(false))();
  TextColumn get taxType => text().nullable()();
  RealColumn get taxValue => real().nullable()();
  BoolColumn get pricesIncludeTax => boolean().withDefault(const Constant(false))();
  
  BoolColumn get alertEnabled => boolean().withDefault(const Constant(true))();
  IntColumn get minStock => integer().withDefault(const Constant(10))();
  BoolColumn get expiryTrackingEnabled => boolean().withDefault(const Constant(true))();
  BoolColumn get allowNegativeStock => boolean().withDefault(const Constant(false))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  
  TextColumn get imageUrl => text().nullable()();
  TextColumn get description => text().nullable()();
  
  // Sync & Ownership
  TextColumn get accountId => text().nullable()();
  TextColumn get branchId => text().nullable()();
  IntColumn get syncVersion => integer().withDefault(const Constant(1))();
  DateTimeColumn get lastModified => dateTime()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// 📦 2. جدول تشغيلات الدواء والصلاحية (Batches)
class ItemBatchesTable extends Table {
  TextColumn get id => text()();
  TextColumn get medicineId => text()();
  TextColumn get batchNumber => text().nullable()();
  DateTimeColumn get expiryDate => dateTime().nullable()();
  IntColumn get quantity => integer().withDefault(const Constant(0))();
  IntColumn get damagedQuantity => integer().withDefault(const Constant(0))();
  RealColumn get purchasePrice => real().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  
  TextColumn get accountId => text().nullable()();
  TextColumn get branchId => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get lastModified => dateTime()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  IntColumn get syncVersion => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}

/// 📂 3. جدول فئات الأصناف
class ItemCategoriesTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get code => text().nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get parentId => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  
  TextColumn get accountId => text().nullable()();
  DateTimeColumn get lastModified => dateTime()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  IntColumn get syncVersion => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}

/// 🏢 4. جدول ماركات الأصناف
class MedicineBrandsTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  BoolColumn get useForRepair => boolean().withDefault(const Constant(false))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  
  TextColumn get accountId => text().nullable()();
  DateTimeColumn get lastModified => dateTime()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  IntColumn get syncVersion => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}

/// 🎨 5. جدول متغيرات الأصناف
class ItemVariantsTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get values => text().withDefault(const Constant('[]'))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  
  TextColumn get accountId => text().nullable()();
  DateTimeColumn get lastModified => dateTime()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  IntColumn get syncVersion => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}

/// 🛡️ 6. جدول ضمانات الأصناف
class ItemWarrantiesTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  IntColumn get duration => integer().withDefault(const Constant(1))();
  TextColumn get durationUnit => text().withDefault(const Constant('year'))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  
  TextColumn get accountId => text().nullable()();
  DateTimeColumn get lastModified => dateTime()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  IntColumn get syncVersion => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}

/// 🏷️ 7. جدول شرائح التسعير
class PriceGroupsTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  RealColumn get markupPercentage => real().withDefault(const Constant(0.0))();
  RealColumn get discountPercentage => real().withDefault(const Constant(0.0))();
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  
  TextColumn get accountId => text().nullable()();
  DateTimeColumn get lastModified => dateTime()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  IntColumn get syncVersion => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}

/// ⚖️ 8. جدول الجرد الفعلي للمخزون
class StocktakingTable extends Table {
  TextColumn get id => text()();
  TextColumn get stocktakingNumber => text()();
  TextColumn get title => text()();
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

/// ⚖️ 9. جدول تسويات وهالك المخزن
class StockAdjustmentsTable extends Table {
  TextColumn get id => text()();
  TextColumn get adjustmentNumber => text()();
  TextColumn get adjustmentType => text().withDefault(const Constant('damage'))();
  TextColumn get items => text()(); // List of items as JSON
  RealColumn get totalAmount => real().withDefault(const Constant(0.0))();
  TextColumn get adjustedBy => text()();
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

/// 🔄 10. جدول تبادل الأصناف المباشر
class ItemSwapsTable extends Table {
  TextColumn get id => text()();
  TextColumn get swapNumber => text()();
  TextColumn get partyType => text().withDefault(const Constant('customer'))();
  TextColumn get partyId => text().nullable()();
  TextColumn get partyName => text().withDefault(const Constant(''))();
  TextColumn get cashRegisterId => text().nullable()();
  RealColumn get totalIncomingAmount => real().withDefault(const Constant(0.0))();
  RealColumn get totalOutgoingAmount => real().withDefault(const Constant(0.0))();
  RealColumn get netCashDifference => real().withDefault(const Constant(0.0))();
  TextColumn get items => text()(); // JSON
  TextColumn get createdBy => text()();
  TextColumn get branchId => text().withDefault(const Constant(''))();
  TextColumn get accountId => text().withDefault(const Constant(''))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get swapDate => dateTime()();
  DateTimeColumn get lastModified => dateTime()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  IntColumn get syncVersion => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}

/// 📦 11. جدول رصيد أول المدة
class OpeningStockTable extends Table {
  TextColumn get id => text()();
  TextColumn get voucherNumber => text()();
  TextColumn get items => text()(); // JSON
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

/// 🖨️ 12. جدول إعدادات ومقاسات وطباعة الباركود
class BarcodeSettingsTable extends Table {
  TextColumn get id => text()();
  TextColumn get prefix => text().withDefault(const Constant('20'))();
  RealColumn get labelWidthMm => real().withDefault(const Constant(62.0))();
  RealColumn get labelHeightMm => real().withDefault(const Constant(32.0))();
  IntColumn get copiesPerItem => integer().withDefault(const Constant(1))();
  BoolColumn get showPrice => boolean().withDefault(const Constant(true))();
  BoolColumn get showItemName => boolean().withDefault(const Constant(true))();
  BoolColumn get showUnitName => boolean().withDefault(const Constant(true))();
  BoolColumn get showPharmacyName => boolean().withDefault(const Constant(false))();
  TextColumn get pharmacyName => text().withDefault(const Constant(''))();
  BoolColumn get showExpiry => boolean().withDefault(const Constant(false))();
  BoolColumn get showBatch => boolean().withDefault(const Constant(false))();
  TextColumn get printLayout => text().withDefault(const Constant('labelPrinter'))();
  BoolColumn get directPrint => boolean().withDefault(const Constant(false))();
  TextColumn get printerName => text().withDefault(const Constant(''))();
  TextColumn get accountId => text().nullable()();
  DateTimeColumn get lastModified => dateTime()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  IntColumn get syncVersion => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}

/// 🏷️ 13. جدول الباركودات المنفصلة للأصناف
class MedicineBarcodesTable extends Table {
  TextColumn get id => text()();
  TextColumn get medicineId => text()();
  TextColumn get barcode => text()();
  BoolColumn get isPrimary => boolean().withDefault(const Constant(false))();
  TextColumn get description => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get syncVersion => integer().withDefault(const Constant(1))();
  DateTimeColumn get lastModified => dateTime()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

/// 📏 14. جدول وحدات القياس للأصناف
class MedicineUnitsTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  RealColumn get buyPrice => real().withDefault(const Constant(0.0))();
  RealColumn get sellPrice => real().withDefault(const Constant(0.0))();
  IntColumn get conversionFactor => integer().withDefault(const Constant(1))();
  IntColumn get syncVersion => integer().withDefault(const Constant(1))();
  DateTimeColumn get lastModified => dateTime()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

/// 📊 15. جدول سجل حر الحركة والتنقلات للمخزون (Inventory Transactions Ledger)
class InventoryTransactionsTable extends Table {
  TextColumn get id => text()();
  TextColumn get medicineId => text()();
  TextColumn get transactionType => text()(); // 'sale', 'purchase', 'adjustment', 'return', 'swap', 'opening'
  TextColumn get referenceId => text()();
  TextColumn get referenceNumber => text().nullable()();
  IntColumn get quantityChange => integer()();
  IntColumn get quantityAfter => integer()();
  RealColumn get unitPrice => real().withDefault(const Constant(0.0))();
  TextColumn get branchId => text().withDefault(const Constant(''))();
  TextColumn get accountId => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get lastModified => dateTime()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  IntColumn get syncVersion => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}


