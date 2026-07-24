import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth_bloc.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/index.dart';
import 'package:pharmacy_system/app/core/constants/app_strings.dart';
import '../../../routes/app_routes.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
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
                          Icon(Icons.local_pharmacy_rounded, size: 80.sp, color: Colors.white),
                          SizedBox(height: 24.h),
                          ReusableText(
                            'نظام Logixa الصيدلي المتكامل',
                            style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          SizedBox(height: 12.h),
                          ReusableText(
                            'إدارة المبيعات والمخزون والمزامنة السحابية والحسابات بأعلى درجات السرعة والأمان.',
                            style: TextStyle(fontSize: 14.sp, color: Colors.white.withValues(alpha: 0.8)),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ReusableText('تسجيل الدخول', style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8.h),
                        ReusableText('أدخل بيانات حسابك للمتابعة إلى النظام', style: TextStyle(fontSize: 13.sp, color: scheme.onSurfaceVariant)),
                        SizedBox(height: 28.h),
                        TextField(
                          controller: _emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'البريد الإلكتروني / اسم المستخدم',
                            prefixIcon: const Icon(Icons.person_outline_rounded),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        TextField(
                          controller: _passwordCtrl,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'كلمة المرور',
                            prefixIcon: const Icon(Icons.lock_outline_rounded),
                            suffixIcon: IconButton(
                              icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            ),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: () => context.push(Routes.FORGOT_PASSWORD),
                            child: const Text('نسيت كلمة المرور؟'),
                          ),
                        ),
                        SizedBox(height: 20.h),
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            return ReusableButton(
                              text: 'تسجيل الدخول',
                              isLoading: state.status == AuthStatus.loading,
                              onPressed: () {
                                if (_emailCtrl.text.trim().isEmpty || _passwordCtrl.text.isEmpty) {
                                  AppSnackbar.warning('يرجى إدخال البريد الإلكتروني وكلمة المرور');
                                  return;
                                }
                                context.read<AuthBloc>().add(
                                  LoginRequested(
                                    email: _emailCtrl.text.trim(),
                                    password: _passwordCtrl.text,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AuthStrings.noAccount,
                              style: TextStyle(fontSize: 13.sp, color: scheme.onSurfaceVariant),
                            ),
                            TextButton(
                              onPressed: () => context.go(Routes.SIGNUP),
                              child: Text(
                                AuthStrings.signupLink,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.bold,
                                  color: scheme.primary,
                                ),
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
          ],
        ),
      ),
    );
  }
}



