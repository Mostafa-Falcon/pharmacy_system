import 'package:drift/drift.dart';
import '../database.dart';

class SalesDao {
  final AppDatabase db;
  SalesDao(this.db);

  Future<List<SalesTableData>> getAll() => db.select(db.salesTable).get();

  Future<List<SalesTableData>> getByBranch(String branchId) =>
      (db.select(db.salesTable)
            ..where((t) => t.branchId.equals(branchId) & t.isDeleted.not())
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

  Stream<List<SalesTableData>> watchByBranch(String branchId) =>
      (db.select(db.salesTable)
            ..where((t) => t.branchId.equals(branchId) & t.isDeleted.not())
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .watch();

  Future<SalesTableData?> getById(String id) =>
      (db.select(db.salesTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<List<SalesTableData>> getByDateRange(
      String branchId, DateTime from, DateTime to) =>
      (db.select(db.salesTable)
            ..where((t) =>
                t.branchId.equals(branchId) &
                t.isDeleted.not() &
                t.createdAt.isBetween(Variable(from), Variable(to))))
          .get();

  Future<List<SalesTableData>> getByRepAndDateRange(
    String repId,
    DateTime from,
    DateTime to,
  ) =>
      (db.select(db.salesTable)
            ..where((t) =>
                t.salesRepId.equals(repId) &
                t.isDeleted.not() &
                t.createdAt.isBetween(Variable(from), Variable(to))))
          .get();

  Future<List<SalesTableData>> getByRepAndBranchAndDateRange(
    String repId,
    String branchId,
    DateTime from,
    DateTime to,
  ) =>
      (db.select(db.salesTable)
            ..where((t) =>
                t.salesRepId.equals(repId) &
                t.branchId.equals(branchId) &
                t.isDeleted.not() &
                t.createdAt.isBetween(Variable(from), Variable(to))))
          .get();

  Future<void> upsert(SalesTableCompanion entry) async {
    await db.into(db.salesTable).insertOnConflictUpdate(entry);
  }

  Future<void> upsertBatch(List<SalesTableCompanion> entries) async {
    await db.batch((batch) {
      for (final entry in entries) {
        batch.insert(db.salesTable, entry, mode: InsertMode.insertOrReplace);
      }
    });
  }

  Future<void> softDelete(String id) async {
    await (db.update(db.salesTable)..where((t) => t.id.equals(id))).write(
      SalesTableCompanion(
        isDeleted: const Value(true),
        lastModified: Value(DateTime.now()),
      ),
    );
  }

  Future<int> count() => db.select(db.salesTable).get().then((r) => r.length);

  Future<int> countByRep(String repId) =>
      (db.select(db.salesTable)
            ..where((t) => t.salesRepId.equals(repId) & t.isDeleted.not()))
          .get()
          .then((rows) => rows.length);
}
