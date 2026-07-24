import 'package:equatable/equatable.dart';
import 'package:pharmacy_system/app/core/models/purchases/purchase_invoice_model.dart';
import 'package:pharmacy_system/app/core/models/inventory/medicine_unit_model.dart';

enum PurchasesStatus { initial, loading, loaded, error, submitting }

class PurchaseLine {
  final String medicineId;
  final String medicineName;
  int quantity;
  double unitPrice;
  String? batchNumber;
  DateTime? expiryDate;
  double? discount;
  String? discountType;
  double? taxAmount;
  String? taxType;
  String? unitId;
  String? unitName;
  List<MedicineUnitModel> units;

  PurchaseLine({
    required this.medicineId,
    required this.medicineName,
    this.quantity = 1,
    this.unitPrice = 0,
    this.batchNumber,
    this.expiryDate,
    this.discount,
    this.discountType = '%',
    this.taxAmount,
    this.taxType = 'fixed',
    this.unitId,
    this.unitName,
    this.units = const [],
  });

  double get total => quantity * unitPrice;

  double get calcLineDiscount {
    if (discount == null || discount == 0) return 0;
    return discountType == '%' ? total * (discount! / 100) : discount!;
  }

  double get calcLineTax {
    if (taxAmount == null || taxAmount == 0) return 0;
    final afterDiscount = (total - calcLineDiscount).clamp(0, double.infinity);
    return taxType == '%' ? afterDiscount * (taxAmount! / 100) : taxAmount!;
  }

  double get finalLineTotal => (total - calcLineDiscount + calcLineTax).clamp(0, double.infinity);

  PurchaseItemModel toItemModel() => PurchaseItemModel(
    medicineId: medicineId, medicineName: medicineName,
    quantity: quantity, unitPrice: unitPrice, totalPrice: total,
    batchNumber: batchNumber, expiryDate: expiryDate,
    discount: discount, discountType: discountType,
    taxAmount: taxAmount, unitId: unitId, unitName: unitName,
  );
}

class PurchasesState extends Equatable {
  final PurchasesStatus status;
  final String? error;
  final List<PurchaseInvoiceModel> allPurchases;
  final List<PurchaseInvoiceModel> filteredPurchases;
  final String searchQuery;
  final String selectedFilter;
  final DateTime? dateFrom;
  final DateTime? dateTo;

  // Form state
  final List<PurchaseLine> receiptLines;
  final String? referenceNumber;
  final String purchaseStatus;
  final DateTime purchaseDate;
  final int? paymentTerm;
  final String paymentTermUnit;
  final String? selectedSupplierId;
  final String? selectedSupplierName;
  final double supplierBalance;
  final String sourceType;
  final String paymentMethod;
  final DateTime paymentDate;
  final String invoiceDiscountType;
  final double invoiceDiscountValue;
  final String invoiceTaxType;
  final double invoiceTaxValue;
  final double shippingAmount;
  final double deliveryAmount;
  final double paidAmount;
  final String? paymentAccountId;
  final String? paymentAccountName;
  final String? editingPurchaseId;
  final String notes;
  final List<Map<String, String>> vendors;

  PurchasesState({
    this.status = PurchasesStatus.initial,
    this.error,
    this.allPurchases = const [],
    this.filteredPurchases = const [],
    this.searchQuery = '',
    this.selectedFilter = 'all',
    this.dateFrom,
    this.dateTo,
    this.receiptLines = const [],
    this.referenceNumber,
    this.purchaseStatus = '?????',
    DateTime? purchaseDate,
    this.paymentTerm,
    this.paymentTermUnit = '????',
    this.selectedSupplierId,
    this.selectedSupplierName,
    this.supplierBalance = 0,
    this.sourceType = '??????',
    this.paymentMethod = 'cash',
    DateTime? paymentDate,
    this.invoiceDiscountType = 'fixed',
    this.invoiceDiscountValue = 0,
    this.invoiceTaxType = 'fixed',
    this.invoiceTaxValue = 0,
    this.shippingAmount = 0,
    this.deliveryAmount = 0,
    this.paidAmount = 0,
    this.paymentAccountId,
    this.paymentAccountName,
    this.editingPurchaseId,
    this.notes = '',
    this.vendors = const [],
  })  : purchaseDate = purchaseDate ?? DateTime.now(),
        paymentDate = paymentDate ?? DateTime.now();

  PurchasesState.init({
    this.status = PurchasesStatus.initial,
    this.error,
    this.allPurchases = const [],
    this.filteredPurchases = const [],
    this.searchQuery = '',
    this.selectedFilter = 'all',
    this.dateFrom,
    this.dateTo,
    this.receiptLines = const [],
    this.referenceNumber,
    this.purchaseStatus = '?????',
    DateTime? purchaseDate,
    this.paymentTerm,
    this.paymentTermUnit = '????',
    this.selectedSupplierId,
    this.selectedSupplierName,
    this.supplierBalance = 0,
    this.sourceType = '??????',
    this.paymentMethod = 'cash',
    DateTime? paymentDate,
    this.invoiceDiscountType = 'fixed',
    this.invoiceDiscountValue = 0,
    this.invoiceTaxType = 'fixed',
    this.invoiceTaxValue = 0,
    this.shippingAmount = 0,
    this.deliveryAmount = 0,
    this.paidAmount = 0,
    this.paymentAccountId,
    this.paymentAccountName,
    this.editingPurchaseId,
    this.notes = '',
    this.vendors = const [],
  })  : purchaseDate = purchaseDate ?? DateTime.now(),
        paymentDate = paymentDate ?? DateTime.now();

  PurchasesState copyWith({
    PurchasesStatus? status,
    String? error,
    List<PurchaseInvoiceModel>? allPurchases,
    List<PurchaseInvoiceModel>? filteredPurchases,
    String? searchQuery,
    String? selectedFilter,
    DateTime? dateFrom,
    bool clearDateFrom = false,
    DateTime? dateTo,
    bool clearDateTo = false,
    List<PurchaseLine>? receiptLines,
    String? referenceNumber,
    String? purchaseStatus,
    DateTime? purchaseDate,
    int? paymentTerm,
    bool clearPaymentTerm = false,
    String? paymentTermUnit,
    String? selectedSupplierId,
    String? selectedSupplierName,
    double? supplierBalance,
    String? sourceType,
    String? paymentMethod,
    DateTime? paymentDate,
    String? invoiceDiscountType,
    double? invoiceDiscountValue,
    String? invoiceTaxType,
    double? invoiceTaxValue,
    double? shippingAmount,
    double? deliveryAmount,
    double? paidAmount,
    String? paymentAccountId,
    String? paymentAccountName,
    String? editingPurchaseId,
    bool clearEditing = false,
    String? notes,
    List<Map<String, String>>? vendors,
  }) {
    return PurchasesState(
      status: status ?? this.status,
      error: error ?? this.error,
      allPurchases: allPurchases ?? this.allPurchases,
      filteredPurchases: filteredPurchases ?? this.filteredPurchases,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      dateFrom: clearDateFrom ? null : (dateFrom ?? this.dateFrom),
      dateTo: clearDateTo ? null : (dateTo ?? this.dateTo),
      receiptLines: receiptLines ?? this.receiptLines,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      purchaseStatus: purchaseStatus ?? this.purchaseStatus,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      paymentTerm: clearPaymentTerm ? null : (paymentTerm ?? this.paymentTerm),
      paymentTermUnit: paymentTermUnit ?? this.paymentTermUnit,
      selectedSupplierId: selectedSupplierId ?? this.selectedSupplierId,
      selectedSupplierName: selectedSupplierName ?? this.selectedSupplierName,
      supplierBalance: supplierBalance ?? this.supplierBalance,
      sourceType: sourceType ?? this.sourceType,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentDate: paymentDate ?? this.paymentDate,
      invoiceDiscountType: invoiceDiscountType ?? this.invoiceDiscountType,
      invoiceDiscountValue: invoiceDiscountValue ?? this.invoiceDiscountValue,
      invoiceTaxType: invoiceTaxType ?? this.invoiceTaxType,
      invoiceTaxValue: invoiceTaxValue ?? this.invoiceTaxValue,
      shippingAmount: shippingAmount ?? this.shippingAmount,
      deliveryAmount: deliveryAmount ?? this.deliveryAmount,
      paidAmount: paidAmount ?? this.paidAmount,
      paymentAccountId: paymentAccountId ?? this.paymentAccountId,
      paymentAccountName: paymentAccountName ?? this.paymentAccountName,
      editingPurchaseId: clearEditing ? null : (editingPurchaseId ?? this.editingPurchaseId),
      notes: notes ?? this.notes,
      vendors: vendors ?? this.vendors,
    );
  }

  // Computed values
  double get subtotal => receiptLines.fold(0.0, (s, l) => s + l.total);

  double get itemsDiscountTotal => receiptLines.fold(0.0, (sum, l) => sum + l.calcLineDiscount);

  double get itemsTaxTotal => receiptLines.fold(0.0, (s, l) => s + l.calcLineTax);

  double get calcInvoiceDiscountAmount {
    if (invoiceDiscountValue <= 0) return 0;
    return invoiceDiscountType == '%' ? subtotal * (invoiceDiscountValue / 100) : invoiceDiscountValue.clamp(0, subtotal);
  }

  double get calcInvoiceTaxAmount {
    if (invoiceTaxValue <= 0) return 0;
    final afterDiscount = (subtotal - itemsDiscountTotal - calcInvoiceDiscountAmount).clamp(0, double.infinity);
    return invoiceTaxType == '%' ? afterDiscount * (invoiceTaxValue / 100) : invoiceTaxValue;
  }

  double get totalAdditionalExpenses => shippingAmount + deliveryAmount;

  double get finalAmount {
    final afterDiscount = (subtotal - itemsDiscountTotal - calcInvoiceDiscountAmount).clamp(0, double.infinity);
    return afterDiscount + itemsTaxTotal + calcInvoiceTaxAmount + totalAdditionalExpenses;
  }

  double get totalDiscountAmount => itemsDiscountTotal + calcInvoiceDiscountAmount;
  double get totalTaxAmount => itemsTaxTotal + calcInvoiceTaxAmount;

  int get totalCount => allPurchases.length;

  double get totalPurchasesAmount => allPurchases.fold(0.0, (sum, p) => sum + p.finalAmount);

  double get todayTotal {
    final today = DateTime.now();
    return allPurchases.where((p) =>
      p.createdAt.day == today.day && p.createdAt.month == today.month && p.createdAt.year == today.year
    ).fold(0.0, (sum, p) => sum + p.finalAmount);
  }

  double get monthTotal {
    final now = DateTime.now();
    return allPurchases.where((p) => p.createdAt.month == now.month && p.createdAt.year == now.year)
      .fold(0.0, (sum, p) => sum + p.finalAmount);
  }

  double get creditTotal => allPurchases.where((p) => p.paymentMethod == 'credit')
      .fold(0.0, (sum, p) => sum + p.remainingAmount);

  List<PurchaseInvoiceModel> get recentPurchases => allPurchases.take(5).toList();

  String getPaymentLabel(String method) => switch (method) {
    'cash' => '?????', 'credit' => '???', 'card' => '?????', _ => method,
  };

  @override
  List<Object?> get props => [
    status, error, allPurchases, filteredPurchases, searchQuery, selectedFilter,
    dateFrom, dateTo, receiptLines, referenceNumber, purchaseStatus, purchaseDate,
    paymentTerm, paymentTermUnit, selectedSupplierId, selectedSupplierName,
    supplierBalance, sourceType, paymentMethod, paymentDate, invoiceDiscountType,
    invoiceDiscountValue, invoiceTaxType, invoiceTaxValue, shippingAmount,
    deliveryAmount, paidAmount, paymentAccountId, paymentAccountName, editingPurchaseId, notes,
  ];
}





