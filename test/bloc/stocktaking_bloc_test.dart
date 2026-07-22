import 'package:flutter_test/flutter_test.dart';
import 'package:pharmacy_system/app/modules/stocktaking/bloc/stocktaking_bloc.dart';
import 'package:pharmacy_system/app/modules/inventory/models/stocktaking_period_model.dart';

void main() {
  group('StocktakingBloc Unit Tests', () {
    late StocktakingBloc bloc;

    setUp(() {
      bloc = StocktakingBloc();
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state has correct defaults', () {
      expect(bloc.state.isLoading, false);
      expect(bloc.state.periods, isEmpty);
      expect(bloc.state.selectedPeriod, isNull);
      expect(bloc.state.counts, isEmpty);
      expect(bloc.state.error, isNull);
      expect(bloc.state.currentPage, 1);
      expect(bloc.state.pageSize, 20);
      expect(bloc.state.hasMore, true);
    });

    test('stats returns zeros for empty state', () {
      final stats = bloc.state.stats;
      expect(stats['total'], 0);
      expect(stats['open'], 0);
      expect(stats['inProgress'], 0);
      expect(stats['closed'], 0);
      expect(stats['cancelled'], 0);
    });

    test('copyWith preserves unchanged fields', () {
      final copy = bloc.state.copyWith(isLoading: true);
      expect(copy.isLoading, true);
      expect(copy.periods, isEmpty);
      expect(copy.counts, isEmpty);
      expect(copy.error, isNull);
      expect(copy.currentPage, 1);
      expect(copy.pageSize, 20);
      expect(copy.hasMore, true);
    });

    test('state props include all fields for Equatable', () {
      final state = StocktakingState(
        isLoading: true,
        periods: [StocktakingPeriodModel(id: '1', name: 'P', branchId: 'b', startedAt: DateTime.now(), createdBy: 'u')],
        selectedPeriod: StocktakingPeriodModel(id: '1', name: 'P', branchId: 'b', startedAt: DateTime.now(), createdBy: 'u'),
        counts: const [],
        error: 'err',
      );
      expect(state.props.length, 8);
      expect(state.props.contains(state.isLoading), true);
      expect(state.props.contains(state.periods), true);
      expect(state.props.contains(state.selectedPeriod), true);
      expect(state.props.contains(state.counts), true);
      expect(state.props.contains(state.error), true);
      expect(state.props.contains(state.currentPage), true);
      expect(state.props.contains(state.pageSize), true);
      expect(state.props.contains(state.hasMore), true);
    });
  });
}
