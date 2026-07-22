import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:pharmacy_system/app/modules/sales/models/return_model.dart';
import 'package:pharmacy_system/app/core/data/repositories/sales_return_repository.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import '../../../core/injection.dart';
import 'package:pharmacy_system/app/core/data/services/inventory/batch_service.dart';
import 'package:pharmacy_system/app/core/data/services/customer/customer_ledger_service.dart';
import 'package:pharmacy_system/app/core/data/services/inventory/stock_mutation_service.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/reusables/feedback/app_snackbar.dart';
import '../../../core/utils/app_utils.dart';
import 'sales_return_event.dart';
import 'sales_return_state.dart';

class SalesReturnBloc extends Bloc<SalesReturnEvent, SalesReturnState> {
  static const _uuid = Uuid();
  StreamSubscription<List<ReturnModel>>? _subscription;

  String get _branchId => AuthService.currentBranchId ?? '';
  String get _userId => AuthService.currentUser?.id ?? 'unknown';
  SalesReturnRepository get _salesReturnRepo => sl<SalesReturnRepository>();

  SalesReturnBloc() : super(const SalesReturnState()) {
    on<LoadSalesReturns>(_onLoad);
    on<SearchSalesReturns>(_onSearch);
    on<SetSalesReturnFilter>(_onSetFilter);
    on<CreateSalesReturn>(_onCreate);
    _setupStreamListener();
  }

  void _setupStreamListener() {
    final stream = _salesReturnRepo.watchSalesReturns(_branchId);
    _subscription = stream.listen((data) {
      if (!isClosed) {
        add(LoadSalesReturns());
      }
    });
  }

  Future<void> _onLoad(
    LoadSalesReturns event,
    Emitter<SalesReturnState> emit,
  ) async {
    emit(state.copyWith(status: SalesReturnStatus.loading));
    try {
      final all = await _salesReturnRepo.getSalesReturns(branchId: _branchId);
      final sorted = all.where((r) => r.saleId != null && !r.isDeleted).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      emit(state.copyWith(status: SalesReturnStatus.loaded, returns: sorted));
    } catch (e) {
      emit(
        state.copyWith(status: SalesReturnStatus.error, error: e.toString()),
      );
    }
  }

  void _onSearch(SearchSalesReturns event, Emitter<SalesReturnState> emit) {
    emit(state.copyWith(searchQuery: event.query));
  }

  void _onSetFilter(
    SetSalesReturnFilter event,
    Emitter<SalesReturnState> emit,
  ) {
    emit(state.copyWith(selectedFilter: event.filter));
  }

  Future<void> _onCreate(
    CreateSalesReturn event,
    Emitter<SalesReturnState> emit,
  ) async {
    if (event.selectedItems.isEmpty) return;

    final returnItems = event.selectedItems
        .map(
          (i) => ReturnItemModel(
            medicineId: i.medicineId,
            medicineName: i.medicineName,
            quantity: i.returnQuantity,
            unitPrice: i.unitPrice,
            totalPrice: i.unitPrice * i.returnQuantity,
            reason: event.reason.name,
          ),
        )
        .toList();

    final returnModel = ReturnModel(
      id: _uuid.v4(),
      branchId: _branchId,
      saleId: event.originalSale.id,
      items: returnItems,
      totalAmount: returnItems.fold(0.0, (sum, i) => sum + i.totalPrice),
      reason: event.reason,
      notes: event.notes?.trim().isEmpty == true ? null : event.notes?.trim(),
      createdBy: _userId,
      createdAt: DateTime.now(),
    );

    await _salesReturnRepo.create(returnModel);

    // إرجاع الكمية للمخزون + إضافة تشغيلة (batch) عشان الكمية القابلة
    // للبيع تفضل متزامنة مع الكمية المعروضة (عكس استهلاك البيع بـ FEFO).
    for (final item in event.selectedItems) {
      await StockMutationService.adjustStock(
        medicineId: item.medicineId,
        delta: item.returnQuantity,
        branchId: _branchId,
      );
      try {
        await BatchService.to.addBatch(
          medicineId: item.medicineId,
          batchNumber: 'RTN-${returnModel.id.substring(0, 8)}',
          quantity: item.returnQuantity,
          purchasePrice: item.unitPrice,
        );
      } catch (e) {
        safeDebugPrint('SalesReturn: addBatch failed for ${item.medicineId}: $e');
      }
    }

    // تخفيض مديونية العميل بنسبة قيمة المرتجع (لو الفاتورة الأصلية عليها
    // مديونية). recordCustomerPayment بتعمل credit = خصم من الرصيد مع clamp.
    final saleDue = event.originalSale.dueAmount;
    if (event.originalSale.customerId != null && saleDue > 0.0001) {
      final returnValue = returnModel.totalAmount;
      final credit = returnValue > saleDue ? saleDue : returnValue;
      if (credit > 0.0001) {
        await CustomerLedgerService.recordCustomerPayment(
          customerId: event.originalSale.customerId!,
          branchId: _branchId,
          amount: double.parse(credit.toStringAsFixed(2)),
          createdBy: _userId,
          notes: 'تخفيض مديونية بمرتجع فاتورة ${event.originalSale.id}',
          referenceId: returnModel.id,
        );
      }
    }

    AppSnackbar.success('تم تسجيل المرتجع بنجاح');
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}

