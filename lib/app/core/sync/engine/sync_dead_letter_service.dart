import 'dart:convert';
import 'package:get_it/get_it.dart';
import 'package:drift/drift.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/core/data/database/daos/sync_dao.dart';
import 'package:pharmacy_system/app/shared/ui_core.dart';

class SyncDeadLetterService {
  static const int maxRetryCount = 5;

  SyncDao get _syncDao => GetIt.instance<SyncDao>();
  AppDatabase get _db => GetIt.instance<AppDatabase>();

  Future<void> init() async {
    safeDebugPrint('SyncDeadLetterService: Ready (Drift-based)');
  }

  Future<bool> handleFailedItem(Map<String, dynamic> item) async {
    final recordId = item['id']?.toString() ?? '';
    final table = item['table']?.toString() ?? 'unknown';
    final operation = item['operation']?.toString() ?? 'create';
    final branchId = item['branch_id']?.toString() ?? '';
    final outboxId = item['outbox_id']?.toString();

    SyncOutboxTableData? existingItem;
    if (outboxId != null) {
      final results = await (_db.select(_db.syncOutboxTable)..where((t) => t.id.equals(outboxId))).get();
      if (results.isNotEmpty) existingItem = results.first;
    }

    if (existingItem == null) {
      final existing = await _syncDao.peekPending(100);
      final matched = existing.where((e) =>
          e.id == recordId &&
          e.targetTable == table &&
          e.operationType == operation).toList();
      if (matched.isNotEmpty) {
        existingItem = matched.first;
      }
    }

    final currentRetryCount = (existingItem?.retryCount ?? 0) + 1;

    if (currentRetryCount > maxRetryCount) {
      safeDebugPrint(
        'SyncDeadLetterService: Exceeded max retries for record $recordId in $table. '
        'Marking as permanent dead letter.',
      );
      if (existingItem != null) {
        await _syncDao.markFailed(
          existingItem.id,
          'failed_permanently',
        );
      }
      return false;
    }

    safeDebugPrint(
      'SyncDeadLetterService: Record $recordId in $table queued for retry '
      '($currentRetryCount/$maxRetryCount)',
    );

    if (existingItem != null) {
      await _syncDao.markFailed(
        existingItem.id,
        'retry_$currentRetryCount',
      );
    } else {
      await _syncDao.enqueue(
        operation: operation,
        tableName: table,
        recordId: recordId,
        data: jsonEncode(item),
        branchId: branchId,
      );
    }

    return true;
  }

  Future<List<SyncOutboxTableData>> getDeadLetterItems() async {
    return (_db.select(_db.syncOutboxTable)
          ..where((t) =>
              t.status.equals('failed') |
              t.retryCount.isBiggerThan(Variable(maxRetryCount - 1))))
        .get();
  }
}
