import 'package:drift/drift.dart';
import '../database.dart';

class ExpensesDao {
  final AppDatabase db;
  ExpensesDao(this.db);

  Future<List<ExpensesTableData>> getAll() =>
      db.select(db.expensesTable).get();

  Future<List<ExpensesTableData>> getByBranch(String branchId) =>
      (db.select(db.expensesTable)
            ..where((t) =>
                t.branchId.equals(branchId) & t.isDeleted.not())
            ..orderBy([(t) => OrderingTerm.desc(t.expenseDate)]))
          .get();

  Future<ExpensesTableData?> getById(String id) =>
      (db.select(db.expensesTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<List<ExpensesTableData>> getByDateRange(
          DateTime start, DateTime end) =>
      (db.select(db.expensesTable)
            ..where((t) =>
                t.expenseDate.isBetweenValues(start, end) &
                t.isDeleted.not())
            ..orderBy([(t) => OrderingTerm.desc(t.expenseDate)]))
          .get();

  Future<void> upsert(ExpensesTableCompanion entry) async {
    await db.into(db.expensesTable).insertOnConflictUpdate(entry);
  }

  Future<void> upsertBatch(List<ExpensesTableCompanion> entries) async {
    await db.batch((batch) {
      for (final entry in entries) {
        batch.insert(db.expensesTable, entry,
            mode: InsertMode.insertOrReplace);
      }
    });
  }

  Future<void> softDelete(String id) async {
    await (db.update(db.expensesTable)..where((t) => t.id.equals(id)))
        .write(ExpensesTableCompanion(isDeleted: const Value(true)));
  }
}
