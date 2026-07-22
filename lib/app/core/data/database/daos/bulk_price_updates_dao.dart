import 'package:drift/drift.dart';
import '../database.dart';

class BulkPriceUpdatesDao {
  final AppDatabase db;
  BulkPriceUpdatesDao(this.db);

  Future<List<BulkPriceUpdatesTableData>> getAll() =>
      db.select(db.bulkPriceUpdatesTable).get();

  Future<List<BulkPriceUpdatesTableData>> getByBranch(String branchId) =>
      (db.select(db.bulkPriceUpdatesTable)
            ..where((t) =>
                t.branchId.equals(branchId) & t.isDeleted.not())
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

  Future<BulkPriceUpdatesTableData?> getById(String id) =>
      (db.select(db.bulkPriceUpdatesTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<void> upsert(BulkPriceUpdatesTableCompanion entry) async {
    await db.into(db.bulkPriceUpdatesTable).insertOnConflictUpdate(entry);
  }

  Future<void> upsertBatch(
      List<BulkPriceUpdatesTableCompanion> entries) async {
    await db.batch((batch) {
      for (final entry in entries) {
        batch.insert(db.bulkPriceUpdatesTable, entry,
            mode: InsertMode.insertOrReplace);
      }
    });
  }

  Future<void> softDelete(String id) async {
    await (db.update(db.bulkPriceUpdatesTable)
          ..where((t) => t.id.equals(id)))
        .write(BulkPriceUpdatesTableCompanion(isDeleted: const Value(true)));
  }
}
