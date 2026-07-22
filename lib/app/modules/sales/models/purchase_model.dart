class PurchaseItemModel {
  String medicineId;
  String medicineName;
  int quantity;
  double unitPrice;
  double totalPrice;
  String? batchNumber;
  DateTime? expiryDate;
  double? discount;
  String? discountType;
  double? taxAmount;
  double? previousUnitPrice;
  String? unitId;
  String? unitName;
  String? taxType;
  double? invoiceDiscountShare;
  double? invoiceTaxShare;

  PurchaseItemModel({
    required this.medicineId,
    required this.medicineName,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    this.batchNumber,
    this.expiryDate,
    this.discount,
    this.discountType,
    this.taxAmount,
    this.previousUnitPrice,
    this.unitId,
    this.unitName,
    this.taxType,
    this.invoiceDiscountShare,
    this.invoiceTaxShare,
  });

  Map<String, dynamic> toJson() => {
    'medicine_id': medicineId,
    'medicine_name': medicineName,
    'quantity': quantity,
    'unit_price': unitPrice,
    'total_price': totalPrice,
    'batch_number': batchNumber,
    'expiry_date': expiryDate?.toIso8601String(),
    'discount': discount,
    'discount_type': discountType,
    'tax_amount': taxAmount,
    'previous_unit_price': previousUnitPrice,
    'unit_id': unitId,
    'unit_name': unitName,
    'tax_type': taxType,
    'invoice_discount_share': invoiceDiscountShare,
    'invoice_tax_share': invoiceTaxShare,
  };

  factory PurchaseItemModel.fromJson(Map<String, dynamic> json) =>
      PurchaseItemModel(
        medicineId: json['medicine_id'] as String,
        medicineName: json['medicine_name'] as String,
        quantity: json['quantity'] as int,
        unitPrice: (json['unit_price'] as num).toDouble(),
        totalPrice: (json['total_price'] as num).toDouble(),
        batchNumber: json['batch_number'] as String?,
        expiryDate: json['expiry_date'] != null
            ? DateTime.tryParse(json['expiry_date'] as String)
            : null,
        discount: json['discount'] != null
            ? (json['discount'] as num).toDouble()
            : null,
        discountType: json['discount_type'] as String?,
        taxAmount: json['tax_amount'] != null
            ? (json['tax_amount'] as num).toDouble()
            : null,
        previousUnitPrice: json['previous_unit_price'] != null
            ? (json['previous_unit_price'] as num).toDouble()
            : null,
        unitId: json['unit_id'] as String?,
        unitName: json['unit_name'] as String?,
        taxType: json['tax_type'] as String?,
        invoiceDiscountShare: json['invoice_discount_share'] != null
            ? (json['invoice_discount_share'] as num).toDouble()
            : null,
        invoiceTaxShare: json['invoice_tax_share'] != null
            ? (json['invoice_tax_share'] as num).toDouble()
            : null,
      );

  PurchaseItemModel copyWith({
    String? medicineId,
    String? medicineName,
    int? quantity,
    double? unitPrice,
    double? totalPrice,
    String? batchNumber,
    DateTime? expiryDate,
    double? discount,
    String? discountType,
    double? taxAmount,
    double? previousUnitPrice,
    String? unitId,
    String? unitName,
    String? taxType,
    double? invoiceDiscountShare,
    double? invoiceTaxShare,
  }) =>
      PurchaseItemModel(
        medicineId: medicineId ?? this.medicineId,
        medicineName: medicineName ?? this.medicineName,
        quantity: quantity ?? this.quantity,
        unitPrice: unitPrice ?? this.unitPrice,
        totalPrice: totalPrice ?? this.totalPrice,
        batchNumber: batchNumber ?? this.batchNumber,
        expiryDate: expiryDate ?? this.expiryDate,
        discount: discount ?? this.discount,
        discountType: discountType ?? this.discountType,
        taxAmount: taxAmount ?? this.taxAmount,
        previousUnitPrice: previousUnitPrice ?? this.previousUnitPrice,
        unitId: unitId ?? this.unitId,
        unitName: unitName ?? this.unitName,
        taxType: taxType ?? this.taxType,
        invoiceDiscountShare: invoiceDiscountShare ?? this.invoiceDiscountShare,
        invoiceTaxShare: invoiceTaxShare ?? this.invoiceTaxShare,
      );
}

class PurchaseModel {
  String id;
  String branchId;
  String supplierName;
  String? supplierPhone;
  List<PurchaseItemModel> items;
  double totalAmount;
  double? discount;
  double finalAmount;
  String paymentMethod;
  double? paidAmount;
  String? notes;
  String createdBy;
  DateTime createdAt;
  int syncVersion;
  DateTime lastModified;
  bool isDeleted;
  String status;
  String? supplierId;
  String? sourceType;
  double? tax;
  String? receiptNumber;
  double? shippingAmount;
  double? deliveryAmount;
  String? supplierPartyType;
  String? invoiceDiscountType;
  double? invoiceDiscountValue;
  double? invoiceDiscountAmount;
  String? invoiceTaxType;
  double? invoiceTaxValue;
  double? invoiceTaxAmount;
  String? paymentAccountId;
  String? paymentAccountName;

  PurchaseModel({
    required this.id,
    required this.branchId,
    required this.supplierName,
    this.supplierPhone,
    required this.items,
    required this.totalAmount,
    this.discount,
    this.tax,
    required this.finalAmount,
    this.paymentMethod = 'cash',
    this.paidAmount,
    this.notes,
    required this.createdBy,
    required this.createdAt,
    this.syncVersion = 1,
    DateTime? lastModified,
    this.isDeleted = false,
    this.status = 'completed',
    this.supplierId,
    this.sourceType,
    this.receiptNumber,
    this.shippingAmount,
    this.deliveryAmount,
    this.supplierPartyType,
    this.invoiceDiscountType,
    this.invoiceDiscountValue,
    this.invoiceDiscountAmount,
    this.invoiceTaxType,
    this.invoiceTaxValue,
    this.invoiceTaxAmount,
    this.paymentAccountId,
    this.paymentAccountName,
  }) : lastModified = lastModified ?? DateTime.now();

  double get additionalExpenses => (shippingAmount ?? 0) + (deliveryAmount ?? 0);
  double get totalDiscount => (discount ?? 0) + (invoiceDiscountAmount ?? 0);
  double get totalTax => (tax ?? 0) + (invoiceTaxAmount ?? 0);
  double get remainingAmount => finalAmount - (paidAmount ?? 0);

  Map<String, dynamic> toJson() => {
    'id': id,
    'branch_id': branchId,
    'supplier_name': supplierName,
    'supplier_phone': supplierPhone,
    'items': items.map((e) => e.toJson()).toList(),
    'total_amount': totalAmount,
    'discount': discount,
    'tax': tax,
    'final_amount': finalAmount,
    'payment_method': paymentMethod,
    'paid_amount': paidAmount,
    'notes': notes,
    'created_by': createdBy,
    'created_at': createdAt.toIso8601String(),
    'sync_version': syncVersion,
    'last_modified': lastModified.toIso8601String(),
    'is_deleted': isDeleted,
    'status': status,
    'supplier_id': supplierId,
    'source_type': sourceType,
    'receipt_number': receiptNumber,
    'shipping_amount': shippingAmount,
    'delivery_amount': deliveryAmount,
    'supplier_party_type': supplierPartyType,
    'invoice_discount_type': invoiceDiscountType,
    'invoice_discount_value': invoiceDiscountValue,
    'invoice_discount_amount': invoiceDiscountAmount,
    'invoice_tax_type': invoiceTaxType,
    'invoice_tax_value': invoiceTaxValue,
    'invoice_tax_amount': invoiceTaxAmount,
    'payment_account_id': paymentAccountId,
    'payment_account_name': paymentAccountName,
  };

  factory PurchaseModel.fromJson(Map<String, dynamic> json) => PurchaseModel(
    id: json['id'] as String,
    branchId: json['branch_id'] as String,
    supplierName: json['supplier_name'] as String,
    supplierPhone: json['supplier_phone'] as String?,
    items: (json['items'] as List<dynamic>?)
        ?.map((e) => PurchaseItemModel.fromJson(e as Map<String, dynamic>))
        .toList() ?? [],
    totalAmount: (json['total_amount'] as num).toDouble(),
    discount: json['discount'] != null ? (json['discount'] as num).toDouble() : null,
    tax: json['tax'] != null ? (json['tax'] as num).toDouble() : null,
    finalAmount: (json['final_amount'] as num).toDouble(),
    paymentMethod: json['payment_method'] as String? ?? 'cash',
    paidAmount: json['paid_amount'] != null ? (json['paid_amount'] as num).toDouble() : null,
    notes: json['notes'] as String?,
    createdBy: json['created_by'] as String,
    createdAt: DateTime.tryParse(json['created_at'] as String) ?? DateTime.now(),
    syncVersion: json['sync_version'] as int? ?? 1,
    lastModified: json['last_modified'] != null
        ? DateTime.tryParse(json['last_modified'] as String) ?? DateTime.now()
        : DateTime.now(),
    isDeleted: json['is_deleted'] as bool? ?? false,
    status: json['status'] as String? ?? 'completed',
    supplierId: json['supplier_id'] as String?,
    sourceType: json['source_type'] as String?,
    receiptNumber: json['receipt_number'] as String?,
    shippingAmount: (json['shipping_amount'] as num?)?.toDouble(),
    deliveryAmount: (json['delivery_amount'] as num?)?.toDouble(),
    supplierPartyType: json['supplier_party_type'] as String?,
    invoiceDiscountType: json['invoice_discount_type'] as String?,
    invoiceDiscountValue: (json['invoice_discount_value'] as num?)?.toDouble(),
    invoiceDiscountAmount: (json['invoice_discount_amount'] as num?)?.toDouble(),
    invoiceTaxType: json['invoice_tax_type'] as String?,
    invoiceTaxValue: (json['invoice_tax_value'] as num?)?.toDouble(),
    invoiceTaxAmount: (json['invoice_tax_amount'] as num?)?.toDouble(),
    paymentAccountId: json['payment_account_id'] as String?,
    paymentAccountName: json['payment_account_name'] as String?,
  );
}
