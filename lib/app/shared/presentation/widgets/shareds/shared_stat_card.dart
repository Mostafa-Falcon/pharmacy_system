import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pharmacy_system/app/shared/ui_core.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/index.dart';

enum StatTrendDirection { up, down, neutral }

class SharedStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color? color;
  final StatTrendDirection trend;
  final String? trendValue;
  final VoidCallback? onTap;

  const SharedStatCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    required this.icon,
    this.color,
    this.trend = StatTrendDirection.neutral,
    this.trendValue,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = AppColors.isDark(context);
    final cardColor = color ?? scheme.primary;

    final trendIcon = switch (trend) {
      StatTrendDirection.up => Icons.trending_up_rounded,
      StatTrendDirection.down => Icons.trending_down_rounded,
      StatTrendDirection.neutral => Icons.trending_flat_rounded,
    };

    final trendColor = switch (trend) {
      StatTrendDirection.up =>
        isDark ? const Color(0xFF4ADE80) : const Color(0xFF16A34A),
      StatTrendDirection.down =>
        isDark ? const Color(0xFFF87171) : const Color(0xFFDC2626),
      StatTrendDirection.neutral => AppColors.textSecondaryOf(context),
    };

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md.r),
        hoverColor: cardColor.withValues(alpha: 0.04),
        splashColor: cardColor.withValues(alpha: 0.08),
        child: Container(
          padding: EdgeInsets.all(AppSpacing.md.w),
          decoration: BoxDecoration(
            color: AppColors.surfaceOf(context),
            borderRadius: BorderRadius.circular(AppRadius.md.r),
            border: Border.all(
              color: cardColor.withValues(alpha: isDark ? 0.25 : 0.15),
              width: 1.w,
            ),
            boxShadow: [
              BoxShadow(
                color: cardColor.withValues(alpha: isDark ? 0.06 : 0.04),
                blurRadius: 10.r,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ReusableText(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondaryOf(context),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: cardColor.withValues(alpha: isDark ? 0.15 : 0.08),
                      borderRadius: BorderRadius.circular(AppRadius.sm.r),
                    ),
                    child: Icon(icon, size: 18.sp, color: cardColor),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.sm.h),
              ReusableText(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimaryOf(context),
                  letterSpacing: -0.5,
                ),
              ),
              if (subtitle != null || trendValue != null) ...[
                SizedBox(height: AppSpacing.xs.h),
                Row(
                  children: [
                    if (trendValue != null) ...[
                      Icon(trendIcon, size: 14.sp, color: trendColor),
                      SizedBox(width: 4.w),
                      ReusableText(
                        trendValue!,
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: trendColor,
                        ),
                      ),
                      SizedBox(width: 6.w),
                    ],
                    if (subtitle != null)
                      Expanded(
                        child: ReusableText(
                          subtitle!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.textSecondaryOf(context),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}



