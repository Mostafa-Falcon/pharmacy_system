import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pharmacy_system/app/shared/ui_core.dart';
import '../bloc/auth_bloc.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/index.dart';

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
          AppSnackbar.success('تم إرسال تعليمات إعادة التعيين بريدياً');
          context.pop();
        }
      },
      child: AppScaffold(
        showBackButton: true,
        body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24.w),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 420.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.lock_reset_rounded,
                        size: 64.sp, color: scheme.primary),
                    SizedBox(height: 16.h),
                    ReusableText(
                      'إعادة تعيين كلمة المرور',
                      style: TextStyle(
                          fontSize: 22.sp, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.h),
                    ReusableText(
                      'أدخل البريد الإلكتروني المسجل لارسال رابط إعادة التعيين.',
                      style: TextStyle(
                          fontSize: 13.sp, color: scheme.onSurfaceVariant),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 28.h),
                    TextFormField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'البريد الإلكتروني',
                        prefixIcon: const Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r)),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'يرجى إدخال البريد الإلكتروني';
                        }
                        if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                          return 'بريد إلكتروني غير صالح';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) => _onSubmit(),
                    ),
                    SizedBox(height: 24.h),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return ReusableButton(
                          text: 'إرسال رابط التعيين',
                          isLoading: state.status == AuthStatus.loading,
                          onPressed: _onSubmit,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
