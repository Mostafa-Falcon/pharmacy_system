import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pharmacy_system/app/core/presentation/theme/app_colors.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_sizes.dart';

import '../display/app_text.dart';

/// شِـِّـل (Bottom Sheet) موحّد لكل المنظومة.
/// بيلفّ المحتوى بكارت مظبوط (حواف ناعمة + ظل + بوردر ديناميكي حسب الثيم)
/// مع هيدر اختياري (أيقونة دائرية + عنوان) وـ grab handle علوي،
/// عشان نلغي أي تكرار في كل الـ showModalBottomSheet بالمنظومة.
class ReusableBottomSheet extends StatelessWidget {
  final Widget? headerIcon;
  final Color? headerIconColor;
  final String? title;
  final List<Widget> children;
  final double? maxHeightFactor;
  final EdgeInsets? contentPadding;
  final bool showDragHandle;

  const ReusableBottomSheet({
    super.key,
    this.headerIcon,
    this.headerIconColor,
    this.title,
    required this.children,
    this.maxHeightFactor = 0.9,
    this.contentPadding,
    this.showDragHandle = true,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = AppColors.isDark(context);
    final hasHeader = headerIcon != null || title != null;

    return Container(
      constraints: maxHeightFactor != null
          ? BoxConstraints(maxHeight: MediaQuery.of(context).size.height * maxHeightFactor!)
          : null,
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl.r)),
        border: Border.all(
          color: AppColors.borderOf(context).withValues(alpha: 0.25),
          width: 1.w,
        ),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withValues(alpha: isDark ? 0.3 : 0.08),
            blurRadius: 24,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (showDragHandle)
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 10.h, bottom: hasHeader ? 4.h : 12.h),
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.borderOf(context).withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
              ),
            ),
          if (hasHeader) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (headerIcon != null)
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: (headerIconColor ?? scheme.primary).withValues(alpha: 0.12),
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
            SizedBox(height: 16.h),
          ],
          Flexible(
            child: SingleChildScrollView(
              padding: contentPadding ?? EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: children,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// دالة استاتيكية لعرض الـ Bottom Sheet بسهولة.
  static Future<T?> show<T>({
    required BuildContext context,
    Widget? headerIcon,
    Color? headerIconColor,
    String? title,
    required List<Widget> children,
    double? maxHeightFactor,
    bool showDragHandle = true,
    bool isScrollControlled = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      builder: (ctx) => ReusableBottomSheet(
        headerIcon: headerIcon,
        headerIconColor: headerIconColor,
        title: title,
        maxHeightFactor: maxHeightFactor,
        showDragHandle: showDragHandle,
        children: children,
      ),
    );
  }
}
