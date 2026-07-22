class InventoryItemModel {
  String id;
  String medicineId;
  String branchId;
  int currentQuantity;
  int minStock;
  int maxStock;
  DateTime lastRestocked;
  int syncVersion;
  DateTime lastModified;

  InventoryItemModel({
    required this.id,
    required this.medicineId,
    required this.branchId,
    required this.currentQuantity,
    this.minStock = 10,
    this.maxStock = 1000,
    required this.lastRestocked,
    this.syncVersion = 1,
    DateTime? lastModified,
  }) : lastModified = lastModified ?? DateTime.now();

  bool get isLowStock => currentQuantity <= minStock;
  bool get isOutOfStock => currentQuantity <= 0;

  Map<String, dynamic> toJson() => {
    'id': id,
    'medicine_id': medicineId,
    'branch_id': branchId,
    'current_quantity': currentQuantity,
    'min_stock': minStock,
    'max_stock': maxStock,
    'last_restocked': lastRestocked.toIso8601String(),
    'sync_version': syncVersion,
    'last_modified': lastModified.toIso8601String(),
  };

  factory InventoryItemModel.fromJson(Map<String, dynamic> json) => InventoryItemModel(
    id: json['id'] as String,
    medicineId: json['medicine_id'] as String,
    branchId: json['branch_id'] as String,
    currentQuantity: json['current_quantity'] as int? ?? 0,
    minStock: json['min_stock'] as int? ?? 10,
    maxStock: json['max_stock'] as int? ?? 1000,
    lastRestocked: json['last_restocked'] != null
        ? DateTime.tryParse(json['last_restocked'] as String) ?? DateTime.now()
        : DateTime.now(),
    syncVersion: json['sync_version'] as int? ?? 1,
    lastModified: json['last_modified'] != null
        ? DateTime.tryParse(json['last_modified'] as String) ?? DateTime.now()
        : DateTime.now(),
  );
}
