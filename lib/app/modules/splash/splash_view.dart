import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pharmacy_system/app/core/constants/strings/app_strings.dart';

import 'package:pharmacy_system/app/shared/widgets/index.dart';
import 'package:pharmacy_system/app/routes/app_routes.dart';
import '../auth/bloc/auth_bloc.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _triggerAuthCheck();
  }

  void _triggerAuthCheck() {
    context.read<AuthBloc>().add(const AppStarted());
  }

  void _handleAuthStateChange(BuildContext context, AuthState state) {
    switch (state.status) {
      case AuthStatus.authenticated:
        Future.delayed(const Duration(milliseconds: 800), () {
          if (!context.mounted) return;
          context.go(Routes.HOME);
        });
        break;
      case AuthStatus.unauthenticated:
        Future.delayed(const Duration(milliseconds: 1000), () {
          if (!context.mounted) return;
          context.go(Routes.LOGIN);
        });
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return BlocListener<AuthBloc, AuthState>(
      listener: _handleAuthStateChange,
      child: Scaffold(
        backgroundColor: scheme.surface,
        body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(32.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    color: scheme.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.local_pharmacy_rounded,
                    size: 72.sp,
                    color: scheme.primary,
                  ),
                ),
                SizedBox(height: 24.h),
                AppText(
                  AuthStrings.appNameSplash,
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w800,
                    color: scheme.onSurface,
                  ),
                ),
                SizedBox(height: 8.h),
                AppText(
                  AuthStrings.appDescSplash,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 48.h),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state.status == AuthStatus.error &&
                        state.error != null) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppText(
                            state.error!,
                            style: TextStyle(
                              color: scheme.error,
                              fontSize: 13.sp,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          AppButton(
                            text: '????? ????????',
                            prefixIcon: Icons.refresh_rounded,
                            onPressed: _triggerAuthCheck,
                          ),
                        ],
                      );
                    }

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const LoadingIndicator(),
                        SizedBox(height: 16.h),
                        AppText(
                          '???? ?????? ?? ???????? ?????? ????????...',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
