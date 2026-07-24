import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pharmacy_system/app/modules/layout/views/home_dashboard_view.dart';

import '../app_routes.dart';

Page<void> fadePage(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(opacity: animation, child: child),
  );
}

final List<RouteBase> homeRoutes = [
  GoRoute(
    path: Routes.HOME,
    name: 'home',
    pageBuilder: (context, state) => fadePage(state, const HomeDashboardView()),
  ),
  GoRoute(
    path: Routes.MAIN_PAGE,
    name: 'main-page',
    pageBuilder: (context, state) => fadePage(state, const HomeDashboardView()),
  ),
  GoRoute(
    path: Routes.MONITORING_DASHBOARD,
    name: 'monitoring',
    pageBuilder: (context, state) => fadePage(state, const HomeDashboardView()),
  ),
];
