import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pharmacy_system/app/core/presentation/theme/app_colors.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_sizes.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/reusables/display/app_text.dart';
import 'shared_stat_card.dart';

class SharedDetailsPageLayout extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? statusBadge;
  final IconData? icon;
  final List<Widget>? actions;
  final List<SharedStatCard>? keyMetrics;
  final Widget body;
  final TabBar? tabBar;

  const SharedDetailsPageLayout({
    super.key,
    required this.title,
    this.subtitle,
    this.statusBadge,
    this.icon,
    this.actions,
    this.keyMetrics,
    required this.body,
    this.tabBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: AppBar(
        backgroundColor: AppColors.surfaceOf(context),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      ReusableText(
                        title,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimaryOf(context),
                        ),
                      ),
                      if (statusBadge != null) ...[
                        SizedBox(width: 8.w),
                        statusBadge!,
                      ],
                    ],
                  ),
                  if (subtitle != null)
                    ReusableText(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.textSecondaryOf(context),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        actions: actions,
        bottom: tabBar,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.md.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (keyMetrics != null && keyMetrics!.isNotEmpty) ...[
                LayoutBuilder(
                  builder: (context, constraints) {
                    final count = keyMetrics!.length;
                    final crossAxisCount = constraints.maxWidth < 600
                        ? 1
                        : (constraints.maxWidth < 900 ? 2 : count);

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
                      itemBuilder: (context, index) => keyMetrics![index],
                    );
                  },
                ),
                SizedBox(height: AppSpacing.md.h),
              ],
              body,
            ],
          ),
        ),
      ),
    );
  }
}
