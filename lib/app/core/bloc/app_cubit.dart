import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_system/app/core/data/services/sync/sync_service.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(const AppState()) {
    _subscription = Connectivity().onConnectivityChanged.listen(_onConnectivityChanged);
  }

  StreamSubscription<ConnectivityResult>? _subscription;

  Future<void> initialize() async {
    emit(state.copyWith(isLoading: true));
    try {
      final result = await Connectivity().checkConnectivity();
      final isOnline = result != ConnectivityResult.none;
      emit(state.copyWith(isOnline: isOnline, isLoading: false, isInitialized: true));
      if (isOnline) {
        SyncService.initialize();
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, isInitialized: true, error: e.toString()));
    }
  }

  void _onConnectivityChanged(ConnectivityResult result) {
    final isOnline = result != ConnectivityResult.none;
    emit(state.copyWith(isOnline: isOnline));
    if (isOnline) {
      SyncService.initialize();
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
