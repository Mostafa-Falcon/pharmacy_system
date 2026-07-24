import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pharmacy_system/app/core/data/services/accounting/correction_service.dart';
import 'activity_log_event.dart';
import 'activity_log_state.dart';

class ActivityLogBloc extends Bloc<ActivityLogEvent, ActivityLogState> {
  ActivityLogBloc() : super(ActivityLogState()) {
    on<LoadActivityLog>(_onLoad);
    on<RefreshActivityLog>(_onRefresh);
    add(const LoadActivityLog());
  }

  Future<void> _onLoad(LoadActivityLog event, Emitter<ActivityLogState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final entries = await CorrectionService.getAll(limit: 200);
      emit(ActivityLogState(
        isLoading: false,
        entries: entries,
      ));
    } catch (e) {
      emit(ActivityLogState(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onRefresh(RefreshActivityLog event, Emitter<ActivityLogState> emit) async {
    emit(state.copyWith(isRefreshing: true));
    try {
      final entries = await CorrectionService.getAll(limit: 200);
      emit(ActivityLogState(
        isLoading: false,
        entries: entries,
      ));
    } catch (e) {
      emit(ActivityLogState(
        isLoading: false,
        entries: state.entries,
        error: e.toString(),
      ));
    }
  }
}


