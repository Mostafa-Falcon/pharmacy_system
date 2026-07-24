import '../../../../core/bloc/base_state.dart';
import 'package:pharmacy_system/app/core/models/contacts/customer_model.dart';
import 'package:pharmacy_system/app/core/models/contacts/customer_ledger_model.dart';

class CustomersState extends BaseState<List<CustomerModel>> {
  final List<CustomerModel> filteredCustomers;
  final List<CustomerModel> pagedCustomers;
  final CustomerModel? selectedCustomer;
  final List<ContactLedgerModel> ledgerEntries;
  final Map<String, double> balances;
  final bool isLoadingLedger;
  final bool isSuccess;
  final int currentPage;
  final int totalPages;
  final int currentPageSize;
  final String searchQuery;
  final String sortColumnId;
  final bool isSortAscending;
  final Set<String> selectedIds;

  const CustomersState({
    super.data,
    super.isLoading = false,
    super.errorMessage,
    super.isInitial = false,
    super.isEmpty = false,
    super.fromDate,
    super.toDate,
    this.filteredCustomers = const [],
    this.pagedCustomers = const [],
    this.selectedCustomer,
    this.ledgerEntries = const [],
    this.balances = const {},
    this.isLoadingLedger = false,
    this.isSuccess = false,
    this.currentPage = 0,
    this.totalPages = 1,
    this.currentPageSize = 10,
    this.searchQuery = '',
    this.sortColumnId = 'name',
    this.isSortAscending = true,
    this.selectedIds = const {},
  });

  List<CustomerModel> get allCustomers => data ?? [];
  BaseState<List<CustomerModel>> get dataState => this;
  int get activeCustomerCount => allCustomers.where((c) => c.isActive).length;
  double get totalBalance => balances.values.fold(0.0, (sum, v) => sum + v);

  @override
  CustomersState copyWith({
    List<CustomerModel>? data,
    bool? isLoading,
    String? errorMessage,
    bool? isInitial,
    bool? isEmpty,
    DateTime? fromDate,
    DateTime? toDate,
    List<CustomerModel>? filteredCustomers,
    List<CustomerModel>? pagedCustomers,
    CustomerModel? selectedCustomer,
    bool clearSelected = false,
    List<ContactLedgerModel>? ledgerEntries,
    Map<String, double>? balances,
    bool? isLoadingLedger,
    bool? isSuccess,
    int? currentPage,
    int? totalPages,
    int? currentPageSize,
    String? searchQuery,
    String? sortColumnId,
    bool? isSortAscending,
    Set<String>? selectedIds,
  }) {
    return CustomersState(
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isInitial: isInitial ?? this.isInitial,
      isEmpty: isEmpty ?? this.isEmpty,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      filteredCustomers: filteredCustomers ?? this.filteredCustomers,
      pagedCustomers: pagedCustomers ?? this.pagedCustomers,
      selectedCustomer: clearSelected ? null : (selectedCustomer ?? this.selectedCustomer),
      ledgerEntries: ledgerEntries ?? this.ledgerEntries,
      balances: balances ?? this.balances,
      isLoadingLedger: isLoadingLedger ?? this.isLoadingLedger,
      isSuccess: isSuccess ?? false,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      currentPageSize: currentPageSize ?? this.currentPageSize,
      searchQuery: searchQuery ?? this.searchQuery,
      sortColumnId: sortColumnId ?? this.sortColumnId,
      isSortAscending: isSortAscending ?? this.isSortAscending,
      selectedIds: selectedIds ?? this.selectedIds,
    );
  }

  @override
  List<Object?> get props => [
        data,
        isLoading,
        errorMessage,
        fromDate,
        toDate,
        filteredCustomers,
        pagedCustomers,
        selectedCustomer,
        ledgerEntries,
        balances,
        isLoadingLedger,
        isSuccess,
        currentPage,
        totalPages,
        currentPageSize,
        searchQuery,
        sortColumnId,
        isSortAscending,
        selectedIds,
      ];
}





