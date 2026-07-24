import 'package:pharmacy_system/app/core/data/database/syncable_entity.dart';

/// 👔 موديل مندوبي المبيعات والتوزيع والعمولات (Sales Agent Model)
class SalesAgentModel implements SyncableEntity {
  // 🆔 المعرف الفريد لمندوب المبيعات (Primary Key)
  final String id;

  // 👤 اسم مندوب المبيعات (مثل: كابتن أحمد علي)
  final String name;

  // 📞 رقم الهاتف/التواصل مع المندوب
  final String? phone;

  // 📧 البريد الإلكتروني للمندوب
  final String? email;

  // ٪ نسبة العمولة المخصصة لمندوب المبيعات (مثل: 2.5%)
  final double commissionPercentage;

  // 💵 إجمالي العمولات المستحقة للمندوب
  final double totalCommissionEarned;

  // 🟢 حالة تفعيل المندوب فـ المنظومة
  final bool isActive;

  // 🏬 معرف الفرع التابع له المندوب
  final String? branchId;

  // 🏢 معرف الحساب الرئيسي / المؤسسة
  final String? accountId;

  // 📝 ملاحظات إضافية
  final String? notes;

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

  SalesAgentModel({
    required this.id,
    required this.name,
    this.phone,
    this.email,
    this.commissionPercentage = 0.0,
    this.totalCommissionEarned = 0.0,
    this.isActive = true,
    this.branchId,
    this.accountId,
    this.notes,
    DateTime? lastModified,
    this.isDeleted = false,
    this.syncVersion = 1,
  }) : lastModified = lastModified ?? DateTime.now();

  SalesAgentModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    double? commissionPercentage,
    double? totalCommissionEarned,
    bool? isActive,
    String? branchId,
    String? accountId,
    String? notes,
    DateTime? lastModified,
    bool? isDeleted,
    int? syncVersion,
  }) {
    return SalesAgentModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      commissionPercentage: commissionPercentage ?? this.commissionPercentage,
      totalCommissionEarned: totalCommissionEarned ?? this.totalCommissionEarned,
      isActive: isActive ?? this.isActive,
      branchId: branchId ?? this.branchId,
      accountId: accountId ?? this.accountId,
      notes: notes ?? this.notes,
      lastModified: lastModified ?? DateTime.now(),
      isDeleted: isDeleted ?? this.isDeleted,
      syncVersion: syncVersion ?? this.syncVersion,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phone': phone,
    'email': email,
    'commission_percentage': commissionPercentage,
    'total_commission_earned': totalCommissionEarned,
    'is_active': isActive,
    'branch_id': branchId,
    'account_id': accountId,
    'notes': notes,
    'last_modified': lastModified.toIso8601String(),
    'is_deleted': isDeleted,
    'sync_version': syncVersion,
  };

  factory SalesAgentModel.fromJson(Map<String, dynamic> json) => SalesAgentModel(
    id: json['id'] as String,
    name: json['name'] as String,
    phone: json['phone'] as String?,
    email: json['email'] as String?,
    commissionPercentage: (json['commission_percentage'] as num?)?.toDouble() ?? 0.0,
    totalCommissionEarned: (json['total_commission_earned'] as num?)?.toDouble() ?? 0.0,
    isActive: json['is_active'] as bool? ?? true,
    branchId: json['branch_id'] as String?,
    accountId: json['account_id'] as String?,
    notes: json['notes'] as String?,
    lastModified: json['last_modified'] != null
        ? DateTime.tryParse(json['last_modified'] as String) ?? DateTime.now()
        : DateTime.now(),
    isDeleted: json['is_deleted'] as bool? ?? false,
    syncVersion: (json['sync_version'] as num?)?.toInt() ?? 1,
  );
}


