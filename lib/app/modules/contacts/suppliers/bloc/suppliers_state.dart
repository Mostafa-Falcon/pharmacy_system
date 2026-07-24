import 'package:equatable/equatable.dart';
import 'package:pharmacy_system/app/core/models/contacts/supplier_model.dart';
import 'package:pharmacy_system/app/core/models/contacts/supplier_ledger_model.dart';

enum SuppliersStatus { initial, loading, loaded, success, error }

class SuppliersState extends Equatable {
  final SuppliersStatus status;
  final List<SupplierModel> allSuppliers;
  final List<SupplierModel> filteredSuppliers;
  final List<SupplierModel> pagedSuppliers;
  final SupplierModel? selectedSupplier;
  final List<SupplierLedgerModel> ledgerEntries;
  final Map<String, double> balances;
  final bool isLoadingLedger;
  final bool showArchived;
  final int currentPage;
  final int totalPages;
  final String searchQuery;
  final String sortColumnId;
  final bool isSortAscending;
  final String? error;
  final Set<String> selectedIds;

  static const int pageSize = 25;

  const SuppliersState({
    this.status = SuppliersStatus.initial,
    this.allSuppliers = const [],
    this.filteredSuppliers = const [],
    this.pagedSuppliers = const [],
    this.selectedSupplier,
    this.ledgerEntries = const [],
    this.balances = const {},
    this.isLoadingLedger = false,
    this.showArchived = false,
    this.currentPage = 0,
    this.totalPages = 1,
    this.searchQuery = '',
    this.sortColumnId = 'name',
    this.isSortAscending = true,
    this.error,
    this.selectedIds = const {},
  });

  int get activeSupplierCount => allSuppliers.where((s) => s.isActive && !s.isDeleted).length;
  int get archivedSupplierCount => allSuppliers.where((s) => s.isDeleted).length;
  double get totalBalance => balances.values.fold(0.0, (sum, v) => sum + v);

  SuppliersState copyWith({
    SuppliersStatus? status,
    List<SupplierModel>? allSuppliers,
    List<SupplierModel>? filteredSuppliers,
    List<SupplierModel>? pagedSuppliers,
    SupplierModel? selectedSupplier, bool clearSelected = false,
    List<SupplierLedgerModel>? ledgerEntries,
    Map<String, double>? balances,
    bool? isLoadingLedger, bool? showArchived,
    int? currentPage, int? totalPages,
    String? searchQuery, String? sortColumnId, bool? isSortAscending,
    String? error, bool clearError = false,
    Set<String>? selectedIds,
  }) {
    return SuppliersState(
      status: status ?? this.status,
      allSuppliers: allSuppliers ?? this.allSuppliers,
      filteredSuppliers: filteredSuppliers ?? this.filteredSuppliers,
      pagedSuppliers: pagedSuppliers ?? this.pagedSuppliers,
      selectedSupplier: clearSelected ? null : (selectedSupplier ?? this.selectedSupplier),
      ledgerEntries: ledgerEntries ?? this.ledgerEntries,
      balances: balances ?? this.balances,
      isLoadingLedger: isLoadingLedger ?? this.isLoadingLedger,
      showArchived: showArchived ?? this.showArchived,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      searchQuery: searchQuery ?? this.searchQuery,
      sortColumnId: sortColumnId ?? this.sortColumnId,
      isSortAscending: isSortAscending ?? this.isSortAscending,
      error: clearError ? null : (error ?? this.error),
      selectedIds: selectedIds ?? this.selectedIds,
    );
  }

  @override
  List<Object?> get props => [status, allSuppliers, filteredSuppliers, pagedSuppliers, selectedSupplier, ledgerEntries, balances, isLoadingLedger, showArchived, currentPage, totalPages, searchQuery, sortColumnId, isSortAscending, error, selectedIds];
}




