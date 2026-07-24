import 'package:get_it/get_it.dart';

import '../data/database/database.dart';
import '../data/database/drift_init.dart';

final sl = GetIt.instance;

void registerDatabaseDependencies() {
  sl.allowReassignment = true;
  _reg<AppDatabase>(() => appDatabase);
}

void _reg<T extends Object>(T Function() factory) {
  if (!sl.isRegistered<T>()) {
    sl.registerLazySingleton<T>(factory);
  }
}


