import 'package:flutter_test/flutter_test.dart';
import 'package:pharmacy_system/app/core/data/services/sync/sync_dead_letter_service.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/core/data/database/daos/sync_dao.dart';
import 'package:drift/native.dart';
import 'package:get_it/get_it.dart';

Map<String, dynamic> _mapFromItem(OutboxTableData item) => {
      'id': item.recordId,
      'table': item.targetTable,
      'operation': item.operation,
      'branch_id': item.branchId,
    };

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late SyncDao syncDao;
  late SyncDeadLetterService deadLetterService;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    syncDao = SyncDao(db);
    deadLetterService = SyncDeadLetterService();

    final getIt = GetIt.instance;
    if (getIt.isRegistered<AppDatabase>()) getIt.unregister<AppDatabase>();
    if (getIt.isRegistered<SyncDao>()) getIt.unregister<SyncDao>();
    getIt.registerSingleton<AppDatabase>(db);
    getIt.registerSingleton<SyncDao>(syncDao);
  });

  tearDown(() async {
    await db.close();
    await GetIt.instance.reset();
  });

  Future<OutboxTableData> enqueueItem({
    String recordId = 'rec_1',
    String table = 'medicines',
    String operation = 'create',
    int retryCount = 0,
  }) async {
    await syncDao.enqueue(
      operation: operation,
      tableName: table,
      recordId: recordId,
      data: '{"id":"$recordId","name":"test"}',
      branchId: 'br_1',
    );
    if (retryCount > 0) {
      final all = await syncDao.peekPending(100);
      final item = all.firstWhere((e) => e.recordId == recordId);
      for (var i = 0; i < retryCount; i++) {
        await syncDao.markFailed(item.id, 'retry_$i');
      }
    }
    final all = await syncDao.peekPending(100);
    return all.firstWhere((e) => e.recordId == recordId);
  }

  group('SyncDeadLetterService', () {
    test('handleFailedItem returns true and increments retryCount when under limit', () async {
      final item = await enqueueItem();
      expect(item.retryCount, 0);

      final shouldKeep = await deadLetterService.handleFailedItem(_mapFromItem(item));
      expect(shouldKeep, true, reason: 'Item should stay in queue for retry');

      final updated = await syncDao.peekPending(100);
      expect(updated.length, 1);
      expect(updated.first.retryCount, 1);
      expect(updated.first.lastError, 'retry_1');
    });

    test('handleFailedItem returns true and increments retryCount on 2nd retry', () async {
      final item = await enqueueItem(retryCount: 2);
      expect(item.retryCount, 2);

      final shouldKeep = await deadLetterService.handleFailedItem(_mapFromItem(item));
      expect(shouldKeep, true);

      final updated = await syncDao.peekPending(100);
      expect(updated.first.retryCount, 3);
      expect(updated.first.lastError, 'retry_3');
    });

    test('handleFailedItem returns false and marks permanent after max retries', () async {
      final item = await enqueueItem(retryCount: SyncDeadLetterService.maxRetryCount);
      expect(item.retryCount, SyncDeadLetterService.maxRetryCount);

      final shouldKeep = await deadLetterService.handleFailedItem(_mapFromItem(item));
      expect(shouldKeep, false, reason: 'Item should be removed as permanent dead letter');

      final updated = await syncDao.peekPending(100);
      expect(updated.first.retryCount, SyncDeadLetterService.maxRetryCount + 1);
      expect(updated.first.lastError, 'failed_permanently');
    });

    test('handleFailedItem does not remove pending item when shouldKeep is true (check queue)', () async {
      final item = await enqueueItem();
      await deadLetterService.handleFailedItem(_mapFromItem(item));

      final pending = await syncDao.peekPending(100);
      expect(pending.length, 1, reason: 'Item must remain in pending queue for retry');
    });

    test('handleFailedItem removes item from pending when shouldKeep is false (permanent dead letter)', () async {
      final item = await enqueueItem(retryCount: SyncDeadLetterService.maxRetryCount);
      final shouldKeep = await deadLetterService.handleFailedItem(_mapFromItem(item));
      expect(shouldKeep, false);

      await syncDao.markSynced(item.id);
      final pending = await syncDao.peekPending(100);
      expect(pending.length, 0, reason: 'Permanent dead letter should be removable from queue');
    });

    test('getDeadLetterItems returns only items past max retry count', () async {
      await enqueueItem(recordId: 'rec_ok', retryCount: 2);
      await enqueueItem(recordId: 'rec_dead', retryCount: SyncDeadLetterService.maxRetryCount + 1);

      final deadItems = await deadLetterService.getDeadLetterItems();
      expect(deadItems.length, 1);
      expect(deadItems.first.recordId, 'rec_dead');
    });

    test('multiple handleFailedItem calls properly increment retryCount', () async {
      final item = await enqueueItem();

      final maxAttempts = SyncDeadLetterService.maxRetryCount + 1;
      for (var attempt = 1; attempt <= maxAttempts; attempt++) {
        final shouldKeep = await deadLetterService.handleFailedItem(_mapFromItem(item));
        if (attempt <= SyncDeadLetterService.maxRetryCount) {
          expect(shouldKeep, true, reason: 'Should keep on attempt $attempt');
        } else {
          expect(shouldKeep, false, reason: 'Should fail permanently on attempt $attempt');
        }

        final updated = await syncDao.peekPending(100);
        expect(updated.first.retryCount, attempt);
      }
    });
  });
}
