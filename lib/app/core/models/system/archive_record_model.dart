/// 📦 أنواع الكيانات القابلة للأرشفة في السيستم بالكامل
enum ArchiveEntityType {
  medicine,          // دواء / صنف
  sale,              // فاتورة مبيعات
  purchase,          // فاتورة مشتريات
  customer,          // عميل
  supplier,          // مورد
  supplierCustomer,  // مورد وعميل
  customerGroup,     // مجموعة عملاء
  quotation,         // عرض سعر
  expense,           // مصروفات
}

/// 📦 امتداد توضيح اسم الكيان الممسوح بالواجهات العربية
extension ArchiveEntityTypeX on ArchiveEntityType {
  String get displayName {
    switch (this) {
      case ArchiveEntityType.medicine:
        return 'الأدوية والأصناف';
      case ArchiveEntityType.sale:
        return 'فواتير المبيعات';
      case ArchiveEntityType.purchase:
        return 'فواتير المشتريات';
      case ArchiveEntityType.customer:
        return 'العملاء والزبائن';
      case ArchiveEntityType.supplier:
        return 'الموردين والشركات';
      case ArchiveEntityType.supplierCustomer:
        return 'موردين وعملاء';
      case ArchiveEntityType.customerGroup:
        return 'مجموعات العملاء';
      case ArchiveEntityType.quotation:
        return 'عروض الأسعار';
      case ArchiveEntityType.expense:
        return 'المصروفات';
    }
  }
}

/// 📦 الموديل الموحد الشامل لسجلات الأرشيف وسلة المهملات
class ArchiveRecordModel {
  // 🆔 المعرف الفريد لسجل الأرشيف (Primary Key)
  final String id;

  // 📦 نوع الكيان المحذوف (دواء، فاتورة، عميل...)
  final ArchiveEntityType entityType;

  // 🆔 المعرف الفريد الأصلي للكيان المحذوف
  final String entityId;

  // 🏷️ اسم الكيان المحذوف للعرض في الواجهة (مثال: بنادول إكسترا / فاتورة #102)
  final String entityName;

  // 💾 الحمولة والبيانات الكاملة للكيان لحظة الحذف (JSON Payload)
  final Map<String, dynamic> entityData;

  // 👤 معرف الشخص الذي أجرى عملية المسح
  final String deletedBy;

  // 👤 اسم الشخص الذي أجرى عملية المسح (مثال: د. أحمد)
  final String deletedByName;

  // 📅 تاريخ ووقت عملية المسح والأرشفة
  final DateTime deletedAt;

  // 🏬 معرف الفرع
  final String branchId;

  // 🏢 معرف الحساب الرئيسي / المؤسسة (Tenant ID)
  final String? accountId;

  // 🕒 تاريخ ووقت الاسترجاع (في حالة إعادة العنصر من الأرشيف)
  final DateTime? restoredAt;

  // 👤 اسم الشخص الذي أجرى الاسترجاع
  final String? restoredBy;

  // 🕒 تاريخ ووقت الحذف النهائي (في حالة مسحه كلياً)
  final DateTime? permanentlyDeletedAt;

  // 🔄 رقم إصدار المزامنة
  final int syncVersion;

  // 🕒 تاريخ ووقت آخر تعديل
  final DateTime lastModified;

  ArchiveRecordModel({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.entityName,
    required this.entityData,
    required this.deletedBy,
    required this.deletedByName,
    DateTime? deletedAt,
    required this.branchId,
    this.accountId,
    this.restoredAt,
    this.restoredBy,
    this.permanentlyDeletedAt,
    this.syncVersion = 1,
    DateTime? lastModified,
  })  : deletedAt = deletedAt ?? DateTime.now(),
        lastModified = lastModified ?? DateTime.now();

  ArchiveRecordModel copyWith({
    String? id,
    ArchiveEntityType? entityType,
    String? entityId,
    String? entityName,
    Map<String, dynamic>? entityData,
    String? deletedBy,
    String? deletedByName,
    DateTime? deletedAt,
    String? branchId,
    bool clearAccountId = false,
    String? accountId,
    bool clearRestoredAt = false,
    DateTime? restoredAt,
    bool clearRestoredBy = false,
    String? restoredBy,
    bool clearPermanentlyDeletedAt = false,
    DateTime? permanentlyDeletedAt,
    int? syncVersion,
    DateTime? lastModified,
  }) =>
      ArchiveRecordModel(
        id: id ?? this.id,
        entityType: entityType ?? this.entityType,
        entityId: entityId ?? this.entityId,
        entityName: entityName ?? this.entityName,
        entityData: entityData ?? this.entityData,
        deletedBy: deletedBy ?? this.deletedBy,
        deletedByName: deletedByName ?? this.deletedByName,
        deletedAt: deletedAt ?? this.deletedAt,
        branchId: branchId ?? this.branchId,
        accountId:
            clearAccountId ? null : (accountId ?? this.accountId),
        restoredAt:
            clearRestoredAt ? null : (restoredAt ?? this.restoredAt),
        restoredBy:
            clearRestoredBy ? null : (restoredBy ?? this.restoredBy),
        permanentlyDeletedAt: clearPermanentlyDeletedAt
            ? null
            : (permanentlyDeletedAt ?? this.permanentlyDeletedAt),
        syncVersion: syncVersion ?? this.syncVersion,
        lastModified: lastModified ?? this.lastModified,
      );

  bool get isActiveInArchive => restoredAt == null && permanentlyDeletedAt == null;

  Map<String, dynamic> toJson() => {
    'id': id,
    'entity_type': entityType.name,
    'entity_id': entityId,
    'entity_name': entityName,
    'entity_data': entityData,
    'deleted_by': deletedBy,
    'deleted_by_name': deletedByName,
    'deleted_at': deletedAt.toIso8601String(),
    'branch_id': branchId,
    'account_id': accountId,
    'restored_at': restoredAt?.toIso8601String(),
    'restored_by': restoredBy,
    'permanently_deleted_at': permanentlyDeletedAt?.toIso8601String(),
    'sync_version': syncVersion,
    'last_modified': lastModified.toIso8601String(),
  };

  factory ArchiveRecordModel.fromJson(Map<String, dynamic> json) => ArchiveRecordModel(
    id: json['id'] as String,
    entityType: ArchiveEntityType.values.firstWhere(
      (e) => e.name == json['entity_type'],
      orElse: () => ArchiveEntityType.medicine,
    ),
    entityId: json['entity_id'] as String,
    entityName: json['entity_name'] as String,
    entityData: (json['entity_data'] as Map<String, dynamic>?) ?? {},
    deletedBy: json['deleted_by'] as String? ?? '',
    deletedByName: json['deleted_by_name'] as String? ?? '',
    deletedAt: DateTime.tryParse(json['deleted_at'] as String? ?? '') ?? DateTime.now(),
    branchId: json['branch_id'] as String? ?? '',
    accountId: json['account_id'] as String?,
    restoredAt: json['restored_at'] != null ? DateTime.tryParse(json['restored_at'] as String) : null,
    restoredBy: json['restored_by'] as String?,
    permanentlyDeletedAt: json['permanently_deleted_at'] != null ? DateTime.tryParse(json['permanently_deleted_at'] as String) : null,
    syncVersion: (json['sync_version'] as num?)?.toInt() ?? 1,
    lastModified: DateTime.tryParse(json['last_modified'] as String? ?? '') ?? DateTime.now(),
  );
}


