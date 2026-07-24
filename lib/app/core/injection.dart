import 'package:get_it/get_it.dart';

// ── Core Infrastructure ──
import 'di/database_di.dart';
import 'di/daos_di.dart';
import 'di/repositories_di.dart';
import 'di/services_di.dart';
import 'di/bloc_di.dart';

// ── Module Dependencies ──
import '../modules/auth/injection.dart';
import '../modules/admin/injection.dart';
import '../modules/contacts/injection.dart';
import '../modules/inventory/injection.dart';
import '../modules/sales/injection.dart';
import '../modules/purchases/injection.dart';
import '../modules/returns/injection.dart';
import '../modules/accounting/injection.dart';
import '../modules/hr/injection.dart';
import '../modules/layout/injection.dart';
import '../modules/home/injection.dart';
import '../modules/employee/injection.dart';
import '../modules/notifications/injection.dart';
import '../modules/quotes/injection.dart';
import '../modules/crm/injection.dart';
import '../modules/reports/injection.dart';
import '../modules/tasks/injection.dart';
import '../modules/stocktaking/injection.dart';
import '../modules/archive/injection.dart';
import '../modules/void_operations/injection.dart';
import '../modules/sync/injection.dart';

final sl = GetIt.instance;

Future<void> initInjection() async {
  sl.allowReassignment = true;

  registerDatabaseDependencies();
  registerDaoDependencies();
  registerRepositoryDependencies();
  registerCoreServiceDependencies();
  registerCoreBlocDependencies();

  registerAuthDependencies();
  registerAdminDependencies();
  registerContactDependencies();
  registerInventoryDependencies();
  registerSalesDependencies();
  registerPurchasesDependencies();
  registerReturnsDependencies();
  registerAccountingDependencies();
  registerHrDependencies();
  registerLayoutDependencies();
  registerHomeDependencies();
  registerEmployeeDependencies();
  registerNotificationsDependencies();
  registerQuotesDependencies();
  registerCrmDependencies();
  registerReportsDependencies();
  registerTasksDependencies();
  registerStocktakingDependencies();
  registerArchiveDependencies();
  registerVoidOperationsDependencies();
  registerSyncDependencies();
}

Future<void> disposeInjection() async {
  await sl.reset();
}


