import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/system_tables.dart';

part 'sync_dao.g.dart';

@DriftAccessor(tables: [SyncOutboxTable, SyncStateTable])
class SyncDao extends DatabaseAccessor<AppDatabase> with _$SyncDaoMixin {
  SyncDao(super.db);

  // ─── Outbox Management ───

  /// إضافة عملية إلى طابور الرفع
  Future<void> enqueue({
    required String operation,
    required String tableName,
    required String recordId,
    required String data,
    String? branchId,
    String? accountId,
  }) async {
    await into(syncOutboxTable).insert(
      SyncOutboxTableCompanion.insert(
        id: recordId, // أو نستخدم UUID لو حابب
        operationType: operation,
        targetTable: tableName,
        payloadJson: data,
        branchId: Value(branchId ?? ''),
        accountId: Value(accountId),
        createdAt: DateTime.now(),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  /// الحصول على العناصر التي لم تُرفع بعد
  Future<List<SyncOutboxTableData>> getUnsyncedItems() =>
      (select(syncOutboxTable)..where((t) => t.status.equals('pending'))).get();

  /// جلب مجموعة من العمليات المعلقة للرفع
  Future<List<SyncOutboxTableData>> peekPending(int limit) =>
      (select(syncOutboxTable)
            ..where((t) => t.status.equals('pending'))
            ..limit(limit))
          .get();

  /// تعليم العملية كناجحة
  Future<void> markSynced(String id) =>
      (update(syncOutboxTable)..where((t) => t.id.equals(id))).write(
        SyncOutboxTableCompanion(
          status: const Value('synced'),
          errorMessage: const Value(null),
        ),
      );

  /// تعليم العملية كفاشلة مع تسجيل الخطأ
  Future<void> markFailed(String id, String error) async {
    final row = await (select(syncOutboxTable)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (row == null) return;

    await (update(syncOutboxTable)..where((t) => t.id.equals(id))).write(
      SyncOutboxTableCompanion(
        retryCount: Value(row.retryCount + 1),
        errorMessage: Value(error),
        status: Value(row.retryCount >= 5 ? 'failed' : 'pending'),
      ),
    );
  }

  /// مسح العمليات التي تم رفعها بنجاح لتنظيف القاعدة
  Future<void> purgeSynced() =>
      (delete(syncOutboxTable)..where((t) => t.status.equals('synced'))).go();

  /// حذف عناصر محددة من الـ Outbox (لأغراض الـ Compaction)
  Future<void> deleteOutboxItems(List<String> ids) =>
      (delete(syncOutboxTable)..where((t) => t.id.isIn(ids))).go();

  /// تحديث بيانات عملية موجودة في الـ Outbox
  Future<void> updateOutboxItem(String id, String data, String op) =>
      (update(syncOutboxTable)..where((t) => t.id.equals(id))).write(
        SyncOutboxTableCompanion(
          payloadJson: Value(data),
          operationType: Value(op),
        ),
      );

  /// التأكد إذا كان هناك تعديل محلي لم يُرفع بعد لهذا السجل
  Future<bool> hasUnsyncedForRecord(String table, String recordId) async {
    final result = await (select(syncOutboxTable)
          ..where((t) =>
              t.targetTable.equals(table) &
              t.id.equals(recordId) &
              t.status.equals('pending')))
        .get();
    return result.isNotEmpty;
  }

  // ─── Sync State (Watermarks) ───

  /// الحصول على آخر نقطة مزامنة لجدول معين
  Future<SyncStateTableData?> getWatermark(String table, String branchId) =>
      (select(syncStateTable)
            ..where((t) => t.targetTable.equals(table) & t.branchId.equals(branchId)))
          .getSingleOrNull();

  /// تحديث نقطة المزامنة (Watermark)
  Future<void> upsertWatermark({
    required String tableName,
    required DateTime watermark,
    required String branchId,
  }) async {
    await into(syncStateTable).insert(
      SyncStateTableCompanion.insert(
        id: '${tableName}_$branchId',
        targetTable: tableName,
        lastSyncedAt: watermark,
        branchId: Value(branchId),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  /// الحصول على عدد السجلات في جدول محلي
  Future<int> getTableCount(String tableName) async {
    // هذه الوظيفة تتطلب استعلاماً ديناميكياً أو مابينج
    return 0; 
  }

  Future<void> purgeDeadLetters(int maxRetries) =>
      (delete(syncOutboxTable)..where((t) => t.retryCount.isBiggerOrEqualValue(maxRetries))).go();
}


