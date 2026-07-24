import 'package:get_it/get_it.dart';
import 'bloc/pos_bloc.dart';
import 'bloc/catalog_cubit.dart';
import 'bloc/cart_cubit.dart';
import 'bloc/sales_bloc.dart';
import 'bloc/cashier_shift_bloc.dart';

final sl = GetIt.instance;

void registerSalesDependencies() {
  sl.allowReassignment = true;
  _fac<PosBloc>(() => PosBloc());
  _fac<CatalogCubit>(() => CatalogCubit());
  _fac<CartCubit>(() => CartCubit());
  _fac<SalesBloc>(() => SalesBloc());
  _fac<CashierShiftBloc>(() => CashierShiftBloc());
}

void _fac<T extends Object>(T Function() factory) {
  if (!sl.isRegistered<T>()) {
    sl.registerFactory<T>(factory);
  }
}


