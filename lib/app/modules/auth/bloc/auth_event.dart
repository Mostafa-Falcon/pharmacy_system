part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

final class AppStarted extends AuthEvent {
  const AppStarted();
}

final class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

final class RegisterRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;

  const RegisterRequested({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  @override
  List<Object?> get props => [name, email, password, confirmPassword];
}

final class ResetPasswordRequested extends AuthEvent {
  final String email;

  const ResetPasswordRequested({required this.email});

  @override
  List<Object?> get props => [email];
}

final class TogglePasswordVisibility extends AuthEvent {
  const TogglePasswordVisibility();
}

final class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

final class ClearAuthErrors extends AuthEvent {
  const ClearAuthErrors();
}

final class AuthErrorDisplayed extends AuthEvent {
  const AuthErrorDisplayed();
}

final class ResendConfirmationRequested extends AuthEvent {
  final String email;
  const ResendConfirmationRequested({required this.email});
  @override
  List<Object?> get props => [email];
}
