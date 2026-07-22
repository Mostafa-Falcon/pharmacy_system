class SupplierCustomerModel {
  String id;
  String name;
  String? phone;
  String? address;
  String? email;
  String? companyName;
  String? taxId;
  bool isActive;
  String? notes;
  int customerKindIndex;
  double creditLimit;
  double discountPercent;
  int paymentTermDays;
  int supplierPartyTypeIndex;
  DateTime lastModified;
  bool isDeleted;
  String? branchId;

  SupplierCustomerModel({
    required this.id,
    required this.name,
    this.phone,
    this.address,
    this.email,
    this.companyName,
    this.taxId,
    this.isActive = true,
    this.notes,
    this.customerKindIndex = 0,
    this.creditLimit = 0,
    this.discountPercent = 0,
    this.paymentTermDays = 0,
    this.supplierPartyTypeIndex = 0,
    DateTime? lastModified,
    this.isDeleted = false,
    this.branchId,
  }) : lastModified = lastModified ?? DateTime.now();

  String get customerKindName => customerKindIndex == 0 ? 'آجل' : 'نقدي';
  String get supplierPartyTypeName => supplierPartyTypeIndex == 0 ? 'شركة' : 'فرد';
  String get subtitle => '$customerKindName | $supplierPartyTypeName${phone != null ? ' | $phone' : ''}';

  SupplierCustomerModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? address,
    String? email,
    String? companyName,
    String? taxId,
    bool? isActive,
    String? notes,
    int? customerKindIndex,
    double? creditLimit,
    double? discountPercent,
    int? paymentTermDays,
    int? supplierPartyTypeIndex,
    bool? isDeleted,
    String? branchId,
  }) {
    return SupplierCustomerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      email: email ?? this.email,
      companyName: companyName ?? this.companyName,
      taxId: taxId ?? this.taxId,
      isActive: isActive ?? this.isActive,
      notes: notes ?? this.notes,
      customerKindIndex: customerKindIndex ?? this.customerKindIndex,
      creditLimit: creditLimit ?? this.creditLimit,
      discountPercent: discountPercent ?? this.discountPercent,
      paymentTermDays: paymentTermDays ?? this.paymentTermDays,
      supplierPartyTypeIndex: supplierPartyTypeIndex ?? this.supplierPartyTypeIndex,
      lastModified: DateTime.now(),
      isDeleted: isDeleted ?? this.isDeleted,
      branchId: branchId ?? this.branchId,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phone': phone,
    'address': address,
    'email': email,
    'company_name': companyName,
    'tax_id': taxId,
    'is_active': isActive,
    'notes': notes,
    'customer_kind_index': customerKindIndex,
    'credit_limit': creditLimit,
    'discount_percent': discountPercent,
    'payment_term_days': paymentTermDays,
    'supplier_party_type_index': supplierPartyTypeIndex,
    'is_deleted': isDeleted,
    'last_modified': lastModified.toIso8601String(),
    'branch_id': branchId,
  };

  factory SupplierCustomerModel.fromJson(Map<String, dynamic> json) => SupplierCustomerModel(
    id: json['id'] as String,
    name: json['name'] as String,
    phone: json['phone'] as String?,
    address: json['address'] as String?,
    email: json['email'] as String?,
    companyName: json['company_name'] as String?,
    taxId: json['tax_id'] as String?,
    isActive: json['is_active'] as bool? ?? true,
    notes: json['notes'] as String?,
    customerKindIndex: json['customer_kind_index'] as int? ?? 0,
    creditLimit: (json['credit_limit'] as num?)?.toDouble() ?? 0,
    discountPercent: (json['discount_percent'] as num?)?.toDouble() ?? 0,
    paymentTermDays: json['payment_term_days'] as int? ?? 0,
    supplierPartyTypeIndex: json['supplier_party_type_index'] as int? ?? 0,
    lastModified: json['last_modified'] != null
        ? DateTime.tryParse(json['last_modified'] as String) ?? DateTime.now()
        : DateTime.now(),
    isDeleted: json['is_deleted'] as bool? ?? false,
    branchId: json['branch_id'] as String?,
  );
}
