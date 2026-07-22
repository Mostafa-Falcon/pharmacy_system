import 'package:drift/drift.dart';
import '../database.dart';

class NotificationsDao {
  final AppDatabase db;
  NotificationsDao(this.db);

  Future<List<NotificationsTableData>> getAll() =>
      db.select(db.notificationsTable).get();

  Future<List<NotificationsTableData>> getUnread() =>
      (db.select(db.notificationsTable)..where((t) => t.isRead.not())).get();

  Future<NotificationsTableData?> getById(String id) =>
      (db.select(db.notificationsTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<void> upsert(NotificationsTableCompanion entry) async {
    await db.into(db.notificationsTable).insertOnConflictUpdate(entry);
  }

  Future<void> upsertBatch(List<NotificationsTableCompanion> entries) async {
    await db.batch((batch) {
      for (final entry in entries) {
        batch.insert(db.notificationsTable, entry,
            mode: InsertMode.insertOrReplace);
      }
    });
  }

  Future<void> markAsRead(String id) async {
    await (db.update(db.notificationsTable)..where((t) => t.id.equals(id)))
        .write(NotificationsTableCompanion(isRead: const Value(true)));
  }

  Future<void> softDelete(String id) async {
    await (db.update(db.notificationsTable)..where((t) => t.id.equals(id)))
        .write(NotificationsTableCompanion(isDeleted: const Value(true)));
  }
}
