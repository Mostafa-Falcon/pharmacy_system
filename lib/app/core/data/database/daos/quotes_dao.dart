import 'package:drift/drift.dart';
import '../database.dart';

class QuotesDao {
  final AppDatabase db;
  QuotesDao(this.db);

  Future<List<QuotesTableData>> getAll() => db.select(db.quotesTable).get();

  Future<List<QuotesTableData>> getByBranch(String branchId) =>
      (db.select(db.quotesTable)
            ..where((t) => t.branchId.equals(branchId) & t.isDeleted.not())
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

  Future<QuotesTableData?> getById(String id) =>
      (db.select(db.quotesTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<void> upsert(QuotesTableCompanion entry) async {
    await db.into(db.quotesTable).insertOnConflictUpdate(entry);
  }

  Future<void> upsertBatch(List<QuotesTableCompanion> entries) async {
    await db.batch((batch) {
      for (final entry in entries) {
        batch.insert(db.quotesTable, entry, mode: InsertMode.insertOrReplace);
      }
    });
  }

  Future<void> softDelete(String id) async {
    await (db.update(db.quotesTable)..where((t) => t.id.equals(id))).write(
      QuotesTableCompanion(
        isDeleted: const Value(true),
        lastModified: Value(DateTime.now()),
      ),
    );
  }

  Future<int> count() => db.select(db.quotesTable).get().then((r) => r.length);
}
