/// 🎨 موديل متغيرات وتباينات الأصناف (مثل: اللون، الحجم، التركيز)
class ItemVariantModel {
  // 🆔 المعرف الفريد للمتغير (Primary Key)
  final String id;

  // 🏷️ اسم المتغير (مثل: اللون، الحجم، التركيز)
  final String name;

  // 🎨 قائمة القيم المتاحة للمتغير (مثل: [أحمر، أصفر، 500mg, 1000mg])
  final List<String> values;

  // 🟢 حالة تفعيل المتغير
  final bool isActive;

  // 🏢 معرف الحساب الرئيسي / المؤسسة
  final String? accountId;

  // 🕒 تاريخ ووقت آخر تعديل
  final DateTime lastModified;

  // 🗑️ حالة الحذف المنطقي
  final bool isDeleted;

  ItemVariantModel({
    required this.id,
    required this.name,
    required this.values,
    this.isActive = true,
    this.accountId,
    DateTime? lastModified,
    this.isDeleted = false,
  }) : lastModified = lastModified ?? DateTime.now();

  ItemVariantModel copyWith({
    String? id,
    String? name,
    List<String>? values,
    bool? isActive,
    String? accountId,
    DateTime? lastModified,
    bool? isDeleted,
  }) {
    return ItemVariantModel(
      id: id ?? this.id,
      name: name ?? this.name,
      values: values ?? List.from(this.values),
      isActive: isActive ?? this.isActive,
      accountId: accountId ?? this.accountId,
      lastModified: lastModified ?? DateTime.now(),
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'values': values,
    'is_active': isActive,
    'account_id': accountId,
    'last_modified': lastModified.toIso8601String(),
    'is_deleted': isDeleted,
  };

  factory ItemVariantModel.fromJson(Map<String, dynamic> json) => ItemVariantModel(
    id: json['id'] as String,
    name: json['name'] as String,
    values: (json['values'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    isActive: json['is_active'] as bool? ?? true,
    accountId: json['account_id'] as String?,
    lastModified: json['last_modified'] != null
        ? DateTime.tryParse(json['last_modified'] as String) ?? DateTime.now()
        : DateTime.now(),
    isDeleted: json['is_deleted'] as bool? ?? false,
  );
}


