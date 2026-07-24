import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pharmacy_system/app/shared/ui_core.dart';
import '../bloc/auth_bloc.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/index.dart';
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
  bool _obscurePassword = true;

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
                      colors: [scheme.primary, scheme.secondary],
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
                            Icons.person_add_rounded,
                            size: 80.sp,
                            color: Colors.white,
                          ),
                          SizedBox(height: 24.h),
                          ReusableText(
                            'إنشاء حساب جديد في المنظومة',
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          ReusableText(
                            'ادخل بيانات المستخدم والتخصص للبدء في استخدام الصيدلية وإدارة الصلاحيات.',
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
                            'إنشاء حساب جديد',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: AppSpacing.xs.h),
                          ReusableText.caption(
                            'قم بتعبئة البيانات التالية لإنشاء الحساب',
                          ),
                          SizedBox(height: AppSpacing.xl.h),
                          ReusableInput.text(
                            controller: _nameCtrl,
                            label: 'الاسم الكامل',
                            prefixIcon: const Icon(Icons.badge_outlined),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'يرجى إدخال الاسم بالكامل';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: AppSpacing.md.h),
                          ReusableInput.email(
                            controller: _emailCtrl,
                            label: 'البريد الإلكتروني',
                            prefixIcon: const Icon(Icons.email_outlined),
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
                          ),
                          SizedBox(height: AppSpacing.md.h),
                          ReusableInput.password(
                            controller: _passwordCtrl,
                            label: 'كلمة المرور',
                            prefixIcon: const Icon(Icons.lock_outline_rounded),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'يرجى إدخال كلمة المرور';
                              }
                              if (value.length < 6) {
                                return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: AppSpacing.md.h),
                          ReusableInput.password(
                            controller: _confirmPasswordCtrl,
                            label: 'تأكيد كلمة المرور',
                            prefixIcon: const Icon(Icons.lock_clock_outlined),
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _onSignup(),
                            validator: (value) {
                              if (value != _passwordCtrl.text) {
                                return 'كلمات المرور غير متطابقة';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: AppSpacing.xl.h),
                          BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                              return ReusableButton(
                                text: 'إنشاء الحساب',
                                isLoading: state.status == AuthStatus.loading,
                                onPressed: _onSignup,
                              );
                            },
                          ),
                          SizedBox(height: AppSpacing.lg.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ReusableText.caption(
                                AuthStrings.alreadyHaveAccount,
                              ),
                              TextButton(
                                onPressed: () => context.go(Routes.LOGIN),
                                child: ReusableText.caption(
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
