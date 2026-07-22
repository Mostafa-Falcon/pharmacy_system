enum CustomerKind { regular, cash }

class CustomerModel {
  String id;
  String name;
  String? phone;
  String? address;
  bool isActive;
  CustomerKind kind;
  String? companyName;
  String? email;
  String? taxId;
  double creditLimit;
  double discountPercent;
  int paymentTermDays;
  String? notes;
  DateTime lastModified;
  bool isDeleted;
  String? salesRepId;
  String? branchId;

  CustomerModel({
    required this.id,
    required this.name,
    this.phone,
    this.address,
    this.isActive = true,
    this.kind = CustomerKind.regular,
    this.companyName,
    this.email,
    this.taxId,
    this.creditLimit = 0,
    this.discountPercent = 0,
    this.paymentTermDays = 0,
    this.notes,
    DateTime? lastModified,
    this.isDeleted = false,
    this.salesRepId,
    this.branchId,
  }) : lastModified = lastModified ?? DateTime.now();

  String get kindName => switch (kind) {
    CustomerKind.regular => 'آجل',
    CustomerKind.cash => 'نقدي',
  };

  String get displayName => name;
  String get identityPhone => phone ?? '';
  String get identityEmail => email ?? '';
  String get identityAddress => address ?? '';
  String get identityCompanyName => companyName ?? '';

  CustomerModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? address,
    bool? isActive,
    CustomerKind? kind,
    String? companyName,
    String? email,
    String? taxId,
    double? creditLimit,
    double? discountPercent,
    int? paymentTermDays,
    String? notes,
    DateTime? lastModified,
    bool? isDeleted,
    String? salesRepId,
    String? branchId,
  }) {
    return CustomerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      isActive: isActive ?? this.isActive,
      kind: kind ?? this.kind,
      companyName: companyName ?? this.companyName,
      email: email ?? this.email,
      taxId: taxId ?? this.taxId,
      creditLimit: creditLimit ?? this.creditLimit,
      discountPercent: discountPercent ?? this.discountPercent,
      paymentTermDays: paymentTermDays ?? this.paymentTermDays,
      notes: notes ?? this.notes,
      lastModified: lastModified ?? DateTime.now(),
      isDeleted: isDeleted ?? this.isDeleted,
      salesRepId: salesRepId ?? this.salesRepId,
      branchId: branchId ?? this.branchId,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phone': phone,
    'address': address,
    'is_active': isActive,
    'kind': kind.name,
    'company_name': companyName,
    'email': email,
    'tax_id': taxId,
    'credit_limit': creditLimit,
    'discount_percent': discountPercent,
    'payment_term_days': paymentTermDays,
    'notes': notes,
    'is_deleted': isDeleted,
    'last_modified': lastModified.toIso8601String(),
    'sales_rep_id': salesRepId,
    'branch_id': branchId,
  };

  factory CustomerModel.fromJson(Map<String, dynamic> json) => CustomerModel(
    id: json['id'] as String,
    name: json['name'] as String,
    phone: json['phone'] as String?,
    address: json['address'] as String?,
    isActive: json['is_active'] as bool? ?? true,
    kind: CustomerKind.values.firstWhere(
      (e) => e.name == json['kind'],
      orElse: () => CustomerKind.regular,
    ),
    companyName: json['company_name'] as String?,
    email: json['email'] as String?,
    taxId: json['tax_id'] as String?,
    creditLimit: (json['credit_limit'] as num?)?.toDouble() ?? 0,
    discountPercent: (json['discount_percent'] as num?)?.toDouble() ?? 0,
    paymentTermDays: json['payment_term_days'] as int? ?? 0,
    notes: json['notes'] as String?,
    lastModified: json['last_modified'] != null
        ? DateTime.tryParse(json['last_modified'] as String) ?? DateTime.now()
        : DateTime.now(),
    isDeleted: json['is_deleted'] as bool? ?? false,
    salesRepId: json['sales_rep_id'] as String?,
    branchId: json['branch_id'] as String?,
  );
}
