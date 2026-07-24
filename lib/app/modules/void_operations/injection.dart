import 'package:get_it/get_it.dart';
import '../../core/data/services/operations/void_operations_service.dart';
import 'bloc/void_operations_bloc.dart';

final sl = GetIt.instance;

void registerVoidOperationsDependencies() {
  sl.allowReassignment = true;
  if (!sl.isRegistered<VoidOperationsService>()) {
    sl.registerSingleton<VoidOperationsService>(VoidOperationsService());
  }
  _fac<VoidOperationsBloc>(() => VoidOperationsBloc());
}

void _fac<T extends Object>(T Function() factory) {
  if (!sl.isRegistered<T>()) {
    sl.registerFactory<T>(factory);
  }
}


