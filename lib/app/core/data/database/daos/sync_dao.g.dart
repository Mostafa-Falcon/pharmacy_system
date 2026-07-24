// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_dao.dart';

// ignore_for_file: type=lint
mixin _$SyncDaoMixin on DatabaseAccessor<AppDatabase> {
  $SyncOutboxTableTable get syncOutboxTable => attachedDatabase.syncOutboxTable;
  $SyncStateTableTable get syncStateTable => attachedDatabase.syncStateTable;
  SyncDaoManager get managers => SyncDaoManager(this);
}

class SyncDaoManager {
  final _$SyncDaoMixin _db;
  SyncDaoManager(this._db);
  $$SyncOutboxTableTableTableManager get syncOutboxTable =>
      $$SyncOutboxTableTableTableManager(
        _db.attachedDatabase,
        _db.syncOutboxTable,
      );
  $$SyncStateTableTableTableManager get syncStateTable =>
      $$SyncStateTableTableTableManager(
        _db.attachedDatabase,
        _db.syncStateTable,
      );
}
