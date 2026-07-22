import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pharmacy_system/app/modules/activity_log/views/activity_log_view.dart';
import 'package:pharmacy_system/app/modules/admin/bloc/branches_bloc.dart';
import 'package:pharmacy_system/app/modules/admin/bloc/employees_bloc.dart';
import 'package:pharmacy_system/app/modules/admin/bloc/settings_bloc.dart';
import 'package:pharmacy_system/app/modules/admin/views/admin_dashboard.dart';
import 'package:pharmacy_system/app/modules/admin/views/branches_management.dart';
import 'package:pharmacy_system/app/modules/admin/views/document_control_view.dart';
import 'package:pharmacy_system/app/modules/admin/views/employees_management.dart';
import 'package:pharmacy_system/app/modules/admin/views/permissions_management.dart';
import 'package:pharmacy_system/app/modules/admin/views/settings_view.dart';
import 'package:pharmacy_system/app/modules/admin/views/user_profile_view.dart';
import 'package:pharmacy_system/app/modules/employee/views/employee_dashboard.dart';

import 'package:pharmacy_system/app/core/injection.dart';

import 'package:pharmacy_system/app/routes/app_routes.dart';
import 'package:pharmacy_system/app/routes/sub_routes/auth_routes.dart';

final List<RouteBase> adminRoutes = [
  GoRoute(
    path: Routes.ADMIN_DASHBOARD,
    name: 'admin_dashboard',
    pageBuilder: (context, state) => fadePage(
      state,
      BlocProvider(
        create: (_) => sl<BranchesBloc>(),
        child: const AdminDashboardView(),
      ),
    ),
  ),
  GoRoute(
    path: Routes.EMPLOYEES,
    name: 'employees',
    pageBuilder: (context, state) => fadePage(
      state,
      BlocProvider(
        create: (_) => sl<EmployeesBloc>()..add(const LoadEmployees()),
        child: const EmployeesManagementView(),
      ),
    ),
  ),
  GoRoute(
    path: Routes.BRANCHES,
    name: 'branches',
    pageBuilder: (context, state) => fadePage(
      state,
      BlocProvider(
        create: (_) => sl<BranchesBloc>(),
        child: const BranchesManagementView(),
      ),
    ),
  ),
  GoRoute(
    path: Routes.PERMISSIONS,
    name: 'permissions',
    pageBuilder: (context, state) => fadePage(
      state,
      BlocProvider(
        create: (_) => sl<EmployeesBloc>()..add(const LoadEmployees()),
        child: const PermissionsManagementView(),
      ),
    ),
  ),
  GoRoute(
    path: Routes.SETTINGS,
    name: 'settings',
    pageBuilder: (context, state) => fadePage(
      state,
      BlocProvider(
        create: (_) => sl<SettingsBloc>(),
        child: const SettingsView(),
      ),
    ),
  ),
  GoRoute(
    path: Routes.PROFILE,
    name: 'profile',
    pageBuilder: (context, state) => fadePage(state, const UserProfileView()),
  ),
  GoRoute(
    path: Routes.EMPLOYEE_DASHBOARD,
    name: 'employee_dashboard',
    pageBuilder: (context, state) => fadePage(state, const EmployeeDashboardView()),
  ),
  GoRoute(
    path: Routes.DOCUMENT_CONTROL,
    name: 'document_control',
    pageBuilder: (context, state) => fadePage(state, const DocumentControlView()),
  ),
  GoRoute(
    path: Routes.ACTIVITY_LOG,
    name: 'activity_log',
    pageBuilder: (context, state) => fadePage(state, const ActivityLogView()),
  ),
];