/// 🏢 موديل ماركات وشركات تصنيع الأصناف (Medicine Brand Model)
class MedicineBrandModel {
  // 🆔 المعرف الفريد للماركة/الشركة (Primary Key)
  final String id;

  // 🏷️ اسم الماركة/الشركة المصنعة (مثل: Amoun, Bayer, EIPICO, Novartis)
  final String name;

  // 📝 وصف مختصر للماركة (مثل: أدوبة محلي، شركة عالمية)
  final String? description;

  // 🛠️ خيار استخدام للإصلاح (useForRepair)
  final bool useForRepair;

  // 🟢 حالة تفعيل الماركة
  final bool isActive;

  // 🏢 معرف الحساب الرئيسي / المؤسسة
  final String? accountId;

  // 🕒 تاريخ ووقت آخر تعديل
  final DateTime lastModified;

  // 🗑️ حالة الحذف المنطقي
  final bool isDeleted;

  MedicineBrandModel({
    required this.id,
    required this.name,
    this.description,
    this.useForRepair = false,
    this.isActive = true,
    this.accountId,
    DateTime? lastModified,
    this.isDeleted = false,
  }) : lastModified = lastModified ?? DateTime.now();

  MedicineBrandModel copyWith({
    String? id,
    String? name,
    String? description,
    bool? useForRepair,
    bool? isActive,
    String? accountId,
    DateTime? lastModified,
    bool? isDeleted,
  }) {
    return MedicineBrandModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      useForRepair: useForRepair ?? this.useForRepair,
      isActive: isActive ?? this.isActive,
      accountId: accountId ?? this.accountId,
      lastModified: lastModified ?? DateTime.now(),
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'use_for_repair': useForRepair,
    'is_active': isActive,
    'account_id': accountId,
    'last_modified': lastModified.toIso8601String(),
    'is_deleted': isDeleted,
  };

  factory MedicineBrandModel.fromJson(Map<String, dynamic> json) => MedicineBrandModel(
    id: json['id'] as String,
    name: json['name'] as String,
    description: json['description'] as String?,
    useForRepair: json['use_for_repair'] as bool? ?? false,
    isActive: json['is_active'] as bool? ?? true,
    accountId: json['account_id'] as String?,
    lastModified: json['last_modified'] != null
        ? DateTime.tryParse(json['last_modified'] as String) ?? DateTime.now()
        : DateTime.now(),
    isDeleted: json['is_deleted'] as bool? ?? false,
  );
}


