import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:pharmacy_system/app/core/models/inventory/inventory_transaction_model.dart';
import 'package:pharmacy_system/app/core/models/inventory/item_batch_model.dart';
import 'package:pharmacy_system/app/core/models/inventory/item_category_model.dart';
import 'package:pharmacy_system/app/core/models/inventory/item_swap_model.dart';
import 'package:pharmacy_system/app/core/models/inventory/item_variant_model.dart';
import 'package:pharmacy_system/app/core/models/inventory/item_warranty_model.dart';
import 'package:pharmacy_system/app/core/models/inventory/medicine_brand_model.dart';
import 'package:pharmacy_system/app/core/models/inventory/medicine_model.dart';
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
      createdAt: Value(m.lastModified), // Fallback
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
    syncVersion: d.syncVersion,
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
    syncVersion: Value(m.syncVersion),
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
    syncVersion: d.syncVersion,
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
    syncVersion: Value(m.syncVersion),
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
    syncVersion: d.syncVersion,
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
    syncVersion: Value(m.syncVersion),
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
    syncVersion: d.syncVersion,
  );

  static ItemVariantsTableCompanion itemVariantToCompanion(ItemVariantModel m) => ItemVariantsTableCompanion(
    id: Value(m.id),
    name: Value(m.name),
    values: Value(jsonEncode(m.values)),
    isActive: Value(m.isActive),
    accountId: Value(m.accountId),
    lastModified: Value(m.lastModified),
    isDeleted: Value(m.isDeleted),
    syncVersion: Value(m.syncVersion),
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
    syncVersion: d.syncVersion,
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
    syncVersion: Value(m.syncVersion),
  );

  // ─── PriceGroup ───
  static PriceGroupModel priceGroupFromData(PriceGroupsTableData d) => PriceGroupModel(
    id: d.id,
    name: d.name,
    markupPercentage: d.markupPercentage,
    discountPercentage: d.discountPercentage,
    isDefault: d.isDefault,
    isActive: d.isActive,
    accountId: d.accountId,
    lastModified: d.lastModified,
    isDeleted: d.isDeleted,
    syncVersion: d.syncVersion,
  );

  static PriceGroupsTableCompanion priceGroupToCompanion(PriceGroupModel m) => PriceGroupsTableCompanion(
    id: Value(m.id),
    name: Value(m.name),
    markupPercentage: Value(m.markupPercentage),
    discountPercentage: Value(m.discountPercentage),
    isDefault: Value(m.isDefault),
    isActive: Value(m.isActive),
    accountId: Value(m.accountId),
    lastModified: Value(m.lastModified),
    isDeleted: Value(m.isDeleted),
    syncVersion: Value(m.syncVersion),
  );

  // ─── Stocktaking ───
  static StocktakingModel stocktakingFromData(StocktakingTableData d) => StocktakingModel.fromJson({
    'id': d.id,
    'reference_number': d.stocktakingNumber,
    'title': d.title,
    'created_by': d.createdBy,
    'branch_id': d.branchId,
    'account_id': d.accountId,
    'notes': d.notes,
    'created_at': d.createdAt.toIso8601String(),
    'status': 'draft', // Needs update in table if needed
    'items': [], // Separate load or JSON column? Currently Table shows no items column
    'last_modified': d.lastModified.toIso8601String(),
    'is_deleted': d.isDeleted,
    'sync_version': d.syncVersion,
  });

  static StocktakingTableCompanion stocktakingToCompanion(StocktakingModel m) => StocktakingTableCompanion(
    id: Value(m.id),
    stocktakingNumber: Value(m.referenceNumber),
    title: Value(m.title),
    createdBy: Value(m.createdBy),
    branchId: Value(m.branchId),
    accountId: Value(m.accountId),
    notes: Value(m.notes),
    createdAt: Value(m.stocktakingDate),
    lastModified: Value(m.lastModified),
    isDeleted: Value(m.isDeleted),
    syncVersion: Value(m.syncVersion),
  );

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
    'sync_version': d.syncVersion,
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
  static ItemSwapModel itemSwapFromData(ItemSwapsTableData d) => ItemSwapModel.fromJson({
    'id': d.id,
    'swap_number': d.swapNumber,
    'party_type': d.partyType,
    'party_id': d.partyId,
    'party_name': d.partyName,
    'cash_register_id': d.cashRegisterId,
    'items': jsonDecode(d.items),
    'total_incoming_amount': d.totalIncomingAmount,
    'total_outgoing_amount': d.totalOutgoingAmount,
    'net_cash_difference': d.netCashDifference,
    'created_by': d.createdBy,
    'branch_id': d.branchId,
    'account_id': d.accountId,
    'notes': d.notes,
    'swap_date': d.swapDate.toIso8601String(),
    'last_modified': d.lastModified.toIso8601String(),
    'is_deleted': d.isDeleted,
    'sync_version': d.syncVersion,
  });

  static ItemSwapsTableCompanion itemSwapToCompanion(ItemSwapModel m) {
    final json = m.toJson();
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
      items: Value(jsonEncode(json['items'])),
      createdBy: Value(m.createdBy),
      branchId: Value(m.branchId),
      accountId: Value(m.accountId),
      notes: Value(m.notes),
      swapDate: Value(m.swapDate),
      lastModified: Value(m.lastModified),
      isDeleted: Value(m.isDeleted),
      syncVersion: Value(m.syncVersion),
    );
  }

  // ─── OpeningStock ───
  static OpeningStockModel openingStockFromData(OpeningStockTableData d) => OpeningStockModel.fromJson({
    'id': d.id,
    'voucher_number': d.voucherNumber,
    'items': jsonDecode(d.items),
    'created_by': d.createdBy,
    'branch_id': d.branchId,
    'account_id': d.accountId,
    'notes': d.notes,
    'created_at': d.createdAt.toIso8601String(),
    'last_modified': d.lastModified.toIso8601String(),
    'is_deleted': d.isDeleted,
    'sync_version': d.syncVersion,
  });

  static OpeningStockTableCompanion openingStockToCompanion(OpeningStockModel m) {
    final json = m.toJson();
    return OpeningStockTableCompanion(
      id: Value(m.id),
      voucherNumber: Value(m.id), // Placeholder
      items: Value(jsonEncode(json['items'])),
      createdBy: Value(m.recordedBy),
      branchId: Value(m.branchId),
      accountId: const Value.absent(),
      notes: const Value.absent(),
      createdAt: Value(m.recordedAt),
      lastModified: Value(m.lastModified),
      isDeleted: Value(m.isDeleted),
      syncVersion: Value(m.syncVersion),
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
    syncVersion: d.syncVersion,
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
}
