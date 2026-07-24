import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_system/app/shared/ui_core.dart';
import 'package:pharmacy_system/app/shared/widgets/buttons/app_button.dart';
import 'package:pharmacy_system/app/shared/widgets/display/app_card.dart';

import 'home_shell.dart';

/// تخطيط معياري موحد لصفحات النماذج (الإضافة والتعديل).
class StandardFormLayout extends StatelessWidget {
  final String title;
  final String? subtitle;
  final GlobalKey<FormState>? formKey;
  final List<Widget> children;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final bool isSaving;
  final double maxWidth;

  const StandardFormLayout({
    super.key,
    required this.title,
    this.subtitle,
    this.formKey,
    required this.children,
    this.confirmText = GeneralStrings.save,
    this.cancelText = GeneralStrings.cancel,
    required this.onConfirm,
    this.onCancel,
    this.isSaving = false,
    this.maxWidth = 600,
  });

  @override
  Widget build(BuildContext context) {
    return HomeShell(
      title: title,
      subtitle: subtitle,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.xl),
        child: Form(
          key: formKey,
          child: Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: maxWidth.w),
              child: AppCard(
                padding: EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ...children,
                    SizedBox(height: AppSpacing.xxl),
                    _buildActions(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ReusableButton(
            text: cancelText,
            type: ButtonType.outlined,
            onPressed: onCancel ?? () => Navigator.of(context).pop(),
          ),
        ),
        SizedBox(width: AppSpacing.md),
        Expanded(
          child: ReusableButton(
            text: confirmText,
            isLoading: isSaving,
            onPressed: isSaving ? null : onConfirm,
          ),
        ),
      ],
    );
  }
}




