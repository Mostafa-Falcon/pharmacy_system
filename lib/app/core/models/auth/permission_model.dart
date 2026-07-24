import 'package:pharmacy_system/app/core/data/database/syncable_entity.dart';

/// 🔑 موديل صلاحيات المستخدمين والموظفين (Permissions Model)
class PermissionModel implements SyncableEntity {
  // 🆔 المعرف الفريد لسجل الصلاحية (Primary Key)
  final String id;

  // 👤 معرف المستخدم/الموظف المرتبط للصلاحية
  final String userId;

  // 🔑 مفتاح وشفرة الصلاحية (مثل: can_edit_price, can_delete_sale, can_view_reports)
  final String permissionKey;

  // ✅ هل الصلاحية مسموح بها للموظف أم ممنوعة
  final bool isAllowed;

  // 🏢 معرف الحساب الرئيسي / المؤسسة
  final String? accountId;

  // 📅 تاريخ إنشاء الصلاحية
  final DateTime createdAt;

  // 🔄 رقم إصدار المزامنة
  final int syncVersion;

  // 🕒 تاريخ ووقت آخر تعديل
  @override
  final DateTime lastModified;

  // 🗑️ حالة الحذف المنطقي
  @override
  final bool isDeleted;

  @override
  String? get syncBranchId => null; // Permissions are typically global per account

  PermissionModel({
    required this.id,
    required this.userId,
    required this.permissionKey,
    required this.isAllowed,
    this.accountId,
    required this.createdAt,
    this.syncVersion = 1,
    DateTime? lastModified,
    this.isDeleted = false,
  }) : lastModified = lastModified ?? DateTime.now();

  PermissionModel copyWith({
    String? id,
    String? userId,
    String? permissionKey,
    bool? isAllowed,
    String? accountId,
    DateTime? createdAt,
    int? syncVersion,
    DateTime? lastModified,
    bool? isDeleted,
  }) {
    return PermissionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      permissionKey: permissionKey ?? this.permissionKey,
      isAllowed: isAllowed ?? this.isAllowed,
      accountId: accountId ?? this.accountId,
      createdAt: createdAt ?? this.createdAt,
      syncVersion: syncVersion ?? this.syncVersion,
      lastModified: lastModified ?? this.lastModified,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'permission_key': permissionKey,
    'is_allowed': isAllowed,
    'account_id': accountId,
    'created_at': createdAt.toIso8601String(),
    'sync_version': syncVersion,
    'last_modified': lastModified.toIso8601String(),
    'is_deleted': isDeleted,
  };

  factory PermissionModel.fromJson(Map<String, dynamic> json) => PermissionModel(
    id: json['id'] as String,
    userId: json['user_id'] as String,
    permissionKey: json['permission_key'] as String,
    isAllowed: json['is_allowed'] as bool? ?? false,
    accountId: json['account_id'] as String?,
    createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
    syncVersion: (json['sync_version'] as num?)?.toInt() ?? 1,
    lastModified: json['last_modified'] != null
        ? DateTime.tryParse(json['last_modified'] as String) ?? DateTime.now()
        : DateTime.now(),
    isDeleted: json['is_deleted'] as bool? ?? false,
  );
}
