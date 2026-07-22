import 'package:drift/drift.dart';
import '../database.dart';

class PurchasesDao {
  final AppDatabase db;
  PurchasesDao(this.db);

  Future<List<PurchasesTableData>> getAll() =>
      db.select(db.purchasesTable).get();

  Future<List<PurchasesTableData>> getByBranch(String branchId) =>
      (db.select(db.purchasesTable)
            ..where((t) => t.branchId.equals(branchId) & t.isDeleted.not())
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

  Future<PurchasesTableData?> getById(String id) =>
      (db.select(db.purchasesTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<void> upsert(PurchasesTableCompanion entry) async {
    await db.into(db.purchasesTable).insertOnConflictUpdate(entry);
  }

  Future<void> softDelete(String id) async {
    await (db.update(db.purchasesTable)..where((t) => t.id.equals(id))).write(
      PurchasesTableCompanion(
        isDeleted: const Value(true),
        lastModified: Value(DateTime.now()),
      ),
    );
  }

  Future<int> count() => db.select(db.purchasesTable).get().then((r) => r.length);
}
