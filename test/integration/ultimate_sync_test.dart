import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase/supabase.dart';
import 'package:pharmacy_system/app/core/data/services/sync/sync_engine.dart';
import 'package:pharmacy_system/app/core/data/services/sync/sync_models.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/core/data/database/daos/sync_dao.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/core/utils/app_utils.dart';
import 'package:drift/native.dart';
import 'package:get_it/get_it.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mocktail/mocktail.dart';

class MockConnectivity extends Mock implements Connectivity {}

void main() {
  const supabaseUrl = 'https://vhsngfalnltxnaiabvaa.supabase.co';
  // المفتاح اللي أنت بعته (Publishable Key)
  const anonKey = 'sb_publishable_xwoFSQD1HYMGfq1CerDnJQ_9DwWc83f';
  
  late AppDatabase db;
  late SyncDao syncDao;
  late SupabaseClient adminClient;
  late SyncEngine syncEngine;

  setUpAll(() async {
    // استخدام الـ Publishable Key للتأكد من وصول الداتا
    adminClient = SupabaseClient(supabaseUrl, anonKey);
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

    await syncEngine.initialize(supabaseClient: adminClient as dynamic, connectivity: mockConnectivity);
    syncEngine.isOnline = true;
  });

  tearDownAll(() async {
    await db.close();
    await GetIt.instance.reset();
  });

  test('ULTIMATE REAL-WORLD SYNC TEST: Full Business Cycle', () async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final branchId = 'br_$timestamp';
    final customerId = 'cust_$timestamp';
    final medicineId = 'med_$timestamp';
    final saleId = 'sale_$timestamp';
    final purchaseId = 'purch_$timestamp';

    AuthService.currentBranchId = branchId;

    safeDebugPrint('🚀 Starting Ultimate Sync Test...');

    // 1. تجهيز الفرع (الأساس)
    safeDebugPrint('Step 1: Queuing Branch...');
    await syncEngine.queueOperation(
      type: SyncOperationType.create,
      table: 'branches',
      data: {'id': branchId, 'name': 'Ultimate Test Branch', 'is_active': true, 'last_modified': DateTime.now().toIso8601String(), 'sync_version': 1},
      branchId: branchId,
    );

    // 2. إضافة العميل (الحساب)
    safeDebugPrint('Step 2: Queuing Customer (Account)...');
    await syncEngine.queueOperation(
      type: SyncOperationType.create,
      table: 'customers',
      data: {'id': customerId, 'name': 'Falcon Customer $timestamp', 'kind': 'individual', 'is_active': true, 'last_modified': DateTime.now().toIso8601String()},
      branchId: branchId,
    );

    // 3. إضافة الصنف (الدواء)
    safeDebugPrint('Step 3: Queuing Medicine...');
    await syncEngine.queueOperation(
      type: SyncOperationType.create,
      table: 'medicines',
      data: {
        'id': medicineId,
        'name': 'Panadol Ultimate $timestamp',
        'buy_price': 12.5,
        'sell_price': 20.0,
        'quantity': 100,
        'branch_id': branchId,
        'sync_version': 1,
        'last_modified': DateTime.now().toIso8601String(),
      },
      branchId: branchId,
    );

    // 4. عملية بيع
    safeDebugPrint('Step 4: Queuing Sale Transaction...');
    await syncEngine.queueOperation(
      type: SyncOperationType.create,
      table: 'sales',
      data: {
        'id': saleId,
        'branch_id': branchId,
        'customer_id': customerId,
        'total_amount': 40.0,
        'final_amount': 40.0,
        'payment_method': 'cash',
        'items': jsonEncode([{'medicine_id': medicineId, 'quantity': 2, 'price': 20.0, 'total': 40.0}]),
        'created_by': 'admin_gigi',
        'created_at': DateTime.now().toIso8601String(),
        'last_modified': DateTime.now().toIso8601String(),
        'sync_version': 1,
      },
      branchId: branchId,
    );

    // 5. عملية شراء
    safeDebugPrint('Step 5: Queuing Purchase Transaction...');
    await syncEngine.queueOperation(
      type: SyncOperationType.create,
      table: 'purchases',
      data: {
        'id': purchaseId,
        'branch_id': branchId,
        'supplier_name': 'Global Pharma',
        'total_amount': 1250.0,
        'final_amount': 1250.0,
        'status': 'completed',
        'payment_method': 'credit',
        'items': jsonEncode([{'medicine_id': medicineId, 'quantity': 100, 'price': 12.5, 'total': 1250.0}]),
        'created_at': DateTime.now().toIso8601String(),
        'last_modified': DateTime.now().toIso8601String(),
        'sync_version': 1,
      },
      branchId: branchId,
    );

    safeDebugPrint('\n--- RUNNING ENTERPRISE BATCH SYNC ---');
    await syncEngine.syncAll();
    
    // انتظار بسيط لضمان انتهاء معالجة الـ async batches
    await Future.delayed(const Duration(seconds: 5));

    safeDebugPrint('\n--- VERIFYING CLOUD DATA ---');
    
    final branchRes = await adminClient.from('branches').select().eq('id', branchId).maybeSingle();
    final custRes = await adminClient.from('customers').select().eq('id', customerId).maybeSingle();
    final medRes = await adminClient.from('medicines').select().eq('id', medicineId).maybeSingle();
    final saleRes = await adminClient.from('sales').select().eq('id', saleId).maybeSingle();
    final purchRes = await adminClient.from('purchases').select().eq('id', purchaseId).maybeSingle();

    expect(branchRes, isNotNull, reason: 'Branch failed to sync');
    expect(custRes, isNotNull, reason: 'Customer failed to sync');
    expect(medRes, isNotNull, reason: 'Medicine failed to sync');
    expect(saleRes, isNotNull, reason: 'Sale failed to sync');
    expect(purchRes, isNotNull, reason: 'Purchase failed to sync');

    safeDebugPrint('✅ SUCCESS! Full business cycle synced to cloud perfectly.');
    safeDebugPrint('Confirmed records in cloud: 1 Branch, 1 Customer, 1 Medicine, 1 Sale, 1 Purchase.');
  });
}
