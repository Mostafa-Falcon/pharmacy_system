import 'package:drift/drift.dart';
import '../database.dart';

class PayrollDao {
  final AppDatabase db;
  PayrollDao(this.db);

  Future<List<PayrollTableData>> getAll() =>
      db.select(db.payrollTable).get();

  Future<List<PayrollTableData>> getByEmployee(String employeeId) =>
      (db.select(db.payrollTable)
            ..where((t) =>
                t.employeeId.equals(employeeId) & t.isDeleted.not())
            ..orderBy([(t) => OrderingTerm.desc(t.payDate)]))
          .get();

  Future<List<PayrollTableData>> getByPeriod(String period) =>
      (db.select(db.payrollTable)
            ..where((t) => t.period.equals(period) & t.isDeleted.not())
            ..orderBy([(t) => OrderingTerm.desc(t.payDate)]))
          .get();

  Future<PayrollTableData?> getById(String id) =>
      (db.select(db.payrollTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<void> upsert(PayrollTableCompanion entry) async {
    await db.into(db.payrollTable).insertOnConflictUpdate(entry);
  }

  Future<void> upsertBatch(List<PayrollTableCompanion> entries) async {
    await db.batch((batch) {
      for (final entry in entries) {
        batch.insert(db.payrollTable, entry,
            mode: InsertMode.insertOrReplace);
      }
    });
  }

  Future<void> softDelete(String id) async {
    await (db.update(db.payrollTable)..where((t) => t.id.equals(id))).write(
      PayrollTableCompanion(
        isDeleted: const Value(true),
        lastModified: Value(DateTime.now()),
      ),
    );
  }
}
