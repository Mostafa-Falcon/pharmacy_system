import 'package:get_it/get_it.dart';
import 'bloc/sales_return_bloc.dart';
import 'bloc/purchase_return_bloc.dart';

import 'bloc/free_return_bloc.dart';

final sl = GetIt.instance;

void registerReturnsDependencies() {
  sl.allowReassignment = true;
  _fac<SalesReturnBloc>(() => SalesReturnBloc());
  _fac<PurchaseReturnBloc>(() => PurchaseReturnBloc());
  _fac<FreeReturnBloc>(() => FreeReturnBloc());
}

void _fac<T extends Object>(T Function() factory) {
  if (!sl.isRegistered<T>()) {
    sl.registerFactory<T>(factory);
  }
}
