import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:pharmacy_system/app/core/constants/ui/app_colors.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/index.dart';
import 'package:pharmacy_system/app/core/models/inventory/stocktaking_period_model.dart';
import '../../../routes/app_routes.dart';
import '../bloc/stocktaking_bloc.dart';

/// واجهة فترات الجرد — تصميم عصري فاخر بدون مساحات ميتة (World-Class Stocktaking Dashboard)
class StocktakingListView extends StatefulWidget {
  const StocktakingListView({super.key});

  @override
  State<StocktakingListView> createState() => _StocktakingListViewState();
}

class _StocktakingListViewState extends State<StocktakingListView> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      final state = context.read<StocktakingBloc>().state;
      if (state.hasMore && !state.isLoading) {
        context.read<StocktakingBloc>().add(const LoadMoreStocktakingPeriods());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return HomeShell(
      title: StocktakingStrings.stocktakingTitle,
      subtitle: StocktakingStrings.stocktakingSubtitle,
      child: Container(
        color: scheme.surfaceContainerLow.withValues(alpha: 0.15),
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // كروت الملخص الإحصائي الممتدة بعرض الشاشة الكامل (Zero Dead Space)
            _buildStatsGrid(scheme),
            SizedBox(height: 16.h),

            // شريط الفلاتر والتحكم البصري الفاخر
            _buildControlToolbar(context, scheme),
            SizedBox(height: 16.h),

            // القائمة الرئيسية أو العرض عند خلو البيانات
            Expanded(child: _buildMainContent(context, scheme)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid(ColorScheme scheme) {
    return BlocBuilder<StocktakingBloc, StocktakingState>(
      buildWhen: (prev, current) => prev.periods != current.periods,
      builder: (context, state) {
        final s = state.stats;
        return LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 900;
            if (isWide) {
              return Row(
                children: [
                  Expanded(child: _StatCard(title: StocktakingStrings.stocktakingAll, count: s['total'] ?? 0, icon: Icons.inventory_2_rounded, color: scheme.primary, gradientColors: [scheme.primary.withValues(alpha: 0.1), scheme.primary.withValues(alpha: 0.02)])),
                  SizedBox(width: 12.w),
                  Expanded(child: _StatCard(title: StocktakingStrings.stocktakingOpen, count: s['open'] ?? 0, icon: Icons.lock_open_rounded, color: AppColors.info, gradientColors: [AppColors.info.withValues(alpha: 0.1), AppColors.info.withValues(alpha: 0.02)])),
                  SizedBox(width: 12.w),
                  Expanded(child: _StatCard(title: StocktakingStrings.stocktakingInProgressLabel, count: s['inProgress'] ?? 0, icon: Icons.pending_actions_rounded, color: AppColors.warning, gradientColors: [AppColors.warning.withValues(alpha: 0.1), AppColors.warning.withValues(alpha: 0.02)])),
                  SizedBox(width: 12.w),
                  Expanded(child: _StatCard(title: StocktakingStrings.stocktakingClosed, count: s['closed'] ?? 0, icon: Icons.check_circle_rounded, color: AppColors.success, gradientColors: [AppColors.success.withValues(alpha: 0.1), AppColors.success.withValues(alpha: 0.02)])),
                  SizedBox(width: 12.w),
                  Expanded(child: _StatCard(title: StocktakingStrings.stocktakingCancelled, count: s['cancelled'] ?? 0, icon: Icons.cancel_rounded, color: AppColors.error, gradientColors: [AppColors.error.withValues(alpha: 0.1), AppColors.error.withValues(alpha: 0.02)])),
                ],
              );
            }

            return Wrap(
              spacing: 12.w,
              runSpacing: 12.h,
              children: [
                SizedBox(width: (constraints.maxWidth - 24.w) / 3, child: _StatCard(title: StocktakingStrings.stocktakingAll, count: s['total'] ?? 0, icon: Icons.inventory_2_rounded, color: scheme.primary, gradientColors: [scheme.primary.withValues(alpha: 0.1), scheme.primary.withValues(alpha: 0.02)])),
                SizedBox(width: (constraints.maxWidth - 24.w) / 3, child: _StatCard(title: StocktakingStrings.stocktakingOpen, count: s['open'] ?? 0, icon: Icons.lock_open_rounded, color: AppColors.info, gradientColors: [AppColors.info.withValues(alpha: 0.1), AppColors.info.withValues(alpha: 0.02)])),
                SizedBox(width: (constraints.maxWidth - 24.w) / 3, child: _StatCard(title: StocktakingStrings.stocktakingInProgressLabel, count: s['inProgress'] ?? 0, icon: Icons.pending_actions_rounded, color: AppColors.warning, gradientColors: [AppColors.warning.withValues(alpha: 0.1), AppColors.warning.withValues(alpha: 0.02)])),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildControlToolbar(BuildContext context, ColorScheme scheme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // حقل البحث التفاعلي
          Expanded(
            child: SizedBox(
              height: 42.h,
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'ابحث باسم فترة الجرد أو الملاحظات...',
                  hintStyle: AppTextStyles.body(context).copyWith(color: scheme.onSurfaceVariant.withValues(alpha: 0.6), fontSize: 13.sp),
                  prefixIcon: Icon(Icons.search_rounded, size: 20.sp, color: scheme.onSurfaceVariant),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(icon: Icon(Icons.clear, size: 18.sp), onPressed: () => setState(() => _searchController.clear()))
                      : null,
                  contentPadding: EdgeInsets.symmetric(vertical: 8.h),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.input.r), borderSide: BorderSide.none),
                  filled: true,
                  fillColor: scheme.surfaceContainerLowest,
                ),
              ),
            ),
          ),
          SizedBox(width: 16.w),

          // فلاتر الحالة السريعة
          _buildFilterChip(context, label: 'الكل', value: 'all'),
          SizedBox(width: 6.w),
          _buildFilterChip(context, label: 'مفتوح', value: 'open'),
          SizedBox(width: 6.w),
          _buildFilterChip(context, label: 'مغلق', value: 'closed'),
          SizedBox(width: 16.w),

          // الأزرار الرئيسية
          ReusableButton(
            text: StocktakingStrings.stocktakingNewPeriod,
            prefixIcon: Icons.add_rounded,
            onPressed: () => _showCreateDialog(context),
          ),
          SizedBox(width: 8.w),
          ReusableButton(
            text: StocktakingStrings.stocktakingRefresh,
            prefixIcon: Icons.refresh_rounded,
            type: ButtonType.tonal,
            onPressed: () => context.read<StocktakingBloc>().add(LoadStocktakingPeriods()),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, {required String label, required String value}) {
    final scheme = Theme.of(context).colorScheme;
    final isSelected = _selectedFilter == value;

    return ChoiceChip(
      label: Text(label, style: TextStyle(fontSize: 12.sp, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? scheme.primary : scheme.onSurfaceVariant)),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) setState(() => _selectedFilter = value);
      },
      selectedColor: scheme.primary.withValues(alpha: 0.12),
      backgroundColor: scheme.surfaceContainerLowest,
      side: BorderSide(color: isSelected ? scheme.primary.withValues(alpha: 0.4) : scheme.outlineVariant.withValues(alpha: 0.2)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.button.r)),
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildMainContent(BuildContext context, ColorScheme scheme) {
    return BlocBuilder<StocktakingBloc, StocktakingState>(
      builder: (context, state) {
        if (state.isLoading && state.periods.isEmpty) {
          return const Center(child: LoadingIndicator());
        }

        var filtered = state.periods;
        if (_searchController.text.trim().isNotEmpty) {
          final query = _searchController.text.trim().toLowerCase();
          filtered = filtered.where((p) => p.name.toLowerCase().contains(query) || (p.notes?.toLowerCase().contains(query) ?? false)).toList();
        }

        if (_selectedFilter == 'open') {
          filtered = filtered.where((p) => !p.isClosed && !p.isCancelled).toList();
        } else if (_selectedFilter == 'closed') {
          filtered = filtered.where((p) => p.isClosed).toList();
        }

        if (filtered.isEmpty && !state.isLoading) {
          return _buildHeroEmptyState(context, scheme);
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 1000;
            if (isWide) {
              return GridView.builder(
                controller: _scrollController,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.8,
                  crossAxisSpacing: 16.w,
                  mainAxisSpacing: 16.h,
                ),
                itemCount: filtered.length + (state.hasMore ? 1 : 0),
                itemBuilder: (context, i) {
                  if (i >= filtered.length) {
                    return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                  }
                  return _PeriodGridCard(period: filtered[i], scheme: scheme);
                },
              );
            }

            return ListView.builder(
              controller: _scrollController,
              itemCount: filtered.length + (state.hasMore ? 1 : 0),
              itemBuilder: (context, i) {
                if (i >= filtered.length) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                  );
                }
                return _PeriodGridCard(period: filtered[i], scheme: scheme);
              },
            );
          },
        );
      },
    );
  }

  Widget _buildHeroEmptyState(BuildContext context, ColorScheme scheme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(32.w),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: scheme.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.inventory_2_outlined, size: 56.sp, color: scheme.primary),
          ),
          SizedBox(height: 20.h),
          ReusableText(
            'لا توجد فترات جرد مسجلة حالياً',
            style: AppTextStyles.title(context).copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.h),
          ReusableText(
            'قم ببدء فترة جرد دورية جديدة لتدقيق رصيد الأدوات والمستحضرات ومتابعة الفروقات بدقة متناهية.',
            style: AppTextStyles.body(context).copyWith(color: scheme.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          ReusableButton(
            text: StocktakingStrings.stocktakingNewPeriod,
            prefixIcon: Icons.add_rounded,
            onPressed: () => _showCreateDialog(context),
          ),
        ],
      ),
    );
  }

  void _showCreateDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    final bloc = context.read<StocktakingBloc>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(StocktakingStrings.stocktakingNewPeriod),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: InputDecoration(labelText: StocktakingStrings.stocktakingPeriodName, border: const OutlineInputBorder()),
              autofocus: true,
            ),
            SizedBox(height: AppSpacing.md.h),
            TextField(
              controller: notesCtrl,
              decoration: InputDecoration(labelText: StocktakingStrings.stocktakingNotes, border: const OutlineInputBorder()),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          ReusableButton(
            text: GeneralStrings.cancel,
            type: ButtonType.text,
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          ReusableButton(
            text: GeneralStrings.create,
            onPressed: () {
              if (nameCtrl.text.trim().isEmpty) return;
              bloc.add(CreateStocktakingPeriod(
                nameCtrl.text.trim(),
                notes: notesCtrl.text.trim().isEmpty ? null : notesCtrl.text.trim(),
              ));
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final Color color;
  final List<Color> gradientColors;

  const _StatCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: color.withValues(alpha: 0.2)),
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadius.input.r),
            ),
            child: Icon(icon, color: color, size: 22.sp),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ReusableText(
                  title,
                  style: AppTextStyles.caption(context).copyWith(color: scheme.onSurfaceVariant, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 2.h),
                ReusableText(
                  '$count',
                  style: AppTextStyles.title(context).copyWith(fontWeight: FontWeight.w800, color: color, fontSize: 18.sp),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PeriodGridCard extends StatelessWidget {
  final StocktakingPeriodModel period;
  final ColorScheme scheme;
  const _PeriodGridCard({required this.period, required this.scheme});

  Color _statusColor() {
    if (period.isClosed) return AppColors.success;
    if (period.isCancelled) return AppColors.error;
    if (period.isInProgress) return AppColors.warning;
    return AppColors.info;
  }

  String _statusLabel() {
    if (period.isClosed) return StocktakingStrings.stocktakingClosed;
    if (period.isCancelled) return StocktakingStrings.stocktakingCancelled;
    if (period.isInProgress) return StocktakingStrings.stocktakingInProgressLabel;
    return StocktakingStrings.stocktakingOpen;
  }

  @override
  Widget build(BuildContext context) {
    final progress = period.totalItems > 0 ? (period.countedItems / period.totalItems).clamp(0.0, 1.0) : 0.0;
    final color = _statusColor();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.push('${Routes.STOCKTAKING_DETAIL}?periodId=${period.id}'),
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 10.w,
                    height: 10.w,
                    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: ReusableText(
                      period.name,
                      style: AppTextStyles.bodyBold(context).copyWith(fontSize: 14.sp),
                      maxLines: 1,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(AppRadius.button.r)),
                    child: ReusableText(
                      _statusLabel(),
                      style: AppTextStyles.caption(context).copyWith(color: color, fontWeight: FontWeight.bold, fontSize: 11.sp),
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (v) {
                      final bloc = context.read<StocktakingBloc>();
                      if (v == 'close') {
                        bloc.add(CloseStocktakingPeriod(period.id));
                      } else if (v == 'cancel') {
                        bloc.add(CancelStocktakingPeriod(period.id));
                      } else if (v == 'delete') {
                        bloc.add(DeleteStocktakingPeriod(period.id));
                      }
                    },
                    itemBuilder: (_) => [
                      ReusableActionMenuItem(value: 'close', icon: Icons.lock_outline_rounded, label: StocktakingStrings.stocktakingClose),
                      ReusableActionMenuItem(value: 'cancel', icon: Icons.cancel_outlined, label: StocktakingStrings.stocktakingCancel),
                      ReusableActionMenuItem(value: 'delete', icon: Icons.delete_outline_rounded, label: GeneralStrings.delete, color: AppColors.error),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              // شريط نسبة التقدم
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4.r),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 6.h,
                        backgroundColor: scheme.surfaceContainerLowest,
                        color: color,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  ReusableText(
                    '${(progress * 100).toInt()}%',
                    style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.bold, color: color),
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              // تفاصيل الأعداد
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _MetricPill(label: 'إجمالي الأصناف', value: '${period.totalItems}', scheme: scheme),
                  _MetricPill(label: 'تم جردها', value: '${period.countedItems}', scheme: scheme),
                  _MetricPill(
                    label: 'الفروقات',
                    value: period.totalDifference.toStringAsFixed(0),
                    color: period.totalDifference != 0 ? AppColors.warning : null,
                    scheme: scheme,
                  ),
                ],
              ),
              const Spacer(),
              Divider(height: 1.h, color: scheme.outlineVariant.withValues(alpha: 0.2)),
              SizedBox(height: 6.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.calendar_today_rounded, size: 12.sp, color: scheme.onSurfaceVariant),
                      SizedBox(width: 4.w),
                      ReusableText(
                        DateFormat('yyyy/MM/dd - HH:mm').format(period.startedAt),
                        style: AppTextStyles.caption(context).copyWith(color: scheme.onSurfaceVariant, fontSize: 11.sp),
                      ),
                    ],
                  ),
                  Icon(Icons.arrow_forward_ios_rounded, size: 12.sp, color: scheme.onSurfaceVariant),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricPill extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  final ColorScheme scheme;

  const _MetricPill({
    required this.label,
    required this.value,
    this.color,
    required this.scheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ReusableText('$label: ', style: AppTextStyles.caption(context).copyWith(fontSize: 11.sp, color: scheme.onSurfaceVariant)),
          ReusableText(value, style: AppTextStyles.caption(context).copyWith(fontSize: 11.sp, fontWeight: FontWeight.bold, color: color ?? scheme.onSurface)),
        ],
      ),
    );
  }
}






