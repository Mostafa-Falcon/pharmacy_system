import 'package:flutter_test/flutter_test.dart';
// ignore_for_file: avoid_print
import 'package:pharmacy_system/app/core/data/services/inventory/batch_service.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/core/data/database/daos/item_batches_dao.dart';
import 'package:drift/native.dart';
import 'package:get_it/get_it.dart';

void main() {
  late AppDatabase db;
  late BatchService batchService;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    final getIt = GetIt.instance;
    if (getIt.isRegistered<AppDatabase>()) getIt.unregister<AppDatabase>();
    if (getIt.isRegistered<ItemBatchesDao>()) getIt.unregister<ItemBatchesDao>();
    if (getIt.isRegistered<BatchService>()) getIt.unregister<BatchService>();

    getIt.registerSingleton<AppDatabase>(db);
    getIt.registerSingleton<ItemBatchesDao>(ItemBatchesDao(db));
    getIt.registerSingleton<BatchService>(BatchService());
    
    batchService = BatchService.to;
    await batchService.init();
  });

  tearDown(() async {
    await db.close();
  });

  test('Should handle multiple expiry dates and track expired batches', () async {
    const medId = 'med_123';
    
    // 1. إضافة تشغيلتين (تاريخين صلاحية مختلفين)
    // تشغيلة منتهية الصلاحية
    await batchService.addBatch(
      medicineId: medId,
      batchNumber: 'B001',
      expiryDate: DateTime.now().subtract(const Duration(days: 30)),
      quantity: 10,
    );

    // تشغيلة صالحة الصلاحية
    await batchService.addBatch(
      medicineId: medId,
      batchNumber: 'B002',
      expiryDate: DateTime.now().add(const Duration(days: 365)),
      quantity: 20,
    );

    print('Step 1: Added two batches. Total Quantity: ${batchService.getTotalQuantity(medId)}');
    // المتاح حالياً هو 20 بس لأن الـ 10 التانيين منتهيين فعلاً
    expect(batchService.getTotalQuantity(medId), 20);

    // التحقق من أن السجل موجود في الـ Cache
    final allBatches = batchService.getBatches(medId);
    expect(allBatches.length, 2);
    expect(allBatches.any((b) => b.batchNumber == 'B001'), isTrue);

    // 2. تشغيل نظام تتبع الصلاحيات (لنقل الكميات المنتهية لخانة التالف)
    print('Step 2: Running Expiry Tracking...');
    final result = await batchService.runExpiryTracking();
    print('Result: ${result.batchesMarkedAsDamaged} batches marked as damaged.');

    // 3. التحقق من النتائج
    // المجموع المتاح لسه 20، بس الفرق إن الـ 10 بتوع B001 بقوا "تالف" رسمياً في الداتا
    expect(batchService.getTotalQuantity(medId), 20);
    expect(result.batchesMarkedAsDamaged, 1);

    // التحقق من حالة التشغيلة المنتهية في الكاش (تأكيد انتقال الكمية للتالف)
    final expiredInDb = batchService.getBatches(medId).firstWhere((b) => b.batchNumber == 'B001');
    expect(expiredInDb.damagedQuantity, 10);
    expect(expiredInDb.remainingQuantity, 0);

    print('✅ SUCCESS: Multiple expiry dates managed and tracking system verified!');
  });
}
