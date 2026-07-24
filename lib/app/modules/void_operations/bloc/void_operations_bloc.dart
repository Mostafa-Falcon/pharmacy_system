import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pharmacy_system/app/core/data/services/operations/void_operations_service.dart';

import 'void_operations_event.dart';
import 'void_operations_state.dart';

export 'void_operations_event.dart';
export 'void_operations_state.dart';

class VoidOperationsBloc
    extends Bloc<VoidOperationsEvent, VoidOperationsState> {
  final VoidOperationsService service;

  VoidOperationsBloc({VoidOperationsService? opsService})
    : service = opsService ?? VoidOperationsService.to,
      super(const VoidOperationsState()) {
    on<LoadVoidOperations>(_onLoad);
    on<VoidSale>(_onVoidSale);
    on<VoidPurchase>(_onVoidPurchase);
    add(LoadVoidOperations());
  }

  Future<void> _onLoad(
    LoadVoidOperations event,
    Emitter<VoidOperationsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    emit(
      state.copyWith(
        voidableSales: service.getVoidableSales(),
        voidablePurchases: service.getVoidablePurchases(),
        isLoading: false,
      ),
    );
  }

  Future<void> _onVoidSale(
    VoidSale event,
    Emitter<VoidOperationsState> emit,
  ) async {
    // Get the sale to void
    final sale = state.voidableSales.firstWhere((s) => s.id == event.saleId);
    await service.voidSale(sale: sale, reason: event.reason);
    if (!isClosed) add(LoadVoidOperations());
  }

  Future<void> _onVoidPurchase(
    VoidPurchase event,
    Emitter<VoidOperationsState> emit,
  ) async {
    // Get the purchase to void
    final purchase = state.voidablePurchases.firstWhere(
      (p) => p.id == event.purchaseId,
    );
    await service.voidPurchase(purchase: purchase, reason: event.reason);
    if (!isClosed) add(LoadVoidOperations());
  }
}

