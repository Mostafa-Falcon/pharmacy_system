/// 👑 رتبة ووظيفة المستخدم/الموظف
enum UserRole {
  owner,    // مالك الصيدلية / مدير النظام (صاحب الكلمة الأولى)
  employee, // موظف / صيدلي / كاشير
}

/// 👤 موديل بيانات المستخدم والموظف الموحد بالكامل
class UserModel {
  // 🆔 المعرف الفريد للمستخدم (Primary Key)
  final String id;

  // 👤 اسم المستخدم/الموظف باللغة العربية (مثال: د. أحمد)
  final String name;

  // 📧 البريد الإلكتروني الخاص بتسجيل الدخول
  final String email;

  // 🔒 كلمة المرور المشفرة
  final String passwordHash;

  // 👑 الرتبة (مالك owner أم موظف employee)
  final UserRole role;

  // 🏬 معرف الفرع المعين له الموظف (اختياري للمالك)
  final String? assignedBranchId;

  // 🏢 معرف الحساب الرئيسي / المؤسسة (Tenant ID)
  final String? accountId;

  // 🟢 حالة تفعيل الحساب في النظام
  final bool isActive;

  // 📅 تاريخ إنشاء الحساب
  final DateTime createdAt;

  // 🕒 تاريخ ووقت آخر تسجيل دخول
  final DateTime? lastLogin;

  // 📱 معرف الجهاز المفعل للجلسة (لمنع الدخول المتعدد غير المصرح به)
  final String? activeDeviceId;

  // 🔄 رقم إصدار المزامنة
  final int syncVersion;

  // 🕒 تاريخ ووقت آخر تعديل
  final DateTime lastModified;

  // 🗑️ حالة الحذف المنطقي للمستخدم
  final bool isDeleted;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.passwordHash,
    required this.role,
    this.assignedBranchId,
    this.accountId,
    this.isActive = true,
    required this.createdAt,
    this.lastLogin,
    this.activeDeviceId,
    this.syncVersion = 1,
    DateTime? lastModified,
    this.isDeleted = false,
  }) : lastModified = lastModified ?? DateTime.now();

  // ⭐️ هل هذا المستخدم هو مالك النظام (Owner)
  bool get isOwner => role == UserRole.owner;

  // ⭐️ هل هذا المستخدم موظف عادي (Employee)
  bool get isEmployee => role == UserRole.employee;

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? passwordHash,
    UserRole? role,
    String? assignedBranchId,
    String? accountId,
    bool? isActive,
    DateTime? createdAt,
    DateTime? lastLogin,
    String? activeDeviceId,
    int? syncVersion,
    DateTime? lastModified,
    bool? isDeleted,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
      role: role ?? this.role,
      assignedBranchId: assignedBranchId ?? this.assignedBranchId,
      accountId: accountId ?? this.accountId,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      activeDeviceId: activeDeviceId ?? this.activeDeviceId,
      syncVersion: syncVersion ?? this.syncVersion,
      lastModified: lastModified ?? this.lastModified,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'password_hash': passwordHash,
    'role': role.name,
    'assigned_branch_id': assignedBranchId,
    'account_id': accountId,
    'is_active': isActive,
    'created_at': createdAt.toIso8601String(),
    'last_login': lastLogin?.toIso8601String(),
    'active_device_id': activeDeviceId,
    'sync_version': syncVersion,
    'last_modified': lastModified.toIso8601String(),
    'is_deleted': isDeleted,
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] as String,
    name: json['name'] as String,
    email: json['email'] as String,
    passwordHash: (json['password_hash'] as String?) ?? (json['passwordHash'] as String? ?? ''),
    role: UserRole.values.firstWhere(
      (r) => r.name == json['role'],
      orElse: () => UserRole.employee,
    ),
    assignedBranchId: (json['assigned_branch_id'] as String?) ?? (json['assignedBranchId'] as String?),
    accountId: json['account_id'] as String?,
    isActive: json['is_active'] as bool? ?? json['isActive'] as bool? ?? true,
    createdAt: DateTime.tryParse(json['created_at'] as String? ?? json['createdAt'] as String? ?? '') ?? DateTime.now(),
    lastLogin: json['last_login'] != null
        ? DateTime.tryParse(json['last_login'] as String)
        : json['lastLogin'] != null
            ? DateTime.tryParse(json['lastLogin'] as String)
            : null,
    activeDeviceId: json['active_device_id'] as String?,
    syncVersion: (json['sync_version'] as num?)?.toInt() ?? 1,
    lastModified: json['last_modified'] != null
        ? DateTime.tryParse(json['last_modified'] as String) ?? DateTime.now()
        : DateTime.now(),
    isDeleted: json['is_deleted'] as bool? ?? false,
  );
}


