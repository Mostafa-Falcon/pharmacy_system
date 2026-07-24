import 'package:equatable/equatable.dart';
import 'package:pharmacy_system/app/core/models/contacts/supplier_customer_model.dart';

enum SupplierCustomersStatus { initial, loading, loaded, error }

class SupplierCustomersState extends Equatable {
  final SupplierCustomersStatus status;
  final String? error;
  final List<SupplierCustomerModel> allSuppliers;
  final List<SupplierCustomerModel> filteredSuppliers;
  final String searchQuery;
  final String selectedFilter;
  final Map<String, double> currentBalances;
  final SupplierCustomerModel? selectedParty;
  final List<Map<String, dynamic>> combinedLedger;
  final bool isLoadingLedger;
  final bool isSuccess;
  final Map<String, double> transactionSummary;

  const SupplierCustomersState({
    this.status = SupplierCustomersStatus.initial,
    this.error,
    this.allSuppliers = const [],
    this.filteredSuppliers = const [],
    this.searchQuery = '',
    this.selectedFilter = 'all',
    this.currentBalances = const {},
    this.selectedParty,
    this.combinedLedger = const [],
    this.isLoadingLedger = false,
    this.isSuccess = false,
    this.transactionSummary = const {},
  });

  SupplierCustomersState copyWith({
    SupplierCustomersStatus? status,
    String? error,
    List<SupplierCustomerModel>? allSuppliers,
    List<SupplierCustomerModel>? filteredSuppliers,
    String? searchQuery,
    String? selectedFilter,
    Map<String, double>? currentBalances,
    SupplierCustomerModel? selectedParty,
    bool clearSelected = false,
    List<Map<String, dynamic>>? combinedLedger,
    bool? isLoadingLedger,
    bool? isSuccess,
    Map<String, double>? transactionSummary,
  }) {
    return SupplierCustomersState(
      status: status ?? this.status,
      error: error ?? this.error,
      allSuppliers: allSuppliers ?? this.allSuppliers,
      filteredSuppliers: filteredSuppliers ?? this.filteredSuppliers,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      currentBalances: currentBalances ?? this.currentBalances,
      selectedParty: clearSelected ? null : (selectedParty ?? this.selectedParty),
      combinedLedger: combinedLedger ?? this.combinedLedger,
      isLoadingLedger: isLoadingLedger ?? this.isLoadingLedger,
      isSuccess: isSuccess ?? false,
      transactionSummary: transactionSummary ?? this.transactionSummary,
    );
  }

  List<String> get availableFilters => [
    'all', 'active', 'inactive', 'credit_customer', 'cash_customer',
    'individual', 'company', 'with_balance', 'no_balance',
  ];

  String getFilterLabel(String filter) {
    switch (filter) {
      case 'all': return '????';
      case 'active': return '???';
      case 'inactive': return '??? ???';
      case 'credit_customer': return '???? ???';
      case 'cash_customer': return '???? ????';
      case 'individual': return '???';
      case 'company': return '????';
      case 'with_balance': return '???? ????';
      case 'no_balance': return '???? ????';
      default: return filter;
    }
  }

  int get totalCount => allSuppliers.length;
  int get activeCount => allSuppliers.where((c) => c.isActive).length;
  double get totalBalance => currentBalances.values.fold(0.0, (s, v) => s + v);

  Map<String, double> get ledgerTotals {
    if (combinedLedger.isEmpty) return {};
    double totalDebit = 0;
    double totalCredit = 0;
    for (final e in combinedLedger) {
      totalDebit += (e['debit'] as double? ?? 0);
      totalCredit += (e['credit'] as double? ?? 0);
    }
    return {'totalDebit': totalDebit, 'totalCredit': totalCredit, 'netBalance': totalDebit - totalCredit};
  }

  @override
  List<Object?> get props => [status, error, allSuppliers, filteredSuppliers, searchQuery, selectedFilter, currentBalances, selectedParty, combinedLedger, isLoadingLedger, isSuccess, transactionSummary];
}




