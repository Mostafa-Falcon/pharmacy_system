import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' as intl;
import 'package:pharmacy_system/app/core/constants/strings/sync_strings.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/core/injection.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_colors.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_sizes.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/index.dart';
import 'package:pharmacy_system/app/modules/sync/models/sync_table_meta.dart';
import 'package:pharmacy_system/app/modules/sync/bloc/sync_status_bloc.dart';


/// شاشة حالة المزامنة والربط السحابي — لوحة تحكم قيادية عالمية (World-Class Executive Sync Dashboard)
class SyncStatusView extends StatelessWidget {
  const SyncStatusView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SyncStatusBloc>()..add(const SyncStatusStarted()),
      child: HomeShell(
        title: SyncStrings.syncStatusTitle,
        subtitle: SyncStrings.syncStatusSubtitle,
        child: BlocBuilder<SyncStatusBloc, SyncStatusState>(
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. بانر قيادة سحابي علوي منظم وفاخر (Command Hero Banner)
                  _buildCloudCommandBanner(context, state),
                  SizedBox(height: AppSpacing.sm),

                  // 2. المحتوى الرئيسي (Tables Grid 3-Columns & Live Activity Stream Sidebar)
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // القسم الرئيسي: جداول المنظومة (3 أعمدة متناسقة)
                        Expanded(
                          flex: 7,
                          child: _buildTablesGridSection(context, state),
                        ),
                        SizedBox(width: AppSpacing.md),
                        // القسم الجانبي: طابور العمليات المعلقة النشط
                        Expanded(
                          flex: 4,
                          child: _SyncPendingList(
                            items: state.pending,
                            onClearAll: () {
                              context.read<SyncStatusBloc>().add(const SyncStatusClearQueue());
                            },
                            onRemove: (id) async {
                              context.read<SyncStatusBloc>().add(SyncStatusRemoveItem(id));
                            },
                            onRefresh: () {
                              context.read<SyncStatusBloc>().add(const SyncStatusStarted());
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// بانر قيادي علوي مدمج ومنظم
  Widget _buildCloudCommandBanner(BuildContext context, SyncStatusState state) {
    final timeFormat = intl.DateFormat('HH:mm:ss');
    final lastTime = state.lastSyncTime != null ? timeFormat.format(state.lastSyncTime!) : '--:--';
    final activeName = state.activeTable != null ? syncTableLabel(state.activeTable!) : '';
    final isSyncing = state.isSyncing;

    // حساب نسبة الإنجاز للمعلقات لو كنا في حالة Push
    if (isSyncing && state.pending.isNotEmpty) {
      // هذه النسبة تقريبية بناءً على عدد العناصر المتبقية
      // سنقوم بتطويرها لاحقاً لتقرأ من الـ Bloc بشكل أدق لو لزم الأمر
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
            Theme.of(context).colorScheme.surface,
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg.r),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
          width: 1.w,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          // السطر 1: الحالة والأزرار
          Row(
            children: [
              // أيقونة حالة الاتصال بالسحابة بتأثير نبضي (Pulse Effect) لو متصل
              _buildConnectionIcon(context, state.isOnline),
              SizedBox(width: 12.w),

              // العنوان والنص التفاعلي
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ReusableText(
                          SyncStrings.connectionStatusLabel,
                          style: AppTextStyles.caption(context).copyWith(
                            color: AppColors.textSecondaryOf(context),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        StatusBadge(
                          label: state.isOnline ? SyncStrings.onlineState : SyncStrings.offlineState,
                          color: state.isOnline ? AppColors.success : AppColors.error,
                        ),
                        if (state.isOnline && isSyncing) ...[
                          SizedBox(width: 8.w),
                          const _LiveIndicator(color: AppColors.primary),
                        ],
                      ],
                    ),
                    SizedBox(height: 4.h),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: ReusableText(
                        isSyncing
                            ? (activeName.isNotEmpty
                                ? '${SyncStrings.syncInProgressMsg} ($activeName)'
                                : SyncStrings.syncInProgressMsg)
                            : SyncStrings.syncIdleMsg,
                        key: ValueKey(isSyncing ? activeName : 'idle'),
                        style: AppTextStyles.title(context).copyWith(
                          fontSize: 16.sp,
                          color: isSyncing ? AppColors.primary : AppColors.textPrimaryOf(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16.w),

              // الأزرار القيادية الملونة بتصميم Button Group
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _CommandButton(
                    label: SyncStrings.pullDataBtn,
                    icon: Icons.cloud_download_rounded,
                    onPressed: isSyncing ? null : () => context.read<SyncStatusBloc>().add(const SyncStatusTriggerPull()),
                  ),
                  SizedBox(width: 8.w),
                  _CommandButton(
                    label: SyncStrings.pushPendingBtn,
                    icon: Icons.cloud_upload_rounded,
                    onPressed: isSyncing ? null : () => context.read<SyncStatusBloc>().add(const SyncStatusTriggerPush()),
                  ),
                  if (state.deadLetterCount > 0) ...[
                    SizedBox(width: 8.w),
                    _CommandButton(
                      label: SyncStrings.retryFailedBtn,
                      icon: Icons.restart_alt_rounded,
                      color: AppColors.error,
                      onPressed: isSyncing ? null : () => context.read<SyncStatusBloc>().add(const SyncStatusRetryDeadLetter()),
                    ),
                  ],
                  SizedBox(width: 8.w),
                  ReusableButton(
                    text: SyncStrings.fullSyncBtn,
                    prefixIcon: Icons.sync_rounded,
                    onPressed: isSyncing ? null : () => context.read<SyncStatusBloc>().add(const SyncStatusTriggerSync()),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // السطر 2: مؤشرات KPI الثلاثة بشكل فخم
          Row(
            children: [
              Expanded(
                child: _buildExecutiveKPI(
                  context: context,
                  label: SyncStrings.pendingOperationsLabel,
                  value: '${state.pending.length}',
                  color: state.pending.isNotEmpty ? AppColors.warning : AppColors.success,
                  icon: Icons.pending_actions_rounded,
                  subtitle: state.pending.isNotEmpty ? 'عمليات بانتظار الرفع' : 'كل البيانات مرفوعة',
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildExecutiveKPI(
                  context: context,
                  label: SyncStrings.syncErrorsLabel,
                  value: '${state.deadLetterCount}',
                  color: state.deadLetterCount > 0 ? AppColors.error : AppColors.info,
                  icon: Icons.sync_problem_rounded,
                  subtitle: state.deadLetterCount > 0 ? 'سجلات تتطلب تدخل' : 'لا يوجد أخطاء',
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildExecutiveKPI(
                  context: context,
                  label: 'آخر مزامنة ناجحة',
                  value: lastTime,
                  color: AppColors.primary,
                  icon: Icons.history_rounded,
                  subtitle: state.lastSyncTime != null 
                    ? intl.DateFormat('yyyy/MM/dd').format(state.lastSyncTime!) 
                    : 'لم تتم المزامنة بعد',
                ),
              ),
            ],
          ),

          if (isSyncing) ...[
            SizedBox(height: 12.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'جاري المعالجة...',
                      style: AppTextStyles.caption(context).copyWith(color: AppColors.primary),
                    ),
                    if (state.pending.isNotEmpty)
                      Text(
                        'متبقي ${state.pending.length} سجل',
                        style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.bold),
                      ),
                  ],
                ),
                SizedBox(height: 6.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  child: LinearProgressIndicator(
                    minHeight: 6.h,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildConnectionIcon(BuildContext context, bool isOnline) {
    return Container(
      width: 42.sp,
      height: 42.sp,
      decoration: BoxDecoration(
        color: (isOnline ? AppColors.success : AppColors.error).withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          isOnline ? Icons.cloud_done_rounded : Icons.cloud_off_rounded,
          color: isOnline ? AppColors.success : AppColors.error,
          size: 24.sp,
        ),
      ),
    );
  }

  Widget _buildExecutiveKPI({
    required BuildContext context,
    required String label,
    required String value,
    required Color color,
    required IconData icon,
    required String subtitle,
  }) {
    return Container(
      padding: EdgeInsets.all(12.sp),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.md.r),
        border: Border.all(color: color.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.sp),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(AppRadius.md.r),
            ),
            child: Icon(icon, size: 20.sp, color: color),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: AppColors.textSecondaryOf(context),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimaryOf(context),
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 9.sp,
                    color: color.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// شبكة جداول المنظومة (3 أعمدة لتوزيع المساحة بامتياز)
  Widget _buildTablesGridSection(BuildContext context, SyncStatusState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.table_rows_rounded, size: 18.sp, color: AppColors.primary),
            SizedBox(width: 8.w),
            ReusableText(
              SyncStrings.tablesStatus,
              style: AppTextStyles.bodyBold(context),
            ),
            const Spacer(),
            ReusableText(
              '${syncTables.length} جداول مدمجة',
              style: AppTextStyles.caption(context).copyWith(
                color: AppColors.textSecondaryOf(context),
              ),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        Expanded(
          child: AppCard(
            padding: EdgeInsets.all(AppSpacing.sm),
            child: GridView.builder(
              physics: const BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: AppSpacing.sm,
                mainAxisSpacing: AppSpacing.sm,
                mainAxisExtent: 68.h,
              ),
              itemCount: syncTables.length,
              itemBuilder: (context, index) {
                final table = syncTables[index];
                return _SyncTableTile(
                  meta: table,
                  status: state.tableStates[table.table] ?? 'idle',
                  error: state.tableErrors[table.table],
                  localCount: state.tableCounts[table.table] ?? 0,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _LiveIndicator extends StatefulWidget {
  final Color color;
  const _LiveIndicator({required this.color});

  @override
  State<_LiveIndicator> createState() => _LiveIndicatorState();
}

class _LiveIndicatorState extends State<_LiveIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.4, end: 1.0).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _anim,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: widget.color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(AppRadius.chip),
          border: Border.all(color: widget.color.withValues(alpha: 0.4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 5.w,
              height: 5.w,
              decoration: BoxDecoration(
                color: widget.color,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 4.w),
            Text(
              'مباشر',
              style: TextStyle(
                fontSize: 9.sp,
                color: widget.color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SyncTableTile extends StatefulWidget {
  final SyncTableMeta meta;
  final String status;
  final String? error;
  final int localCount;

  const _SyncTableTile({
    required this.meta,
    required this.status,
    this.error,
    required this.localCount,
  });

  @override
  State<_SyncTableTile> createState() => _SyncTableTileState();
}

class _SyncTableTileState extends State<_SyncTableTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );

    if (widget.status == 'syncing') {
      _pulseCtrl.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant _SyncTableTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.status == 'syncing' && !_pulseCtrl.isAnimating) {
      _pulseCtrl.repeat(reverse: true);
    } else if (widget.status != 'syncing' && _pulseCtrl.isAnimating) {
      _pulseCtrl.stop();
      _pulseCtrl.animateTo(1.0, duration: const Duration(milliseconds: 300));
    }
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isSyncing = widget.status == 'syncing';
    final isSynced = widget.status == 'synced';
    final hasError = widget.error != null && widget.error!.isNotEmpty;

    return ScaleTransition(
      scale: _pulseAnim,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSyncing ? scheme.primary.withValues(alpha: 0.04) : scheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(
            color: hasError
                ? AppColors.error.withValues(alpha: 0.4)
                : (isSyncing
                    ? scheme.primary
                    : (isSynced
                        ? AppColors.success.withValues(alpha: 0.3)
                        : scheme.outlineVariant.withValues(alpha: 0.2))),
            width: isSyncing ? 1.5.w : 1.w,
          ),
          boxShadow: isSyncing
              ? [
                  BoxShadow(
                    color: scheme.primary.withValues(alpha: 0.1),
                    blurRadius: 10,
                    spreadRadius: 1,
                  )
                ]
              : null,
        ),
        child: Row(
          children: [
            if (isSyncing)
              const _RotatingSyncIcon()
            else
              Icon(
                hasError
                    ? Icons.error_outline_rounded
                    : (isSynced ? Icons.check_circle_outline_rounded : Icons.table_chart_rounded),
                size: 18.sp,
                color: hasError
                    ? AppColors.error
                    : (isSynced ? AppColors.success : scheme.onSurfaceVariant),
              ),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ReusableText(
                    widget.meta.label,
                    style: AppTextStyles.caption(context).copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 11.sp,
                      color: isSyncing ? scheme.primary : null,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  ReusableText(
                    '${widget.localCount} سجل محلي',
                    style: AppTextStyles.caption(context).copyWith(
                      fontSize: 10.sp,
                      color: isSyncing ? scheme.primary.withValues(alpha: 0.7) : scheme.onSurfaceVariant,
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

class _RotatingSyncIcon extends StatefulWidget {
  const _RotatingSyncIcon();

  @override
  State<_RotatingSyncIcon> createState() => _RotatingSyncIconState();
}

class _RotatingSyncIconState extends State<_RotatingSyncIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _ctrl,
      child: Icon(
        Icons.sync_rounded,
        size: 18.sp,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

class _SyncPendingList extends StatelessWidget {
  final List<OutboxTableData> items;
  final VoidCallback onClearAll;
  final Function(String) onRemove;
  final VoidCallback onRefresh;

  const _SyncPendingList({
    required this.items,
    required this.onClearAll,
    required this.onRemove,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.history_rounded, size: 18.sp, color: AppColors.primary),
            SizedBox(width: 8.w),
            ReusableText(
              'طابور العمليات المعلقة',
              style: AppTextStyles.bodyBold(context),
            ),
            const Spacer(),
            if (items.isNotEmpty)
              TextButton.icon(
                onPressed: onClearAll,
                icon: Icon(Icons.delete_sweep_rounded, size: 16.sp, color: AppColors.error),
                label: Text(
                  'مسح الكل',
                  style: TextStyle(fontSize: 10.sp, color: AppColors.error),
                ),
              ),
          ],
        ),
        SizedBox(height: 6.h),
        Expanded(
          child: AppCard(
            padding: EdgeInsets.zero,
            child: items.isEmpty
                ? _buildEmptyState(context)
                : ListView.separated(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
                    itemCount: items.length,
                    separatorBuilder: (context, index) => Divider(
                      height: 1.h,
                      indent: 45.w,
                      color: AppColors.dividerOf(context).withValues(alpha: 0.5),
                    ),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return _PendingItemTile(
                        item: item,
                        onRemove: () => onRemove(item.id),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20.sp),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.cloud_done_outlined,
              size: 48.sp,
              color: AppColors.success.withValues(alpha: 0.4),
            ),
          ),
          SizedBox(height: 16.h),
          ReusableText(
            'لا توجد عمليات معلقة',
            style: AppTextStyles.bodyBold(context).copyWith(
              color: AppColors.textSecondaryOf(context),
            ),
          ),
          SizedBox(height: 4.h),
          ReusableText(
            'جميع بياناتك متزامنة مع السحابة بسلام',
            style: AppTextStyles.caption(context),
          ),
        ],
      ),
    );
  }
}

class _PendingItemTile extends StatelessWidget {
  final OutboxTableData item;
  final VoidCallback onRemove;

  const _PendingItemTile({
    required this.item,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final isCreate = item.operation == 'create';
    final isDelete = item.operation == 'delete';

    final color = isCreate 
        ? AppColors.success 
        : (isDelete ? AppColors.error : AppColors.info);
    
    final icon = isCreate 
        ? Icons.add_circle_outline_rounded 
        : (isDelete ? Icons.remove_circle_outline_rounded : Icons.edit_note_rounded);

    return ListTile(
      dense: true,
      leading: Container(
        padding: EdgeInsets.all(8.sp),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppRadius.sm.r),
        ),
        child: Icon(icon, size: 18.sp, color: color),
      ),
      title: Text(
        syncTableLabel(item.targetTable),
        style: AppTextStyles.caption(context).copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 11.sp,
        ),
      ),
      subtitle: Text(
        'معرف: ${item.recordId.length > 8 ? item.recordId.substring(0, 8) : item.recordId}...',
        style: TextStyle(fontSize: 9.sp, color: AppColors.textSecondaryOf(context)),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (item.retryCount > 0)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              margin: EdgeInsets.only(left: 4.w),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                '${item.retryCount} محاولات',
                style: TextStyle(fontSize: 8.sp, color: AppColors.error, fontWeight: FontWeight.bold),
              ),
            ),
          IconButton(
            icon: Icon(Icons.close_rounded, size: 14.sp, color: AppColors.textSecondaryOf(context)),
            onPressed: onRemove,
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}

class _CommandButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;

  const _CommandButton({
    required this.label,
    required this.icon,
    this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final themeColor = color ?? Theme.of(context).colorScheme.primary;
    final isDisabled = onPressed == null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppRadius.md.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
          decoration: BoxDecoration(
            border: Border.all(
              color: themeColor.withValues(alpha: isDisabled ? 0.1 : 0.2),
            ),
            borderRadius: BorderRadius.circular(AppRadius.md.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16.sp,
                color: themeColor.withValues(alpha: isDisabled ? 0.4 : 1.0),
              ),
              SizedBox(width: 6.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: themeColor.withValues(alpha: isDisabled ? 0.4 : 1.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
