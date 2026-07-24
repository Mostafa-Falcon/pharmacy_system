import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_system/app/shared/ui_core.dart';

/// مكون شريحة موحّد وممركزي (Unified AppChip UI).
/// يجمع أنماط شرائح البيانات، الإحصائيات، والفلترة في مكون واحد مرن.
class AppChip extends StatelessWidget {
  final String label;
  final String? value;
  final IconData? icon;
  final Color? color;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool showBadgeCircle;

  const AppChip({
    super.key,
    required this.label,
    this.value,
    this.icon,
    this.color,
    this.isSelected = false,
    this.onTap,
    this.showBadgeCircle = false,
  });

  const AppChip.info({
    super.key,
    required this.icon,
    required this.label,
    this.value,
    this.color,
  }) : isSelected = false,
       onTap = null,
       showBadgeCircle = false;

  const AppChip.stat({
    super.key,
    required this.label,
    required dynamic count,
    required this.color,
    required this.icon,
  }) : value = '$count',
       isSelected = true,
       onTap = null,
       showBadgeCircle = true;

  const AppChip.filter({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.color,
  }) : value = null,
       icon = null,
       showBadgeCircle = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = AppColors.isDark(context);
    final activeColor = color ?? scheme.primary;
    final radius = BorderRadius.circular(AppRadius.md.r);

    Widget chipContent = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (icon != null && showBadgeCircle) ...[
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: activeColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: AppIconSize.sm.value, color: activeColor),
          ),
          SizedBox(width: 8.w),
        ] else if (icon != null) ...[
          Icon(icon, size: AppIconSize.sm.value, color: activeColor),
          SizedBox(width: 5.w),
        ],

        ReusableText(
          label,
          style: AppTextStyles.caption(context).copyWith(
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            color: isSelected
                ? (isDark ? AppColors.textPrimaryOf(context) : activeColor)
                : AppColors.textSecondaryOf(context),
          ),
        ),

        if (value != null) ...[
          SizedBox(width: 5.w),
          ReusableText(
            value!,
            style: AppTextStyles.body(
              context,
            ).copyWith(fontWeight: FontWeight.w800, color: activeColor),
          ),
        ],
      ],
    );

    final decoration = BoxDecoration(
      color: isSelected
          ? activeColor.withValues(alpha: isDark ? 0.14 : 0.07)
          : scheme.surfaceContainerLow.withValues(alpha: 0.35),
      borderRadius: radius,
      border: Border.all(
        color: isSelected
            ? activeColor.withValues(alpha: isDark ? 0.4 : 0.25)
            : AppColors.borderOf(context).withValues(alpha: 0.2),
        width: 1.w,
      ),
    );

    if (onTap != null) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: decoration,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: radius,
            hoverColor: activeColor.withValues(alpha: 0.02),
            splashColor: activeColor.withValues(alpha: 0.06),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              child: chipContent,
            ),
          ),
        ),
      );
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: decoration,
      child: chipContent,
    );
  }
}

// ── Legacy Compatibility Wrappers ──

/// [InfoChip] يعتمد هندسياً على [AppChip.info].
class InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final Color? color;

  const InfoChip({
    super.key,
    required this.icon,
    required this.label,
    this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AppChip.info(icon: icon, label: label, value: value, color: color);
  }
}

/// [StatChip] يعتمد هندسياً على [AppChip.stat].
class StatChip extends StatelessWidget {
  final String label;
  final dynamic count;
  final Color color;
  final IconData icon;

  const StatChip({
    super.key,
    required this.label,
    required this.count,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AppChip.stat(label: label, count: count, color: color, icon: icon);
  }
}

/// [QuickFilterChip] يعتمد هندسياً على [AppChip.filter].
class QuickFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? color;

  const QuickFilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AppChip.filter(
      label: label,
      isSelected: isSelected,
      onTap: onTap,
      color: color,
    );
  }
}
