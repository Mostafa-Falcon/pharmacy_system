import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pharmacy_system/app/modules/accounting/bloc/accounting_bloc.dart';
import 'package:pharmacy_system/app/modules/accounting/bloc/party_payments_bloc.dart';
import 'package:pharmacy_system/app/modules/accounting/views/accounting_shell_view.dart';

import 'package:pharmacy_system/app/core/bloc/import_data_bloc.dart';
import 'package:pharmacy_system/app/core/bloc/import_data_event.dart';
import 'package:pharmacy_system/app/core/injection.dart';
import 'package:pharmacy_system/app/shared/presentation/views/import_data_view.dart';

import 'package:pharmacy_system/app/routes/app_routes.dart';
import 'package:pharmacy_system/app/routes/sub_routes/auth_routes.dart';

final List<RouteBase> accountingRoutes = [
  GoRoute(
    path: Routes.ACCOUNTING,
    name: 'accounting',
    pageBuilder: (context, state) => fadePage(
      state,
      BlocProvider(
        create: (_) => sl<AccountingBloc>(),
        child: BlocProvider(
          create: (_) => sl<PartyPaymentsBloc>(),
          child: const AccountingShellView(),
        ),
      ),
    ),
  ),
  GoRoute(
    path: Routes.ACCOUNTING_ACCOUNTS,
    name: 'accounting_accounts',
    pageBuilder: (context, state) => fadePage(
      state,
      MultiBlocProvider(
        providers: [
          BlocProvider.value(value: sl<AccountingBloc>()),
          BlocProvider.value(value: sl<PartyPaymentsBloc>()),
        ],
        child: const AccountingShellView(),
      ),
    ),
  ),
  GoRoute(
    path: Routes.ACCOUNTING_JOURNAL,
    name: 'accounting_journal',
    pageBuilder: (context, state) => fadePage(
      state,
      MultiBlocProvider(
        providers: [
          BlocProvider.value(value: sl<AccountingBloc>()),
          BlocProvider.value(value: sl<PartyPaymentsBloc>()),
        ],
        child: const AccountingShellView(),
      ),
    ),
  ),
  GoRoute(
    path: Routes.ACCOUNTING_EXPENSES,
    name: 'accounting_expenses',
    pageBuilder: (context, state) => fadePage(
      state,
      MultiBlocProvider(
        providers: [
          BlocProvider.value(value: sl<AccountingBloc>()),
          BlocProvider.value(value: sl<PartyPaymentsBloc>()),
        ],
        child: const AccountingShellView(),
      ),
    ),
  ),
  GoRoute(
    path: Routes.ACCOUNTING_PAYMENTS,
    name: 'accounting_payments',
    pageBuilder: (context, state) => fadePage(
      state,
      MultiBlocProvider(
        providers: [
          BlocProvider.value(value: sl<AccountingBloc>()),
          BlocProvider.value(value: sl<PartyPaymentsBloc>()),
        ],
        child: const AccountingShellView(),
      ),
    ),
  ),
  GoRoute(
    path: Routes.ACCOUNTING_EXPENSES_IMPORT,
    name: 'accounting_expenses_import',
    pageBuilder: (context, state) => fadePage(
      state,
      BlocProvider(
        create: (_) => ImportDataBloc(),
        child: const ImportDataView(
          entityType: ImportEntityType.expenses,
          title: 'استيراد المصاريف من Excel',
          description: 'اختر ملف Excel (xlsx) لاستيراد بيانات المصاريف.',
        ),
      ),
    ),
  ),
];


