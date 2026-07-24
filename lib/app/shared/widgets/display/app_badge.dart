import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_system/app/shared/ui_core.dart';

enum AppBadgeTone { success, warning, danger, neutral, info }

/// شارة/تايج موحّد وفائق المرونة (Unified AppBadge UI).
/// يجمع وظائف البادجات، الحالات، والتاجات في مكوّن إنشائي واحد لتسهيل التطوير وتوحيد المظهر.
class AppBadge extends StatelessWidget {
  final String label;
  final Color? color;
  final AppBadgeTone? tone;
  final IconData? icon;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final bool showBorder;

  const AppBadge({
    super.key,
    required this.label,
    this.color,
    this.tone,
    this.icon,
    this.fontSize,
    this.padding,
    this.borderRadius,
    this.showBorder = true,
  });

  const AppBadge.tone({
    super.key,
    required this.label,
    required this.tone,
    this.fontSize,
    this.padding,
    this.borderRadius,
    this.showBorder = false,
  }) : color = null,
       icon = null;

  const AppBadge.status({
    super.key,
    required this.label,
    required this.color,
    this.icon,
    this.fontSize,
    this.padding,
    this.borderRadius,
    this.showBorder = true,
  }) : tone = null;

  const AppBadge.tag({
    super.key,
    required this.label,
    required this.color,
    this.fontSize,
    this.padding,
    this.borderRadius,
    this.showBorder = true,
  }) : tone = null,
       icon = null;

  (Color foreground, Color background) _resolveFromTone(
    BuildContext context,
    AppBadgeTone tone,
  ) {
    final scheme = Theme.of(context).colorScheme;
    return switch (tone) {
      AppBadgeTone.success => (
        AppColors.success,
        AppColors.successSoftOf(context),
      ),
      AppBadgeTone.warning => (
        AppColors.warning,
        AppColors.warningSoftOf(context),
      ),
      AppBadgeTone.danger => (AppColors.error, AppColors.errorSoftOf(context)),
      AppBadgeTone.info => (AppColors.info, AppColors.infoSoftOf(context)),
      AppBadgeTone.neutral => (
        scheme.onSurfaceVariant,
        scheme.surfaceContainerHigh,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);
    final Color foreground;
    final Color background;

    if (tone != null) {
      (foreground, background) = _resolveFromTone(context, tone!);
    } else if (color != null) {
      foreground = color!;
      background = color!.withValues(alpha: isDark ? 0.15 : 0.08);
    } else {
      final scheme = Theme.of(context).colorScheme;
      foreground = scheme.primary;
      background = scheme.primary.withValues(alpha: isDark ? 0.15 : 0.08);
    }

    final effectiveRadius =
        borderRadius ?? BorderRadius.circular(AppRadius.pill);
    final effectivePadding =
        padding ?? EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: effectivePadding,
      decoration: BoxDecoration(
        color: background,
        borderRadius: effectiveRadius,
        border: showBorder && color != null
            ? Border.all(
                color: color!.withValues(alpha: isDark ? 0.3 : 0.2),
                width: 0.8.w,
              )
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: AppIconSize.sm.value, color: foreground),
            SizedBox(width: 4.w),
          ],
          FittedBox(
            fit: BoxFit.scaleDown,
            child: ReusableText(
              label,
              style: AppTextStyles.caption(
                context,
              ).copyWith(fontWeight: FontWeight.w700, color: foreground),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Legacy Compatibility Wrappers ──

typedef ReusableBadgeTone = AppBadgeTone;

/// شارة حالة موحّدة تعتمد على [AppBadge.status].
class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;

  const StatusBadge({
    super.key,
    required this.label,
    required this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AppBadge.status(label: label, color: color, icon: icon);
  }
}

/// تاج موحّد يعتمد على [AppBadge.tag].
class Tag extends StatelessWidget {
  final String label;
  final Color color;

  const Tag({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return AppBadge.tag(label: label, color: color);
  }
}

// Legacy typedef for backward compatibility
typedef ReusableBadge = AppBadge;
