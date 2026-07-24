import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pharmacy_system/app/shared/ui_core.dart';

/// زرار موبايل بأيقونة فوق وتحتها نص — مستخدم في شاشات POS الموبايل
/// (الدفع: نقدي/بطاقة/آجل/مختلط/تعليق/عرض سعر) وأي شاشة موبايل تانية.
///
/// الكلاس استُخرج من [_mobileBtn] في [MobileCartTab] لتوحيد الشكل والـ
/// disabled-state والـ semantic color عبر المنظومة.
class ReusableIconTextButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onPressed;
  final bool isEnabled;
  final bool expand;
  final double iconSize;
  final double fontSize;

  const ReusableIconTextButton({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    this.onPressed,
    this.isEnabled = true,
    this.expand = true,
    this.iconSize = 18,
    this.fontSize = 9,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveEnabled = isEnabled && onPressed != null;
    final child = Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: color.withValues(alpha: effectiveEnabled ? 0.12 : 0.05),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          padding: EdgeInsets.symmetric(vertical: 10.h),
        ),
        onPressed: effectiveEnabled ? onPressed : null,
        child: Column(
          children: [
            Icon(
              icon,
              color: effectiveEnabled ? color : color.withValues(alpha: 0.4),
              size: AppIconSize.md.value,
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              style: AppTextStyles.caption(context).copyWith(
                color: effectiveEnabled ? color : color.withValues(alpha: 0.4),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );

    return expand ? Expanded(child: child) : child;
  }
}

/// تبويب تنقّل سفلي (BottomNavigationBar item) بأيقونة ونص — مستخرج من
/// [_navTab] في [MobileLayout] لتوحيد حالة التحديد (selected) عبر الشاشات.
class ReusableNavTab extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final Color? selectedColor;

  const ReusableNavTab({
    super.key,
    required this.icon,
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.selectedColor,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = selectedColor ?? AppColors.surfaceTintDarkAlt;
    final color = isSelected ? activeColor : Colors.grey;
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: AppIconSize.md.value),
          SizedBox(height: 2.h),
          Text(
            label,
            style: AppTextStyles.caption(context).copyWith(
              color: color,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}




