import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pharmacy_system/app/modules/auth/views/auth_callback_view.dart';
import 'package:pharmacy_system/app/modules/auth/views/forgot_password_view.dart';
import 'package:pharmacy_system/app/modules/auth/views/login_view.dart';
import 'package:pharmacy_system/app/modules/auth/views/signup_view.dart';
import 'package:pharmacy_system/app/modules/splash/splash_view.dart';

import 'package:pharmacy_system/app/routes/app_routes.dart';

Page<void> fadePage(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(opacity: animation, child: child),
  );
}

final List<RouteBase> authRoutes = [
  GoRoute(
    path: Routes.SPLASH,
    name: 'splash',
    pageBuilder: (context, state) => fadePage(state, const SplashView()),
  ),
  GoRoute(
    path: Routes.LOGIN,
    name: 'login',
    pageBuilder: (context, state) => fadePage(state, const LoginView()),
  ),
  GoRoute(
    path: Routes.SIGNUP,
    name: 'signup',
    pageBuilder: (context, state) => fadePage(state, const SignupView()),
  ),
  GoRoute(
    path: Routes.FORGOT_PASSWORD,
    name: 'forgot-password',
    pageBuilder: (context, state) => fadePage(state, const ForgotPasswordView()),
  ),
  GoRoute(
    path: Routes.AUTH_CALLBACK,
    name: 'auth-callback',
    pageBuilder: (context, state) => fadePage(state, const AuthCallbackView()),
  ),
];