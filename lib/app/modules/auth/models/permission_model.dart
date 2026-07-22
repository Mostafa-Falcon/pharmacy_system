class PermissionModel {
  String id;
  String userId;
  String permissionKey;
  bool isAllowed;
  DateTime createdAt;
  int syncVersion;
  bool isDeleted;
  DateTime lastModified;

  PermissionModel({
    required this.id,
    required this.userId,
    required this.permissionKey,
    required this.isAllowed,
    required this.createdAt,
    this.syncVersion = 1,
    this.isDeleted = false,
    DateTime? lastModified,
  }) : lastModified = lastModified ?? DateTime.now();

  PermissionModel copyWith({
    String? id,
    String? userId,
    String? permissionKey,
    bool? isAllowed,
    DateTime? createdAt,
    int? syncVersion,
    bool? isDeleted,
    DateTime? lastModified,
  }) {
    return PermissionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      permissionKey: permissionKey ?? this.permissionKey,
      isAllowed: isAllowed ?? this.isAllowed,
      createdAt: createdAt ?? this.createdAt,
      syncVersion: syncVersion ?? this.syncVersion + 1,
      isDeleted: isDeleted ?? this.isDeleted,
      lastModified: lastModified ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'permission_key': permissionKey,
    'is_allowed': isAllowed,
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
    createdAt: DateTime.tryParse(json['created_at'] as String) ?? DateTime.now(),
    syncVersion: json['sync_version'] as int? ?? 1,
    isDeleted: json['is_deleted'] as bool? ?? false,
    lastModified: json['last_modified'] != null
        ? DateTime.tryParse(json['last_modified'] as String) ?? DateTime.now()
        : DateTime.now(),
  );
}
