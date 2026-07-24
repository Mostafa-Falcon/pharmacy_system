class InventoryTransactionModel {
  final String id;
  final String medicineId;
  final String transactionType;
  final String referenceId;
  final String? referenceNumber;
  final int quantityChange;
  final int quantityAfter;
  final double unitPrice;
  final String branchId;
  final String? accountId;
  final DateTime createdAt;
  final DateTime lastModified;
  final bool isDeleted;
  final int syncVersion;

  InventoryTransactionModel({
    required this.id,
    required this.medicineId,
    required this.transactionType,
    required this.referenceId,
    this.referenceNumber,
    required this.quantityChange,
    required this.quantityAfter,
    this.unitPrice = 0.0,
    required this.branchId,
    this.accountId,
    DateTime? createdAt,
    DateTime? lastModified,
    this.isDeleted = false,
    this.syncVersion = 1,
  })  : createdAt = createdAt ?? DateTime.now(),
        lastModified = lastModified ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'medicine_id': medicineId,
    'transaction_type': transactionType,
    'reference_id': referenceId,
    'reference_number': referenceNumber,
    'quantity_change': quantityChange,
    'quantity_after': quantityAfter,
    'unit_price': unitPrice,
    'branch_id': branchId,
    'account_id': accountId,
    'created_at': createdAt.toIso8601String(),
    'last_modified': lastModified.toIso8601String(),
    'is_deleted': isDeleted,
    'sync_version': syncVersion,
  };

  factory InventoryTransactionModel.fromJson(Map<String, dynamic> json) => InventoryTransactionModel(
    id: json['id'] as String,
    medicineId: json['medicine_id'] as String,
    transactionType: json['transaction_type'] as String,
    referenceId: json['reference_id'] as String,
    referenceNumber: json['reference_number'] as String?,
    quantityChange: (json['quantity_change'] as num?)?.toInt() ?? 0,
    quantityAfter: (json['quantity_after'] as num?)?.toInt() ?? 0,
    unitPrice: (json['unit_price'] as num?)?.toDouble() ?? 0.0,
    branchId: json['branch_id'] as String? ?? '',
    accountId: json['account_id'] as String?,
    createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
    lastModified: DateTime.tryParse(json['last_modified'] as String? ?? '') ?? DateTime.now(),
    isDeleted: json['is_deleted'] as bool? ?? false,
    syncVersion: (json['sync_version'] as num?)?.toInt() ?? 1,
  );
}