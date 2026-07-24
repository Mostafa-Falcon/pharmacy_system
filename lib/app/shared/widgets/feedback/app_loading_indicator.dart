import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pharmacy_system/app/shared/ui_core.dart';


/// مؤشر تحميل موحّد بديل التكرار اليدوي لـ `Center(child: CircularProgressIndicator())`.
/// بيلغي تكرار الـ loading spinner في الـ 51 شاشة ويوفّر شكل ثابت في كل الثيمز.
class LoadingIndicator extends StatelessWidget {
  final double size;
  final double strokeWidth;
  final String? message;
  final Color? color;

  const LoadingIndicator({
    super.key,
    this.size = 28,
    this.strokeWidth = 3,
    this.message,
    this.color,
  });

  const LoadingIndicator.inline({
    super.key,
    this.size = 18,
    this.strokeWidth = 2,
    this.message,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final indicator = SizedBox(
      width: size.w,
      height: size.w,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth.w,
        valueColor: AlwaysStoppedAnimation<Color>(color ?? scheme.primary),
      ),
    );

    if (message == null) return Center(child: indicator);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          indicator,
          SizedBox(height: 12.h),
          ReusableText(
            message!,
            style: AppTextStyles.caption(context).copyWith(color: AppColors.textSecondaryOf(context)),
          ),
        ],
      ),
    );
  }
}



