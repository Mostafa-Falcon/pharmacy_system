import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmacy_system/app/core/models/auth/user_model.dart';

part 'auth_state.freezed.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({
    @Default(AuthStatus.initial) AuthStatus status,
    UserModel? user,
    String? error,
    @Default(false) bool isPasswordVisible,
    @Default(false) bool isResetSent,
    String? emailError,
    String? passwordError,
    String? confirmPasswordError,
    String? nameError,
    String? emailAttempt,
  }) = _AuthState;
}




