import 'package:get_it/get_it.dart';
import 'bloc/reports_bloc.dart';
import 'bloc/extra_reports_bloc.dart';

final sl = GetIt.instance;

void registerReportsDependencies() {
  sl.allowReassignment = true;
  _fac<ReportsBloc>(() => ReportsBloc());
  _fac<ExtraReportsBloc>(() => ExtraReportsBloc());
}

void _fac<T extends Object>(T Function() factory) {
  if (!sl.isRegistered<T>()) {
    sl.registerFactory<T>(factory);
  }
}
