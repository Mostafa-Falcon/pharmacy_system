import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pharmacy_system/app/modules/contacts/customer_groups/bloc/customer_groups_bloc.dart';
import 'package:pharmacy_system/app/modules/contacts/customer_groups/views/customer_groups_view.dart';
import 'package:pharmacy_system/app/modules/contacts/supplier_customers/bloc/supplier_customers_bloc.dart';
import 'package:pharmacy_system/app/modules/contacts/supplier_customers/views/add_supplier_customer_view.dart';
import 'package:pharmacy_system/app/modules/contacts/supplier_customers/views/supplier_customers_list_view.dart';
import 'package:pharmacy_system/app/modules/contacts/customers/bloc/customers_bloc.dart';
import 'package:pharmacy_system/app/modules/contacts/customers/views/add_customer_view.dart';
import 'package:pharmacy_system/app/modules/contacts/customers/views/customers_list_view.dart';
import 'package:pharmacy_system/app/modules/contacts/suppliers/bloc/suppliers_bloc.dart';
import 'package:pharmacy_system/app/modules/contacts/suppliers/views/add_supplier_view.dart';
import 'package:pharmacy_system/app/modules/contacts/suppliers/views/suppliers_list_view.dart';

import 'package:pharmacy_system/app/core/bloc/import_data_bloc.dart';
import 'package:pharmacy_system/app/core/bloc/import_data_event.dart';
import 'package:pharmacy_system/app/core/injection.dart';
import 'package:pharmacy_system/app/core/presentation/views/import_data_view.dart';

import 'package:pharmacy_system/app/routes/app_routes.dart';
import 'package:pharmacy_system/app/routes/sub_routes/auth_routes.dart';

final List<RouteBase> contactsRoutes = [
  GoRoute(
    path: Routes.CUSTOMERS,
    name: 'customers',
    pageBuilder: (context, state) => fadePage(
      state,
      BlocProvider(
        create: (_) => sl<CustomersBloc>(),
        child: const CustomersListView(),
      ),
    ),
  ),
  GoRoute(
    path: Routes.CUSTOMER_ADD,
    name: 'customer_add',
    pageBuilder: (context, state) => fadePage(
      state,
      BlocProvider(
        create: (_) => sl<CustomersBloc>(),
        child: const AddCustomerView(),
      ),
    ),
  ),
  GoRoute(
    path: Routes.CUSTOMERS_IMPORT,
    name: 'customers_import',
    pageBuilder: (context, state) => fadePage(
      state,
      BlocProvider(
        create: (_) => ImportDataBloc(),
        child: const ImportDataView(
          entityType: ImportEntityType.customers,
          title: 'استيراد العملاء من Excel',
          description: 'اختر ملف Excel (xlsx) لاستيراد بيانات العملاء.',
        ),
      ),
    ),
  ),
  GoRoute(
    path: Routes.SUPPLIERS,
    name: 'suppliers',
    pageBuilder: (context, state) => fadePage(
      state,
      BlocProvider(
        create: (_) => sl<SuppliersBloc>(),
        child: const SuppliersListView(),
      ),
    ),
  ),
  GoRoute(
    path: Routes.SUPPLIER_ADD,
    name: 'supplier_add',
    pageBuilder: (context, state) => fadePage(
      state,
      BlocProvider(
        create: (_) => sl<SuppliersBloc>(),
        child: const AddSupplierView(),
      ),
    ),
  ),
  GoRoute(
    path: Routes.SUPPLIERS_IMPORT,
    name: 'suppliers_import',
    pageBuilder: (context, state) => fadePage(
      state,
      BlocProvider(
        create: (_) => ImportDataBloc(),
        child: const ImportDataView(
          entityType: ImportEntityType.suppliers,
          title: 'استيراد الموردين من Excel',
          description: 'اختر ملف Excel (xlsx) لاستيراد بيانات الموردين.',
        ),
      ),
    ),
  ),
  GoRoute(
    path: Routes.CUSTOMER_GROUPS,
    name: 'customer_groups',
    pageBuilder: (context, state) => fadePage(
      state,
      BlocProvider(
        create: (_) => sl<CustomerGroupsBloc>(),
        child: const CustomerGroupsView(),
      ),
    ),
  ),
  GoRoute(
    path: Routes.SUPPLIER_CUSTOMERS,
    name: 'supplier_customers',
    pageBuilder: (context, state) => fadePage(
      state,
      BlocProvider(
        create: (_) => sl<SupplierCustomersBloc>(),
        child: const SupplierCustomersListView(),
      ),
    ),
  ),
  GoRoute(
    path: Routes.SUPPLIER_CUSTOMER_ADD,
    name: 'supplier_customer_add',
    pageBuilder: (context, state) => fadePage(
      state,
      BlocProvider(
        create: (_) => sl<SupplierCustomersBloc>(),
        child: const AddSupplierCustomerView(),
      ),
    ),
  ),
];