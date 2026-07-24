enum LookupType { itemType, group }

class LookupModel {
  String id;
  String name;
  String type; // 'itemType' or 'group'
  bool isActive;
  String branchId;
  int syncVersion;
  DateTime lastModified;
  bool isDeleted;

  LookupModel({
    required this.id,
    required this.name,
    required this.type,
    this.isActive = true,
    required this.branchId,
    this.syncVersion = 1,
    DateTime? lastModified,
    this.isDeleted = false,
  }) : lastModified = lastModified ?? DateTime.now();

  LookupType get lookupType =>
      LookupType.values.firstWhere((e) => e.name == type, orElse: () => LookupType.itemType);

  static LookupModel create({
    required String name,
    required LookupType lookupType,
    required String branchId,
  }) {
    return LookupModel(
      id: 'lookup_${DateTime.now().microsecondsSinceEpoch}',
      name: name,
      type: lookupType.name,
      branchId: branchId,
    );
  }

  LookupModel copyWith({
    String? id,
    String? name,
    String? type,
    bool? isActive,
    String? branchId,
    int? syncVersion,
    DateTime? lastModified,
    bool? isDeleted,
  }) {
    return LookupModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      isActive: isActive ?? this.isActive,
      branchId: branchId ?? this.branchId,
      syncVersion: syncVersion ?? this.syncVersion + 1,
      lastModified: lastModified ?? DateTime.now(),
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type,
    'is_active': isActive,
    'branch_id': branchId,
    'sync_version': syncVersion,
    'last_modified': lastModified.toIso8601String(),
    'is_deleted': isDeleted,
  };

  factory LookupModel.fromJson(Map<String, dynamic> json) => LookupModel(
    id: json['id'] as String,
    name: json['name'] as String,
    type: json['type'] as String,
    isActive: json['is_active'] as bool? ?? true,
    branchId: json['branch_id'] as String,
    syncVersion: json['sync_version'] as int? ?? 1,
    lastModified: json['last_modified'] != null
        ? DateTime.tryParse(json['last_modified'] as String) ?? DateTime.now()
        : DateTime.now(),
    isDeleted: json['is_deleted'] as bool? ?? false,
  );
}


