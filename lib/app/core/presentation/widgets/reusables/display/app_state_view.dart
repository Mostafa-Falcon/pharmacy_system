import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pharmacy_system/app/core/constants/app_strings.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_colors.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_sizes.dart';

import '../display/app_text.dart';

/// مكون موحّد وممركزي لتجسيد جميع حالات الشاشات والـ Views (Empty State, Error, Loading, Permission).
/// يوفر مظهراً بصرياً فخماً مع التوافق التام مع الثيم والدارك مود والتجاوب.
class AppStateView extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Widget? action;
  final Color? iconColor;
  final bool compact;
  final bool isLoading;

  const AppStateView({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    this.action,
    this.iconColor,
    this.compact = false,
    this.isLoading = false,
  });

  const AppStateView.empty({
    super.key,
    required this.title,
    this.subtitle,
    this.icon = Icons.inbox_rounded,
    this.action,
    this.iconColor,
    this.compact = false,
  })  : isLoading = false;

  const AppStateView.error({
    super.key,
    required String message,
    String? title,
    this.icon = Icons.error_outline_rounded,
    this.action,
    this.compact = false,
  })  :         title = title ?? AppStrings.stateViewError,
        subtitle = message,
        iconColor = AppColors.error,
        isLoading = false;

  const AppStateView.permissionDenied({
    super.key,
    required String message,
    String? title,
    this.icon = Icons.lock_outline_rounded,
    this.action,
    this.compact = false,
  })  :         title = title ?? AppStrings.stateViewPermissionDenied,
        subtitle = message,
        iconColor = AppColors.warning,
        isLoading = false;

  const AppStateView.loading({
    super.key,
    String? message,
    this.compact = false,
  })  :         title = message ?? AppStrings.loading,
        subtitle = null,
        icon = Icons.hourglass_empty_rounded,
        action = null,
        iconColor = null,
        isLoading = true;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final effectiveIconColor = iconColor ?? scheme.primary;

    if (isLoading) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(compact ? 16.w : 32.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator.adaptive(),
              SizedBox(height: 16.h),
              ReusableText(
                title,
                style: AppTextStyles.caption(context).copyWith(
                  color: AppColors.textSecondaryOf(context),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final double outerCircleSize = compact ? 64.w : 96.w;
    final double innerCircleSize = compact ? 48.w : 72.w;
    final double iconSize = compact ? AppIconSize.lg.value : AppIconSize.xl.value;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: compact ? 340.w : 440.w),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 16.w : 32.w,
            vertical: compact ? 16.h : 24.h,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: outerCircleSize,
                height: outerCircleSize,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: effectiveIconColor.withValues(alpha: 0.04),
                  shape: BoxShape.circle,
                ),
                child: Container(
                  width: innerCircleSize,
                  height: innerCircleSize,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: effectiveIconColor.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: iconSize,
                    color: effectiveIconColor,
                  ),
                ),
              ),
              SizedBox(height: compact ? 12.h : 20.h),

              ReusableText(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyles.body(context).copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimaryOf(context),
                ),
              ),

              if (subtitle != null && subtitle!.trim().isNotEmpty) ...[
                SizedBox(height: compact ? 6.h : 8.h),
                ReusableText(
                  subtitle!,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body(context).copyWith(
                    height: 1.45,
                    color: AppColors.textSecondaryOf(context),
                  ),
                ),
              ],

              if (action != null) ...[
                SizedBox(height: compact ? 12.h : 20.h),
                action!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ── Legacy Compatibility Wrappers ──

/// [ReusableStateView] يعتمد هندسياً على [AppStateView].
class ReusableStateView extends StatelessWidget {
  final String? title;
  final String message;
  final IconData? icon;
  final Widget? action;
  final bool compact;

  const ReusableStateView({
    super.key,
    required this.message,
    this.icon,
    this.title,
    this.action,
    this.compact = false,
  });

  const ReusableStateView.empty({
    super.key,
    required this.message,
    this.title,
    this.icon = Icons.inbox_outlined,
    this.action,
    this.compact = false,
  });

  const ReusableStateView.permissionDenied({
    super.key,
    required this.message,
    this.title,
    this.icon = Icons.lock_outline_rounded,
    this.action,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppStateView(
      title: title ?? message,
      subtitle: title != null ? message : null,
      icon: icon ?? Icons.info_outline_rounded,
      action: action,
      compact: compact,
    );
  }
}

/// [EmptyState] يعتمد هندسياً على [AppStateView.empty].
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? action;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return AppStateView.empty(
      title: title,
      subtitle: subtitle,
      icon: icon,
      action: action,
    );
  }
}
