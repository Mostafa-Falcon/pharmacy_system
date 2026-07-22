import 'package:flutter/material.dart';

import 'package:pharmacy_system/app/core/presentation/theme/app_sizes.dart';

import 'package:pharmacy_system/app/core/constants/app_strings.dart';
import '../inputs/app_input.dart';

/// حقل بحث موحّد فوق [ReusableInput] بأيقونة بحث وزر مسح تلقائي.
/// بيلغي تكرار `TextField` الخام للبحث في كل القوائم.
class SearchField extends StatelessWidget {
  final TextEditingController? controller;
  final String hint;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final bool autofocus;
  final Widget? suffixIcon;

  const SearchField({
    super.key,
    this.controller,
    this.hint = AppStrings.searchHint,
    this.onChanged,
    this.onClear,
    this.autofocus = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return ReusableInput(
      controller: controller,
      hint: hint,
      onChanged: onChanged,
      onClear: onClear,
      autofocus: autofocus,
      prefixIcon: Icon(Icons.search_rounded, size: AppIconSize.md.value),
      suffixIcon: suffixIcon,
      textInputAction: TextInputAction.search,
    );
  }
}
