import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import 'package:pharmacy_system/app/shared/ui_core.dart';
import 'package:pharmacy_system/app/shared/widgets/display/app_text.dart';

class DateRangePicker extends StatelessWidget {
  final DateTime? fromDate;
  final DateTime? toDate;
  final VoidCallback? onFromTap;
  final VoidCallback? onToTap;
  final String fromLabel;
  final String toLabel;

  const DateRangePicker({
    super.key,
    this.fromDate,
    this.toDate,
    this.onFromTap,
    this.onToTap,
    this.fromLabel = GeneralStrings.startDate,
    this.toLabel = GeneralStrings.endDate,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _DateBox(
          label: fromDate != null
              ? DateFormat('yyyy/MM/dd').format(fromDate!)
              : fromLabel,
          onTap: onFromTap,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: AppText(
            '←',
            style: AppTextStyles.body(context),
          ),
        ),
        _DateBox(
          label: toDate != null
              ? DateFormat('yyyy/MM/dd').format(toDate!)
              : toLabel,
          onTap: onToTap,
        ),
      ],
    );
  }
}

class _DateBox extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const _DateBox({required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: scheme.outlineVariant),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.calendar_month_rounded,
                size: AppIconSize.md.value, color: Colors.grey),
            SizedBox(width: 8.w),
            AppText(
              label,
              style: AppTextStyles.body(context)
                  .copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}




