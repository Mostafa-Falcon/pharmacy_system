/// 🔄 نوع العملية الأصلية للمرتجع الحر (مرتجع مبيعات / مرتجع مشتريات)
enum FreeReturnCategory {
  saleReturn,     // مرتجع مبيعات حر
  purchaseReturn, // مرتجع مشتريات حر
}

/// 🤝 الأربعة أنواع الصريحة للطرف في المرتجع الحر (نقدي / عميل / مورد / عميل ومورد)
enum FreeReturnPartyType {
  cash,             // 1. نقدي
  customer,         // 2. عميل
  supplier,         // 3. مورد
  supplierCustomer, // 4. عميل / مورد (الصيدليات والشركاء المزدوجين)
}

/// 📦 موديل سطر الصنف المرجّع فـ المرتجع الحر
class FreeReturnItemModel {
  // 💊 معرف الدواء/الصنف
  final String medicineId;

  // 🏷️ اسم الدواء/الصنف بالعربي
  final String medicineName;

  // 🔢 مستوى الوحدة المرجعة (1 = علبة، 2 = شريط، 3 = قرص)
  final int unitLevel;

  // 🏷️ اسم الوحدة المرجعة (علبة، شريط، قرص)
  final String unitName;

  // 📦 الكمية المرجعة
  final int quantity;

  // 💵 سعر وحدة المرتجع
  final double unitPrice;

  // ⏳ تاريخ الصلاحية المكتوب على العبوة المرجعة
  final DateTime? expiryDate;

  // 💰 إجمالي قيمة سطر المرتجع (الكمية × السعر)
  final double totalPrice;

  FreeReturnItemModel({
    required this.medicineId,
    required this.medicineName,
    required this.unitLevel,
    required this.unitName,
    required this.quantity,
    required this.unitPrice,
    this.expiryDate,
    required this.totalPrice,
  });

  FreeReturnItemModel copyWith({
    String? medicineId,
    String? medicineName,
    int? unitLevel,
    String? unitName,
    int? quantity,
    double? unitPrice,
    bool clearExpiryDate = false,
    DateTime? expiryDate,
    double? totalPrice,
  }) =>
      FreeReturnItemModel(
        medicineId: medicineId ?? this.medicineId,
        medicineName: medicineName ?? this.medicineName,
        unitLevel: unitLevel ?? this.unitLevel,
        unitName: unitName ?? this.unitName,
        quantity: quantity ?? this.quantity,
        unitPrice: unitPrice ?? this.unitPrice,
        expiryDate:
            clearExpiryDate ? null : (expiryDate ?? this.expiryDate),
        totalPrice: totalPrice ?? this.totalPrice,
      );

  Map<String, dynamic> toJson() => {
    'medicine_id': medicineId,
    'medicine_name': medicineName,
    'unit_level': unitLevel,
    'unit_name': unitName,
    'quantity': quantity,
    'unit_price': unitPrice,
    'expiry_date': expiryDate?.toIso8601String(),
    'total_price': totalPrice,
  };

  factory FreeReturnItemModel.fromJson(Map<String, dynamic> json) => FreeReturnItemModel(
    medicineId: json['medicine_id'] as String,
    medicineName: json['medicine_name'] as String,
    unitLevel: (json['unit_level'] as num?)?.toInt() ?? 1,
    unitName: (json['unit_name'] as String?) ?? 'علبة',
    quantity: (json['quantity'] as num?)?.toInt() ?? 1,
    unitPrice: (json['unit_price'] as num?)?.toDouble() ?? 0.0,
    expiryDate: json['expiry_date'] != null ? DateTime.tryParse(json['expiry_date'] as String) : null,
    totalPrice: (json['total_price'] as num?)?.toDouble() ?? 0.0,
  );
}

/// 📋 موديل المرتجع الحر المباشر بدون فاتورة سابقة (Free Return Model)
class FreeReturnModel {
  // 🆔 المعرف الفريد لإذن المرتجع الحر (Primary Key)
  final String id;

  // 🔢 رقم إذن المرتجع التسلسلي المرجعي
  final String returnNumber;

  // 🔄 نوع المرتجع الأصلي (مرتجع مبيعات saleReturn / مرتجع مشتريات purchaseReturn)
  final FreeReturnCategory returnCategory;

  // 🤝 الأربعة أنواع الصريحة للطرف (نقدي / عميل / مورد / عميل ومورد)
  final FreeReturnPartyType partyType;

  // 👤 معرف الطرف المختارات (اختياري في حالة النقدي)
  final String? partyId;

  // 👤 اسم الطرف المختارات (مثل: زبون نقدي / شركة ابن سينا / صيدلية النور)
  final String partyName;

  // 💳 معرف الخزينة المسؤولة عن المرتجع المالي (مثل: إنستاباي / الخزينة الرئيسية)
  final String cashRegisterId;

  // 📝 السبب أو الملاحظة المدونة للمرتجع (مثل: تالف، خطأ في الطلب)
  final String? reasonNotes;

  // 📦 قائمة أصناف المرتجع الحر
  final List<FreeReturnItemModel> items;

  // 💰 إجمالي المبلغ المرجّع المالي بالجنيه
  final double totalAmount;

  // 👤 اسم/معرف الصيدلي الذي سجل المرتجع
  final String createdBy;

  // 🏬 معرف الفرع
  final String branchId;

  // 🏢 معرف الحساب الرئيسي / المؤسسة
  final String accountId;

  // 📅 تاريخ ووقت تسجيل المرتجع
  final DateTime createdAt;

  // 🕒 تاريخ ووقت آخر تعديل
  final DateTime lastModified;

  FreeReturnModel({
    required this.id,
    required this.returnNumber,
    required this.returnCategory,
    this.partyType = FreeReturnPartyType.cash,
    this.partyId,
    required this.partyName,
    required this.cashRegisterId,
    this.reasonNotes,
    required this.items,
    required this.totalAmount,
    required this.createdBy,
    required this.branchId,
    required this.accountId,
    DateTime? createdAt,
    DateTime? lastModified,
  })  : createdAt = createdAt ?? DateTime.now(),
        lastModified = lastModified ?? DateTime.now();

  FreeReturnModel copyWith({
    String? id,
    String? returnNumber,
    FreeReturnCategory? returnCategory,
    FreeReturnPartyType? partyType,
    bool clearPartyId = false,
    String? partyId,
    String? partyName,
    String? cashRegisterId,
    bool clearReasonNotes = false,
    String? reasonNotes,
    List<FreeReturnItemModel>? items,
    double? totalAmount,
    String? createdBy,
    String? branchId,
    String? accountId,
    DateTime? createdAt,
    DateTime? lastModified,
  }) =>
      FreeReturnModel(
        id: id ?? this.id,
        returnNumber: returnNumber ?? this.returnNumber,
        returnCategory: returnCategory ?? this.returnCategory,
        partyType: partyType ?? this.partyType,
        partyId: clearPartyId ? null : (partyId ?? this.partyId),
        partyName: partyName ?? this.partyName,
        cashRegisterId: cashRegisterId ?? this.cashRegisterId,
        reasonNotes:
            clearReasonNotes ? null : (reasonNotes ?? this.reasonNotes),
        items: items ?? this.items,
        totalAmount: totalAmount ?? this.totalAmount,
        createdBy: createdBy ?? this.createdBy,
        branchId: branchId ?? this.branchId,
        accountId: accountId ?? this.accountId,
        createdAt: createdAt ?? this.createdAt,
        lastModified: lastModified ?? this.lastModified,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'return_number': returnNumber,
    'return_category': returnCategory.name,
    'party_type': partyType.name,
    'party_id': partyId,
    'party_name': partyName,
    'cash_register_id': cashRegisterId,
    'reason_notes': reasonNotes,
    'items': items.map((i) => i.toJson()).toList(),
    'total_amount': totalAmount,
    'created_by': createdBy,
    'branch_id': branchId,
    'account_id': accountId,
    'created_at': createdAt.toIso8601String(),
    'last_modified': lastModified.toIso8601String(),
  };

  factory FreeReturnModel.fromJson(Map<String, dynamic> json) => FreeReturnModel(
    id: json['id'] as String,
    returnNumber: json['return_number'] as String,
    returnCategory: json['return_category'] == 'purchaseReturn'
        ? FreeReturnCategory.purchaseReturn
        : FreeReturnCategory.saleReturn,
    partyType: json['party_type'] == 'supplierCustomer'
        ? FreeReturnPartyType.supplierCustomer
        : json['party_type'] == 'supplier'
            ? FreeReturnPartyType.supplier
            : json['party_type'] == 'customer'
                ? FreeReturnPartyType.customer
                : FreeReturnPartyType.cash,
    partyId: json['party_id'] as String?,
    partyName: json['party_name'] as String? ?? 'نقدي',
    cashRegisterId: json['cash_register_id'] as String? ?? '',
    reasonNotes: json['reason_notes'] as String?,
    items: (json['items'] as List<dynamic>?)
        ?.map((e) => FreeReturnItemModel.fromJson(e as Map<String, dynamic>))
        .toList() ?? [],
    totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
    createdBy: json['created_by'] as String? ?? '',
    branchId: json['branch_id'] as String? ?? '',
    accountId: json['account_id'] as String? ?? '',
    createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
    lastModified: DateTime.tryParse(json['last_modified'] as String? ?? '') ?? DateTime.now(),
  );
}


