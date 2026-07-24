import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pharmacy_system/app/shared/ui_core.dart';
import '../bloc/auth_bloc.dart';
import '../../../routes/app_routes.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        LoginRequested(
          email: _emailCtrl.text.trim(),
          password: _passwordCtrl.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        switch (state.status) {
          case AuthStatus.authenticated:
            final user = state.user;
            if (user != null && user.isOwner) {
              context.go(Routes.ADMIN_DASHBOARD);
            } else {
              context.go(Routes.EMPLOYEE_DASHBOARD);
            }
            break;
          case AuthStatus.error:
            if (state.error != null) {
              AppSnackbar.error(state.error!);
              context.read<AuthBloc>().add(const AuthErrorDisplayed());
            }
            break;
          default:
            break;
        }
      },
      child: AuthLayout(
        title: AuthStrings.loginTitle,
        subtitle: AuthStrings.loginSubtitle,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ReusableInput.email(
                controller: _emailCtrl,
                label: AuthStrings.emailLabel,
                hint: AuthStrings.emailHint,
                prefixIcon: const Icon(Icons.person_outline_rounded),
                validator: AppValidators.validateEmail,
              ),
              SizedBox(height: AppSpacing.md.h),
              ReusableInput.password(
                controller: _passwordCtrl,
                label: AuthStrings.passwordLabel,
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                onFieldSubmitted: (_) => _onLogin(),
                validator: AppValidators.validatePassword,
              ),
              SizedBox(height: AppSpacing.xs.h),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () => context.push(Routes.FORGOT_PASSWORD),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  ),
                  child: ReusableText.caption(
                    AuthStrings.forgotPassword,
                    color: scheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.lg.h),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return ReusableButton(
                    text: AuthStrings.loginButton,
                    isLoading: state.status == AuthStatus.loading,
                    onPressed: _onLogin,
                  );
                },
              ),
              SizedBox(height: AppSpacing.lg.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ReusableText.caption(
                    AuthStrings.noAccount,
                  ),
                  TextButton(
                    onPressed: () => context.go(Routes.SIGNUP),
                    child: ReusableText.caption(
                      AuthStrings.signupLink,
                      fontWeight: FontWeight.bold,
                      color: scheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
