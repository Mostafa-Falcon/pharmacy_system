import 'package:pharmacy_system/app/core/sync/syncable_entity.dart';

/// ٪ نوع الخصم الترويجي (مبلغ ثابت أم نسبة مئوية)
enum PromotionDiscountType {
  percentage, // نسبة مئوية %
  fixedAmount, // مبلغ ثابت ج.م
}

/// 🎁 موديل العروض والخصومات الترويجية (Promotion / Promotional Discount Model)
class PromotionModel implements SyncableEntity {
  // 🆔 المعرف الفريد للعرض الترويجي (Primary Key)
  final String id;

  // 🏷️ اسم العرض الترويجي (مثل: عرض خصم باي الكوفان / عروض الصيف)
  final String name;

  // 💊 قائمة معرفات الأصناف المستهدفة (اتركها فارغة لتطبيقها على الكل)
  final List<String>? selectedMedicineIds;

  // 📂 معرف المجموعة الرئيسية المخصصة (إن وجدت مثل: عيون)
  final String? categoryId;

  // 🏢 معرف الماركة/الشركة المخصصة (إن وجدت مثل: Amoun)
  final String? brandId;

  // 🔢 أولوية العرض (Priority Number مثل: 1, 4)
  final int priority;

  // ٪ نوع الخصم (نسبة مئوية percentage أم مبلغ ثابت fixedAmount)
  final PromotionDiscountType discountType;

  // 💰 قيمة أو نسبة الخصم (مثل: 4.00 للـ % أم 10.00 ج.م)
  final double discountValue;

  // 📅 تاريخ ووقت بداية تفعيل العرض الترويجي
  final DateTime startDate;

  // 📅 تاريخ ووقت نهاية تفعيل العرض الترويجي
  final DateTime endDate;

  // 🟢 حالة تفعيل العرض (مفعل أم متوقف)
  final bool isActive;

  // 🏬 معرف الفرع
  final String branchId;

  // 🏢 معرف الحساب الرئيسي / المؤسسة
  final String accountId;

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

  PromotionModel({
    required this.id,
    required this.name,
    this.selectedMedicineIds,
    this.categoryId,
    this.brandId,
    this.priority = 1,
    this.discountType = PromotionDiscountType.percentage,
    required this.discountValue,
    required this.startDate,
    required this.endDate,
    this.isActive = true,
    required this.branchId,
    required this.accountId,
    DateTime? lastModified,
    this.isDeleted = false,
    this.syncVersion = 1,
  }) : lastModified = lastModified ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'selected_medicine_ids': selectedMedicineIds,
    'category_id': categoryId,
    'brand_id': brandId,
    'priority': priority,
    'discount_type': discountType.name,
    'discount_value': discountValue,
    'start_date': startDate.toIso8601String(),
    'end_date': endDate.toIso8601String(),
    'is_active': isActive,
    'branch_id': branchId,
    'account_id': accountId,
    'last_modified': lastModified.toIso8601String(),
    'is_deleted': isDeleted,
    'sync_version': syncVersion,
  };

  factory PromotionModel.fromJson(Map<String, dynamic> json) => PromotionModel(
    id: json['id'] as String,
    name: json['name'] as String,
    selectedMedicineIds: (json['selected_medicine_ids'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
    categoryId: json['category_id'] as String?,
    brandId: json['brand_id'] as String?,
    priority: (json['priority'] as num?)?.toInt() ?? 1,
    discountType: json['discount_type'] == 'fixedAmount'
        ? PromotionDiscountType.fixedAmount
        : PromotionDiscountType.percentage,
    discountValue: (json['discount_value'] as num?)?.toDouble() ?? 0.0,
    startDate: DateTime.tryParse(json['start_date'] as String? ?? '') ?? DateTime.now(),
    endDate: DateTime.tryParse(json['end_date'] as String? ?? '') ?? DateTime.now(),
    isActive: json['is_active'] as bool? ?? true,
    branchId: json['branch_id'] as String? ?? '',
    accountId: json['account_id'] as String? ?? '',
    lastModified: DateTime.tryParse(json['last_modified'] as String? ?? '') ?? DateTime.now(),
    isDeleted: json['is_deleted'] as bool? ?? false,
    syncVersion: (json['sync_version'] as num?)?.toInt() ?? 1,
  );

  PromotionModel copyWith({
    String? id,
    String? name,
    List<String>? selectedMedicineIds,
    String? categoryId,
    String? brandId,
    int? priority,
    PromotionDiscountType? discountType,
    double? discountValue,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    String? branchId,
    String? accountId,
    DateTime? lastModified,
    bool? isDeleted,
    int? syncVersion,
  }) {
    return PromotionModel(
      id: id ?? this.id,
      name: name ?? this.name,
      selectedMedicineIds: selectedMedicineIds ?? this.selectedMedicineIds,
      categoryId: categoryId ?? this.categoryId,
      brandId: brandId ?? this.brandId,
      priority: priority ?? this.priority,
      discountType: discountType ?? this.discountType,
      discountValue: discountValue ?? this.discountValue,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
      branchId: branchId ?? this.branchId,
      accountId: accountId ?? this.accountId,
      lastModified: lastModified ?? this.lastModified,
      isDeleted: isDeleted ?? this.isDeleted,
      syncVersion: syncVersion ?? this.syncVersion,
    );
  }
}
