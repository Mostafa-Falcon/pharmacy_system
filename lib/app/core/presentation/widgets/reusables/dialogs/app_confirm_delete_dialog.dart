import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pharmacy_system/app/core/constants/app_strings.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_colors.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_sizes.dart';

import '../buttons/app_button.dart';
import '../display/app_text.dart';

class ConfirmDeleteDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final VoidCallback onConfirm;

  const ConfirmDeleteDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = AppStrings.confirmDeleteYes,
    required this.onConfirm,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = AppStrings.confirmDeleteYes,
    required VoidCallback onConfirm,
  }) {
    return showDialog(
      context: context,
      builder: (_) => _build(context, title, message, confirmText, onConfirm),
      barrierColor: Colors.black54,
    );
  }

  static Widget _build(BuildContext context, String title, String message, String confirmText, VoidCallback onConfirm) {
    return Builder(builder: (context) {
      final scheme = Theme.of(context).colorScheme;

      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(maxWidth: 380.w), // تعديل هندسي مريح للعرض
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: AppColors.surfaceOf(context),
            borderRadius: BorderRadius.circular(AppRadius.lg.r),
            border: Border.all(
              color: AppColors.borderOf(context).withValues(alpha: 0.25),
              width: 1.w,
            ),
            boxShadow: [
              BoxShadow(
                color: scheme.shadow.withValues(alpha: AppColors.isDark(context) ? 0.2 : 0.05),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch, // جعل العناصر تمتد لتناسق الزراير
            children: [
              // العنوان مع الأيقونة
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: scheme.error.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.warning_amber_rounded,
                      color: scheme.error,
                      size: AppIconSize.md.value,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ReusableText(
                      title,
                      style: AppTextStyles.title(context).copyWith(color: AppColors.textPrimaryOf(context)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14.h),

              // محتوى الرسالة
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: ReusableText(
                  message,
                  style: AppTextStyles.body(context).copyWith(
                    height: 1.5,
                    color: AppColors.textSecondaryOf(context),
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // الزراير تحت متظبطة وموزعة بالتساوي
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: ReusableButton(
                      text: AppStrings.confirmCancelUndo,
                      type: ButtonType.text,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ReusableButton(
                      text: confirmText,
                      type: ButtonType.primary, // لو عندك الـ ReusableButton بياخد color خليه ياخد scheme.error
                      onPressed: () {
                        Navigator.of(context).pop(); // نقفل الـ Dialog أولاً لتأمين الـ Navigation Stack
                        onConfirm(); // ننفذ الأكشن في الـ background بأمان
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return _build(context, title, message, confirmText, onConfirm);
  }
}
