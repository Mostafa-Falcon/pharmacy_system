import 'package:pharmacy_system/app/core/data/database/syncable_entity.dart';

/// Backward Compatibility Type Alias
typedef QuoteModel = QuotationModel;

/// 💳 حالة دفع عرض السعر
enum QuotationPaymentStatus {
  unpaid,   // غير مدفوع
  partial,  // مدفوع جزئياً
  paid,     // مدفوع
}

/// 🚚 حالة الشحن والتوصيل لعرض السعر
enum QuotationShippingStatus {
  pending,    // في الانتظار
  shipping,   // جاري الشحن
  delivered,  // تم التوصيل
}

/// 📦 موديل سطر الصنف داخل عرض السعر
class QuotationItemModel {
  // 💊 معرف الصنف/الدواء
  final String medicineId;

  // 🏷️ اسم الصنف/الدواء
  final String medicineName;

  // 🔢 مستوى الوحدة المباعة (1 = علبة، 2 = شريط، 3 = قرص)
  final int unitLevel;

  // 🏷️ اسم الوحدة المباعة (علبة، شريط، قرص)
  final String unitName;

  // 📦 الكمية المطلوبة من هذه الوحدة
  final int quantity;

  // 💵 سعر بيع الوحدة المحددة
  final double unitPrice;

  // ٪ قيمة الخصم المطبقة على الصنف
  final double discountValue;

  // 💰 إجمالي سعر السطر (الكمية × السعر - الخصم)
  final double totalPrice;

  QuotationItemModel({
    required this.medicineId,
    required this.medicineName,
    required this.unitLevel,
    required this.unitName,
    required this.quantity,
    required this.unitPrice,
    this.discountValue = 0.0,
    required this.totalPrice,
  });

  Map<String, dynamic> toJson() => {
    'medicine_id': medicineId,
    'medicine_name': medicineName,
    'unit_level': unitLevel,
    'unit_name': unitName,
    'quantity': quantity,
    'unit_price': unitPrice,
    'discount_value': discountValue,
    'total_price': totalPrice,
  };

  factory QuotationItemModel.fromJson(Map<String, dynamic> json) => QuotationItemModel(
    medicineId: json['medicine_id'] as String,
    medicineName: json['medicine_name'] as String,
    unitLevel: (json['unit_level'] as num?)?.toInt() ?? 1,
    unitName: (json['unit_name'] as String?) ?? 'علبة',
    quantity: (json['quantity'] as num?)?.toInt() ?? 1,
    unitPrice: (json['unit_price'] as num?)?.toDouble() ?? 0.0,
    discountValue: (json['discount_value'] as num?)?.toDouble() ?? 0.0,
    totalPrice: (json['total_price'] as num?)?.toDouble() ?? 0.0,
  );
}

/// 📋 موديل عرض السعر الموحد بالكامل (عروض الأسعار)
class QuotationModel implements SyncableEntity {
  // 🆔 المعرف الفريد لعرض السعر (Primary Key)
  final String id;

  // 🔢 رقم عرض السعر المرجعي (مثال: 0271)
  final String quotationNumber;

  // 👤 معرف العميل/الزبون
  final String? customerId;

  // 👤 اسم العميل (مثال: زبون نقدي، سارة إبراهيم)
  final String customerName;

  // 📞 رقم هاتف/اتصال العميل
  final String? customerPhone;

  // 📦 قائمة الأصناف المضافة داخل عرض السعر
  final List<QuotationItemModel> items;

  // 💰 إجمالي قيمة عرض السعر بالكامل
  final double totalAmount;

  // 💵 مدفوعات المبيعات (المبلغ المدفوع عربون أو مقدماً)
  final double paidAmount;

  // 🏷️ المبلغ المتبقي المستحق على العميل
  final double remainingAmount;

  // 💳 طريقة الدفع المتوقعة (كاش، فيزا، آجل)
  final String? paymentMethod;

  // 💳 حالة السداد والدفع (غير مدفوع، مدفوع جزئياً، مدفوع)
  final QuotationPaymentStatus paymentStatus;

  // 🚚 حالة الشحن والتوصيل (في الانتظار، جاري الشحن، تم التوصيل)
  final QuotationShippingStatus shippingStatus;

  // 📦 إجمالي كمية الأصناف المضافة بالعرض
  final double totalQuantity;

  // 👤 اسم الصيدلي/الموظف الذي أنشأ عرض السعر (مثال: د. أحمد)
  final String createdBy;

  // 🏬 معرف الفرع التابع له عرض السعر
  final String branchId;

  // 🏢 معرف الحساب الرئيسي / المؤسسة
  final String accountId;

  // 📝 ملاحظات إضافية
  final String? notes;

  // 📅 تاريخ ووقت إنشاء عرض السعر
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

  QuotationModel({
    required this.id,
    required this.quotationNumber,
    this.customerId,
    required this.customerName,
    this.customerPhone,
    required this.items,
    required this.totalAmount,
    this.paidAmount = 0.0,
    required this.remainingAmount,
    this.paymentMethod,
    this.paymentStatus = QuotationPaymentStatus.unpaid,
    this.shippingStatus = QuotationShippingStatus.pending,
    required this.totalQuantity,
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

  QuotationModel copyWith({
    String? id,
    String? quotationNumber,
    String? customerId,
    String? customerName,
    String? customerPhone,
    List<QuotationItemModel>? items,
    double? totalAmount,
    double? paidAmount,
    double? remainingAmount,
    String? paymentMethod,
    QuotationPaymentStatus? paymentStatus,
    QuotationShippingStatus? shippingStatus,
    double? totalQuantity,
    String? createdBy,
    String? branchId,
    String? accountId,
    String? notes,
    DateTime? createdAt,
    DateTime? lastModified,
    bool? isDeleted,
    int? syncVersion,
  }) {
    return QuotationModel(
      id: id ?? this.id,
      quotationNumber: quotationNumber ?? this.quotationNumber,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      items: items ?? List.from(this.items),
      totalAmount: totalAmount ?? this.totalAmount,
      paidAmount: paidAmount ?? this.paidAmount,
      remainingAmount: remainingAmount ?? this.remainingAmount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      shippingStatus: shippingStatus ?? this.shippingStatus,
      totalQuantity: totalQuantity ?? this.totalQuantity,
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

  Map<String, dynamic> toJson() => {
    'id': id,
    'quotation_number': quotationNumber,
    'customer_id': customerId,
    'customer_name': customerName,
    'customer_phone': customerPhone,
    'items': items.map((i) => i.toJson()).toList(),
    'total_amount': totalAmount,
    'paid_amount': paidAmount,
    'remaining_amount': remainingAmount,
    'payment_method': paymentMethod,
    'payment_status': paymentStatus.name,
    'shipping_status': shippingStatus.name,
    'total_quantity': totalQuantity,
    'created_by': createdBy,
    'branch_id': branchId,
    'account_id': accountId,
    'notes': notes,
    'created_at': createdAt.toIso8601String(),
    'last_modified': lastModified.toIso8601String(),
    'is_deleted': isDeleted,
    'sync_version': syncVersion,
  };

  factory QuotationModel.fromJson(Map<String, dynamic> json) => QuotationModel(
    id: json['id'] as String,
    quotationNumber: json['quotation_number'] as String,
    customerId: json['customer_id'] as String?,
    customerName: json['customer_name'] as String? ?? 'زبون نقدي',
    customerPhone: json['customer_phone'] as String?,
    items: (json['items'] as List<dynamic>?)
        ?.map((e) => QuotationItemModel.fromJson(e as Map<String, dynamic>))
        .toList() ?? [],
    totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
    paidAmount: (json['paid_amount'] as num?)?.toDouble() ?? 0.0,
    remainingAmount: (json['remaining_amount'] as num?)?.toDouble() ?? 0.0,
    paymentMethod: json['payment_method'] as String?,
    paymentStatus: QuotationPaymentStatus.values.firstWhere(
      (e) => e.name == json['payment_status'],
      orElse: () => QuotationPaymentStatus.unpaid,
    ),
    shippingStatus: QuotationShippingStatus.values.firstWhere(
      (e) => e.name == json['shipping_status'],
      orElse: () => QuotationShippingStatus.pending,
    ),
    totalQuantity: (json['total_quantity'] as num?)?.toDouble() ?? 0.0,
    createdBy: json['created_by'] as String? ?? '',
    branchId: json['branch_id'] as String? ?? '',
    accountId: json['account_id'] as String? ?? '',
    notes: json['notes'] as String?,
    createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'] as String) ?? DateTime.now() : DateTime.now(),
    lastModified: json['last_modified'] != null ? DateTime.tryParse(json['last_modified'] as String) ?? DateTime.now() : DateTime.now(),
    isDeleted: json['is_deleted'] as bool? ?? false,
    syncVersion: (json['sync_version'] as num?)?.toInt() ?? 1,
  );
}
