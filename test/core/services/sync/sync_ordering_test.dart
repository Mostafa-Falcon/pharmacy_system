import 'package:flutter_test/flutter_test.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/core/data/database/daos/sync_dao.dart';
import 'package:drift/native.dart';
import 'package:get_it/get_it.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late SyncDao syncDao;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    syncDao = SyncDao(db);
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

  group('Queue ordering (FIFO)', () {
    test('peekPending returns items in createdAt order (FIFO)', () async {
      await syncDao.enqueue(
        operation: 'create', tableName: 'medicines', recordId: 'first',
        data: '{}', branchId: 'br_1',
      );
      await Future.delayed(const Duration(milliseconds: 2));
      await syncDao.enqueue(
        operation: 'create', tableName: 'medicines', recordId: 'second',
        data: '{}', branchId: 'br_1',
      );
      await Future.delayed(const Duration(milliseconds: 2));
      await syncDao.enqueue(
        operation: 'create', tableName: 'medicines', recordId: 'third',
        data: '{}', branchId: 'br_1',
      );

      final items = await syncDao.peekPending(100);
      expect(items.length, 3);
      expect(items[0].recordId, 'first');
      expect(items[1].recordId, 'second');
      expect(items[2].recordId, 'third');
    });

    test('priority tables are sorted before non-priority tables', () async {
      // Simulate the push service's sorting logic
      const priorityTables = ['branches', 'users', 'customers', 'suppliers'];
      final tables = ['sales', 'customers', 'medicines', 'branches'];
      tables.sort((a, b) {
        final aIdx = priorityTables.indexOf(a);
        final bIdx = priorityTables.indexOf(b);
        if (aIdx != -1 && bIdx != -1) return aIdx.compareTo(bIdx);
        if (aIdx != -1) return -1;
        if (bIdx != -1) return 1;
        return 0;
      });

      expect(tables[0], 'branches');
      expect(tables[1], 'customers');
      expect(tables[2], anyOf(equals('medicines'), equals('sales')));
    });

    test('item created first in queue stays as pending item', () async {
      await syncDao.enqueue(
        operation: 'create', tableName: 'medicines', recordId: 'keep_me',
        data: '{"id":"keep_me","name":"test"}', branchId: 'br_1',
      );

      final items = await syncDao.peekPending(100);
      expect(items.length, 1);
      expect(items.first.recordId, 'keep_me');
      expect(items.first.syncedAt, isNull);
    });

    test('markSynced removes item from pending queue', () async {
      await syncDao.enqueue(
        operation: 'create', tableName: 'medicines', recordId: 'gone',
        data: '{}', branchId: 'br_1',
      );

      final items = await syncDao.peekPending(100);
      await syncDao.markSynced(items.first.id);

      final after = await syncDao.peekPending(100);
      expect(after.length, 0);
    });

    test('markFailed does NOT remove item from pending queue', () async {
      await syncDao.enqueue(
        operation: 'create', tableName: 'medicines', recordId: 'retry_me',
        data: '{}', branchId: 'br_1',
      );

      final items = await syncDao.peekPending(100);
      await syncDao.markFailed(items.first.id, 'test_error');

      final after = await syncDao.peekPending(100);
      expect(after.length, 1, reason: 'Item must stay in queue after markFailed');
      expect(after.first.retryCount, 1);
      expect(after.first.lastError, 'test_error');
    });

    test('multiple tables maintain their relative createdAt order', () async {
      // Simulate: customers created first, then sales
      await syncDao.enqueue(
        operation: 'create', tableName: 'customers', recordId: 'c1',
        data: '{}', branchId: 'br_1',
      );
      await Future.delayed(const Duration(milliseconds: 2));
      await syncDao.enqueue(
        operation: 'create', tableName: 'sales', recordId: 's1',
        data: '{}', branchId: 'br_1',
      );
      await Future.delayed(const Duration(milliseconds: 2));
      await syncDao.enqueue(
        operation: 'create', tableName: 'customers', recordId: 'c2',
        data: '{}', branchId: 'br_1',
      );

      final items = await syncDao.peekPending(100);
      expect(items.length, 3);
      // First item should be the earliest created
      expect(items[0].recordId, 'c1');
      expect(items[0].targetTable, 'customers');
      expect(items[2].recordId, 'c2');
      expect(items[2].targetTable, 'customers');
    });

    test('successful push marks items synced in order', () async {
      await syncDao.enqueue(
        operation: 'create', tableName: 'medicines', recordId: 'order_1',
        data: '{"id":"order_1"}', branchId: 'br_1',
      );
      await syncDao.enqueue(
        operation: 'create', tableName: 'medicines', recordId: 'order_2',
        data: '{"id":"order_2"}', branchId: 'br_1',
      );

      // Simulate markSynced in order
      final items = await syncDao.peekPending(100);
      await syncDao.markSynced(items[0].id);
      await syncDao.markSynced(items[1].id);

      final remaining = await syncDao.peekPending(100);
      expect(remaining.length, 0, reason: 'Both items should be synced after push');
    });
  });
}
