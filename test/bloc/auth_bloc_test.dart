import 'package:flutter_test/flutter_test.dart';
import 'package:pharmacy_system/app/modules/auth/bloc/auth_bloc.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AuthBloc & Freezed AuthState Tests', () {
    late AuthBloc authBloc;

    setUp(() {
      authBloc = AuthBloc();
    });

    tearDown(() {
      authBloc.close();
    });

    test('initial state has AuthStatus.initial and no errors', () {
      expect(authBloc.state.status, AuthStatus.initial);
      expect(authBloc.state.error, isNull);
      expect(authBloc.state.emailError, isNull);
      expect(authBloc.state.passwordError, isNull);
    });

    test('TogglePasswordVisibility toggles isPasswordVisible', () {
      expect(authBloc.state.isPasswordVisible, false);
      authBloc.add(const TogglePasswordVisibility());
      expectLater(
        authBloc.stream,
        emits(predicate<AuthState>((state) => state.isPasswordVisible == true)),
      );
    });

    test('LoginRequested emits emailError when email is empty', () {
      authBloc.add(const LoginRequested(email: '', password: '123'));
      expectLater(
        authBloc.stream,
        emitsThrough(predicate<AuthState>(
          (state) => state.status == AuthStatus.error && state.emailError != null,
        )),
      );
    });

    test('ClearAuthErrors cleans errors from state', () {
      authBloc.emit(authBloc.state.copyWith(
        status: AuthStatus.error,
        error: 'Critical Error',
        emailError: 'Email required',
      ));

      expect(authBloc.state.error, 'Critical Error');
      authBloc.add(const ClearAuthErrors());

      expectLater(
        authBloc.stream,
        emits(predicate<AuthState>(
          (state) => state.error == null && state.emailError == null,
        )),
      );
    });
  });
}
