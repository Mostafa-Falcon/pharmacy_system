import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pharmacy_system/app/core/bloc/base_bloc.dart';
import 'package:pharmacy_system/app/core/bloc/base_state.dart';
import 'package:pharmacy_system/app/core/models/sales/cashier_shift_model.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/core/data/services/sales/cashier_shift_service.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/reusables/feedback/app_snackbar.dart';
import 'package:pharmacy_system/app/core/constants/app_strings.dart';

// --- Events ---
abstract class CashierShiftEvent extends Equatable {
  const CashierShiftEvent();
  @override
  List<Object?> get props => [];
}

class LoadCashierShifts extends CashierShiftEvent {
  const LoadCashierShifts();
}

class OpenCashierShift extends CashierShiftEvent {
  final double openingCash;
  const OpenCashierShift(this.openingCash);
  @override
  List<Object?> get props => [openingCash];
}

class CloseCashierShift extends CashierShiftEvent {
  final String shiftId;
  final double countedCash;
  final String? notes;
  const CloseCashierShift({required this.shiftId, required this.countedCash, this.notes});
  @override
  List<Object?> get props => [shiftId, countedCash, notes];
}

// --- Bloc ---
class CashierShiftBloc extends BaseBloc<CashierShiftEvent, List<CashierShiftModel>> {
  CashierShiftBloc() : super() {
    on<LoadCashierShifts>(_onLoad);
    on<OpenCashierShift>(_onOpen);
    on<CloseCashierShift>(_onClose);

    add(const LoadCashierShifts());
  }

  String get _branchId => AuthService.currentBranchId ?? '';
  String get _cashierId => AuthService.currentUser?.id ?? '';

  /// ?????? ??? ??????? ???????? ?????? ?? ???????? ???????
  CashierShiftModel? get currentShift {
    final list = state.data;
    if (list == null) return null;
    try {
      return list.firstWhere(
        (s) => s.status == CashierShiftStatus.open && s.cashierId == _cashierId,
      );
    } catch (_) {
      return null;
    }
  }
  
  // Note: Better handle null in UI by checking if id is empty or using firstWhereOrNull if available.

  Future<void> _onLoad(LoadCashierShifts event, Emitter<BaseState<List<CashierShiftModel>>> emit) async {
    await handleOperation(emit, () async {
      await CashierShiftService.refresh();
      return CashierShiftService.getAll(branchId: _branchId);
    });
  }

  Future<void> _onOpen(OpenCashierShift event, Emitter<BaseState<List<CashierShiftModel>>> emit) async {
    await handleOperation(emit, () async {
      await CashierShiftService.openShift(
        openingCash: event.openingCash,
        branchId: _branchId,
      );
      AppSnackbar.success(SalesStrings.shiftOpenedSuccess);
      return CashierShiftService.getAll(branchId: _branchId);
    });
  }

  Future<void> _onClose(CloseCashierShift event, Emitter<BaseState<List<CashierShiftModel>>> emit) async {
    await handleOperation(emit, () async {
      await CashierShiftService.closeShift(
        shiftId: event.shiftId,
        countedCash: event.countedCash,
        notes: event.notes,
      );
      AppSnackbar.success(SalesStrings.shiftClosedSuccess);
      return CashierShiftService.getAll(branchId: _branchId);
    });
  }
}





