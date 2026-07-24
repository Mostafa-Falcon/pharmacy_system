import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_system/app/shared/ui_core.dart';

typedef ReusableAppCard = AppCard;

/// كارت النظام الموحد [AppCard].
/// يدعم الاستخدام العادي، كارت الاستمارات [AppCard.form]، وكارت الأقسام [AppCard.section].
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.onTap,
    this.borderRadius,
    this.showBorder = true,
    this.maxWidth,
    this.centerInParent = false,
  });

  factory AppCard.form({
    Key? key,
    required Widget child,
    EdgeInsetsGeometry? padding,
    double? maxWidth,
  }) {
    return AppCard(
      key: key,
      padding: padding,
      maxWidth: maxWidth,
      centerInParent: true,
      child: child,
    );
  }

  factory AppCard.section({
    Key? key,
    required List<Widget> children,
    EdgeInsetsGeometry? padding,
    Color? backgroundColor,
    bool dividers = true,
    BuildContext? context,
  }) {
    final List<Widget> content = [];
    for (var i = 0; i < children.length; i++) {
      content.add(children[i]);
      if (dividers && i < children.length - 1) {
        content.add(
          Builder(
            builder: (ctx) => Divider(
              height: 1.h,
              thickness: 1,
              color: AppColors.dividerOf(ctx).withValues(alpha: 0.5),
            ),
          ),
        );
      }
    }

    return AppCard(
      key: key,
      padding: padding ?? EdgeInsets.all(AppSpacing.md.w),
      backgroundColor: backgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: content,
      ),
    );
  }

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final double? borderRadius;
  final bool showBorder;
  final double? maxWidth;
  final bool centerInParent;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = AppColors.isDark(context);

    final radiusValue = borderRadius ?? AppRadius.lg;
    final radius = BorderRadius.circular(radiusValue.r);

    final cardDecoration = BoxDecoration(
      color: backgroundColor ?? AppColors.surfaceOf(context),
      borderRadius: radius,
      border: showBorder
          ? Border.all(
              color: AppColors.borderOf(
                context,
              ).withValues(alpha: isDark ? 0.25 : 0.35),
              width: 1.w,
            )
          : null,
      boxShadow: [
        BoxShadow(
          color: scheme.shadow.withValues(alpha: isDark ? 0.15 : 0.03),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );

    Widget cardContent = Padding(
      padding: padding ?? EdgeInsets.all(AppSpacing.lg.w),
      child: child,
    );

    if (onTap != null) {
      cardContent = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          hoverColor: scheme.primary.withValues(alpha: 0.02),
          splashColor: scheme.primary.withValues(alpha: 0.05),
          highlightColor: Colors.transparent,
          child: cardContent,
        ),
      );
    }

    Widget result = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: margin,
      constraints: BoxConstraints(
        maxWidth: maxWidth?.w ?? double.infinity,
        minWidth: 140.w,
      ),
      decoration: cardDecoration,
      child: ClipRRect(borderRadius: radius, child: cardContent),
    );

    if (onTap != null) {
      result = _CardInteractiveWrapper(child: result);
    }

    if (centerInParent) {
      result = Center(child: result);
    }

    return result;
  }
}

class _CardInteractiveWrapper extends StatefulWidget {
  final Widget child;
  const _CardInteractiveWrapper({required this.child});

  @override
  State<_CardInteractiveWrapper> createState() =>
      _CardInteractiveWrapperState();
}

class _CardInteractiveWrapperState extends State<_CardInteractiveWrapper> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    double scale = 1.0;
    if (_isPressed) {
      scale = 0.98;
    } else if (_isHovered) {
      scale = 1.01;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOutCubic,
          child: widget.child,
        ),
      ),
    );
  }
}

// ── Legacy Compatibility Cards Wrappers ──

class FormCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? maxWidth;

  const FormCard({super.key, required this.child, this.padding, this.maxWidth});

  @override
  Widget build(BuildContext context) {
    return AppCard.form(padding: padding, maxWidth: maxWidth, child: child);
  }
}

class SectionCard extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final bool dividers;

  const SectionCard({
    super.key,
    required this.children,
    this.padding,
    this.backgroundColor,
    this.dividers = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard.section(
      padding: padding,
      backgroundColor: backgroundColor,
      dividers: dividers,
      children: children,
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  final IconData? icon;
  final bool vertical;
  final double? minWidth;
  final String? subtitle;
  final VoidCallback? onTap;

  const SummaryCard({
    super.key,
    required this.label,
    required this.value,
    this.color,
    this.icon,
    this.vertical = false,
    this.minWidth,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);
    final cardColor = color ?? Theme.of(context).colorScheme.primary;

    return Container(
      constraints: minWidth != null
          ? BoxConstraints(minWidth: minWidth!)
          : null,
      child: AppCard(
        onTap: onTap,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
        child: vertical
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ReusableText(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption(context).copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondaryOf(context),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  ReusableText(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body(
                      context,
                    ).copyWith(fontWeight: FontWeight.w800, color: cardColor),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 2.h),
                    ReusableText(
                      subtitle!,
                      style: AppTextStyles.caption(
                        context,
                      ).copyWith(color: AppColors.textSecondaryOf(context)),
                    ),
                  ],
                ],
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: cardColor.withValues(
                          alpha: isDark ? 0.15 : 0.08,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icon,
                        color: cardColor,
                        size: AppIconSize.md.value,
                      ),
                    ),
                    SizedBox(width: 8.w),
                  ],
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ReusableText(
                          label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondaryOf(context),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        ReusableText(
                          value,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13.5.sp,
                            fontWeight: FontWeight.w800,
                            color: cardColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class ReportCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String? subtitle;
  final VoidCallback? onTap;

  const ReportCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);

    return AppCard(
      onTap: onTap,
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: color.withValues(alpha: isDark ? 0.15 : 0.08),
              borderRadius: BorderRadius.circular(AppRadius.card.r),
            ),
            child: Icon(icon, color: color, size: AppIconSize.xl.value),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ReusableText(
                  title,
                  style: AppTextStyles.caption(context).copyWith(
                    color: AppColors.textSecondaryOf(context),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                ReusableText(
                  value,
                  style: AppTextStyles.body(
                    context,
                  ).copyWith(fontWeight: FontWeight.w900, color: color),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: 2.h),
                  ReusableText(
                    subtitle!,
                    style: AppTextStyles.caption(
                      context,
                    ).copyWith(color: AppColors.textSecondaryOf(context)),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TransactionCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String amount;
  final String date;
  final IconData icon;
  final Color iconColor;
  final List<Widget>? tags;
  final String? amountSubtext;
  final VoidCallback? onTap;
  final List<PopupMenuEntry<String>>? menuItems;
  final ValueChanged<String>? onMenuSelected;

  const TransactionCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.amount,
    required this.date,
    required this.icon,
    required this.iconColor,
    this.tags,
    this.amountSubtext,
    this.onTap,
    this.menuItems,
    this.onMenuSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);

    return AppCard(
      onTap: onTap,
      padding: EdgeInsets.all(12.w),
      margin: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: isDark ? 0.15 : 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReusableText(
                  title,
                  style: AppTextStyles.body(
                    context,
                  ).copyWith(fontWeight: FontWeight.bold),
                ),
                if (subtitle != null && subtitle!.isNotEmpty) ...[
                  SizedBox(height: 2.h),
                  ReusableText(
                    subtitle!,
                    style: AppTextStyles.caption(
                      context,
                    ).copyWith(color: AppColors.textSecondaryOf(context)),
                  ),
                ],
                if (tags != null && tags!.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  Wrap(spacing: 4.w, runSpacing: 4.h, children: tags!),
                ],
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ReusableText(
                amount,
                style: AppTextStyles.body(
                  context,
                ).copyWith(fontWeight: FontWeight.w900, color: iconColor),
              ),
              SizedBox(height: 2.h),
              ReusableText(
                date,
                style: AppTextStyles.caption(
                  context,
                ).copyWith(color: AppColors.textSecondaryOf(context)),
              ),
              if (amountSubtext != null && amountSubtext!.isNotEmpty) ...[
                SizedBox(height: 2.h),
                ReusableText(
                  amountSubtext!,
                  style: AppTextStyles.caption(
                    context,
                  ).copyWith(color: AppColors.textSecondaryOf(context)),
                ),
              ],
            ],
          ),
          if (menuItems != null && menuItems!.isNotEmpty) ...[
            SizedBox(width: 4.w),
            PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert_rounded,
                size: 20.sp,
                color: AppColors.textSecondaryOf(context),
              ),
              onSelected: onMenuSelected,
              itemBuilder: (_) => menuItems!,
            ),
          ],
        ],
      ),
    );
  }
}
