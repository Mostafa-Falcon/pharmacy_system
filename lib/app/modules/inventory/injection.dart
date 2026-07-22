import 'dart:async';

import 'package:get_it/get_it.dart';

import '../../core/data/services/inventory/batch_service.dart';
import '../../core/data/services/inventory/stocktaking_service.dart';
import 'services/inventory_transaction_service.dart';
import 'services/inventory_reconciliation_service.dart';
import 'services/inventory_projection_service.dart';
import 'bloc/medicines_bloc.dart';
import 'bloc/import_medicines_bloc.dart';
import 'bloc/brands_bloc.dart';
import 'bloc/price_groups_bloc.dart';
import 'bloc/barcode_label_bloc.dart';
import 'bloc/stock_transfer_bloc.dart';
import 'bloc/barcode_settings_bloc.dart';
import 'bloc/items_archive_bloc.dart';
import 'bloc/bulk_price/bulk_price_update_bloc.dart';

final sl = GetIt.instance;

void registerInventoryDependencies() {
  sl.allowReassignment = true;
  if (!sl.isRegistered<BatchService>()) {
    final s = BatchService();
    sl.registerSingleton<BatchService>(s);
    unawaited(s.init());
  }
  if (!sl.isRegistered<StocktakingService>()) {
    sl.registerSingleton<StocktakingService>(StocktakingService());
  }
  _reg<InventoryTransactionService>(() => InventoryTransactionService());
  _reg<InventoryReconciliationService>(() => InventoryReconciliationService());
  _reg<InventoryProjectionService>(() => InventoryProjectionService());
  _fac<MedicinesBloc>(() => MedicinesBloc());
  _fac<ImportMedicinesBloc>(() => ImportMedicinesBloc());
  _fac<BrandsBloc>(() => BrandsBloc());
  _fac<PriceGroupsBloc>(() => PriceGroupsBloc());
  _fac<BarcodeLabelBloc>(() => BarcodeLabelBloc());
  _fac<StockTransferBloc>(() => StockTransferBloc());
  _fac<BarcodeSettingsBloc>(() => BarcodeSettingsBloc());
  _fac<ItemsArchiveBloc>(() => ItemsArchiveBloc());
  _fac<BulkPriceUpdateBloc>(() => BulkPriceUpdateBloc());
}

void _reg<T extends Object>(T Function() factory) {
  if (!sl.isRegistered<T>()) {
    sl.registerLazySingleton<T>(factory);
  }
}

void _fac<T extends Object>(T Function() factory) {
  if (!sl.isRegistered<T>()) {
    sl.registerFactory<T>(factory);
  }
}
