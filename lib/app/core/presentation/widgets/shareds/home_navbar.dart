import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_system/app/core/constants/app_strings.dart';

import 'package:pharmacy_system/app/modules/notifications/models/app_notification_model.dart';
import 'package:pharmacy_system/app/core/data/services/theme_service.dart';
import 'package:pharmacy_system/app/core/data/services/sync/sync_service.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_sizes.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/index.dart';
import 'package:pharmacy_system/app/modules/notifications/bloc/notifications_bloc.dart';
import 'package:pharmacy_system/app/modules/notifications/bloc/notifications_event.dart';
import 'package:pharmacy_system/app/modules/notifications/bloc/notifications_state.dart';
import 'package:pharmacy_system/app/routes/app_routes.dart';

class HomeNavbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String subtitle;
  final bool isSidebarVisible;
  final VoidCallback? onToggleSidebar;
  final VoidCallback? onMenuPressed;
  final String userName;
  final String userRole;
  final VoidCallback? onProfileTap;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onLogout;
  final int notificationCount;
  final bool isOnline;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onCalculatorTap;
  final VoidCallback? onCashierTap;
  final VoidCallback? onSupportTap;

  const HomeNavbar({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isSidebarVisible,
    this.onToggleSidebar,
    this.onMenuPressed,
    required this.userName,
    required this.userRole,
    this.onProfileTap,
    this.onSettingsTap,
    this.onLogout,
    this.notificationCount = 0,
    this.isOnline = true,
    this.onNotificationTap,
    this.onCalculatorTap,
    this.onCashierTap,
    this.onSupportTap,
  });

  @override
  Size get preferredSize => Size.fromHeight(AppDimensions.navbarHeight);

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);
    final themeService = ThemeService.instance;

    return Container(
      height: AppDimensions.navbarHeight,
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        border: Border(
          bottom: BorderSide(
            color: AppColors.borderOf(
              context,
            ).withValues(alpha: isDark ? 0.25 : 0.45),
            width: AppDimensions.dividerThickness,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.06 : 0.015),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
      child: Row(
        children: [
          _buildMenuButton(context),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReusableText(
                  title,
                  style: AppTextStyles.body(context).copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimaryOf(context),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle.trim().isNotEmpty) ...[
                  SizedBox(height: 2.h),
                  ReusableText(
                    subtitle,
                    style: AppTextStyles.caption(context).copyWith(
                      color: AppColors.textSecondaryOf(context),
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: AppSpacing.md.w),

          _NavbarAction(
            icon: Icons.calculate_outlined,
            tooltip: AppStrings.calculator,
            onTap: onCalculatorTap,
          ),
          SizedBox(width: 6.w),
          _NavbarAction(
            icon: Icons.point_of_sale_outlined,
            tooltip: AppStrings.cashier,
            onTap: onCashierTap,
          ),
          SizedBox(width: 6.w),
          _NavbarAction(
            icon: Icons.headphones_outlined,
            tooltip: AppStrings.techSupport,
            onTap: onSupportTap,
          ),
          SizedBox(width: 6.w),
          _NotificationBadge(
            count: notificationCount,
            onSeeMore: () => context.go('/notifications'),
          ),
          SizedBox(width: 4.w),
          const _SyncIndicator(),
          SizedBox(width: 6.w),
          _ThemeToggle(themeService: themeService),
          SizedBox(width: 8.w),

          Container(
            height: 18.0,
            width: 1.w,
            color: AppColors.borderOf(context).withValues(alpha: 0.25),
          ),
          SizedBox(width: 12.w),

          _ProfileBadge(
            userName: userName,
            userRole: userRole,
            isOnline: isOnline,
            onProfileTap: onProfileTap,
            onSettingsTap: onSettingsTap,
            onLogout: onLogout,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context) {
    if (onToggleSidebar != null) {
      return IconButton(
        key: const ValueKey('toggle'),
        icon: Icon(
          isSidebarVisible ? Icons.menu_open_rounded : Icons.menu_rounded,
          size: AppDimensions.iconSize,
        ),
        onPressed: onToggleSidebar,
        tooltip: isSidebarVisible ? AppStrings.closeMenu : AppStrings.openMenu,
        style: IconButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
          hoverColor: Theme.of(
            context,
          ).colorScheme.primary.withValues(alpha: 0.04),
        ),
      );
    }
    if (onMenuPressed != null) {
      return IconButton(
        key: const ValueKey('menu'),
        icon: Icon(Icons.menu_rounded, size: AppDimensions.iconSize),
        onPressed: onMenuPressed,
        tooltip: AppStrings.menu,
        style: IconButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
          hoverColor: Theme.of(
            context,
          ).colorScheme.primary.withValues(alpha: 0.04),
        ),
      );
    }
    return const SizedBox.shrink(key: ValueKey('empty'));
  }
}

class _NavbarAction extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;
  final int badgeCount;

  const _NavbarAction({
    required this.icon,
    required this.tooltip,
    this.onTap,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Tooltip(
      message: tooltip,
      child: IconButton(
        icon: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(icon, size: AppDimensions.iconSize),
            if (badgeCount > 0)
              Positioned(
                right: -4.w,
                top: -4.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    borderRadius: BorderRadius.circular(AppRadius.pill.r),
                    border: Border.all(
                      color: AppColors.surfaceOf(context),
                      width: 1.5.w,
                    ),
                  ),
                  constraints: BoxConstraints(minWidth: 14.w, minHeight: 14.w),
                  child: Center(
                    child: Text(
                      badgeCount > 99 ? '99+' : badgeCount.toString(),
                      style: AppTextStyles.caption(context).copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        height: 1,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        onPressed: onTap,
        style: IconButton.styleFrom(
          foregroundColor: scheme.onSurfaceVariant,
          hoverColor: scheme.primary.withValues(alpha: 0.04),
        ),
      ),
    );
  }
}

class _ThemeToggle extends StatelessWidget {
  final ThemeService themeService;
  const _ThemeToggle({required this.themeService});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ListenableBuilder(
      listenable: themeService,
      builder: (context, child) {
        final isDark = themeService.isDark;
        return Tooltip(
          message: isDark ? AppStrings.lightMode : AppStrings.darkMode,
          child: IconButton(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, animation) =>
                  RotationTransition(turns: animation, child: child),
              child: Icon(
                isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                key: ValueKey(isDark),
                size: AppDimensions.iconSize,
                color: isDark ? AppColors.warning : scheme.onSurfaceVariant,
              ),
            ),
            onPressed: () {
              HapticFeedback.lightImpact();
              themeService.toggleTheme();
            },
            style: IconButton.styleFrom(
              foregroundColor: scheme.onSurfaceVariant,
              hoverColor: scheme.primary.withValues(alpha: 0.04),
            ),
          ),
        );
      },
    );
  }
}

class _SyncIndicator extends StatefulWidget {
  const _SyncIndicator();

  @override
  State<_SyncIndicator> createState() => _SyncIndicatorState();
}

class _SyncIndicatorState extends State<_SyncIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _spinController;

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
  }

  @override
  void dispose() {
    _spinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Ã™â€¦Ã˜ÂªÃ˜Â§Ã˜Â¨Ã˜Â¹Ã˜Â© Ã˜Â­Ã™Å Ã˜Â© Ã˜Â¹Ã˜Â¨Ã˜Â± statusStream Ã˜Â¹Ã˜Â´Ã˜Â§Ã™â€  Ã˜Â§Ã™â€žÃ™â€¦Ã˜Â¤Ã˜Â´Ã˜Â± Ã™Å Ã˜ÂªÃ˜ÂºÃ™Å Ã˜Â± Ã™ÂÃ™Å  "Ã™â€ Ã™ÂÃ˜Â³ Ã˜Â§Ã™â€žÃ™â€žÃ˜Â­Ã˜Â¸Ã˜Â©"
    // (Ã™â€¦Ã˜Â´ Ã˜Â¨Ã˜Â³ Ã™â€žÃ™Ë† Ã˜Â§Ã™â€žÃ™Ë†Ã™Å Ã˜Â¯Ã˜Â¬Ã˜Âª Ã˜Â§Ã˜ÂªÃ˜Â¨Ã™â€ Ã™â€° Ã™â€¦Ã™â€  Ã˜ÂªÃ˜Â§Ã™â€ Ã™Å ).
    return StreamBuilder<SyncStatus>(
      stream: SyncService.statusStream,
      initialData: SyncStatus(
        isOnline: SyncService.isOnline,
        isSyncing: SyncService.isSyncing,
        lastSyncTime: SyncService.lastSyncTime,
        lastSyncError: SyncService.lastSyncError,
      ),
      builder: (context, snapshot) {
        final s = snapshot.data!;
        final isOnline = s.isOnline;
        final isSyncing = s.isSyncing;
        final hasError = s.lastSyncError != null;

        IconData icon;
        Color color;
        if (hasError) {
          icon = Icons.cloud_off_rounded;
          color = AppColors.error;
        } else if (isSyncing) {
          icon = Icons.sync_rounded;
          color = AppColors.warning;
        } else if (isOnline) {
          icon = Icons.cloud_done_rounded;
          color = AppColors.success;
        } else {
          icon = Icons.wifi_off_rounded;
          color = AppColors.error;
        }

        final label = _getLabel(isOnline, isSyncing, hasError);

        return Tooltip(
          message: _getTooltipMessage(isOnline, isSyncing, hasError),
          child: InkWell(
            onTap: () => context.go(Routes.SYNC_STATUS),
            borderRadius: BorderRadius.circular(6.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  isSyncing
                      ? RotationTransition(
                          turns: _spinController,
                          child: Icon(icon, size: 16.w),
                        )
                      : Icon(icon, size: 16.w),
                  SizedBox(width: 4.w),
                  ReusableText(
                    label,
                    style: AppTextStyles.caption(
                      context,
                    ).copyWith(color: color, fontWeight: FontWeight.w600),
                  ),
                  if (SyncService.pendingOperationsCount > 0) ...[
                    SizedBox(width: 4.w),
                    Container(
                      width: 6.w,
                      height: 6.w,
                      decoration: BoxDecoration(
                        color: AppColors.warning,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _getTooltipMessage(bool isOnline, bool isSyncing, bool hasError) {
    if (hasError) return SyncService.lastSyncError ?? AppStrings.syncErrorLabel;
    if (isSyncing) return AppStrings.syncInProgress;
    if (isOnline) return AppStrings.synced;
    return AppStrings.offlineDetailed;
  }

  String _getLabel(bool isOnline, bool isSyncing, bool hasError) {
    if (hasError) return AppStrings.error;
    if (isSyncing) return AppStrings.syncingShort;
    if (isOnline) return AppStrings.online;
    return AppStrings.offline;
  }
}

class _NotificationBadge extends StatelessWidget {
  final int count;
  final VoidCallback onSeeMore;

  const _NotificationBadge({required this.count, required this.onSeeMore});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return BlocBuilder<NotificationsBloc, NotificationsState>(
      builder: (context, state) {
        final notifications = state.notifications.take(5).toList();
        final unreadCount = state.unreadCount;

        return MenuAnchor(
          style: MenuStyle(
            padding: WidgetStateProperty.all(EdgeInsets.zero),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md.r),
              ),
            ),
            elevation: WidgetStateProperty.all(12),
          ),
          menuChildren: [
            Container(
              width: 360.w,
              constraints: BoxConstraints(maxHeight: 500.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Row(
                      children: [
                        Icon(
                          Icons.notifications_active_outlined,
                          size: 20.sp,
                          color: scheme.primary,
                        ),
                        SizedBox(width: 10.w),
                        ReusableText(
                          AppStrings.notificationsCenterTitle,
                          style: AppTextStyles.body(
                            context,
                          ).copyWith(fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        if (unreadCount > 0)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 3.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.error.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(
                                AppRadius.pill.r,
                              ),
                            ),
                            child: ReusableText(
                              '$unreadCount ${AppStrings.newNotifications}',
                              style: AppTextStyles.caption(context).copyWith(
                                color: AppColors.error,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  if (state.notifications.isEmpty)
                    Padding(
                      padding: EdgeInsets.all(40.w),
                      child: Column(
                        children: [
                          Icon(
                            Icons.notifications_none_rounded,
                            size: AppIconSize.xl.value,
                            color: Colors.grey.shade300,
                          ),
                          SizedBox(height: 16.h),
                          ReusableText(
                            AppStrings.noNotificationsCurrent,
                            style: AppTextStyles.body(
                              context,
                            ).copyWith(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  else
                    Flexible(
                      child: ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: notifications.length,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final n = notifications[index];
                          return _NotificationItem(
                            notification: n,
                            onTap: () {
                              context.read<NotificationsBloc>().add(
                                MarkAsRead(n.id),
                              );
                              if (n.actionRoute != null) {
                                context.push(n.actionRoute!);
                              }
                            },
                          );
                        },
                      ),
                    ),
                  const Divider(height: 1),
                  Padding(
                    padding: EdgeInsets.all(12.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: onSeeMore,
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppRadius.sm.r,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ReusableText(
                                  AppStrings.viewAll,
                                  style: AppTextStyles.body(context).copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: scheme.primary,
                                  ),
                                ),
                                SizedBox(width: 6.w),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  size: AppIconSize.md.value,
                                  color: scheme.primary,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
          builder: (context, controller, child) {
            return _NavbarAction(
              icon: Icons.notifications_outlined,
              tooltip: AppStrings.notificationsTooltip,
              badgeCount: unreadCount,
              onTap: () {
                if (controller.isOpen) {
                  controller.close();
                } else {
                  controller.open();
                }
              },
            );
          },
        );
      },
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onTap;

  const _NotificationItem({required this.notification, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = _getCategoryColor(notification.category);
    final icon = _getCategoryIcon(notification.category);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(14.w),
        color: notification.isRead
            ? Colors.transparent
            : color.withValues(alpha: 0.03),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, size: AppIconSize.md.value, color: color),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ReusableText(
                          notification.title,
                          style: AppTextStyles.body(context).copyWith(
                            fontWeight: notification.isRead
                                ? FontWeight.w600
                                : FontWeight.w900,
                            color: notification.isRead
                                ? AppColors.textSecondaryOf(context)
                                : AppColors.textPrimaryOf(context),
                          ),
                        ),
                      ),
                      if (!notification.isRead)
                        Container(
                          width: 6.w,
                          height: 6.w,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  ReusableText(
                    notification.message,
                    style: AppTextStyles.caption(
                      context,
                    ).copyWith(color: AppColors.textSecondaryOf(context)),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6.h),
                  ReusableText(
                    _formatTimestamp(notification.timestamp),
                    style: AppTextStyles.caption(context).copyWith(
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w500,
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

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);
    if (diff.inMinutes < 60) {
      return AppStrings.agoMinutes.replaceFirst('%s', '${diff.inMinutes}');
    }
    if (diff.inHours < 24) {
      return AppStrings.agoHours.replaceFirst('%s', '${diff.inHours}');
    }
    return DateFormat('yyyy/MM/dd').format(timestamp);
  }

  Color _getCategoryColor(NotificationCategory category) {
    switch (category) {
      case NotificationCategory.expiry:
        return AppColors.error;
      case NotificationCategory.stock:
        return Colors.orange;
      case NotificationCategory.system:
        return Colors.blueGrey;
      default:
        return AppColors.primary;
    }
  }

  IconData _getCategoryIcon(NotificationCategory category) {
    switch (category) {
      case NotificationCategory.expiry:
        return Icons.event_busy_rounded;
      case NotificationCategory.stock:
        return Icons.inventory_2_rounded;
      case NotificationCategory.system:
        return Icons.info_outline_rounded;
      default:
        return Icons.notifications_none_rounded;
    }
  }
}

class _ProfileBadge extends StatelessWidget {
  final String userName;
  final String userRole;
  final bool isOnline;
  final VoidCallback? onProfileTap;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onLogout;

  const _ProfileBadge({
    required this.userName,
    required this.userRole,
    required this.isOnline,
    this.onProfileTap,
    this.onSettingsTap,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final initials = userName.isNotEmpty
        ? userName.trim().characters.first
        : '?';

    return PopupMenuButton<String>(
      icon: CircleAvatar(
        radius: 16.r,
        backgroundColor: scheme.primary.withValues(alpha: 0.12),
        child: Text(
          initials.toUpperCase(),
          style: AppTextStyles.caption(
            context,
          ).copyWith(fontWeight: FontWeight.bold, color: scheme.primary),
        ),
      ),
      tooltip: AppStrings.profile,
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg.r),
      ),
      onSelected: (value) {
        switch (value) {
          case 'profile':
            onProfileTap?.call();
          case 'settings':
            onSettingsTap?.call();
          case 'logout':
            onLogout?.call();
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'profile',
          child: Row(
            children: [
              Icon(
                Icons.person_outline_rounded,
                size: AppIconSize.md.value,
                color: scheme.onSurface,
              ),
              SizedBox(width: 10.w),
              Text(userName, style: AppTextStyles.body(context)),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'settings',
          child: Row(
            children: [
              Icon(
                Icons.settings_outlined,
                size: AppIconSize.md.value,
                color: scheme.onSurface,
              ),
              SizedBox(width: 10.w),
              Text(userRole, style: AppTextStyles.body(context)),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: 'logout',
          child: Row(
            children: [
              Icon(
                Icons.logout_rounded,
                size: AppIconSize.md.value,
                color: AppColors.error,
              ),
              SizedBox(width: 10.w),
              Text(
                AppStrings.logout,
                style: AppTextStyles.body(
                  context,
                ).copyWith(color: AppColors.error),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

