import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pharmacy_system/app/shared/ui_core.dart';

import '../display/app_text.dart';

class AppProgressBar extends StatelessWidget {
  final double progress;
  final String title;
  final String? subtitle;
  final bool showPercentage;
  final double height;
  final Color? color;

  const AppProgressBar({
    super.key,
    required this.progress,
    required this.title,
    this.subtitle,
    this.showPercentage = true,
    this.height = 8,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final clamped = progress.clamp(0.0, 1.0);
    final percentage = (clamped * 100).toInt();
    final barColor = color ?? scheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: AppText(
                title,
                style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.w600, color: AppColors.textPrimaryOf(context)),
              ),
            ),
            if (showPercentage)
              AppText(
                '%$percentage',
                style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.w900, color: barColor),
              ),
          ],
        ),
        if (subtitle != null) ...[
          SizedBox(height: 2.h),
          AppText(
            subtitle!,
            style: AppTextStyles.caption(context).copyWith(color: AppColors.textSecondaryOf(context)),
          ),
        ],
        SizedBox(height: 8.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          child: LinearProgressIndicator(
            value: clamped,
            minHeight: height.h,
            backgroundColor: barColor.withValues(alpha: 0.12),
            valueColor: AlwaysStoppedAnimation<Color>(barColor),
          ),
        ),
      ],
    );
  }
}



