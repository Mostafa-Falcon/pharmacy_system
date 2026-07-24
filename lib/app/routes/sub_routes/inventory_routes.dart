import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pharmacy_system/app/modules/inventory/bloc/barcode_label_bloc.dart';
import 'package:pharmacy_system/app/modules/inventory/bloc/barcode_settings_bloc.dart';
import 'package:pharmacy_system/app/modules/inventory/bloc/brands_bloc.dart';
import 'package:pharmacy_system/app/modules/inventory/bloc/bulk_price/bulk_price_update_bloc.dart';
import 'package:pharmacy_system/app/modules/inventory/bloc/import_medicines_bloc.dart';
import 'package:pharmacy_system/app/modules/inventory/bloc/import_medicines_event.dart';
import 'package:pharmacy_system/app/modules/inventory/bloc/items_archive_bloc.dart';
import 'package:pharmacy_system/app/modules/inventory/bloc/medicines_bloc.dart';
import 'package:pharmacy_system/app/modules/inventory/bloc/price_groups_bloc.dart';
import 'package:pharmacy_system/app/modules/inventory/bloc/promotions/promotions_bloc.dart';
import 'package:pharmacy_system/app/modules/inventory/bloc/stock_transfer_bloc.dart';
import 'package:pharmacy_system/app/modules/inventory/views/add_medicine_view.dart';
import 'package:pharmacy_system/app/modules/inventory/views/add_stock_transfer_view.dart';
import 'package:pharmacy_system/app/modules/inventory/views/barcode_label_view.dart';
import 'package:pharmacy_system/app/modules/inventory/views/barcode_settings_view.dart';
import 'package:pharmacy_system/app/modules/inventory/views/brands_view.dart';
import 'package:pharmacy_system/app/modules/inventory/views/bulk_price_update_view.dart';
import 'package:pharmacy_system/app/modules/inventory/views/edit_medicine_view.dart';
import 'package:pharmacy_system/app/modules/inventory/views/import_medicines_view.dart';
import 'package:pharmacy_system/app/modules/inventory/views/inventory_health_view.dart';
import 'package:pharmacy_system/app/modules/inventory/views/items_archive_view.dart';
import 'package:pharmacy_system/app/modules/inventory/views/medicines_list_view.dart';
import 'package:pharmacy_system/app/modules/inventory/views/price_groups_view.dart';
import 'package:pharmacy_system/app/modules/inventory/views/promotions_view.dart';
import 'package:pharmacy_system/app/modules/inventory/views/stock_adjustment_view.dart';
import 'package:pharmacy_system/app/modules/inventory/views/stock_transfer_view.dart';
import 'package:pharmacy_system/app/modules/inventory/views/variants_view.dart';

import 'package:pharmacy_system/app/core/injection.dart';
import 'package:pharmacy_system/app/core/data/services/admin/branch_data_service.dart';
import 'package:pharmacy_system/app/core/models/inventory/medicine_model.dart';

import 'package:pharmacy_system/app/routes/app_routes.dart';
import 'package:pharmacy_system/app/routes/sub_routes/auth_routes.dart';

final List<RouteBase> inventoryRoutes = [
  GoRoute(
    path: Routes.INVENTORY_LIST,
    name: 'inventory_list',
    pageBuilder: (context, state) => fadePage(
      state,
      BlocProvider(
        create: (_) => sl<MedicinesBloc>(),
        child: const MedicinesListView(),
      ),
    ),
  ),
  GoRoute(
    path: Routes.INVENTORY_ADD,
    name: 'inventory_add',
    pageBuilder: (context, state) => fadePage(
      state,
      BlocProvider(
        create: (_) => sl<MedicinesBloc>(),
        child: const AddMedicineView(),
      ),
    ),
  ),
  GoRoute(
    path: Routes.INVENTORY_EDIT,
    name: 'inventory_edit',
    pageBuilder: (context, state) {
      final id = state.pathParameters['id'];
      final medicine = id != null ? BranchDataService.getMedicine(id) : null;
      return fadePage(state, EditMedicineView(medicine: medicine, medicineId: id));
    },
  ),
  GoRoute(
    path: Routes.INVENTORY_HEALTH,
    name: 'inventory_health',
    pageBuilder: (context, state) => fadePage(state, const InventoryHealthView()),
  ),
  GoRoute(
    path: Routes.INVENTORY_STOCK_ADJUSTMENT,
    name: 'inventory_stock_adjustment',
    pageBuilder: (context, state) => fadePage(
      state,
      StockAdjustmentView(medicine: state.extra as MedicineModel?),
    ),
  ),
  GoRoute(
    path: Routes.BARCODE_LABELS,
    name: 'barcode_labels',
    pageBuilder: (context, state) => fadePage(
      state,
      BlocProvider(
        create: (_) => sl<BarcodeLabelBloc>(),
        child: const BarcodeLabelView(),
      ),
    ),
  ),
  GoRoute(
    path: Routes.BARCODE_SETTINGS,
    name: 'barcode_settings',
    pageBuilder: (context, state) => fadePage(
      state,
      BlocProvider(
        create: (_) => sl<BarcodeSettingsBloc>()..add(const LoadBarcodeSettings()),
        child: const BarcodeSettingsView(),
      ),
    ),
  ),
  GoRoute(
    path: Routes.INVENTORY_ARCHIVE,
    name: 'inventory_archive',
    pageBuilder: (context, state) => fadePage(
      state,
      BlocProvider(
        create: (_) => sl<ItemsArchiveBloc>()..add(const LoadItemsArchive()),
        child: const ItemsArchiveView(),
      ),
    ),
  ),
  GoRoute(
    path: Routes.INVENTORY_IMPORT,
    name: 'inventory_import',
    pageBuilder: (context, state) => fadePage(
      state,
      BlocProvider(
        create: (_) => sl<ImportMedicinesBloc>()..add(const ResetImport()),
        child: const ImportMedicinesView(),
      ),
    ),
  ),
  GoRoute(
    path: Routes.INVENTORY_IMPORT_PRODUCTS,
    name: 'inventory_import_products',
    pageBuilder: (context, state) => fadePage(
      state,
      BlocProvider(
        create: (_) => sl<ImportMedicinesBloc>()..add(const ResetImport()),
        child: const ImportMedicinesView(),
      ),
    ),
  ),
  GoRoute(
    path: Routes.STOCK_TRANSFER,
    name: 'stock_transfer',
    pageBuilder: (context, state) => fadePage(
      state,
      BlocProvider(
        create: (_) => sl<StockTransferBloc>()..add(const LoadStockTransfers()),
        child: const StockTransferView(),
      ),
    ),
  ),
  GoRoute(
    path: Routes.STOCK_TRANSFER_ADD,
    name: 'stock_transfer_add',
    pageBuilder: (context, state) => fadePage(
      state,
      BlocProvider(
        create: (_) => sl<StockTransferBloc>()..add(const LoadStockTransfers()),
        child: const AddStockTransferView(),
      ),
    ),
  ),
  GoRoute(
    path: Routes.BRANDS,
    name: 'brands',
    pageBuilder: (context, state) => fadePage(
      state,
      BlocProvider(
        create: (_) => sl<BrandsBloc>(),
        child: const BrandsView(),
      ),
    ),
  ),
  GoRoute(
    path: Routes.PRICE_GROUPS,
    name: 'price_groups',
    pageBuilder: (context, state) => fadePage(
      state,
      BlocProvider(
        create: (_) => sl<PriceGroupsBloc>()..add(const LoadPriceGroups()),
        child: const PriceGroupsView(),
      ),
    ),
  ),
  GoRoute(
    path: Routes.VARIANTS,
    name: 'variants',
    pageBuilder: (context, state) => fadePage(
      state,
      BlocProvider(
        create: (_) => sl<BarcodeLabelBloc>(),
        child: const VariantsView(),
      ),
    ),
  ),
  GoRoute(
    path: Routes.INVENTORY_BULK_PRICE_UPDATE,
    name: 'inventory_bulk_price_update',
    pageBuilder: (context, state) => fadePage(
      state,
      BlocProvider(
        create: (_) => BulkPriceUpdateBloc(),
        child: const BulkPriceUpdateView(),
      ),
    ),
  ),
  GoRoute(
    path: Routes.INVENTORY_PROMOTIONS,
    name: 'inventory_promotions',
    pageBuilder: (context, state) => fadePage(
      state,
      BlocProvider(
        create: (_) => PromotionsBloc(),
        child: const PromotionsView(),
      ),
    ),
  ),
];



