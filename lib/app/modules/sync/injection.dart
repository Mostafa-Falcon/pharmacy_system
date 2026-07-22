import 'package:get_it/get_it.dart';
import 'bloc/sync_status_bloc.dart';

final sl = GetIt.instance;

void registerSyncDependencies() {
  sl.allowReassignment = true;
  _fac<SyncStatusBloc>(() => SyncStatusBloc());
}

void _fac<T extends Object>(T Function() factory) {
  if (!sl.isRegistered<T>()) {
    sl.registerFactory<T>(factory);
  }
}
