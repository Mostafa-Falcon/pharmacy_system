import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:pharmacy_system/app/core/models/sales/sale_invoice_model.dart';
import 'package:pharmacy_system/app/core/models/sales/invoice_return_model.dart';
import 'package:pharmacy_system/app/core/models/sales/free_return_model.dart';
import 'package:pharmacy_system/app/core/models/sales/cashier_shift_model.dart';
import 'package:pharmacy_system/app/core/models/sales/shipping_order_model.dart';
import 'package:pharmacy_system/app/core/models/sales/quotation_model.dart';
import 'package:pharmacy_system/app/core/models/sales/promotion_model.dart';
import 'package:pharmacy_system/app/core/models/sales/suspended_sale_model.dart';
import 'package:pharmacy_system/app/core/models/sales/return_model.dart';

import '../database/database.dart';

class SalesMapper {
  // ─── SaleInvoice ───
  static SaleInvoiceModel saleInvoiceFromData(SaleInvoicesTableData d) => SaleInvoiceModel.fromJson({
    'id': d.id,
    'invoice_number': d.invoiceNumber,
    'customer_name': d.customerName,
    'customer_id': d.customerId,
    'cash_register_id': d.cashRegisterId,
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

  static SaleInvoicesTableCompanion saleInvoiceToCompanion(SaleInvoiceModel m) {
    final json = m.toJson();
    return SaleInvoicesTableCompanion(
      id: Value(m.id),
      invoiceNumber: Value(m.invoiceNumber),
      customerName: Value(m.customerName),
      customerId: Value(m.customerId),
      cashRegisterId: Value(m.cashRegisterId),
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

  // ─── InvoiceReturn ───
  static InvoiceReturnModel invoiceReturnFromData(InvoiceReturnsTableData d) => InvoiceReturnModel.fromJson({
    'id': d.id,
    'return_number': d.returnNumber,
    'original_invoice_number': d.originalInvoiceNumber,
    'original_invoice_id': d.originalInvoiceId,
    'customer_name': d.customerName,
    'customer_id': d.customerId,
    'items': jsonDecode(d.items),
    'return_discount': d.returnDiscount,
    'total_return_amount': d.totalReturnAmount,
    'created_by': d.createdBy,
    'branch_id': d.branchId,
    'account_id': d.accountId,
    'notes': d.notes,
    'created_at': d.createdAt.toIso8601String(),
    'last_modified': d.lastModified.toIso8601String(),
    'is_deleted': d.isDeleted,
    'sync_version': d.syncVersion,
  });

  static InvoiceReturnsTableCompanion invoiceReturnToCompanion(InvoiceReturnModel m) {
    final json = m.toJson();
    return InvoiceReturnsTableCompanion(
      id: Value(m.id),
      returnNumber: Value(m.returnNumber),
      originalInvoiceNumber: Value(m.originalInvoiceNumber),
      originalInvoiceId: Value(m.originalInvoiceId),
      customerName: Value(m.customerName),
      customerId: Value(m.customerId),
      items: Value(jsonEncode(json['items'])),
      returnDiscount: Value(m.returnDiscount),
      totalReturnAmount: Value(m.totalReturnAmount),
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

  // ─── FreeReturn ───
  static FreeReturnModel freeReturnFromData(FreeReturnsTableData d) => FreeReturnModel.fromJson({
    'id': d.id,
    'return_number': d.returnNumber,
    'return_category': d.returnCategory,
    'party_type': d.partyType,
    'party_id': d.partyId,
    'party_name': d.partyName,
    'cash_register_id': d.cashRegisterId,
    'items': jsonDecode(d.items),
    'reason_notes': d.reasonNotes,
    'total_amount': d.totalAmount,
    'created_by': d.createdBy,
    'branch_id': d.branchId,
    'account_id': d.accountId,
    'created_at': d.createdAt.toIso8601String(),
    'last_modified': d.lastModified.toIso8601String(),
  });

  static FreeReturnsTableCompanion freeReturnToCompanion(FreeReturnModel m) {
    final json = m.toJson();
    return FreeReturnsTableCompanion(
      id: Value(m.id),
      returnNumber: Value(m.returnNumber),
      returnCategory: Value(m.returnCategory.name),
      partyType: Value(m.partyType.name),
      partyId: Value(m.partyId),
      partyName: Value(m.partyName),
      cashRegisterId: Value(m.cashRegisterId),
      items: Value(jsonEncode(json['items'])),
      reasonNotes: Value(m.reasonNotes),
      totalAmount: Value(m.totalAmount),
      createdBy: Value(m.createdBy),
      branchId: Value(m.branchId),
      accountId: Value(m.accountId),
      createdAt: Value(m.createdAt),
      lastModified: Value(m.lastModified),
      isDeleted: const Value(false),
      syncVersion: const Value(1),
    );
  }

  // ─── CashierShift ───
  static CashierShiftModel cashierShiftFromData(CashierShiftsTableData d) => CashierShiftModel(
    id: d.id,
    shiftNumber: d.shiftNumber,
    branchId: d.branchId,
    cashierId: d.cashierId,
    cashierName: d.cashierName,
    deviceId: d.deviceId,
    openedAt: d.openedAt,
    openingCash: d.openingCash,
    status: CashierShiftStatus.values.firstWhere(
      (s) => s.name == d.status,
      orElse: () => CashierShiftStatus.open,
    ),
    closedAt: d.closedAt,
    expectedCash: d.expectedCash,
    countedCash: d.countedCash,
    difference: d.difference,
    accountId: d.accountId,
    notes: d.notes,
    lastModified: d.lastModified,
    isDeleted: d.isDeleted,
  );

  static CashierShiftsTableCompanion cashierShiftToCompanion(CashierShiftModel m) => CashierShiftsTableCompanion(
    id: Value(m.id),
    shiftNumber: Value(m.shiftNumber),
    branchId: Value(m.branchId),
    cashierId: Value(m.cashierId),
    cashierName: Value(m.cashierName),
    deviceId: Value(m.deviceId),
    openedAt: Value(m.openedAt),
    openingCash: Value(m.openingCash),
    status: Value(m.status.name),
    closedAt: Value(m.closedAt),
    expectedCash: Value(m.expectedCash),
    countedCash: Value(m.countedCash),
    difference: Value(m.difference),
    accountId: Value(m.accountId),
    notes: Value(m.notes),
    lastModified: Value(m.lastModified),
    isDeleted: Value(m.isDeleted),
  );

  // ─── ShippingOrder ───
  static ShippingOrderModel shippingOrderFromData(ShippingOrdersTableData d) {
    List<String>? urls;
    if (d.documentUrls != null && d.documentUrls!.isNotEmpty) {
      try { urls = (jsonDecode(d.documentUrls!) as List).cast<String>(); } catch (_) {}
    }
    return ShippingOrderModel(
      id: d.id,
      invoiceNumber: d.invoiceNumber,
      invoiceId: d.invoiceId,
      shippingDate: d.shippingDate,
      customerName: d.customerName,
      customerPhone: d.customerPhone,
      shippingAddress: d.shippingAddress,
      shippingDetails: d.shippingDetails,
      deliveredTo: d.deliveredTo,
      deliveryAgentId: d.deliveryAgentId,
      deliveryAgentName: d.deliveryAgentName,
      shippingStatus: ShippingStatus.values.firstWhere(
        (s) => s.name == d.shippingStatus,
        orElse: () => ShippingStatus.pending,
      ),
      isPaid: d.isPaid,
      notes: d.notes,
      documentUrls: urls,
      createdBy: d.createdBy,
      branchId: d.branchId,
      accountId: d.accountId,
      lastModified: d.lastModified,
      isDeleted: d.isDeleted,
    );
  }

  static ShippingOrdersTableCompanion shippingOrderToCompanion(ShippingOrderModel m) => ShippingOrdersTableCompanion(
    id: Value(m.id),
    invoiceNumber: Value(m.invoiceNumber),
    invoiceId: Value(m.invoiceId),
    shippingDate: Value(m.shippingDate),
    customerName: Value(m.customerName),
    customerPhone: Value(m.customerPhone),
    shippingAddress: Value(m.shippingAddress),
    shippingDetails: Value(m.shippingDetails),
    deliveredTo: Value(m.deliveredTo),
    deliveryAgentId: Value(m.deliveryAgentId),
    deliveryAgentName: Value(m.deliveryAgentName),
    shippingStatus: Value(m.shippingStatus.name),
    isPaid: Value(m.isPaid),
    notes: Value(m.notes),
    documentUrls: Value(m.documentUrls != null ? jsonEncode(m.documentUrls) : null),
    createdBy: Value(m.createdBy),
    branchId: Value(m.branchId),
    accountId: Value(m.accountId),
    lastModified: Value(m.lastModified),
    isDeleted: Value(m.isDeleted),
  );

  // ─── Quotation ───
  static QuotationModel quotationFromData(QuotationsTableData d) {
    final itemsList = (jsonDecode(d.items) as List<dynamic>?)
            ?.map((e) => QuotationItemModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    return QuotationModel(
      id: d.id,
      quotationNumber: d.quotationNumber,
      customerId: d.customerId,
      customerName: d.customerName,
      customerPhone: d.customerPhone,
      items: itemsList,
      totalAmount: d.finalAmount,
      paidAmount: d.paidAmount,
      remainingAmount: d.remainingAmount,
      paymentMethod: d.paymentMethod,
      paymentStatus: QuotationPaymentStatus.values.firstWhere(
        (e) => e.name == d.paymentStatus,
        orElse: () => QuotationPaymentStatus.unpaid,
      ),
      shippingStatus: QuotationShippingStatus.values.firstWhere(
        (e) => e.name == d.shippingStatus,
        orElse: () => QuotationShippingStatus.pending,
      ),
      totalQuantity: d.totalQuantity,
      createdBy: d.createdBy,
      branchId: d.branchId,
      accountId: d.accountId,
      notes: d.notes,
      createdAt: d.createdAt,
      lastModified: d.lastModified,
      isDeleted: d.isDeleted,
      syncVersion: d.syncVersion,
    );
  }

  static QuotationsTableCompanion quotationToCompanion(QuotationModel m) {
    return QuotationsTableCompanion(
      id: Value(m.id),
      quotationNumber: Value(m.quotationNumber),
      customerId: Value(m.customerId),
      customerName: Value(m.customerName),
      customerPhone: Value(m.customerPhone),
      items: Value(jsonEncode(m.items.map((i) => i.toJson()).toList())),
      subtotalAmount: const Value.absent(),
      discountAmount: const Value.absent(),
      finalAmount: Value(m.totalAmount),
      paidAmount: Value(m.paidAmount),
      remainingAmount: Value(m.remainingAmount),
      paymentMethod: Value(m.paymentMethod),
      paymentStatus: Value(m.paymentStatus.name),
      shippingStatus: Value(m.shippingStatus.name),
      totalQuantity: Value(m.totalQuantity),
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

  // ─── Promotion ───
  static PromotionModel promotionFromData(PromotionsTableData d) => PromotionModel.fromJson({
    'id': d.id,
    'name': d.name,
    'selected_medicine_ids': d.selectedMedicineIds != null ? jsonDecode(d.selectedMedicineIds!) : null,
    'category_id': d.categoryId,
    'brand_id': d.brandId,
    'priority': d.priority,
    'discount_type': d.discountType,
    'discount_value': d.discountValue,
    'start_date': d.startDate.toIso8601String(),
    'end_date': d.endDate.toIso8601String(),
    'is_active': d.isActive,
    'branch_id': d.branchId,
    'account_id': d.accountId,
    'last_modified': d.lastModified.toIso8601String(),
    'is_deleted': d.isDeleted,
    'sync_version': d.syncVersion,
  });

  static PromotionsTableCompanion promotionToCompanion(PromotionModel m) {
    final json = m.toJson();
    return PromotionsTableCompanion(
      id: Value(m.id),
      name: Value(m.name),
      selectedMedicineIds: Value(json['selected_medicine_ids'] != null ? jsonEncode(json['selected_medicine_ids']) : null),
      categoryId: Value(m.categoryId),
      brandId: Value(m.brandId),
      priority: Value(m.priority),
      discountType: Value(m.discountType.name),
      discountValue: Value(m.discountValue),
      startDate: Value(m.startDate),
      endDate: Value(m.endDate),
      isActive: Value(m.isActive),
      branchId: Value(m.branchId),
      accountId: Value(m.accountId),
      lastModified: Value(m.lastModified),
      isDeleted: Value(m.isDeleted),
      syncVersion: Value(m.syncVersion),
    );
  }

  // ─── SuspendedSale ───
  static SuspendedSaleModel suspendedSaleFromData(SuspendedSalesTableData d) => SuspendedSaleModel(
    id: d.id,
    referenceNumber: d.referenceNumber,
    customerName: d.customerName,
    customerId: d.customerId,
    itemsJson: d.itemsJson,
    totalAmount: d.totalAmount,
    cashierId: d.cashierId,
    branchId: d.branchId,
    accountId: d.accountId,
    createdAt: d.createdAt,
    lastModified: d.lastModified,
    isDeleted: d.isDeleted,
    syncVersion: d.syncVersion,
  );

  static SuspendedSalesTableCompanion suspendedSaleToCompanion(SuspendedSaleModel m) => SuspendedSalesTableCompanion(
    id: Value(m.id),
    referenceNumber: Value(m.referenceNumber),
    customerName: Value(m.customerName),
    customerId: Value(m.customerId),
    itemsJson: Value(m.itemsJson),
    totalAmount: Value(m.totalAmount),
    cashierId: Value(m.cashierId),
    branchId: Value(m.branchId),
    accountId: Value(m.accountId),
    createdAt: Value(m.createdAt),
    lastModified: Value(m.lastModified),
    isDeleted: Value(m.isDeleted),
    syncVersion: Value(m.syncVersion),
  );

  // ─── Return ───
  static ReturnModel returnFromData(ReturnsTableData d) => ReturnModel.fromJson({
    'id': d.id,
    'branch_id': d.branchId,
    'sale_id': d.saleId,
    'purchase_id': d.purchaseId,
    'items': jsonDecode(d.items),
    'total_amount': d.totalAmount,
    'reason': d.reason,
    'notes': d.notes,
    'created_by': d.createdBy,
    'account_id': d.accountId,
    'created_at': d.createdAt.toIso8601String(),
    'sync_version': d.syncVersion,
    'last_modified': d.lastModified.toIso8601String(),
    'is_deleted': d.isDeleted,
  });

  static ReturnsTableCompanion returnToCompanion(ReturnModel m) {
    final json = m.toJson();
    return ReturnsTableCompanion(
      id: Value(m.id),
      branchId: Value(m.branchId),
      saleId: Value(m.saleId),
      purchaseId: Value(m.purchaseId),
      items: Value(jsonEncode(json['items'])),
      totalAmount: Value(m.totalAmount),
      reason: Value(m.reason.name),
      notes: Value(m.notes),
      createdBy: Value(m.createdBy),
      accountId: Value(m.accountId),
      createdAt: Value(m.createdAt),
      syncVersion: Value(m.syncVersion),
      lastModified: Value(m.lastModified),
      isDeleted: Value(m.isDeleted),
    );
  }
}
