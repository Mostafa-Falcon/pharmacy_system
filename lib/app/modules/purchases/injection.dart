import 'package:get_it/get_it.dart';
import 'bloc/purchases_bloc.dart';

final sl = GetIt.instance;

void registerPurchasesDependencies() {
  sl.allowReassignment = true;
  _fac<PurchasesBloc>(() => PurchasesBloc());
}

void _fac<T extends Object>(T Function() factory) {
  if (!sl.isRegistered<T>()) {
    sl.registerFactory<T>(factory);
  }
}


