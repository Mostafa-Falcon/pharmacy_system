import 'package:pharmacy_system/app/core/sync/syncable_entity.dart';

/// 👥 موديل فئات ومجموعات العملاء (مثل: عملاء النقابة / مرضي التأمين / خصم VIP)
class CustomerGroupModel implements GlobalSyncableEntity {
  // 🆔 المعرف الفريد لمجموعة العملاء
  final String id;

  // 🏷️ اسم المجموعة/الفئة (مثل: خصم نقابة الأطباء 10% / مرضى السكر)
  final String name;

  // ٪ نسبة الخصم الثابتة المخصصة لهذه المجموعة %
  final double discountPercent;

  // 🏷️ معرف شريحة التسعير المرتبطة (إن وجدت)
  final String? priceGroupId;

  // 📝 وصف الفئة والشروط المطبقة عليها
  final String? description;

  // 🟢 حالة تفعيل الفئة بالنظام
  final bool isActive;

  // 🏢 معرف الحساب الرئيسي / المؤسسة
  final String? accountId;

  // 🕒 تاريخ ووقت آخر تعديل
  @override
  final DateTime lastModified;

  // 🗑️ حالة الحذف المنطقي (Soft Delete)
  @override
  final bool isDeleted;

  // ⚙️ نسخة المزامنة
  final int syncVersion;

  @override
  String? get syncBranchId => null;

  CustomerGroupModel({
    required this.id,
    required this.name,
    this.discountPercent = 0.0,
    this.priceGroupId,
    this.description,
    this.isActive = true,
    this.accountId,
    DateTime? lastModified,
    this.isDeleted = false,
    this.syncVersion = 1,
  }) : lastModified = lastModified ?? DateTime.now();

  CustomerGroupModel copyWith({
    String? id,
    String? name,
    double? discountPercent,
    String? priceGroupId,
    String? description,
    bool? isActive,
    String? accountId,
    DateTime? lastModified,
    bool? isDeleted,
    int? syncVersion,
  }) {
    return CustomerGroupModel(
      id: id ?? this.id,
      name: name ?? this.name,
      discountPercent: discountPercent ?? this.discountPercent,
      priceGroupId: priceGroupId ?? this.priceGroupId,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      accountId: accountId ?? this.accountId,
      lastModified: lastModified ?? DateTime.now(),
      isDeleted: isDeleted ?? this.isDeleted,
      syncVersion: syncVersion ?? this.syncVersion,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'discount_percent': discountPercent,
    'price_group_id': priceGroupId,
    'description': description,
    'is_active': isActive,
    'account_id': accountId,
    'last_modified': lastModified.toIso8601String(),
    'is_deleted': isDeleted,
    'sync_version': syncVersion,
  };

  factory CustomerGroupModel.fromJson(Map<String, dynamic> json) => CustomerGroupModel(
    id: json['id'] as String,
    name: json['name'] as String,
    discountPercent: (json['discount_percent'] as num?)?.toDouble() ?? 0.0,
    priceGroupId: json['price_group_id'] as String?,
    description: json['description'] as String?,
    isActive: json['is_active'] as bool? ?? true,
    accountId: json['account_id'] as String?,
    lastModified: json['last_modified'] != null
        ? DateTime.tryParse(json['last_modified'] as String) ?? DateTime.now()
        : DateTime.now(),
    isDeleted: json['is_deleted'] as bool? ?? false,
    syncVersion: (json['sync_version'] as num?)?.toInt() ?? 1,
  );
}


