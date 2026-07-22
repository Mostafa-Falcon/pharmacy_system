import 'package:drift/drift.dart';
import '../database.dart';

class JournalEntriesDao {
  final AppDatabase db;
  JournalEntriesDao(this.db);

  Future<List<JournalEntriesTableData>> getAll() =>
      db.select(db.journalEntriesTable).get();

  Future<List<JournalEntriesTableData>> getByBranch(String branchId) =>
      (db.select(db.journalEntriesTable)
            ..where((t) =>
                t.branchId.equals(branchId) & t.isDeleted.not())
            ..orderBy([(t) => OrderingTerm.desc(t.entryDate)]))
          .get();

  Future<JournalEntriesTableData?> getById(String id) =>
      (db.select(db.journalEntriesTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<void> upsert(JournalEntriesTableCompanion entry) async {
    await db.into(db.journalEntriesTable).insertOnConflictUpdate(entry);
  }

  Future<void> upsertBatch(
      List<JournalEntriesTableCompanion> entries) async {
    await db.batch((batch) {
      for (final entry in entries) {
        batch.insert(db.journalEntriesTable, entry,
            mode: InsertMode.insertOrReplace);
      }
    });
  }

  Future<void> softDelete(String id) async {
    await (db.update(db.journalEntriesTable)
          ..where((t) => t.id.equals(id)))
        .write(JournalEntriesTableCompanion(isDeleted: const Value(true)));
  }
}
