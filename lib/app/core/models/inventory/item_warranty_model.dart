/// 🛡️ وحدة المدة الزمنية للضمان (يوم / شهر / سنة)
enum WarrantyDurationUnit {
  day,   // يوم
  month, // شهر
  year,  // سنة
}

/// 🛡️ موديل ضمانات الأصناف والمستلزمات الطبية (Item Warranty Model)
class ItemWarrantyModel {
  // 🆔 المعرف الفريد لبيان الضمان (Primary Key)
  final String id;

  // 🏷️ اسم الضمان (مثل: ضمان سنة / ضمان 6 أشهر / ضمان يوم)
  final String name;

  // 📝 وصف تفصيلي للضمان وشروطه
  final String? description;

  // 🔢 قيمة المدة الزمنية (مثل: 1, 6, 12)
  final int duration;

  // ⏳ وحدة المدة الزمنية (يوم / شهر / سنة)
  final WarrantyDurationUnit durationUnit;

  // 🟢 حالة تفعيل الضمان
  final bool isActive;

  // 🏢 معرف الحساب الرئيسي / المؤسسة
  final String? accountId;

  // 🕒 تاريخ ووقت آخر تعديل
  final DateTime lastModified;

  // 🗑️ حالة الحذف المنطقي
  final bool isDeleted;

  ItemWarrantyModel({
    required this.id,
    required this.name,
    this.description,
    required this.duration,
    this.durationUnit = WarrantyDurationUnit.year,
    this.isActive = true,
    this.accountId,
    DateTime? lastModified,
    this.isDeleted = false,
  }) : lastModified = lastModified ?? DateTime.now();

  ItemWarrantyModel copyWith({
    String? id,
    String? name,
    String? description,
    int? duration,
    WarrantyDurationUnit? durationUnit,
    bool? isActive,
    String? accountId,
    DateTime? lastModified,
    bool? isDeleted,
  }) {
    return ItemWarrantyModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      duration: duration ?? this.duration,
      durationUnit: durationUnit ?? this.durationUnit,
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
    'duration': duration,
    'duration_unit': durationUnit.name,
    'is_active': isActive,
    'account_id': accountId,
    'last_modified': lastModified.toIso8601String(),
    'is_deleted': isDeleted,
  };

  factory ItemWarrantyModel.fromJson(Map<String, dynamic> json) => ItemWarrantyModel(
    id: json['id'] as String,
    name: json['name'] as String,
    description: json['description'] as String?,
    duration: (json['duration'] as num?)?.toInt() ?? 1,
    durationUnit: json['duration_unit'] == 'month'
        ? WarrantyDurationUnit.month
        : json['duration_unit'] == 'day'
            ? WarrantyDurationUnit.day
            : WarrantyDurationUnit.year,
    isActive: json['is_active'] as bool? ?? true,
    accountId: json['account_id'] as String?,
    lastModified: json['last_modified'] != null
        ? DateTime.tryParse(json['last_modified'] as String) ?? DateTime.now()
        : DateTime.now(),
    isDeleted: json['is_deleted'] as bool? ?? false,
  );
}


