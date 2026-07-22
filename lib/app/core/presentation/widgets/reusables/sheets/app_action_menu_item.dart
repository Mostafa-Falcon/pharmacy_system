import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pharmacy_system/app/core/presentation/theme/app_colors.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_sizes.dart';

import '../display/app_text.dart';

/// عنصر قائمة (PopupMenuItem) موحّد لكل أكشنات الـ Overflow/Context menus
/// في المنظومة (تعديل / حذف / تفعيل / تعطيل / تعيين افتراضي ... إلخ).
///
/// الهدف: إنهاء التكرار (كان متوزع في +55 مكان) وتوحيد الأيقونة + اللون
/// + النص داخل [ReusableText] عشان نستفيد من الـ theme والـ i18n.
class ReusableActionMenuItem extends PopupMenuItem<String> {
  ReusableActionMenuItem({
    super.key,
    required super.value,
    required IconData icon,
    required String label,
    Color? color,
    super.enabled,
    super.height,
  }) : super(
          child: _ReusableActionMenuItemChild(
            icon: icon,
            label: label,
            color: color,
          ),
        );
}

class _ReusableActionMenuItemChild extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;

  const _ReusableActionMenuItemChild({
    required this.icon,
    required this.label,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColors.textSecondaryOf(context);
    return Row(
      children: [
        Icon(icon, size: AppIconSize.md.value, color: effectiveColor),
        SizedBox(width: 8.w),
        ReusableText(
          label,
          style: AppTextStyles.body(context).copyWith(color: color),
        ),
      ],
    );
  }
}
