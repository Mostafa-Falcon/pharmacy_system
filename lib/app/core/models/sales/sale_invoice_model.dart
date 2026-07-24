import 'package:pharmacy_system/app/core/data/database/syncable_entity.dart';

/// 📦 موديل سطر الدواء المباع داخل فاتورة المبيعات
class SaleItemModel {
  // 💊 معرف الدواء/الصنف
  final String medicineId;

  // 🏷️ اسم الدواء/الصنف بالعربي
  final String medicineName;

  // 🔢 مستوى الوحدة المباعة (1 = علبة، 2 = شريط، 3 = قرص)
  final int unitLevel;

  // 🏷️ اسم الوحدة المباعة (علبة، شريط، قرص)
  final String unitName;

  // 🏷️ رقم الطبخة/التشغيلة المسحوبة أوتوماتيك لبيع الأقرب انتهاءً (Batch Number)
  final String? batchNumber;

  // ⏳ تاريخ انتهاء صلاحية التشغيلة المباعة
  final DateTime? expiryDate;

  // 📦 الكمية المباعة
  final int quantity;

  // 💵 سعر بيع الوحدة
  final double unitPrice;

  // ٪ قيمة الخصم على السطر
  final double discountAmount;

  // 💰 إجمالي سعر السطر بعد الخصم
  final double totalPrice;

  // ─── Backward Compatibility ───
  final double costPrice;

  SaleItemModel({
    required this.medicineId,
    required this.medicineName,
    required this.unitLevel,
    required this.unitName,
    this.batchNumber,
    this.expiryDate,
    required this.quantity,
    required this.unitPrice,
    this.discountAmount = 0.0,
    required this.totalPrice,
    this.costPrice = 0.0,
  });

  Map<String, dynamic> toJson() => {
    'medicine_id': medicineId,
    'medicine_name': medicineName,
    'unit_level': unitLevel,
    'unit_name': unitName,
    'batch_number': batchNumber,
    'expiry_date': expiryDate?.toIso8601String(),
    'quantity': quantity,
    'unit_price': unitPrice,
    'discount_amount': discountAmount,
    'total_price': totalPrice,
    'cost_price': costPrice,
  };

  factory SaleItemModel.fromJson(Map<String, dynamic> json) => SaleItemModel(
    medicineId: json['medicine_id'] as String,
    medicineName: json['medicine_name'] as String,
    unitLevel: (json['unit_level'] as num?)?.toInt() ?? 1,
    unitName: (json['unit_name'] as String?) ?? 'علبة',
    batchNumber: json['batch_number'] as String?,
    expiryDate: json['expiry_date'] != null ? DateTime.tryParse(json['expiry_date'] as String) : null,
    quantity: (json['quantity'] as num?)?.toInt() ?? 1,
    unitPrice: (json['unit_price'] as num?)?.toDouble() ?? 0.0,
    discountAmount: (json['discount_amount'] as num?)?.toDouble() ?? 0.0,
    totalPrice: (json['total_price'] as num?)?.toDouble() ?? 0.0,
    costPrice: (json['cost_price'] as num?)?.toDouble() ?? 0.0,
  );
}

/// 🧾 موديل فاتورة المبيعات الرئيسية (POS Sale Invoice Model)
class SaleInvoiceModel implements SyncableEntity {
  // 🆔 المعرف الفريد للفاتورة (Primary Key)
  final String id;

  // 🔢 رقم الفاتورة التسلسلي المرجعي
  final String invoiceNumber;

  // 👤 اسم العميل / زبون نقدي
  final String customerName;

  // 👤 معرف العميل (إن وجد)
  final String? customerId;

  // 💳 معرف الخزينة التي تم تحصيل المبلغ فيها
  final String cashRegisterId;

  // 📦 قائمة سطور الأدوية المباعة
  final List<SaleItemModel> items;

  // 💰 إجمالي المبلغ قبل الخصم
  final double subtotalAmount;

  // ٪ قيمة الخصم المفتوح على الفاتورة ككل
  final double discountAmount;

  // 💰 المبلغ النهائي الإجمالي بعد الخصم
  final double finalAmount;

  // 💵 المبلغ المدفوع فعلياً من العميل
  final double paidAmount;

  // 💵 المبلغ المتبقي على العميل (في حالة المبيعات الآجلة)
  final double remainingAmount;

  // 💳 طريقة الدفع (كاش cash / كارت card / آجل credit / تحويل transfer)
  final String paymentMethod;

  // 👤 اسم/معرف الصيدلي/الكاشير الذي أجرى المبيعات
  final String createdBy;

  // 🏬 معرف الفرع
  final String branchId;

  // 🏢 معرف الحساب الرئيسي / المؤسسة
  final String accountId;

  // 📝 ملاحظات الفاتورة
  final String? notes;

  // 📅 تاريخ ووقت إنشاء الفاتورة
  final DateTime createdAt;

  // 🕒 تاريخ ووقت آخر تعديل
  @override
  final DateTime lastModified;

  // 🗑️ حالة الحذف المنطقي
  @override
  final bool isDeleted;

  // ⚙️ نسخة المزامنة
  final int syncVersion;

  // ─── Backward Compatibility Getters ───
  double get totalAmount => subtotalAmount;
  double get dueAmount => remainingAmount;
  double? get discount => discountAmount > 0 ? discountAmount : null;
  double? get taxAmount => null;
  String? get receiptNumber => invoiceNumber;

  @override
  String? get syncBranchId => branchId;

  SaleInvoiceModel({
    required this.id,
    required this.invoiceNumber,
    this.customerName = 'زبون نقدي',
    this.customerId,
    required this.cashRegisterId,
    required this.items,
    required this.subtotalAmount,
    this.discountAmount = 0.0,
    required this.finalAmount,
    required this.paidAmount,
    this.remainingAmount = 0.0,
    this.paymentMethod = 'cash',
    required this.createdBy,
    required this.branchId,
    required this.accountId,
    this.notes,
    DateTime? createdAt,
    DateTime? lastModified,
    this.isDeleted = false,
    this.syncVersion = 1,
  })  : createdAt = createdAt ?? DateTime.now(),
        lastModified = lastModified ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'invoice_number': invoiceNumber,
    'customer_name': customerName,
    'customer_id': customerId,
    'cash_register_id': cashRegisterId,
    'items': items.map((i) => i.toJson()).toList(),
    'subtotal_amount': subtotalAmount,
    'discount_amount': discountAmount,
    'final_amount': finalAmount,
    'paid_amount': paidAmount,
    'remaining_amount': remainingAmount,
    'payment_method': paymentMethod,
    'created_by': createdBy,
    'branch_id': branchId,
    'account_id': accountId,
    'notes': notes,
    'created_at': createdAt.toIso8601String(),
    'last_modified': lastModified.toIso8601String(),
    'is_deleted': isDeleted,
    'sync_version': syncVersion,
  };

  factory SaleInvoiceModel.fromJson(Map<String, dynamic> json) => SaleInvoiceModel(
    id: json['id'] as String,
    invoiceNumber: json['invoice_number'] as String,
    customerName: json['customer_name'] as String? ?? 'زبون نقدي',
    customerId: json['customer_id'] as String?,
    cashRegisterId: json['cash_register_id'] as String? ?? '',
    items: (json['items'] as List<dynamic>?)
        ?.map((e) => SaleItemModel.fromJson(e as Map<String, dynamic>))
        .toList() ?? [],
    subtotalAmount: (json['subtotal_amount'] as num?)?.toDouble() ?? 0.0,
    discountAmount: (json['discount_amount'] as num?)?.toDouble() ?? 0.0,
    finalAmount: (json['final_amount'] as num?)?.toDouble() ?? 0.0,
    paidAmount: (json['paid_amount'] as num?)?.toDouble() ?? 0.0,
    remainingAmount: (json['remaining_amount'] as num?)?.toDouble() ?? 0.0,
    paymentMethod: json['payment_method'] as String? ?? 'cash',
    createdBy: json['created_by'] as String? ?? '',
    branchId: json['branch_id'] as String? ?? '',
    accountId: json['account_id'] as String? ?? '',
    notes: json['notes'] as String?,
    createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
    lastModified: DateTime.tryParse(json['last_modified'] as String? ?? '') ?? DateTime.now(),
    isDeleted: json['is_deleted'] as bool? ?? false,
    syncVersion: (json['sync_version'] as num?)?.toInt() ?? 1,
  );

  SaleInvoiceModel copyWith({
    String? id,
    String? invoiceNumber,
    String? customerName,
    String? customerId,
    String? cashRegisterId,
    List<SaleItemModel>? items,
    double? subtotalAmount,
    double? discountAmount,
    double? finalAmount,
    double? paidAmount,
    double? remainingAmount,
    String? paymentMethod,
    String? createdBy,
    String? branchId,
    String? accountId,
    String? notes,
    DateTime? createdAt,
    DateTime? lastModified,
    bool? isDeleted,
    int? syncVersion,
  }) {
    return SaleInvoiceModel(
      id: id ?? this.id,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      customerName: customerName ?? this.customerName,
      customerId: customerId ?? this.customerId,
      cashRegisterId: cashRegisterId ?? this.cashRegisterId,
      items: items ?? this.items,
      subtotalAmount: subtotalAmount ?? this.subtotalAmount,
      discountAmount: discountAmount ?? this.discountAmount,
      finalAmount: finalAmount ?? this.finalAmount,
      paidAmount: paidAmount ?? this.paidAmount,
      remainingAmount: remainingAmount ?? this.remainingAmount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      createdBy: createdBy ?? this.createdBy,
      branchId: branchId ?? this.branchId,
      accountId: accountId ?? this.accountId,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      lastModified: lastModified ?? this.lastModified,
      isDeleted: isDeleted ?? this.isDeleted,
      syncVersion: syncVersion ?? this.syncVersion,
    );
  }
}


