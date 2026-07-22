import 'package:drift/drift.dart';
import '../database.dart';

class MedicineBrandsDao {
  final AppDatabase db;
  MedicineBrandsDao(this.db);

  Future<List<MedicineBrandsTableData>> getAll() =>
      db.select(db.medicineBrandsTable).get();

  Future<MedicineBrandsTableData?> getById(String id) =>
      (db.select(db.medicineBrandsTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<void> upsert(MedicineBrandsTableCompanion entry) async {
    await db.into(db.medicineBrandsTable).insertOnConflictUpdate(entry);
  }

  Future<void> upsertBatch(List<MedicineBrandsTableCompanion> entries) async {
    await db.batch((batch) {
      for (final entry in entries) {
        batch.insert(db.medicineBrandsTable, entry,
            mode: InsertMode.insertOrReplace);
      }
    });
  }

  Future<void> delete(String id) async {
    await (db.delete(db.medicineBrandsTable)..where((t) => t.id.equals(id)))
        .go();
  }
}
