class SyncQueueItem {
  String id;
  String operation; // create, update, delete
  String table; // users, branches, permissions, medicines, sales, purchases, inventory, returns
  Map<String, dynamic> data;
  DateTime createdAt;
  int retryCount;
  String? lastError;
  DateTime? syncedAt;
  String branchId;

  SyncQueueItem({
    required this.id,
    required this.operation,
    required this.table,
    required this.data,
    required this.createdAt,
    this.retryCount = 0,
    this.lastError,
    this.syncedAt,
    required this.branchId,
  });

  SyncQueueItem copyWith({
    String? id,
    String? operation,
    String? table,
    Map<String, dynamic>? data,
    DateTime? createdAt,
    int? retryCount,
    String? lastError,
    DateTime? syncedAt,
    String? branchId,
  }) {
    return SyncQueueItem(
      id: id ?? this.id,
      operation: operation ?? this.operation,
      table: table ?? this.table,
      data: data ?? Map<String, dynamic>.from(this.data),
      createdAt: createdAt ?? this.createdAt,
      retryCount: retryCount ?? this.retryCount,
      lastError: lastError ?? this.lastError,
      syncedAt: syncedAt ?? this.syncedAt,
      branchId: branchId ?? this.branchId,
    );
  }
}


