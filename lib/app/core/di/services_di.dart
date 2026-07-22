import 'package:get_it/get_it.dart';

import '../data/services/lookup_service.dart';
import '../data/services/sync/sync_engine.dart';

final sl = GetIt.instance;

void registerCoreServiceDependencies() {
  sl.allowReassignment = true;
  _reg<LookupService>(() => LookupService());
  
  // Register SyncEngine singleton
  if (!sl.isRegistered<SyncEngine>()) {
    sl.registerSingleton<SyncEngine>(SyncEngine.instance);
  }
}

void _reg<T extends Object>(T Function() factory) {
  if (!sl.isRegistered<T>()) {
    sl.registerLazySingleton<T>(factory);
  }
}
