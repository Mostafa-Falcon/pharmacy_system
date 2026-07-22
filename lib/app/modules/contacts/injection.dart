import 'package:get_it/get_it.dart';

import '../../core/data/services/customer/customer_service.dart';
import '../../core/data/services/customer/customer_group_service.dart';
import '../../core/data/services/supplier/supplier_service.dart';
import 'customers/bloc/customers_bloc.dart';
import 'suppliers/bloc/suppliers_bloc.dart';
import 'customer_groups/bloc/customer_groups_bloc.dart';
import 'supplier_customers/bloc/supplier_customers_bloc.dart';

final sl = GetIt.instance;

void registerContactDependencies() {
  sl.allowReassignment = true;
  _reg<CustomerService>(() => CustomerService());
  _reg<CustomerGroupService>(() => CustomerGroupService());
  _reg<SupplierService>(() => SupplierService());
  _fac<CustomersBloc>(() => CustomersBloc());
  _fac<SuppliersBloc>(() => SuppliersBloc());
  _fac<CustomerGroupsBloc>(() => CustomerGroupsBloc());
  _fac<SupplierCustomersBloc>(() => SupplierCustomersBloc());
}

void _reg<T extends Object>(T Function() factory) {
  if (!sl.isRegistered<T>()) {
    sl.registerLazySingleton<T>(factory);
  }
}

void _fac<T extends Object>(T Function() factory) {
  if (!sl.isRegistered<T>()) {
    sl.registerFactory<T>(factory);
  }
}
