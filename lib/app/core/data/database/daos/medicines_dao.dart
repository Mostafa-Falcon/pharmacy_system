import 'package:drift/drift.dart';
import '../database.dart';

class MedicinesDao {
  final AppDatabase db;
  MedicinesDao(this.db);

  Future<List<MedicinesTableData>> getAll() =>
      db.select(db.medicinesTable).get();

  Future<List<MedicinesTableData>> getByBranch(String branchId) =>
      (db.select(db.medicinesTable)
            ..where((t) => t.branchId.equals(branchId) & t.isDeleted.not()))
          .get();

  Stream<List<MedicinesTableData>> watchByBranch(String branchId) =>
      (db.select(db.medicinesTable)
            ..where((t) => t.branchId.equals(branchId) & t.isDeleted.not()))
          .watch();

  Future<MedicinesTableData?> getById(String id) =>
      (db.select(db.medicinesTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<List<MedicinesTableData>> search(String query, String branchId) {
    final like = '%$query%';
    return (db.select(db.medicinesTable)
          ..where((t) =>
              t.branchId.equals(branchId) &
              t.isDeleted.not() &
              (t.name.like(like) | t.barcodes.like(like)))
          ..limit(20))
        .get();
  }

  Future<void> upsert(MedicinesTableCompanion entry) async {
    await db.into(db.medicinesTable).insertOnConflictUpdate(entry);
  }

  Future<void> upsertBatch(List<MedicinesTableCompanion> entries) async {
    await db.batch((batch) {
      for (final entry in entries) {
        batch.insert(db.medicinesTable, entry,
            mode: InsertMode.insertOrReplace);
      }
    });
  }

  Future<void> softDelete(String id) async {
    await (db.update(db.medicinesTable)..where((t) => t.id.equals(id))).write(
      MedicinesTableCompanion(
        isDeleted: const Value(true),
        lastModified: Value(DateTime.now()),
      ),
    );
  }

  Future<void> restore(String id) async {
    await (db.update(db.medicinesTable)..where((t) => t.id.equals(id))).write(
      MedicinesTableCompanion(
        isDeleted: const Value(false),
        lastModified: Value(DateTime.now()),
      ),
    );
  }

  Future<void> hardDelete(String id) async {
    await (db.delete(db.medicinesTable)..where((t) => t.id.equals(id))).go();
  }

  Future<int> count() => db.select(db.medicinesTable).get().then((r) => r.length);
}
