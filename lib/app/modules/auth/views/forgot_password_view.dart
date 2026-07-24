import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pharmacy_system/app/shared/ui_core.dart';
import '../bloc/auth_bloc.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final _emailCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
            ResetPasswordRequested(email: _emailCtrl.text.trim()),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.error && state.error != null) {
          AppSnackbar.error(state.error!);
          context.read<AuthBloc>().add(const AuthErrorDisplayed());
        }
        if (state.isResetSent) {
          AppSnackbar.success(AuthStrings.resetInstructionsSent);
          context.pop();
        }
      },
      child: AuthLayout(
        title: AuthStrings.resetPasswordTitle,
        subtitle: AuthStrings.resetPasswordSubtitle,
        showBackButton: true,
        promoIcon: Icons.lock_reset_rounded,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppInput.email(
                controller: _emailCtrl,
                label: AuthStrings.emailLabel,
                hint: AuthStrings.emailHint,
                prefixIcon: const Icon(Icons.email_outlined),
                validator: AppValidators.validateEmail,
                onFieldSubmitted: (_) => _onSubmit(),
              ),
              SizedBox(height: AppSpacing.xl.h),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return AppButton(
                    text: AuthStrings.resetPasswordButton,
                    isLoading: state.status == AuthStatus.loading,
                    onPressed: _onSubmit,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
