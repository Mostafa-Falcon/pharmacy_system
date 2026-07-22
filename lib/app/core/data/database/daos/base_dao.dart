import 'package:drift/drift.dart';
import '../database.dart';

class BaseDao {
  final AppDatabase db;
  BaseDao(this.db);

  Future<void> batchInsert(
    TableInfo table,
    List<Insertable> rows,
  ) async {
    await db.batch((batch) {
      for (final row in rows) {
        batch.insert(table, row, mode: InsertMode.insertOrReplace);
      }
    });
  }
}
