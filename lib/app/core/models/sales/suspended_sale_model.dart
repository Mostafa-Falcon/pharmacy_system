class SuspendedSaleModel {
  final String id;
  final String referenceNumber;
  final String customerName;
  final String? customerId;
  final String itemsJson;
  final double totalAmount;
  final String cashierId;
  final String branchId;
  final String? accountId;
  final DateTime createdAt;
  final DateTime lastModified;
  final bool isDeleted;
  final int syncVersion;

  SuspendedSaleModel({
    required this.id,
    required this.referenceNumber,
    this.customerName = 'زبون نقدي',
    this.customerId,
    required this.itemsJson,
    this.totalAmount = 0.0,
    required this.cashierId,
    required this.branchId,
    this.accountId,
    DateTime? createdAt,
    DateTime? lastModified,
    this.isDeleted = false,
    this.syncVersion = 1,
  })  : createdAt = createdAt ?? DateTime.now(),
        lastModified = lastModified ?? DateTime.now();

  SuspendedSaleModel copyWith({
    String? id,
    String? referenceNumber,
    String? customerName,
    bool clearCustomerId = false,
    String? customerId,
    String? itemsJson,
    double? totalAmount,
    String? cashierId,
    String? branchId,
    bool clearAccountId = false,
    String? accountId,
    DateTime? createdAt,
    DateTime? lastModified,
    bool? isDeleted,
    int? syncVersion,
  }) =>
      SuspendedSaleModel(
        id: id ?? this.id,
        referenceNumber: referenceNumber ?? this.referenceNumber,
        customerName: customerName ?? this.customerName,
        customerId:
            clearCustomerId ? null : (customerId ?? this.customerId),
        itemsJson: itemsJson ?? this.itemsJson,
        totalAmount: totalAmount ?? this.totalAmount,
        cashierId: cashierId ?? this.cashierId,
        branchId: branchId ?? this.branchId,
        accountId: clearAccountId ? null : (accountId ?? this.accountId),
        createdAt: createdAt ?? this.createdAt,
        lastModified: lastModified ?? this.lastModified,
        isDeleted: isDeleted ?? this.isDeleted,
        syncVersion: syncVersion ?? this.syncVersion,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'reference_number': referenceNumber,
    'customer_name': customerName,
    'customer_id': customerId,
    'items_json': itemsJson,
    'total_amount': totalAmount,
    'cashier_id': cashierId,
    'branch_id': branchId,
    'account_id': accountId,
    'created_at': createdAt.toIso8601String(),
    'last_modified': lastModified.toIso8601String(),
    'is_deleted': isDeleted,
    'sync_version': syncVersion,
  };

  factory SuspendedSaleModel.fromJson(Map<String, dynamic> json) => SuspendedSaleModel(
    id: json['id'] as String,
    referenceNumber: json['reference_number'] as String? ?? '',
    customerName: json['customer_name'] as String? ?? 'زبون نقدي',
    customerId: json['customer_id'] as String?,
    itemsJson: json['items_json'] as String? ?? '[]',
    totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
    cashierId: json['cashier_id'] as String? ?? '',
    branchId: json['branch_id'] as String? ?? '',
    accountId: json['account_id'] as String?,
    createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
    lastModified: DateTime.tryParse(json['last_modified'] as String? ?? '') ?? DateTime.now(),
    isDeleted: json['is_deleted'] as bool? ?? false,
    syncVersion: (json['sync_version'] as num?)?.toInt() ?? 1,
  );
}