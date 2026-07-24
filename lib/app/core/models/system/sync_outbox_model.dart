class SyncOutboxModel {
  final String id;
  final String operationType;
  final String targetTable;
  final String payloadJson;
  final int retryCount;
  final String status;
  final String? errorMessage;
  final String branchId;
  final String? accountId;
  final DateTime createdAt;

  SyncOutboxModel({
    required this.id,
    required this.operationType,
    required this.targetTable,
    required this.payloadJson,
    this.retryCount = 0,
    this.status = 'pending',
    this.errorMessage,
    required this.branchId,
    this.accountId,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'operation_type': operationType,
    'target_table': targetTable,
    'payload_json': payloadJson,
    'retry_count': retryCount,
    'status': status,
    'error_message': errorMessage,
    'branch_id': branchId,
    'account_id': accountId,
    'created_at': createdAt.toIso8601String(),
  };

  factory SyncOutboxModel.fromJson(Map<String, dynamic> json) => SyncOutboxModel(
    id: json['id'] as String,
    operationType: json['operation_type'] as String,
    targetTable: json['target_table'] as String? ?? json['table_name'] as String? ?? '',
    payloadJson: json['payload_json'] as String? ?? '{}',
    retryCount: (json['retry_count'] as num?)?.toInt() ?? 0,
    status: json['status'] as String? ?? 'pending',
    errorMessage: json['error_message'] as String?,
    branchId: json['branch_id'] as String? ?? '',
    accountId: json['account_id'] as String?,
    createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
  );
}