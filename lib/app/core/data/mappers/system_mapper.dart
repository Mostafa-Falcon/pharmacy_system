import 'dart:convert';
import 'package:drift/drift.dart';

import '../database/database.dart';
import 'base_mapper.dart';
import 'package:pharmacy_system/app/core/models/auth/user_model.dart';
import 'package:pharmacy_system/app/core/models/auth/branch_model.dart';
import 'package:pharmacy_system/app/core/models/auth/permission_model.dart';
import 'package:pharmacy_system/app/core/models/system/app_settings_model.dart';
import 'package:pharmacy_system/app/core/models/system/archive_record_model.dart';
import 'package:pharmacy_system/app/core/models/system/audit_log_model.dart';
import 'package:pharmacy_system/app/core/models/system/app_notification_model.dart';
import 'package:pharmacy_system/app/core/models/system/sync_outbox_model.dart';
import 'package:pharmacy_system/app/core/models/system/sync_state_model.dart';
import 'package:pharmacy_system/app/core/models/system/receipt_counter_model.dart';
import 'package:pharmacy_system/app/core/models/base/lookup_model.dart';
import 'package:pharmacy_system/app/core/models/base/error_log_model.dart';
import 'package:pharmacy_system/app/core/models/base/correction_model.dart';

class SystemMapper {
  // ── User ──
  static UserModel userFromData(UsersTableData d) => UserModel.fromJson({
    'id': d.id,
    'name': d.name,
    'email': d.email,
    'role': d.role,
    'assigned_branch_id': d.assignedBranchId,
    'account_id': d.accountId,
    'is_active': d.isActive,
    'created_at': d.createdAt.toIso8601String(),
    'last_login': d.lastLogin?.toIso8601String(),
    'active_device_id': d.activeDeviceId,
    'sync_version': d.syncVersion,
    'last_modified': d.lastModified.toIso8601String(),
    'is_deleted': d.isDeleted,
  });

  static UsersTableCompanion userToCompanion(UserModel m) => UsersTableCompanion(
    id: Value(m.id),
    name: Value(m.name),
    email: Value(m.email),
    role: Value(m.role.name),
    assignedBranchId: Value(m.assignedBranchId),
    accountId: Value(m.accountId),
    isActive: Value(m.isActive),
    createdAt: Value(m.createdAt),
    lastLogin: Value(m.lastLogin),
    activeDeviceId: Value(m.activeDeviceId),
    syncVersion: Value(m.syncVersion),
    lastModified: Value(m.lastModified),
    isDeleted: Value(m.isDeleted),
  );

  // ── Branch ──
  static BranchModel branchFromData(BranchesTableData d) => BranchModel.fromJson({
    'id': d.id,
    'name': d.name,
    'account_id': d.accountId,
    'address': d.address,
    'phone': d.phone,
    'is_active': d.isActive,
    'created_at': d.lastModified.toIso8601String(), // Placeholder
    'sync_version': 1,
    'last_modified': d.lastModified.toIso8601String(),
    'is_deleted': d.isDeleted,
  });

  static BranchesTableCompanion branchToCompanion(BranchModel m) => BranchesTableCompanion(
    id: Value(m.id),
    name: Value(m.name),
    address: Value(m.address),
    phone: Value(m.phone),
    isActive: Value(m.isActive),
    accountId: Value(m.accountId),
    lastModified: Value(m.lastModified),
    isDeleted: Value(m.isDeleted),
  );

  // ── Permission ──
  static PermissionModel permissionFromData(PermissionsTableData d) => PermissionModel.fromJson({
    'id': d.id,
    'user_id': d.userId,
    'permission_key': d.permissionKey,
    'is_allowed': d.isAllowed,
    'account_id': d.accountId,
    'sync_version': 1,
    'last_modified': d.lastModified.toIso8601String(),
    'is_deleted': false,
  });

  static PermissionsTableCompanion permissionToCompanion(PermissionModel m) => PermissionsTableCompanion(
    id: Value(m.id),
    userId: Value(m.userId),
    permissionKey: Value(m.permissionKey),
    isAllowed: Value(m.isAllowed),
    accountId: Value(m.accountId),
    lastModified: Value(m.lastModified),
  );

  // ── AppSettings ──
  static AppSettingsModel settingsFromData(AppSettingsTableData d) => AppSettingsModel(
    pharmacyName: d.pharmacyName,
    pharmacyNameEn: d.pharmacyNameEn ?? 'My Pharmacy',
    currency: d.currency,
    taxNumber: d.taxNumber,
    commercialRegister: d.commercialRegister,
    logoUrl: d.logoUrl,
    address: d.pharmacyAddress,
    phone: d.pharmacyPhone,
    email: d.email,
    defaultLowStockThreshold: d.defaultLowStockThreshold,
    nearExpiryAlertDays: d.nearExpiryAlertDays,
    autoOpenCashDrawer: d.enablePOSDrawer,
    autoPrintReceipt: d.enableAutomaticPrint,
    accountId: d.accountId,
    lastModified: d.lastModified,
  );

  static AppSettingsTableCompanion settingsToCompanion(AppSettingsModel m) => AppSettingsTableCompanion(
    id: const Value('default'),
    pharmacyName: Value(m.pharmacyName),
    pharmacyPhone: Value(m.phone),
    pharmacyAddress: Value(m.address),
    taxNumber: Value(m.taxNumber),
    currency: Value(m.currency),
    enableAutomaticPrint: Value(m.autoPrintReceipt),
    enablePOSDrawer: Value(m.autoOpenCashDrawer),
    pharmacyNameEn: Value(m.pharmacyNameEn),
    commercialRegister: Value(m.commercialRegister),
    logoUrl: Value(m.logoUrl),
    email: Value(m.email),
    defaultLowStockThreshold: Value(m.defaultLowStockThreshold),
    nearExpiryAlertDays: Value(m.nearExpiryAlertDays),
    accountId: Value(m.accountId),
    lastModified: Value(m.lastModified),
  );

  // ── ArchiveRecord ──
  static ArchiveRecordModel archiveFromData(ArchiveRecordsTableData d) => ArchiveRecordModel(
    id: d.id,
    entityType: ArchiveEntityType.values.firstWhere(
      (e) => e.name == d.entityType,
      orElse: () => ArchiveEntityType.medicine,
    ),
    entityId: d.entityId,
    entityName: d.entityTitle,
    entityData: Map<String, dynamic>.from(jsonDecode(d.entityDataJson) as Map),
    deletedBy: d.deletedById,
    deletedByName: d.deletedByName,
    deletedAt: d.deletedAt,
    branchId: d.branchId,
    accountId: d.accountId,
    restoredAt: d.restoredAt,
    restoredBy: d.restoredBy,
    permanentlyDeletedAt: d.permanentlyDeletedAt,
    syncVersion: d.syncVersion,
  );

  static ArchiveRecordsTableCompanion archiveToCompanion(ArchiveRecordModel m) => ArchiveRecordsTableCompanion(
    id: Value(m.id),
    entityType: Value(m.entityType.name),
    entityId: Value(m.entityId),
    entityTitle: Value(m.entityName),
    entityDataJson: Value(jsonEncode(m.entityData)),
    deletedById: Value(m.deletedBy),
    deletedByName: Value(m.deletedByName),
    deletedAt: Value(m.deletedAt),
    branchId: Value(m.branchId),
    accountId: Value(m.accountId),
    restoredAt: Value(m.restoredAt),
    restoredBy: Value(m.restoredBy),
    permanentlyDeletedAt: Value(m.permanentlyDeletedAt),
    syncVersion: Value(m.syncVersion),
  );

  // ── SyncOutbox ──
  static SyncOutboxModel syncOutboxFromData(SyncOutboxTableData d) => SyncOutboxModel(
    id: d.id,
    operationType: d.operationType,
    targetTable: d.targetTable,
    payloadJson: d.payloadJson,
    retryCount: d.retryCount,
    status: d.status,
    errorMessage: d.errorMessage,
    branchId: d.branchId,
    accountId: d.accountId,
    createdAt: d.createdAt,
  );

  static SyncOutboxTableCompanion syncOutboxToCompanion(SyncOutboxModel m) => SyncOutboxTableCompanion(
    id: Value(m.id),
    operationType: Value(m.operationType),
    targetTable: Value(m.targetTable),
    payloadJson: Value(m.payloadJson),
    retryCount: Value(m.retryCount),
    status: Value(m.status),
    errorMessage: Value(m.errorMessage),
    branchId: Value(m.branchId),
    accountId: Value(m.accountId),
    createdAt: Value(m.createdAt),
  );

  // ── SyncState ──
  static SyncStateModel syncStateFromData(SyncStateTableData d) => SyncStateModel(
    id: d.id,
    targetTable: d.targetTable,
    lastSyncedAt: d.lastSyncedAt,
    lastSyncedVersion: d.lastSyncedVersion,
    branchId: d.branchId,
  );

  static SyncStateTableCompanion syncStateToCompanion(SyncStateModel m) => SyncStateTableCompanion(
    id: Value(m.id),
    targetTable: Value(m.targetTable),
    lastSyncedAt: Value(m.lastSyncedAt),
    lastSyncedVersion: Value(m.lastSyncedVersion),
    branchId: Value(m.branchId),
  );

  // ── ReceiptCounter ──
  static ReceiptCounterModel receiptCounterFromData(ReceiptCountersTableData d) => ReceiptCounterModel(
    id: d.id,
    counterType: d.counterType,
    lastNumber: d.lastNumber,
    prefix: d.prefix,
    branchId: d.branchId,
    lastModified: d.lastModified,
    syncVersion: d.syncVersion,
    isDeleted: d.isDeleted,
  );

  static ReceiptCountersTableCompanion receiptCounterToCompanion(ReceiptCounterModel m) => ReceiptCountersTableCompanion(
    id: Value(m.id),
    counterType: Value(m.counterType),
    lastNumber: Value(m.lastNumber),
    prefix: Value(m.prefix),
    branchId: Value(m.branchId),
    lastModified: Value(m.lastModified),
    syncVersion: Value(m.syncVersion),
    isDeleted: Value(m.isDeleted),
  );
}
