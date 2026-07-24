import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_system/app/shared/ui_core.dart';

/// صف قائمة موحّد لكيان (عميل/مورد/مجموعة/ليد): أفاتار + عنوان + وصف + trailing + قائمة إجراءات.
/// بيلغي تكرار `Card + ListTile + CircleAvatar` في كل القوائم.
class PartyListTile extends StatelessWidget {
  final String? avatarText;
  final IconData? avatarIcon;
  final Color? avatarColor;
  final String title;
  final String? subtitle;
  final List<Widget> tags;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool selected;
  final List<PopupMenuEntry<String>>? menuItems;
  final ValueChanged<String>? onMenuSelected;

  const PartyListTile({
    super.key,
    this.avatarText,
    this.avatarIcon,
    this.avatarColor,
    required this.title,
    this.subtitle,
    this.tags = const [],
    this.trailing,
    this.onTap,
    this.selected = false,
    this.menuItems,
    this.onMenuSelected,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = AppColors.isDark(context);
    final aColor = avatarColor ?? scheme.primary;
    final radius = BorderRadius.circular(AppRadius.lg.w);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.only(bottom: AppSpacing.sm.h),
      decoration: BoxDecoration(
        color: selected
            ? aColor.withValues(alpha: isDark ? 0.12 : 0.06)
            : AppColors.surfaceOf(context),
        borderRadius: radius,
        border: Border.all(
          color: selected
              ? aColor.withValues(alpha: 0.5)
              : AppColors.borderOf(
                  context,
                ).withValues(alpha: isDark ? 0.3 : 0.5),
          width: 1.w,
        ),
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            hoverColor: aColor.withValues(alpha: 0.02),
            splashColor: aColor.withValues(alpha: 0.06),
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.md.w),
              child: Row(
                children: [
                  Container(
                    width: 42.w,
                    height: 42.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: aColor.withValues(alpha: isDark ? 0.18 : 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: avatarIcon != null
                        ? Icon(
                            avatarIcon,
                            size: AppIconSize.md.value,
                            color: aColor,
                          )
                        : ReusableText(
                            (avatarText != null && avatarText!.isNotEmpty)
                                ? avatarText!.characters.first
                                : '?',
                            style: AppTextStyles.body(context).copyWith(
                              fontWeight: FontWeight.w800,
                              color: aColor,
                            ),
                          ),
                  ),
                  SizedBox(width: AppSpacing.md.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ReusableText(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.body(context).copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimaryOf(context),
                          ),
                        ),
                        if (subtitle != null) ...[
                          SizedBox(height: 3.h),
                          ReusableText(
                            subtitle!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption(context).copyWith(
                              color: AppColors.textSecondaryOf(context),
                            ),
                          ),
                        ],
                        if (tags.isNotEmpty) ...[
                          SizedBox(height: 6.h),
                          Wrap(spacing: 6.w, runSpacing: 4.h, children: tags),
                        ],
                      ],
                    ),
                  ),
                  if (trailing != null) ...[
                    SizedBox(width: AppSpacing.sm.w),
                    trailing!,
                  ],
                  if (menuItems != null) ...[
                    SizedBox(width: 4.w),
                    PopupMenuButton<String>(
                      onSelected: onMenuSelected ?? (_) {},
                      icon: Icon(
                        Icons.more_vert_rounded,
                        color: AppColors.textSecondaryOf(
                          context,
                        ).withValues(alpha: 0.8),
                        size: AppIconSize.md.value,
                      ),
                      padding: EdgeInsets.zero,
                      itemBuilder: (_) => menuItems!,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
