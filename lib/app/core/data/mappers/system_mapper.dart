import 'dart:convert';
import 'package:drift/drift.dart';

import '../database/database.dart';
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
  static BranchModel branchFromData(BranchesTableData d) => BranchModel(
    id: d.id,
    name: d.name,
    code: d.code,
    isMainBranch: d.isMainBranch,
    accountId: d.accountId,
    address: d.address,
    phone: d.phone,
    isActive: d.isActive,
    createdAt: d.createdAt,
    syncVersion: d.syncVersion,
    lastModified: d.lastModified,
    isDeleted: d.isDeleted,
  );

  static BranchesTableCompanion branchToCompanion(BranchModel m) => BranchesTableCompanion(
    id: Value(m.id),
    name: Value(m.name),
    code: Value(m.code),
    isMainBranch: Value(m.isMainBranch),
    address: Value(m.address),
    phone: Value(m.phone),
    isActive: Value(m.isActive),
    accountId: Value(m.accountId),
    createdAt: Value(m.createdAt),
    lastModified: Value(m.lastModified),
    isDeleted: Value(m.isDeleted),
    syncVersion: Value(m.syncVersion),
  );

  // ── Permission ──
  static PermissionModel permissionFromData(PermissionsTableData d) => PermissionModel(
    id: d.id,
    userId: d.userId,
    permissionKey: d.permissionKey,
    isAllowed: d.isAllowed,
    accountId: d.accountId,
    createdAt: d.createdAt,
    syncVersion: d.syncVersion,
    lastModified: d.lastModified,
    isDeleted: d.isDeleted,
  );

  static PermissionsTableCompanion permissionToCompanion(PermissionModel m) => PermissionsTableCompanion(
    id: Value(m.id),
    userId: Value(m.userId),
    permissionKey: Value(m.permissionKey),
    isAllowed: Value(m.isAllowed),
    accountId: Value(m.accountId),
    createdAt: Value(m.createdAt),
    lastModified: Value(m.lastModified),
    isDeleted: Value(m.isDeleted),
    syncVersion: Value(m.syncVersion),
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

  // ── AuditLog ──
  static AuditLogModel auditLogFromData(AuditLogsTableData d) {
    Map<String, dynamic>? summary;
    String entityType = '';
    String entityId = '';
    try {
      final details = jsonDecode(d.actionDetails) as Map<String, dynamic>;
      summary = details['summary'] as Map<String, dynamic>?;
      entityType = details['entity_type'] as String? ?? '';
      entityId = details['entity_id'] as String? ?? '';
    } catch (_) {}

    return AuditLogModel(
      id: d.id,
      action: d.actionType,
      entityType: entityType,
      entityId: entityId,
      actorId: d.performedById,
      actorName: d.performedByName,
      branchId: d.branchId,
      summary: summary,
      occurredAt: d.createdAt,
    );
  }

  static AuditLogsTableCompanion auditLogToCompanion(AuditLogModel m) {
    final details = {
      'entity_type': m.entityType,
      'entity_id': m.entityId,
      'summary': m.summary,
    };
    return AuditLogsTableCompanion(
      id: Value(m.id),
      actionType: Value(m.action),
      actionDetails: Value(jsonEncode(details)),
      performedById: Value(m.actorId),
      performedByName: Value(m.actorName ?? ''),
      branchId: Value(m.branchId ?? ''),
      accountId: const Value.absent(),
      createdAt: Value(m.occurredAt),
    );
  }

  // ── Notification ──
  static AppNotificationModel notificationFromData(NotificationsTableData d) => AppNotificationModel(
    id: d.id,
    title: d.title,
    message: d.message,
    type: NotificationType.values.firstWhere(
      (t) => t.name == d.type,
      orElse: () => NotificationType.systemAlert,
    ),
    targetRoute: d.targetRoute,
    isRead: d.isRead,
    accountId: d.accountId,
    branchId: d.branchId,
    createdAt: d.createdAt,
  );

  static NotificationsTableCompanion notificationToCompanion(AppNotificationModel m) => NotificationsTableCompanion(
    id: Value(m.id),
    title: Value(m.title),
    message: Value(m.message),
    type: Value(m.type.name),
    targetRoute: Value(m.targetRoute),
    isRead: Value(m.isRead),
    accountId: Value(m.accountId),
    branchId: Value(m.branchId),
    createdAt: Value(m.createdAt),
  );

  // ── Lookup ──
  static LookupModel lookupFromData(LookupsTableData d) => LookupModel(
    id: d.id,
    name: d.name,
    type: d.type,
    isActive: d.isActive,
    branchId: d.branchId,
    syncVersion: d.syncVersion,
    lastModified: d.lastModified,
    isDeleted: d.isDeleted,
  );

  static LookupsTableCompanion lookupToCompanion(LookupModel m) => LookupsTableCompanion(
    id: Value(m.id),
    name: Value(m.name),
    type: Value(m.type),
    isActive: Value(m.isActive),
    branchId: Value(m.branchId),
    syncVersion: Value(m.syncVersion),
    lastModified: Value(m.lastModified),
    isDeleted: Value(m.isDeleted),
  );

  // ── ErrorLog ──
  static ErrorLogModel errorLogFromData(ErrorLogsTableData d) => ErrorLogModel(
    id: d.id,
    title: d.title,
    message: d.message,
    source: d.source,
    stackTrace: d.stackTrace,
    severity: ErrorSeverity.values.firstWhere(
      (s) => s.name == d.severity,
      orElse: () => ErrorSeverity.warning,
    ),
    createdAt: d.createdAt,
    isRead: d.isRead,
  );

  static ErrorLogsTableCompanion errorLogToCompanion(ErrorLogModel m) => ErrorLogsTableCompanion(
    id: Value(m.id),
    title: Value(m.title),
    message: Value(m.message),
    source: Value(m.source),
    stackTrace: Value(m.stackTrace),
    severity: Value(m.severity.name),
    createdAt: Value(m.createdAt),
    isRead: Value(m.isRead),
  );

  // ── Correction ──
  static CorrectionEntry correctionFromData(CorrectionsTableData d) => CorrectionEntry(
    id: d.id,
    referenceType: CorrectionReferenceType.values.firstWhere(
      (t) => t.name == d.referenceType,
      orElse: () => CorrectionReferenceType.sale,
    ),
    referenceId: d.referenceId,
    action: CorrectionAction.values.firstWhere(
      (a) => a.name == d.action,
      orElse: () => CorrectionAction.modified,
    ),
    userId: d.userId,
    userDisplayName: d.userDisplayName,
    timestamp: d.timestamp,
    details: d.details,
  );

  static CorrectionsTableCompanion correctionToCompanion(CorrectionEntry m) => CorrectionsTableCompanion(
    id: Value(m.id),
    referenceType: Value(m.referenceType.name),
    referenceId: Value(m.referenceId),
    action: Value(m.action.name),
    userId: Value(m.userId),
    userDisplayName: Value(m.userDisplayName),
    timestamp: Value(m.timestamp),
    details: Value(m.details),
  );
}
