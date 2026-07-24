import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pharmacy_system/app/shared/ui_core.dart';


/// عنصر قائمة (PopupMenuItem) موحّد لكل أكشنات الـ Overflow/Context menus
/// في المنظومة (تعديل / حذف / تفعيل / تعطيل / تعيين افتراضي ... إلخ).
///
/// الهدف: إنهاء التكرار (كان متوزع في +55 مكان) وتوحيد الأيقونة + اللون
/// + النص داخل [ReusableText] عشان نستفيد من الـ theme والـ i18n.
class AppActionMenuItem extends PopupMenuItem<String> {
  AppActionMenuItem({
    super.key,
    required super.value,
    required IconData icon,
    required String label,
    Color? color,
    super.enabled,
    super.height,
  }) : super(
          child: _AppActionMenuItemChild(
            icon: icon,
            label: label,
            color: color,
          ),
        );
}

class _AppActionMenuItemChild extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;

  const _AppActionMenuItemChild({
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
        AppText(
          label,
          style: AppTextStyles.body(context).copyWith(color: color),
        ),
      ],
    );
  }
}



