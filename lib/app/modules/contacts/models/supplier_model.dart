enum SupplierPartyType { company, individual }

extension SupplierPartyTypeExtension on SupplierPartyType {
  String get label => switch (this) {
    SupplierPartyType.company => 'شركة',
    SupplierPartyType.individual => 'فرد',
  };
}

class SupplierModel {
  String id;
  String name;
  String? phone;
  String? address;
  bool isActive;
  bool isDeleted;
  DateTime lastModified;
  SupplierPartyType partyType;
  String? companyName;
  String? email;
  String? taxId;
  double creditLimit;
  double discountPercent;
  int paymentTermDays;
  String? notes;
  String? branchId;

  SupplierModel({
    required this.id,
    required this.name,
    this.phone,
    this.address,
    this.isActive = true,
    this.isDeleted = false,
    DateTime? lastModified,
    this.partyType = SupplierPartyType.company,
    this.companyName,
    this.email,
    this.taxId,
    this.creditLimit = 0,
    this.discountPercent = 0,
    this.paymentTermDays = 0,
    this.notes,
    this.branchId,
  }) : lastModified = lastModified ?? DateTime.now();

  String get partyTypeName => switch (partyType) {
    SupplierPartyType.company => 'شركة',
    SupplierPartyType.individual => 'فرد',
  };

  bool get isArchived => isDeleted;
  String get displayName => name;
  String get identityPhone => phone ?? '';
  String get identityEmail => email ?? '';
  String get identityAddress => address ?? '';
  String get identityCompanyName => companyName ?? '';

  SupplierModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? address,
    bool? isActive,
    bool? isDeleted,
    SupplierPartyType? partyType,
    String? companyName,
    String? email,
    String? taxId,
    double? creditLimit,
    double? discountPercent,
    int? paymentTermDays,
    String? notes,
    String? branchId,
  }) {
    return SupplierModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      isActive: isActive ?? this.isActive,
      isDeleted: isDeleted ?? this.isDeleted,
      partyType: partyType ?? this.partyType,
      companyName: companyName ?? this.companyName,
      email: email ?? this.email,
      taxId: taxId ?? this.taxId,
      creditLimit: creditLimit ?? this.creditLimit,
      discountPercent: discountPercent ?? this.discountPercent,
      paymentTermDays: paymentTermDays ?? this.paymentTermDays,
      notes: notes ?? this.notes,
      branchId: branchId ?? this.branchId,
      lastModified: lastModified,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'party_type': partyType.name,
    'phone': phone,
    'address': address,
    'is_active': isActive,
    'is_deleted': isDeleted,
    'last_modified': lastModified.toIso8601String(),
    'company_name': companyName,
    'email': email,
    'tax_id': taxId,
    'credit_limit': creditLimit,
    'discount_percent': discountPercent,
    'payment_term_days': paymentTermDays,
    'notes': notes,
    'branch_id': branchId,
  };

  factory SupplierModel.fromJson(Map<String, dynamic> json) => SupplierModel(
    id: json['id'] as String,
    name: json['name'] as String,
    partyType: SupplierPartyType.values.firstWhere(
      (e) => e.name == json['party_type'],
      orElse: () => SupplierPartyType.company,
    ),
    phone: json['phone'] as String?,
    address: json['address'] as String?,
    isActive: json['is_active'] as bool? ?? true,
    isDeleted: json['is_deleted'] as bool? ?? false,
    lastModified: json['last_modified'] != null
        ? DateTime.tryParse(json['last_modified'] as String) ?? DateTime.now()
        : DateTime.now(),
    companyName: json['company_name'] as String?,
    email: json['email'] as String?,
    taxId: json['tax_id'] as String?,
    creditLimit: (json['credit_limit'] as num?)?.toDouble() ?? 0,
    discountPercent: (json['discount_percent'] as num?)?.toDouble() ?? 0,
    paymentTermDays: json['payment_term_days'] as int? ?? 0,
    notes: json['notes'] as String?,
    branchId: json['branch_id'] as String?,
  );
}
