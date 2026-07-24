import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/components/feedback/app_snackbar.dart';
import 'package:pharmacy_system/app/core/data/services/inventory/stocktaking_service.dart';
import 'package:pharmacy_system/app/core/models/inventory/stocktaking_period_model.dart';

// --- Events ---------------------------------------------------------------

sealed class StocktakingEvent extends Equatable {
  const StocktakingEvent();
  @override
  List<Object?> get props => [];
}

class LoadStocktakingPeriods extends StocktakingEvent {}

class LoadMoreStocktakingPeriods extends StocktakingEvent {
  const LoadMoreStocktakingPeriods();
}

class LoadStocktakingCounts extends StocktakingEvent {
  final String periodId;
  const LoadStocktakingCounts(this.periodId);
  @override
  List<Object?> get props => [periodId];
}

class CreateStocktakingPeriod extends StocktakingEvent {
  final String name;
  final String? notes;
  const CreateStocktakingPeriod(this.name, {this.notes});
  @override
  List<Object?> get props => [name, notes];
}

class CloseStocktakingPeriod extends StocktakingEvent {
  final String id;
  const CloseStocktakingPeriod(this.id);
  @override
  List<Object?> get props => [id];
}

class CancelStocktakingPeriod extends StocktakingEvent {
  final String id;
  const CancelStocktakingPeriod(this.id);
  @override
  List<Object?> get props => [id];
}

class DeleteStocktakingPeriod extends StocktakingEvent {
  final String id;
  const DeleteStocktakingPeriod(this.id);
  @override
  List<Object?> get props => [id];
}

class DeleteStocktakingCount extends StocktakingEvent {
  final String id;
  const DeleteStocktakingCount(this.id);
  @override
  List<Object?> get props => [id];
}

class UpdateStocktakingCount extends StocktakingEvent {
  final String id;
  final int? actualQuantity;
  final String? notes;
  const UpdateStocktakingCount(this.id, {this.actualQuantity, this.notes});
  @override
  List<Object?> get props => [id, actualQuantity, notes];
}

class RecordStocktakingCount extends StocktakingEvent {
  final String periodId;
  final String itemId;
  final String itemName;
  final String? sku;
  final String unit;
  final int systemQuantity;
  final int actualQuantity;
  final double buyPrice;
  final String? notes;

  const RecordStocktakingCount({
    required this.periodId,
    required this.itemId,
    required this.itemName,
    this.sku,
    this.unit = '????',
    required this.systemQuantity,
    required this.actualQuantity,
    this.buyPrice = 0,
    this.notes,
  });

  @override
  List<Object?> get props => [periodId, itemId, actualQuantity];
}

// --- States ---------------------------------------------------------------

class StocktakingState extends Equatable {
  final bool isLoading;
  final List<StocktakingPeriodModel> periods;
  final StocktakingPeriodModel? selectedPeriod;
  final List<StocktakingCountModel> counts;
  final String? error;
  final int currentPage;
  final int pageSize;
  final bool hasMore;

  const StocktakingState({
    this.isLoading = false,
    this.periods = const [],
    this.selectedPeriod,
    this.counts = const [],
    this.error,
    this.currentPage = 1,
    this.pageSize = 20,
    this.hasMore = true,
  });

  StocktakingState copyWith({
    bool? isLoading,
    List<StocktakingPeriodModel>? periods,
    StocktakingPeriodModel? selectedPeriod,
    List<StocktakingCountModel>? counts,
    String? error,
    int? currentPage,
    int? pageSize,
    bool? hasMore,
  }) {
    return StocktakingState(
      isLoading: isLoading ?? this.isLoading,
      periods: periods ?? this.periods,
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
      counts: counts ?? this.counts,
      error: error ?? this.error,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  Map<String, int> get stats {
    if (periods.isEmpty) {
      return {
        'total': 0,
        'open': 0,
        'inProgress': 0,
        'closed': 0,
        'cancelled': 0,
      };
    }
    return {
      'total': periods.length,
      'open': periods.where((p) => p.isOpen).length,
      'inProgress': periods.where((p) => p.isInProgress).length,
      'closed': periods.where((p) => p.isClosed).length,
      'cancelled': periods.where((p) => p.isCancelled).length,
    };
  }

  @override
  List<Object?> get props => [
    isLoading,
    periods,
    selectedPeriod,
    counts,
    error,
    currentPage,
    pageSize,
    hasMore,
  ];
}

// --- BLoC ---------------------------------------------------------------

class StocktakingBloc extends Bloc<StocktakingEvent, StocktakingState> {
  StocktakingBloc() : super(const StocktakingState()) {
    on<LoadStocktakingPeriods>(_onLoadPeriods);
    on<LoadMoreStocktakingPeriods>(_onLoadMorePeriods);
    on<LoadStocktakingCounts>(_onLoadCounts);
    on<CreateStocktakingPeriod>(_onCreatePeriod);
    on<CloseStocktakingPeriod>(_onClosePeriod);
    on<CancelStocktakingPeriod>(_onCancelPeriod);
    on<DeleteStocktakingPeriod>(_onDeletePeriod);
    on<RecordStocktakingCount>(_onRecordCount);
    on<DeleteStocktakingCount>(_onDeleteCount);
    on<UpdateStocktakingCount>(_onUpdateCount);
  }

  Future<void> _onLoadPeriods(
    LoadStocktakingPeriods event,
    Emitter<StocktakingState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, currentPage: 1));
    try {
      final periods = await StocktakingService.to.getPeriodsPage(1, state.pageSize);
      emit(state.copyWith(periods: periods, isLoading: false, hasMore: periods.length >= state.pageSize));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onLoadMorePeriods(
    LoadMoreStocktakingPeriods event,
    Emitter<StocktakingState> emit,
  ) async {
    if (!state.hasMore || state.isLoading) return;
    emit(state.copyWith(isLoading: true));
    try {
      final nextPage = state.currentPage + 1;
      final newPeriods = await StocktakingService.to.getPeriodsPage(nextPage, state.pageSize);
      final updated = [...state.periods, ...newPeriods];
      emit(state.copyWith(
        periods: updated,
        currentPage: nextPage,
        isLoading: false,
        hasMore: newPeriods.length >= state.pageSize,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onLoadCounts(
    LoadStocktakingCounts event,
    Emitter<StocktakingState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final selectedPeriod = await StocktakingService.to.getPeriod(event.periodId);
      final counts = await StocktakingService.to.getCounts(event.periodId);
      emit(
        state.copyWith(
          selectedPeriod: selectedPeriod,
          counts: counts,
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onCreatePeriod(
    CreateStocktakingPeriod event,
    Emitter<StocktakingState> emit,
  ) async {
    try {
      await StocktakingService.to.createPeriod(
        name: event.name,
        notes: event.notes,
      );
      if (!isClosed) add(LoadStocktakingPeriods());
    } catch (e) {
      AppSnackbar.error(e.toString());
    }
  }

  Future<void> _onClosePeriod(
    CloseStocktakingPeriod event,
    Emitter<StocktakingState> emit,
  ) async {
    try {
      await StocktakingService.to.closePeriod(event.id);
      if (!isClosed) add(LoadStocktakingPeriods());
    } catch (e) {
      AppSnackbar.error(e.toString());
    }
  }

  Future<void> _onCancelPeriod(
    CancelStocktakingPeriod event,
    Emitter<StocktakingState> emit,
  ) async {
    try {
      await StocktakingService.to.cancelPeriod(event.id);
      if (!isClosed) add(LoadStocktakingPeriods());
    } catch (e) {
      AppSnackbar.error(e.toString());
    }
  }

  Future<void> _onDeletePeriod(
    DeleteStocktakingPeriod event,
    Emitter<StocktakingState> emit,
  ) async {
    try {
      await StocktakingService.to.deletePeriod(event.id);
      if (!isClosed) add(LoadStocktakingPeriods());
    } catch (e) {
      AppSnackbar.error(e.toString());
    }
  }

  Future<void> _onRecordCount(
    RecordStocktakingCount event,
    Emitter<StocktakingState> emit,
  ) async {
    try {
      await StocktakingService.to.recordCount(
        periodId: event.periodId,
        itemId: event.itemId,
        itemName: event.itemName,
        sku: event.sku,
        unit: event.unit,
        systemQuantity: event.systemQuantity,
        actualQuantity: event.actualQuantity,
        buyPrice: event.buyPrice,
        notes: event.notes,
      );
      if (!isClosed) add(LoadStocktakingCounts(event.periodId));
    } catch (e) {
      AppSnackbar.error(e.toString());
    }
  }

  Future<void> _onDeleteCount(
    DeleteStocktakingCount event,
    Emitter<StocktakingState> emit,
  ) async {
    try {
      await StocktakingService.to.deleteCount(event.id);
      final period = state.selectedPeriod;
      if (period != null && !isClosed) add(LoadStocktakingCounts(period.id));
    } catch (e) {
      AppSnackbar.error(e.toString());
    }
  }

  Future<void> _onUpdateCount(
    UpdateStocktakingCount event,
    Emitter<StocktakingState> emit,
  ) async {
    try {
      await StocktakingService.to.updateCount(
        event.id,
        actualQuantity: event.actualQuantity,
        notes: event.notes,
      );
      final period = state.selectedPeriod;
      if (period != null && !isClosed) add(LoadStocktakingCounts(period.id));
    } catch (e) {
      AppSnackbar.error(e.toString());
    }
  }
}





