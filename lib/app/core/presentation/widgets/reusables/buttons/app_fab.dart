import 'package:flutter/material.dart';

import 'package:pharmacy_system/app/core/presentation/theme/app_sizes.dart';

/// زر عائم موحّد (FloatingActionButton) بستايل التطبيق.
class ReusableFab extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final String? tooltip;
  final String? label;

  const ReusableFab({
    super.key,
    required this.icon,
    this.onPressed,
    this.backgroundColor,
    this.tooltip,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg = backgroundColor ?? scheme.primary;

    if (label != null) {
      return FloatingActionButton.extended(
        onPressed: onPressed,
        backgroundColor: bg,
        foregroundColor: Colors.white,
        tooltip: tooltip,
        icon: Icon(icon, size: AppIconSize.md.value),
        label: Text(
          label!,
          style: AppTextStyles.button(context),
        ),
      );
    }

    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: bg,
      foregroundColor: Colors.white,
      tooltip: tooltip,
      child: Icon(icon, size: AppIconSize.lg.value),
    );
  }
}

