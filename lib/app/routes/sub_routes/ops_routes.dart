import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pharmacy_system/app/modules/archive/views/archive_dashboard_view.dart';
import 'package:pharmacy_system/app/modules/crm/bloc/crm_bloc.dart';
import 'package:pharmacy_system/app/modules/crm/views/crm_view.dart';
import 'package:pharmacy_system/app/modules/notifications/views/notifications_center_view.dart';
import 'package:pharmacy_system/app/modules/stocktaking/bloc/stocktaking_bloc.dart';
import 'package:pharmacy_system/app/modules/stocktaking/views/stocktaking_detail_view.dart';
import 'package:pharmacy_system/app/modules/stocktaking/views/stocktaking_list_view.dart';
import 'package:pharmacy_system/app/modules/sync/views/sync_status_view.dart';
import 'package:pharmacy_system/app/modules/tasks/bloc/tasks_bloc.dart';
import 'package:pharmacy_system/app/modules/tasks/views/tasks_view.dart';
import 'package:pharmacy_system/app/modules/void_operations/bloc/void_operations_bloc.dart';
import 'package:pharmacy_system/app/modules/void_operations/views/void_operations_view.dart';

import 'package:pharmacy_system/app/core/injection.dart';

import 'package:pharmacy_system/app/routes/app_routes.dart';
import 'package:pharmacy_system/app/routes/sub_routes/auth_routes.dart';

final List<RouteBase> opsRoutes = [
  GoRoute(
    path: Routes.CRM,
    name: 'crm',
    pageBuilder: (context, state) => fadePage(
      state,
      BlocProvider(create: (_) => sl<CrmBloc>(), child: const CrmView()),
    ),
  ),
  GoRoute(
    path: Routes.NOTIFICATIONS,
    name: 'notifications',
    pageBuilder: (context, state) => fadePage(state, const NotificationsCenterView()),
  ),
  GoRoute(
    path: Routes.SYNC_STATUS,
    name: 'sync_status',
    pageBuilder: (context, state) => fadePage(state, const SyncStatusView()),
  ),
  GoRoute(
    path: Routes.TASKS,
    name: 'tasks',
    pageBuilder: (context, state) => fadePage(
      state,
      BlocProvider(
        create: (_) => sl<TasksBloc>()..add(LoadTasks()),
        child: const TasksView(),
      ),
    ),
  ),
  GoRoute(
    path: Routes.STOCKTAKING,
    name: 'stocktaking',
    pageBuilder: (context, state) => fadePage(
      state,
      BlocProvider.value(
        value: sl<StocktakingBloc>()..add(LoadStocktakingPeriods()),
        child: const StocktakingListView(),
      ),
    ),
  ),
  GoRoute(
    path: Routes.STOCKTAKING_DETAIL,
    name: 'stocktaking_detail',
    pageBuilder: (context, state) {
      final periodId = state.uri.queryParameters['periodId'] ?? '';
      return fadePage(
        state,
        BlocProvider.value(
          value: sl<StocktakingBloc>()..add(LoadStocktakingCounts(periodId)),
          child: StocktakingDetailView(periodId: periodId),
        ),
      );
    },
  ),
  GoRoute(
    path: Routes.VOID_OPERATIONS,
    name: 'void_operations',
    pageBuilder: (context, state) => fadePage(
      state,
      BlocProvider(
        create: (_) => sl<VoidOperationsBloc>()..add(LoadVoidOperations()),
        child: const VoidOperationsView(),
      ),
    ),
  ),
  GoRoute(
    path: Routes.ARCHIVE,
    name: 'archive',
    pageBuilder: (context, state) => fadePage(state, const ArchiveDashboardView()),
  ),
];

