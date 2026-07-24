import 'package:pharmacy_system/app/core/sync/syncable_entity.dart';

/// 💰 الحالة المالية لجهة التعامل
enum FinancialState {
  debit,   // مدين (عليه فلوس للصيدلية)
  credit,  // دائن (له فلوس عند الصيدلية)
  settled, // متزن / متخالص (الحساب 0)
}

/// 🚚 موديل الموردين المخصص (Suppliers Model)
class SupplierModel implements SyncableEntity {
  final String id;
  final String name;
  final String? phone;
  final String? address;
  final String? email;
  final String? contactPerson;
  final String? taxId;

  // 💰 الحسابات المباشرة (له فلوس / عليه فلوس)
  final double creditAmount; // دائن: مستحقات له عند الصيدلية (فواتير مشتريات)
  final double debitAmount;  // مدين: مبالغ سددت له أو مرتجعات عليه للصيدلية

  // ⚖️ صافي مستحقات المورد (دائن - مدين)
  double get netBalance => creditAmount - debitAmount;

  // 📊 الحالة المالية الصريحة للمورد
  FinancialState get financialState => netBalance > 0
      ? FinancialState.credit
      : netBalance < 0
          ? FinancialState.debit
          : FinancialState.settled;

  final int paymentTermDays;
  final bool isActive;
  final String? notes;
  final String? branchId;
  final String? accountId;
  @override
  final DateTime lastModified;
  @override
  final bool isDeleted;
  final int syncVersion;

  @override
  String? get syncBranchId => branchId;

  // ─── Backward Compatibility Getters ───
  String? get taxNumber => taxId;
  String? get agentPhone => null;

  SupplierModel({
    required this.id,
    required this.name,
    this.phone,
    this.address,
    this.email,
    this.contactPerson,
    this.taxId,
    this.creditAmount = 0.0,
    this.debitAmount = 0.0,
    this.paymentTermDays = 0,
    this.isActive = true,
    this.notes,
    this.branchId,
    this.accountId,
    DateTime? lastModified,
    this.isDeleted = false,
    this.syncVersion = 1,
  }) : lastModified = lastModified ?? DateTime.now();

  SupplierModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? address,
    String? email,
    String? contactPerson,
    String? taxId,
    double? creditAmount,
    double? debitAmount,
    int? paymentTermDays,
    bool? isActive,
    String? notes,
    String? branchId,
    String? accountId,
    DateTime? lastModified,
    bool? isDeleted,
    int? syncVersion,
  }) {
    return SupplierModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      email: email ?? this.email,
      contactPerson: contactPerson ?? this.contactPerson,
      taxId: taxId ?? this.taxId,
      creditAmount: creditAmount ?? this.creditAmount,
      debitAmount: debitAmount ?? this.debitAmount,
      paymentTermDays: paymentTermDays ?? this.paymentTermDays,
      isActive: isActive ?? this.isActive,
      notes: notes ?? this.notes,
      branchId: branchId ?? this.branchId,
      accountId: accountId ?? this.accountId,
      lastModified: lastModified ?? this.lastModified,
      isDeleted: isDeleted ?? this.isDeleted,
      syncVersion: syncVersion ?? this.syncVersion,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phone': phone,
    'address': address,
    'email': email,
    'contact_person': contactPerson,
    'tax_id': taxId,
    'credit_amount': creditAmount,
    'debit_amount': debitAmount,
    'payment_term_days': paymentTermDays,
    'is_active': isActive,
    'notes': notes,
    'branch_id': branchId,
    'account_id': accountId,
    'last_modified': lastModified.toIso8601String(),
    'is_deleted': isDeleted,
    'sync_version': syncVersion,
  };

  factory SupplierModel.fromJson(Map<String, dynamic> json) => SupplierModel(
    id: json['id'] as String,
    name: json['name'] as String,
    phone: json['phone'] as String?,
    address: json['address'] as String?,
    email: json['email'] as String?,
    contactPerson: json['contact_person'] as String?,
    taxId: json['tax_id'] as String?,
    creditAmount: (json['credit_amount'] as num?)?.toDouble() ?? 0.0,
    debitAmount: (json['debit_amount'] as num?)?.toDouble() ?? 0.0,
    paymentTermDays: (json['payment_term_days'] as num?)?.toInt() ?? 0,
    isActive: json['is_active'] as bool? ?? true,
    notes: json['notes'] as String?,
    branchId: json['branch_id'] as String?,
    accountId: json['account_id'] as String?,
    lastModified: json['last_modified'] != null
        ? DateTime.tryParse(json['last_modified'] as String) ?? DateTime.now()
        : DateTime.now(),
    isDeleted: json['is_deleted'] as bool? ?? false,
    syncVersion: (json['sync_version'] as num?)?.toInt() ?? 1,
  );
}


