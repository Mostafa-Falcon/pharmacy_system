import 'package:flutter_test/flutter_test.dart';
// ignore_for_file: avoid_print
import 'package:supabase/supabase.dart';
import 'package:pharmacy_system/app/core/data/services/sync/sync_engine.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/core/data/database/daos/sync_dao.dart';
import 'package:pharmacy_system/app/core/data/database/daos/cashier_shifts_dao.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:drift/native.dart';
import 'package:get_it/get_it.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mocktail/mocktail.dart';

import 'package:pharmacy_system/app/core/injection.dart';

class MockConnectivity extends Mock implements Connectivity {}

void main() {
  const supabaseUrl = 'https://vhsngfalnltxnaiabvaa.supabase.co';
  const anonKey = 'sb_publishable_xwoFSQD1HYMGfq1CerDnJQ_9DwWc83f';
  
  late AppDatabase dbDeviceB;
  late SyncDao syncDaoB;
  late SupabaseClient client;
  late SyncEngine syncEngineB;

  setUpAll(() async {
    client = SupabaseClient(supabaseUrl, anonKey);
    
    // محاكاة الجهاز (ب)
    dbDeviceB = AppDatabase(NativeDatabase.memory());
    syncDaoB = SyncDao(dbDeviceB);
    
    final getIt = GetIt.instance;
    if (getIt.isRegistered<AppDatabase>()) getIt.unregister<AppDatabase>();
    if (getIt.isRegistered<SyncDao>()) getIt.unregister<SyncDao>();
    if (getIt.isRegistered<CashierShiftsDao>()) getIt.unregister<CashierShiftsDao>();
    
    getIt.registerSingleton<AppDatabase>(dbDeviceB);
    getIt.registerSingleton<SyncDao>(syncDaoB);
    getIt.registerSingleton<CashierShiftsDao>(CashierShiftsDao(dbDeviceB));
    
    syncEngineB = SyncEngine.instance;
    final mockConn = MockConnectivity();
    when(() => mockConn.onConnectivityChanged).thenAnswer((_) => Stream.value(ConnectivityResult.wifi));
    when(() => mockConn.checkConnectivity()).thenAnswer((_) async => ConnectivityResult.wifi);

    await syncEngineB.initialize(supabaseClient: client as dynamic, connectivity: mockConn);
    syncEngineB.isOnline = true;
    AuthService.currentBranchId = '1784678856613';
  });

  test('CLOUD SHIFT TEST: Device B should see shift opened by Device A', () async {
    final branchId = '1784678856613';
    final cashierId = 'test_user_${DateTime.now().millisecondsSinceEpoch}';
    final shiftId = 'shift_${DateTime.now().millisecondsSinceEpoch}';

    print('Step 1: Simulating Device A opening a shift on Cloud...');
    final shiftData = {
      'id': shiftId,
      'branch_id': branchId,
      'shift_number': 99,
      'cashier_id': cashierId,
      'cashier_name': 'Test Device A',
      'device_id': 'device_a',
      'opened_at': DateTime.now().toIso8601String(),
      'opening_cash': 500.0,
      'status': 'open',
      'last_modified': DateTime.now().toIso8601String(),
      'sync_version': 1,
      'is_deleted': false,
    };
    
    // نرفع الوردية مباشرة للسحاب (كأن جهاز أ رفعها)
    await client.from('cashier_shifts').upsert(shiftData);
    print('Device A successfully uploaded shift to cloud.');

    print('Step 2: Device B performing Sync...');
    // الجهاز ب بيعمل مزامنة (Pull)
    await syncEngineB.syncAll();
    
    print('Step 3: Checking Device B local database...');
    final shiftsInB = await sl<CashierShiftsDao>().getAll();
    final found = shiftsInB.any((s) => s.id == shiftId && s.status == 'open');

    expect(found, isTrue, reason: 'Device B failed to pull the open shift from cloud.');
    
    print('✅ SUCCESS! Shift shared across devices via cloud sync.');
    
    // Cleanup
    await client.from('cashier_shifts').delete().eq('id', shiftId);
  });
}
