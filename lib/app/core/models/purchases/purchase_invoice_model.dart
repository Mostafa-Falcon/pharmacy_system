import 'package:pharmacy_system/app/core/sync/syncable_entity.dart';

/// 📦 موديل سطر الدواء المشتري داخل فاتورة المشتريات
class PurchaseItemModel {
  // 💊 معرف الدواء/الصنف
  final String medicineId;

  // 🏷️ اسم الدواء/الصنف
  final String medicineName;

  // 🔢 مستوى الوحدة المشراة (1 = علبة، 2 = شريط، 3 = قرص)
  final int unitLevel;

  // 🏷️ اسم الوحدة المشراة (علبة، شريط، قرص)
  final String unitName;

  // 📦 الكمية المشتراة
  final int quantity;

  // 💵 سعر شراء الوحدة (التكلفة)
  final double buyPrice;

  // 🏷️ سعر بيع الوحدة للجمهور
  final double sellPrice;

  // ⏳ تاريخ الصلاحية للدفعة المشتراة
  final DateTime? expiryDate;

  // 🔢 رقم التشغيلة/الدفعة (Batch Number)
  final String? batchNumber;

  // 💰 إجمالي سعر التكلفة للسطر
  final double totalPrice;

  // ─── Backward Compatibility Getters ───
  double get unitPrice => buyPrice;
  double get discount => 0.0;
  double get taxAmount => 0.0;

  PurchaseItemModel({
    required this.medicineId,
    required this.medicineName,
    required this.unitLevel,
    required this.unitName,
    required this.quantity,
    required this.buyPrice,
    required this.sellPrice,
    this.expiryDate,
    this.batchNumber,
    required this.totalPrice,
  });

  Map<String, dynamic> toJson() => {
    'medicine_id': medicineId,
    'medicine_name': medicineName,
    'unit_level': unitLevel,
    'unit_name': unitName,
    'quantity': quantity,
    'buy_price': buyPrice,
    'sell_price': sellPrice,
    'expiry_date': expiryDate?.toIso8601String(),
    'batch_number': batchNumber,
    'total_price': totalPrice,
  };

  factory PurchaseItemModel.fromJson(Map<String, dynamic> json) => PurchaseItemModel(
    medicineId: json['medicine_id'] as String,
    medicineName: json['medicine_name'] as String,
    unitLevel: (json['unit_level'] as num?)?.toInt() ?? 1,
    unitName: (json['unit_name'] as String?) ?? 'علبة',
    quantity: (json['quantity'] as num?)?.toInt() ?? 1,
    buyPrice: (json['buy_price'] as num?)?.toDouble() ?? 0.0,
    sellPrice: (json['sell_price'] as num?)?.toDouble() ?? 0.0,
    expiryDate: json['expiry_date'] != null ? DateTime.tryParse(json['expiry_date'] as String) : null,
    batchNumber: json['batch_number'] as String?,
    totalPrice: (json['total_price'] as num?)?.toDouble() ?? 0.0,
  );
}

/// 📦 موديل فاتورة المشتريات من الموردين (Purchase Invoice Model)
class PurchaseInvoiceModel implements SyncableEntity {
  // 🆔 المعرف الفريد لفاتورة المشتريات (Primary Key)
  final String id;

  // 🔢 رقم فاتورة المورد المرجعي (مثل: PUR-8890)
  final String invoiceNumber;

  // 🚚 معرف المورد
  final String supplierId;

  // 🚚 اسم شركة/مكتب المورد
  final String supplierName;

  // 📦 قائمة الأصناف المشتراة داخل الفاتورة
  final List<PurchaseItemModel> items;

  // 💰 إجمالي مبلغ المشتريات قبل الخصم
  final double subtotalAmount;

  // ٪ قيمة الخصم التجاري الممنوح من المورد
  final double discountAmount;

  // 💵 المبلغ الصافي النهائي الفعلي للفاتورة
  final double finalAmount;

  // 💵 المبلغ المسدد للمورد
  final double paidAmount;

  // 🏷️ المبلغ المتبقي المستحق للمورد
  final double remainingAmount;

  // 💳 طريقة الدفع (كاش / آجل / تحويل بانكي)
  final String paymentMethod;

  // 👤 اسم/معرف الموظف الذي أدخل فاتورة المشتريات
  final String createdBy;

  // 🏬 معرف الفرع
  final String branchId;

  // 🏢 معرف الحساب الرئيسي / المؤسسة
  final String accountId;

  // 📝 ملاحظات الفاتورة
  final String? notes;

  // 📅 تاريخ الفاتورة
  final DateTime createdAt;

  // 🕒 تاريخ آخر تعديل
  @override
  final DateTime lastModified;

  // 🗑️ حالة الحذف المنطقي
  @override
  final bool isDeleted;

  // ⚙️ نسخة المزامنة
  final int syncVersion;

  // ─── Backward Compatibility Getters ───
  String? get receiptNumber => invoiceNumber;
  String get status => 'completed'; // Default
  String? get supplierPhone => null; // Needs join or store in model
  String? get sourceType => 'local';
  double get shippingAmount => 0.0;
  double get deliveryAmount => 0.0;
  double get invoiceTaxAmount => 0.0;
  double get invoiceDiscountAmount => discountAmount;
  String? get invoiceDiscountType => 'fixed';
  double get invoiceDiscountValue => discountAmount;
  String? get invoiceTaxType => 'none';
  double get invoiceTaxValue => 0.0;
  String? get paymentAccountName => null;

  @override
  String? get syncBranchId => branchId;

  PurchaseInvoiceModel({
    required this.id,
    required this.invoiceNumber,
    required this.supplierId,
    required this.supplierName,
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
    'supplier_id': supplierId,
    'supplier_name': supplierName,
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

  factory PurchaseInvoiceModel.fromJson(Map<String, dynamic> json) => PurchaseInvoiceModel(
    id: json['id'] as String,
    invoiceNumber: json['invoice_number'] as String,
    supplierId: json['supplier_id'] as String? ?? '',
    supplierName: json['supplier_name'] as String? ?? '',
    items: (json['items'] as List<dynamic>?)
        ?.map((e) => PurchaseItemModel.fromJson(e as Map<String, dynamic>))
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

  PurchaseInvoiceModel copyWith({
    String? id,
    String? invoiceNumber,
    String? supplierId,
    String? supplierName,
    List<PurchaseItemModel>? items,
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
    return PurchaseInvoiceModel(
      id: id ?? this.id,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      supplierId: supplierId ?? this.supplierId,
      supplierName: supplierName ?? this.supplierName,
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


