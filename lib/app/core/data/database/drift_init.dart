import 'database.dart';
import 'drift_executor_stub.dart'
    if (dart.library.io) 'drift_executor_native.dart'
    if (dart.library.html) 'drift_executor_web.dart'
    if (dart.library.js_interop) 'drift_executor_web.dart';

AppDatabase? _db;

AppDatabase get appDatabase {
  assert(_db != null, 'Drift database not initialized. Call initDrift() first.');
  return _db!;
}

Future<AppDatabase> initDrift() async {
  if (_db != null) return _db!;

  final executor = await createDriftExecutor();
  _db = AppDatabase(executor);
  return _db!;
}

Future<void> disposeDrift() async {
  await _db?.close();
  _db = null;
}
