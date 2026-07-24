import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pharmacy_system/app/shared/ui_core.dart';
import '../bloc/auth_bloc.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/index.dart';
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
  bool _obscurePassword = true;

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
    final size = MediaQuery.of(context).size;
    final isWeb = size.width >= 900;
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
      child: AppScaffold(
        showBackButton: false,
        body: Row(
          children: [
            if (isWeb)
              Expanded(
                flex: 10,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [scheme.primary, scheme.tertiary],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(40.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.local_pharmacy_rounded,
                            size: 80.sp,
                            color: Colors.white,
                          ),
                          SizedBox(height: 24.h),
                          ReusableText(
                            'نظام Logixa الصيدلي المتكامل',
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          ReusableText(
                            'إدارة المبيعات والمخزون والمزامنة السحابية والحسابات بأعلى درجات السرعة والأمان.',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            Expanded(
              flex: 8,
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(32.w),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 420.w),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ReusableText.h2(
                            'تسجيل الدخول',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: AppSpacing.xs.h),
                          ReusableText.caption(
                            'أدخل بيانات حسابك للمتابعة إلى النظام',
                          ),
                          SizedBox(height: AppSpacing.xl.h),
                          ReusableInput.email(
                            controller: _emailCtrl,
                            label: 'البريد الإلكتروني / اسم المستخدم',
                            prefixIcon: const Icon(Icons.person_outline_rounded),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'يرجى إدخال البريد الإلكتروني';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: AppSpacing.md.h),
                          ReusableInput.password(
                            controller: _passwordCtrl,
                            label: 'كلمة المرور',
                            prefixIcon: const Icon(Icons.lock_outline_rounded),
                            onFieldSubmitted: (_) => _onLogin(),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'يرجى إدخال كلمة المرور';
                              }
                              return null;
                            },
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
                                'نسيت كلمة المرور؟',
                                color: scheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: AppSpacing.lg.h),
                          BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                              return ReusableButton(
                                text: 'تسجيل الدخول',
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
