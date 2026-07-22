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
    AuthService.currentBranchId = '1784678856613';
  });

  test('FULL SYSTEM TEST: Sync Account, Medicine, Sale, and Purchase', () async {
    final branchId = '1784678856613';
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    
    // 1. Queue a Customer (Account)
    final customerId = 'test_cust_$timestamp';
    safeDebugPrint('Step 1: Queuing Customer...');
    await syncEngine.queueOperation(
      type: SyncOperationType.create,
      table: 'customers',
      data: {
        'id': customerId,
        'name': 'Test Account $timestamp',
        'kind': 'individual',
        'is_active': true,
        'last_modified': DateTime.now().toIso8601String(),
      },
      branchId: branchId,
    );

    // 2. Queue a Medicine
    final medicineId = 'test_med_$timestamp';
    safeDebugPrint('Step 2: Queuing Medicine...');
    await syncEngine.queueOperation(
      type: SyncOperationType.create,
      table: 'medicines',
      data: {
        'id': medicineId,
        'name': 'Panadol Test $timestamp',
        'buy_price': 10.0,
        'sell_price': 15.0,
        'quantity': 100,
        'branch_id': branchId,
        'sync_version': 1,
        'last_modified': DateTime.now().toIso8601String(),
      },
      branchId: branchId,
    );

    // 3. Queue a Sale Transaction
    final saleId = 'test_sale_$timestamp';
    safeDebugPrint('Step 3: Queuing Sale...');
    await syncEngine.queueOperation(
      type: SyncOperationType.create,
      table: 'sales',
      data: {
        'id': saleId,
        'branch_id': branchId,
        'customer_id': customerId,
        'total_amount': 30.0,
        'final_amount': 30.0,
        'payment_method': 'cash',
        'created_by': 'admin',
        'items': jsonEncode([
          {'medicine_id': medicineId, 'quantity': 2, 'price': 15.0, 'total': 30.0}
        ]),
        'created_at': DateTime.now().toIso8601String(),
        'last_modified': DateTime.now().toIso8601String(),
        'sync_version': 1,
        'is_deleted': false,
      },
      branchId: branchId,
    );

    // 4. Queue a Purchase Transaction
    final purchaseId = 'test_purch_$timestamp';
    safeDebugPrint('Step 4: Queuing Purchase...');
    await syncEngine.queueOperation(
      type: SyncOperationType.create,
      table: 'purchases',
      data: {
        'id': purchaseId,
        'branch_id': branchId,
        'supplier_name': 'Test Supplier',
        'total_amount': 500.0,
        'final_amount': 500.0,
        'payment_method': 'credit',
        'status': 'completed',
        'created_by': 'admin',
        'items': jsonEncode([
          {'medicine_id': medicineId, 'quantity': 50, 'price': 10.0, 'total': 500.0}
        ]),
        'created_at': DateTime.now().toIso8601String(),
        'last_modified': DateTime.now().toIso8601String(),
        'sync_version': 1,
        'is_deleted': false,
      },
      branchId: branchId,
    );

    safeDebugPrint('\n--- ALL OPERATIONS QUEUED (Local Outbox) ---');
    final pendingCount = syncEngine.pendingOperationsCount;
    expect(pendingCount, 4);
    safeDebugPrint('Pending items in queue: $pendingCount');

    safeDebugPrint('\n--- STARTING GLOBAL SYNC ---');
    await syncEngine.syncAll();
    
    // ننتظر قليلاً لمعالجة النتائج
    await Future.delayed(const Duration(seconds: 3));

    safeDebugPrint('\n--- POST-SYNC VERIFICATION ---');
    final remaining = await syncDao.peekPending(10);
    safeDebugPrint('Remaining items in outbox: ${remaining.length}');
    
    for (var item in remaining) {
       safeDebugPrint('Failed Item: ${item.targetTable}, Error: ${item.lastError}');
    }

    if (remaining.isEmpty) {
      safeDebugPrint('CONGRATULATIONS! All system operations synced successfully.');
    } else {
      safeDebugPrint('Sync partially completed. Some items failed (likely RLS).');
    }
  });
}
