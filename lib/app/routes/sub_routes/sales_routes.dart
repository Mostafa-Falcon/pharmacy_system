import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pharmacy_system/app/modules/quotes/bloc/quotes_bloc.dart';
import 'package:pharmacy_system/app/modules/quotes/views/quotes_list_view.dart';
import 'package:pharmacy_system/app/modules/sales/bloc/cashier_shift_bloc.dart';
import 'package:pharmacy_system/app/modules/sales/bloc/sales_bloc.dart';
import 'package:pharmacy_system/app/modules/sales/views/cashier_shift_view.dart';
import 'package:pharmacy_system/app/modules/sales/views/open_shift_view.dart';
import 'package:pharmacy_system/app/modules/sales/views/pos_view.dart';
import 'package:pharmacy_system/app/modules/sales/views/sales_details_view.dart';
import 'package:pharmacy_system/app/modules/sales/views/sales_list_view.dart';

import 'package:pharmacy_system/app/core/bloc/import_data_bloc.dart';
import 'package:pharmacy_system/app/core/bloc/import_data_event.dart';
import 'package:pharmacy_system/app/core/injection.dart';
import 'package:pharmacy_system/app/core/presentation/views/import_data_view.dart';

import 'package:pharmacy_system/app/routes/app_routes.dart';
import 'package:pharmacy_system/app/routes/sub_routes/auth_routes.dart';

final List<RouteBase> salesRoutes = [
  GoRoute(
    path: Routes.SALES_POS,
    name: 'sales_pos',
    pageBuilder: (context, state) => fadePage(state, const PosView()),
  ),
  GoRoute(
    path: Routes.SALES_OPEN_SHIFT,
    name: 'sales_open_shift',
    pageBuilder: (context, state) => fadePage(state, const OpenShiftView()),
  ),
  GoRoute(
    path: Routes.SALES_CASHIER_SHIFTS,
    name: 'sales_cashier_shifts',
    pageBuilder: (context, state) => fadePage(
      state,
      BlocProvider(
        create: (_) => sl<CashierShiftBloc>(),
        child: const CashierShiftView(),
      ),
    ),
  ),
  GoRoute(
    path: Routes.SALES_LIST,
    name: 'sales_list',
    pageBuilder: (context, state) => fadePage(
      state,
      BlocProvider(
        create: (_) => sl<SalesBloc>(),
        child: const SalesListView(),
      ),
    ),
  ),
  GoRoute(
    path: Routes.SALES_DETAILS,
    name: 'sales_details',
    pageBuilder: (context, state) => fadePage(
      state,
      BlocProvider(
        create: (_) => sl<SalesBloc>(),
        child: const SalesDetailsView(),
      ),
    ),
  ),
  GoRoute(
    path: Routes.PRICE_QUOTES,
    name: 'price_quotes',
    pageBuilder: (context, state) => fadePage(
      state,
      BlocProvider(
        create: (_) => sl<QuotesBloc>(),
        child: const QuotesListView(),
      ),
    ),
  ),
  GoRoute(
    path: Routes.SALES_IMPORT,
    name: 'sales_import',
    pageBuilder: (context, state) => fadePage(
      state,
      BlocProvider(
        create: (_) => ImportDataBloc(),
        child: const ImportDataView(
          entityType: ImportEntityType.sales,
          title: 'استيراد المبيعات من Excel',
          description: 'اختر ملف Excel (xlsx) لاستيراد بيانات المبيعات.',
        ),
      ),
    ),
  ),
];