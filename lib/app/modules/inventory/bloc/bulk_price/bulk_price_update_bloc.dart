import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/core/data/services/admin/branch_data_service.dart';
import 'package:pharmacy_system/app/modules/inventory/models/medicine_model.dart';
import 'bulk_price_update_event.dart';
import 'bulk_price_update_state.dart';

export 'bulk_price_update_event.dart';
export 'bulk_price_update_state.dart';

class BulkPriceUpdateBloc extends Bloc<BulkPriceUpdateEvent, BulkPriceUpdateState> {
  String get _branchId => AuthService.currentBranchId ?? '';
  List<MedicineModel> _cache = [];

  BulkPriceUpdateBloc() : super(const BulkPriceUpdateState()) {
    on<BulkPriceUpdateLoadCategories>(_onLoadCategories);
    on<BulkPriceUpdateApply>(_onApply);
    on<BulkPriceUpdateConfirmApply>(_onConfirmApply);
  }

  Future<void> _ensureLoaded() async {
    // ذكاء مهندسة: نستخدم الـ Repository لضمان جلب بيانات الفرع الحالي فقط
    _cache = await BranchDataService.getMedicinesAsync(branchId: _branchId);
  }

  List<String> _getCategories() {
    final cats = _cache
        .map((m) => m.category ?? 'عام')
        .where((c) => c.isNotEmpty)
        .toSet()
        .toList();
    cats.sort();
    return cats;
  }

  Future<void> _onLoadCategories(BulkPriceUpdateLoadCategories event, Emitter<BulkPriceUpdateState> emit) async {
    await _ensureLoaded();
    emit(state.copyWith(categories: _getCategories()));
  }

  void _onApply(BulkPriceUpdateApply event, Emitter<BulkPriceUpdateState> emit) {
    final filtered = event.category != null
        ? _cache.where((m) => (m.category ?? 'عام') == event.category).toList()
        : _cache;

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
          ? _cache.where((m) => (m.category ?? 'عام') == state.selectedCategory).toList()
          : _cache;

      final List<MedicineModel> updatedItems = [];

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
          updatedItems.add(m.copyWith(sellPrice: newSell, buyPrice: newBuy));
        }
      }

      if (updatedItems.isNotEmpty) {
        await BranchDataService.batchUpdateMedicines(updatedItems);
      }

      emit(state.copyWith(
        isLoading: false,
        isSuccess: true,
        affectedCount: updatedItems.length,
        message: 'تم تحديث أسعار ${updatedItems.length} صنف بنجاح وترحيلها للسحابة',
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

