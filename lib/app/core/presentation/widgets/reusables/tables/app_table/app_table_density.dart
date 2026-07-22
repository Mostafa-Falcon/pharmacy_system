import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_system/app/core/constants/app_strings.dart';

/// أنماط كثافة عرض الصفوف والخلية في الجدول لتناسب تفضيلات المستخدم ورغبات الشاشات المختلفة.
enum AppTableDensity {
  compact,
  medium,
  comfortable;

  double get rowHeight {
    switch (this) {
      case AppTableDensity.compact:
        return 42.h;
      case AppTableDensity.medium:
        return 52.h;
      case AppTableDensity.comfortable:
        return 64.h;
    }
  }

  double get headerHeight {
    switch (this) {
      case AppTableDensity.compact:
        return 44.h;
      case AppTableDensity.medium:
        return 50.h;
      case AppTableDensity.comfortable:
        return 58.h;
    }
  }

  EdgeInsetsGeometry get cellPadding {
    switch (this) {
      case AppTableDensity.compact:
        return EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h);
      case AppTableDensity.medium:
        return EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h);
      case AppTableDensity.comfortable:
        return EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h);
    }
  }

  double get fontSize {
    switch (this) {
      case AppTableDensity.compact:
        return 11.sp;
      case AppTableDensity.medium:
        return 12.sp;
      case AppTableDensity.comfortable:
        return 13.sp;
    }
  }

  String get label {
    switch (this) {
      case AppTableDensity.compact:
        return AppStrings.tableDensityCompact;
      case AppTableDensity.medium:
        return AppStrings.tableDensityMedium;
      case AppTableDensity.comfortable:
        return AppStrings.tableDensityComfortable;
    }
  }

  IconData get icon {
    switch (this) {
      case AppTableDensity.compact:
        return Icons.density_small_rounded;
      case AppTableDensity.medium:
        return Icons.density_medium_rounded;
      case AppTableDensity.comfortable:
        return Icons.density_large_rounded;
    }
  }
}
