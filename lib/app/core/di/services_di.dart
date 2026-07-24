import 'package:get_it/get_it.dart';
import 'package:pharmacy_system/app/core/sync/engine/sync_engine.dart';

import '../data/services/system/lookup_service.dart';
import '../data/services/system/system_health_service.dart';
import '../data/services/ui/theme_service.dart';
import '../data/services/ui/sound_service.dart';

final sl = GetIt.instance;

void registerCoreServiceDependencies() {
  sl.allowReassignment = true;
  
  // ─── System Services ───
  _reg<LookupService>(() => LookupService.instance);
  _reg<SystemHealthService>(() => SystemHealthService.instance);
  // ConfigService is static-only; no DI registration needed.
  
  // ─── UI Services ───
  _reg<ThemeService>(() => ThemeService.instance);
  _reg<SoundService>(() => SoundService.instance);

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
