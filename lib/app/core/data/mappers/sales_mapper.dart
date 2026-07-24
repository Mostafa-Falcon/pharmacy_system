import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:pharmacy_system/app/core/data/database/tables/sales_tables.dart';
import 'package:pharmacy_system/app/core/models/sales/sale_invoice_model.dart';
import 'package:pharmacy_system/app/core/models/sales/invoice_return_model.dart';
import 'package:pharmacy_system/app/core/models/sales/free_return_model.dart';
import 'package:pharmacy_system/app/core/models/sales/cashier_shift_model.dart';
import 'package:pharmacy_system/app/core/models/sales/shipping_order_model.dart';
import 'package:pharmacy_system/app/core/models/sales/quotation_model.dart';
import 'package:pharmacy_system/app/core/models/sales/promotion_model.dart';
import 'package:pharmacy_system/app/core/models/sales/return_model.dart';
import 'package:pharmacy_system/app/core/models/sales/suspended_sale_model.dart';
import 'package:pharmacy_system/app/core/data/mappers/base_mapper.dart';

import '../database/database.dart';

class SalesMapper {
  static SaleInvoiceModel saleInvoiceFromData(SaleInvoicesTableData d) => SaleInvoiceModel(
    id: d.id,
    invoiceNumber: d.invoiceNumber,
    customerName: d.customerName,
    customerId: d.customerId,
    cashRegisterId: d.cashRegisterId,
    items: (jsonDecode(d.items) as List).map((e) => SaleItemModel.fromJson(e)).toList(),
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

  static SaleInvoicesTableCompanion saleInvoiceToCompanion(SaleInvoiceModel m) => SaleInvoicesTableCompanion(
    id: Value(m.id),
    invoiceNumber: Value(m.invoiceNumber),
    customerName: Value(m.customerName),
    customerId: Value(m.customerId),
    cashRegisterId: Value(m.cashRegisterId),
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

  static InvoiceReturnModel invoiceReturnFromData(InvoiceReturnsTableData d) => InvoiceReturnModel(
    id: d.id,
    returnNumber: d.returnNumber,
    originalInvoiceNumber: d.originalInvoiceNumber,
    originalInvoiceId: d.originalInvoiceId,
    customerName: d.customerName,
    customerId: d.customerId,
    items: (jsonDecode(d.items) as List).map((e) => InvoiceReturnItemModel.fromJson(e)).toList(),
    returnDiscount: d.returnDiscount,
    totalReturnAmount: d.totalReturnAmount,
    createdBy: d.createdBy,
    branchId: d.branchId,
    accountId: d.accountId,
    notes: d.notes,
    createdAt: d.createdAt,
    lastModified: d.lastModified,
    isDeleted: d.isDeleted,
    syncVersion: d.syncVersion,
  );

  static InvoiceReturnsTableCompanion invoiceReturnToCompanion(InvoiceReturnModel m) => InvoiceReturnsTableCompanion(
    id: Value(m.id),
    returnNumber: Value(m.returnNumber),
    originalInvoiceNumber: Value(m.originalInvoiceNumber),
    originalInvoiceId: Value(m.originalInvoiceId),
    customerName: Value(m.customerName),
    customerId: Value(m.customerId),
    items: Value(jsonEncode(m.items.map((e) => e.toJson()).toList())),
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

  static FreeReturnModel freeReturnFromData(FreeReturnsTableData d) => FreeReturnModel(
    id: d.id,
    returnNumber: d.returnNumber,
    returnCategory: FreeReturnCategory.values.firstWhere(
      (c) => c.name == d.returnCategory,
      orElse: () => FreeReturnCategory.saleReturn,
    ),
    partyType: FreeReturnPartyType.values.firstWhere(
      (p) => p.name == d.partyType,
      orElse: () => FreeReturnPartyType.cash,
    ),
    partyId: d.partyId,
    partyName: d.partyName,
    cashRegisterId: d.cashRegisterId,
    items: (jsonDecode(d.items) as List).map((e) => FreeReturnItemModel.fromJson(e)).toList(),
    reasonNotes: d.reasonNotes,
    totalAmount: d.totalAmount,
    createdBy: d.createdBy,
    branchId: d.branchId,
    accountId: d.accountId,
    createdAt: d.createdAt,
    lastModified: d.lastModified,
  );

  static FreeReturnsTableCompanion freeReturnToCompanion(FreeReturnModel m) => FreeReturnsTableCompanion(
    id: Value(m.id),
    returnNumber: Value(m.returnNumber),
    returnCategory: Value(m.returnCategory.name),
    partyType: Value(m.partyType.name),
    partyId: Value(m.partyId),
    partyName: Value(m.partyName),
    cashRegisterId: Value(m.cashRegisterId),
    items: Value(jsonEncode(m.items.map((e) => e.toJson()).toList())),
    reasonNotes: Value(m.reasonNotes),
    totalAmount: Value(m.totalAmount),
    createdBy: Value(m.createdBy),
    branchId: Value(m.branchId),
    accountId: Value(m.accountId),
    createdAt: Value(m.createdAt),
    lastModified: Value(m.lastModified),
    isDeleted: const Value.absent(),
    syncVersion: const Value.absent(),
  );

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
    syncVersion: const Value.absent(),
  );

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
    syncVersion: const Value.absent(),
  );

  static QuotationModel quotationFromData(QuotationsTableData d) => QuotationModel(
    id: d.id,
    quotationNumber: d.quotationNumber,
    customerName: d.customerName,
    customerPhone: d.customerPhone,
    items: (jsonDecode(d.items) as List).map((e) => QuotationItemModel.fromJson(e)).toList(),
    totalAmount: d.finalAmount,
    totalQuantity: 0,
    notes: d.notes,
    createdBy: d.createdBy,
    branchId: d.branchId,
    accountId: d.accountId,
    createdAt: d.createdAt,
    lastModified: d.lastModified,
    isDeleted: d.isDeleted,
    syncVersion: d.syncVersion,
  );

  static QuotationsTableCompanion quotationToCompanion(QuotationModel m) => QuotationsTableCompanion(
    id: Value(m.id),
    quotationNumber: Value(m.quotationNumber),
    customerName: Value(m.customerName),
    customerPhone: Value(m.customerPhone),
    items: Value(jsonEncode(m.items.map((e) => e.toJson()).toList())),
    subtotalAmount: const Value.absent(),
    discountAmount: const Value.absent(),
    finalAmount: Value(m.totalAmount),
    status: const Value.absent(),
    createdBy: Value(m.createdBy),
    branchId: Value(m.branchId),
    accountId: Value(m.accountId),
    notes: Value(m.notes),
    createdAt: Value(m.createdAt),
    lastModified: Value(m.lastModified),
    isDeleted: Value(m.isDeleted),
    syncVersion: Value(m.syncVersion),
  );

  static PromotionModel promotionFromData(PromotionsTableData d) => PromotionModel(
    id: d.id,
    name: d.name,
    selectedMedicineIds: d.selectedMedicineIds != null ? (jsonDecode(d.selectedMedicineIds!) as List).cast<String>() : null,
    categoryId: d.categoryId,
    brandId: d.brandId,
    priority: d.priority,
    discountType: PromotionDiscountType.values.firstWhere(
      (t) => t.name == d.discountType,
      orElse: () => PromotionDiscountType.percentage,
    ),
    discountValue: d.discountValue,
    startDate: d.startDate,
    endDate: d.endDate,
    isActive: d.isActive,
    branchId: d.branchId,
    accountId: d.accountId,
    lastModified: d.lastModified,
    isDeleted: d.isDeleted,
    syncVersion: d.syncVersion,
  );

  static PromotionsTableCompanion promotionToCompanion(PromotionModel m) => PromotionsTableCompanion(
    id: Value(m.id),
    name: Value(m.name),
    selectedMedicineIds: Value(m.selectedMedicineIds != null ? jsonEncode(m.selectedMedicineIds) : null),
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

  static ReturnModel returnFromData(ReturnsTableData d) => ReturnModel(
    id: d.id,
    branchId: d.branchId,
    saleId: d.saleId,
    purchaseId: d.purchaseId,
    items: (jsonDecode(d.items) as List).map((e) => ReturnItemModel.fromJson(e)).toList(),
    totalAmount: d.totalAmount,
    reason: ReturnReason.values.firstWhere(
      (r) => r.name == d.reason,
      orElse: () => ReturnReason.other,
    ),
    notes: d.notes,
    createdBy: d.createdBy,
    accountId: d.accountId,
    createdAt: d.createdAt,
    syncVersion: d.syncVersion,
    lastModified: d.lastModified,
    isDeleted: d.isDeleted,
  );

  static ReturnsTableCompanion returnToCompanion(ReturnModel m) => ReturnsTableCompanion(
    id: Value(m.id),
    branchId: Value(m.branchId),
    saleId: Value(m.saleId),
    purchaseId: Value(m.purchaseId),
    items: Value(jsonEncode(m.items.map((e) => e.toJson()).toList())),
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
}