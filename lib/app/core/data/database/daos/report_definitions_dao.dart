import 'package:drift/drift.dart';
import '../database.dart';

class ReportDefinitionsDao {
  final AppDatabase db;
  ReportDefinitionsDao(this.db);

  Future<List<ReportDefinitionsTableData>> getAll() =>
      db.select(db.reportDefinitionsTable).get();

  Future<List<ReportDefinitionsTableData>> getByType(String type) =>
      (db.select(db.reportDefinitionsTable)
            ..where((t) => t.type.equals(type) & t.isDeleted.not()))
          .get();

  Future<ReportDefinitionsTableData?> getById(String id) =>
      (db.select(db.reportDefinitionsTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<void> upsert(ReportDefinitionsTableCompanion entry) async {
    await db.into(db.reportDefinitionsTable).insertOnConflictUpdate(entry);
  }

  Future<void> upsertBatch(
      List<ReportDefinitionsTableCompanion> entries) async {
    await db.batch((batch) {
      for (final entry in entries) {
        batch.insert(db.reportDefinitionsTable, entry,
            mode: InsertMode.insertOrReplace);
      }
    });
  }

  Future<void> softDelete(String id) async {
    await (db.update(db.reportDefinitionsTable)
          ..where((t) => t.id.equals(id)))
        .write(ReportDefinitionsTableCompanion(isDeleted: const Value(true)));
  }
}
