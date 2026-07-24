import 'package:get_it/get_it.dart';

import '../data/database/daos/accounting_dao.dart';
import '../data/database/daos/contacts_dao.dart';
import '../data/database/daos/hr_dao.dart';
import '../data/database/daos/inventory_dao.dart';
import '../data/database/daos/purchases_dao.dart';
import '../data/database/daos/sales_dao.dart';
import '../data/database/daos/sync_dao.dart';
import '../data/database/daos/system_dao.dart';
import '../data/database/drift_init.dart';

final sl = GetIt.instance;

void registerDaoDependencies() {
  _reg<AccountingDao>(() => AccountingDao(appDatabase));
  _reg<ContactsDao>(() => ContactsDao(appDatabase));
  _reg<HrDao>(() => HrDao(appDatabase));
  _reg<InventoryDao>(() => InventoryDao(appDatabase));
  _reg<PurchasesDao>(() => PurchasesDao(appDatabase));
  _reg<SalesDao>(() => SalesDao(appDatabase));
  _reg<SyncDao>(() => SyncDao(appDatabase));
  _reg<SystemDao>(() => SystemDao(appDatabase));
}

void _reg<T extends Object>(T Function() factory) {
  if (!sl.isRegistered<T>()) {
    sl.registerLazySingleton<T>(factory);
  }
}
