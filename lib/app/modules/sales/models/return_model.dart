class ReturnItemModel {
  String medicineId;
  String medicineName;
  int quantity;
  double unitPrice;
  double totalPrice;
  String? reason;

  /// تكلفة شراء الوحدة — لحساب تكلفة البضاعة المرتجعة (COGS) بدقة.
  double costPrice;

  ReturnItemModel({
    required this.medicineId,
    required this.medicineName,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    this.reason,
    this.costPrice = 0,
  });

  Map<String, dynamic> toJson() => {
    'medicine_id': medicineId,
    'medicine_name': medicineName,
    'quantity': quantity,
    'unit_price': unitPrice,
    'total_price': totalPrice,
    'reason': reason,
    'cost_price': costPrice,
  };

  factory ReturnItemModel.fromJson(Map<String, dynamic> json) => ReturnItemModel(
    medicineId: json['medicine_id'] as String,
    medicineName: json['medicine_name'] as String,
    quantity: json['quantity'] as int,
    unitPrice: (json['unit_price'] as num).toDouble(),
    totalPrice: (json['total_price'] as num).toDouble(),
    reason: json['reason'] as String?,
    costPrice: (json['cost_price'] as num?)?.toDouble() ?? 0,
  );
}

enum ReturnReason { expired, damaged, wrongItem, customerReturn, other }

class ReturnModel {
  String id;
  String branchId;
  String? saleId; // original sale id if return from sale
  String? purchaseId; // original purchase id if return to supplier
  List<ReturnItemModel> items;
  double totalAmount;
  ReturnReason reason;
  String? notes;
  String createdBy; // userId
  DateTime createdAt;
  int syncVersion;
  DateTime lastModified;
  bool isDeleted;

  ReturnModel({
    required this.id,
    required this.branchId,
    this.saleId,
    this.purchaseId,
    required this.items,
    required this.totalAmount,
    required this.reason,
    this.notes,
    required this.createdBy,
    required this.createdAt,
    this.syncVersion = 1,
    DateTime? lastModified,
    this.isDeleted = false,
  }) : lastModified = lastModified ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'branch_id': branchId,
    'sale_id': saleId,
    'purchase_id': purchaseId,
    'items': items.map((e) => e.toJson()).toList(),
    'total_amount': totalAmount,
    'reason': reason.name,
    'notes': notes,
    'created_by': createdBy,
    'created_at': createdAt.toIso8601String(),
    'sync_version': syncVersion,
    'last_modified': lastModified.toIso8601String(),
    'is_deleted': isDeleted,
  };

  factory ReturnModel.fromJson(Map<String, dynamic> json) => ReturnModel(
    id: json['id'] as String,
    branchId: json['branch_id'] as String,
    saleId: json['sale_id'] as String?,
    purchaseId: json['purchase_id'] as String?,
    items: (json['items'] as List<dynamic>?)
            ?.map((e) => ReturnItemModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    totalAmount: (json['total_amount'] as num).toDouble(),
    reason: ReturnReason.values.firstWhere(
      (r) => r.name == json['reason'],
      orElse: () => ReturnReason.other,
    ),
    notes: json['notes'] as String?,
    createdBy: json['created_by'] as String,
    createdAt: DateTime.tryParse(json['created_at'] as String) ?? DateTime.now(),
    syncVersion: json['sync_version'] as int? ?? 1,
    lastModified: json['last_modified'] != null
        ? DateTime.tryParse(json['last_modified'] as String) ?? DateTime.now()
        : DateTime.now(),
    isDeleted: json['is_deleted'] as bool? ?? false,
  );
}
