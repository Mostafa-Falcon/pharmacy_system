import 'package:get_it/get_it.dart';
import 'bloc/shell_bloc.dart';

final sl = GetIt.instance;

void registerLayoutDependencies() {
  sl.allowReassignment = true;
  if (!sl.isRegistered<ShellBloc>()) {
    sl.registerLazySingleton<ShellBloc>(() => ShellBloc());
  }
}
