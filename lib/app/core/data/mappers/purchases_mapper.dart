import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:pharmacy_system/app/core/models/purchases/purchase_invoice_model.dart';
import 'package:pharmacy_system/app/core/models/purchases/supplied_item_model.dart';

import '../database/database.dart';

class PurchasesMapper {
  static PurchaseInvoiceModel purchaseInvoiceFromData(PurchaseInvoicesTableData d) => PurchaseInvoiceModel(
    id: d.id,
    invoiceNumber: d.invoiceNumber,
    supplierId: d.supplierId,
    supplierName: d.supplierName,
    items: (jsonDecode(d.items) as List).map((e) => PurchaseItemModel.fromJson(e)).toList(),
    subtotalAmount: d.subtotalAmount,
    discountAmount: d.discountAmount,
    finalAmount: d.finalAmount,
    paidAmount: d.paidAmount,
    remainingAmount: d.remainingAmount,
    paymentMethod: d.paymentMethod,
    createdBy: d.createdBy,
    branchId: d.branchId,
    accountId: d.accountId,
    notes: d.notes,
    createdAt: d.createdAt,
    lastModified: d.lastModified,
    isDeleted: d.isDeleted,
    syncVersion: d.syncVersion,
  );

  static PurchaseInvoicesTableCompanion purchaseInvoiceToCompanion(PurchaseInvoiceModel m) => PurchaseInvoicesTableCompanion(
    id: Value(m.id),
    invoiceNumber: Value(m.invoiceNumber),
    supplierId: Value(m.supplierId),
    supplierName: Value(m.supplierName),
    items: Value(jsonEncode(m.items.map((e) => e.toJson()).toList())),
    subtotalAmount: Value(m.subtotalAmount),
    discountAmount: Value(m.discountAmount),
    finalAmount: Value(m.finalAmount),
    paidAmount: Value(m.paidAmount),
    remainingAmount: Value(m.remainingAmount),
    paymentMethod: Value(m.paymentMethod),
    createdBy: Value(m.createdBy),
    branchId: Value(m.branchId),
    accountId: Value(m.accountId),
    notes: Value(m.notes),
    createdAt: Value(m.createdAt),
    lastModified: Value(m.lastModified),
    isDeleted: Value(m.isDeleted),
    syncVersion: Value(m.syncVersion),
  );

  static SuppliedItemModel suppliedItemFromData(SuppliedItemsTableData d) => SuppliedItemModel(
    id: d.id,
    contactId: d.supplierId,
    medicineId: d.medicineId,
    medicineName: d.medicineName,
    unitPrice: d.lastPurchasePrice,
    quantity: d.totalQuantitySupplied.toDouble(),
    priceWithTax: d.lastPurchasePrice,
    totalAmount: d.lastPurchasePrice * d.totalQuantitySupplied,
    date: d.lastPurchaseDate,
  );

  static SuppliedItemsTableCompanion suppliedItemToCompanion(SuppliedItemModel m) => SuppliedItemsTableCompanion(
    id: Value(m.id),
    supplierId: Value(m.contactId),
    medicineId: Value(m.medicineId),
    medicineName: Value(m.medicineName),
    lastPurchasePrice: Value(m.unitPrice),
    lastPurchaseDate: Value(m.date),
    totalQuantitySupplied: Value(m.quantity.toInt()),
    branchId: const Value.absent(),
    accountId: const Value.absent(),
    lastModified: const Value.absent(),
    isDeleted: const Value.absent(),
    syncVersion: const Value.absent(),
  );
}