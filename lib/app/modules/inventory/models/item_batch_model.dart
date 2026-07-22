class ItemBatchModel {
  String id;
  String medicineId;
  String? batchNumber;
  DateTime? expiryDate;
  int quantity;
  int damagedQuantity;
  double? purchasePrice;
  bool isActive;
  bool isDeleted;
  DateTime createdAt;

  ItemBatchModel({
    required this.id,
    required this.medicineId,
    this.batchNumber,
    this.expiryDate,
    this.quantity = 0,
    this.damagedQuantity = 0,
    this.purchasePrice,
    this.isActive = true,
    this.isDeleted = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  int get remainingQuantity {
    final remaining = quantity - damagedQuantity;
    return remaining > 0 ? remaining : 0;
  }

  int get availableQuantity => isActive && !isExpired ? remainingQuantity : 0;

  bool get isExpired {
    if (expiryDate == null) return false;
    final today = DateTime.now();
    final currentDate = DateTime(today.year, today.month, today.day);
    return expiryDate!.isBefore(currentDate);
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'medicine_id': medicineId,
    'batch_number': batchNumber,
    'expiry_date': expiryDate?.toIso8601String(),
    'quantity': quantity,
    'damaged_quantity': damagedQuantity,
    'purchase_price': purchasePrice,
    'is_active': isActive,
    'is_deleted': isDeleted,
    'created_at': createdAt.toIso8601String(),
  };

  factory ItemBatchModel.fromJson(Map<String, dynamic> json) => ItemBatchModel(
    id: json['id'] as String,
    medicineId: json['medicine_id'] as String,
    batchNumber: json['batch_number'] as String?,
    expiryDate: json['expiry_date'] != null
        ? DateTime.tryParse(json['expiry_date'] as String)
        : null,
    quantity: json['quantity'] as int? ?? 0,
    damagedQuantity: json['damaged_quantity'] as int? ?? 0,
    purchasePrice: (json['purchase_price'] as num?)?.toDouble(),
    isActive: json['is_active'] as bool? ?? true,
    isDeleted: json['is_deleted'] as bool? ?? false,
    createdAt: json['created_at'] != null
        ? DateTime.tryParse(json['created_at'] as String) ?? DateTime.now()
        : DateTime.now(),
  );

  ItemBatchModel copyWith({
    String? id,
    String? medicineId,
    String? batchNumber,
    DateTime? expiryDate,
    int? quantity,
    int? damagedQuantity,
    double? purchasePrice,
    bool? isActive,
    bool? isDeleted,
    DateTime? createdAt,
  }) {
    return ItemBatchModel(
      id: id ?? this.id,
      medicineId: medicineId ?? this.medicineId,
      batchNumber: batchNumber ?? this.batchNumber,
      expiryDate: expiryDate ?? this.expiryDate,
      quantity: quantity ?? this.quantity,
      damagedQuantity: damagedQuantity ?? this.damagedQuantity,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      isActive: isActive ?? this.isActive,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
