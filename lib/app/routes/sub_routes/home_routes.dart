import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pharmacy_system/app/modules/home/bloc/monitoring_dashboard_bloc.dart';
import 'package:pharmacy_system/app/modules/home/views/home_view.dart';
import 'package:pharmacy_system/app/modules/home/views/main_page_view.dart';

import 'package:pharmacy_system/app/core/injection.dart';

import 'package:pharmacy_system/app/routes/app_routes.dart';
import 'package:pharmacy_system/app/routes/sub_routes/auth_routes.dart';

final List<RouteBase> homeRoutes = [
  GoRoute(
    path: Routes.HOME,
    name: 'home',
    pageBuilder: (context, state) => fadePage(state, const MainPageView()),
  ),
  GoRoute(
    path: Routes.MAIN_PAGE,
    name: 'main_page',
    pageBuilder: (context, state) => fadePage(
      state,
      BlocProvider(
        create: (_) => sl<MonitoringDashboardBloc>(),
        child: const HomeView(),
      ),
    ),
  ),
  GoRoute(
    path: Routes.MONITORING_DASHBOARD,
    name: 'monitoring_dashboard',
    pageBuilder: (context, state) => fadePage(
      state,
      BlocProvider(
        create: (_) => sl<MonitoringDashboardBloc>(),
        child: const HomeView(),
      ),
    ),
  ),
];

