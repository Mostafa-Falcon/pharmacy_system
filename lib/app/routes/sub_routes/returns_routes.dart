import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pharmacy_system/app/modules/returns/bloc/purchase_return_bloc.dart';
import 'package:pharmacy_system/app/modules/returns/bloc/sales_return_bloc.dart';
import 'package:pharmacy_system/app/modules/returns/views/add_purchase_return_view.dart';
import 'package:pharmacy_system/app/modules/returns/views/purchase_return_list_view.dart';
import 'package:pharmacy_system/app/modules/returns/views/sales_return_view.dart';

import 'package:pharmacy_system/app/core/injection.dart';

import 'package:pharmacy_system/app/routes/app_routes.dart';
import 'package:pharmacy_system/app/routes/sub_routes/auth_routes.dart';

final List<RouteBase> returnsRoutes = [
  GoRoute(
    path: Routes.SALES_RETURN,
    name: 'sales_return',
    pageBuilder: (context, state) => fadePage(
      state,
      BlocProvider(
        create: (_) => sl<SalesReturnBloc>(),
        child: const SalesReturnView(),
      ),
    ),
  ),
  GoRoute(
    path: Routes.PURCHASE_RETURN,
    name: 'purchase_return',
    pageBuilder: (context, state) => fadePage(
      state,
      BlocProvider(
        create: (_) => sl<PurchaseReturnBloc>(),
        child: const PurchaseReturnListView(),
      ),
    ),
  ),
  GoRoute(
    path: Routes.PURCHASE_RETURN_ADD,
    name: 'purchase_return_add',
    pageBuilder: (context, state) => fadePage(
      state,
      BlocProvider(
        create: (_) => sl<PurchaseReturnBloc>(),
        child: const AddPurchaseReturnView(),
      ),
    ),
  ),
];