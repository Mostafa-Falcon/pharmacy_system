import 'package:drift/drift.dart';
import '../database.dart';

class AuditLogsDao {
  final AppDatabase db;
  AuditLogsDao(this.db);

  Future<List<AuditLogsTableData>> getAll() =>
      db.select(db.auditLogsTable).get();

  Future<List<AuditLogsTableData>> getByBranch(String branchId) =>
      (db.select(db.auditLogsTable)
            ..where((t) => t.branchId.equals(branchId))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

  Future<List<AuditLogsTableData>> getByUser(String userId) =>
      (db.select(db.auditLogsTable)
            ..where((t) => t.userId.equals(userId))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

  Future<AuditLogsTableData?> getById(String id) =>
      (db.select(db.auditLogsTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<void> upsert(AuditLogsTableCompanion entry) async {
    await db.into(db.auditLogsTable).insertOnConflictUpdate(entry);
  }

  Future<void> upsertBatch(List<AuditLogsTableCompanion> entries) async {
    await db.batch((batch) {
      for (final entry in entries) {
        batch.insert(db.auditLogsTable, entry,
            mode: InsertMode.insertOrReplace);
      }
    });
  }

  Future<void> delete(String id) async {
    await (db.delete(db.auditLogsTable)..where((t) => t.id.equals(id))).go();
  }
}
