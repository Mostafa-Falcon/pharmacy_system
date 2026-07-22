import 'package:equatable/equatable.dart';
import 'package:pharmacy_system/app/modules/sales/models/return_model.dart';

enum PurchaseReturnStatus { initial, loading, loaded, error }

class PurchaseReturnState extends Equatable {
  final PurchaseReturnStatus status;
  final String? error;
  final List<ReturnModel> returns;
  final String searchQuery;
  final String selectedFilter;
  final Set<String> selectedIds;

  const PurchaseReturnState({
    this.status = PurchaseReturnStatus.initial,
    this.error,
    this.returns = const [],
    this.searchQuery = '',
    this.selectedFilter = 'all',
    this.selectedIds = const {},
  });

  PurchaseReturnState copyWith({
    PurchaseReturnStatus? status,
    String? error,
    List<ReturnModel>? returns,
    String? searchQuery,
    String? selectedFilter,
    Set<String>? selectedIds,
  }) {
    return PurchaseReturnState(
      status: status ?? this.status,
      error: error ?? this.error,
      returns: returns ?? this.returns,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      selectedIds: selectedIds ?? this.selectedIds,
    );
  }

  List<ReturnModel> get filteredReturns {
    var list = returns.toList();
    final q = searchQuery.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list.where((r) =>
        r.id.toLowerCase().contains(q) ||
        (r.purchaseId?.toLowerCase().contains(q) ?? false) ||
        r.items.any((i) => i.medicineName.toLowerCase().contains(q))
      ).toList();
    }
    if (selectedFilter == 'today') {
      final t = DateTime.now();
      list = list.where((r) =>
        r.createdAt.day == t.day && r.createdAt.month == t.month && r.createdAt.year == t.year
      ).toList();
    } else if (selectedFilter == 'this_month') {
      final n = DateTime.now();
      list = list.where((r) => r.createdAt.month == n.month && r.createdAt.year == n.year).toList();
    }
    return list;
  }

  int get totalCount => returns.length;
  double get totalReturned => returns.fold(0.0, (sum, r) => sum + r.totalAmount);

  @override
  List<Object?> get props => [status, error, returns, searchQuery, selectedFilter, selectedIds];
}

