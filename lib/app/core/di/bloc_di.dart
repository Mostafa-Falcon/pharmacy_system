import 'package:get_it/get_it.dart';

import '../bloc/import_data_bloc.dart';

final sl = GetIt.instance;

void registerCoreBlocDependencies() {
  sl.allowReassignment = true;
  _reg<ImportDataBloc>(() => ImportDataBloc());
}

void _reg<T extends Object>(T Function() factory) {
  if (!sl.isRegistered<T>()) {
    sl.registerLazySingleton<T>(factory);
  }
}


