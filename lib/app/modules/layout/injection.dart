import 'package:get_it/get_it.dart';
import 'bloc/shell_bloc.dart';
import 'bloc/shell_event.dart';

final sl = GetIt.instance;

void registerLayoutDependencies() {
  sl.allowReassignment = true;
  _reg<ShellBloc>(() => ShellBloc()..add(const LoadShell()));
}

void _reg<T extends Object>(T Function() factory) {
  if (!sl.isRegistered<T>()) {
    sl.registerLazySingleton<T>(factory);
  }
}
