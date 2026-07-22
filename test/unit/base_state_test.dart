import 'package:flutter_test/flutter_test.dart';
import 'package:pharmacy_system/app/core/bloc/base_state.dart';

class TestState extends BaseState<String> {
  const TestState({
    super.data,
    super.isLoading = false,
    super.errorMessage,
    super.isInitial,
    super.isEmpty,
    super.fromDate,
    super.toDate,
  });

  @override
  TestState copyWith({
    String? data,
    bool? isLoading,
    String? errorMessage,
    bool? isInitial,
    bool? isEmpty,
    DateTime? fromDate,
    DateTime? toDate,
  }) {
    return TestState(
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isInitial: isInitial ?? this.isInitial,
      isEmpty: isEmpty ?? this.isEmpty,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
    );
  }
}

void main() {
  group('BaseState', () {
    test('copyWith preserves unchanged fields', () {
      const state = TestState(
        data: 'test',
        isLoading: true,
        errorMessage: 'error',
      );

      final updated = state.copyWith(data: 'new');
      expect(updated.data, 'new');
      expect(updated.isLoading, true);
      expect(updated.errorMessage, 'error');
    });

    test('props contains all fields', () {
      const state = TestState(data: 'test', isLoading: true);
      expect(state.props.length, 7);
    });

    test('initial state has default values', () {
      const state = TestState();
      expect(state.data, null);
      expect(state.isLoading, false);
      expect(state.errorMessage, null);
    });
  });
}
