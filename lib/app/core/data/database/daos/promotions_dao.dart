import 'package:drift/drift.dart';
import '../database.dart';

class PromotionsDao {
  final AppDatabase db;
  PromotionsDao(this.db);

  Future<List<PromotionsTableData>> getAll() =>
      db.select(db.promotionsTable).get();

  Future<List<PromotionsTableData>> getByBranch(String branchId) =>
      (db.select(db.promotionsTable)
            ..where((t) => t.branchId.equals(branchId)))
          .get();

  Future<PromotionsTableData?> getById(String id) =>
      (db.select(db.promotionsTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<List<PromotionsTableData>> getActive(String branchId) =>
      (db.select(db.promotionsTable)
            ..where((t) =>
                t.branchId.equals(branchId) &
                t.isActive.equals(true) &
                t.startDate.isSmallerOrEqual(Variable(DateTime.now())) &
                t.endDate.isBiggerThan(Variable(DateTime.now()))))
          .get();

  Future<void> upsert(PromotionsTableCompanion entry) async {
    await db.into(db.promotionsTable).insertOnConflictUpdate(entry);
  }

  Future<void> upsertBatch(List<PromotionsTableCompanion> entries) async {
    await db.batch((batch) {
      for (final entry in entries) {
        batch.insert(db.promotionsTable, entry,
            mode: InsertMode.insertOrReplace);
      }
    });
  }

  Future<void> delete(String id) async {
    await (db.delete(db.promotionsTable)..where((t) => t.id.equals(id))).go();
  }
}
