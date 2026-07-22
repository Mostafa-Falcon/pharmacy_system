import 'package:get_it/get_it.dart';
import 'bloc/archive_bloc.dart';

final sl = GetIt.instance;

void registerArchiveDependencies() {
  sl.allowReassignment = true;
  _fac<ArchiveBloc>(() => ArchiveBloc());
}

void _fac<T extends Object>(T Function() factory) {
  if (!sl.isRegistered<T>()) {
    sl.registerFactory<T>(factory);
  }
}
