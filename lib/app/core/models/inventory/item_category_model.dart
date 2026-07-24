/// 📂 موديل مجموعات وفئات الأصناف (Item Categories Model)
class ItemCategoryModel {
  // 🆔 المعرف الفريد للمجموعة (Primary Key)
  final String id;

  // 🏷️ اسم المجموعة (مثل: جهاز تنفسي / سكر / عناية الأطفال)
  final String name;

  // 🔢 رمز المجموعة المرجعي المباشر (مثل: RESP, DIAB, BABY)
  final String? code;

  // 📝 وصف المجموعة
  final String? description;

  // 🔗 معرف المجموعة الرئيسية التابعة لها (في حالة المجموعات الفرعية)
  final String? parentId;

  // 🟢 حالة تفعيل المجموعة
  final bool isActive;

  // 🏢 معرف الحساب الرئيسي / المؤسسة
  final String? accountId;

  // 🕒 تاريخ ووقت آخر تعديل
  final DateTime lastModified;

  // 🗑️ حالة الحذف المنطقي
  final bool isDeleted;

  ItemCategoryModel({
    required this.id,
    required this.name,
    this.code,
    this.description,
    this.parentId,
    this.isActive = true,
    this.accountId,
    DateTime? lastModified,
    this.isDeleted = false,
  }) : lastModified = lastModified ?? DateTime.now();

  ItemCategoryModel copyWith({
    String? id,
    String? name,
    String? code,
    String? description,
    String? parentId,
    bool? isActive,
    String? accountId,
    DateTime? lastModified,
    bool? isDeleted,
  }) {
    return ItemCategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      description: description ?? this.description,
      parentId: parentId ?? this.parentId,
      isActive: isActive ?? this.isActive,
      accountId: accountId ?? this.accountId,
      lastModified: lastModified ?? DateTime.now(),
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'code': code,
    'description': description,
    'parent_id': parentId,
    'is_active': isActive,
    'account_id': accountId,
    'last_modified': lastModified.toIso8601String(),
    'is_deleted': isDeleted,
  };

  factory ItemCategoryModel.fromJson(Map<String, dynamic> json) => ItemCategoryModel(
    id: json['id'] as String,
    name: json['name'] as String,
    code: json['code'] as String?,
    description: json['description'] as String?,
    parentId: json['parent_id'] as String?,
    isActive: json['is_active'] as bool? ?? true,
    accountId: json['account_id'] as String?,
    lastModified: json['last_modified'] != null
        ? DateTime.tryParse(json['last_modified'] as String) ?? DateTime.now()
        : DateTime.now(),
    isDeleted: json['is_deleted'] as bool? ?? false,
  );
}


