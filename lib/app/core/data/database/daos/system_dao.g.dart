// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_dao.dart';

// ignore_for_file: type=lint
mixin _$SystemDaoMixin on DatabaseAccessor<AppDatabase> {
  $UsersTableTable get usersTable => attachedDatabase.usersTable;
  $BranchesTableTable get branchesTable => attachedDatabase.branchesTable;
  $PermissionsTableTable get permissionsTable =>
      attachedDatabase.permissionsTable;
  $AppSettingsTableTable get appSettingsTable =>
      attachedDatabase.appSettingsTable;
  $ArchiveRecordsTableTable get archiveRecordsTable =>
      attachedDatabase.archiveRecordsTable;
  $AuditLogsTableTable get auditLogsTable => attachedDatabase.auditLogsTable;
  $NotificationsTableTable get notificationsTable =>
      attachedDatabase.notificationsTable;
  SystemDaoManager get managers => SystemDaoManager(this);
}

class SystemDaoManager {
  final _$SystemDaoMixin _db;
  SystemDaoManager(this._db);
  $$UsersTableTableTableManager get usersTable =>
      $$UsersTableTableTableManager(_db.attachedDatabase, _db.usersTable);
  $$BranchesTableTableTableManager get branchesTable =>
      $$BranchesTableTableTableManager(_db.attachedDatabase, _db.branchesTable);
  $$PermissionsTableTableTableManager get permissionsTable =>
      $$PermissionsTableTableTableManager(
        _db.attachedDatabase,
        _db.permissionsTable,
      );
  $$AppSettingsTableTableTableManager get appSettingsTable =>
      $$AppSettingsTableTableTableManager(
        _db.attachedDatabase,
        _db.appSettingsTable,
      );
  $$ArchiveRecordsTableTableTableManager get archiveRecordsTable =>
      $$ArchiveRecordsTableTableTableManager(
        _db.attachedDatabase,
        _db.archiveRecordsTable,
      );
  $$AuditLogsTableTableTableManager get auditLogsTable =>
      $$AuditLogsTableTableTableManager(
        _db.attachedDatabase,
        _db.auditLogsTable,
      );
  $$NotificationsTableTableTableManager get notificationsTable =>
      $$NotificationsTableTableTableManager(
        _db.attachedDatabase,
        _db.notificationsTable,
      );
}
