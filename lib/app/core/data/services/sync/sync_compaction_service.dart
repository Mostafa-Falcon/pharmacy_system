import 'dart:convert';
import 'package:get_it/get_it.dart';
import 'package:pharmacy_system/app/core/data/database/daos/sync_dao.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/core/utils/app_utils.dart';

/// خدمة تجميع وضغط طابور المزامنة (Outbox Compaction Service)
/// تلخص وتدمج العمليات المعلقة المكررة لنفس السجل لمنع استهلاك طلبات API مكررة.
class SyncCompactionService {
  SyncDao get _syncDao => GetIt.instance<SyncDao>();

  /// يضغط طابور العمليات المعلقة في Outbox ويمنع تكرار أي سجل.
  /// يعيد عدد العمليات المعلقة التي تم اختصارها وإلغاؤها.
  Future<int> compactOutboxQueue() async {
    try {
      final unsynced = await _syncDao.getUnsyncedItems();
      if (unsynced.length <= 1) return 0;

      // تجميع حسب (الجدول + معرف السجل)
      final Map<String, List<OutboxTableData>> groups = {};
      for (final item in unsynced) {
        final key = '${item.targetTable}:${item.recordId}';
        groups.putIfAbsent(key, () => []).add(item);
      }

      int totalEliminated = 0;

      for (final entry in groups.entries) {
        final items = entry.value;
        if (items.length <= 1) continue;

        final firstOp = items.first.operation.toLowerCase();
        final lastOp = items.last.operation.toLowerCase();

        final idsToDelete = <String>[];
        Map<String, dynamic> mergedData = {};

        // دمج البيانات تدريجياً لجميع العمليات في المجموعة
        for (final item in items) {
          try {
            if (item.data.isNotEmpty) {
              final parsed = jsonDecode(item.data) as Map<String, dynamic>;
              mergedData.addAll(parsed);
            }
          } catch (e) {
            safeDebugPrint('SyncCompactionService JSON decode error: $e');
          }
        }

        // حالة 1: إنشاء ثم حذف أوفلاين (CREATE + DELETE) ⬅️ إلغاء كلي
        if ((firstOp == 'create' || firstOp == 'insert') && (lastOp == 'delete' || lastOp == 'softdelete')) {
          idsToDelete.addAll(items.map((i) => i.id));
          await _syncDao.deleteOutboxItems(idsToDelete);
          totalEliminated += items.length;
          safeDebugPrint('Compacted: Cancelled local create+delete cycle for ${entry.key}');
          continue;
        }

        // حالة 2: العملية الأخيرة حذف ⬅️ الاحتفاظ بحذف واحد وإلغاء ما قبله
        if (lastOp == 'delete' || lastOp == 'softdelete') {
          final keepItem = items.last;
          for (final item in items) {
            if (item.id != keepItem.id) {
              idsToDelete.add(item.id);
            }
          }
          await _syncDao.deleteOutboxItems(idsToDelete);
          await _syncDao.updateOutboxItem(keepItem.id, jsonEncode(mergedData), lastOp);
          totalEliminated += idsToDelete.length;
          safeDebugPrint('Compacted: Reduced to single DELETE for ${entry.key}');
          continue;
        }

        // حالة 3: العملية الأولى إنشاء مع تحديثات بعدها (CREATE + UPDATES)
        if (firstOp == 'create' || firstOp == 'insert') {
          final keepItem = items.first;
          for (int i = 1; i < items.length; i++) {
            idsToDelete.add(items[i].id);
          }
          await _syncDao.deleteOutboxItems(idsToDelete);
          await _syncDao.updateOutboxItem(keepItem.id, jsonEncode(mergedData), firstOp);
          totalEliminated += idsToDelete.length;
          safeDebugPrint('Compacted: Merged updates into initial CREATE for ${entry.key}');
          continue;
        }

        // حالة 4: تحديثات مكررة (UPDATES + UPDATES)
        final keepItem = items.last;
        for (final item in items) {
          if (item.id != keepItem.id) {
            idsToDelete.add(item.id);
          }
        }
        await _syncDao.deleteOutboxItems(idsToDelete);
        await _syncDao.updateOutboxItem(keepItem.id, jsonEncode(mergedData), 'update');
        totalEliminated += idsToDelete.length;
        safeDebugPrint('Compacted: Merged ${items.length} updates into 1 for ${entry.key}');
      }

      // تنظيف العناصر التي تم رفعها بنجاح قدام
      await _syncDao.purgeSynced();
      await _syncDao.purgeDeadLetters(5);

      return totalEliminated;
    } catch (e, s) {
      safeDebugPrint('SyncCompactionService.compactOutboxQueue error: $e\n$s');
      return 0;
    }
  }

  Future<void> compactAll(List<String> tableNames) async {
    await compactOutboxQueue();
  }

  Future<void> compactTable(String tableName) async {
    await compactOutboxQueue();
  }

  Future<void> compactAllBoxes(List<String> boxNames) async {
    await compactOutboxQueue();
  }

  Future<void> compactBox(String boxName) async {
    await compactOutboxQueue();
  }
}
