import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/system_tables.dart';

part 'system_dao.g.dart';

/// ⚙️ كائن الاستعلامات والتنفيذ المباشر لإعدادات المنظومة والأرشيف والتنبيهات والمستخدمين
@DriftAccessor(tables: [
  UsersTable,
  BranchesTable,
  PermissionsTable,
  AppSettingsTable,
  ArchiveRecordsTable,
  AuditLogsTable,
  NotificationsTable,
  CorrectionsTable,
])
class SystemDao extends DatabaseAccessor<AppDatabase> with _$SystemDaoMixin {
  SystemDao(super.db);

  // ... (previous methods)

  // ─── 5. سجل التصحيحات (Corrections) ───
  Future<void> insertCorrection(CorrectionsTableCompanion correction) async {
    await into(correctionsTable).insert(correction);
  }

  Future<List<CorrectionsTableData>> getCorrectionsByReference(
    String type,
    String id,
  ) =>
      (select(correctionsTable)
            ..where((t) => t.referenceType.equals(type) & t.referenceId.equals(id))
            ..orderBy([(t) => OrderingTerm.desc(t.timestamp)]))
          .get();

  Future<List<CorrectionsTableData>> getAllCorrections({int limit = 100}) =>
      (select(correctionsTable)
            ..orderBy([(t) => OrderingTerm.desc(t.timestamp)])
            ..limit(limit))
          .get();
}

  // ─── 1. المستخدمين والفروع الصريحة ───
  Future<List<UsersTableData>> getAllUsers() =>
      (select(usersTable)..where((t) => t.isDeleted.not())).get();

  Future<UsersTableData?> getUserById(String id) =>
      (select(usersTable)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> upsertUser(UsersTableCompanion user) async {
    await into(usersTable).insertOnConflictUpdate(user);
  }

  Future<List<BranchesTableData>> getAllBranches() =>
      (select(branchesTable)..where((t) => t.isDeleted.not())).get();

  Future<BranchesTableData?> getBranchById(String id) =>
      (select(branchesTable)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> upsertBranch(BranchesTableCompanion branch) async {
    await into(branchesTable).insertOnConflictUpdate(branch);
  }

  // ─── 2. إعدادات المنظومة والأرشيف سلة المهملات الموحدة ───
  Future<AppSettingsTableData?> getSettings() =>
      select(appSettingsTable).getSingleOrNull();

  Future<void> upsertSettings(AppSettingsTableCompanion settings) async {
    await into(appSettingsTable).insertOnConflictUpdate(settings);
  }

  Future<List<ArchiveRecordsTableData>> getAllArchiveRecords() =>
      (select(archiveRecordsTable)..orderBy([(t) => OrderingTerm.desc(t.deletedAt)])).get();

  Future<void> insertArchiveRecord(ArchiveRecordsTableCompanion record) async {
    await into(archiveRecordsTable).insertOnConflictUpdate(record);
  }

  // ─── 3. المراقبة والتدقيق Audit Log والإشعارات ───
  Future<List<AuditLogsTableData>> getAuditLogs() =>
      (select(auditLogsTable)..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).get();

  Future<void> insertAuditLog(AuditLogsTableCompanion log) async {
    await into(auditLogsTable).insertOnConflictUpdate(log);
  }

  Future<List<NotificationsTableData>> getUnreadNotifications() =>
      (select(notificationsTable)
            ..where((t) => t.isRead.equals(false))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

  Future<void> insertNotification(NotificationsTableCompanion notification) async {
    await into(notificationsTable).insertOnConflictUpdate(notification);
  }

  // ─── 4. الصلاحيات ───
  Future<List<PermissionsTableData>> getPermissionsByUser(String userId) =>
      (select(permissionsTable)..where((t) => t.userId.equals(userId))).get();

  Future<void> upsertPermission(PermissionsTableCompanion permission) async {
    await into(permissionsTable).insertOnConflictUpdate(permission);
  }
}
