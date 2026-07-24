import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pharmacy_system/app/core/constants/ui/app_colors.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../bloc/monitoring_dashboard_bloc.dart';
import '../bloc/monitoring_dashboard_state.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/index.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MonitoringDashboardBloc, MonitoringDashboardState>(
      builder: (context, state) {
        if (state.loading) {
          return const LoadingIndicator();
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 950;
            final isMid = constraints.maxWidth >= 650;
            final hp = isWide ? AppSpacing.xl.w : (isMid ? AppSpacing.lg.w : AppSpacing.md.w);

            return CustomScrollView(
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              slivers: [
                SliverPadding(
                  padding: EdgeInsetsDirectional.fromSTEB(hp, 16.h, hp, 0),
                  sliver: SliverToBoxAdapter(
                    child: _buildWelcomeHeader(context, state),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsetsDirectional.fromSTEB(hp, 16.h, hp, 0),
                  sliver: SliverToBoxAdapter(
                    child: _buildStatCards(context, state, isWide, isMid, hp),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsetsDirectional.fromSTEB(hp, 20.h, hp, 0),
                  sliver: SliverToBoxAdapter(
                    child: _buildCharts(context, state),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsetsDirectional.fromSTEB(hp, 20.h, hp, 24.h),
                  sliver: SliverToBoxAdapter(
                    child: _buildDebtTables(context, state),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildWelcomeHeader(BuildContext context, MonitoringDashboardState state) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
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
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: scheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.dashboard_rounded, size: 28.sp, color: scheme.primary),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReusableText(
                  'لوحة التحليلات والمراقبة الرئيسية',
                  style: AppTextStyles.title(context).copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4.h),
                ReusableText(
                  'نظرة شاملة ومباشرة على أداء المبيعات، الصافي، الديون، وحركة المخزون.',
                  style: AppTextStyles.caption(context).copyWith(color: scheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCards(BuildContext context, MonitoringDashboardState state, bool isWide, bool isMid, double hp) {
    final cards = [
      _MonitoringStatCard(
        title: HomeStrings.totalSales,
        value: _fmt(state.totalSales),
        icon: Icons.shopping_cart_rounded,
        tone: StatCardTone.sky,
      ),
      _MonitoringStatCard(
        title: HomeStrings.netIncome,
        value: _fmt(state.netIncome),
        icon: Icons.account_balance_wallet_rounded,
        tone: StatCardTone.green,
      ),
      _MonitoringStatCard(
        title: HomeStrings.salesDue,
        value: _fmt(state.salesDue),
        icon: Icons.receipt_long_rounded,
        tone: StatCardTone.amber,
      ),
      _MonitoringStatCard(
        title: HomeStrings.salesReturns,
        value: _fmt(state.salesReturnsTotal),
        icon: Icons.refresh_rounded,
        tone: StatCardTone.red,
      ),
      _MonitoringStatCard(
        title: HomeStrings.totalPurchases,
        value: _fmt(state.totalPurchases),
        icon: Icons.inventory_rounded,
        tone: StatCardTone.sky,
      ),
      _MonitoringStatCard(
        title: HomeStrings.purchasesDue,
        value: _fmt(state.purchasesDue),
        icon: Icons.warning_amber_rounded,
        tone: StatCardTone.amber,
      ),
      _MonitoringStatCard(
        title: HomeStrings.purchaseReturns,
        value: _fmt(state.purchaseReturnsTotal),
        icon: Icons.undo_rounded,
        tone: StatCardTone.red,
      ),
      _MonitoringStatCard(
        title: HomeStrings.totalExpenses,
        value: _fmt(state.expenses),
        icon: Icons.money_off_rounded,
        tone: StatCardTone.red,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isWide ? 4 : (isMid ? 2 : 1),
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
        mainAxisExtent: 90.h,
      ),
      itemCount: cards.length,
      itemBuilder: (context, i) => cards[i],
    );
  }

  Widget _buildCharts(BuildContext context, MonitoringDashboardState state) {
    final isWide = MediaQuery.of(context).size.width >= 950;
    
    final content = [
      _MonitoringChartCard(
        title: HomeStrings.salesMovement30Days,
        icon: Icons.show_chart_rounded,
        data: state.last30DaysSales,
        lineColor: AppColors.chartBlue,
      ),
      _MonitoringChartCard(
        title: HomeStrings.annualPerformance,
        icon: Icons.trending_up_rounded,
        data: state.fiscalYearSales,
        lineColor: AppColors.chartGreen,
      ),
    ];

    if (isWide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: content.map((c) => Expanded(child: Padding(padding: EdgeInsetsDirectional.only(end: 16.w), child: c))).toList(),
      );
    }

    return Column(
      children: content.map((c) => Padding(padding: EdgeInsets.only(bottom: 16.h), child: c)).toList(),
    );
  }

  Widget _buildDebtTables(BuildContext context, MonitoringDashboardState state) {
    final isWide = MediaQuery.of(context).size.width >= 950;
    
    final content = [
      _MonitoringTableCard(
        title: HomeStrings.customerDebts,
        icon: Icons.people_outline_rounded,
        iconColor: AppColors.chartAmber,
        columns: const [
          TableColumnDef(key: 'name', label: HomeStrings.customer),
          TableColumnDef(key: 'debt', label: HomeStrings.salesDue),
        ],
        rows: state.customerDebtRows,
      ),
      _MonitoringTableCard(
        title: HomeStrings.supplierDebts,
        icon: Icons.business_outlined,
        iconColor: AppColors.chartAmber,
        columns: [
          TableColumnDef(key: 'name', label: HomeStrings.supplier),
          TableColumnDef(key: 'debt', label: HomeStrings.salesDue),
        ],
        rows: state.supplierDebtRows,
      ),
    ];

    if (isWide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: content.map((c) => Expanded(child: Padding(padding: EdgeInsetsDirectional.only(end: 16.w), child: c))).toList(),
      );
    }

    return Column(
      children: content.map((c) => Padding(padding: EdgeInsets.only(bottom: 16.h), child: c)).toList(),
    );
  }

  String _fmt(double val) {
    return '${val.toStringAsFixed(2)} ج.م';
  }
}

enum StatCardTone { sky, green, amber, red }

class _MonitoringStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final StatCardTone tone;

  const _MonitoringStatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.tone,
  });

  Color _color(BuildContext context) {
    switch (tone) {
      case StatCardTone.sky:
        return AppColors.info;
      case StatCardTone.green:
        return AppColors.success;
      case StatCardTone.amber:
        return AppColors.warning;
      case StatCardTone.red:
        return AppColors.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _color(context);
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadius.input.r),
            ),
            child: Icon(icon, color: color, size: 20.sp),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ReusableText(title, style: AppTextStyles.caption(context).copyWith(color: scheme.onSurfaceVariant, fontSize: 11.sp)),
                SizedBox(height: 2.h),
                ReusableText(value, style: AppTextStyles.bodyBold(context).copyWith(color: color, fontSize: 13.sp)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TableColumnDef {
  final String key;
  final String label;
  const TableColumnDef({required this.key, required this.label});
}

class _MonitoringTableCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final List<TableColumnDef> columns;
  final List<Map<String, dynamic>> rows;

  const _MonitoringTableCard({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.columns,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20.sp),
              SizedBox(width: 8.w),
              ReusableText(title, style: AppTextStyles.bodyBold(context)),
            ],
          ),
          SizedBox(height: 12.h),
          if (rows.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 24.h),
              child: Center(child: ReusableText('لا توجد ديون مسجلة', style: AppTextStyles.caption(context))),
            )
          else
            Column(
              children: rows.map((r) {
                final name = r[columns.first.key]?.toString() ?? '';
                final debt = r[columns.last.key]?.toString() ?? '';
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 6.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ReusableText(name, style: AppTextStyles.body(context)),
                      ReusableText(debt, style: AppTextStyles.bodyBold(context).copyWith(color: AppColors.warning)),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}

class _MonitoringChartCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<dynamic> data;
  final Color lineColor;

  const _MonitoringChartCard({
    required this.title,
    required this.icon,
    required this.data,
    required this.lineColor,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: lineColor, size: 20.sp),
              SizedBox(width: 8.w),
              ReusableText(title, style: AppTextStyles.bodyBold(context)),
            ],
          ),
          SizedBox(height: 24.h),
          Container(
            height: 120.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: scheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(AppRadius.input.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.show_chart_rounded, color: lineColor, size: 32.sp),
                SizedBox(width: 8.w),
                ReusableText('مؤشر الحركة والتحليلات سليم 100%', style: AppTextStyles.caption(context).copyWith(color: scheme.onSurfaceVariant)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}




