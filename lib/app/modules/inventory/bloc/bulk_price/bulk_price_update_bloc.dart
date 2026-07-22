import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:pharmacy_system/app/core/data/database/daos/medicines_dao.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/modules/inventory/models/medicine_model.dart';
import 'package:pharmacy_system/app/modules/inventory/models/medicine_unit_model.dart';
import 'bulk_price_update_event.dart';
import 'bulk_price_update_state.dart';

export 'bulk_price_update_event.dart';
export 'bulk_price_update_state.dart';

class BulkPriceUpdateBloc extends Bloc<BulkPriceUpdateEvent, BulkPriceUpdateState> {
  static MedicinesDao get _dao =>
      MedicinesDao(GetIt.instance<AppDatabase>());
  List<MedicineModel> _cache = [];

  BulkPriceUpdateBloc() : super(const BulkPriceUpdateState()) {
    on<BulkPriceUpdateLoadCategories>(_onLoadCategories);
    on<BulkPriceUpdateApply>(_onApply);
    on<BulkPriceUpdateConfirmApply>(_onConfirmApply);
  }

  List<MedicineModel> get _allMedicines => _cache;

  Future<void> _ensureLoaded() async {
    if (_cache.isNotEmpty) return;
    final data = await _dao.getAll();
    _cache = data
        .where((m) => !m.isDeleted)
        .map(_medicineFromData)
        .toList();
  }

  static MedicineModel _medicineFromData(MedicinesTableData d) {
    List<String> barcodes;
    try {
      barcodes = (jsonDecode(d.barcodes) as List<dynamic>)
          .map((e) => e.toString())
          .toList();
    } catch (_) {
      barcodes = d.barcodes.isNotEmpty ? [d.barcodes] : [];
    }

    List<MedicineUnitModel> units;
    try {
      units = (jsonDecode(d.units) as List<dynamic>)
          .map((e) => MedicineUnitModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      units = [];
    }

    return MedicineModel(
      id: d.id,
      name: d.name,
      nameEn: d.nameEn,
      category: d.category,
      barcodes: barcodes,
      buyPrice: d.buyPrice,
      sellPrice: d.sellPrice,
      quantity: d.quantity,
      minStock: d.minStock,
      expiryDate: d.expiryDate,
      manufacturer: d.manufacturer,
      branchId: d.branchId,
      syncVersion: d.syncVersion,
      lastModified: d.lastModified,
      isDeleted: d.isDeleted,
      dosageForm: d.dosageForm,
      strength: d.strength,
      packageSize: d.packageSize,
      expiryTrackingEnabled: d.expiryTrackingEnabled,
      supplierName: d.supplierName,
      description: d.description,
      oldSellPrice: d.oldSellPrice,
      itemTypeId: d.itemTypeId,
      groupId: d.groupId,
      units: units,
      alertEnabled: d.alertEnabled,
      dosageFormEnabled: d.dosageFormEnabled,
      imageUrl: d.imageUrl,
      containerShape: d.containerShape,
      allowNegativeStock: d.allowNegativeStock,
      isTaxable: d.isTaxable,
      taxType: d.taxType,
      taxValue: d.taxValue,
      pricesIncludeTax: d.pricesIncludeTax,
      location: d.location,
      isActive: d.isActive,
      createdAt: d.createdAt,
    );
  }

  static MedicinesTableCompanion _medicineToCompanion(MedicineModel m) {
    return MedicinesTableCompanion(
      id: Value(m.id),
      name: Value(m.name),
      nameEn: Value(m.nameEn),
      category: Value(m.category),
      barcodes: Value(jsonEncode(m.barcodes)),
      buyPrice: Value(m.buyPrice),
      sellPrice: Value(m.sellPrice),
      quantity: Value(m.quantity),
      minStock: Value(m.minStock),
      expiryDate: Value(m.expiryDate),
      manufacturer: Value(m.manufacturer),
      branchId: Value(m.branchId),
      syncVersion: Value(m.syncVersion),
      lastModified: Value(m.lastModified),
      isDeleted: Value(m.isDeleted),
      dosageForm: Value(m.dosageForm),
      strength: Value(m.strength),
      packageSize: Value(m.packageSize),
      expiryTrackingEnabled: Value(m.expiryTrackingEnabled),
      supplierName: Value(m.supplierName),
      description: Value(m.description),
      oldSellPrice: Value(m.oldSellPrice),
      itemTypeId: Value(m.itemTypeId),
      groupId: Value(m.groupId),
      units: Value(jsonEncode(m.units.map((u) => u.toJson()).toList())),
      alertEnabled: Value(m.alertEnabled),
      dosageFormEnabled: Value(m.dosageFormEnabled),
      imageUrl: Value(m.imageUrl),
      containerShape: Value(m.containerShape),
      allowNegativeStock: Value(m.allowNegativeStock),
      isTaxable: Value(m.isTaxable),
      taxType: Value(m.taxType),
      taxValue: Value(m.taxValue),
      pricesIncludeTax: Value(m.pricesIncludeTax),
      location: Value(m.location),
      isActive: Value(m.isActive),
      createdAt: Value(m.createdAt),
    );
  }

  List<String> _getCategories() {
    final cats = _allMedicines.map((m) => m.category ?? 'عام').toSet().toList();
    cats.sort();
    return cats;
  }

  Future<void> _onLoadCategories(BulkPriceUpdateLoadCategories event, Emitter<BulkPriceUpdateState> emit) async {
    await _ensureLoaded();
    emit(state.copyWith(categories: _getCategories()));
  }

  void _onApply(BulkPriceUpdateApply event, Emitter<BulkPriceUpdateState> emit) {
    final filtered = event.category != null
        ? _allMedicines.where((m) => (m.category ?? 'عام') == event.category).toList()
        : _allMedicines;

    double newValue(double original) {
      switch (event.operation) {
        case 'set':
          return event.value;
        case 'increase':
          return original + event.value;
        case 'decrease':
          return (original - event.value).clamp(0, double.infinity);
        case 'increasePercent':
          return original * (1 + event.value / 100);
        case 'decreasePercent':
          return original * (1 - event.value / 100).clamp(0, double.infinity);
        default:
          return original;
      }
    }

    int simulatedCount = 0;
    for (final m in filtered) {
      final oldSell = m.sellPrice;
      final oldBuy = m.buyPrice;
      double newSell = oldSell;
      double newBuy = oldBuy;

      if (event.field == 'sellPrice' || event.field == 'both') {
        newSell = newValue(oldSell);
      }
      if (event.field == 'buyPrice' || event.field == 'both') {
        newBuy = newValue(oldBuy);
      }

      if (newSell != oldSell || newBuy != oldBuy) {
        simulatedCount++;
      }
    }

    emit(state.copyWith(
      selectedCategory: event.category,
      selectedField: event.field,
      selectedOperation: event.operation,
      value: event.value,
      affectedCount: simulatedCount,
    ));
  }

  Future<void> _onConfirmApply(BulkPriceUpdateConfirmApply event, Emitter<BulkPriceUpdateState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final filtered = state.selectedCategory != null
          ? _allMedicines.where((m) => (m.category ?? 'عام') == state.selectedCategory).toList()
          : _allMedicines;

      int count = 0;

      for (final m in filtered) {
        final oldSell = m.sellPrice;
        final oldBuy = m.buyPrice;
        double newSell = oldSell;
        double newBuy = oldBuy;

        switch (state.selectedOperation) {
          case 'set':
            if (state.selectedField == 'sellPrice' || state.selectedField == 'both') newSell = state.value;
            if (state.selectedField == 'buyPrice' || state.selectedField == 'both') newBuy = state.value;
          case 'increase':
            if (state.selectedField == 'sellPrice' || state.selectedField == 'both') newSell = oldSell + state.value;
            if (state.selectedField == 'buyPrice' || state.selectedField == 'both') newBuy = oldBuy + state.value;
          case 'decrease':
            if (state.selectedField == 'sellPrice' || state.selectedField == 'both') newSell = (oldSell - state.value).clamp(0, double.infinity);
            if (state.selectedField == 'buyPrice' || state.selectedField == 'both') newBuy = (oldBuy - state.value).clamp(0, double.infinity);
          case 'increasePercent':
            if (state.selectedField == 'sellPrice' || state.selectedField == 'both') newSell = oldSell * (1 + state.value / 100);
            if (state.selectedField == 'buyPrice' || state.selectedField == 'both') newBuy = oldBuy * (1 + state.value / 100);
          case 'decreasePercent':
            if (state.selectedField == 'sellPrice' || state.selectedField == 'both') newSell = oldSell * (1 - state.value / 100).clamp(0, double.infinity);
            if (state.selectedField == 'buyPrice' || state.selectedField == 'both') newBuy = oldBuy * (1 - state.value / 100).clamp(0, double.infinity);
        }

        if (newSell != oldSell || newBuy != oldBuy) {
          final updated = m.copyWith(sellPrice: newSell, buyPrice: newBuy);
          await _dao.upsert(_medicineToCompanion(updated));
          count++;
        }
      }

      emit(state.copyWith(
        isLoading: false,
        isSuccess: true,
        affectedCount: count,
        message: 'تم تحديث أسعار $count صنف بنجاح',
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        isSuccess: false,
        message: 'فشل التحديث: $e',
      ));
    }
  }
}

