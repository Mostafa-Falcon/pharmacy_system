import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:pharmacy_system/app/modules/notifications/models/app_notification_model.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_colors.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/index.dart';
import '../bloc/notifications_bloc.dart';
import '../bloc/notifications_event.dart';
import '../bloc/notifications_state.dart';

class NotificationsCenterView extends StatefulWidget {
  const NotificationsCenterView({super.key});

  @override
  State<NotificationsCenterView> createState() => _NotificationsCenterViewState();
}

class _NotificationsCenterViewState extends State<NotificationsCenterView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return HomeShell(
      title: NotificationsStrings.notificationsCenterTitle,
      subtitle: NotificationsStrings.notificationsCenterSubtitle,
      child: BlocBuilder<NotificationsBloc, NotificationsState>(
        builder: (context, state) {
          return Container(
            color: scheme.surfaceContainerLow.withValues(alpha: 0.15),
            padding: EdgeInsets.all(AppSpacing.lg.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(context, state),
                SizedBox(height: AppSpacing.lg.h),
                _buildTabs(scheme),
                SizedBox(height: AppSpacing.md.h),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _NotificationList(notifications: state.notifications),
                      _NotificationList(
                        notifications: state.notifications.where((n) => n.category == NotificationCategory.expiry).toList(),
                      ),
                      _NotificationList(
                        notifications: state.notifications.where((n) => n.category == NotificationCategory.stock).toList(),
                      ),
                      _NotificationList(
                        notifications: state.notifications.where((n) => n.category == NotificationCategory.system).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, NotificationsState state) {
    return Row(
      children: [
        Expanded(
          child: ReusableText(
            NotificationsStrings.unreadNotificationsFormat.replaceFirst('%s', state.unreadCount.toString()),
            style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimaryOf(context)),
          ),
        ),
        ReusableButton(
          text: NotificationsStrings.markAllAsRead,
          type: ButtonType.text,
          prefixIcon: Icons.done_all_rounded,
          onPressed: () => context.read<NotificationsBloc>().add(const MarkAllAsRead()),
        ),
        SizedBox(width: AppSpacing.md.w),
        ReusableButton(
          text: NotificationsStrings.clearAll,
          type: ButtonType.outlined,
          color: AppColors.error,
          prefixIcon: Icons.delete_sweep_rounded,
          onPressed: () => _showClearAllDialog(context),
        ),
      ],
    );
  }

  Widget _buildTabs(ColorScheme scheme) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: TabBar(
        controller: _tabController,
        labelColor: scheme.primary,
        unselectedLabelColor: Colors.grey,
        indicatorColor: scheme.primary,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelStyle: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold),
        tabs: const [
          Tab(text: NotificationsStrings.all, icon: Icon(Icons.all_inbox_rounded, size: 18)),
          Tab(text: NotificationsStrings.expiry, icon: Icon(Icons.event_busy_rounded, size: 18)),
          Tab(text: NotificationsStrings.stock, icon: Icon(Icons.inventory_2_rounded, size: 18)),
          Tab(text: NotificationsStrings.system, icon: Icon(Icons.settings_suggest_rounded, size: 18)),
        ],
      ),
    );
  }

  void _showClearAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: Icon(Icons.warning_rounded, color: AppColors.error, size: 32.sp),
        title: const ReusableText(AdminStrings.deleteAllNotifications, style: TextStyle(fontWeight: FontWeight.bold)),
        content: const ReusableText(NotificationsStrings.clearAllConfirm),
        actions: [
          ReusableButton(
            text: GeneralStrings.cancel,
            type: ButtonType.text,
            onPressed: () => ctx.pop(),
          ),
          ReusableButton(
            text: AdminStrings.deleteAll,
            type: ButtonType.error,
            onPressed: () {
              context.read<NotificationsBloc>().add(const ClearAllNotifications());
              ctx.pop();
            },
          ),
        ],
      ),
    );
  }
}

class _NotificationList extends StatelessWidget {
  final List<AppNotification> notifications;

  const _NotificationList({required this.notifications});

  @override
  Widget build(BuildContext context) {
    if (notifications.isEmpty) {
      return const EmptyState(
        icon: Icons.notifications_none_rounded,
        title: NotificationsStrings.noNotifications,
        subtitle: NotificationsStrings.noNotificationsSubtitle,
      );
    }

    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        return _NotificationCard(notification: notifications[index]);
      },
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final AppNotification notification;

  const _NotificationCard({required this.notification});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = _getCategoryColor(notification.category);
    final icon = _getCategoryIcon(notification.category);
    final dateFormat = DateFormat('yyyy/MM/dd | HH:mm');

    return AppCard(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: () {
          context.read<NotificationsBloc>().add(MarkAsRead(notification.id));
          if (notification.actionRoute != null) {
            context.push(notification.actionRoute!);
          }
        },
        borderRadius: BorderRadius.circular(AppRadius.md.r),
        child: Container(
          decoration: BoxDecoration(
            border: BorderDirectional(
              start: BorderSide(color: color, width: 4.w),
            ),
          ),
          padding: EdgeInsets.all(AppSpacing.md.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(icon, color: color, size: 22.sp),
              ),
              SizedBox(width: 16.w),
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
                              fontWeight: notification.isRead ? FontWeight.w600 : FontWeight.w900,
                              color: notification.isRead ? AppColors.textSecondaryOf(context) : AppColors.textPrimaryOf(context),
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 8.w,
                            height: 8.w,
                            decoration: BoxDecoration(color: scheme.primary, shape: BoxShape.circle),
                          ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    ReusableText(
                      notification.message,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textSecondaryOf(context),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Icon(Icons.access_time_rounded, size: AppIconSize.sm.value, color: Colors.grey),
                        SizedBox(width: 4.w),
                        ReusableText(
                          dateFormat.format(notification.timestamp),
                          style: AppTextStyles.caption(context).copyWith(color: Colors.grey),
                        ),
                        const Spacer(),
                        if (notification.actionRoute != null)
                          ReusableButton(
                            text: NotificationsStrings.viewDetails,
                            type: ButtonType.text,
                            size: ButtonSize.small,
                            onPressed: () {
                              context.read<NotificationsBloc>().add(MarkAsRead(notification.id));
                              context.push(notification.actionRoute!);
                            },
                          ),
                        SizedBox(width: 8.w),
                        IconButton(
                          icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
                          onPressed: () => context.read<NotificationsBloc>().add(DeleteNotification(notification.id)),
                          tooltip: NotificationsStrings.deleteNotification,
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(NotificationCategory category) {
    switch (category) {
      case NotificationCategory.expiry:
        return AppColors.error;
      case NotificationCategory.stock:
        return Colors.orange;
      case NotificationCategory.task:
        return Colors.blue;
      case NotificationCategory.crm:
        return Colors.purple;
      case NotificationCategory.system:
        return Colors.blueGrey;
    }
  }

  IconData _getCategoryIcon(NotificationCategory category) {
    switch (category) {
      case NotificationCategory.expiry:
        return Icons.event_busy_rounded;
      case NotificationCategory.stock:
        return Icons.inventory_2_rounded;
      case NotificationCategory.task:
        return Icons.task_alt_rounded;
      case NotificationCategory.crm:
        return Icons.people_alt_rounded;
      case NotificationCategory.system:
        return Icons.info_outline_rounded;
    }
  }
}






