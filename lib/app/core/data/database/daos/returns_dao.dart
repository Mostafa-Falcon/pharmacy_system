import 'package:drift/drift.dart';
import '../database.dart';

class ReturnsDao {
  final AppDatabase db;
  ReturnsDao(this.db);

  Future<List<ReturnsTableData>> getAll() => db.select(db.returnsTable).get();

  Future<List<ReturnsTableData>> getByBranch(String branchId) =>
      (db.select(db.returnsTable)
            ..where((t) => t.branchId.equals(branchId) & t.isDeleted.not())
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

  Future<ReturnsTableData?> getById(String id) =>
      (db.select(db.returnsTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<void> upsert(ReturnsTableCompanion entry) async {
    await db.into(db.returnsTable).insertOnConflictUpdate(entry);
  }

  Future<void> softDelete(String id) async {
    await (db.update(db.returnsTable)..where((t) => t.id.equals(id))).write(
      ReturnsTableCompanion(
        isDeleted: const Value(true),
        lastModified: Value(DateTime.now()),
      ),
    );
  }

  Future<int> count() => db.select(db.returnsTable).get().then((r) => r.length);
}
