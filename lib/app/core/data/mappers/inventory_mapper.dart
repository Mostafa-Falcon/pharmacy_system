import 'dart:convert';
import 'package:drift/drift.dart';
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
  // ─── Medicine ───
  static MedicineModel medicineFromData(MedicinesTableData d) => MedicineModel.fromJson({
    'id': d.id,
    'name': d.name,
    'name_en': d.nameEn,
    'item_types': jsonDecode(d.itemTypes),
    'therapeutic_group': jsonDecode(d.therapeuticGroup),
    'barcodes': jsonDecode(d.barcodes),
    'item_levels': jsonDecode(d.itemLevels),
    'expiry_dates': d.expiryDates != null ? jsonDecode(d.expiryDates!) : null,
    'supplier_id': d.supplierId,
    'manufacturer': d.manufacturer,
    'dosage_form': d.dosageForm,
    'strength': d.strength,
    'package_size': d.packageSize,
    'container_shape': d.containerShape,
    'location': d.location,
    'is_taxable': d.isTaxable,
    'tax_type': d.taxType,
    'tax_value': d.taxValue,
    'prices_include_tax': d.pricesIncludeTax,
    'alert_enabled': d.alertEnabled,
    'min_stock': d.minStock,
    'expiry_tracking_enabled': d.expiryTrackingEnabled,
    'allow_negative_stock': d.allowNegativeStock,
    'is_active': d.isActive,
    'image_url': d.imageUrl,
    'description': d.description,
    'account_id': d.accountId,
    'branch_id': d.branchId,
    'sync_version': d.syncVersion,
    'last_modified': d.lastModified.toIso8601String(),
    'is_deleted': d.isDeleted,
    'created_at': d.createdAt.toIso8601String(),
  });

  static MedicinesTableCompanion medicineToCompanion(MedicineModel m) {
    final json = m.toJson();
    return MedicinesTableCompanion(
      id: Value(m.id),
      name: Value(m.name),
      nameEn: Value(m.nameEn),
      itemTypes: Value(jsonEncode(json['item_types'])),
      therapeuticGroup: Value(jsonEncode(json['therapeutic_group'])),
      barcodes: Value(jsonEncode(json['barcodes'])),
      itemLevels: Value(jsonEncode(json['item_levels'])),
      expiryDates: m.expiryDates != null ? Value(jsonEncode(json['expiry_dates'])) : const Value.absent(),
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
      createdAt: Value(m.createdAt),
    );
  }

  // ─── ItemBatch ───
  static ItemBatchModel itemBatchFromData(ItemBatchesTableData d) => ItemBatchModel(
    id: d.id,
    medicineId: d.medicineId,
    batchNumber: d.batchNumber,
    expiryDate: d.expiryDate,
    quantity: d.quantity,
    damagedQuantity: d.damagedQuantity,
    purchasePrice: d.purchasePrice ?? 0.0,
    isActive: d.isActive,
    accountId: d.accountId,
    createdAt: d.createdAt,
    lastModified: d.lastModified,
    isDeleted: d.isDeleted,
  );

  static ItemBatchesTableCompanion itemBatchToCompanion(ItemBatchModel m) => ItemBatchesTableCompanion(
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
    syncVersion: const Value(1),
  );

  // ─── ItemCategory ───
  static ItemCategoryModel itemCategoryFromData(ItemCategoriesTableData d) => ItemCategoryModel(
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

  static ItemCategoriesTableCompanion itemCategoryToCompanion(ItemCategoryModel m) => ItemCategoriesTableCompanion(
    id: Value(m.id),
    name: Value(m.name),
    code: Value(m.code),
    description: Value(m.description),
    parentId: Value(m.parentId),
    isActive: Value(m.isActive),
    accountId: Value(m.accountId),
    lastModified: Value(m.lastModified),
    isDeleted: Value(m.isDeleted),
  );

  // ─── MedicineBrand ───
  static MedicineBrandModel medicineBrandFromData(MedicineBrandsTableData d) => MedicineBrandModel(
    id: d.id,
    name: d.name,
    description: d.description,
    useForRepair: d.useForRepair,
    isActive: d.isActive,
    accountId: d.accountId,
    lastModified: d.lastModified,
    isDeleted: d.isDeleted,
  );

  static MedicineBrandsTableCompanion medicineBrandToCompanion(MedicineBrandModel m) => MedicineBrandsTableCompanion(
    id: Value(m.id),
    name: Value(m.name),
    description: Value(m.description),
    useForRepair: Value(m.useForRepair),
    isActive: Value(m.isActive),
    accountId: Value(m.accountId),
    lastModified: Value(m.lastModified),
    isDeleted: Value(m.isDeleted),
  );

  // ─── ItemVariant ───
  static ItemVariantModel itemVariantFromData(ItemVariantsTableData d) => ItemVariantModel(
    id: d.id,
    name: d.name,
    values: (jsonDecode(d.values) as List).cast<String>(),
    isActive: d.isActive,
    accountId: d.accountId,
    lastModified: d.lastModified,
    isDeleted: d.isDeleted,
  );

  static ItemVariantsTableCompanion itemVariantToCompanion(ItemVariantModel m) => ItemVariantsTableCompanion(
    id: Value(m.id),
    name: Value(m.name),
    values: Value(jsonEncode(m.values)),
    isActive: Value(m.isActive),
    accountId: Value(m.accountId),
    lastModified: Value(m.lastModified),
    isDeleted: Value(m.isDeleted),
  );

  // ─── ItemWarranty ───
  static ItemWarrantyModel itemWarrantyFromData(ItemWarrantiesTableData d) => ItemWarrantyModel(
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

  static ItemWarrantiesTableCompanion itemWarrantyToCompanion(ItemWarrantyModel m) => ItemWarrantiesTableCompanion(
    id: Value(m.id),
    name: Value(m.name),
    description: Value(m.description),
    duration: Value(m.duration),
    durationUnit: Value(m.durationUnit.name),
    isActive: Value(m.isActive),
    accountId: Value(m.accountId),
    lastModified: Value(m.lastModified),
    isDeleted: Value(m.isDeleted),
  );

  // ─── PriceGroup ───
  static PriceGroupModel priceGroupFromData(PriceGroupsTableData d) => PriceGroupModel(
    id: d.id,
    name: d.name,
    markupPercentage: d.markupPercentage,
    discountPercentage: d.discountPercentage,
    isDefault: d.isDefault,
  );

  static PriceGroupsTableCompanion priceGroupToCompanion(PriceGroupModel m) => PriceGroupsTableCompanion(
    id: Value(m.id),
    name: Value(m.name),
    markupPercentage: Value(m.markupPercentage),
    discountPercentage: Value(m.discountPercentage),
    isDefault: Value(m.isDefault),
  );

  // ─── Stocktaking ───
  static StocktakingModel stocktakingFromData(StocktakingTableData d) {
    final itemsList = (jsonDecode(d.items) as List<dynamic>?)
            ?.map((e) => StocktakingItemModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    return StocktakingModel(
      id: d.id,
      referenceNumber: d.stocktakingNumber,
      stocktakingDate: d.createdAt,
      status: d.status == 'confirmed'
          ? StocktakingStatus.confirmed
          : StocktakingStatus.draft,
      totalDifferenceValue: d.totalDifferenceValue,
      categoryId: d.categoryId,
      brandId: d.brandId,
      items: itemsList,
      notes: d.notes,
      createdBy: d.createdBy,
      branchId: d.branchId,
      accountId: d.accountId,
      lastModified: d.lastModified,
      isDeleted: d.isDeleted,
    );
  }

  static StocktakingTableCompanion stocktakingToCompanion(StocktakingModel m) {
    return StocktakingTableCompanion(
      id: Value(m.id),
      stocktakingNumber: Value(m.referenceNumber),
      title: Value(m.referenceNumber),
      status: Value(m.status.name),
      totalDifferenceValue: Value(m.totalDifferenceValue),
      categoryId: Value(m.categoryId),
      brandId: Value(m.brandId),
      items: Value(jsonEncode(m.items.map((i) => i.toJson()).toList())),
      createdBy: Value(m.createdBy),
      branchId: Value(m.branchId),
      accountId: Value(m.accountId),
      notes: Value(m.notes),
      createdAt: Value(m.stocktakingDate),
      lastModified: Value(m.lastModified),
      isDeleted: Value(m.isDeleted),
      syncVersion: const Value(1),
    );
  }

  // ─── StockAdjustment ───
  static StockAdjustmentModel stockAdjustmentFromData(StockAdjustmentsTableData d) => StockAdjustmentModel.fromJson({
    'id': d.id,
    'adjustment_number': d.adjustmentNumber,
    'adjustment_type': d.adjustmentType,
    'items': jsonDecode(d.items),
    'total_amount': d.totalAmount,
    'adjusted_by': d.adjustedBy,
    'branch_id': d.branchId,
    'account_id': d.accountId,
    'notes': d.notes,
    'created_at': d.createdAt.toIso8601String(),
    'last_modified': d.lastModified.toIso8601String(),
    'is_deleted': d.isDeleted,
  });

  static StockAdjustmentsTableCompanion stockAdjustmentToCompanion(StockAdjustmentModel m) {
    final json = m.toJson();
    return StockAdjustmentsTableCompanion(
      id: Value(m.id),
      adjustmentNumber: Value(m.adjustmentNumber),
      adjustmentType: Value(m.adjustmentType.name),
      items: Value(jsonEncode(json['items'])),
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
  }

  // ─── ItemSwap ───
  static ItemSwapModel itemSwapFromData(ItemSwapsTableData d) {
    Map<String, dynamic> itemsMap = {};
    try { itemsMap = jsonDecode(d.items) as Map<String, dynamic>; } catch (_) {}
    return ItemSwapModel(
      id: d.id,
      swapNumber: d.swapNumber,
      partyType: d.partyType,
      partyId: d.partyId,
      partyName: d.partyName,
      cashRegisterId: d.cashRegisterId,
      incomingItems: (itemsMap['incoming_items'] as List<dynamic>?)
          ?.map((e) => SwapItemModel.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      outgoingItems: (itemsMap['outgoing_items'] as List<dynamic>?)
          ?.map((e) => SwapItemModel.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
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

  static ItemSwapsTableCompanion itemSwapToCompanion(ItemSwapModel m) {
    final itemsMap = {
      'incoming_items': m.incomingItems.map((i) => i.toJson()).toList(),
      'outgoing_items': m.outgoingItems.map((i) => i.toJson()).toList(),
    };
    return ItemSwapsTableCompanion(
      id: Value(m.id),
      swapNumber: Value(m.swapNumber),
      partyType: Value(m.partyType),
      partyId: Value(m.partyId),
      partyName: Value(m.partyName),
      cashRegisterId: Value(m.cashRegisterId),
      totalIncomingAmount: Value(m.totalIncomingAmount),
      totalOutgoingAmount: Value(m.totalOutgoingAmount),
      netCashDifference: Value(m.netCashDifference),
      items: Value(jsonEncode(itemsMap)),
      createdBy: Value(m.createdBy),
      branchId: Value(m.branchId),
      accountId: Value(m.accountId),
      notes: Value(m.notes),
      swapDate: Value(m.swapDate),
      lastModified: Value(m.lastModified),
      isDeleted: const Value(false),
      syncVersion: const Value(1),
    );
  }

  // ─── OpeningStock ───
  static OpeningStockModel openingStockFromData(OpeningStockTableData d) {
    final itemsList = (jsonDecode(d.items) as List<dynamic>?) ?? [];
    if (itemsList.isEmpty) {
      return OpeningStockModel(
        id: d.id, medicineId: '', medicineName: '',
        unit1Quantity: 0, buyPrice: 0, branchId: d.branchId,
        recordedBy: d.createdBy, recordedAt: d.createdAt,
        lastModified: d.lastModified,
      );
    }
    final first = itemsList.first as Map<String, dynamic>;
    return OpeningStockModel(
      id: d.id,
      medicineId: first['medicine_id'] as String? ?? '',
      medicineName: first['medicine_name'] as String? ?? '',
      unit1Quantity: (first['unit_1_quantity'] as num?)?.toInt() ?? 0,
      unit2Quantity: (first['unit_2_quantity'] as num?)?.toInt(),
      unit3Quantity: (first['unit_3_quantity'] as num?)?.toInt(),
      buyPrice: (first['buy_price'] as num?)?.toDouble() ?? 0,
      branchId: d.branchId,
      recordedBy: d.createdBy,
      recordedAt: d.createdAt,
      lastModified: d.lastModified,
    );
  }

  static OpeningStockTableCompanion openingStockToCompanion(OpeningStockModel m) {
    final itemsArray = [
      {
        'medicine_id': m.medicineId,
        'medicine_name': m.medicineName,
        'unit_1_quantity': m.unit1Quantity,
        'unit_2_quantity': m.unit2Quantity,
        'unit_3_quantity': m.unit3Quantity,
        'buy_price': m.buyPrice,
      },
    ];
    return OpeningStockTableCompanion(
      id: Value(m.id),
      voucherNumber: Value(m.id),
      items: Value(jsonEncode(itemsArray)),
      createdBy: Value(m.recordedBy),
      branchId: Value(m.branchId),
      accountId: const Value.absent(),
      notes: const Value.absent(),
      createdAt: Value(m.recordedAt),
      lastModified: Value(m.lastModified),
      isDeleted: const Value(false),
      syncVersion: const Value(1),
    );
  }

  // ─── InventoryTransaction ───
  static InventoryTransactionModel inventoryTransactionFromData(InventoryTransactionsTableData d) => InventoryTransactionModel(
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
  );

  static InventoryTransactionsTableCompanion inventoryTransactionToCompanion(InventoryTransactionModel m) => InventoryTransactionsTableCompanion(
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

  // ─── BarcodeSettings ───
  static BarcodeSettingsModel barcodeSettingsFromData(BarcodeSettingsTableData d) => BarcodeSettingsModel(
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

  static BarcodeSettingsTableCompanion barcodeSettingsToCompanion(BarcodeSettingsModel m) => BarcodeSettingsTableCompanion(
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
    isDeleted: const Value(false),
    syncVersion: const Value(1),
  );

  // ─── MedicineBarcode ───
  static MedicineBarcodeModel medicineBarcodeFromData(MedicineBarcodesTableData d) => MedicineBarcodeModel(
    id: d.id,
    medicineId: d.medicineId,
    barcode: d.barcode,
    isPrimary: d.isPrimary,
    description: d.description,
    createdAt: d.createdAt,
  );

  static MedicineBarcodesTableCompanion medicineBarcodeToCompanion(MedicineBarcodeModel m) => MedicineBarcodesTableCompanion(
    id: Value(m.id),
    medicineId: Value(m.medicineId),
    barcode: Value(m.barcode),
    isPrimary: Value(m.isPrimary),
    description: Value(m.description),
    createdAt: Value(m.createdAt),
    lastModified: Value(m.createdAt),
    isDeleted: const Value(false),
    syncVersion: const Value(1),
  );

  // ─── MedicineUnit ───
  static MedicineUnitModel medicineUnitFromData(MedicineUnitsTableData d) => MedicineUnitModel(
    id: d.id,
    name: d.name,
    buyPrice: d.buyPrice,
    sellPrice: d.sellPrice,
    conversionFactor: d.conversionFactor,
  );

  static MedicineUnitsTableCompanion medicineUnitToCompanion(MedicineUnitModel m) => MedicineUnitsTableCompanion(
    id: Value(m.id),
    name: Value(m.name),
    buyPrice: Value(m.buyPrice),
    sellPrice: Value(m.sellPrice),
    conversionFactor: Value(m.conversionFactor),
    lastModified: Value(DateTime.now()),
    isDeleted: const Value(false),
    syncVersion: const Value(1),
  );
}
