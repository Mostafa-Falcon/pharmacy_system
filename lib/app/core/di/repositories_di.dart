import 'package:get_it/get_it.dart';

import '../data/repositories/medicines_repository.dart';
import '../data/repositories/customers_repository.dart';
import '../data/repositories/suppliers_repository.dart';
import '../data/repositories/supplier_customers_repository.dart';
import '../data/repositories/sales_repository.dart';
import '../data/repositories/purchases_repository.dart';
import '../data/repositories/sales_return_repository.dart';
import '../data/repositories/contact_ledger_repository.dart';

final sl = GetIt.instance;

void registerRepositoryDependencies() {
  sl.allowReassignment = true;
  _reg<MedicinesRepository>(() => MedicinesRepository());
  _reg<CustomersRepository>(() => CustomersRepository());
  _reg<SuppliersRepository>(() => SuppliersRepository());
  _reg<SupplierCustomersRepository>(() => SupplierCustomersRepository());
  _reg<SalesRepository>(() => SalesRepository());
  _reg<PurchasesRepository>(() => PurchasesRepository());
  _reg<SalesReturnRepository>(() => SalesReturnRepository());
  _reg<ContactLedgerRepository>(() => ContactLedgerRepository());
}

void _reg<T extends Object>(T Function() factory) {
  if (!sl.isRegistered<T>()) {
    sl.registerLazySingleton<T>(factory);
  }
}
