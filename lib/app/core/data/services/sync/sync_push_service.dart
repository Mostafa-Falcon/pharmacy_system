import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:pharmacy_system/app/core/data/database/daos/sync_dao.dart';
import 'package:pharmacy_system/app/core/utils/app_utils.dart';

class SyncPushService {
  final SupabaseClient _supabase;
  SyncDao get _syncDao => GetIt.instance<SyncDao>();

  SyncPushService(this._supabase);

  Future<int> processPushQueue({
    required String syncBoxName,
    required Future<bool> Function(Map<String, dynamic> item) onFailedItem,
    void Function(String table, bool success, bool isPending)? onItemProcessed,
  }) async {
    final items = await _syncDao.peekPending(10000);
    if (items.isEmpty) return 0;

    int successCount = 0;
    for (final item in items) {
      try {
        // إشارة لبدء معالجة الجدول
        onItemProcessed?.call(item.targetTable, false, true);

        final data = Map<String, dynamic>.from(
          jsonDecode(item.data) as Map,
        );
        
        // قائمة بالجداول التي لا تحتوي على عمود branch_id
        const globalTables = {'branches', 'users', 'permissions', 'customer_groups', 'app_settings'};

        // ضمان وجود branch_id في الـ payload للامتثال لسياسات RLS
        // فقط للجداول غير العالمية
        if (!globalTables.contains(item.targetTable)) {
          if (data['branch_id'] == null && item.branchId.isNotEmpty) {
            data['branch_id'] = item.branchId;
          }
        }

        final success = await _pushSingleItem(
          operation: item.operation,
          table: item.targetTable,
          data: data,
          recordId: item.recordId,
        );
        if (success) {
          await _syncDao.markSynced(item.id);
          successCount++;
          onItemProcessed?.call(item.targetTable, true, false);
        } else {
          final shouldKeep = await onFailedItem({...data, 'outbox_id': item.id});
          if (!shouldKeep) {
            await _syncDao.markSynced(item.id);
          }
          onItemProcessed?.call(item.targetTable, false, false);
        }
      } catch (e, s) {
        safeDebugPrint('SyncPushService: Error pushing item ${item.id}: $e\n$s');
        
        // تسجيل الخطأ في قاعدة البيانات
        await _syncDao.markFailed(item.id, e.toString());

        final data = Map<String, dynamic>.from(
          jsonDecode(item.data) as Map,
        );
        // إضافة معلومات الجدول والعملية لتمكين الـ dead letter من التصرف
        data['table'] = item.targetTable;
        data['operation'] = item.operation;
        data['branch_id'] = item.branchId;
        data['outbox_id'] = item.id; // تمرير الـ ID الفعلي في الـ Outbox

        final shouldKeep = await onFailedItem(data);
        if (!shouldKeep) {
          // إذا كان الخطأ نهائياً (تجاوز المحاولات)، نعتبره "منتهي"
          await _syncDao.markSynced(item.id);
        }
        onItemProcessed?.call(item.targetTable, false, false);
      }
    }
    return successCount;
  }

  Future<bool> _pushSingleItem({
    required String operation,
    required String table,
    required Map<String, dynamic> data,
    required String recordId,
  }) async {
    final payload = Map<String, dynamic>.from(data);

    switch (operation) {
      case 'create':
      case 'update':
        await _supabase.from(table).upsert(payload);
        return true;
      case 'delete':
        final idVal = payload['id'] ?? recordId;
        await _supabase.from(table).delete().eq('id', idVal);
        return true;
      default:
        safeDebugPrint('SyncPushService: Unknown operation type "$operation"');
        return false;
    }
  }
}
