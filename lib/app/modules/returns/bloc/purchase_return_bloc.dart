import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:pharmacy_system/app/core/models/base/correction_model.dart';
import 'package:pharmacy_system/app/core/models/sales/return_model.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/core/data/services/admin/branch_data_service.dart';
import 'package:pharmacy_system/app/core/data/services/accounting/correction_service.dart';
import 'package:pharmacy_system/app/core/data/services/inventory/stock_mutation_service.dart';
import 'package:pharmacy_system/app/core/data/services/supplier/supplier_ledger_service.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/components/feedback/app_snackbar.dart';
import 'purchase_return_event.dart';
import 'purchase_return_state.dart';

class PurchaseReturnBloc extends Bloc<PurchaseReturnEvent, PurchaseReturnState> {
  static const _uuid = Uuid();

  String get _branchId => AuthService.currentBranchId ?? '';
  String get _userId => AuthService.currentUser?.id ?? 'unknown';

  PurchaseReturnBloc() : super(const PurchaseReturnState()) {
    on<LoadPurchaseReturns>(_onLoad);
    on<SearchPurchaseReturns>(_onSearch);
    on<SetPurchaseReturnFilter>(_onSetFilter);
    on<CreatePurchaseReturn>(_onCreate);
    on<ToggleSelectReturn>(_onToggleSelect);
    on<ToggleSelectAllReturns>(_onToggleSelectAll);
  }

  void _onToggleSelect(ToggleSelectReturn event, Emitter<PurchaseReturnState> emit) {
    final newSelected = Set<String>.from(state.selectedIds);
    if (newSelected.contains(event.id)) {
      newSelected.remove(event.id);
    } else {
      newSelected.add(event.id);
    }
    emit(state.copyWith(selectedIds: newSelected));
  }

  void _onToggleSelectAll(ToggleSelectAllReturns event, Emitter<PurchaseReturnState> emit) {
    if (event.select) {
      final allIds = state.filteredReturns.map((r) => r.id).toSet();
      emit(state.copyWith(selectedIds: allIds));
    } else {
      emit(state.copyWith(selectedIds: {}));
    }
  }

  Future<void> _onLoad(LoadPurchaseReturns event, Emitter<PurchaseReturnState> emit) async {
    emit(state.copyWith(status: PurchaseReturnStatus.loading));
    try {
      final all = BranchDataService.getReturns(branchId: _branchId);
      final sorted = all.where((r) => r.purchaseId != null && !r.isDeleted).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      emit(state.copyWith(status: PurchaseReturnStatus.loaded, returns: sorted));
    } catch (e) {
      emit(state.copyWith(status: PurchaseReturnStatus.error, error: e.toString()));
    }
  }

  void _onSearch(SearchPurchaseReturns event, Emitter<PurchaseReturnState> emit) {
    emit(state.copyWith(searchQuery: event.query));
  }

  void _onSetFilter(SetPurchaseReturnFilter event, Emitter<PurchaseReturnState> emit) {
    emit(state.copyWith(selectedFilter: event.filter));
  }

  Future<void> _onCreate(CreatePurchaseReturn event, Emitter<PurchaseReturnState> emit) async {
    if (event.selectedItems.isEmpty) return;

    final returnItems = event.selectedItems
        .map((i) => ReturnItemModel(
          medicineId: i.medicineId,
          medicineName: i.medicineName,
          quantity: i.returnQuantity,
          unitPrice: i.unitPrice,
          totalPrice: i.unitPrice * i.returnQuantity,
          reason: event.reason.name,
        ))
        .toList();

    final returnModel = ReturnModel(
      id: _uuid.v4(),
      branchId: _branchId,
      returnType: 'purchase',
      purchaseId: event.originalPurchase.id,
      items: returnItems,
      totalAmount: returnItems.fold(0.0, (sum, i) => sum + i.totalPrice),
      finalAmount: returnItems.fold(0.0, (sum, i) => sum + i.totalPrice),
      reason: event.reason,
      notes: event.notes?.trim().isEmpty == true ? null : event.notes?.trim(),
      createdBy: _userId,
      createdAt: DateTime.now(),
    );

    await BranchDataService.addReturn(returnModel);

    CorrectionService.record(
      referenceType: CorrectionReferenceType.purchase,
      referenceId: event.originalPurchase.id,
      action: CorrectionAction.returned,
      details: '????? ??????? ????? ${returnModel.totalAmount.toStringAsFixed(2)} ?.? — ???: ${event.reason.name}',
    );

    for (final item in event.selectedItems) {
      // ???? ??????? ??? ???? StockMutationService ??????? (??? FIFO + sync queue)
      // ??? ??????? ??????? ??? Hive — ?? ????? ??? ??????? ?????? ????????.
      await StockMutationService.adjustStock(
        medicineId: item.medicineId,
        delta: -item.returnQuantity,
        branchId: _branchId,
      );
    }

    // ????? ???? ?????? ????? ??????? (recordSupplierPayment ????? credit =
    // ??? ?? ?????? ??????? ????? ?? clamp ???? ??????).
    if (event.originalPurchase.supplierId != null) {
      final returnValue = returnModel.totalAmount;
      await SupplierLedgerService.recordSupplierPayment(
        supplierId: event.originalPurchase.supplierId!,
        branchId: _branchId,
        amount: double.parse(returnValue.toStringAsFixed(2)),
        createdBy: _userId,
        notes: '??? ????? ??????? ${event.originalPurchase.id}',
        referenceId: returnModel.id,
      );
    }

    add(const LoadPurchaseReturns());
    AppSnackbar.success('?? ????? ????? ????????? ?????');
  }
}





