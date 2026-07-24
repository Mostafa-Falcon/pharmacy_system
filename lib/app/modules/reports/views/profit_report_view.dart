import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pharmacy_system/app/core/constants/ui/app_colors.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_sizes.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/index.dart';
import 'package:pharmacy_system/app/core/constants/app_strings.dart';
import '../bloc/reports_bloc.dart';
import '../services/report_projection_service.dart';

class ProfitReportView extends StatelessWidget {
  const ProfitReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeShell(
      title: ReportsStrings.reportsProfit,
      child: Container(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerLow
            .withValues(alpha: 0.3),
        padding: EdgeInsets.all(AppSpacing.xl.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildPeriodSelector(context),
            SizedBox(height: AppSpacing.lg.h),
            Expanded(
              child: BlocBuilder<ReportsBloc, ReportsState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const LoadingIndicator(message: ReportsStrings.loadingReportMessage);
                  }
                  final error = state.errorMessage;
                  if (error != null) {
                    return _buildErrorState(context, error);
                  }
                  final report = state.bundle;
                  if (report == null) {
                    return const EmptyState(
                      title: GeneralStrings.noData,
                      icon: Icons.bar_chart_outlined,
                    );
                  }
                  return _buildReportContent(context, report);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodSelector(BuildContext context) {
    final bloc = context.read<ReportsBloc>();
    final state = bloc.state;
    return Container(
      padding: EdgeInsets.all(AppSpacing.md.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(AppRadius.lg.r),
        border: Border.all(
            color: AppColors.borderOf(context).withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.date_range_rounded, size: AppIconSize.md.value, color: AppColors.textSecondaryOf(context)),
              SizedBox(width: 8.w),
              ReusableText(ReportsStrings.periodPrefix.replaceFirst('%s', state.periodLabel),
                  style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.w600, color: AppColors.textSecondaryOf(context))),
              const Spacer(),
              ReusableButton(
                text: ReportsStrings.reportsCustomRange,
                prefixIcon: Icons.calendar_month_outlined,
                type: ButtonType.text,
                onPressed: () => _pickCustomRange(context),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: ReportPeriod.values.map((period) {
              final isSelected = state.selectedPeriod == period;
              return QuickFilterChip(
                label: _periodLabel(period),
                isSelected: isSelected,
                onTap: () => bloc.add(SelectReportPeriod(period)),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Future<void> _pickCustomRange(BuildContext context) async {
    final bloc = context.read<ReportsBloc>();
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
        start: bloc.state.fromDate,
        end: bloc.state.toDate,
      ),
    );
    if (range != null) {
      bloc.add(PickCustomRange(range.start, range.end));
    }
  }

  String _periodLabel(ReportPeriod period) {
    switch (period) {
      case ReportPeriod.today:
        return ReportsStrings.todayLabel;
      case ReportPeriod.thisWeek:
        return ReportsStrings.reportsThisWeek;
      case ReportPeriod.thisMonth:
        return ReportsStrings.thisMonthLabel;
      case ReportPeriod.thisYear:
        return ReportsStrings.reportsThisYear;
      case ReportPeriod.custom:
        return ReportsStrings.reportsCustom;
    }
  }

  Widget _buildReportContent(BuildContext context, ProfitReportBundle report) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildMetricCards(context, report),
          SizedBox(height: AppSpacing.lg.h),
          _buildJournalIntegrity(context, report),
        ],
      ),
    );
  }

  Widget _buildMetricCards(BuildContext context, ProfitReportBundle report) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 800 ? 3 : 2;
        return GridView.count(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: AppSpacing.lg.w,
          mainAxisSpacing: AppSpacing.lg.h,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.8,
          children: [
            ReportCard(
              title: ReportsStrings.netProfitLabel,
              value: _formatMoney(report.netProfit),
              color: report.netProfit >= 0
                  ? AppColors.success
                  : AppColors.error,
              icon: report.netProfit >= 0
                  ? Icons.trending_up_rounded
                  : Icons.trending_down_rounded,
            ),
            ReportCard(
              title: ReportsStrings.revenueLabel,
              value: _formatMoney(report.revenue),
              color: AppColors.primary,
              icon: Icons.attach_money_rounded,
            ),
            ReportCard(
              title: ReportsStrings.cogsLabel,
              value: _formatMoney(report.costOfGoodsSold),
              color: AppColors.warning,
              icon: Icons.inventory_2_outlined,
            ),
            ReportCard(
              title: ReportsStrings.grossProfitLabel,
              value: _formatMoney(report.grossProfit),
              color: AppColors.info,
              icon: Icons.insights_rounded,
            ),
            ReportCard(
              title: ReportsStrings.reportsOperationalExpenses,
              value: _formatMoney(report.operatingExpenses),
              color: AppColors.homeAdministration,
              icon: Icons.payments_outlined,
            ),
            ReportCard(
              title: ReportsStrings.netSalesLabel,
              value: _formatMoney(report.netSales),
              color: AppColors.homeSales,
              icon: Icons.point_of_sale_outlined,
            ),
          ],
        );
      },
    );
  }

  Widget _buildJournalIntegrity(
      BuildContext context, ProfitReportBundle report) {
    return SectionCard(
      padding: EdgeInsets.all(AppSpacing.lg.w),
      dividers: false,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: AppColors.infoSoftOf(context),
                borderRadius: BorderRadius.circular(AppRadius.md.r),
              ),
              child: Icon(Icons.book_rounded,
                  size: 18.sp, color: AppColors.info),
            ),
            SizedBox(width: 10.w),
            ReusableText(ReportsStrings.reportsJournalIntegrity,
                style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.w700, color: AppColors.textPrimaryOf(context))),
          ],
        ),
        SizedBox(height: AppSpacing.md.h),
        _integrityRow(ReportsStrings.totalDebitLabel, report.totalDebit, context),
        _integrityRow(ReportsStrings.totalCreditLabel, report.totalCredit, context),
        const Divider(),
        Row(
          children: [
            Icon(
              report.isBalanced
                  ? Icons.verified_rounded
                  : Icons.warning_amber_rounded,
              size: 20.sp,
              color: report.isBalanced
                  ? AppColors.success
                  : AppColors.error,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: ReusableText(
                report.isBalanced
                    ? ReportsStrings.journalBalancedMsg
                    : ReportsStrings.journalUnbalancedMsg,
                style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.w800, color: report.isBalanced ? AppColors.success : AppColors.error),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _integrityRow(String label, double value, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ReusableText(label,
              style: AppTextStyles.body(context).copyWith(color: AppColors.textSecondaryOf(context))),
          ReusableText(_formatMoney(value),
              style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.w700, color: AppColors.textPrimaryOf(context))),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline_rounded, size: AppIconSize.xxl.value, color: AppColors.error),
          SizedBox(height: AppSpacing.md.h),
          ReusableText(ReportsStrings.reportLoadError,
              style: AppTextStyles.title(context).copyWith(fontWeight: FontWeight.w600, color: AppColors.textPrimaryOf(context))),
          SizedBox(height: AppSpacing.sm.h),
          ReusableText(error,
              style: AppTextStyles.caption(context).copyWith(color: AppColors.textSecondaryOf(context)),
              maxLines: 3,
              overflow: TextOverflow.ellipsis),
          SizedBox(height: AppSpacing.lg.h),
          ReusableButton(
            text: ReportsStrings.retryButton,
            prefixIcon: Icons.refresh_rounded,
            type: ButtonType.primary,
            onPressed: () => context.read<ReportsBloc>().add(const LoadReport()),
          ),
        ],
      ),
    );
  }

  String _formatMoney(double value) {
    return '${value.toStringAsFixed(2)} ${GeneralStrings.currency}';
  }
}






