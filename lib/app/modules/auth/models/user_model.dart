enum UserRole { owner, employee }

class UserModel {
  String id;
  String name;
  String email;
  String passwordHash;
  UserRole role;
  String? assignedBranchId;
  bool isActive;
  DateTime createdAt;
  DateTime? lastLogin;
  int syncVersion;
  DateTime lastModified;
  bool isDeleted;
  String? activeDeviceId;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.passwordHash,
    required this.role,
    this.assignedBranchId,
    this.isActive = true,
    required this.createdAt,
    this.lastLogin,
    this.syncVersion = 1,
    DateTime? lastModified,
    this.isDeleted = false,
    this.activeDeviceId,
  }) : lastModified = lastModified ?? DateTime.now();

  bool get isOwner => role == UserRole.owner;
  bool get isEmployee => role == UserRole.employee;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'role': role.name,
    'assigned_branch_id': assignedBranchId,
    'is_active': isActive,
    'created_at': createdAt.toIso8601String(),
    'last_login': lastLogin?.toIso8601String(),
    'sync_version': syncVersion,
    'last_modified': lastModified.toIso8601String(),
    'is_deleted': isDeleted,
    'active_device_id': activeDeviceId,
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] as String,
    name: json['name'] as String,
    email: json['email'] as String,
    passwordHash: json['password_hash'] as String? ?? json['passwordHash'] as String,
    role: UserRole.values.firstWhere(
      (r) => r.name == json['role'],
      orElse: () => UserRole.employee,
    ),
    assignedBranchId: json['assigned_branch_id'] as String? ?? json['assignedBranchId'] as String?,
    isActive: json['is_active'] as bool? ?? json['isActive'] as bool? ?? true,
    createdAt: DateTime.tryParse(json['created_at'] as String? ?? json['createdAt'] as String) ?? DateTime.now(),
    lastLogin: json['last_login'] != null
        ? DateTime.tryParse(json['last_login'] as String)
        : json['lastLogin'] != null
            ? DateTime.tryParse(json['lastLogin'] as String)
            : null,
    syncVersion: json['sync_version'] as int? ?? 1,
    lastModified: json['last_modified'] != null
        ? DateTime.tryParse(json['last_modified'] as String) ?? DateTime.now()
        : DateTime.now(),
    isDeleted: json['is_deleted'] as bool? ?? false,
    activeDeviceId: json['active_device_id'] as String?,
  );

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? passwordHash,
    UserRole? role,
    String? assignedBranchId,
    bool? isActive,
    DateTime? createdAt,
    DateTime? lastLogin,
    int? syncVersion,
    DateTime? lastModified,
    bool? isDeleted,
    String? activeDeviceId,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
      role: role ?? this.role,
      assignedBranchId: assignedBranchId ?? this.assignedBranchId,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      syncVersion: syncVersion ?? this.syncVersion,
      lastModified: lastModified ?? this.lastModified,
      isDeleted: isDeleted ?? this.isDeleted,
      activeDeviceId: activeDeviceId ?? this.activeDeviceId,
    );
  }
}
