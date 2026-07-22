import 'package:drift/drift.dart';
import '../database.dart';

class ArchiveRecordsDao {
  final AppDatabase db;
  ArchiveRecordsDao(this.db);

  Future<List<ArchiveRecord>> getAll() => db.select(db.archiveRecords).get();

  Future<List<ArchiveRecord>> getByBranch(String branchId) =>
      (db.select(db.archiveRecords)
            ..where((t) => t.branchId.equals(branchId))
            ..orderBy([(t) => OrderingTerm.desc(t.deletedAt)]))
          .get();

  Future<List<ArchiveRecord>> getByEntityType(String entityType) =>
      (db.select(db.archiveRecords)
            ..where((t) => t.entityType.equals(entityType))
            ..orderBy([(t) => OrderingTerm.desc(t.deletedAt)]))
          .get();

  Future<ArchiveRecord?> getById(String id) =>
      (db.select(db.archiveRecords)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<void> upsert(ArchiveRecordsCompanion entry) async {
    await db.into(db.archiveRecords).insertOnConflictUpdate(entry);
  }

  Future<void> upsertBatch(List<ArchiveRecordsCompanion> entries) async {
    await db.batch((batch) {
      for (final entry in entries) {
        batch.insert(db.archiveRecords, entry,
            mode: InsertMode.insertOrReplace);
      }
    });
  }

  Future<void> delete(String id) async {
    await (db.delete(db.archiveRecords)..where((t) => t.id.equals(id))).go();
  }
}
