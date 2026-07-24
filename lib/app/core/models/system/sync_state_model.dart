class SyncStateModel {
  final String id;
  final String targetTable;
  final DateTime lastSyncedAt;
  final int lastSyncedVersion;
  final String branchId;

  SyncStateModel({
    required this.id,
    required this.targetTable,
    required this.lastSyncedAt,
    this.lastSyncedVersion = 0,
    required this.branchId,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'target_table': targetTable,
    'last_synced_at': lastSyncedAt.toIso8601String(),
    'last_synced_version': lastSyncedVersion,
    'branch_id': branchId,
  };

  factory SyncStateModel.fromJson(Map<String, dynamic> json) => SyncStateModel(
    id: json['id'] as String,
    targetTable: json['target_table'] as String? ?? json['table_name'] as String? ?? '',
    lastSyncedAt: DateTime.tryParse(json['last_synced_at'] as String? ?? '') ?? DateTime.now(),
    lastSyncedVersion: (json['last_synced_version'] as num?)?.toInt() ?? 0,
    branchId: json['branch_id'] as String? ?? '',
  );
}