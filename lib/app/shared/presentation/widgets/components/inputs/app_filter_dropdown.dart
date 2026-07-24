import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pharmacy_system/app/shared/ui_core.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/components/display/app_text.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/components/inputs/app_dropdown.dart';

class FilterDropdown<T> extends StatelessWidget {
  final String label;
  final List<T> items;
  final T? value;
  final ValueChanged<T?> onChanged;
  final String Function(T) itemAsString;

  const FilterDropdown({
    super.key,
    required this.label,
    required this.items,
    this.value,
    required this.onChanged,
    required this.itemAsString,
  });

  const FilterDropdown.string({
    super.key,
    required this.label,
    required this.items,
    this.value,
    required this.onChanged,
  }) : itemAsString = _identityString;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReusableText(
            label,
            style: AppTextStyles.caption(context)
                .copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 6.h),
          ReusableDropdown<T>(
            hintText: label,
            items: items,
            itemAsString: itemAsString,
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

String _identityString(dynamic v) => v.toString();



