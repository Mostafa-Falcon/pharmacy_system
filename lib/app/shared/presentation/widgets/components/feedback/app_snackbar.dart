import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

import 'package:pharmacy_system/app/shared/ui_core.dart';

import '../display/app_text.dart';

/// المكون الموحد لإظهار الـ Snackbar ضمن مكتبة المكونات المشتركة (Reusables).
class AppSnackbar {
  AppSnackbar._();

  static void show(
    String title,
    String message, {
    required Color primaryColor,
    ToastificationType type = ToastificationType.info,
    Alignment alignment = Alignment.topCenter,
    Duration duration = const Duration(seconds: 4),
  }) {
    toastification.show(
      type: type,
      style: ToastificationStyle.minimal,
      primaryColor: primaryColor,
      title: AppText(
        title,
        fontSizeOverride: 13,
        fontWeight: FontWeight.w700,
      ),
      description: AppText(
        message,
        fontSizeOverride: 11,
        fontWeight: FontWeight.w500,
      ),
      alignment: alignment,
      direction: TextDirection.rtl,
      autoCloseDuration: duration,
      showProgressBar: true,
      closeButton: const ToastCloseButton(),
      dragToClose: true,
      animationDuration: const Duration(milliseconds: 300),
    );
  }
}

/// Helper موحّد لكل الـ Snackbars في التطبيق.
class AppSnackbar {
  AppSnackbar._();

  static void _clear() {
    toastification.dismissAll();
  }

  static void success(String message, {String title = GeneralStrings.done}) {
    _clear();
    AppSnackbar.show(
      title,
      message,
      primaryColor: AppColors.success,
      type: ToastificationType.success,
    );
  }

  static void error(String message, {String title = GeneralStrings.error}) {
    _clear();
    AppSnackbar.show(
      title,
      message,
      primaryColor: AppColors.error,
      type: ToastificationType.error,
    );
  }

  static void warning(String message, {String title = GeneralStrings.warning}) {
    _clear();
    AppSnackbar.show(
      title,
      message,
      primaryColor: AppColors.warning,
      type: ToastificationType.warning,
    );
  }

  static void info(String message, {String title = GeneralStrings.information}) {
    _clear();
    AppSnackbar.show(
      title,
      message,
      primaryColor: AppColors.info,
      type: ToastificationType.info,
    );
  }
}




