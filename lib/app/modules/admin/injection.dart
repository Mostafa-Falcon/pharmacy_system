import 'package:get_it/get_it.dart';

import '../../core/data/services/admin/branch_service.dart';
import 'services/settings_service.dart';
import 'services/admin_service.dart';
import 'services/access_control_service.dart';
import 'bloc/branches_bloc.dart';
import 'bloc/settings_bloc.dart';
import 'bloc/employees_bloc.dart';

final sl = GetIt.instance;

void registerAdminDependencies() {
  sl.allowReassignment = true;
  _reg<BranchService>(() => BranchService());
  _reg<SettingsService>(() => SettingsService());
  _reg<AdminService>(() => AdminService());
  _reg<AccessControlService>(() => AccessControlService());
  _fac<BranchesBloc>(() => BranchesBloc());
  _fac<SettingsBloc>(() => SettingsBloc());
  _fac<EmployeesBloc>(() => EmployeesBloc());
}

void _reg<T extends Object>(T Function() factory) {
  if (!sl.isRegistered<T>()) {
    sl.registerLazySingleton<T>(factory);
  }
}

void _fac<T extends Object>(T Function() factory) {
  if (!sl.isRegistered<T>()) {
    sl.registerFactory<T>(factory);
  }
}


