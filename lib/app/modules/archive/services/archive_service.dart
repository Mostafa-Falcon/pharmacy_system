import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/core/data/database/daos/archive_records_dao.dart';
import 'package:pharmacy_system/app/core/data/database/daos/medicines_dao.dart';
import 'package:pharmacy_system/app/core/data/database/daos/customers_dao.dart';
import 'package:pharmacy_system/app/core/data/database/daos/suppliers_dao.dart';
import 'package:pharmacy_system/app/core/data/database/daos/supplier_customers_dao.dart';
import 'package:pharmacy_system/app/core/data/database/daos/customer_groups_dao.dart';
import '../../../core/injection.dart';
import 'package:pharmacy_system/app/modules/archive/models/archive_record_model.dart';
import 'package:pharmacy_system/app/core/data/services/sync/sync_service.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import '../../../core/utils/app_utils.dart';

class ArchiveService {
  static ArchiveRecordsDao get _dao => sl<ArchiveRecordsDao>();
  static MedicinesDao get _medicinesDao => sl<MedicinesDao>();
  static CustomersDao get _customersDao => sl<CustomersDao>();
  static SuppliersDao get _suppliersDao => sl<SuppliersDao>();
  static SupplierCustomersDao get _supplierCustomersDao => sl<SupplierCustomersDao>();
  static CustomerGroupsDao get _customerGroupsDao => sl<CustomerGroupsDao>();

  static Future<void> record({
    required String entityType,
    required String entityId,
    required String entityName,
    required Map<String, dynamic> entityData,
    String? deletedBy,
    String? deletedByName,
    String? branchId,
  }) async {
    try {
      final id = _uuid();
      final now = DateTime.now();
      final record = ArchiveRecordsCompanion(
        id: Value(id),
        entityType: Value(entityType),
        entityId: Value(entityId),
        entityTitle: Value(entityName),
        entityData: Value(jsonEncode(entityData)),
        deletedBy: Value(deletedBy ?? AuthService.currentUser?.id ?? ''),
        deletedByName: Value(deletedByName ?? AuthService.currentUser?.name ?? ''),
        deletedAt: Value(now),
        branchId: Value(branchId ?? AuthService.currentBranchId ?? ''),
        syncVersion: const Value(1),
        lastModified: Value(now),
      );

      safeDebugPrint('ArchiveService.record: saving $entityType $entityId');
      await _dao.upsert(record);
      await SyncService.queueOperation(
        type: SyncOperationType.create,
        table: 'archive_records',
        data: _archiveRecordToJson(record),
        branchId: branchId ?? AuthService.currentBranchId ?? '',
      );
      safeDebugPrint('ArchiveService.record: saved $entityType $entityId');
    } catch (e, s) {
      safeDebugPrint('ArchiveService.record failed: $e\n$s');
    }
  }

  static Future<List<ArchiveRecordModel>> getAll({
    String? entityType,
    bool activeOnly = true,
    int page = 1,
    int pageSize = 50,
  }) async {
    List<ArchiveRecord> items;
    if (entityType != null) {
      items = await _dao.getByEntityType(entityType);
    } else {
      items = await _dao.getAll();
    }

    safeDebugPrint('ArchiveService.getAll: total items = ${items.length}');

    if (activeOnly) {
      items = items.where((r) => r.restoredAt == null && r.permanentlyDeletedAt == null).toList();
    }

    items.sort((a, b) => b.deletedAt.compareTo(a.deletedAt));

    final start = (page - 1) * pageSize;
    if (start >= items.length) return [];
    final end = start + pageSize;
    return items.sublist(start, end > items.length ? items.length : end).map(_toModel).toList();
  }

  static Future<int> count({
    String? entityType,
    bool activeOnly = true,
  }) async {
    List<ArchiveRecord> items;
    if (entityType != null) {
      items = await _dao.getByEntityType(entityType);
    } else {
      items = await _dao.getAll();
    }

    if (activeOnly) {
      items = items.where((r) => r.restoredAt == null && r.permanentlyDeletedAt == null).toList();
    }

    return items.length;
  }

  static Future<List<ArchiveRecordModel>> search({
    required String query,
    String? entityType,
    bool activeOnly = true,
    int page = 1,
    int pageSize = 50,
  }) async {
    final q = query.toLowerCase().trim();
    if (q.isEmpty) {
      return getAll(entityType: entityType, activeOnly: activeOnly, page: page, pageSize: pageSize);
    }

    List<ArchiveRecord> items;
    if (entityType != null) {
      items = await _dao.getByEntityType(entityType);
    } else {
      items = await _dao.getAll();
    }

    if (activeOnly) {
      items = items.where((r) => r.restoredAt == null && r.permanentlyDeletedAt == null).toList();
    }

    items = items.where((r) =>
      r.entityTitle.toLowerCase().contains(q) ||
      r.deletedByName.toLowerCase().contains(q) ||
      r.entityId.toLowerCase().contains(q)
    ).toList();

    items.sort((a, b) => b.deletedAt.compareTo(a.deletedAt));

    final start = (page - 1) * pageSize;
    if (start >= items.length) return [];
    final end = start + pageSize;
    return items.sublist(start, end > items.length ? items.length : end).map(_toModel).toList();
  }

  static Future<int> searchCount({
    required String query,
    String? entityType,
    bool activeOnly = true,
  }) async {
    final q = query.toLowerCase().trim();
    if (q.isEmpty) return count(entityType: entityType, activeOnly: activeOnly);

    List<ArchiveRecord> items;
    if (entityType != null) {
      items = await _dao.getByEntityType(entityType);
    } else {
      items = await _dao.getAll();
    }

    if (activeOnly) {
      items = items.where((r) => r.restoredAt == null && r.permanentlyDeletedAt == null).toList();
    }

    return items.where((r) =>
      r.entityTitle.toLowerCase().contains(q) ||
      r.deletedByName.toLowerCase().contains(q) ||
      r.entityId.toLowerCase().contains(q)
    ).length;
  }

  static Future<ArchiveRecordModel?> getById(String id) async {
    final data = await _dao.getById(id);
    return data != null ? _toModel(data) : null;
  }

  static Future<bool> restore(String recordId, {Map<String, dynamic>? modifiedData}) async {
    try {
      final record = await _dao.getById(recordId);
      if (record == null || (record.restoredAt != null || record.permanentlyDeletedAt != null)) return false;

      final now = DateTime.now().toIso8601String();
      
      // 1. Update Archive Table
      await _dao.upsert(ArchiveRecordsCompanion(
        id: Value(recordId),
        restoredAt: Value(now),
        restoredBy: Value(AuthService.currentUser?.id ?? ''),
        syncVersion: Value(record.syncVersion + 1),
        lastModified: Value(DateTime.now()),
      ));

      // 2. Determine target table and restore in local DB
      String? targetTable;
      switch (record.entityType) {
        case 'medicine':
          targetTable = 'medicines';
          await _medicinesDao.restore(record.entityId);
          break;
        case 'customer':
          targetTable = 'customers';
          await _customersDao.restore(record.entityId);
          break;
        case 'supplier':
          targetTable = 'suppliers';
          await _suppliersDao.restore(record.entityId);
          break;
        case 'supplier_customer':
          targetTable = 'supplier_customers';
          await _supplierCustomersDao.restore(record.entityId);
          break;
        case 'customer_group':
          targetTable = 'customer_groups';
          await _customerGroupsDao.restore(record.entityId);
          break;
      }

      // 3. Sync Archive record to Supabase
      await SyncService.queueOperation(
        type: SyncOperationType.update,
        table: 'archive_records',
        data: _archiveRecordToJson(ArchiveRecordsCompanion(
          id: Value(recordId),
          entityType: Value(record.entityType),
          entityId: Value(record.entityId),
          entityTitle: Value(record.entityTitle),
          entityData: Value(record.entityData),
          deletedBy: Value(record.deletedBy),
          deletedByName: Value(record.deletedByName),
          deletedAt: Value(record.deletedAt),
          branchId: Value(record.branchId),
          restoredAt: Value(now),
          restoredBy: Value(AuthService.currentUser?.id ?? ''),
          syncVersion: Value(record.syncVersion + 1),
          lastModified: Value(DateTime.now()),
        )),
        branchId: record.branchId,
      );

      // 4. Sync Restore operation to target table in Supabase
      if (targetTable != null) {
        final data = _parseEntityData(record.entityData);
        data['is_deleted'] = false;
        data['last_modified'] = DateTime.now().toIso8601String();
        await SyncService.queueOperation(
          type: SyncOperationType.update,
          table: targetTable,
          data: data,
          branchId: record.branchId,
        );
        // Notify UI
        SyncService.onTableUpdated?.call(targetTable, record.branchId);
      }

      return true;
    } catch (e, s) {
      safeDebugPrint('ArchiveService.restore failed: $e\n$s');
      return false;
    }
  }

  static Future<bool> permanentDelete(String recordId) async {
    try {
      final record = await _dao.getById(recordId);
      if (record == null || (record.restoredAt != null || record.permanentlyDeletedAt != null)) return false;

      // 1. Update Archive Table (Mark as permanently deleted)
      await _dao.upsert(ArchiveRecordsCompanion(
        id: Value(recordId),
        permanentlyDeletedAt: Value(DateTime.now().toIso8601String()),
        syncVersion: Value(record.syncVersion + 1),
        lastModified: Value(DateTime.now()),
      ));

      // 2. Determine target table and delete from local DB
      String? targetTable;
      switch (record.entityType) {
        case 'medicine':
          targetTable = 'medicines';
          await _medicinesDao.hardDelete(record.entityId);
          break;
        case 'customer':
          targetTable = 'customers';
          await _customersDao.hardDelete(record.entityId);
          break;
        case 'supplier':
          targetTable = 'suppliers';
          await _suppliersDao.hardDelete(record.entityId);
          break;
        case 'supplier_customer':
          targetTable = 'supplier_customers';
          await _supplierCustomersDao.hardDelete(record.entityId);
          break;
        case 'customer_group':
          targetTable = 'customer_groups';
          await _customerGroupsDao.hardDelete(record.entityId);
          break;
      }

      // 3. Sync Archive record to Supabase
      await SyncService.queueOperation(
        type: SyncOperationType.update,
        table: 'archive_records',
        data: _archiveRecordToJson(ArchiveRecordsCompanion(
          id: Value(recordId),
          entityType: Value(record.entityType),
          entityId: Value(record.entityId),
          entityTitle: Value(record.entityTitle),
          entityData: Value(record.entityData),
          deletedBy: Value(record.deletedBy),
          deletedByName: Value(record.deletedByName),
          deletedAt: Value(record.deletedAt),
          branchId: Value(record.branchId),
          permanentlyDeletedAt: Value(DateTime.now().toIso8601String()),
          syncVersion: Value(record.syncVersion + 1),
          lastModified: Value(DateTime.now()),
        )),
        branchId: record.branchId,
      );

      // 4. Sync Permanent Delete to target table in Supabase
      if (targetTable != null) {
        await SyncService.queueOperation(
          type: SyncOperationType.delete,
          table: targetTable,
          data: {'id': record.entityId},
          branchId: record.branchId,
          recordId: record.entityId,
        );
        // Notify UI
        SyncService.onTableUpdated?.call(targetTable, record.branchId);
      }

      return true;
    } catch (e, s) {
      safeDebugPrint('ArchiveService.permanentDelete failed: $e\n$s');
      return false;
    }
  }

  // ─── Converters ───

  static ArchiveRecordModel _toModel(ArchiveRecord d) {
    return ArchiveRecordModel(
      id: d.id,
      entityType: archiveEntityTypeFromString(d.entityType) ?? ArchiveEntityType.medicine,
      entityId: d.entityId,
      entityName: d.entityTitle,
      entityData: _parseEntityData(d.entityData),
      deletedBy: d.deletedBy,
      deletedByName: d.deletedByName,
      deletedAt: d.deletedAt,
      branchId: d.branchId,
      restoredAt: d.restoredAt,
      restoredBy: d.restoredBy,
      permanentlyDeletedAt: d.permanentlyDeletedAt,
      syncVersion: d.syncVersion,
      lastModified: d.lastModified,
    );
  }

  static Map<String, dynamic> _parseEntityData(String raw) {
    if (raw.isEmpty) return {};
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
    } catch (_) {}
    return {};
  }

  static Map<String, dynamic> _archiveRecordToJson(ArchiveRecordsCompanion c) {
    return {
      'id': c.id.value,
      'entity_type': c.entityType.value,
      'entity_id': c.entityId.value,
      'entity_name': c.entityTitle.value,
      'entity_data': c.entityData.value,
      'deleted_by': c.deletedBy.value,
      'deleted_by_name': c.deletedByName.value,
      'deleted_at': c.deletedAt.value.toIso8601String(),
      'branch_id': c.branchId.value,
      'sync_version': c.syncVersion.value,
      'last_modified': c.lastModified.value.toIso8601String(),
    };
  }

  static String _uuid() {
    final now = DateTime.now();
    return '${now.microsecondsSinceEpoch}_${now.millisecondsSinceEpoch}';
  }
}

