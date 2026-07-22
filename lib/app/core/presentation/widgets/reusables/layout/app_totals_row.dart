import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pharmacy_system/app/core/presentation/theme/app_colors.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_sizes.dart';

import '../display/app_text.dart';

/// صف (Label ↔ Value) الموحّد المستخدم في ملخصات الفواتير وكشوف الحساب والورديات.
/// بيلغي تكرار `_totalRow` / `_financeRow` / `_summaryRow` / `_Row` في كل الشاشات.
class TotalsRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  final bool bold;
  final double? fontSize;

  const TotalsRow({
    super.key,
    required this.label,
    required this.value,
    this.color,
    this.bold = false,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColors.textSecondaryOf(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: ReusableText(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption(context).copyWith(
                fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
                color: effectiveColor,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          ReusableText(
            value,
            style: AppTextStyles.caption(context).copyWith(
              fontWeight: bold ? FontWeight.w900 : FontWeight.w700,
              color: effectiveColor,
            ),
          ),
        ],
      ),
    );
  }
}
