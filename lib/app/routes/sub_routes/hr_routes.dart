import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pharmacy_system/app/modules/hr/bloc/hr_bloc.dart';
import 'package:pharmacy_system/app/modules/hr/views/hr_shell_view.dart';
import 'package:pharmacy_system/app/core/injection.dart';
import 'package:pharmacy_system/app/routes/app_routes.dart';
import 'package:pharmacy_system/app/routes/sub_routes/auth_routes.dart';

final List<RouteBase> hrRoutes = [
  GoRoute(
    path: Routes.HR,
    name: 'hr',
    pageBuilder: (context, state) => fadePage(
      state,
      BlocProvider(create: (_) => sl<HrBloc>(), child: const HrShellView()),
    ),
  ),
  GoRoute(
    path: Routes.HR_EMPLOYEES,
    name: 'hr_employees',
    pageBuilder: (context, state) => fadePage(
      state,
      BlocProvider(create: (_) => sl<HrBloc>(), child: const HrShellView()),
    ),
  ),
  GoRoute(
    path: Routes.HR_ATTENDANCE,
    name: 'hr_attendance',
    pageBuilder: (context, state) => fadePage(
      state,
      BlocProvider(create: (_) => sl<HrBloc>(), child: const HrShellView()),
    ),
  ),
  GoRoute(
    path: Routes.HR_LEAVE,
    name: 'hr_leave',
    pageBuilder: (context, state) => fadePage(
      state,
      BlocProvider(create: (_) => sl<HrBloc>(), child: const HrShellView()),
    ),
  ),
  GoRoute(
    path: Routes.HR_PAYROLL,
    name: 'hr_payroll',
    pageBuilder: (context, state) => fadePage(
      state,
      BlocProvider(create: (_) => sl<HrBloc>(), child: const HrShellView()),
    ),
  ),
  GoRoute(
    path: Routes.HR_DEPARTMENTS,
    name: 'hr_departments',
    pageBuilder: (context, state) => fadePage(
      state,
      BlocProvider(create: (_) => sl<HrBloc>(), child: const HrShellView()),
    ),
  ),
];
