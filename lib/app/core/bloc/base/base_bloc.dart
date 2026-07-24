import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_system/app/shared/ui_core.dart';
import 'base_state.dart';
import 'package:pharmacy_system/app/core/sync/sync_service.dart';

mixin BlocEffectMixin<E, S> on Bloc<E, S> {
  final _effectController = StreamController<BaseEffect>.broadcast();
  Stream<BaseEffect> get effectStream => _effectController.stream;

  void emitEffect(BaseEffect effect) {
    if (!_effectController.isClosed) {
      _effectController.add(effect);
    }
  }

  @override
  Future<void> close() async {
    await _effectController.close();
    return super.close();
  }
}

/// دالة مساعدة لتنفيذ العمليات مع معالجة الأخطاء وحالة التحميل
Future<void> handleOperation<S extends BaseState<T>, T>(
  Emitter<S> emit,
  Future<T> Function() operation, {
  bool showLoading = true,
  String? customErrorMessage,
  S Function()? loadingState,
  S Function(T data)? successState,
  S Function(String error)? errorState,
}) async {
  if (showLoading) {
    if (loadingState != null) {
      emit(loadingState());
    }
  }
  try {
    final result = await operation();
    if (successState != null) {
      emit(successState(result));
    }
  } catch (e, stack) {
    safeDebugPrint('Bloc Error: $e\n$stack');
    if (errorState != null) {
      emit(errorState(customErrorMessage ?? e.toString()));
    }
  }
}

abstract class BaseBloc<E, T> extends Bloc<E, BaseState<T>> {
  BaseBloc() : super(const BaseState.initial());

  final _effectController = StreamController<BaseEffect>.broadcast();
  Stream<BaseEffect> get effectStream => _effectController.stream;

  final List<StreamSubscription> _subscriptions = [];

  void emitEffect(BaseEffect effect) {
    if (!_effectController.isClosed) {
      _effectController.add(effect);
    }
  }

  void observeTables(
    List<String> tables,
    FutureOr<void> Function() onUpdate, {
    String? branchId,
    Duration debounceDuration = const Duration(milliseconds: 300),
  }) {
    Timer? debounceTimer;
    _subscriptions.add(
      SyncService.tableUpdateStream.listen((update) {
        final table = update.$1;
        final bid = update.$2;
        if (tables.contains(table) &&
            (branchId == null || bid == branchId || bid.isEmpty)) {
          debounceTimer?.cancel();
          debounceTimer = Timer(debounceDuration, () {
            onUpdate();
          });
        }
      }),
    );
  }

  @override
  Future<void> close() async {
    for (final s in _subscriptions) {
      await s.cancel();
    }
    await _effectController.close();
    return super.close();
  }

  Future<void> handleOperation(
    Emitter<BaseState<T>> emit,
    Future<T> Function() operation, {
    bool showLoading = true,
    String? customErrorMessage,
  }) async {
    if (showLoading) emit(const BaseState.loading());
    try {
      final result = await operation();
      emit(BaseState.success(result));
    } catch (e, stack) {
      safeDebugPrint('Bloc Error: $e\n$stack');
      emit(BaseState.error(customErrorMessage ?? e.toString()));
    }
  }
}
