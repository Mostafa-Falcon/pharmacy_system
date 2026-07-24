import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pharmacy_system/app/shared/ui_core.dart';


/// صف إعداد موحّد بمفتاح تبديل (Switch) + أيقونة + عنوان + وصف.
/// يدعم التنسيق الشفاف العادي (للأجهزة والقوائم المتتالية) والتنسيق المعلب Boxed (كبطاقة منفصلة).
class SettingsToggleTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color? color;
  final bool boxed;
  final bool enabled;

  const SettingsToggleTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
    this.color,
    this.boxed = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = AppColors.isDark(context);
    final c = color ?? scheme.primary;

    // توحيد الحواف بـ .r
    final radius = BorderRadius.circular(AppRadius.md.r);

    Widget tileContent = Padding(
      padding: EdgeInsets.symmetric(
        horizontal: boxed ? AppSpacing.md.w : 4.w,
        vertical: boxed ? AppSpacing.md.h : 10.h,
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: c.withValues(alpha: isDark ? 0.15 : 0.08),
              borderRadius: BorderRadius.circular(AppRadius.md.r),
            ),
            child: Icon(icon, size: AppIconSize.md.value, color: c),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText(
                  title,
                  style: AppTextStyles.body(context).copyWith(
                    fontWeight: FontWeight.bold,
                    color: enabled
                        ? AppColors.textPrimaryOf(context)
                        : AppColors.textPrimaryOf(context).withValues(alpha: 0.5),
                  ),
                ),
                if (subtitle != null && subtitle!.trim().isNotEmpty) ...[
                  SizedBox(height: 2.h),
                  AppText(
                    subtitle!,
                    style: AppTextStyles.caption(context).copyWith(
                      color: enabled
                          ? AppColors.textSecondaryOf(context)
                          : AppColors.textSecondaryOf(context).withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Switch(
            value: value,
            onChanged: enabled ? onChanged : null,
            activeThumbColor: c,
          ),
        ],
      ),
    );

    return Semantics(
      toggled: value,
      enabled: enabled,
      label: title,
      child: AnimatedOpacity(
        opacity: enabled ? 1.0 : 0.55,
        duration: const Duration(milliseconds: 150),
        child: Material(
          color: boxed
              ? (isDark ? scheme.surfaceContainerLow : AppColors.lightInputFill.withValues(alpha: 0.5))
              : Colors.transparent,
          shape: boxed
              ? RoundedRectangleBorder(
                  borderRadius: radius,
                  side: BorderSide(
                    color: AppColors.borderOf(context).withValues(alpha: 0.4),
                    width: 1.w,
                  ),
                )
              : null,
          borderRadius: boxed ? null : radius,
          child: InkWell(
            borderRadius: radius,
            onTap: enabled ? () => onChanged(!value) : null,
            child: tileContent,
          ),
        ),
      ),
    );
  }
}



