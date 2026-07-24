import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_system/app/core/models/auth/user_model.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/core/data/services/supplier/supplier_service.dart';
import 'package:pharmacy_system/app/core/sync/sync_service.dart';
import 'package:pharmacy_system/app/core/sync/supabase/supabase_client.dart';
import 'package:pharmacy_system/app/shared/ui_core.dart';
import '../../../core/injection.dart';
import 'auth_state.dart';
export 'auth_state.dart';

part 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthState()) {
    on<AppStarted>(_onAppStarted);
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<ResetPasswordRequested>(_onResetPasswordRequested);
    on<TogglePasswordVisibility>(_onTogglePasswordVisibility);
    on<LogoutRequested>(_onLogoutRequested);
    on<ClearAuthErrors>(_onClearErrors);
    on<AuthErrorDisplayed>(_onErrorDisplayed);
    on<ResendConfirmationRequested>(_onResendConfirmation);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    emit(
      state.copyWith(
        status: AuthStatus.loading,
        error: null,
        emailError: null,
        passwordError: null,
        confirmPasswordError: null,
        nameError: null,
      ),
    );
    try {
      // 1) تهيئة خدمة المصادقة وجلب الجلسة (Supabase / Local)
      await AuthService.init();

      // 2) محاولة المزامنة إذا كنا أونلاين
      if (SyncService.isOnline) {
        try {
          await SyncService.syncAll();
        } catch (e, s) {
          safeDebugPrint('AuthBloc.AppStarted sync failed (ignored): $e\n$s');
        }
      }

      await _initDefaults();

      final user = AuthService.currentUser;
      if (user != null) {
        // تهيئة واجهة التطبيق (Shell) وتحميل البيانات الأساسية للمستخدم
        sl<ShellBloc>().add(const LoadShell());

        emit(
          state.copyWith(
            status: AuthStatus.authenticated,
            user: user,
            error: null,
            emailError: null,
            passwordError: null,
            confirmPasswordError: null,
            nameError: null,
          ),
        );
      } else {
        // حالة عدم تسجيل الدخول (أو انتهت الجلسة) بدون أخطاء.
        emit(
          state.copyWith(
            status: AuthStatus.unauthenticated,
            error: null,
            emailError: null,
            passwordError: null,
            confirmPasswordError: null,
            nameError: null,
          ),
        );
      }
    } catch (e, s) {
      // حدث خطأ فادح أثناء التهيئة (أو المزامنة) في بداية التطبيق.
      // نظهر رسالة خطأ للمستخدم للمحاولة مرة أخرى.
      safeDebugPrint('AuthBloc.AppStarted failed: $e $s');
      emit(
        state.copyWith(
          status: AuthStatus.error,
          error: AuthStrings.errorLoadingAccount,
        ),
      );
    }
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    final email = event.email.trim();
    emit(
      state.copyWith(
        status: AuthStatus.loading,
        emailError: null,
        passwordError: null,
        emailAttempt: email,
      ),
    );
    if (email.isEmpty) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          emailError: AuthStrings.emailRequired,
        ),
      );
      return;
    }
    if (!_isValidEmail(email)) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          emailError: AuthStrings.emailInvalid,
        ),
      );
      return;
    }
    if (event.password.isEmpty) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          passwordError: AuthStrings.passwordRequired,
        ),
      );
      return;
    }

    try {
      final result = await AuthService.login(
        email: email,
        password: event.password,
      );

      if (result['success'] == true) {
        final user = result['user'] as UserModel;

        // محاولة المزامنة في الخلفية بعد تسجيل الدخول بنجاح.
        if (SyncService.isOnline) {
          SyncService.syncAll().catchError((e) {
            safeDebugPrint('AuthBloc: Background sync failed: $e');
          });
        }

        // تهيئة الإعدادات الافتراضية بعد الدخول.
        _initDefaults();

        // تهيئة واجهة التطبيق (Shell) وتحميل البيانات.
        sl<ShellBloc>().add(const LoadShell());

        emit(state.copyWith(status: AuthStatus.authenticated, user: user));
      } else {
        emit(
          state.copyWith(
            status: AuthStatus.error,
            error: result['message'] as String? ?? AuthStrings.errorGeneral,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          error: AuthStrings.errorServerConnection,
        ),
      );
    }
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      state.copyWith(
        status: AuthStatus.loading,
        emailError: null,
        passwordError: null,
        confirmPasswordError: null,
      ),
    );

    final name = event.name.trim();
    final email = event.email.trim();

    if (name.isEmpty) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          nameError: AuthStrings.nameRequired,
          error: null,
        ),
      );
      return;
    }
    if (email.isEmpty) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          emailError: AuthStrings.emailRequired,
        ),
      );
      return;
    }
    if (!_isValidEmail(email)) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          emailError: AuthStrings.emailInvalid,
        ),
      );
      return;
    }
    if (event.password.length < 8) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          passwordError: AuthStrings.passwordMinLength,
        ),
      );
      return;
    }
    if (event.password != event.confirmPassword) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          confirmPasswordError: AuthStrings.passwordsNotMatch,
        ),
      );
      return;
    }

    try {
      // استدعاء خدمة التسجيل (التي تتعامل مع Supabase والمزامنة المحلية).
      final result = await AuthService.register(
        name: name,
        email: email,
        password: event.password,
        role: UserRole.owner,
      );

      if (result['success'] == true) {
        // في حالة تطلب تأكيد البريد الإلكتروني، نظهر رسالة تنبيه للمستخدم.
        if (result['emailConfirmationRequired'] == true) {
          emit(
            state.copyWith(
              status: AuthStatus.unauthenticated,
              error: AuthStrings.emailConfirmationSent,
            ),
          );
          return;
        }

        final user = result['user'] as UserModel;

        // تهيئة البيانات والخدمات الأساسية بعد التسجيل.
        await _initDefaults();

        emit(
          state.copyWith(
            status: AuthStatus.authenticated,
            user: user,
            // في حالة التسجيل المحلي فقط، نظهر رسالة توضيحية.
            error: result['isLocalOnly'] == true
                ? result['message'] as String?
                : null,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: AuthStatus.error,
            error: result['message'] as String? ?? AuthStrings.errorRegister,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          error: '${AuthStrings.errorServer}${e.runtimeType}',
        ),
      );
    }
  }

  Future<void> _onResetPasswordRequested(
    ResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    final email = event.email.trim();
    if (email.isEmpty || !_isValidEmail(email)) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          emailError: AuthStrings.validEmailRequired,
        ),
      );
      return;
    }

    emit(state.copyWith(status: AuthStatus.loading));
    try {
      await SupabaseClientService.resetPassword(email);
      emit(
        state.copyWith(status: AuthStatus.unauthenticated, isResetSent: true),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          error: AuthStrings.forgotPasswordMessage,
        ),
      );
    }
  }

  void _onTogglePasswordVisibility(
    TogglePasswordVisibility event,
    Emitter<AuthState> emit,
  ) {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  Future<void> _onResendConfirmation(
    ResendConfirmationRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await AuthService.resendConfirmation(event.email);
    if (result['success'] == true) {
      AppSnackbar.success(result['message'] as String);
    } else {
      AppSnackbar.error(
        result['message'] as String? ?? AuthStrings.errorGeneral,
      );
    }
    emit(state.copyWith(status: AuthStatus.unauthenticated));
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      state.copyWith(
        status: AuthStatus.loading,
        error: null,
        emailError: null,
        passwordError: null,
        confirmPasswordError: null,
        nameError: null,
      ),
    );
    try {
      await AuthService.logout();
    } catch (e) {
      safeDebugPrint('AuthBloc.logout error: $e');
    }
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }

  void _onClearErrors(ClearAuthErrors event, Emitter<AuthState> emit) {
    // مسح الأخطاء لضمان عدم تكرار ظهور الرسائل أو الدخول في حلقة لانهائية.
    if (state.error != null ||
        state.emailError != null ||
        state.passwordError != null) {
      emit(
        state.copyWith(
          error: null,
          emailError: null,
          passwordError: null,
          confirmPasswordError: null,
          nameError: null,
        ),
      );
    }
  }

  void _onErrorDisplayed(AuthErrorDisplayed event, Emitter<AuthState> emit) {
    // استدعاء هذه الميثود بعد عرض الخطأ في Snackbar لضمان عدم ظهوره مرة أخرى تلقائياً.
    if (state.error != null ||
        state.emailError != null ||
        state.passwordError != null) {
      emit(
        state.copyWith(
          error: null,
          emailError: null,
          passwordError: null,
          confirmPasswordError: null,
          nameError: null,
        ),
      );
    }
  }

  Future<void> _initDefaults() async {
    try {
      await SupplierService.init();
    } catch (e) {
      safeDebugPrint('AuthBloc.initDefaults failed: $e');
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(email);
  }
}
