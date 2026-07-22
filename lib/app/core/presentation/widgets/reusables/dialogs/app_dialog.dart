import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pharmacy_system/app/core/constants/app_strings.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_colors.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_sizes.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/index.dart';

/// Shell موحد لأي حوار (Dialog) في التطبيق.
/// بيلفّ الـ [Dialog] بالكارت المظبوط (حواف ناعمة + ظل + بوردر ديناميكي حسب الثيم)
/// ويوفّر هيدر اختياري (أيقونة دائرية + عنوان) عشان نلغي أي تكرار في كل الحوارات.
class ReusableDialog extends StatelessWidget {
  final Widget? headerIcon;
  final Color? headerIconColor;
  final Color? headerIconBackgroundColor;
  final String? title;
  final List<Widget> children;
  final List<Widget>? footerActions;
  final double? maxWidth;
  final EdgeInsets? insetPadding;
  final EdgeInsetsGeometry? contentPadding;

  const ReusableDialog({
    super.key,
    this.headerIcon,
    this.headerIconColor,
    this.headerIconBackgroundColor,
    this.title,
    required this.children,
    this.footerActions,
    this.maxWidth = 380, // تعديل هندسي مريح وموحد للديالوج
    this.insetPadding,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = AppColors.isDark(context);
    final hasHeader = headerIcon != null || title != null;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: insetPadding ?? EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Builder(
        builder: (context) {
          return Center( // يضمن التمركز المثالي للديالوج على الشاشات الكبيرة والتابلت
            child: Container(
              width: double.infinity,
              constraints: maxWidth != null ? BoxConstraints(maxWidth: maxWidth!.w) : null, // ضبط العرض الأقصى بالـ .w
              padding: contentPadding ?? EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: AppColors.surfaceOf(context),
                borderRadius: BorderRadius.circular(AppRadius.lg.r), // توحيد الحواف بـ .r
                border: Border.all(
                  color: AppColors.borderOf(context).withValues(alpha: 0.25),
                  width: 1.w,
                ),
                boxShadow: [
                  BoxShadow(
                    color: scheme.shadow.withValues(alpha: isDark ? 0.2 : 0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch, // جعل العناصر تمتد لتطابق محاذاة الأزرار بالملي
                children: [
                  if (hasHeader) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (headerIcon != null)
                          Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: (headerIconBackgroundColor ?? headerIconColor ?? scheme.primary)
                                  .withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                            ),
                            child: IconTheme(
                              data: IconThemeData(
                                color: headerIconColor ?? scheme.primary,
                                size: AppIconSize.md.value,
                              ),
                              child: headerIcon!,
                            ),
                          ),
                        if (headerIcon != null) SizedBox(width: 12.w),
                        if (title != null)
                          Expanded(
                            child: ReusableText(
                              title!,
                              style: AppTextStyles.title(context).copyWith(color: AppColors.textPrimaryOf(context)),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 18.h),
                  ],
                  ...children,
                  if (footerActions != null && footerActions!.isNotEmpty) ...[
                    SizedBox(height: 16.h),
                    Wrap(
                      alignment: WrapAlignment.end,
                      spacing: 12.w,
                      runSpacing: 8.h,
                      children: footerActions!,
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// دالة استاتيكية لعرض الديالوج بسهولة
  static Future<T?> show<T>(
    BuildContext context, {
    Widget? headerIcon,
    Color? headerIconColor,
    String? title,
    required List<Widget> children,
    List<Widget>? footerActions,
    double? maxWidth,
  }) {
    return showDialog<T>(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) => ReusableDialog(
        headerIcon: headerIcon,
        headerIconColor: headerIconColor,
        title: title,
        footerActions: footerActions,
        maxWidth: maxWidth,
        children: children,
      ),
    );
  }
}

/// صف الأزرار القياسي أسفل أي حوار: (إلغاء - تأكيد).
/// بيرجّع [Widget] جاهز يُحط جوه الـ [ReusableDialog].
class DialogActions extends StatelessWidget {
  final String cancelText;
  final String confirmText;
  final VoidCallback? onCancel;
  final VoidCallback? onConfirm;
  final ButtonType confirmType;
  final double? spacing;

  const DialogActions({
    super.key,
    this.cancelText = AppStrings.cancel,
    required this.confirmText,
    this.onCancel,
    this.onConfirm,
    this.confirmType = ButtonType.primary,
    this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ReusableButton(
            text: cancelText,
            type: ButtonType.text,
            onPressed: onCancel ?? () => Navigator.of(context).pop(),
          ),
        ),
        SizedBox(width: spacing?.w ?? 12.w), // تأمين الـ spacing بالـ .w
        Expanded(
          child: ReusableButton(
            text: confirmText,
            type: confirmType,
            onPressed: onConfirm,
          ),
        ),
      ],
    );
  }
}
