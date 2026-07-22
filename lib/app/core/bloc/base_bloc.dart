import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'base_state.dart';
import '../utils/app_utils.dart';
import '../data/services/sync/sync_service.dart';

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

  /// الاستماع لتحديثات جداول معينة في قاعدة البيانات (من المزامنة أو محلياً) مع تجميع التحديثات المتتالية (Debounce)
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
        if (tables.contains(table) && (branchId == null || bid == branchId || bid.isEmpty)) {
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

  /// Helper لتنفيذ العمليات مع معالجة الأخطاء وحالة التحميل.
  /// يتم تمرير [emit] لتجنب تحذيرات الوصول للأعضاء المحمية.
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
