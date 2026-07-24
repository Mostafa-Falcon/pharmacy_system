import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pharmacy_system/app/shared/ui_core.dart';
import '../bloc/auth_bloc.dart';
import '../../../routes/app_routes.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  void _onSignup() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
            RegisterRequested(
              name: _nameCtrl.text.trim(),
              email: _emailCtrl.text.trim(),
              password: _passwordCtrl.text,
              confirmPassword: _confirmPasswordCtrl.text,
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
        title: AuthStrings.signupTitle,
        subtitle: AuthStrings.signupSubtitle,
        promoIcon: Icons.person_add_rounded,
        promoTitle: AuthStrings.signupPromoTitle,
        promoSubtitle: AuthStrings.signupPromoSubtitle,
        promoGradient: [scheme.primary, scheme.secondary],
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppInput.text(
                controller: _nameCtrl,
                label: AuthStrings.fullNameLabel,
                hint: AuthStrings.nameHint,
                prefixIcon: const Icon(Icons.badge_outlined),
                validator: AppValidators.validateFullName,
              ),
              SizedBox(height: AppSpacing.md.h),
              AppInput.email(
                controller: _emailCtrl,
                label: AuthStrings.emailLabel,
                hint: AuthStrings.emailHint,
                prefixIcon: const Icon(Icons.email_outlined),
                validator: AppValidators.validateEmail,
              ),
              SizedBox(height: AppSpacing.md.h),
              AppInput.password(
                controller: _passwordCtrl,
                label: AuthStrings.passwordLabel,
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                validator: AppValidators.validatePassword,
              ),
              SizedBox(height: AppSpacing.md.h),
              AppInput.password(
                controller: _confirmPasswordCtrl,
                label: AuthStrings.confirmPasswordLabel,
                prefixIcon: const Icon(Icons.lock_clock_outlined),
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _onSignup(),
                validator: (value) => AppValidators.validateConfirmPassword(value, _passwordCtrl.text),
              ),
              SizedBox(height: AppSpacing.xl.h),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return AppButton(
                    text: AuthStrings.signupButton,
                    isLoading: state.status == AuthStatus.loading,
                    onPressed: _onSignup,
                  );
                },
              ),
              SizedBox(height: AppSpacing.lg.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText.caption(
                    AuthStrings.alreadyHaveAccount,
                  ),
                  TextButton(
                    onPressed: () => context.go(Routes.LOGIN),
                    child: AppText.caption(
                      AuthStrings.loginNow,
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
