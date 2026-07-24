import 'package:get_it/get_it.dart';
import 'bloc/employee_bloc.dart';

final sl = GetIt.instance;

void registerEmployeeDependencies() {
  sl.allowReassignment = true;
  _fac<EmployeeBloc>(() => EmployeeBloc());
}

void _fac<T extends Object>(T Function() factory) {
  if (!sl.isRegistered<T>()) {
    sl.registerFactory<T>(factory);
  }
}


