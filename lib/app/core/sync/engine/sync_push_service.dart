import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:pharmacy_system/app/core/data/database/daos/sync_dao.dart';
import 'package:pharmacy_system/app/shared/ui_core.dart';

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
        onItemProcessed?.call(item.targetTable, false, true);

        final data = Map<String, dynamic>.from(
          jsonDecode(item.payloadJson) as Map,
        );
        
        // التحقق من الجداول العالمية
        const globalTables = {
          'branches', 'users', 'permissions',
          'item_categories', 'medicine_brands', 'item_variants',
          'item_warranties', 'price_groups', 'barcode_settings',
          'customer_groups', 'account_tree', 'expense_categories', 
          'app_settings',
        };

        if (!globalTables.contains(item.targetTable)) {
          if (data['branch_id'] == null && item.branchId.isNotEmpty) {
            data['branch_id'] = item.branchId;
          }
        }

        final success = await _pushSingleItem(
          operation: item.operationType,
          table: item.targetTable,
          data: data,
          recordId: item.id,
        );
        
        if (success) {
          await _syncDao.markSynced(item.id);
          successCount++;
          onItemProcessed?.call(item.targetTable, true, false);
        } else {
          // في حالة الفشل (أو التعارض)، يتم إرسالها لـ Dead Letter
          final shouldKeep = await onFailedItem({...data, 'outbox_id': item.id});
          if (!shouldKeep) {
            await _syncDao.markSynced(item.id);
          }
          onItemProcessed?.call(item.targetTable, false, false);
        }
      } catch (e) {
        final errorMsg = e is PostgrestException ? '${e.message} (Code: ${e.code})' : e.toString();
        safeDebugPrint('SyncPushService: Error pushing ${item.targetTable}/${item.id}: $errorMsg');
        
        await _syncDao.markFailed(item.id, errorMsg);

        final data = Map<String, dynamic>.from(jsonDecode(item.payloadJson) as Map);
        data['table'] = item.targetTable;
        data['operation'] = item.operationType;
        data['outbox_id'] = item.id;

        final shouldKeep = await onFailedItem(data);
        if (!shouldKeep) {
          await _syncDao.markSynced(item.id);
        }
        onItemProcessed?.call(item.targetTable, false, false);
      }
    }
    return successCount;
  }

  // الجداول التي تحتوي على إصدار مزامنة للحماية من التعارض
  static const _versionedTables = {
    'medicines', 'item_batches', 'item_categories', 'customers', 'suppliers',
    'supplier_customers', 'contact_ledger', 'customer_groups',
    'sale_invoices', 'purchase_invoices', 'account_tree', 'archive_records',
    'inventory_transactions', 'attendance', 'payroll', 'employee_messages',
    'stocktaking', 'stock_adjustments', 'item_swaps', 'opening_stock',
    'users', 'permissions', 'branches',
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
          // Conflict Shield: منع الكتابة فوق بيانات أحدث على السيرفر
          if (_versionedTables.contains(table) && payload.containsKey('sync_version')) {
            final localVersion = (payload['sync_version'] as num?)?.toInt() ?? 0;
            final serverVersion = await _getServerVersion(table, recordId);
            if (serverVersion > localVersion) {
              safeDebugPrint(
                'SyncPushService: Conflict Shield! Skipping $table/$recordId '
                '(Server v$serverVersion > Local v$localVersion)',
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
          // الحذف هنا منطقي (Soft Delete) لأن الموديلات ترسل is_deleted = true
          if (payload.containsKey('is_deleted') && payload['is_deleted'] == true) {
             await _supabase.from(table).upsert(payload);
          } else {
             await _supabase.from(table).delete().eq('id', recordId);
          }
          return true;
        default:
          safeDebugPrint('SyncPushService: Unknown operation type "$operation"');
          return false;
      }
    } on PostgrestException catch (e) {
      safeDebugPrint('SyncPushService: Supabase Error for table "$table" ($operation): ${e.message} (Code: ${e.code})');
      rethrow;
    } catch (e) {
      safeDebugPrint('SyncPushService: Unexpected Error for table "$table": $e');
      rethrow;
    }
  }

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
      return 0; 
    }
  }
}
