import 'package:drift/drift.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/core/injection.dart';
import 'package:pharmacy_system/app/core/sync/sync_service.dart';

class ArchiveService {
  static final ArchiveService _instance = ArchiveService._();
  ArchiveService._();
  factory ArchiveService() => _instance;

  AppDatabase get _db => sl<AppDatabase>();

  Future<void> archiveRecord({
    required String entityType,
    required String entityId,
    required String entityName,
    required String deletedById,
    String? deletedByName,
    String? branchId,
    Map<String, dynamic>? entityData,
  }) async {
    final now = DateTime.now();
    await _db
        .into(_db.archiveRecordsTable)
        .insertOnConflictUpdate(
          ArchiveRecordsTableCompanion.insert(
            id: '${entityType}_${entityId}_${now.millisecondsSinceEpoch}',
            entityType: entityType,
            entityId: entityId,
            entityTitle: entityName,
            entityDataJson: entityData?.toString() ?? '{}',
            deletedById: deletedById,
            deletedByName: Value(deletedByName ?? 'المستخدم'),
            branchId: Value(branchId ?? ''),
            deletedAt: now,
          ),
        );

    await SyncService.queueOperation(
      type: SyncOperationType.create,
      table: 'archive_records',
      data: {
        'id': '${entityType}_${entityId}_${now.millisecondsSinceEpoch}',
        'entity_type': entityType,
        'entity_id': entityId,
        'entity_name': entityName,
        'deleted_by': deletedById,
        'deleted_at': now.toIso8601String(),
      },
      branchId: branchId,
    );
  }
}
