import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pharmacy_system/app/shared/ui_core.dart';


/// مُكون تراكب (Overlay) لإظهار تقدم العمليات الطويلة (مثل الحذف الجماعي أو الاستيراد).
/// يضمن منع المستخدم من التفاعل مع الواجهة حتى انتهاء العملية مع عرض نسبة مئوية حقيقية.
class AppProgressOverlay extends StatelessWidget {
  final bool isVisible;
  final double progress; // من 0.0 إلى 1.0
  final String title;
  final String? subtitle;

  const AppProgressOverlay({
    super.key,
    required this.isVisible,
    required this.progress,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    final scheme = Theme.of(context).colorScheme;
    final percentage = (progress.clamp(0.0, 1.0) * 100).toInt();

    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      child: Center(
        child: AppCard(
          maxWidth: 400,
          padding: EdgeInsets.all(AppSpacing.xl.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const LoadingIndicator(),
              SizedBox(height: 24.h),
              AppText(
                title,
                style: AppTextStyles.title(context).copyWith(color: AppColors.textPrimaryOf(context)),
                textAlign: TextAlign.center,
              ),
              if (subtitle != null) ...[
                SizedBox(height: 8.h),
                  AppText(
                    subtitle!,
                    style: AppTextStyles.caption(context).copyWith(color: AppColors.textSecondaryOf(context)),
                    textAlign: TextAlign.center,
                  ),
              ],
              SizedBox(height: 20.h),
              
              // شريط التقدم المطور
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 12.h,
                      backgroundColor: scheme.primary.withValues(alpha: 0.1),
                      valueColor: AlwaysStoppedAnimation<Color>(scheme.primary),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    WidgetStrings.progressInProgress,
                    style: AppTextStyles.caption(context).copyWith(color: Colors.grey),
                  ),
                  AppText(
                    '%$percentage',
                    style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.w900, color: scheme.primary),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              AppText(
                InventoryStrings.doNotClosePage,
                style: AppTextStyles.caption(context).copyWith(
                  color: AppColors.error.withValues(alpha: 0.7),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}




