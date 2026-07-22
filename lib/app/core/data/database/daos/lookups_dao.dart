import 'package:drift/drift.dart';
import '../database.dart';

class LookupsDao {
  final AppDatabase db;
  LookupsDao(this.db);

  Future<List<LookupsTableData>> getAll() =>
      db.select(db.lookupsTable).get();

  Future<List<LookupsTableData>> getByType(String type) =>
      (db.select(db.lookupsTable)..where((t) => t.type.equals(type))).get();

  Future<List<LookupsTableData>> getByBranch(String branchId) =>
      (db.select(db.lookupsTable)
            ..where((t) => t.branchId.equals(branchId) & t.isDeleted.not()))
          .get();

  Future<LookupsTableData?> getById(String id) =>
      (db.select(db.lookupsTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<void> upsert(LookupsTableCompanion entry) async {
    await db.into(db.lookupsTable).insertOnConflictUpdate(entry);
  }

  Future<void> upsertBatch(List<LookupsTableCompanion> entries) async {
    await db.batch((batch) {
      for (final entry in entries) {
        batch.insert(db.lookupsTable, entry,
            mode: InsertMode.insertOrReplace);
      }
    });
  }

  Future<void> softDelete(String id) async {
    await (db.update(db.lookupsTable)..where((t) => t.id.equals(id))).write(
      LookupsTableCompanion(
        isDeleted: const Value(true),
        lastModified: Value(DateTime.now()),
      ),
    );
  }
}
