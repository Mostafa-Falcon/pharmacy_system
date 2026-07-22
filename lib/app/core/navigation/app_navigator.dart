import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../routes/app_router.dart';

/// مساعد التنقل يحل محل Get.toNamed و Get.back و Get.offAllNamed
class AppNavigator {
  /// الانتقال إلى صفحة معينة
  static void to(String route) {
    AppRouter.router.go(route);
  }

  /// الانتقال مع إمكانية إرجاع قيمة
  static Future<T?> push<T>(String route) async {
    return AppRouter.router.push<T>(route);
  }

  /// الرجوع من الصفحة الحالية
  static void back<T>({T? result}) {
    AppRouter.router.pop(result);
  }

  /// الانتقال إلى صفحة وإزالة جميع الصفحات السابقة
  static void offAllTo(String route) {
    AppRouter.router.go(route);
  }

  /// الانتقال إلى صفحة مع إزالة الصفحة الحالية
  static void offTo(String route) {
    while (AppRouter.router.canPop()) {
      AppRouter.router.pop();
    }
    AppRouter.router.go(route);
  }
}

/// امتدادات عامة على BuildContext لتسهيل التنقل
extension GoRouterExtension on BuildContext {
  void pushRoute(String route) => go(route);
  void pushReplacementNamed(String route) => pushReplacement(route);
  void goRoute(String route) => go(route);
}
