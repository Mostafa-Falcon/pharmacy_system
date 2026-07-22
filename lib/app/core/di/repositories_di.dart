import 'package:get_it/get_it.dart';

import '../data/repositories/medicines_repository.dart';
import '../data/repositories/customers_repository.dart';
import '../data/repositories/suppliers_repository.dart';
import '../data/repositories/sales_repository.dart';
import '../data/repositories/purchases_repository.dart';
import '../data/repositories/sales_return_repository.dart';
import '../data/repositories/inventory_repository.dart';
import '../data/repositories/customer_ledger_repository.dart';
import '../data/repositories/supplier_ledger_repository.dart';

final sl = GetIt.instance;

void registerRepositoryDependencies() {
  sl.allowReassignment = true;
  _reg<MedicinesRepository>(() => MedicinesRepository());
  _reg<CustomersRepository>(() => CustomersRepository());
  _reg<SuppliersRepository>(() => SuppliersRepository());
  _reg<SalesRepository>(() => SalesRepository());
  _reg<PurchasesRepository>(() => PurchasesRepository());
  _reg<SalesReturnRepository>(() => SalesReturnRepository());
  _reg<InventoryRepository>(() => InventoryRepository());
  _reg<CustomerLedgerRepository>(() => CustomerLedgerRepository());
  _reg<SupplierLedgerRepository>(() => SupplierLedgerRepository());
}

void _reg<T extends Object>(T Function() factory) {
  if (!sl.isRegistered<T>()) {
    sl.registerLazySingleton<T>(factory);
  }
}
