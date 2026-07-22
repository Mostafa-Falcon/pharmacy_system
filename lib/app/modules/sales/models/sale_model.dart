class SaleItemModel {
  String medicineId;
  String medicineName;
  int quantity;
  double unitPrice;
  double totalPrice;

  /// تكلفة شراء الوحدة وقت البيع — أساسية لحساب الربح/تكلفة البضاعة المباعة (COGS).
  double costPrice;

  SaleItemModel({
    required this.medicineId,
    required this.medicineName,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    this.costPrice = 0,
  });

  Map<String, dynamic> toJson() => {
    'medicine_id': medicineId,
    'medicine_name': medicineName,
    'quantity': quantity,
    'unit_price': unitPrice,
    'total_price': totalPrice,
    'cost_price': costPrice,
  };

  factory SaleItemModel.fromJson(Map<String, dynamic> json) => SaleItemModel(
    medicineId: json['medicine_id'] as String,
    medicineName: json['medicine_name'] as String,
    quantity: json['quantity'] as int,
    unitPrice: (json['unit_price'] as num).toDouble(),
    totalPrice: (json['total_price'] as num).toDouble(),
    costPrice: (json['cost_price'] as num?)?.toDouble() ?? 0,
  );
}

class SaleModel {
  String id;
  String branchId;
  String? customerId;
  String? customerName;
  List<SaleItemModel> items;
  double totalAmount;
  double? discount;
  double finalAmount;
  double? taxAmount;
  String paymentMethod; // cash, card, credit, mixed
  String? notes;
  String createdBy; // userId
  DateTime createdAt;
  int syncVersion;
  DateTime lastModified;
  bool isDeleted;

  /// المبلغ المدفوع مقدماً (للفواتير المختلطة mixed). يستخدم لحساب المديونية
  /// الصحيحة عند الإلغاء (void) والمرتجع عشان متعكسش مديونية أكتر من المستحق.
  double? paidAmount;
  String? receiptNumber;
  String? salesRepId;

  /// المبلغ المستحق فعلياً على العميل:
  /// - نقدي/بطاقة: صفر (مدفوع بالكامل).
  /// - آجل (credit): كامل المبلغ.
  /// - مختلط (mixed): المبلغ ناقص المدفوع مقدماً.
  double get dueAmount {
    if (paymentMethod == 'credit') return finalAmount;
    if (paymentMethod == 'mixed') {
      return (finalAmount - (paidAmount ?? 0)).clamp(0.0, double.infinity);
    }
    return 0.0;
  }

  SaleModel({
    required this.id,
    required this.branchId,
    this.customerId,
    this.customerName,
    required this.items,
    required this.totalAmount,
    this.discount,
    required this.finalAmount,
    this.taxAmount,
    this.paymentMethod = 'cash',
    this.notes,
    required this.createdBy,
    required this.createdAt,
    this.syncVersion = 1,
    DateTime? lastModified,
    this.isDeleted = false,
    this.paidAmount,
    this.receiptNumber,
    this.salesRepId,
  }) : lastModified = lastModified ?? DateTime.now();

  SaleModel copyWith({
    String? id,
    String? branchId,
    String? customerId,
    String? customerName,
    List<SaleItemModel>? items,
    double? totalAmount,
    double? discount,
    double? finalAmount,
    double? taxAmount,
    String? paymentMethod,
    String? notes,
    String? createdBy,
    DateTime? createdAt,
    int? syncVersion,
    DateTime? lastModified,
    bool? isDeleted,
    double? paidAmount,
    String? receiptNumber,
    String? salesRepId,
  }) {
    return SaleModel(
      id: id ?? this.id,
      branchId: branchId ?? this.branchId,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      discount: discount ?? this.discount,
      finalAmount: finalAmount ?? this.finalAmount,
      taxAmount: taxAmount ?? this.taxAmount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      notes: notes ?? this.notes,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      syncVersion: syncVersion ?? this.syncVersion + 1,
      lastModified: lastModified ?? DateTime.now(),
      isDeleted: isDeleted ?? this.isDeleted,
      paidAmount: paidAmount ?? this.paidAmount,
      receiptNumber: receiptNumber ?? this.receiptNumber,
      salesRepId: salesRepId ?? this.salesRepId,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'branch_id': branchId,
    'customer_id': customerId,
    'customer_name': customerName,
    'items': items.map((e) => e.toJson()).toList(),
    'total_amount': totalAmount,
    'discount': discount,
    'final_amount': finalAmount,
    'tax_amount': taxAmount,
    'payment_method': paymentMethod,
    'notes': notes,
    'created_by': createdBy,
    'created_at': createdAt.toIso8601String(),
    'sync_version': syncVersion,
    'last_modified': lastModified.toIso8601String(),
    'is_deleted': isDeleted,
    'paid_amount': paidAmount,
    'receipt_number': receiptNumber,
    'sales_rep_id': salesRepId,
  };

  factory SaleModel.fromJson(Map<String, dynamic> json) => SaleModel(
    id: json['id'] as String,
    branchId: json['branch_id'] as String,
    customerId: json['customer_id'] as String?,
    customerName: json['customer_name'] as String?,
    items:
        (json['items'] as List<dynamic>?)
            ?.map((e) => SaleItemModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    totalAmount: (json['total_amount'] as num).toDouble(),
    discount: json['discount'] != null
        ? (json['discount'] as num).toDouble()
        : null,
    finalAmount: (json['final_amount'] as num).toDouble(),
    taxAmount: json['tax_amount'] != null
        ? (json['tax_amount'] as num).toDouble()
        : null,
    paymentMethod: json['payment_method'] as String? ?? 'cash',
    notes: json['notes'] as String?,
    createdBy: json['created_by'] as String,
    createdAt:
        DateTime.tryParse(json['created_at'] as String) ?? DateTime.now(),
    syncVersion: json['sync_version'] as int? ?? 1,
    lastModified: json['last_modified'] != null
        ? DateTime.tryParse(json['last_modified'] as String) ?? DateTime.now()
        : DateTime.now(),
    isDeleted: json['is_deleted'] as bool? ?? false,
    paidAmount: json['paid_amount'] != null
        ? (json['paid_amount'] as num).toDouble()
        : null,
    receiptNumber: json['receipt_number'] as String?,
    salesRepId: json['sales_rep_id'] as String?,
  );
}
