class CustomerGroupModel {
  String id;
  String name;
  double discountPercent;
  String? priceGroupId;
  String? description;
  bool isActive;
  DateTime lastModified;
  bool isDeleted;

  CustomerGroupModel({
    required this.id,
    required this.name,
    this.discountPercent = 0,
    this.priceGroupId,
    this.description,
    this.isActive = true,
    DateTime? lastModified,
    this.isDeleted = false,
  }) : lastModified = lastModified ?? DateTime.now();

  CustomerGroupModel copyWith({
    String? id,
    String? name,
    double? discountPercent,
    String? priceGroupId,
    String? description,
    bool? isActive,
    bool? isDeleted,
  }) {
    return CustomerGroupModel(
      id: id ?? this.id,
      name: name ?? this.name,
      discountPercent: discountPercent ?? this.discountPercent,
      priceGroupId: priceGroupId ?? this.priceGroupId,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      lastModified: DateTime.now(),
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'discount_percent': discountPercent,
    'price_group_id': priceGroupId,
    'description': description,
    'is_active': isActive,
    'is_deleted': isDeleted,
    'last_modified': lastModified.toIso8601String(),
  };

  factory CustomerGroupModel.fromJson(Map<String, dynamic> json) => CustomerGroupModel(
    id: json['id'] as String,
    name: json['name'] as String,
    discountPercent: (json['discount_percent'] as num?)?.toDouble() ?? 0,
    priceGroupId: json['price_group_id'] as String?,
    description: json['description'] as String?,
    isActive: json['is_active'] as bool? ?? true,
    isDeleted: json['is_deleted'] as bool? ?? false,
    lastModified: json['last_modified'] != null
        ? DateTime.tryParse(json['last_modified'] as String) ?? DateTime.now()
        : DateTime.now(),
  );
}
