import 'package:get_it/get_it.dart';
import 'bloc/stocktaking_bloc.dart';

final sl = GetIt.instance;

void registerStocktakingDependencies() {
  sl.allowReassignment = true;
  _fac<StocktakingBloc>(() => StocktakingBloc());
}

void _fac<T extends Object>(T Function() factory) {
  if (!sl.isRegistered<T>()) {
    sl.registerFactory<T>(factory);
  }
}


