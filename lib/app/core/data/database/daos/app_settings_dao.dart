import 'package:drift/drift.dart';
import '../database.dart';

class AppSettingsDao {
  final AppDatabase db;
  AppSettingsDao(this.db);

  Future<AppSettingsTableData?> get(String key) =>
      (db.select(db.appSettingsTable)..where((t) => t.key.equals(key)))
          .getSingleOrNull();

  Future<void> set(String key, String value) async {
    await db.into(db.appSettingsTable).insertOnConflictUpdate(
      AppSettingsTableCompanion(
        key: Value(key),
        value: Value(value),
      ),
    );
  }

  Future<List<AppSettingsTableData>> getAll() =>
      db.select(db.appSettingsTable).get();

  Future<void> delete(String key) async {
    await (db.delete(db.appSettingsTable)..where((t) => t.key.equals(key)))
        .go();
  }
}
