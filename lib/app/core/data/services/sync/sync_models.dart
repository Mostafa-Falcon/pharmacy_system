enum SyncOperationType { create, update, delete }

class SyncStatus {
  final bool isOnline;
  final bool isSyncing;
  final DateTime? lastSyncTime;
  final String? lastSyncError;

  const SyncStatus({
    required this.isOnline,
    required this.isSyncing,
    this.lastSyncTime,
    this.lastSyncError,
  });

  SyncStatus copyWith({
    bool? isOnline,
    bool? isSyncing,
    DateTime? lastSyncTime,
    String? lastSyncError,
  }) => SyncStatus(
        isOnline: isOnline ?? this.isOnline,
        isSyncing: isSyncing ?? this.isSyncing,
        lastSyncTime: lastSyncTime ?? this.lastSyncTime,
        lastSyncError: lastSyncError ?? this.lastSyncError,
      );
}

class SyncProgress {
  final SyncOperationType operation;
  final String table;
  final bool isPending;
  final bool? isSuccess;
  final String? error;

  SyncProgress({
    required this.operation,
    required this.table,
    this.isPending = false,
    this.isSuccess,
    this.error,
  });
}
