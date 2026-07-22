import 'package:drift/drift.dart';

class MedicinesTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get nameEn => text().nullable()();
  TextColumn get category => text().nullable()();
  TextColumn get barcodes => text()();
  RealColumn get buyPrice => real()();
  RealColumn get sellPrice => real()();
  IntColumn get quantity => integer()();
  IntColumn get minStock => integer()();
  DateTimeColumn get expiryDate => dateTime().nullable()();
  TextColumn get manufacturer => text().nullable()();
  TextColumn get branchId => text()();
  IntColumn get syncVersion => integer()();
  DateTimeColumn get lastModified => dateTime()();
  BoolColumn get isDeleted => boolean()();
  TextColumn get dosageForm => text().nullable()();
  TextColumn get strength => text().nullable()();
  TextColumn get packageSize => text().nullable()();
  BoolColumn get expiryTrackingEnabled => boolean()();
  TextColumn get supplierName => text().nullable()();
  TextColumn get description => text().nullable()();
  RealColumn get oldSellPrice => real().nullable()();
  TextColumn get itemTypeId => text().nullable()();
  TextColumn get groupId => text().nullable()();
  TextColumn get units => text()();
  BoolColumn get alertEnabled => boolean()();
  BoolColumn get dosageFormEnabled => boolean()();
  TextColumn get imageUrl => text().nullable()();
  TextColumn get containerShape => text().nullable()();
  BoolColumn get allowNegativeStock => boolean()();
  BoolColumn get isTaxable => boolean()();
  TextColumn get taxType => text().nullable()();
  RealColumn get taxValue => real().nullable()();
  BoolColumn get pricesIncludeTax => boolean()();
  TextColumn get location => text().nullable()();
  BoolColumn get isActive => boolean()();
  DateTimeColumn get createdAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class MedicineUnitsTable extends Table {
  TextColumn get id => text()();
  TextColumn get medicineId => text()();
  TextColumn get name => text()();
  IntColumn get level => integer()();
  RealColumn get conversionFactor => real()();
  RealColumn get buyPrice => real()();
  RealColumn get sellPrice => real()();
  RealColumn get oldSellPrice => real().nullable()();
  RealColumn get discountPercent => real().nullable()();
  BoolColumn get allowSale => boolean()();
  IntColumn get quantity => integer()();
  TextColumn get barcode => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class ItemBatchesTable extends Table {
  TextColumn get id => text()();
  TextColumn get medicineId => text()();
  TextColumn get batchNumber => text().nullable()();
  DateTimeColumn get expiryDate => dateTime().nullable()();
  IntColumn get quantity => integer()();
  IntColumn get damagedQuantity => integer()();
  RealColumn get purchasePrice => real().nullable()();
  BoolColumn get isActive => boolean()();
  BoolColumn get isDeleted => boolean()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class StocktakingTable extends Table {
  TextColumn get id => text()();
  TextColumn get branchId => text()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime().nullable()();
  TextColumn get status => text()();
  TextColumn get notes => text().nullable()();
  TextColumn get createdBy => text()();
  IntColumn get syncVersion => integer()();
  DateTimeColumn get lastModified => dateTime()();
  BoolColumn get isDeleted => boolean()();

  @override
  Set<Column> get primaryKey => {id};
}

class StocktakingItemsTable extends Table {
  TextColumn get id => text()();
  TextColumn get stocktakingId => text()();
  TextColumn get medicineId => text()();
  TextColumn get medicineName => text()();
  IntColumn get systemQuantity => integer()();
  IntColumn get countedQuantity => integer()();
  IntColumn get difference => integer()();
  TextColumn get notes => text().nullable()();
  IntColumn get syncVersion => integer()();
  DateTimeColumn get lastModified => dateTime()();
  BoolColumn get isDeleted => boolean()();

  @override
  Set<Column> get primaryKey => {id};
}
