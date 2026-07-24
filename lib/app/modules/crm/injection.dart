import 'package:get_it/get_it.dart';
import 'bloc/crm_bloc.dart';

final sl = GetIt.instance;

void registerCrmDependencies() {
  sl.allowReassignment = true;
  _fac<CrmBloc>(() => CrmBloc());
}

void _fac<T extends Object>(T Function() factory) {
  if (!sl.isRegistered<T>()) {
    sl.registerFactory<T>(factory);
  }
}


