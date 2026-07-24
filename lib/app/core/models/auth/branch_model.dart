import 'package:pharmacy_system/app/core/data/database/syncable_entity.dart';

/// 🏬 موديل بيانات فرع الصيدلية (المؤسسة/الفروع)
class BranchModel implements SyncableEntity {
  // 🆔 المعرف الفريد للفرع (Primary Key)
  final String id;

  // 🏬 اسم الفرع (مثال: الفرع الرئيسي / فرع المعادي / فرع 2)
  final String name;

  // 🔢 كود الفرع (اختياري)
  final String? code;

  // 🏠 هل هذا هو الفرع الرئيسي للمؤسسة
  final bool isMainBranch;

  // 🏢 معرف الحساب الرئيسي / المؤسسة التابع لها الفرع (Tenant ID)
  final String? accountId;

  // 📍 عنوان الفرع التفصيلي
  final String? address;

  // 📞 رقم تليفون/هاتف الفرع
  final String? phone;

  // 🟢 حالة تفعيل الفرع بالنظام
  final bool isActive;

  // 📅 تاريخ إنشاء وتسجيل الفرع
  final DateTime createdAt;

  // 🔄 رقم إصدار المزامنة
  final int syncVersion;

  // 🕒 تاريخ ووقت آخر تعديل
  @override
  final DateTime lastModified;

  // 🗑️ حالة الحذف المنطقي للفرع
  @override
  final bool isDeleted;

  @override
  String? get syncBranchId => id;

  BranchModel({
    required this.id,
    required this.name,
    this.code,
    this.isMainBranch = false,
    this.accountId,
    this.address,
    this.phone,
    this.isActive = true,
    required this.createdAt,
    this.syncVersion = 1,
    DateTime? lastModified,
    this.isDeleted = false,
  }) : lastModified = lastModified ?? DateTime.now();

  BranchModel copyWith({
    String? id,
    String? name,
    String? code,
    bool? isMainBranch,
    String? accountId,
    String? address,
    String? phone,
    bool? isActive,
    DateTime? createdAt,
    int? syncVersion,
    DateTime? lastModified,
    bool? isDeleted,
  }) {
    return BranchModel(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      isMainBranch: isMainBranch ?? this.isMainBranch,
      accountId: accountId ?? this.accountId,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      syncVersion: syncVersion ?? this.syncVersion,
      lastModified: lastModified ?? this.lastModified,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'code': code,
    'is_main_branch': isMainBranch,
    'account_id': accountId,
    'address': address,
    'phone': phone,
    'is_active': isActive,
    'created_at': createdAt.toIso8601String(),
    'sync_version': syncVersion,
    'last_modified': lastModified.toIso8601String(),
    'is_deleted': isDeleted,
  };

  factory BranchModel.fromJson(Map<String, dynamic> json) => BranchModel(
    id: json['id'] as String,
    name: json['name'] as String,
    code: json['code'] as String?,
    isMainBranch: json['is_main_branch'] as bool? ?? false,
    accountId: json['account_id'] as String?,
    address: json['address'] as String?,
    phone: json['phone'] as String?,
    isActive: json['is_active'] as bool? ?? true,
    createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
    syncVersion: (json['sync_version'] as num?)?.toInt() ?? 1,
    lastModified: json['last_modified'] != null
        ? DateTime.tryParse(json['last_modified'] as String) ?? DateTime.now()
        : DateTime.now(),
    isDeleted: json['is_deleted'] as bool? ?? false,
  );
}
