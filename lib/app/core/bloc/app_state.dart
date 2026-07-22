part of 'app_cubit.dart';

class AppState {
  final bool isInitialized;
  final bool isLoading;
  final bool isOnline;
  final String? error;

  const AppState({
    this.isInitialized = false,
    this.isLoading = false,
    this.isOnline = false,
    this.error,
  });

  AppState copyWith({
    bool? isInitialized,
    bool? isLoading,
    bool? isOnline,
    String? error,
    bool clearError = false,
  }) {
    return AppState(
      isInitialized: isInitialized ?? this.isInitialized,
      isLoading: isLoading ?? this.isLoading,
      isOnline: isOnline ?? this.isOnline,
      error: clearError ? null : (error ?? this.error),
    );
  }
}
