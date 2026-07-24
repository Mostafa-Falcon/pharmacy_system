import 'package:get_it/get_it.dart';
import 'bloc/monitoring_dashboard_bloc.dart';

final sl = GetIt.instance;

void registerHomeDependencies() {
  sl.allowReassignment = true;
  _fac<MonitoringDashboardBloc>(() => MonitoringDashboardBloc());
}

void _fac<T extends Object>(T Function() factory) {
  if (!sl.isRegistered<T>()) {
    sl.registerFactory<T>(factory);
  }
}


