import 'package:flutter/material.dart';

import 'package:pharmacy_system/app/core/presentation/theme/app_colors.dart';

/// اختصارات سياق (BuildContext) لتقليل التكرار الحرفي
/// لـ [Theme.of(context)] في كل الـ views (كان متكرر +261 مرة).
extension ContextThemeExt on BuildContext {
  /// ColorScheme الخاص بالثيم الحالي — بديل لـ [Theme.of(this).colorScheme].
  ColorScheme get scheme => Theme.of(this).colorScheme;

  /// TextTheme الخاص بالثيم الحالي.
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// هل الثيم الحالي داكن؟
  bool get isDark => AppColors.isDark(this);

  /// لون الخلفية الديناميكي (فاتح/داكن).
  Color get background => AppColors.backgroundOf(this);

  /// لون السطح الديناميكي (فاتح/داكن).
  Color get surface => AppColors.surfaceOf(this);

  /// لون النص الأساسي الديناميكي.
  Color get textPrimary => AppColors.textPrimaryOf(this);

  /// لون النص الثانوي الديناميكي.
  Color get textSecondary => AppColors.textSecondaryOf(this);

  /// لون النص الباهت الديناميكي.
  Color get textMuted => AppColors.textMutedOf(this);

  /// لون الحدود الديناميكي.
  Color get border => AppColors.borderOf(this);
}
