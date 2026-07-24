import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pharmacy_system/app/shared/ui_core.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/reusables/buttons/app_button.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/reusables/display/app_text.dart';

class SharedFormSection extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget child;

  const SharedFormSection({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.md.h),
      padding: EdgeInsets.all(AppSpacing.lg.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(AppRadius.md.r),
        border: Border.all(
          color: AppColors.borderOf(context).withValues(alpha: 0.2),
          width: 1.w,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 18.sp,
                  color: scheme.primary,
                ),
                SizedBox(width: 8.w),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReusableText(
                      title,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimaryOf(context),
                      ),
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: 2.h),
                      ReusableText(
                        subtitle!,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.textSecondaryOf(context),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm.h),
          Divider(
            color: AppColors.borderOf(context).withValues(alpha: 0.15),
            height: 1.h,
          ),
          SizedBox(height: AppSpacing.md.h),
          child,
        ],
      ),
    );
  }
}

class SharedFormPageLayout extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final List<Widget> sections;
  final VoidCallback onSave;
  final VoidCallback? onSaveAndNew;
  final VoidCallback? onCancel;
  final bool isSaving;
  final String saveButtonText;
  final IconData saveButtonIcon;

  const SharedFormPageLayout({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    required this.sections,
    required this.onSave,
    this.onSaveAndNew,
    this.onCancel,
    this.isSaving = false,
    this.saveButtonText = GeneralStrings.saveData,
    this.saveButtonIcon = Icons.save_rounded,
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
          onPressed: onCancel ?? () => Navigator.maybePop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ReusableText(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimaryOf(context),
              ),
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
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppSpacing.md.w),
                child: Column(
                  children: sections,
                ),
              ),
            ),

            // Sticky Bottom Action Bar
            Container(
              padding: EdgeInsets.all(AppSpacing.md.w),
              decoration: BoxDecoration(
                color: AppColors.surfaceOf(context),
                border: Border(
                  top: BorderSide(
                    color: AppColors.borderOf(context).withValues(alpha: 0.2),
                    width: 1.w,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: isSaving ? null : (onCancel ?? () => Navigator.maybePop(context)),
                    child: const Text(GeneralStrings.cancel),
                  ),
                  SizedBox(width: AppSpacing.sm.w),
                  if (onSaveAndNew != null) ...[
                    OutlinedButton.icon(
                      onPressed: isSaving ? null : onSaveAndNew,
                      icon: const Icon(Icons.add_rounded),
                      label: const Text(GeneralStrings.saveAndAddAnother),
                    ),
                    SizedBox(width: AppSpacing.sm.w),
                  ],
                  ReusableButton(
                    text: saveButtonText,
                    prefixIcon: saveButtonIcon,
                    isLoading: isSaving,
                    onPressed: isSaving ? null : onSave,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}




