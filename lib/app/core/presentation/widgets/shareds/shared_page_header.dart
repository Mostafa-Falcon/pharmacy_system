import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pharmacy_system/app/core/presentation/theme/app_colors.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_sizes.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/index.dart';
import 'shared_stat_card.dart';

class SharedPageHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;
  final List<Widget>? actions;
  final List<SharedStatCard>? stats;
  final TabBar? tabBar;
  final Widget? customHeaderBottom;

  const SharedPageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.actions,
    this.stats,
    this.tabBar,
    this.customHeaderBottom,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = AppColors.isDark(context);
    final primaryColor = iconColor ?? scheme.primary;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg.w,
        vertical: AppSpacing.md.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(AppRadius.md.r),
        border: Border.all(
          color: AppColors.borderOf(context).withValues(alpha: 0.2),
          width: 1.w,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 12.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top Row: Title + Icon + Actions
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 600;
              final headerInfo = Row(
                children: [
                  if (icon != null) ...[
                    Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(
                          alpha: isDark ? 0.18 : 0.08,
                        ),
                        borderRadius: BorderRadius.circular(AppRadius.sm.r),
                        border: Border.all(
                          color: primaryColor.withValues(alpha: 0.2),
                          width: 1.w,
                        ),
                      ),
                      child: Icon(icon, size: 22.sp, color: primaryColor),
                    ),
                    SizedBox(width: AppSpacing.md.w),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ReusableText(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimaryOf(context),
                            letterSpacing: -0.3,
                          ),
                        ),
                        if (subtitle != null &&
                            subtitle!.trim().isNotEmpty) ...[
                          SizedBox(height: 2.h),
                          ReusableText(
                            subtitle!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.textSecondaryOf(context),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              );

              if (actions == null || actions!.isEmpty) {
                return headerInfo;
              }

              if (isNarrow) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    headerInfo,
                    SizedBox(height: AppSpacing.sm.h),
                    Wrap(
                      spacing: AppSpacing.xs.w,
                      runSpacing: AppSpacing.xs.h,
                      children: actions!,
                    ),
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(child: headerInfo),
                  SizedBox(width: AppSpacing.md.w),
                  Wrap(
                    spacing: AppSpacing.xs.w,
                    runSpacing: AppSpacing.xs.h,
                    children: actions!,
                  ),
                ],
              );
            },
          ),

          // Stat Cards Grid/Row
          if (stats != null && stats!.isNotEmpty) ...[
            SizedBox(height: AppSpacing.md.h),
            LayoutBuilder(
              builder: (context, constraints) {
                final count = stats!.length;
                final crossAxisCount = constraints.maxWidth < 600
                    ? 1
                    : (constraints.maxWidth < 900 ? 2 : count);

                if (crossAxisCount == 1 || count == 1) {
                  return Column(
                    children: stats!
                        .map(
                          (s) => Padding(
                            padding: EdgeInsets.only(bottom: AppSpacing.xs.h),
                            child: s,
                          ),
                        )
                        .toList(),
                  );
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: AppSpacing.md.w,
                    mainAxisSpacing: AppSpacing.sm.h,
                    mainAxisExtent: 94.h,
                  ),
                  itemCount: count,
                  itemBuilder: (context, index) => stats![index],
                );
              },
            ),
          ],

          if (customHeaderBottom != null) ...[
            SizedBox(height: AppSpacing.sm.h),
            customHeaderBottom!,
          ],

          // Optional TabBar
          if (tabBar != null) ...[
            SizedBox(height: AppSpacing.xs.h),
            Theme(
              data: theme.copyWith(
                colorScheme: scheme.copyWith(
                  surfaceContainerHighest: Colors.transparent,
                ),
              ),
              child: tabBar!,
            ),
          ],
        ],
      ),
    );
  }
}
