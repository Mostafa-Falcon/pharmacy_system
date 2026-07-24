import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_sizes.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/index.dart';

class SettingsFieldBuilders {
  static Widget buildField(
    String label,
    String value,
    ValueChanged<String> onChanged, {
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.md.h),
      child: TextFormField(
        initialValue: value,
        decoration: InputDecoration(labelText: label),
        onChanged: onChanged,
        keyboardType: keyboardType ?? TextInputType.text,
      ),
    );
  }

  static Widget buildToggle(
    String label,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.md.h),
      child: Card(
        child: SwitchListTile(
          title: Text(label),
          value: value,
          onChanged: onChanged,
        ),
      ),
    );
  }

  static Widget buildDropdown(
    String label,
    String value,
    List<String> values,
    List<String> labels,
    ValueChanged<String?> onChanged,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.md.h),
      child: ReusableDropdown<String>(
        hintText: label,
        labelText: label,
        value: value,
        items: values,
        itemAsString: (v) => labels[values.indexOf(v)],
        onChanged: onChanged,
      ),
    );
  }
}



