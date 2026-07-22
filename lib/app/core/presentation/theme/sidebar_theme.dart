import 'package:flutter/material.dart';

@immutable
class SidebarTheme extends ThemeExtension<SidebarTheme> {
  final Color backgroundColor;
  final Color textColor;
  final Color mutedColor;
  final Color hoverColor;
  final Color selectedIndicatorColor;
  final Color selectedBackgroundColor;
  final Color dividerColor;

  const SidebarTheme({
    required this.backgroundColor,
    required this.textColor,
    required this.mutedColor,
    required this.hoverColor,
    required this.selectedIndicatorColor,
    required this.selectedBackgroundColor,
    required this.dividerColor,
  });

  @override
  SidebarTheme copyWith({
    Color? backgroundColor,
    Color? textColor,
    Color? mutedColor,
    Color? hoverColor,
    Color? selectedIndicatorColor,
    Color? selectedBackgroundColor,
    Color? dividerColor,
  }) {
    return SidebarTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      mutedColor: mutedColor ?? this.mutedColor,
      hoverColor: hoverColor ?? this.hoverColor,
      selectedIndicatorColor: selectedIndicatorColor ?? this.selectedIndicatorColor,
      selectedBackgroundColor: selectedBackgroundColor ?? this.selectedBackgroundColor,
      dividerColor: dividerColor ?? this.dividerColor,
    );
  }

  @override
  SidebarTheme lerp(covariant ThemeExtension<SidebarTheme>? other, double t) {
    if (other is! SidebarTheme) return this;
    return SidebarTheme(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t) ?? backgroundColor,
      textColor: Color.lerp(textColor, other.textColor, t) ?? textColor,
      mutedColor: Color.lerp(mutedColor, other.mutedColor, t) ?? mutedColor,
      hoverColor: Color.lerp(hoverColor, other.hoverColor, t) ?? hoverColor,
      selectedIndicatorColor: Color.lerp(selectedIndicatorColor, other.selectedIndicatorColor, t) ?? selectedIndicatorColor,
      selectedBackgroundColor: Color.lerp(selectedBackgroundColor, other.selectedBackgroundColor, t) ?? selectedBackgroundColor,
      dividerColor: Color.lerp(dividerColor, other.dividerColor, t) ?? dividerColor,
    );
  }
}
