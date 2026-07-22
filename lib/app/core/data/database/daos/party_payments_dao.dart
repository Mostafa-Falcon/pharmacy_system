import 'package:drift/drift.dart';
import '../database.dart';

class PartyPaymentsDao {
  final AppDatabase db;
  PartyPaymentsDao(this.db);

  Future<List<PartyPaymentsTableData>> getAll() =>
      db.select(db.partyPaymentsTable).get();

  Future<List<PartyPaymentsTableData>> getByBranch(String branchId) =>
      (db.select(db.partyPaymentsTable)
            ..where((t) =>
                t.branchId.equals(branchId) & t.isDeleted.not())
            ..orderBy([(t) => OrderingTerm.desc(t.paymentDate)]))
          .get();

  Future<List<PartyPaymentsTableData>> getByParty(String partyId) =>
      (db.select(db.partyPaymentsTable)
            ..where((t) =>
                t.partyId.equals(partyId) & t.isDeleted.not())
            ..orderBy([(t) => OrderingTerm.desc(t.paymentDate)]))
          .get();

  Future<PartyPaymentsTableData?> getById(String id) =>
      (db.select(db.partyPaymentsTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<void> upsert(PartyPaymentsTableCompanion entry) async {
    await db.into(db.partyPaymentsTable).insertOnConflictUpdate(entry);
  }

  Future<void> upsertBatch(List<PartyPaymentsTableCompanion> entries) async {
    await db.batch((batch) {
      for (final entry in entries) {
        batch.insert(db.partyPaymentsTable, entry,
            mode: InsertMode.insertOrReplace);
      }
    });
  }

  Future<void> softDelete(String id) async {
    await (db.update(db.partyPaymentsTable)..where((t) => t.id.equals(id)))
        .write(PartyPaymentsTableCompanion(isDeleted: const Value(true)));
  }
}
