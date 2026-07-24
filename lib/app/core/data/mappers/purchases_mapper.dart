import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:pharmacy_system/app/core/models/purchases/purchase_invoice_model.dart';
import 'package:pharmacy_system/app/core/models/purchases/supplied_item_model.dart';

import '../database/database.dart';

class PurchasesMapper {
  // ─── PurchaseInvoice ───
  static PurchaseInvoiceModel purchaseInvoiceFromData(PurchaseInvoicesTableData d) => PurchaseInvoiceModel.fromJson({
    'id': d.id,
    'invoice_number': d.invoiceNumber,
    'supplier_id': d.supplierId,
    'supplier_name': d.supplierName,
    'items': jsonDecode(d.items),
    'subtotal_amount': d.subtotalAmount,
    'discount_amount': d.discountAmount,
    'final_amount': d.finalAmount,
    'paid_amount': d.paidAmount,
    'remaining_amount': d.remainingAmount,
    'payment_method': d.paymentMethod,
    'created_by': d.createdBy,
    'branch_id': d.branchId,
    'account_id': d.accountId,
    'notes': d.notes,
    'created_at': d.createdAt.toIso8601String(),
    'last_modified': d.lastModified.toIso8601String(),
    'is_deleted': d.isDeleted,
    'sync_version': d.syncVersion,
  });

  static PurchaseInvoicesTableCompanion purchaseInvoiceToCompanion(PurchaseInvoiceModel m) {
    final json = m.toJson();
    return PurchaseInvoicesTableCompanion(
      id: Value(m.id),
      invoiceNumber: Value(m.invoiceNumber),
      supplierId: Value(m.supplierId),
      supplierName: Value(m.supplierName),
      items: Value(jsonEncode(json['items'])),
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
  }

  // ─── SuppliedItem ───
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
