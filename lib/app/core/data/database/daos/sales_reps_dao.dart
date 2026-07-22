import 'package:drift/drift.dart';
import '../database.dart';

class SalesRepsDao {
  final AppDatabase db;
  SalesRepsDao(this.db);

  Future<List<SalesRepsTableData>> getAll() =>
      db.select(db.salesRepsTable).get();

  Future<List<SalesRepsTableData>> getByBranch(String branchId) =>
      (db.select(db.salesRepsTable)
            ..where((t) => t.branchId.equals(branchId) & t.isDeleted.not()))
          .get();

  Future<SalesRepsTableData?> getById(String id) =>
      (db.select(db.salesRepsTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<void> upsert(SalesRepsTableCompanion entry) async {
    await db.into(db.salesRepsTable).insertOnConflictUpdate(entry);
  }

  Future<void> upsertBatch(List<SalesRepsTableCompanion> entries) async {
    await db.batch((batch) {
      for (final entry in entries) {
        batch.insert(db.salesRepsTable, entry,
            mode: InsertMode.insertOrReplace);
      }
    });
  }

  Future<void> softDelete(String id) async {
    await (db.update(db.salesRepsTable)..where((t) => t.id.equals(id))).write(
      SalesRepsTableCompanion(
        isDeleted: const Value(true),
        lastModified: Value(DateTime.now()),
      ),
    );
  }
}
