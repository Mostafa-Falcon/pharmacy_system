import 'package:equatable/equatable.dart';
import 'package:pharmacy_system/app/modules/sales/models/return_model.dart';

enum SalesReturnStatus { initial, loading, loaded, error }

class SalesReturnState extends Equatable {
  final SalesReturnStatus status;
  final String? error;
  final List<ReturnModel> returns;
  final String searchQuery;
  final String selectedFilter;

  const SalesReturnState({
    this.status = SalesReturnStatus.initial,
    this.error,
    this.returns = const [],
    this.searchQuery = '',
    this.selectedFilter = 'all',
  });

  SalesReturnState copyWith({
    SalesReturnStatus? status,
    String? error,
    List<ReturnModel>? returns,
    String? searchQuery,
    String? selectedFilter,
  }) {
    return SalesReturnState(
      status: status ?? this.status,
      error: error ?? this.error,
      returns: returns ?? this.returns,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }

  static bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.day == now.day && date.month == now.month && date.year == now.year;
  }

  List<ReturnModel> get filteredReturns {
    var list = returns.toList();
    final q = searchQuery.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list.where((r) =>
        r.id.toLowerCase().contains(q) ||
        (r.saleId?.toLowerCase().contains(q) ?? false) ||
        r.items.any((i) => i.medicineName.toLowerCase().contains(q))
      ).toList();
    }
    if (selectedFilter == 'today') {
      list = list.where((r) => _isToday(r.createdAt)).toList();
    } else if (selectedFilter == 'this_month') {
      final n = DateTime.now();
      list = list.where((r) => r.createdAt.month == n.month && r.createdAt.year == n.year).toList();
    }
    return list;
  }

  int get totalCount => returns.length;
  double get totalReturned => returns.fold(0.0, (sum, r) => sum + r.totalAmount);
  int get todayCount => returns.where((r) => _isToday(r.createdAt)).length;
  double get todayTotal => returns.where((r) => _isToday(r.createdAt)).fold(0.0, (sum, r) => sum + r.totalAmount);

  @override
  List<Object?> get props => [status, error, returns, searchQuery, selectedFilter];
}

