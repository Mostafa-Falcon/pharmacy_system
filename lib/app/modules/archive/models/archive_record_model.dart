import 'dart:convert';

enum ArchiveEntityType {
  medicine,
  sale,
  purchase,
  customer,
  supplier,
  return_,
  customerGroup,
  supplierCustomer,
}

extension ArchiveEntityTypeX on ArchiveEntityType {
  String get value {
    switch (this) {
      case ArchiveEntityType.medicine:
        return 'medicine';
      case ArchiveEntityType.sale:
        return 'sale';
      case ArchiveEntityType.purchase:
        return 'purchase';
      case ArchiveEntityType.customer:
        return 'customer';
      case ArchiveEntityType.supplier:
        return 'supplier';
      case ArchiveEntityType.return_:
        return 'return';
      case ArchiveEntityType.customerGroup:
        return 'customer_group';
      case ArchiveEntityType.supplierCustomer:
        return 'supplier_customer';
    }
  }

  String get displayName {
    switch (this) {
      case ArchiveEntityType.medicine:
        return 'الأدوية';
      case ArchiveEntityType.sale:
        return 'المبيعات';
      case ArchiveEntityType.purchase:
        return 'المشتريات';
      case ArchiveEntityType.customer:
        return 'العملاء';
      case ArchiveEntityType.supplier:
        return 'الموردين';
      case ArchiveEntityType.return_:
        return 'المرتجعات';
      case ArchiveEntityType.customerGroup:
        return 'مجموعات العملاء';
      case ArchiveEntityType.supplierCustomer:
        return 'موردين/عملاء';
    }
  }
}

Map<String, dynamic> parseEntityData(dynamic raw) {
  if (raw is Map) return Map<String, dynamic>.from(raw);
  if (raw is String) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
    } catch (_) {}
  }
  return {};
}

ArchiveEntityType? archiveEntityTypeFromString(String? v) {
  if (v == null) return null;
  return ArchiveEntityType.values.firstWhere(
    (e) => e.value == v,
    orElse: () => ArchiveEntityType.medicine,
  );
}

class ArchiveRecordModel {
  String id;
  ArchiveEntityType entityType;
  String entityId;
  String entityName;
  Map<String, dynamic> entityData;
  String deletedBy;
  String deletedByName;
  DateTime deletedAt;
  String branchId;
  String? restoredAt;
  String? restoredBy;
  String? permanentlyDeletedAt;
  int syncVersion;
  DateTime lastModified;

  ArchiveRecordModel({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.entityName,
    required this.entityData,
    required this.deletedBy,
    required this.deletedByName,
    required this.deletedAt,
    required this.branchId,
    this.restoredAt,
    this.restoredBy,
    this.permanentlyDeletedAt,
    this.syncVersion = 1,
    DateTime? lastModified,
  }) : lastModified = lastModified ?? DateTime.now();

  bool get isRestored => restoredAt != null;
  bool get isPermanentlyDeleted => permanentlyDeletedAt != null;
  bool get isActive => !isRestored && !isPermanentlyDeleted;

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
    String? restoredAt,
    String? restoredBy,
    String? permanentlyDeletedAt,
    int? syncVersion,
    DateTime? lastModified,
  }) {
    return ArchiveRecordModel(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      entityName: entityName ?? this.entityName,
      entityData: entityData ?? this.entityData,
      deletedBy: deletedBy ?? this.deletedBy,
      deletedByName: deletedByName ?? this.deletedByName,
      deletedAt: deletedAt ?? this.deletedAt,
      branchId: branchId ?? this.branchId,
      restoredAt: restoredAt ?? this.restoredAt,
      restoredBy: restoredBy ?? this.restoredBy,
      permanentlyDeletedAt: permanentlyDeletedAt ?? this.permanentlyDeletedAt,
      syncVersion: syncVersion ?? this.syncVersion,
      lastModified: lastModified ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'entity_type': entityType.value,
    'entity_id': entityId,
    'entity_name': entityName,
    'entity_data': entityData,
    'deleted_by': deletedBy,
    'deleted_by_name': deletedByName,
    'deleted_at': deletedAt.toIso8601String(),
    'branch_id': branchId,
    'restored_at': restoredAt,
    'restored_by': restoredBy,
    'permanently_deleted_at': permanentlyDeletedAt,
    'sync_version': syncVersion,
    'last_modified': lastModified.toIso8601String(),
  };

  factory ArchiveRecordModel.fromJson(Map<String, dynamic> json) =>
      ArchiveRecordModel(
        id: json['id'] as String,
        entityType: archiveEntityTypeFromString(json['entity_type'] as String?) ?? ArchiveEntityType.medicine,
        entityId: json['entity_id'] as String,
        entityName: json['entity_name'] as String? ?? '',
        entityData: parseEntityData(json['entity_data']),
        deletedBy: json['deleted_by'] as String? ?? '',
        deletedByName: json['deleted_by_name'] as String? ?? '',
        deletedAt: DateTime.tryParse(json['deleted_at'] as String? ?? '') ?? DateTime.now(),
        branchId: json['branch_id'] as String? ?? '',
        restoredAt: json['restored_at'] as String?,
        restoredBy: json['restored_by'] as String?,
        permanentlyDeletedAt: json['permanently_deleted_at'] as String?,
        syncVersion: json['sync_version'] as int? ?? 1,
        lastModified: json['last_modified'] != null
            ? DateTime.tryParse(json['last_modified'] as String) ?? DateTime.now()
            : DateTime.now(),
      );
}
