import 'package:flutter_test/flutter_test.dart';
import 'package:supabase/supabase.dart';
import 'package:pharmacy_system/app/core/data/services/sync/sync_engine.dart';
import 'package:pharmacy_system/app/core/data/services/sync/sync_models.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/core/data/database/daos/sync_dao.dart';
import 'package:pharmacy_system/app/core/utils/app_utils.dart';
import 'package:drift/native.dart';
import 'package:get_it/get_it.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mocktail/mocktail.dart';

class MockConnectivity extends Mock implements Connectivity {}

void main() {
  const supabaseUrl = 'https://vhsngfalnltxnaiabvaa.supabase.co';
  const anonKey = 'sb_publishable_xwoFSQD1HYMGfq1CerDnJQ_9DwWc83f';
  
  late AppDatabase db;
  late SyncDao syncDao;
  late SupabaseClient client;
  late SyncEngine syncEngine;

  setUpAll(() async {
    client = SupabaseClient(supabaseUrl, anonKey);
    db = AppDatabase(NativeDatabase.memory());
    syncDao = SyncDao(db);
    
    final getIt = GetIt.instance;
    if (getIt.isRegistered<AppDatabase>()) getIt.unregister<AppDatabase>();
    if (getIt.isRegistered<SyncDao>()) getIt.unregister<SyncDao>();
    getIt.registerSingleton<AppDatabase>(db);
    getIt.registerSingleton<SyncDao>(syncDao);
    
    syncEngine = SyncEngine.instance;
    final mockConnectivity = MockConnectivity();
    when(() => mockConnectivity.onConnectivityChanged).thenAnswer((_) => Stream.value(ConnectivityResult.wifi));
    when(() => mockConnectivity.checkConnectivity()).thenAnswer((_) async => ConnectivityResult.wifi);

    await syncEngine.initialize(supabaseClient: client as dynamic, connectivity: mockConnectivity);
    syncEngine.isOnline = true;
  });

  tearDownAll(() async {
    await db.close();
    await GetIt.instance.reset();
  });

  test('POST-POLICY TEST: Verify Branch Sync works after RLS update', () async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final branchId = 'test_branch_$timestamp';

    safeDebugPrint('Step 1: Queuing a new branch localy...');
    await syncEngine.queueOperation(
      type: SyncOperationType.create,
      table: 'branches',
      data: {
        'id': branchId,
        'name': 'Sync Test Branch $timestamp',
        'is_active': true,
        'last_modified': DateTime.now().toIso8601String(),
        'sync_version': 1,
      },
      branchId: branchId,
    );

    safeDebugPrint('Step 2: Starting SyncEngine.syncAll()...');
    await syncEngine.syncAll();
    
    // انتظار بسيط لضمان انتهاء الرفع
    await Future.delayed(const Duration(seconds: 3));

    safeDebugPrint('Step 3: Checking if outbox is cleared...');
    final pending = await syncDao.peekPending(10);
    
    if (pending.isEmpty) {
      safeDebugPrint('✅ SUCCESS: Item cleared from outbox!');
    } else {
      safeDebugPrint('❌ FAILED: Item still in outbox. Error: ${pending.first.lastError}');
    }

    safeDebugPrint('Step 4: Verifying record exists in Supabase Cloud...');
    final cloudRes = await client.from('branches').select().eq('id', branchId).maybeSingle();

    expect(cloudRes, isNotNull, reason: 'Record was not found in cloud.');
    expect(cloudRes!['name'], 'Sync Test Branch $timestamp');
    
    safeDebugPrint('🔥 CELEBRATION: Sync is officially WORKING for branches!');
    
    // Cleanup
    await client.from('branches').delete().eq('id', branchId);
  });
}
