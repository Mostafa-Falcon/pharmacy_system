/// 📋 حالة جلسة/ورقة الجرد المخزني
enum StocktakingStatus {
  draft,     // مسودة جرد (جاري التحرير والإدخال)
  confirmed, // معتمد ومسوى (تم اعتماد التسوية وتعديل المخزون)
}

/// 📦 موديل سطر الصنف المجرود في ورقة الجرد
class StocktakingItemModel {
  // 🆔 المعرف الفريد لسطر الجرد
  final String id;

  // 💊 معرف الصنف/الدواء
  final String medicineId;

  // 🏷️ اسم الصنف وتفاصيل الشجرة (مثال: أسپوسيد 75 مجم)
  final String medicineName;

  // 🔢 كود الباركود/التكويدي الصريح للصنف (SKU)
  final String? sku;

  // 📦 نص الرصيد الدفتري بالسيستم (مثال: 180 علبة + 1 شريط + 5 قرص)
  final String bookQuantityText;

  // ⏳ تاريخ صلاحية التشغيلة المجرودة
  final DateTime? expiryDate;

  // 📥 الرصيد الفعلي المدخل - الوحدة 1 (مثال: عدد العلب الفعلي)
  final int actualUnit1Qty;

  // 📥 الرصيد الفعلي المدخل - الوحدة 2 (مثال: عدد الأشرطة الفعلي)
  final int? actualUnit2Qty;

  // 📥 الرصيد الفعلي المدخل - الوحدة 3 (مثال: عدد الأقراص الفعلي)
  final int? actualUnit3Qty;

  // 💵 سعر تكلفة الوحدة الرئيسية بالجنيه
  final double unitCost;

  // ⚖️ الفرق العددي الإجمالي بين الرصيد الفعلي والدفتري
  final int differenceQuantity;

  // 💰 القيمة المالية الإجمالية للفرق بالجنيه (عجز بالسالب أم زيادة بالموجب)
  final double differenceValue;

  // 📝 ملاحظات الصيدلي على الصنف المجرود
  final String? notes;

  StocktakingItemModel({
    required this.id,
    required this.medicineId,
    required this.medicineName,
    this.sku,
    required this.bookQuantityText,
    this.expiryDate,
    required this.actualUnit1Qty,
    this.actualUnit2Qty,
    this.actualUnit3Qty,
    required this.unitCost,
    this.differenceQuantity = 0,
    this.differenceValue = 0.0,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'medicine_id': medicineId,
    'medicine_name': medicineName,
    'sku': sku,
    'book_quantity_text': bookQuantityText,
    'expiry_date': expiryDate?.toIso8601String(),
    'actual_unit1_qty': actualUnit1Qty,
    'actual_unit2_qty': actualUnit2Qty,
    'actual_unit3_qty': actualUnit3Qty,
    'unit_cost': unitCost,
    'difference_quantity': differenceQuantity,
    'difference_value': differenceValue,
    'notes': notes,
  };

  factory StocktakingItemModel.fromJson(Map<String, dynamic> json) => StocktakingItemModel(
    id: json['id'] as String,
    medicineId: json['medicine_id'] as String,
    medicineName: json['medicine_name'] as String,
    sku: json['sku'] as String?,
    bookQuantityText: json['book_quantity_text'] as String? ?? '',
    expiryDate: json['expiry_date'] != null ? DateTime.tryParse(json['expiry_date'] as String) : null,
    actualUnit1Qty: (json['actual_unit1_qty'] as num?)?.toInt() ?? 0,
    actualUnit2Qty: (json['actual_unit2_qty'] as num?)?.toInt(),
    actualUnit3Qty: (json['actual_unit3_qty'] as num?)?.toInt(),
    unitCost: (json['unit_cost'] as num?)?.toDouble() ?? 0.0,
    differenceQuantity: (json['difference_quantity'] as num?)?.toInt() ?? 0,
    differenceValue: (json['difference_value'] as num?)?.toDouble() ?? 0.0,
    notes: json['notes'] as String?,
  );
}

/// 📋 موديل جلسة وورقة الجرد المخزني الموحد (Stocktaking Model)
class StocktakingModel {
  // 🆔 المعرف الفريد لجلسة الجرد (Primary Key)
  final String id;

  // 🔢 الرقم المرجعي لإذن/ورقة الجرد (مثال: ADJ-0016)
  final String referenceNumber;

  // 📅 تاريخ ووقت إجراء ورقة الجرد
  final DateTime stocktakingDate;

  // 🏷️ حالة الجرد (مسودة draft أم معتمد confirmed)
  final StocktakingStatus status;

  // 💰 إجمالي القيمة المالية للفروق بالجنيه
  final double totalDifferenceValue;

  // 📂 معرف الفئة المحددة بالجرد (لو كان الجرد جزئياً)
  final String? categoryId;

  // 🏷️ معرف الشركة/الماركة المحددة للجرد
  final String? brandId;

  // 📦 قائمة الأصناف والتشغيلات المجرودة
  final List<StocktakingItemModel> items;

  // 📝 ملاحظات جلسة الجرد
  final String? notes;

  // 👤 اسم/معرف الصيدلي الذي قام بعملية الجرد
  final String createdBy;

  // 🏬 معرف الفرع
  final String branchId;

  // 🏢 معرف الحساب الرئيسي / المؤسسة
  final String accountId;

  // 🕒 تاريخ ووقت آخر تعديل
  final DateTime lastModified;

  // 🗑️ حالة الحذف المنطقي
  final bool isDeleted;

  StocktakingModel({
    required this.id,
    required this.referenceNumber,
    DateTime? stocktakingDate,
    this.status = StocktakingStatus.draft,
    this.totalDifferenceValue = 0.0,
    this.categoryId,
    this.brandId,
    required this.items,
    this.notes,
    required this.createdBy,
    required this.branchId,
    required this.accountId,
    DateTime? lastModified,
    this.isDeleted = false,
  })  : stocktakingDate = stocktakingDate ?? DateTime.now(),
        lastModified = lastModified ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'reference_number': referenceNumber,
    'stocktaking_date': stocktakingDate.toIso8601String(),
    'status': status.name,
    'total_difference_value': totalDifferenceValue,
    'category_id': categoryId,
    'brand_id': brandId,
    'items': items.map((i) => i.toJson()).toList(),
    'notes': notes,
    'created_by': createdBy,
    'branch_id': branchId,
    'account_id': accountId,
    'last_modified': lastModified.toIso8601String(),
    'is_deleted': isDeleted,
  };

  factory StocktakingModel.fromJson(Map<String, dynamic> json) => StocktakingModel(
    id: json['id'] as String,
    referenceNumber: json['reference_number'] as String,
    stocktakingDate: DateTime.tryParse(json['stocktaking_date'] as String? ?? '') ?? DateTime.now(),
    status: json['status'] == 'confirmed' ? StocktakingStatus.confirmed : StocktakingStatus.draft,
    totalDifferenceValue: (json['total_difference_value'] as num?)?.toDouble() ?? 0.0,
    categoryId: json['category_id'] as String?,
    brandId: json['brand_id'] as String?,
    items: (json['items'] as List<dynamic>?)
        ?.map((e) => StocktakingItemModel.fromJson(e as Map<String, dynamic>))
        .toList() ?? [],
    notes: json['notes'] as String?,
    createdBy: json['created_by'] as String? ?? '',
    branchId: json['branch_id'] as String? ?? '',
    accountId: json['account_id'] as String? ?? '',
    lastModified: DateTime.tryParse(json['last_modified'] as String? ?? '') ?? DateTime.now(),
    isDeleted: json['is_deleted'] as bool? ?? false,
  );
}


