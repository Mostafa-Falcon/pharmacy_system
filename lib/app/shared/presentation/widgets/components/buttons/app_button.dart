import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pharmacy_system/app/shared/ui_core.dart';

enum ButtonType { primary, outlined, text, tonal, error, success }

enum ButtonSize { small, medium, large }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final ButtonSize size;
  final bool isLoading;
  final bool enabled;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final double? width;
  final double? height;
  final Color? color;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon,
    this.width,
    this.height,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = AppColors.isDark(context);
    final isButtonEnabled = enabled && !isLoading && onPressed != null;

    // ألوان الخلفية المنسقة بدقة
    Color getBackgroundColor() {
      if (!isButtonEnabled) {
        return isDark
            ? scheme.surfaceContainerHigh.withValues(alpha: 0.4)
            : scheme.surfaceContainerLow.withValues(alpha: 0.7);
      }
      if (color != null) return color!;
      switch (type) {
        case ButtonType.primary:
          return scheme.primary;
        case ButtonType.error:
          return scheme.error;
        case ButtonType.success:
          return AppColors.success;
        case ButtonType.tonal:
          return isDark
              ? scheme.primary.withValues(alpha: 0.15)
              : scheme.primary.withValues(alpha: 0.08);
        case ButtonType.outlined:
        case ButtonType.text:
          return Colors.transparent;
      }
    }

    // ألوان النصوص والأيقونات
    Color getTextColor() {
      if (!isButtonEnabled) {
        return AppColors.textMutedOf(context).withValues(alpha: 0.5);
      }
      if (color != null) {
        return ThemeData.estimateBrightnessForColor(color!) == Brightness.dark
            ? Colors.white
            : Colors.black87;
      }
      switch (type) {
        case ButtonType.primary:
          return scheme.onPrimary;
        case ButtonType.error:
          return scheme.onError;
        case ButtonType.success:
          return Colors.white;
        case ButtonType.tonal:
        case ButtonType.outlined:
        case ButtonType.text:
          return scheme.primary;
      }
    }

    // بوردر هندسي دقيق للـ Outlined
    Border? getBorder() {
      if (type == ButtonType.outlined) {
        return Border.all(
          color: isButtonEnabled
              ? scheme.primary.withValues(alpha: 0.5)
              : AppColors.borderOf(context).withValues(alpha: 0.2),
          width: 1.2.w,
        );
      }
      return null;
    }

    // استخدام .r للـ Radius لضمان تدويرة مثالية ومستقرة هندسياً
    final radius = BorderRadius.circular(
      size == ButtonSize.small ? AppRadius.sm.r : AppRadius.md.r,
    );

    double getButtonHeight() {
      if (height != null) return height!;
      switch (size) {
        case ButtonSize.small: return 32.0;
        case ButtonSize.large: return 56.0;
        case ButtonSize.medium: return 48.0;
      }
    }

    double getFontSize() {
      switch (size) {
        case ButtonSize.small: return 11.5.sp;
        case ButtonSize.large: return 15.sp;
        case ButtonSize.medium: return 13.5.sp;
      }
    }

    double getIconSize() {
      switch (size) {
        case ButtonSize.small: return 14.sp;
        case ButtonSize.large: return 20.sp;
        case ButtonSize.medium: return 16.sp;
      }
    }

    return _ButtonScaleWrapper(
      isEnabled: isButtonEnabled,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: width,
        height: getButtonHeight(), // ترك الارتفاع القياسي بدون .h لمنع تمطيط الزرار رأسياً
        decoration: BoxDecoration(
          color: getBackgroundColor(),
          border: getBorder(),
          borderRadius: radius,
          boxShadow: (type == ButtonType.primary && isButtonEnabled)
              ? [
            BoxShadow(
              color: scheme.primary.withValues(alpha: isDark ? 0.2 : 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ]
              : [],
        ),
        child: ClipRRect(
          borderRadius: radius,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: isButtonEnabled ? onPressed : null,
              // تظبيط ألوان التفاعل بناءً على نوع الزرار عشان تنطق في الشاشة
              hoverColor: type == ButtonType.primary
                  ? Colors.white.withValues(alpha: 0.04)
                  : scheme.primary.withValues(alpha: 0.03),
              highlightColor: type == ButtonType.primary
                  ? Colors.white.withValues(alpha: 0.06)
                  : scheme.primary.withValues(alpha: 0.04),
              splashColor: type == ButtonType.primary
                  ? Colors.white.withValues(alpha: 0.1)
                  : scheme.primary.withValues(alpha: 0.08),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: size == ButtonSize.small ? AppSpacing.sm : AppSpacing.md),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isLoading) ...[
                      SizedBox(
                        width: getIconSize(),
                        height: getIconSize(), // استخدام نفس التناسب للودر
                        child: CircularProgressIndicator(
                          strokeWidth: 2.w,
                          valueColor: AlwaysStoppedAnimation<Color>(getTextColor()),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Flexible(
                        child: Text(
                          isLoading ? GeneralStrings.loading : text,
                          style: AppTextStyles.button(context).copyWith(
                            color: getTextColor(),
                            fontSize: getFontSize(),
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ] else ...[
                      if (prefixIcon != null) ...[
                        Icon(prefixIcon, size: getIconSize(), color: getTextColor()),
                        SizedBox(width: AppSpacing.xs),
                      ],
                      Flexible(
                        child: Text(
                          text,
                          style: AppTextStyles.button(context).copyWith(
                            color: getTextColor(),
                            fontSize: getFontSize(),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.2,
                            fontFamily: 'Cairo',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (suffixIcon != null) ...[
                        SizedBox(width: AppSpacing.xs),
                        Icon(suffixIcon, size: getIconSize(), color: getTextColor()),
                      ],
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

typedef ReusableButton = AppButton;

/// أنيميشن سبرينج احترافي عند التحويم أو الضغط لإعطاء الزرار طابع حيوي وممتاز
class _ButtonScaleWrapper extends StatefulWidget {
  const _ButtonScaleWrapper({required this.child, required this.isEnabled});
  final Widget child;
  final bool isEnabled;

  @override
  State<_ButtonScaleWrapper> createState() => _ButtonScaleWrapperState();
}

class _ButtonScaleWrapperState extends State<_ButtonScaleWrapper> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    if (!widget.isEnabled) return widget.child;
    double scale = 1.0;
    if (_isPressed) {
      scale = 0.96;
    } else if (_isHovered) {
      scale = 1.02;
    }
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOutCubic,
          child: widget.child,
        ),
      ),
    );
  }
}

/// زرار الإضافة السريعة ذو المظهر الأنيق والتحجيم المربع المتناسق بالملي
class AppAddButton extends StatelessWidget {
  const AppAddButton({super.key, required this.onPressed, this.tooltip});

  final VoidCallback onPressed;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = AppColors.isDark(context);
    final effectiveTooltip = tooltip ?? WidgetStrings.buttonAddNew;
    return Tooltip(
      message: effectiveTooltip,
      child: _ButtonScaleWrapper(
        isEnabled: true,
        child: Material(
          color: isDark ? scheme.surfaceContainerHigh : scheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(AppRadius.md.r),
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(AppRadius.md.r),
            child: Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.md.r),
                border: Border.all(color: AppColors.borderOf(context).withValues(alpha: 0.6), width: 1.w),
              ),
              child: Icon(
                Icons.add_rounded,
                color: scheme.primary,
                size: 22.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
