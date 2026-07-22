import 'package:get_it/get_it.dart';
import 'bloc/hr_bloc.dart';

final sl = GetIt.instance;

void registerHrDependencies() {
  sl.allowReassignment = true;
  _fac<HrBloc>(() => HrBloc());
}

void _fac<T extends Object>(T Function() factory) {
  if (!sl.isRegistered<T>()) {
    sl.registerFactory<T>(factory);
  }
}
