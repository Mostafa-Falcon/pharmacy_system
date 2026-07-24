// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_dao.dart';

// ignore_for_file: type=lint
mixin _$InventoryDaoMixin on DatabaseAccessor<AppDatabase> {
  $MedicinesTableTable get medicinesTable => attachedDatabase.medicinesTable;
  $ItemBatchesTableTable get itemBatchesTable =>
      attachedDatabase.itemBatchesTable;
  $ItemCategoriesTableTable get itemCategoriesTable =>
      attachedDatabase.itemCategoriesTable;
  $MedicineBrandsTableTable get medicineBrandsTable =>
      attachedDatabase.medicineBrandsTable;
  $ItemVariantsTableTable get itemVariantsTable =>
      attachedDatabase.itemVariantsTable;
  $ItemWarrantiesTableTable get itemWarrantiesTable =>
      attachedDatabase.itemWarrantiesTable;
  $PriceGroupsTableTable get priceGroupsTable =>
      attachedDatabase.priceGroupsTable;
  $StocktakingTableTable get stocktakingTable =>
      attachedDatabase.stocktakingTable;
  $StockAdjustmentsTableTable get stockAdjustmentsTable =>
      attachedDatabase.stockAdjustmentsTable;
  $ItemSwapsTableTable get itemSwapsTable => attachedDatabase.itemSwapsTable;
  $OpeningStockTableTable get openingStockTable =>
      attachedDatabase.openingStockTable;
  $BarcodeSettingsTableTable get barcodeSettingsTable =>
      attachedDatabase.barcodeSettingsTable;
  $InventoryTransactionsTableTable get inventoryTransactionsTable =>
      attachedDatabase.inventoryTransactionsTable;
  InventoryDaoManager get managers => InventoryDaoManager(this);
}

class InventoryDaoManager {
  final _$InventoryDaoMixin _db;
  InventoryDaoManager(this._db);
  $$MedicinesTableTableTableManager get medicinesTable =>
      $$MedicinesTableTableTableManager(
        _db.attachedDatabase,
        _db.medicinesTable,
      );
  $$ItemBatchesTableTableTableManager get itemBatchesTable =>
      $$ItemBatchesTableTableTableManager(
        _db.attachedDatabase,
        _db.itemBatchesTable,
      );
  $$ItemCategoriesTableTableTableManager get itemCategoriesTable =>
      $$ItemCategoriesTableTableTableManager(
        _db.attachedDatabase,
        _db.itemCategoriesTable,
      );
  $$MedicineBrandsTableTableTableManager get medicineBrandsTable =>
      $$MedicineBrandsTableTableTableManager(
        _db.attachedDatabase,
        _db.medicineBrandsTable,
      );
  $$ItemVariantsTableTableTableManager get itemVariantsTable =>
      $$ItemVariantsTableTableTableManager(
        _db.attachedDatabase,
        _db.itemVariantsTable,
      );
  $$ItemWarrantiesTableTableTableManager get itemWarrantiesTable =>
      $$ItemWarrantiesTableTableTableManager(
        _db.attachedDatabase,
        _db.itemWarrantiesTable,
      );
  $$PriceGroupsTableTableTableManager get priceGroupsTable =>
      $$PriceGroupsTableTableTableManager(
        _db.attachedDatabase,
        _db.priceGroupsTable,
      );
  $$StocktakingTableTableTableManager get stocktakingTable =>
      $$StocktakingTableTableTableManager(
        _db.attachedDatabase,
        _db.stocktakingTable,
      );
  $$StockAdjustmentsTableTableTableManager get stockAdjustmentsTable =>
      $$StockAdjustmentsTableTableTableManager(
        _db.attachedDatabase,
        _db.stockAdjustmentsTable,
      );
  $$ItemSwapsTableTableTableManager get itemSwapsTable =>
      $$ItemSwapsTableTableTableManager(
        _db.attachedDatabase,
        _db.itemSwapsTable,
      );
  $$OpeningStockTableTableTableManager get openingStockTable =>
      $$OpeningStockTableTableTableManager(
        _db.attachedDatabase,
        _db.openingStockTable,
      );
  $$BarcodeSettingsTableTableTableManager get barcodeSettingsTable =>
      $$BarcodeSettingsTableTableTableManager(
        _db.attachedDatabase,
        _db.barcodeSettingsTable,
      );
  $$InventoryTransactionsTableTableTableManager
  get inventoryTransactionsTable =>
      $$InventoryTransactionsTableTableTableManager(
        _db.attachedDatabase,
        _db.inventoryTransactionsTable,
      );
}
