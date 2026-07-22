import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pharmacy_system/app/core/data/services/sync/sync_engine.dart';
import 'package:pharmacy_system/app/core/data/services/sync/sync_pull_service.dart';
import 'package:pharmacy_system/app/core/data/services/sync/sync_push_service.dart';
import 'package:pharmacy_system/app/core/data/services/sync/sync_dead_letter_service.dart';
import 'package:pharmacy_system/app/core/data/services/sync/sync_compaction_service.dart';
import 'package:pharmacy_system/app/core/data/database/daos/sync_dao.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}
class MockSyncPullService extends Mock implements SyncPullService {}
class MockSyncPushService extends Mock implements SyncPushService {}
class MockSyncDeadLetterService extends Mock implements SyncDeadLetterService {}
class MockSyncCompactionService extends Mock implements SyncCompactionService {}
class MockSyncDao extends Mock implements SyncDao {}
class MockAppDatabase extends Mock implements AppDatabase {}
class MockConnectivity extends Mock implements Connectivity {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SyncEngine syncEngine;
  late MockSupabaseClient mockSupabase;
  late MockSyncPullService mockPull;
  late MockSyncPushService mockPush;
  late MockSyncDeadLetterService mockDeadLetter;
  late MockSyncCompactionService mockCompaction;
  late MockSyncDao mockSyncDao;
  late MockAppDatabase mockDb;
  late MockConnectivity mockConnectivity;

  setUpAll(() {
    registerFallbackValue(Duration(seconds: 1));
    registerFallbackValue('sync_queue');
    registerFallbackValue(_dummyFailedItemHandler);
  });

  setUp(() {
    mockSupabase = MockSupabaseClient();
    mockPull = MockSyncPullService();
    mockPush = MockSyncPushService();
    mockDeadLetter = MockSyncDeadLetterService();
    mockCompaction = MockSyncCompactionService();
    mockSyncDao = MockSyncDao();
    mockDb = MockAppDatabase();
    mockConnectivity = MockConnectivity();

    when(() => mockConnectivity.onConnectivityChanged).thenAnswer((_) => const Stream.empty());
    when(() => mockConnectivity.checkConnectivity()).thenAnswer((_) async => ConnectivityResult.wifi);

    final getIt = GetIt.instance;
    if (getIt.isRegistered<SyncDao>()) getIt.unregister<SyncDao>();
    if (getIt.isRegistered<AppDatabase>()) getIt.unregister<AppDatabase>();

    getIt.registerSingleton<SyncDao>(mockSyncDao);
    getIt.registerSingleton<AppDatabase>(mockDb);

    syncEngine = SyncEngine.instance;
  });

  test('SyncEngine initialize should setup services', () async {
    await syncEngine.initialize(
      supabaseClient: mockSupabase,
      pull: mockPull,
      push: mockPush,
      deadLetter: mockDeadLetter,
      compaction: mockCompaction,
      connectivity: mockConnectivity,
    );

    expect(syncEngine.pullService, mockPull);
    expect(syncEngine.pushService, mockPush);
  });

  test('syncAll should process push queue', () async {
    when(() => mockPush.processPushQueue(
      syncBoxName: any(named: 'syncBoxName'),
      onFailedItem: any(named: 'onFailedItem'),
    )).thenAnswer((_) async => 5);

    await syncEngine.initialize(
      supabaseClient: mockSupabase,
      pull: mockPull,
      push: mockPush,
      deadLetter: mockDeadLetter,
      compaction: mockCompaction,
      connectivity: mockConnectivity,
    );

    syncEngine.isOnline = true;
    AuthService.currentBranchId = 'test-branch';

    await syncEngine.syncAll();

    verify(() => mockPush.processPushQueue(
      syncBoxName: any(named: 'syncBoxName'),
      onFailedItem: any(named: 'onFailedItem'),
    )).called(1);

    expect(syncEngine.lastSyncError, isNull);
  });
}

Future<bool> _dummyFailedItemHandler(Map<String, dynamic> item) async => true;
