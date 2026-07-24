import 'package:get_it/get_it.dart';

// ── Core Infrastructure ──
import 'di/database_di.dart';
import 'di/daos_di.dart';
import 'di/repositories_di.dart';
import 'di/services_di.dart';
import 'di/bloc_di.dart';

// ── Module Dependencies ──
import '../modules/auth/injection.dart';


final sl = GetIt.instance;

Future<void> initInjection() async {
  sl.allowReassignment = true;

  registerDatabaseDependencies();
  registerDaoDependencies();
  registerRepositoryDependencies();
  registerCoreServiceDependencies();
  registerCoreBlocDependencies();

  registerAuthDependencies();

}

Future<void> disposeInjection() async {
  await sl.reset();
}


