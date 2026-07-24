import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:pharmacy_system/app/core/models/base/correction_model.dart';
import 'package:pharmacy_system/app/core/models/sales/sale_invoice_model.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/core/data/services/admin/branch_data_service.dart';
import 'package:pharmacy_system/app/core/data/services/accounting/correction_service.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/components/feedback/app_snackbar.dart';
import 'package:pharmacy_system/app/core/constants/app_strings.dart';
import 'package:pharmacy_system/app/core/bloc/base_state.dart';
import 'package:pharmacy_system/app/core/data/repositories/sales_repository.dart';
import 'package:pharmacy_system/app/core/injection.dart';

// --- Events ---
abstract class SalesEvent extends Equatable {
  const SalesEvent();
  @override
  List<Object?> get props => [];
}

class LoadSales extends SalesEvent {
  const LoadSales();
}

class FilterSalesQuery extends SalesEvent {
  final String query;
  const FilterSalesQuery(this.query);
  @override
  List<Object?> get props => [query];
}

class FilterSalesByStatus extends SalesEvent {
  final String status;
  const FilterSalesByStatus(this.status);
  @override
  List<Object?> get props => [status];
}

class VoidSale extends SalesEvent {
  final SaleInvoiceModel sale;
  const VoidSale(this.sale);
  @override
  List<Object?> get props => [sale];
}

// --- State ---
class SalesState extends BaseState<List<SaleInvoiceModel>> {
  final List<SaleInvoiceModel> filteredSales;
  final String searchQuery;
  final String selectedFilter;
  final double todayTotal;
  final double monthTotal;
  final int totalCount;
  final double creditTotal;

  const SalesState({
    super.data,
    super.isLoading = false,
    super.errorMessage,
    super.isInitial = false,
    super.isEmpty = false,
    super.fromDate,
    super.toDate,
    this.filteredSales = const [],
    this.searchQuery = '',
    this.selectedFilter = 'all',
    this.todayTotal = 0,
    this.monthTotal = 0,
    this.totalCount = 0,
    this.creditTotal = 0,
  });

  List<SaleInvoiceModel> get sales => data ?? [];
  BaseState<List<SaleInvoiceModel>> get dataState => this;

  @override
  SalesState copyWith({
    List<SaleInvoiceModel>? data,
    bool? isLoading,
    String? errorMessage,
    bool? isInitial,
    bool? isEmpty,
    DateTime? fromDate,
    DateTime? toDate,
    List<SaleInvoiceModel>? filteredSales,
    String? searchQuery,
    String? selectedFilter,
    double? todayTotal,
    double? monthTotal,
    int? totalCount,
    double? creditTotal,
  }) {
    return SalesState(
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isInitial: isInitial ?? this.isInitial,
      isEmpty: isEmpty ?? this.isEmpty,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      filteredSales: filteredSales ?? this.filteredSales,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      todayTotal: todayTotal ?? this.todayTotal,
      monthTotal: monthTotal ?? this.monthTotal,
      totalCount: totalCount ?? this.totalCount,
      creditTotal: creditTotal ?? this.creditTotal,
    );
  }

  @override
  List<Object?> get props => [
        data,
        isLoading,
        errorMessage,
        fromDate,
        toDate,
        filteredSales,
        searchQuery,
        selectedFilter,
        todayTotal,
        monthTotal,
        totalCount,
        creditTotal,
      ];
}

// --- Bloc ---
class SalesBloc extends Bloc<SalesEvent, SalesState> {
  StreamSubscription? _subscription;

  SalesBloc() : super(const SalesState()) {
    on<LoadSales>(_onLoad);
    on<FilterSalesQuery>(_onFilterQuery);
    on<FilterSalesByStatus>(_onFilterStatus);
    on<VoidSale>(_onVoid);

    // ?????? ???? ?? ??????? ????????
    _subscription = sl<SalesRepository>().watchSales(_branchId).listen((_) {
      if (!isClosed) add(const LoadSales());
    });

    add(const LoadSales());
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  String get _branchId => AuthService.currentBranchId ?? '';

  void _updateTotals(List<SaleInvoiceModel> sales, Emitter<SalesState> emit) {
    final now = DateTime.now();
    final todayTotal = sales
        .where((s) =>
            s.createdAt.day == now.day &&
            s.createdAt.month == now.month &&
            s.createdAt.year == now.year)
        .fold(0.0, (sum, s) => sum + s.finalAmount);
    final monthTotal = sales
        .where((s) => s.createdAt.month == now.month && s.createdAt.year == now.year)
        .fold(0.0, (sum, s) => sum + s.finalAmount);
    final creditTotal = sales
        .where((s) => s.paymentMethod == 'credit')
        .fold(0.0, (sum, s) => sum + s.finalAmount);
    emit(state.copyWith(
      totalCount: sales.length,
      todayTotal: todayTotal,
      monthTotal: monthTotal,
      creditTotal: creditTotal,
    ));
  }

  List<SaleInvoiceModel> _applyFilter(List<SaleInvoiceModel> list) {
    var result = list.toList();
    final q = state.searchQuery.trim().toLowerCase();
    if (q.isNotEmpty) {
      result = result
          .where((s) =>
              (s.customerName?.toLowerCase().contains(q) ?? false) ||
              s.id.toLowerCase().contains(q) ||
              s.items.any((i) => i.medicineName.toLowerCase().contains(q)))
          .toList();
    }
    switch (state.selectedFilter) {
      case 'today':
        final now = DateTime.now();
        result = result
            .where((s) =>
                s.createdAt.day == now.day &&
                s.createdAt.month == now.month &&
                s.createdAt.year == now.year)
            .toList();
        break;
      case 'this_month':
        final now = DateTime.now();
        result = result
            .where((s) => s.createdAt.month == now.month && s.createdAt.year == now.year)
            .toList();
        break;
      case 'credit':
        result = result.where((s) => s.paymentMethod == 'credit').toList();
        break;
    }
    return result;
  }

  Future<void> _onLoad(LoadSales event, Emitter<SalesState> emit) async {
    emit(state.copyWith(isLoading: true));
    final all = BranchDataService.getSales(branchId: _branchId);
    final sales = all.where((s) => !s.isDeleted).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    _updateTotals(sales, emit);
    emit(state.copyWith(data: sales, filteredSales: _applyFilter(sales), isLoading: false));
  }

  void _onFilterQuery(FilterSalesQuery event, Emitter<SalesState> emit) {
    emit(state.copyWith(searchQuery: event.query, filteredSales: _applyFilter(state.sales)));
  }

  void _onFilterStatus(FilterSalesByStatus event, Emitter<SalesState> emit) {
    emit(state.copyWith(selectedFilter: event.status, filteredSales: _applyFilter(state.sales)));
  }

  Future<void> _onVoid(VoidSale event, Emitter<SalesState> emit) async {
    await BranchDataService.voidSale(event.sale.id, branchId: _branchId);
    CorrectionService.record(
      referenceType: CorrectionReferenceType.sale,
      referenceId: event.sale.id,
      action: CorrectionAction.voided,
      details: SalesStrings.voidInvoice,
    );
    add(const LoadSales());
    AppSnackbar.success(CrmStrings.msgUpdatedSuccess);
  }

  String getPaymentLabel(String method) => switch (method) {
        'cash' => GeneralStrings.enumCustomerCash,
        'credit' => GeneralStrings.enumCustomerRegular,
        'card' => PurchasesStrings.paymentMethodCard,
        _ => method,
      };
}







