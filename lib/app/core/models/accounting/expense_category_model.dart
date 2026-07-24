/// 📁 موديل فئات وتصنيفات المصاريف (Expense Category Model)
class ExpenseCategoryModel {
  // 🆔 المعرف الفريد لفئة المصروف (Primary Key)
  final String id;

  // 🏷️ اسم فئة المصروف (مثل: إيجار المقر / كهرباء ومياه / رواتب موظفين / أكياس ومستلزمات / مصاريف نثرية)
  final String name;

  // 🔢 كود أو رمز الفئة المرجعي (مثال: EXP-RENT, EXP-ELEC)
  final String? code;

  // 📝 وصف الفئة والشروط
  final String? description;

  // 🟢 حالة تفعيل الفئة بالنظام
  final bool isActive;

  // 🏢 معرف الحساب الرئيسي / المؤسسة
  final String? accountId;

  // 🕒 تاريخ ووقت آخر تعديل
  final DateTime lastModified;

  // 🗑️ حالة الحذف المنطقي
  final bool isDeleted;

  ExpenseCategoryModel({
    required this.id,
    required this.name,
    this.code,
    this.description,
    this.isActive = true,
    this.accountId,
    DateTime? lastModified,
    this.isDeleted = false,
  }) : lastModified = lastModified ?? DateTime.now();

  ExpenseCategoryModel copyWith({
    String? id,
    String? name,
    String? code,
    String? description,
    bool? isActive,
    String? accountId,
    DateTime? lastModified,
    bool? isDeleted,
  }) {
    return ExpenseCategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      description: description ?? this.description,
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
    'is_active': isActive,
    'account_id': accountId,
    'last_modified': lastModified.toIso8601String(),
    'is_deleted': isDeleted,
  };

  factory ExpenseCategoryModel.fromJson(Map<String, dynamic> json) => ExpenseCategoryModel(
    id: json['id'] as String,
    name: json['name'] as String,
    code: json['code'] as String?,
    description: json['description'] as String?,
    isActive: json['is_active'] as bool? ?? true,
    accountId: json['account_id'] as String?,
    lastModified: json['last_modified'] != null
        ? DateTime.tryParse(json['last_modified'] as String) ?? DateTime.now()
        : DateTime.now(),
    isDeleted: json['is_deleted'] as bool? ?? false,
  );
}


