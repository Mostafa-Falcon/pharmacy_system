import 'package:pharmacy_system/app/core/sync/syncable_entity.dart';

/// 📦 موديل سطر المرتجع المربوط بالفاتورة
class InvoiceReturnItemModel {
  // 💊 معرف الدواء/الصنف
  final String medicineId;

  // 🏷️ اسم الدواء/الصنف بالعربي
  final String medicineName;

  // 🔢 مستوى الوحدة المرجعة (1 = علبة، 2 = شريط، 3 = قرص)
  final int unitLevel;

  // 🏷️ اسم الوحدة المرجعة (علبة، شريط، قرص)
  final String unitName;

  // 📦 الكمية الأصلية المسجلة بالفاتورة الأصلية
  final int originalQuantity;

  // 📦 الكمية المتاحة للإرجاع فعلياً
  final int availableQuantityToReturn;

  // 📦 الكمية المرجعة في هذه العملية
  final int quantityToReturn;

  // 💵 سعر وحدة المرتجع
  final double unitPrice;

  // 💰 إجمالي سعر سطر المرتجع
  final double totalPrice;

  InvoiceReturnItemModel({
    required this.medicineId,
    required this.medicineName,
    required this.unitLevel,
    required this.unitName,
    required this.originalQuantity,
    required this.availableQuantityToReturn,
    required this.quantityToReturn,
    required this.unitPrice,
    required this.totalPrice,
  });

  Map<String, dynamic> toJson() => {
    'medicine_id': medicineId,
    'medicine_name': medicineName,
    'unit_level': unitLevel,
    'unit_name': unitName,
    'original_quantity': originalQuantity,
    'available_quantity_to_return': availableQuantityToReturn,
    'quantity_to_return': quantityToReturn,
    'unit_price': unitPrice,
    'total_price': totalPrice,
  };

  factory InvoiceReturnItemModel.fromJson(Map<String, dynamic> json) => InvoiceReturnItemModel(
    medicineId: json['medicine_id'] as String,
    medicineName: json['medicine_name'] as String,
    unitLevel: (json['unit_level'] as num?)?.toInt() ?? 1,
    unitName: (json['unit_name'] as String?) ?? 'علبة',
    originalQuantity: (json['original_quantity'] as num?)?.toInt() ?? 1,
    availableQuantityToReturn: (json['available_quantity_to_return'] as num?)?.toInt() ?? 1,
    quantityToReturn: (json['quantity_to_return'] as num?)?.toInt() ?? 1,
    unitPrice: (json['unit_price'] as num?)?.toDouble() ?? 0.0,
    totalPrice: (json['total_price'] as num?)?.toDouble() ?? 0.0,
  );
}

/// 📋 موديل مرتجع المبيعات المربوط بالفاتورة المباشر (Invoice-Linked Sale Return Model)
class InvoiceReturnModel implements SyncableEntity {
  // 🆔 المعرف الفريد لإذن المرتجع (Primary Key)
  final String id;

  // 🔢 رقم إذن المرتجع المرجعي (مثل: R0017)
  final String returnNumber;

  // 🔢 رقم الفاتورة الأصلية المباع منها الصنف (مثل: مرتجع للفاتورة 0298)
  final String originalInvoiceNumber;

  // 🆔 معرف الفاتورة الأصلية
  final String originalInvoiceId;

  // 👤 اسم العميل / مورد عميل 3 / زبون نقدي
  final String customerName;

  // 👤 معرف العميل
  final String? customerId;

  // 📦 قائمة الأصناف المرجعة من الفاتورة
  final List<InvoiceReturnItemModel> items;

  // ٪ قيمة الخصم المطبقة على المرتجع
  final double returnDiscount;

  // 💰 إجمالي المبلغ المرجّع مالي بالسالب (مثل: -7000.00 ج.م)
  final double totalReturnAmount;

  // 👤 اسم/معرف الصيدلي الذي سجل المرتجع (مثل: د. أحمد)
  final String createdBy;

  // 🏬 معرف الفرع
  final String branchId;

  // 🏢 معرف الحساب الرئيسي / المؤسسة
  final String accountId;

  // 📝 ملاحظات المرتجع
  final String? notes;

  // 📅 تاريخ ووقت عملية المرتجع
  final DateTime createdAt;

  // 🕒 تاريخ ووقت آخر تعديل
  @override
  final DateTime lastModified;

  // 🗑️ حالة الحذف المنطقي
  @override
  final bool isDeleted;

  // ⚙️ نسخة المزامنة
  final int syncVersion;

  @override
  String? get syncBranchId => branchId;

  InvoiceReturnModel({
    required this.id,
    required this.returnNumber,
    required this.originalInvoiceNumber,
    required this.originalInvoiceId,
    required this.customerName,
    this.customerId,
    required this.items,
    this.returnDiscount = 0.0,
    required this.totalReturnAmount,
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
    'return_number': returnNumber,
    'original_invoice_number': originalInvoiceNumber,
    'original_invoice_id': originalInvoiceId,
    'customer_name': customerName,
    'customer_id': customerId,
    'items': items.map((i) => i.toJson()).toList(),
    'return_discount': returnDiscount,
    'total_return_amount': totalReturnAmount,
    'created_by': createdBy,
    'branch_id': branchId,
    'account_id': accountId,
    'notes': notes,
    'created_at': createdAt.toIso8601String(),
    'last_modified': lastModified.toIso8601String(),
    'is_deleted': isDeleted,
    'sync_version': syncVersion,
  };

  factory InvoiceReturnModel.fromJson(Map<String, dynamic> json) => InvoiceReturnModel(
    id: json['id'] as String,
    returnNumber: json['return_number'] as String,
    originalInvoiceNumber: json['original_invoice_number'] as String? ?? '',
    originalInvoiceId: json['original_invoice_id'] as String? ?? '',
    customerName: json['customer_name'] as String? ?? 'زبون نقدي',
    customerId: json['customer_id'] as String?,
    items: (json['items'] as List<dynamic>?)
        ?.map((e) => InvoiceReturnItemModel.fromJson(e as Map<String, dynamic>))
        .toList() ?? [],
    returnDiscount: (json['return_discount'] as num?)?.toDouble() ?? 0.0,
    totalReturnAmount: (json['total_return_amount'] as num?)?.toDouble() ?? 0.0,
    createdBy: json['created_by'] as String? ?? '',
    branchId: json['branch_id'] as String? ?? '',
    accountId: json['account_id'] as String? ?? '',
    notes: json['notes'] as String?,
    createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
    lastModified: DateTime.tryParse(json['last_modified'] as String? ?? '') ?? DateTime.now(),
    isDeleted: json['is_deleted'] as bool? ?? false,
    syncVersion: (json['sync_version'] as num?)?.toInt() ?? 1,
  );

  InvoiceReturnModel copyWith({
    String? id,
    String? returnNumber,
    String? originalInvoiceNumber,
    String? originalInvoiceId,
    String? customerName,
    String? customerId,
    List<InvoiceReturnItemModel>? items,
    double? returnDiscount,
    double? totalReturnAmount,
    String? createdBy,
    String? branchId,
    String? accountId,
    String? notes,
    DateTime? createdAt,
    DateTime? lastModified,
    bool? isDeleted,
    int? syncVersion,
  }) {
    return InvoiceReturnModel(
      id: id ?? this.id,
      returnNumber: returnNumber ?? this.returnNumber,
      originalInvoiceNumber: originalInvoiceNumber ?? this.originalInvoiceNumber,
      originalInvoiceId: originalInvoiceId ?? this.originalInvoiceId,
      customerName: customerName ?? this.customerName,
      customerId: customerId ?? this.customerId,
      items: items ?? this.items,
      returnDiscount: returnDiscount ?? this.returnDiscount,
      totalReturnAmount: totalReturnAmount ?? this.totalReturnAmount,
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
