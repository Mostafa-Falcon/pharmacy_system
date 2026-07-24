import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pharmacy_system/app/modules/purchases/bloc/purchases_bloc.dart';
import 'package:pharmacy_system/app/modules/purchases/views/add_purchase_view.dart';
import 'package:pharmacy_system/app/modules/purchases/views/purchase_details_view.dart';
import 'package:pharmacy_system/app/modules/purchases/views/purchases_list_view.dart';

import 'package:pharmacy_system/app/core/injection.dart';
import 'package:pharmacy_system/app/core/models/purchases/purchase_invoice_model.dart';

import 'package:pharmacy_system/app/routes/app_routes.dart';
import 'package:pharmacy_system/app/routes/sub_routes/auth_routes.dart';

final List<RouteBase> purchasesRoutes = [
  GoRoute(
    path: Routes.PURCHASE_LIST,
    name: 'purchase_list',
    pageBuilder: (context, state) => fadePage(
      state,
      BlocProvider(
        create: (_) => sl<PurchasesBloc>(),
        child: const PurchasesListView(),
      ),
    ),
  ),
  GoRoute(
    path: Routes.PURCHASE_ADD,
    name: 'purchase_add',
    pageBuilder: (context, state) => fadePage(
      state,
      BlocProvider(
        create: (_) => sl<PurchasesBloc>(),
        child: const AddPurchaseView(),
      ),
    ),
  ),
  GoRoute(
    path: Routes.PURCHASE_DETAILS,
    name: 'purchase_details',
    pageBuilder: (context, state) => fadePage(
      state,
      BlocProvider(
        create: (_) => sl<PurchasesBloc>(),
        child: PurchaseDetailsView(purchase: state.extra as PurchaseInvoiceModel),
      ),
    ),
  ),
];




