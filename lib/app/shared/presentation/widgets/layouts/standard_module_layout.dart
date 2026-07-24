import 'package:flutter/material.dart';
import 'package:pharmacy_system/app/shared/ui_core.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/index.dart';

/// تخطيط معياري موحد لصفحات المنظومة.
/// يضمن ثبات المسافات، توزيع العناصر، وتطبيق الثيم اللوني للقطاع.
class StandardModuleLayout extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final List<Widget>? stats;
  final Widget? filters;
  final Widget? headerWidget;
  final Widget content;
  final bool showProgress;
  final double? progress;
  final String? progressTitle;
  final EdgeInsets? padding;
  final bool useShell;

  const StandardModuleLayout({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    this.stats,
    this.filters,
    this.headerWidget,
    required this.content,
    this.showProgress = false,
    this.progress,
    this.progressTitle,
    this.padding,
    this.useShell = true,
  });

  @override
  Widget build(BuildContext context) {
    final body = Stack(
      children: [
        Container(
          color: AppColors.surfaceContainer(context),
          padding: padding ?? EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (headerWidget != null) ...[
                headerWidget!,
                SizedBox(height: AppSpacing.md),
              ],
              if (actions != null && actions!.isNotEmpty) ...[
                _buildActionsRow(),
                SizedBox(height: AppSpacing.lg),
              ],
              if (stats != null && stats!.isNotEmpty) ...[
                _buildStatsRow(),
                SizedBox(height: AppSpacing.lg),
              ],
              if (filters != null) ...[
                filters!,
                SizedBox(height: AppSpacing.md),
              ],
              Expanded(child: content),
            ],
          ),
        ),
        if (showProgress)
          ReusableProgressOverlay(
            isVisible: true,
            progress: progress ?? 0.0,
            title: progressTitle ?? WidgetStrings.moduleProcessing,
          ),
      ],
    );

    if (!useShell) return body;

    return HomeShell(title: title, subtitle: subtitle, child: body);
  }

  Widget _buildActionsRow() {
    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.md,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: actions!,
    );
  }

  Widget _buildStatsRow() {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: stats!,
    );
  }
}




