import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_system/app/shared/ui_core.dart';

/// نظام المسافات الموحد
class AppSpacing {
  AppSpacing._();
  static double get xxs => 4.w;
  static double get xs => 8.w;
  static double get sm => 12.w;
  static double get md => 16.w;
  static double get lg => 20.w;
  static double get xl => 24.w;
  static double get xxl => 32.w;
  static double get xxxl => 40.w;

  static double get xsH => 8.h;
  static double get smH => 12.h;
  static double get mdH => 16.h;
  static double get lgH => 20.h;
  static double get xlH => 24.h;
}

/// نظام الخطوط الموحد (Typography)
class AppTextStyles {
  AppTextStyles._();

  static TextStyle headline(BuildContext context) => TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimaryOf(context),
    height: 1.2,
  );

  static TextStyle title(BuildContext context) => TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimaryOf(context),
    height: 1.3,
  );

  static TextStyle subtitle(BuildContext context) => TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimaryOf(context),
    height: 1.3,
  );

  static TextStyle body(BuildContext context) => TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimaryOf(context),
    height: 1.5,
  );

  static TextStyle bodyBold(BuildContext context) => TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimaryOf(context),
    height: 1.5,
  );

  static TextStyle caption(BuildContext context) => TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondaryOf(context),
    height: 1.4,
  );

  static TextStyle button(BuildContext context) => TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    height: 1.1,
  );
}

/// أحجام الأيقونات الموحدة
enum AppIconSize {
  xs(12.0),
  sm(16.0),
  md(20.0),
  lg(24.0),
  xl(32.0),
  xxl(40.0),
  xxxl(48.0);

  final double value;
  const AppIconSize(this.value);
}

/// نظام الزوايا الموحد (Radius)
class AppRadius {
  AppRadius._();
  static double get xs => 4.r;
  static double get sm => 8.r;
  static double get md => 12.r;
  static double get lg => 16.r;
  static double get xl => 20.r;
  static double get pill => 999.r;

  // Semantic aliases
  static double get card => md;
  static double get chip => pill;
  static double get button => sm;
  static double get dialog => lg;
  static double get input => sm;
}

/// نظام الظلال والارتفاع الموحد
class AppElevation {
  AppElevation._();
  static const double none = 0;
  static const double sm = 2;
  static const double md = 4;
  static const double lg = 8;
  static const double xl = 16;
}

/// أبعاد التخطيط الأساسية (تم استعادتها بالكامل)
class AppDimensions {
  AppDimensions._();
  static double get sidebarWidth => 260.w;
  static double get sidebarCollapsedWidth => 72.w;
  static double get navbarHeight => 64.h;
  static double get headerHeight => 86.h;
  static double get iconSize => 21.sp;
  static double get iconSizeSmall => 18.sp;
  static double get dividerThickness => 1.0;
  static double get scrollbarThickness => 5.w;
}

/// Backward compatibility (تأمين كامل لجميع المسميات القديمة)
class AppSizes {
  AppSizes._();
  static double get sidebarWidth => AppDimensions.sidebarWidth;
  static double get sidebarCollapsedWidth =>
      AppDimensions.sidebarCollapsedWidth;
  static double get navbarHeight => AppDimensions.navbarHeight;
  static double get headerHeight => AppDimensions.headerHeight;
  static double get iconSize => AppDimensions.iconSize;
  static double get iconSizeSmall => AppDimensions.iconSizeSmall;
  static double get borderRadius => AppRadius.md;
  static double get borderRadiusSmall => AppRadius.sm;
  static double get borderRadiusLarge => AppRadius.lg;
  static double get spacingXS => AppSpacing.xs;
  static double get spacingSM => AppSpacing.sm;
  static double get spacingMD => AppSpacing.md;
  static double get spacingLG => AppSpacing.lg;
  static double get spacingXL => AppSpacing.xl;
  static double get dividerThickness => AppDimensions.dividerThickness;
  static double get scrollbarThickness => AppDimensions.scrollbarThickness;
  static double get cardRadius => AppRadius.card;
  static double get chipRadius => AppRadius.chip;
  static double get buttonRadius => AppRadius.button;
}
