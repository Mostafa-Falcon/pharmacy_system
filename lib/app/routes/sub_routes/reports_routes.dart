import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pharmacy_system/app/modules/reports/bloc/extra_reports_bloc.dart';
import 'package:pharmacy_system/app/modules/reports/bloc/reports_bloc.dart';
import 'package:pharmacy_system/app/modules/reports/views/advanced_ledger_report_view.dart';
import 'package:pharmacy_system/app/modules/reports/views/contacts_report_view.dart';
import 'package:pharmacy_system/app/modules/reports/views/extra_reports_view.dart';
import 'package:pharmacy_system/app/modules/reports/views/profit_report_view.dart';
import 'package:pharmacy_system/app/modules/reports/views/purchase_report_view.dart';
import 'package:pharmacy_system/app/modules/reports/views/sales_report_view.dart';

import 'package:pharmacy_system/app/core/injection.dart';

import 'package:pharmacy_system/app/routes/app_routes.dart';
import 'package:pharmacy_system/app/routes/sub_routes/auth_routes.dart';

final List<RouteBase> reportsRoutes = [
  GoRoute(
    path: Routes.SALES_REPORT,
    name: 'sales_report',
    pageBuilder: (context, state) => fadePage(
      state,
      BlocProvider(
        create: (_) => sl<ReportsBloc>()..add(const LoadReport()),
        child: const SalesReportView(),
      ),
    ),
  ),
  GoRoute(
    path: Routes.CONTACTS_REPORT,
    name: 'contacts_report',
    pageBuilder: (context, state) => fadePage(
      state,
      BlocProvider(
        create: (_) => sl<ReportsBloc>()..add(const LoadReport()),
        child: const ContactsReportView(),
      ),
    ),
  ),
  GoRoute(
    path: Routes.PURCHASE_REPORT,
    name: 'purchase_report',
    pageBuilder: (context, state) => fadePage(
      state,
      BlocProvider(
        create: (_) => sl<ReportsBloc>()..add(const LoadReport()),
        child: const PurchaseReportView(),
      ),
    ),
  ),
  GoRoute(
    path: Routes.PROFIT_REPORT,
    name: 'profit_report',
    pageBuilder: (context, state) => fadePage(
      state,
      BlocProvider(
        create: (_) => sl<ReportsBloc>()..add(const LoadReport()),
        child: const ProfitReportView(),
      ),
    ),
  ),
  GoRoute(
    path: Routes.EXTRA_REPORTS,
    name: 'extra_reports',
    pageBuilder: (context, state) => fadePage(
      state,
      BlocProvider(
        create: (_) => sl<ExtraReportsBloc>()..add(const LoadExtraReport()),
        child: const ExtraReportsView(),
      ),
    ),
  ),
  GoRoute(
    path: Routes.ADVANCED_LEDGER_REPORT,
    name: 'advanced_ledger_report',
    pageBuilder: (context, state) => fadePage(state, const AdvancedLedgerReportView()),
  ),
];

