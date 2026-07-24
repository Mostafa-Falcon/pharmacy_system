import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_system/app/shared/ui_core.dart';
import 'package:pharmacy_system/app/core/models/system/app_notification_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_system/app/modules/notifications/bloc/notifications_bloc.dart';
import 'package:pharmacy_system/app/modules/notifications/bloc/notifications_event.dart';
import 'package:pharmacy_system/app/modules/notifications/bloc/notifications_state.dart';
import 'package:pharmacy_system/app/modules/auth/bloc/auth_bloc.dart';
import 'package:pharmacy_system/app/routes/app_routes.dart';

class HomeNavbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String subtitle;
  final bool isSidebarVisible;
  final VoidCallback? onToggleSidebar;
  final VoidCallback? onMenuPressed;
  final String userName;
  final String userRole;
  final int notificationCount;
  final bool isOnline;
  final VoidCallback? onCalculatorTap;
  final VoidCallback? onCashierTap;

  const HomeNavbar({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isSidebarVisible,
    this.onToggleSidebar,
    this.onMenuPressed,
    required this.userName,
    required this.userRole,
    this.notificationCount = 0,
    this.isOnline = true,
    this.onCalculatorTap,
    this.onCashierTap,
  });

  @override
  Size get preferredSize => Size.fromHeight(AppDimensions.navbarHeight);

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);
    // 🎨 استخدام لون داكن موحد للبار العلوي كما في الصور (Olive Dark/Deep Gray)
    final navbarBg = isDark ? const Color(0xFF1A1D18) : const Color(0xFF2E332A);
    final foregroundColor = Colors.white;

    return Container(
      height: AppDimensions.navbarHeight,
      decoration: BoxDecoration(
        color: navbarBg,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w),
      child: Row(
        children: [
          _buildMenuButton(context, foregroundColor),
          const Spacer(),
          // 🗓️ ويدجت التاريخ في المنتصف
          const _NavbarDate(),
          const Spacer(),
          
          // 🧮 الآلة الحاسبة
          _NavbarIconButton(
            icon: Icons.calculate_outlined,
            tooltip: GeneralStrings.calculator,
            onTap: onCalculatorTap,
          ),
          SizedBox(width: 8.w),

          // 🔔 مركز التنبيهات
          _NotificationBadge(
            count: notificationCount,
            onSeeMore: () => context.go('/notifications'),
          ),
          SizedBox(width: 8.w),

          // 🛒 الكاشير (رابط سريع)
          _NavbarQuickAction(
            icon: Icons.grid_view_rounded,
            label: GeneralStrings.cashier,
            onTap: onCashierTap,
          ),
          SizedBox(width: 8.w),

          // 👤 الملف الشخصي
          _ProfileBadge(
            userName: userName,
            userRole: userRole,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, Color color) {
    if (onToggleSidebar != null) {
      return IconButton(
        icon: Icon(
          isSidebarVisible ? Icons.menu_open_rounded : Icons.menu_rounded,
          size: 24.sp,
          color: color,
        ),
        onPressed: onToggleSidebar,
        tooltip: isSidebarVisible ? GeneralStrings.closeMenu : GeneralStrings.openMenu,
      );
    }
    if (onMenuPressed != null) {
      return IconButton(
        icon: Icon(Icons.menu_rounded, size: 24.sp, color: color),
        onPressed: onMenuPressed,
        tooltip: GeneralStrings.menu,
      );
    }
    return const SizedBox.shrink();
  }
}

class _NavbarIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;
  final int badgeCount;

  const _NavbarIconButton({
    required this.icon,
    required this.tooltip,
    this.onTap,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(icon, color: Colors.white, size: 20.sp),
              if (badgeCount > 0)
                Positioned(
                  right: -4.w,
                  top: -4.w,
                  child: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF2E332A), width: 1.w),
                    ),
                    constraints: BoxConstraints(minWidth: 14.w, minHeight: 14.w),
                    child: Center(
                      child: Text(
                        badgeCount > 99 ? '99+' : badgeCount.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavbarQuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _NavbarQuickAction({
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 18.sp),
            SizedBox(width: 8.w),
            ReusableText(
              label,
              style: AppTextStyles.bodyBold(context).copyWith(
                color: Colors.white,
                fontSize: 13.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavbarDate extends StatelessWidget {
  const _NavbarDate();

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dayName = _getDayName(now.weekday);
    final day = now.day;
    final monthName = _getMonthName(now.month);
    final year = now.year;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.calendar_month_outlined, color: Colors.white, size: 18.sp),
          SizedBox(width: 8.w),
          ReusableText(
            '$dayName، $day $monthName $year',
            style: AppTextStyles.body(context).copyWith(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _getDayName(int day) {
    switch (day) {
      case DateTime.sunday: return GeneralStrings.sunday;
      case DateTime.monday: return GeneralStrings.monday;
      case DateTime.tuesday: return GeneralStrings.tuesday;
      case DateTime.wednesday: return GeneralStrings.wednesday;
      case DateTime.thursday: return GeneralStrings.thursday;
      case DateTime.friday: return GeneralStrings.friday;
      case DateTime.saturday: return GeneralStrings.saturday;
      default: return '';
    }
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1: return GeneralStrings.january;
      case 2: return GeneralStrings.february;
      case 3: return GeneralStrings.march;
      case 4: return GeneralStrings.april;
      case 5: return GeneralStrings.may;
      case 6: return GeneralStrings.june;
      case 7: return GeneralStrings.july;
      case 8: return GeneralStrings.august;
      case 9: return GeneralStrings.september;
      case 10: return GeneralStrings.october;
      case 11: return GeneralStrings.november;
      case 12: return GeneralStrings.december;
      default: return '';
    }
  }
}

class _NotificationBadge extends StatefulWidget {
  final int count;
  final VoidCallback onSeeMore;

  const _NotificationBadge({required this.count, required this.onSeeMore});

  @override
  State<_NotificationBadge> createState() => _NotificationBadgeState();
}

class _NotificationBadgeState extends State<_NotificationBadge> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsBloc, NotificationsState>(
      builder: (context, state) {
        final unreadCount = state.unreadCount;

        return MenuAnchor(
          style: MenuStyle(
            padding: WidgetStateProperty.all(EdgeInsets.zero),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
            ),
            elevation: WidgetStateProperty.all(12),
          ),
          menuChildren: [
            Container(
              width: 380.w,
              constraints: BoxConstraints(maxHeight: 520.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 🏁 Header
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ReusableText(
                          NotificationsStrings.notificationsLabel,
                          style: AppTextStyles.title(context).copyWith(fontSize: 16.sp),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            context.read<NotificationsBloc>().add(const MarkAllAsRead());
                          },
                          icon: Icon(Icons.done_all_rounded, size: 16.sp),
                          label: ReusableText(
                            NotificationsStrings.markAllAsRead,
                            style: AppTextStyles.caption(context).copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 📑 Tabs
                  TabBar(
                    controller: _tabController,
                    isScrollable: false,
                    labelColor: AppColors.primary,
                    unselectedLabelColor: AppColors.textSecondaryOf(context),
                    indicatorColor: AppColors.primary,
                    indicatorSize: TabBarIndicatorSize.label,
                    labelStyle: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.bold),
                    tabs: [
                      Tab(text: NotificationsStrings.all.replaceFirst('%s', '${state.notifications.length}')),
                      Tab(text: NotificationsStrings.unread.replaceFirst('%s', '$unreadCount')),
                      Tab(text: NotificationsStrings.messages.replaceFirst('%s', '0')),
                    ],
                  ),
                  const Divider(height: 1),

                  // 📦 List
                  Flexible(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildNotificationList(state.notifications),
                        _buildNotificationList(state.notifications.where((n) => !n.isRead).toList()),
                        _buildNotificationList([]), // Empty for messages now
                      ],
                    ),
                  ),

                  const Divider(height: 1),
                  // 🔗 Footer
                  Padding(
                    padding: EdgeInsets.all(8.w),
                    child: AppButton(
                      text: NotificationsStrings.viewAll,
                      type: ButtonType.text,
                      width: double.infinity,
                      onPressed: widget.onSeeMore,
                    ),
                  ),
                ],
              ),
            ),
          ],
          builder: (context, controller, child) {
            return _NavbarIconButton(
              icon: Icons.notifications_none_rounded,
              tooltip: NotificationsStrings.notificationsTooltip,
              badgeCount: unreadCount,
              onTap: () => controller.isOpen ? controller.close() : controller.open(),
            );
          },
        );
      },
    );
  }

  Widget _buildNotificationList(List<AppNotification> items) {
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(32.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.notifications_off_outlined, size: 48.sp, color: Colors.grey.shade300),
              SizedBox(height: 12.h),
              ReusableText(
                NotificationsStrings.noNotificationsCurrent,
                style: AppTextStyles.caption(context).copyWith(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: items.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) => _NotificationItem(
        notification: items[index],
        onTap: () {
          context.read<NotificationsBloc>().add(MarkAsRead(items[index].id));
          if (items[index].targetRoute != null) {
            context.push(items[index].targetRoute!);
          }
        },
      ),
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
      return NotificationsStrings.agoMinutes.replaceFirst(
        '%s',
        '${diff.inMinutes}',
      );
    }
    if (diff.inHours < 24) {
      return NotificationsStrings.agoHours.replaceFirst(
        '%s',
        '${diff.inHours}',
      );
    }
    return DateFormat('yyyy/MM/dd').format(timestamp);
  }

  Color _getCategoryColor(NotificationCategory category) {
    switch (category) {
      case NotificationCategory.expiryWarning:
        return AppColors.error;
      case NotificationCategory.lowStock:
        return Colors.orange;
      case NotificationCategory.newOrder:
        return Colors.teal;
      case NotificationCategory.systemAlert:
        return Colors.blueGrey;
    }
  }

  IconData _getCategoryIcon(NotificationCategory category) {
    switch (category) {
      case NotificationCategory.expiryWarning:
        return Icons.event_busy_rounded;
      case NotificationCategory.lowStock:
        return Icons.inventory_2_rounded;
      case NotificationCategory.newOrder:
        return Icons.local_shipping_rounded;
      case NotificationCategory.systemAlert:
        return Icons.info_outline_rounded;
    }
  }
}

class _ProfileBadge extends StatelessWidget {
  final String userName;
  final String userRole;

  const _ProfileBadge({
    required this.userName,
    required this.userRole,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final email = state.status == AuthStatus.authenticated 
            ? state.user?.email ?? '' 
            : 'pxl-ph@gmail.com';
        
        return MenuAnchor(
          style: MenuStyle(
            padding: WidgetStateProperty.all(EdgeInsets.zero),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
            ),
            elevation: WidgetStateProperty.all(12),
          ),
          menuChildren: [
            Container(
              width: 240.w,
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 📧 User Info
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    child: ReusableText(
                      email,
                      style: AppTextStyles.caption(context).copyWith(
                        color: AppColors.textSecondaryOf(context),
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  
                  // 👥 Employees
                  _ProfileMenuItem(
                    icon: Icons.people_outline_rounded,
                    label: 'الموظفين',
                    onTap: () => context.go(Routes.EMPLOYEES),
                  ),
                  
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  
                  // 🚪 Logout
                  _ProfileMenuItem(
                    icon: Icons.logout_rounded,
                    label: AuthStrings.logout,
                    labelColor: AppColors.error,
                    onTap: () => _showLogoutDialog(context),
                  ),
                ],
              ),
            ),
          ],
          builder: (context, controller, child) {
            return InkWell(
              onTap: () => controller.isOpen ? controller.close() : controller.open(),
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.account_circle_outlined, color: Colors.white, size: 22.sp),
                    SizedBox(width: 8.w),
                    ReusableText(
                      userName,
                      style: AppTextStyles.bodyBold(context).copyWith(
                        color: Colors.white,
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    AppDialog.show(
      context,
      title: AuthStrings.logoutTitle,
      headerIcon: const Icon(Icons.logout_rounded, color: AppColors.error),
      maxWidth: 360,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: ReusableText(
            AuthStrings.logoutConfirm,
            style: AppTextStyles.caption(context).copyWith(height: 1.35),
          ),
        ),
        SizedBox(height: 24.h),
        DialogActions(
          cancelText: AuthStrings.cancelAndBack,
          confirmText: AuthStrings.yesLogout,
          confirmType: ButtonType.error,
          onCancel: () => Navigator.of(context).pop(),
          onConfirm: () {
            Navigator.of(context).pop();
            context.read<AuthBloc>().add(const LogoutRequested());
          },
        ),
      ],
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? labelColor;
  final VoidCallback? onTap;

  const _ProfileMenuItem({
    required this.icon,
    required this.label,
    this.labelColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            Icon(icon, size: 20.sp, color: labelColor ?? AppColors.textPrimaryOf(context)),
            SizedBox(width: 12.w),
            ReusableText(
              label,
              style: AppTextStyles.body(context).copyWith(
                color: labelColor,
                fontWeight: labelColor != null ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
