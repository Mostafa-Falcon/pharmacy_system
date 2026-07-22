import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'base_state.dart';
import 'sortable_list_mixin.dart';

abstract class PaginatedEvent {
  const PaginatedEvent();
}

class LoadItems extends PaginatedEvent {
  final bool refresh;
  const LoadItems({this.refresh = false});
}

class SearchItems extends PaginatedEvent {
  final String query;
  const SearchItems(this.query);
}

class ChangePage extends PaginatedEvent {
  final int page;
  const ChangePage(this.page);
}

class UpdateSortEvent extends PaginatedEvent {
  final String column;
  final bool ascending;
  const UpdateSortEvent(this.column, this.ascending);
}

class PaginatedState<T> extends BaseState<List<T>> {
  final int totalItems;
  final int currentPage;
  final int pageSize;
  final String searchQuery;

  const PaginatedState({
    super.isLoading,
    super.data,
    super.errorMessage,
    super.isInitial,
    super.isEmpty,
    super.fromDate,
    super.toDate,
    this.totalItems = 0,
    this.currentPage = 0,
    this.pageSize = 50,
    this.searchQuery = '',
  });

  List<T> get items => data ?? [];
  bool get isFailure => errorMessage != null;
  String? get error => errorMessage;

  @override
  PaginatedState<T> copyWith({
    bool? isLoading,
    List<T>? data,
    String? errorMessage,
    bool? isInitial,
    bool? isEmpty,
    DateTime? fromDate,
    DateTime? toDate,
    int? totalItems,
    int? currentPage,
    int? pageSize,
    String? searchQuery,
  }) {
    return PaginatedState<T>(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      errorMessage: errorMessage ?? this.errorMessage,
      isInitial: isInitial ?? this.isInitial,
      isEmpty: isEmpty ?? this.isEmpty,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      totalItems: totalItems ?? this.totalItems,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

abstract class BasePaginatedBloc<T> extends Bloc<PaginatedEvent, PaginatedState<T>> with SortableListMixin<T> {
  BasePaginatedBloc() : super(const PaginatedState(isInitial: true)) {
    on<LoadItems>(_onLoadItems);
    on<SearchItems>(_onSearch);
    on<ChangePage>(_onChangePage);
    on<UpdateSortEvent>(_onUpdateSort);
  }

  List<T> allItems = [];

  Future<List<T>> fetchAllItems();
  bool filterCondition(T item, String query);
  int compareItems(T a, T b, String column);

  Future<void> _onLoadItems(LoadItems event, Emitter<PaginatedState<T>> emit) async {
    if (event.refresh || allItems.isEmpty) {
      emit(state.copyWith(isLoading: true, errorMessage: null));
      try {
        allItems = await fetchAllItems();
      } catch (e) {
        emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
        return;
      }
    }
    _applyAndEmit(emit);
  }

  void _onSearch(SearchItems event, Emitter<PaginatedState<T>> emit) {
    emit(state.copyWith(searchQuery: event.query, currentPage: 0));
    _applyAndEmit(emit);
  }

  void _onChangePage(ChangePage event, Emitter<PaginatedState<T>> emit) {
    emit(state.copyWith(currentPage: event.page));
    _applyAndEmit(emit);
  }

  void _onUpdateSort(UpdateSortEvent event, Emitter<PaginatedState<T>> emit) {
    updateSort(event.column, event.ascending);
    _applyAndEmit(emit);
  }

  void _applyAndEmit(Emitter<PaginatedState<T>> emit) {
    final query = state.searchQuery;
    final filteredItems = allItems.where((item) => filterCondition(item, query)).toList();
    final sorted = sortList(filteredItems, compareItems);
    
    final start = state.currentPage * state.pageSize;
    final paged = sorted.sublist(
      start.clamp(0, sorted.length),
      (start + state.pageSize).clamp(0, sorted.length),
    );

    emit(state.copyWith(
      isLoading: false,
      data: paged,
      totalItems: filteredItems.length,
      isEmpty: paged.isEmpty && allItems.isNotEmpty && query.isEmpty,
    ));
  }
}
