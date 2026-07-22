import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pharmacy_system/app/modules/auth/bloc/auth_bloc.dart';

import 'package:pharmacy_system/app/core/injection.dart';
import 'package:pharmacy_system/app/core/navigation/route_cubit.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';

import 'app_routes.dart';
import 'route_access_policy.dart';
import 'sub_routes/accounting_routes.dart';
import 'sub_routes/admin_routes.dart';
import 'sub_routes/auth_routes.dart';
import 'sub_routes/contacts_routes.dart';
import 'sub_routes/home_routes.dart';
import 'sub_routes/hr_routes.dart';
import 'sub_routes/inventory_routes.dart';
import 'sub_routes/ops_routes.dart';
import 'sub_routes/purchases_routes.dart';
import 'sub_routes/reports_routes.dart';
import 'sub_routes/returns_routes.dart';
import 'sub_routes/sales_routes.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: Routes.SPLASH,
    debugLogDiagnostics: false,
    refreshListenable: _GoRouterRefreshStream(sl<AuthBloc>().stream),
    redirect: _guard,
    routes: _routes,
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text(
          'خطأ في التنقل: ${state.error}',
          style: const TextStyle(fontFamily: 'Cairo'),
        ),
      ),
    ),
    observers: [_RouteObserver()],
  );

  static String? _guard(BuildContext context, GoRouterState state) {
    final route = state.matchedLocation;
    final authState = sl<AuthBloc>().state;
    final user = authState.user ?? AuthService.currentUser;

    if (user == null || authState.status == AuthStatus.unauthenticated) {
      if (route != Routes.LOGIN &&
          route != Routes.SIGNUP &&
          route != Routes.FORGOT_PASSWORD &&
          route != Routes.SPLASH &&
          route != Routes.AUTH_CALLBACK) {
        return Routes.LOGIN;
      }
      return null;
    }

    if (route == Routes.LOGIN || route == Routes.SIGNUP) {
      if (user.isOwner) return Routes.HOME;
      return Routes.EMPLOYEE_DASHBOARD;
    }

    final requiredPermission = RouteAccessPolicy.permissionForRoute(route);
    if (requiredPermission != null &&
        !AuthService.hasPermission(requiredPermission)) {
      return Routes.HOME;
    }

    final isOwnerOnly = RouteAccessPolicy.ownerOnlyDestinations.any(
      (dest) => route.contains(dest),
    );
    if (isOwnerOnly && !user.isOwner) {
      return Routes.HOME;
    }

    if (route == Routes.ADMIN_DASHBOARD && user.isOwner) {
      return Routes.HOME;
    }

    return null;
  }

  static List<RouteBase> get _routes => [
    ...authRoutes,
    ...homeRoutes,
    ...adminRoutes,
    ...salesRoutes,
    ...inventoryRoutes,
    ...contactsRoutes,
    ...purchasesRoutes,
    ...returnsRoutes,
    ...hrRoutes,
    ...accountingRoutes,
    ...reportsRoutes,
    ...opsRoutes,
  ];
}

class _RouteObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _notify(route);
    super.didPush(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (newRoute != null) _notify(newRoute);
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (previousRoute != null) _notify(previousRoute);
    super.didPop(route, previousRoute);
  }

  void _notify(Route<dynamic> route) {
    final name = route.settings.name;
    if (name != null && name.isNotEmpty) {
      routeCubit.setRoute(name);
    }
  }
}

class _GoRouterRefreshStream extends ChangeNotifier {
  _GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}