import 'dart:convert';

import 'package:drift/drift.dart';

import 'package:pharmacy_system/app/core/data/database/tables/inventory_tables.dart';
import 'package:pharmacy_system/app/core/data/mappers/base_mapper.dart';
import 'package:pharmacy_system/app/core/models/inventory/barcode_settings_model.dart';
import 'package:pharmacy_system/app/core/models/inventory/inventory_transaction_model.dart';
import 'package:pharmacy_system/app/core/models/inventory/item_batch_model.dart';
import 'package:pharmacy_system/app/core/models/inventory/item_category_model.dart';
import 'package:pharmacy_system/app/core/models/inventory/item_swap_model.dart';
import 'package:pharmacy_system/app/core/models/inventory/item_variant_model.dart';
import 'package:pharmacy_system/app/core/models/inventory/item_warranty_model.dart';
import 'package:pharmacy_system/app/core/models/inventory/medicine_barcode_model.dart';
import 'package:pharmacy_system/app/core/models/inventory/medicine_brand_model.dart';
import 'package:pharmacy_system/app/core/models/inventory/medicine_model.dart';
import 'package:pharmacy_system/app/core/models/inventory/medicine_unit_model.dart';
import 'package:pharmacy_system/app/core/models/inventory/opening_stock_model.dart';
import 'package:pharmacy_system/app/core/models/inventory/price_group_model.dart';
import 'package:pharmacy_system/app/core/models/inventory/stock_adjustment_model.dart';
import 'package:pharmacy_system/app/core/models/inventory/stocktaking_model.dart';

import '../database/database.dart';

class InventoryMapper {
  // ─── 1. Medicine ────────────────────────────────────────────

  static MedicineModel medicineFromData(MedicinesTableData d) => MedicineModel(
    id: d.id,
    name: d.name,
    nameEn: d.nameEn,
    itemTypes: (jsonDecode(d.itemTypes) as List)
        .map((e) => ItemTypeModel.fromJson(e as Map<String, dynamic>))
        .toList(),
    therapeuticGroup: TherapeuticGroupModel.fromJson(
      jsonDecode(d.therapeuticGroup) as Map<String, dynamic>,
    ),
    supplierId: d.supplierId,
    manufacturer: d.manufacturer,
    barcodes: (jsonDecode(d.barcodes) as List)
        .map((e) => BarcodeModel.fromJson(e as Map<String, dynamic>))
        .toList(),
    dosageForm: d.dosageForm,
    strength: d.strength,
    packageSize: d.packageSize,
    containerShape: d.containerShape,
    location: d.location,
    isTaxable: d.isTaxable,
    taxType: d.taxType,
    taxValue: d.taxValue,
    pricesIncludeTax: d.pricesIncludeTax,
    alertEnabled: d.alertEnabled,
    minStock: d.minStock,
    expiryTrackingEnabled: d.expiryTrackingEnabled,
    expiryDates: d.expiryDates != null
        ? (jsonDecode(d.expiryDates!) as List)
            .map((e) => DateTime.parse(e as String))
            .toList()
        : null,
    allowNegativeStock: d.allowNegativeStock,
    isActive: d.isActive,
    imageUrl: d.imageUrl,
    description: d.description,
    itemLevels: ItemLevelsModel.fromJson(
      jsonDecode(d.itemLevels) as Map<String, dynamic>,
    ),
    accountId: d.accountId,
    branchId: d.branchId,
    syncVersion: d.syncVersion,
    lastModified: d.lastModified,
    isDeleted: d.isDeleted,
  );

  static MedicinesTableCompanion medicineToCompanion(MedicineModel m) =>
      MedicinesTableCompanion(
        id: Value(m.id),
        name: Value(m.name),
        nameEn: Value(m.nameEn),
        itemTypes: Value(
          jsonEncode(m.itemTypes.map((e) => e.toJson()).toList()),
        ),
        therapeuticGroup: Value(jsonEncode(m.therapeuticGroup.toJson())),
        barcodes: Value(
          jsonEncode(m.barcodes.map((e) => e.toJson()).toList()),
        ),
        itemLevels: Value(jsonEncode(m.itemLevels.toJson())),
        expiryDates: Value(
          m.expiryDates != null
              ? jsonEncode(
                  m.expiryDates!.map((e) => e.toIso8601String()).toList())
              : null,
        ),
        supplierId: Value(m.supplierId),
        manufacturer: Value(m.manufacturer),
        dosageForm: Value(m.dosageForm),
        strength: Value(m.strength),
        packageSize: Value(m.packageSize),
        containerShape: Value(m.containerShape),
        location: Value(m.location),
        isTaxable: Value(m.isTaxable),
        taxType: Value(m.taxType),
        taxValue: Value(m.taxValue),
        pricesIncludeTax: Value(m.pricesIncludeTax),
        alertEnabled: Value(m.alertEnabled),
        minStock: Value(m.minStock),
        expiryTrackingEnabled: Value(m.expiryTrackingEnabled),
        allowNegativeStock: Value(m.allowNegativeStock),
        isActive: Value(m.isActive),
        imageUrl: Value(m.imageUrl),
        description: Value(m.description),
        accountId: Value(m.accountId),
        branchId: Value(m.branchId),
        syncVersion: Value(m.syncVersion),
        lastModified: Value(m.lastModified),
        isDeleted: Value(m.isDeleted),
        createdAt: const Value.absent(),
      );

  // ─── 2. ItemBatch ──────────────────────────────────────────

  static ItemBatchModel itemBatchFromData(ItemBatchesTableData d) =>
      ItemBatchModel(
        id: d.id,
        medicineId: d.medicineId,
        batchNumber: d.batchNumber,
        expiryDate: d.expiryDate,
        quantity: d.quantity,
        damagedQuantity: d.damagedQuantity,
        purchasePrice: d.purchasePrice,
        isActive: d.isActive,
        accountId: d.accountId,
        createdAt: d.createdAt,
        lastModified: d.lastModified,
        isDeleted: d.isDeleted,
      );

  static ItemBatchesTableCompanion itemBatchToCompanion(ItemBatchModel m) =>
      ItemBatchesTableCompanion(
        id: Value(m.id),
        medicineId: Value(m.medicineId),
        batchNumber: Value(m.batchNumber),
        expiryDate: Value(m.expiryDate),
        quantity: Value(m.quantity),
        damagedQuantity: Value(m.damagedQuantity),
        purchasePrice: Value(m.purchasePrice),
        isActive: Value(m.isActive),
        accountId: Value(m.accountId),
        branchId: const Value.absent(),
        createdAt: Value(m.createdAt),
        lastModified: Value(m.lastModified),
        isDeleted: Value(m.isDeleted),
        syncVersion: const Value.absent(),
      );

  // ─── 3. ItemCategory ───────────────────────────────────────

  static ItemCategoryModel itemCategoryFromData(ItemCategoriesTableData d) =>
      ItemCategoryModel(
        id: d.id,
        name: d.name,
        code: d.code,
        description: d.description,
        parentId: d.parentId,
        isActive: d.isActive,
        accountId: d.accountId,
        lastModified: d.lastModified,
        isDeleted: d.isDeleted,
      );

  static ItemCategoriesTableCompanion itemCategoryToCompanion(
          ItemCategoryModel m) =>
      ItemCategoriesTableCompanion(
        id: Value(m.id),
        name: Value(m.name),
        code: Value(m.code),
        description: Value(m.description),
        parentId: Value(m.parentId),
        isActive: Value(m.isActive),
        accountId: Value(m.accountId),
        lastModified: Value(m.lastModified),
        isDeleted: Value(m.isDeleted),
        syncVersion: const Value.absent(),
      );

  // ─── 4. MedicineBrand ──────────────────────────────────────

  static MedicineBrandModel medicineBrandFromData(
          MedicineBrandsTableData d) =>
      MedicineBrandModel(
        id: d.id,
        name: d.name,
        description: d.description,
        useForRepair: d.useForRepair,
        isActive: d.isActive,
        accountId: d.accountId,
        lastModified: d.lastModified,
        isDeleted: d.isDeleted,
      );

  static MedicineBrandsTableCompanion medicineBrandToCompanion(
          MedicineBrandModel m) =>
      MedicineBrandsTableCompanion(
        id: Value(m.id),
        name: Value(m.name),
        description: Value(m.description),
        useForRepair: Value(m.useForRepair),
        isActive: Value(m.isActive),
        accountId: Value(m.accountId),
        lastModified: Value(m.lastModified),
        isDeleted: Value(m.isDeleted),
        syncVersion: const Value.absent(),
      );

  // ─── 5. ItemVariant ────────────────────────────────────────

  static ItemVariantModel itemVariantFromData(ItemVariantsTableData d) =>
      ItemVariantModel(
        id: d.id,
        name: d.name,
        values: (jsonDecode(d.values) as List).cast<String>(),
        isActive: d.isActive,
        accountId: d.accountId,
        lastModified: d.lastModified,
        isDeleted: d.isDeleted,
      );

  static ItemVariantsTableCompanion itemVariantToCompanion(
          ItemVariantModel m) =>
      ItemVariantsTableCompanion(
        id: Value(m.id),
        name: Value(m.name),
        values: Value(jsonEncode(m.values)),
        isActive: Value(m.isActive),
        accountId: Value(m.accountId),
        lastModified: Value(m.lastModified),
        isDeleted: Value(m.isDeleted),
        syncVersion: const Value.absent(),
      );

  // ─── 6. ItemWarranty ───────────────────────────────────────

  static ItemWarrantyModel itemWarrantyFromData(ItemWarrantiesTableData d) =>
      ItemWarrantyModel(
        id: d.id,
        name: d.name,
        description: d.description,
        duration: d.duration,
        durationUnit: WarrantyDurationUnit.values.firstWhere(
          (u) => u.name == d.durationUnit,
          orElse: () => WarrantyDurationUnit.year,
        ),
        isActive: d.isActive,
        accountId: d.accountId,
        lastModified: d.lastModified,
        isDeleted: d.isDeleted,
      );

  static ItemWarrantiesTableCompanion itemWarrantyToCompanion(
          ItemWarrantyModel m) =>
      ItemWarrantiesTableCompanion(
        id: Value(m.id),
        name: Value(m.name),
        description: Value(m.description),
        duration: Value(m.duration),
        durationUnit: Value(m.durationUnit.name),
        isActive: Value(m.isActive),
        accountId: Value(m.accountId),
        lastModified: Value(m.lastModified),
        isDeleted: Value(m.isDeleted),
        syncVersion: const Value.absent(),
      );

  // ─── 7. PriceGroup ─────────────────────────────────────────

  static PriceGroupModel priceGroupFromData(PriceGroupsTableData d) =>
      PriceGroupModel(
        id: d.id,
        name: d.name,
        markupPercentage: d.markupPercentage,
        discountPercentage: d.discountPercentage,
        isDefault: d.isDefault,
      );

  static PriceGroupsTableCompanion priceGroupToCompanion(PriceGroupModel m) =>
      PriceGroupsTableCompanion(
        id: Value(m.id),
        name: Value(m.name),
        markupPercentage: Value(m.markupPercentage),
        discountPercentage: Value(m.discountPercentage),
        isDefault: Value(m.isDefault),
        isActive: const Value.absent(),
        accountId: const Value.absent(),
        lastModified: const Value.absent(),
        isDeleted: const Value.absent(),
        syncVersion: const Value.absent(),
      );

  // ─── 8. Stocktaking ────────────────────────────────────────

  static StocktakingModel stocktakingFromData(StocktakingTableData d) =>
      StocktakingModel(
        id: d.id,
        referenceNumber: d.stocktakingNumber,
        stocktakingDate: d.createdAt,
        status: StocktakingStatus.draft,
        totalDifferenceValue: 0.0,
        items: [],
        notes: d.notes,
        createdBy: d.createdBy,
        branchId: d.branchId,
        accountId: d.accountId,
        lastModified: d.lastModified,
        isDeleted: d.isDeleted,
      );

  static StocktakingTableCompanion stocktakingToCompanion(
          StocktakingModel m) =>
      StocktakingTableCompanion(
        id: Value(m.id),
        stocktakingNumber: Value(m.referenceNumber),
        title: const Value.absent(),
        createdBy: Value(m.createdBy),
        branchId: Value(m.branchId),
        accountId: Value(m.accountId),
        notes: Value(m.notes),
        createdAt: Value(m.stocktakingDate),
        lastModified: Value(m.lastModified),
        isDeleted: Value(m.isDeleted),
        syncVersion: const Value.absent(),
      );

  // ─── 9. StockAdjustment ────────────────────────────────────

  static StockAdjustmentModel stockAdjustmentFromData(
          StockAdjustmentsTableData d) =>
      StockAdjustmentModel(
        id: d.id,
        adjustmentNumber: d.adjustmentNumber,
        adjustmentType: AdjustmentType.values.firstWhere(
          (a) => a.name == d.adjustmentType,
          orElse: () => AdjustmentType.damage,
        ),
        items: (jsonDecode(d.items) as List)
            .map(
                (e) => StockAdjustmentItemModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        totalAmount: d.totalAmount,
        adjustedBy: d.adjustedBy,
        branchId: d.branchId,
        accountId: d.accountId,
        notes: d.notes,
        createdAt: d.createdAt,
        lastModified: d.lastModified,
        isDeleted: d.isDeleted,
        syncVersion: d.syncVersion,
      );

  static StockAdjustmentsTableCompanion stockAdjustmentToCompanion(
          StockAdjustmentModel m) =>
      StockAdjustmentsTableCompanion(
        id: Value(m.id),
        adjustmentNumber: Value(m.adjustmentNumber),
        adjustmentType: Value(m.adjustmentType.name),
        items: Value(
          jsonEncode(m.items.map((e) => e.toJson()).toList()),
        ),
        totalAmount: Value(m.totalAmount),
        adjustedBy: Value(m.adjustedBy),
        branchId: Value(m.branchId),
        accountId: Value(m.accountId),
        notes: Value(m.notes),
        createdAt: Value(m.createdAt),
        lastModified: Value(m.lastModified),
        isDeleted: Value(m.isDeleted),
        syncVersion: Value(m.syncVersion),
      );

  // ─── 10. ItemSwap ──────────────────────────────────────────

  static ItemSwapModel itemSwapFromData(ItemSwapsTableData d) {
    final itemsMap = jsonDecode(d.items) as Map<String, dynamic>;
    return ItemSwapModel(
      id: d.id,
      swapNumber: d.swapNumber,
      partyType: d.partyType,
      partyId: d.partyId,
      partyName: d.partyName,
      cashRegisterId: d.cashRegisterId,
      incomingItems: (itemsMap['incoming'] as List)
          .map((e) => SwapItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      outgoingItems: (itemsMap['outgoing'] as List)
          .map((e) => SwapItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalIncomingAmount: d.totalIncomingAmount,
      totalOutgoingAmount: d.totalOutgoingAmount,
      netCashDifference: d.netCashDifference,
      createdBy: d.createdBy,
      branchId: d.branchId,
      accountId: d.accountId,
      notes: d.notes,
      swapDate: d.swapDate,
      lastModified: d.lastModified,
    );
  }

  static ItemSwapsTableCompanion itemSwapToCompanion(ItemSwapModel m) =>
      ItemSwapsTableCompanion(
        id: Value(m.id),
        swapNumber: Value(m.swapNumber),
        partyType: Value(m.partyType),
        partyId: Value(m.partyId),
        partyName: Value(m.partyName),
        cashRegisterId: Value(m.cashRegisterId),
        totalIncomingAmount: Value(m.totalIncomingAmount),
        totalOutgoingAmount: Value(m.totalOutgoingAmount),
        netCashDifference: Value(m.netCashDifference),
        items: Value(jsonEncode({
          'incoming': m.incomingItems.map((e) => e.toJson()).toList(),
          'outgoing': m.outgoingItems.map((e) => e.toJson()).toList(),
        })),
        createdBy: Value(m.createdBy),
        branchId: Value(m.branchId),
        accountId: Value(m.accountId),
        notes: Value(m.notes),
        swapDate: Value(m.swapDate),
        lastModified: Value(m.lastModified),
        isDeleted: const Value.absent(),
        syncVersion: const Value.absent(),
      );

  // ─── 11. OpeningStock ──────────────────────────────────────

  static OpeningStockModel openingStockFromData(OpeningStockTableData d) {
    final itemsList = jsonDecode(d.items) as List;
    if (itemsList.isEmpty) {
      return OpeningStockModel(
        id: d.id,
        medicineId: '',
        medicineName: '',
        unit1Quantity: 0,
        buyPrice: 0.0,
        branchId: d.branchId,
        recordedBy: d.createdBy,
        recordedAt: d.createdAt,
        lastModified: d.lastModified,
      );
    }
    final item = itemsList.first as Map<String, dynamic>;
    return OpeningStockModel(
      id: d.id,
      medicineId: item['medicine_id'] as String? ?? '',
      medicineName: item['medicine_name'] as String? ?? '',
      unit1Quantity: (item['unit1_quantity'] as num?)?.toInt() ?? 0,
      unit2Quantity: (item['unit2_quantity'] as num?)?.toInt(),
      unit3Quantity: (item['unit3_quantity'] as num?)?.toInt(),
      buyPrice: (item['buy_price'] as num?)?.toDouble() ?? 0.0,
      branchId: d.branchId,
      recordedBy: d.createdBy,
      recordedAt: d.createdAt,
      lastModified: d.lastModified,
    );
  }

  static OpeningStockTableCompanion openingStockToCompanion(
          OpeningStockModel m) =>
      OpeningStockTableCompanion(
        id: Value(m.id),
        voucherNumber: const Value.absent(),
        items: Value(jsonEncode([
          {
            'medicine_id': m.medicineId,
            'medicine_name': m.medicineName,
            'unit1_quantity': m.unit1Quantity,
            'unit2_quantity': m.unit2Quantity,
            'unit3_quantity': m.unit3Quantity,
            'buy_price': m.buyPrice,
          }
        ])),
        createdBy: Value(m.recordedBy),
        branchId: Value(m.branchId),
        accountId: const Value.absent(),
        notes: const Value.absent(),
        createdAt: Value(m.recordedAt),
        lastModified: Value(m.lastModified),
        isDeleted: const Value.absent(),
        syncVersion: const Value.absent(),
      );

  // ─── 12. BarcodeSettings ───────────────────────────────────

  static BarcodeSettingsModel barcodeSettingsFromData(
          BarcodeSettingsTableData d) =>
      BarcodeSettingsModel(
        id: d.id,
        prefix: d.prefix,
        labelWidthMm: d.labelWidthMm,
        labelHeightMm: d.labelHeightMm,
        copiesPerItem: d.copiesPerItem,
        showPrice: d.showPrice,
        showItemName: d.showItemName,
        showUnitName: d.showUnitName,
        showPharmacyName: d.showPharmacyName,
        pharmacyName: d.pharmacyName,
        showExpiry: d.showExpiry,
        showBatch: d.showBatch,
        printLayout: BarcodePrintLayout.values.firstWhere(
          (l) => l.name == d.printLayout,
          orElse: () => BarcodePrintLayout.labelPrinter,
        ),
        directPrint: d.directPrint,
        printerName: d.printerName,
        accountId: d.accountId,
        lastModified: d.lastModified,
      );

  static BarcodeSettingsTableCompanion barcodeSettingsToCompanion(
          BarcodeSettingsModel m) =>
      BarcodeSettingsTableCompanion(
        id: Value(m.id),
        prefix: Value(m.prefix),
        labelWidthMm: Value(m.labelWidthMm),
        labelHeightMm: Value(m.labelHeightMm),
        copiesPerItem: Value(m.copiesPerItem),
        showPrice: Value(m.showPrice),
        showItemName: Value(m.showItemName),
        showUnitName: Value(m.showUnitName),
        showPharmacyName: Value(m.showPharmacyName),
        pharmacyName: Value(m.pharmacyName),
        showExpiry: Value(m.showExpiry),
        showBatch: Value(m.showBatch),
        printLayout: Value(m.printLayout.name),
        directPrint: Value(m.directPrint),
        printerName: Value(m.printerName),
        accountId: Value(m.accountId),
        lastModified: Value(m.lastModified),
        isDeleted: const Value.absent(),
        syncVersion: const Value.absent(),
      );

  // ─── 13. MedicineBarcode ───────────────────────────────────

  static MedicineBarcodeModel medicineBarcodeFromData(
          MedicineBarcodesTableData d) =>
      MedicineBarcodeModel(
        id: d.id,
        medicineId: d.medicineId,
        barcode: d.barcode,
        isPrimary: d.isPrimary,
        description: d.description,
        createdAt: d.createdAt,
      );

  static MedicineBarcodesTableCompanion medicineBarcodeToCompanion(
          MedicineBarcodeModel m) =>
      MedicineBarcodesTableCompanion(
        id: Value(m.id),
        medicineId: Value(m.medicineId),
        barcode: Value(m.barcode),
        isPrimary: Value(m.isPrimary),
        description: Value(m.description),
        createdAt: Value(m.createdAt),
        syncVersion: const Value.absent(),
        lastModified: const Value.absent(),
        isDeleted: const Value.absent(),
      );

  // ─── 14. MedicineUnit ──────────────────────────────────────

  static MedicineUnitModel medicineUnitFromData(MedicineUnitsTableData d) =>
      MedicineUnitModel(
        id: d.id,
        name: d.name,
        buyPrice: d.buyPrice,
        sellPrice: d.sellPrice,
        conversionFactor: d.conversionFactor,
      );

  static MedicineUnitsTableCompanion medicineUnitToCompanion(
          MedicineUnitModel m) =>
      MedicineUnitsTableCompanion(
        id: Value(m.id),
        name: Value(m.name),
        buyPrice: Value(m.buyPrice),
        sellPrice: Value(m.sellPrice),
        conversionFactor: Value(m.conversionFactor),
        syncVersion: const Value.absent(),
        lastModified: const Value.absent(),
        isDeleted: const Value.absent(),
      );

  // ─── 15. InventoryTransaction ──────────────────────────────

  static InventoryTransactionModel inventoryTransactionFromData(
          InventoryTransactionsTableData d) =>
      InventoryTransactionModel(
        id: d.id,
        medicineId: d.medicineId,
        transactionType: d.transactionType,
        referenceId: d.referenceId,
        referenceNumber: d.referenceNumber,
        quantityChange: d.quantityChange,
        quantityAfter: d.quantityAfter,
        unitPrice: d.unitPrice,
        branchId: d.branchId,
        accountId: d.accountId,
        createdAt: d.createdAt,
        lastModified: d.lastModified,
        isDeleted: d.isDeleted,
        syncVersion: d.syncVersion,
      );

  static InventoryTransactionsTableCompanion inventoryTransactionToCompanion(
          InventoryTransactionModel m) =>
      InventoryTransactionsTableCompanion(
        id: Value(m.id),
        medicineId: Value(m.medicineId),
        transactionType: Value(m.transactionType),
        referenceId: Value(m.referenceId),
        referenceNumber: Value(m.referenceNumber),
        quantityChange: Value(m.quantityChange),
        quantityAfter: Value(m.quantityAfter),
        unitPrice: Value(m.unitPrice),
        branchId: Value(m.branchId),
        accountId: Value(m.accountId),
        createdAt: Value(m.createdAt),
        lastModified: Value(m.lastModified),
        isDeleted: Value(m.isDeleted),
        syncVersion: Value(m.syncVersion),
      );
}
