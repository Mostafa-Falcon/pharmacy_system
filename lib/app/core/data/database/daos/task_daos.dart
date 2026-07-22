import 'package:drift/drift.dart';
import '../database.dart';

class TasksDao {
  final AppDatabase db;
  TasksDao(this.db);

  Future<List<TasksTableData>> getAll() =>
      db.select(db.tasksTable).get();

  Future<List<TasksTableData>> getByBranch(String branchId) =>
      (db.select(db.tasksTable)
            ..where((t) => t.branchId.equals(branchId) & t.isDeleted.not())
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

  Future<TasksTableData?> getById(String id) =>
      (db.select(db.tasksTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<void> upsert(TasksTableCompanion entry) async {
    await db.into(db.tasksTable).insertOnConflictUpdate(entry);
  }

  Future<void> upsertBatch(List<TasksTableCompanion> entries) async {
    await db.batch((batch) {
      for (final entry in entries) {
        batch.insert(db.tasksTable, entry, mode: InsertMode.insertOrReplace);
      }
    });
  }

  Future<void> softDelete(String id) async {
    await (db.update(db.tasksTable)..where((t) => t.id.equals(id))).write(
      TasksTableCompanion(
        isDeleted: const Value(true),
        lastModified: Value(DateTime.now()),
      ),
    );
  }
}

class NotesDao {
  final AppDatabase db;
  NotesDao(this.db);

  Future<List<NotesTableData>> getAll() =>
      db.select(db.notesTable).get();

  Future<List<NotesTableData>> getByBranch(String branchId) =>
      (db.select(db.notesTable)
            ..where((t) => t.branchId.equals(branchId) & t.isDeleted.not())
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

  Future<NotesTableData?> getById(String id) =>
      (db.select(db.notesTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<void> upsert(NotesTableCompanion entry) async {
    await db.into(db.notesTable).insertOnConflictUpdate(entry);
  }

  Future<void> upsertBatch(List<NotesTableCompanion> entries) async {
    await db.batch((batch) {
      for (final entry in entries) {
        batch.insert(db.notesTable, entry, mode: InsertMode.insertOrReplace);
      }
    });
  }

  Future<void> softDelete(String id) async {
    await (db.update(db.notesTable)..where((t) => t.id.equals(id))).write(
      NotesTableCompanion(
        isDeleted: const Value(true),
        lastModified: Value(DateTime.now()),
      ),
    );
  }
}

class RemindersDao {
  final AppDatabase db;
  RemindersDao(this.db);

  Future<List<RemindersTableData>> getAll() =>
      db.select(db.remindersTable).get();

  Future<List<RemindersTableData>> getByBranch(String branchId) =>
      (db.select(db.remindersTable)
            ..where((t) => t.branchId.equals(branchId) & t.isDeleted.not())
            ..orderBy([(t) => OrderingTerm.asc(t.remindAt)]))
          .get();

  Future<RemindersTableData?> getById(String id) =>
      (db.select(db.remindersTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<void> upsert(RemindersTableCompanion entry) async {
    await db.into(db.remindersTable).insertOnConflictUpdate(entry);
  }

  Future<void> upsertBatch(List<RemindersTableCompanion> entries) async {
    await db.batch((batch) {
      for (final entry in entries) {
        batch.insert(db.remindersTable, entry, mode: InsertMode.insertOrReplace);
      }
    });
  }

  Future<void> softDelete(String id) async {
    await (db.update(db.remindersTable)..where((t) => t.id.equals(id))).write(
      RemindersTableCompanion(
        isDeleted: const Value(true),
        lastModified: Value(DateTime.now()),
      ),
    );
  }
}

class MessagesDao {
  final AppDatabase db;
  MessagesDao(this.db);

  Future<List<MessagesTableData>> getAll() =>
      db.select(db.messagesTable).get();

  Future<List<MessagesTableData>> getByBranch(String branchId) =>
      (db.select(db.messagesTable)
            ..where((t) => t.branchId.equals(branchId) & t.isDeleted.not())
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

  Future<MessagesTableData?> getById(String id) =>
      (db.select(db.messagesTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<void> upsert(MessagesTableCompanion entry) async {
    await db.into(db.messagesTable).insertOnConflictUpdate(entry);
  }

  Future<void> upsertBatch(List<MessagesTableCompanion> entries) async {
    await db.batch((batch) {
      for (final entry in entries) {
        batch.insert(db.messagesTable, entry, mode: InsertMode.insertOrReplace);
      }
    });
  }

  Future<void> softDelete(String id) async {
    await (db.update(db.messagesTable)..where((t) => t.id.equals(id))).write(
      MessagesTableCompanion(
        isDeleted: const Value(true),
        lastModified: Value(DateTime.now()),
      ),
    );
  }
}
