import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pharmacy_system/app/core/presentation/theme/app_colors.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_sizes.dart';

import '../display/app_text.dart';

/// عدّاد كمية موحّد (- [قيمة] +).
/// بيلغي تكرار أزرار الزيادة/النقصان في السلة وطباعة الباركود.
class QuantityStepper extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int? max;

  const QuantityStepper({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final canDecrease = value > min;
    final canIncrease = max == null || value < max!;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputFillOf(context),
        borderRadius: BorderRadius.circular(AppRadius.md.w),
        border: Border.all(color: AppColors.borderOf(context).withValues(alpha: 0.4), width: 1.w),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _btn(context, Icons.remove_rounded, canDecrease ? () => onChanged(value - 1) : null),
          Container(
            constraints: BoxConstraints(minWidth: 36.w),
            alignment: Alignment.center,
            child: ReusableText(
              '$value',
              style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.w800, color: scheme.primary),
            ),
          ),
          _btn(context, Icons.add_rounded, canIncrease ? () => onChanged(value + 1) : null),
        ],
      ),
    );
  }

  Widget _btn(BuildContext context, IconData icon, VoidCallback? onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.sm.w),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(6.w),
          child: Icon(
            icon,
            size: AppIconSize.md.value,
            color: onTap != null
                ? Theme.of(context).colorScheme.primary
                : AppColors.textMutedOf(context).withValues(alpha: 0.4),
          ),
        ),
      ),
    );
  }
}
