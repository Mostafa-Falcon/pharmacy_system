import 'package:flutter_test/flutter_test.dart';
// ignore_for_file: avoid_print
import 'package:supabase/supabase.dart';
import 'package:pharmacy_system/app/core/sync/sync_engine.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/core/data/database/daos/sync_dao.dart';
import 'package:pharmacy_system/app/core/data/database/daos/medicines_dao.dart';
import 'package:pharmacy_system/app/core/data/database/daos/branches_dao.dart';
import 'package:pharmacy_system/app/core/data/repositories/medicines_repository.dart';
import 'package:pharmacy_system/app/modules/inventory/models/medicine_model.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:drift/native.dart';
import 'package:get_it/get_it.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mocktail/mocktail.dart';

class MockConnectivity extends Mock implements Connectivity {}

void main() {
  const supabaseUrl = 'https://vhsngfalnltxnaiabvaa.supabase.co';
  const anonKey = 'sb_publishable_xwoFSQD1HYMGfq1CerDnJQ_9DwWc83f';
  
  late AppDatabase db;
  late MedicinesRepository medicinesRepo;
  late SupabaseClient client;
  late SyncEngine syncEngine;

  setUpAll(() async {
    client = SupabaseClient(supabaseUrl, anonKey);
    db = AppDatabase(NativeDatabase.memory());
    
    final getIt = GetIt.instance;
    if (getIt.isRegistered<AppDatabase>()) getIt.unregister<AppDatabase>();
    if (getIt.isRegistered<SyncDao>()) getIt.unregister<SyncDao>();
    if (getIt.isRegistered<MedicinesDao>()) getIt.unregister<MedicinesDao>();
    if (getIt.isRegistered<BranchesDao>()) getIt.unregister<BranchesDao>();
    if (getIt.isRegistered<SyncEngine>()) getIt.unregister<SyncEngine>();
    if (getIt.isRegistered<MedicinesRepository>()) getIt.unregister<MedicinesRepository>();

    getIt.registerSingleton<AppDatabase>(db);
    getIt.registerSingleton<SyncDao>(SyncDao(db));
    getIt.registerSingleton<MedicinesDao>(MedicinesDao(db));
    getIt.registerSingleton<BranchesDao>(BranchesDao(db));
    getIt.registerSingleton<SyncEngine>(SyncEngine.instance);
    
    medicinesRepo = MedicinesRepository();
    getIt.registerSingleton<MedicinesRepository>(medicinesRepo);
    
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

  test('MEDICINE SYNC TEST: Add Medicine via Repository and Verify on Cloud', () async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final branchId = 'br_sync_$timestamp';
    final medicineId = 'med_sync_$timestamp';

    // 1. Ø¥Ø¹Ø¯Ø§Ø¯ Ø§Ù„ÙØ±Ø¹ Ù…Ø­Ù„ÙŠØ§Ù‹ (Ø§Ù„Ù…Ø²Ø§Ù…Ù†Ø© Ø§Ù„Ø°ÙƒÙŠØ© Ù‡ØªØ±ÙØ¹Ù‡ Ù„ÙˆØ­Ø¯Ù‡Ø§)
    print('Step 1: Setting up local branch...');
    final branchesDao = GetIt.instance<BranchesDao>();
    await branchesDao.upsert(BranchesTableCompanion.insert(
      id: branchId,
      name: 'Sync Test Branch',
      isActive: true,
      createdAt: DateTime.now(),
      lastModified: DateTime.now(),
      syncVersion: 1,
      isDeleted: false,
    ));
    AuthService.currentBranchId = branchId;

    // 2. Ø¥Ø¶Ø§ÙØ© Ø§Ù„Ø¯ÙˆØ§Ø¡ Ø¹Ø¨Ø± Ø§Ù„Ù€ Repository
    print('Step 2: Adding Medicine via Repository...');
    final medicine = MedicineModel(
      id: medicineId,
      name: 'Sync Test Medicine $timestamp',
      buyPrice: 10.0,
      sellPrice: 20.0,
      quantity: 50,
      branchId: branchId,
      barcodes: ['BAR_$timestamp'],
    );
    
    await medicinesRepo.create(medicine, branchId: branchId);

    // 3. ØªØ´ØºÙŠÙ„ Ø§Ù„Ù…Ø²Ø§Ù…Ù†Ø©
    print('Step 3: Triggering SyncEngine.syncAll()...');
    await syncEngine.syncAll();
    
    // Ø§Ù†ØªØ¸Ø§Ø± Ø§Ù„Ø±ÙØ¹
    await Future.delayed(const Duration(seconds: 5));

    // 4. Ø§Ù„ØªØ­Ù‚Ù‚ Ù…Ù† Ø§Ù„Ø³Ø­Ø§Ø¨Ø©
    print('Step 4: Verifying from Supabase Cloud...');
    final res = await client.from('medicines').select().eq('id', medicineId).maybeSingle();

    if (res != null) {
      print('âœ… SUCCESS: Medicine "${res['name']}" found in Cloud!');
      expect(res['id'], medicineId);
    } else {
      print('âŒ FAILED: Medicine not found in cloud. Check RLS or Foreign Key.');
      // ÙØ­Øµ Ø§Ù„Ø£Ø®Ø·Ø§Ø¡ ÙÙŠ Ø§Ù„Ø·Ø§Ø¨ÙˆØ± Ø§Ù„Ù…Ø­Ù„ÙŠ
      final pending = await GetIt.instance<SyncDao>().peekPending(10);
      for (var p in pending) {
        print('Pending Item: ${p.targetTable}, Last Error: ${p.lastError}');
      }
      fail('Medicine sync failed.');
    }
    
    // Cleanup cloud
    await client.from('medicines').delete().eq('id', medicineId);
    await client.from('branches').delete().eq('id', branchId);
  });
}

