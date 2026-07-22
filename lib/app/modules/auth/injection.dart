import 'package:get_it/get_it.dart';
import 'bloc/auth_bloc.dart';

final sl = GetIt.instance;

void registerAuthDependencies() {
  sl.allowReassignment = true;
  _reg<AuthBloc>(() => AuthBloc());
}

void _reg<T extends Object>(T Function() factory) {
  if (!sl.isRegistered<T>()) {
    sl.registerLazySingleton<T>(factory);
  }
}
