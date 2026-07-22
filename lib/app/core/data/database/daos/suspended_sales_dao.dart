import 'package:drift/drift.dart';
import '../database.dart';

class SuspendedSalesDao {
  final AppDatabase db;
  SuspendedSalesDao(this.db);

  Future<List<SuspendedSalesTableData>> getAll() =>
      db.select(db.suspendedSalesTable).get();

  Future<List<SuspendedSalesTableData>> getByBranch(String branchId) =>
      (db.select(db.suspendedSalesTable)
            ..where((t) =>
                t.branchId.equals(branchId) & t.isDeleted.not())
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

  Future<SuspendedSalesTableData?> getById(String id) =>
      (db.select(db.suspendedSalesTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<void> upsert(SuspendedSalesTableCompanion entry) async {
    await db.into(db.suspendedSalesTable).insertOnConflictUpdate(entry);
  }

  Future<void> upsertBatch(List<SuspendedSalesTableCompanion> entries) async {
    await db.batch((batch) {
      for (final entry in entries) {
        batch.insert(db.suspendedSalesTable, entry,
            mode: InsertMode.insertOrReplace);
      }
    });
  }

  Future<void> softDelete(String id) async {
    await (db.update(db.suspendedSalesTable)
          ..where((t) => t.id.equals(id)))
        .write(SuspendedSalesTableCompanion(isDeleted: const Value(true)));
  }
}
