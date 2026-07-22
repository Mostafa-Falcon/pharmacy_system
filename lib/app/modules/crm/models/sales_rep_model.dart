class SalesRepModel {
  String id;
  String name;
  String? phone;
  String? email;
  String? address;
  String? notes;
  String branchId;
  bool isActive;
  DateTime lastModified;
  bool isDeleted;

  SalesRepModel({
    required this.id,
    required this.name,
    this.phone,
    this.email,
    this.address,
    this.notes,
    required this.branchId,
    this.isActive = true,
    DateTime? lastModified,
    this.isDeleted = false,
  }) : lastModified = lastModified ?? DateTime.now();

  SalesRepModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? address,
    String? notes,
    String? branchId,
    bool? isActive,
    DateTime? lastModified,
    bool? isDeleted,
  }) {
    return SalesRepModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      notes: notes ?? this.notes,
      branchId: branchId ?? this.branchId,
      isActive: isActive ?? this.isActive,
      lastModified: lastModified ?? DateTime.now(),
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phone': phone,
    'email': email,
    'address': address,
    'notes': notes,
    'branch_id': branchId,
    'is_active': isActive,
    'is_deleted': isDeleted,
    'last_modified': lastModified.toIso8601String(),
  };

  factory SalesRepModel.fromJson(Map<String, dynamic> json) => SalesRepModel(
    id: json['id'] as String,
    name: json['name'] as String,
    phone: json['phone'] as String?,
    email: json['email'] as String?,
    address: json['address'] as String?,
    notes: json['notes'] as String?,
    branchId: json['branch_id'] as String? ?? '',
    isActive: json['is_active'] as bool? ?? true,
    lastModified: json['last_modified'] != null
        ? DateTime.tryParse(json['last_modified'] as String) ?? DateTime.now()
        : DateTime.now(),
    isDeleted: json['is_deleted'] as bool? ?? false,
  );
}
