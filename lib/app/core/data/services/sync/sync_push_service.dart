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
        
        // قائمة بالجداول التي لا تحتوي على عمود branch_id (جداول عامة أو فرعية تابعة لصنف)
        const globalTables = {
          'branches', 
          'users', 
          'permissions', 
          'customer_groups', 
          'app_settings',
          'item_batches',
          'medicine_units',
          'variants'
        };

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
      } catch (e) {
        final errorMsg = e is PostgrestException ? '${e.message} (Code: ${e.code})' : e.toString();
        safeDebugPrint('SyncPushService: Error pushing item ${item.id} to table ${item.targetTable}: $errorMsg');
        
        // تسجيل الخطأ في قاعدة البيانات
        await _syncDao.markFailed(item.id, errorMsg);

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

  /// قائمة بالجداول التي تدعم sync_version لفحص التضارب
  static const _versionedTables = {
    'branches', 'users', 'permissions', 'customers', 'suppliers',
    'supplier_customers', 'medicines', 'sales', 'purchases', 'inventory',
    'cashier_shifts', 'quotes', 'stock_transfers',
  };

  Future<bool> _pushSingleItem({
    required String operation,
    required String table,
    required Map<String, dynamic> data,
    required String recordId,
  }) async {
    final payload = Map<String, dynamic>.from(data);

    try {
      switch (operation) {
        case 'update':
          // درع التضارب: قبل الرفع، نتأكد إن النسخة المحلية أحدث من الـ server
          if (_versionedTables.contains(table) && payload.containsKey('sync_version')) {
            final localVersion = (payload['sync_version'] as num?)?.toInt() ?? 0;
            final serverVersion = await _getServerVersion(table, recordId);
            if (serverVersion > localVersion) {
              safeDebugPrint(
                'SyncPushService: Conflict shield — skipping $table/$recordId '
                '(server v$serverVersion > local v$localVersion)',
              );
              return false;
            }
          }
          await _supabase.from(table).upsert(payload);
          return true;
        case 'create':
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
    } on PostgrestException catch (e) {
      safeDebugPrint('SyncPushService: Supabase Error for table "$table" ($operation): ${e.message} (Code: ${e.code})');
      // إعادة رمي الخطأ ليتم معالجته في processPushQueue وتسجيله في الـ Outbox
      rethrow;
    } catch (e) {
      safeDebugPrint('SyncPushService: Unexpected Error for table "$table": $e');
      rethrow;
    }
  }

  /// استعلام sync_version من الـ server لفحص التضارب
  Future<int> _getServerVersion(String table, String recordId) async {
    try {
      final response = await _supabase
          .from(table)
          .select('sync_version')
          .eq('id', recordId)
          .maybeSingle()
          .timeout(const Duration(seconds: 5));
      if (response == null) return 0;
      return (response['sync_version'] as num?)?.toInt() ?? 0;
    } catch (e) {
      safeDebugPrint('SyncPushService: Version check failed for $table/$recordId: $e');
      return 0; // لو فشل الاستعلام، نكمل الرفع عادي
    }
  }
}
