import 'package:pharmacy_system/app/core/data/database/syncable_entity.dart';

/// 💰 الحالة المالية لجهة التعامل
enum FinancialState {
  debit,   // مدين (عليه فلوس للصيدلية)
  credit,  // دائن (له فلوس عند الصيدلية)
  settled, // متزن / متخالص (الحساب 0)
}

/// 👤 موديل العملاء والزبائن المخصص (Customers Model)
class CustomerModel implements SyncableEntity {
  final String id;
  final String name;
  final String? phone;
  final String? secondPhone;
  final String? address;
  final String? email;
  
  // 👥 ربط المجموعة (مثل: عملاء VIP / نقابة الأطباء)
  final String? groupId;
  final String? groupName;

  final double creditLimit;
  final double discountPercent;

  // 💰 الحسابات المباشرة (مدين / دائن)
  final double debitAmount;  // مدين: عليه فلوس للصيدلية
  final double creditAmount; // دائن: له فلوس/مقدم عند الصيدلية

  // ⚖️ صافي المديونية (مدين - دائن)
  double get netBalance => debitAmount - creditAmount;

  // 📊 الحالة المالية الصريحة للواجهة
  FinancialState get financialState => netBalance > 0
      ? FinancialState.debit
      : netBalance < 0
          ? FinancialState.credit
          : FinancialState.settled;

  final bool isActive;
  final String? notes;
  final String? branchId;
  final String? accountId;
  
  // ⚙️ حقول الإدارة والمزامنة
  final int syncVersion;
  @override
  final DateTime lastModified;
  @override
  final bool isDeleted;

  @override
  String? get syncBranchId => branchId;

  CustomerModel({
    required this.id,
    required this.name,
    this.phone,
    this.secondPhone,
    this.address,
    this.email,
    this.groupId,
    this.groupName,
    this.creditLimit = 0.0,
    this.discountPercent = 0.0,
    this.debitAmount = 0.0,
    this.creditAmount = 0.0,
    this.isActive = true,
    this.notes,
    this.branchId,
    this.accountId,
    this.syncVersion = 1,
    DateTime? lastModified,
    this.isDeleted = false,
  }) : lastModified = lastModified ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phone': phone,
    'second_phone': secondPhone,
    'address': address,
    'email': email,
    'group_id': groupId,
    'group_name': groupName,
    'credit_limit': creditLimit,
    'discount_percent': discountPercent,
    'debit_amount': debitAmount,
    'credit_amount': creditAmount,
    'is_active': isActive,
    'notes': notes,
    'branch_id': branchId,
    'account_id': accountId,
    'sync_version': syncVersion,
    'last_modified': lastModified.toIso8601String(),
    'is_deleted': isDeleted,
  };

  factory CustomerModel.fromJson(Map<String, dynamic> json) => CustomerModel(
    id: json['id'] as String,
    name: json['name'] as String,
    phone: json['phone'] as String?,
    secondPhone: json['second_phone'] as String?,
    address: json['address'] as String?,
    email: json['email'] as String?,
    groupId: json['group_id'] as String?,
    groupName: json['group_name'] as String?,
    creditLimit: (json['credit_limit'] as num?)?.toDouble() ?? 0.0,
    discountPercent: (json['discount_percent'] as num?)?.toDouble() ?? 0.0,
    debitAmount: (json['debit_amount'] as num?)?.toDouble() ?? 0.0,
    creditAmount: (json['credit_amount'] as num?)?.toDouble() ?? 0.0,
    isActive: json['is_active'] as bool? ?? true,
    notes: json['notes'] as String?,
    branchId: json['branch_id'] as String?,
    accountId: json['account_id'] as String?,
    syncVersion: (json['sync_version'] as num?)?.toInt() ?? 1,
    lastModified: json['last_modified'] != null
        ? DateTime.tryParse(json['last_modified'] as String) ?? DateTime.now()
        : DateTime.now(),
    isDeleted: json['is_deleted'] as bool? ?? false,
  );

  CustomerModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? secondPhone,
    String? address,
    String? email,
    String? groupId,
    String? groupName,
    double? creditLimit,
    double? discountPercent,
    double? debitAmount,
    double? creditAmount,
    bool? isActive,
    String? notes,
    String? branchId,
    String? accountId,
    int? syncVersion,
    DateTime? lastModified,
    bool? isDeleted,
  }) {
    return CustomerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      secondPhone: secondPhone ?? this.secondPhone,
      address: address ?? this.address,
      email: email ?? this.email,
      groupId: groupId ?? this.groupId,
      groupName: groupName ?? this.groupName,
      creditLimit: creditLimit ?? this.creditLimit,
      discountPercent: discountPercent ?? this.discountPercent,
      debitAmount: debitAmount ?? this.debitAmount,
      creditAmount: creditAmount ?? this.creditAmount,
      isActive: isActive ?? this.isActive,
      notes: notes ?? this.notes,
      branchId: branchId ?? this.branchId,
      accountId: accountId ?? this.accountId,
      syncVersion: syncVersion ?? this.syncVersion,
      lastModified: lastModified ?? this.lastModified,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
