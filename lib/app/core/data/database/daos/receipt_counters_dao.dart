import 'package:drift/drift.dart';
import '../database.dart';

class ReceiptCountersDao {
  final AppDatabase db;
  ReceiptCountersDao(this.db);

  Future<ReceiptCountersTableData?> get(
          String branchId, String counterType) =>
      (db.select(db.receiptCountersTable)
            ..where((t) =>
                t.branchId.equals(branchId) & t.counterType.equals(counterType)))
          .getSingleOrNull();

  Future<void> set(
      String branchId, String counterType, int value) async {
    await db.into(db.receiptCountersTable).insertOnConflictUpdate(
      ReceiptCountersTableCompanion(
        branchId: Value(branchId),
        counterType: Value(counterType),
        currentValue: Value(value),
      ),
    );
  }

  Future<int> increment(String branchId, String counterType) async {
    final current = await get(branchId, counterType);
    final newValue = (current?.currentValue ?? 0) + 1;
    await set(branchId, counterType, newValue);
    return newValue;
  }

  Future<List<ReceiptCountersTableData>> getAll() =>
      db.select(db.receiptCountersTable).get();
}
