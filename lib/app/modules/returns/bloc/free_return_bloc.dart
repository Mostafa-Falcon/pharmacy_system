import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/modules/sales/models/return_model.dart';
import '../services/free_return_service.dart';
import 'free_return_event.dart';
import 'free_return_state.dart';

class FreeReturnBloc extends Bloc<FreeReturnEvent, FreeReturnState> {
  static const _uuid = Uuid();

  FreeReturnBloc() : super(const FreeReturnState()) {
    on<SetReturnType>(_onSetReturnType);
    on<SetPartyType>(_onSetPartyType);
    on<SetSelectedParty>(_onSetSelectedParty);
    on<AddReturnItem>(_onAddItem);
    on<RemoveReturnItem>(_onRemoveItem);
    on<UpdateReturnItem>(_onUpdateItem);
    on<SetDiscountPercent>(_onSetDiscountPercent);
    on<SetReturnNotes>(_onSetNotes);
    on<SetReturnReason>(_onSetReason);
    on<SubmitFreeReturn>(_onSubmit);
  }

  void _onSetReturnType(SetReturnType event, Emitter<FreeReturnState> emit) {
    emit(state.copyWith(returnType: event.returnType));
  }

  void _onSetPartyType(SetPartyType event, Emitter<FreeReturnState> emit) {
    emit(state.copyWith(
      partyType: event.partyType,
      clearParty: true,
    ));
  }

  void _onSetSelectedParty(SetSelectedParty event, Emitter<FreeReturnState> emit) {
    emit(state.copyWith(
      selectedPartyId: event.id,
      selectedPartyName: event.name,
    ));
  }

  void _onAddItem(AddReturnItem event, Emitter<FreeReturnState> emit) {
    final updatedItems = List<ReturnItemModel>.from(state.items)..add(event.item);
    emit(state.copyWith(items: updatedItems));
  }

  void _onRemoveItem(RemoveReturnItem event, Emitter<FreeReturnState> emit) {
    final updatedItems = List<ReturnItemModel>.from(state.items)..removeAt(event.index);
    emit(state.copyWith(items: updatedItems));
  }

  void _onUpdateItem(UpdateReturnItem event, Emitter<FreeReturnState> emit) {
    final updatedItems = List<ReturnItemModel>.from(state.items);
    updatedItems[event.index] = event.item;
    emit(state.copyWith(items: updatedItems));
  }

  void _onSetDiscountPercent(SetDiscountPercent event, Emitter<FreeReturnState> emit) {
    emit(state.copyWith(discountPercent: event.percent));
  }

  void _onSetNotes(SetReturnNotes event, Emitter<FreeReturnState> emit) {
    emit(state.copyWith(notes: event.notes));
  }

  void _onSetReason(SetReturnReason event, Emitter<FreeReturnState> emit) {
    emit(state.copyWith(reason: event.reason));
  }

  Future<void> _onSubmit(SubmitFreeReturn event, Emitter<FreeReturnState> emit) async {
    if (state.items.isEmpty) {
      emit(state.copyWith(status: FreeReturnStatus.error, error: 'يجب إضافة صنف واحد على الأقل'));
      return;
    }

    if (state.partyType != 'cash' && state.selectedPartyId == null) {
      emit(state.copyWith(status: FreeReturnStatus.error, error: 'يجب اختيار الطرف المستهدف'));
      return;
    }

    emit(state.copyWith(status: FreeReturnStatus.loading));
    try {
      final model = ReturnModel(
        id: _uuid.v4(),
        branchId: AuthService.currentBranchId ?? '',
        returnType: state.returnType,
        partyId: state.selectedPartyId,
        partyName: state.selectedPartyName,
        partyType: state.partyType,
        items: state.items,
        totalAmount: state.subtotal,
        discountPercent: state.discountPercent,
        finalAmount: state.finalAmount,
        reason: state.reason,
        notes: state.notes,
        createdBy: AuthService.currentUser?.id ?? 'unknown',
        createdAt: DateTime.now(),
      );

      await FreeReturnService.submitFreeReturn(model);
      emit(state.copyWith(status: FreeReturnStatus.success));
    } catch (e) {
      emit(state.copyWith(status: FreeReturnStatus.error, error: e.toString()));
    }
  }
}
