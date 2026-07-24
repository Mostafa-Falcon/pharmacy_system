import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:pharmacy_system/app/core/models/sales/cashier_shift_model.dart';
import 'package:pharmacy_system/app/core/models/sales/sale_invoice_model.dart';
import 'package:pharmacy_system/app/core/data/services/sales/cashier_shift_service.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_colors.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/index.dart';
import '../../../core/utils/format_utils.dart';
import '../../../routes/app_routes.dart';
import 'package:pharmacy_system/app/core/bloc/base_state.dart';
import '../bloc/cashier_shift_bloc.dart';

class CashierShiftView extends StatefulWidget {
  const CashierShiftView({super.key});

  @override
  State<CashierShiftView> createState() => _CashierShiftViewState();
}

class _CashierShiftViewState extends State<CashierShiftView> {
  final Set<String> _expandedIds = {};

  void _toggleExpand(String id) {
    setState(() {
      if (_expandedIds.contains(id)) {
        _expandedIds.remove(id);
      } else {
        _expandedIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return HomeShell(
      title: SalesStrings.cashierShiftsTitle,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest.withValues(alpha: 0.5),
        body: BlocBuilder<CashierShiftBloc, BaseState<List<CashierShiftModel>>>(
          builder: (context, state) {
            final shifts = state.data ?? [];
            final activeShifts = shifts.where((s) => s.status == CashierShiftStatus.open).length;
            final closedShifts = shifts.where((s) => s.status == CashierShiftStatus.closed).length;
            final totalOpeningCash = shifts
                .where((s) => s.status == CashierShiftStatus.open)
                .fold<double>(0, (sum, s) => sum + s.openingCash);

            return SingleChildScrollView(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(context),
                  SizedBox(height: 20.h),
                  _buildKpiMetrics(
                    context,
                    activeShifts: activeShifts,
                    closedShifts: closedShifts,
                    totalOpeningCash: totalOpeningCash,
                    totalShifts: shifts.length,
                  ),
                  SizedBox(height: 24.h),
                  if (state.isLoading)
                    Container(
                      height: 300.h,
                      alignment: Alignment.center,
                      child: const LoadingIndicator(),
                    )
                  else if (shifts.isEmpty)
                    _buildEmptyState(context)
                  else
                    _buildShiftList(context, shifts),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.8)]),
              borderRadius: BorderRadius.circular(AppRadius.button),
            ),
            child: Icon(Icons.point_of_sale_rounded, color: Colors.white, size: AppIconSize.xl.value.sp),
          ),
          SizedBox(width: 14.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ReusableText(SalesStrings.cashierShiftsTitle, style: AppTextStyles.title(context)),
              ReusableText(SalesStrings.cashierShiftsSubtitle, style: AppTextStyles.caption(context)),
            ],
          ),
          const Spacer(),
          ReusableButton(
            text: SalesStrings.startNewSession,
            prefixIcon: Icons.add_rounded,
            onPressed: () => context.push(Routes.SALES_OPEN_SHIFT),
          ),
        ],
      ),
    );
  }

  Widget _buildKpiMetrics(BuildContext context, {required int activeShifts, required int closedShifts, required double totalOpeningCash, required int totalShifts}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 700;
        return GridView.count(
          crossAxisCount: isMobile ? 2 : 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 14.w,
          mainAxisSpacing: 14.h,
          childAspectRatio: isMobile ? 2.2 : 2.5,
          children: [
            _MetricCard(title: SalesStrings.openShiftsLabel, value: '$activeShifts', icon: Icons.play_circle_fill_rounded, color: AppColors.success),
            _MetricCard(title: SalesStrings.openingLabelShifts, value: FormatUtils.currency(totalOpeningCash), icon: Icons.account_balance_wallet_rounded, color: AppColors.primary),
            _MetricCard(title: SalesStrings.closedShiftsLabel, value: '$closedShifts', icon: Icons.check_circle_rounded, color: AppColors.info),
            _MetricCard(title: SalesStrings.totalRecordsLabel, value: '$totalShifts', icon: Icons.receipt_long_rounded, color: Colors.purple),
          ],
        );
      },
    );
  }

  Widget _buildShiftList(BuildContext context, List<CashierShiftModel> shifts) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: shifts.length,
      separatorBuilder: (_, _) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final shift = shifts[index];
        return _ShiftCard(
          shift: shift,
          isExpanded: _expandedIds.contains(shift.id),
          onToggle: () => _toggleExpand(shift.id),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return EmptyState(
      icon: Icons.history_toggle_off_rounded,
      title: SalesStrings.noShiftsYet,
      subtitle: SalesStrings.noShiftsMessage,
      action: ReusableButton(
        text: SalesStrings.startFirstShift,
        onPressed: () => context.push(Routes.SALES_OPEN_SHIFT),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title, value;
  final IconData icon;
  final Color color;
  const _MetricCard({required this.title, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.all(14.w),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12.r)),
            child: Icon(icon, color: color, size: AppIconSize.lg.value.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ReusableText(title, style: AppTextStyles.caption(context)),
                ReusableText(value, style: AppTextStyles.bodyBold(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ShiftCard extends StatelessWidget {
  final CashierShiftModel shift;
  final bool isExpanded;
  final VoidCallback onToggle;

  const _ShiftCard({required this.shift, required this.isExpanded, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isOpen = shift.status == CashierShiftStatus.open;

    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          ListTile(
            onTap: onToggle,
            leading: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: isOpen ? AppColors.success.withValues(alpha: 0.1) : scheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppRadius.pill),
                border: Border.all(color: isOpen ? AppColors.success.withValues(alpha: 0.3) : scheme.outlineVariant),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(isOpen ? Icons.play_arrow_rounded : Icons.lock_clock_rounded, size: AppIconSize.sm.value.sp, color: isOpen ? AppColors.success : scheme.onSurfaceVariant),
                  SizedBox(width: 4.w),
                  ReusableText('${SalesStrings.shiftLabel} #${shift.shiftNumber}', style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.bold, color: isOpen ? AppColors.success : null)),
                ],
              ),
            ),
            title: Row(
              children: [
                Icon(Icons.access_time_rounded, size: AppIconSize.sm.value.sp, color: Colors.grey),
                SizedBox(width: 6.w),
                ReusableText('${SalesStrings.openedAtLabel} ${FormatUtils.dateTime(shift.openedAt)}', style: AppTextStyles.caption(context)),
              ],
            ),
            trailing: FutureBuilder<Map<String, dynamic>>(
              future: CashierShiftService.getShiftSummary(shift.id),
              builder: (context, snapshot) {
                final total = snapshot.data?['total_sales'] ?? 0.0;
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _MiniChip(label: SalesStrings.openingLabelShifts, value: FormatUtils.currency(shift.openingCash), color: scheme.primary),
                    SizedBox(width: 8.w),
                    _MiniChip(label: HomeStrings.sectionSales, value: FormatUtils.currency(total), color: AppColors.success),
                    SizedBox(width: 12.w),
                    Icon(isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded),
                  ],
                );
              },
            ),
          ),
          if (isExpanded) _ExpandedShiftDetails(shiftId: shift.id),
        ],
      ),
    );
  }
}

class _MiniChip extends StatelessWidget {
  final String label, value;
  final Color color;
  const _MiniChip({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(AppRadius.button), border: Border.all(color: color.withValues(alpha: 0.2))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ReusableText(label, style: AppTextStyles.caption(context).copyWith(fontSize: 9.sp, color: color, fontWeight: FontWeight.bold)),
          ReusableText(value, style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}

class _ExpandedShiftDetails extends StatelessWidget {
  final String shiftId;
  const _ExpandedShiftDetails({required this.shiftId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: CashierShiftService.getShiftTransactions(shiftId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Padding(padding: EdgeInsets.all(20), child: LoadingIndicator());
        final transactions = snapshot.data!;
        if (transactions.isEmpty) return Padding(padding: const EdgeInsets.all(20), child: ReusableText(GeneralStrings.noData));

        return Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerLowest, borderRadius: BorderRadius.vertical(bottom: Radius.circular(AppRadius.card))),
          child: Column(
            children: [
              ...transactions.map((t) => ListTile(
                dense: true,
                title: ReusableText('#${t.id.substring(0, 8).toUpperCase()}', style: AppTextStyles.bodyBold(context)),
                subtitle: ReusableText(FormatUtils.dateTime(t.createdAt), style: AppTextStyles.caption(context)),
                trailing: ReusableText(FormatUtils.currency(t is SaleInvoiceModel ? t.finalAmount : t.totalAmount), style: AppTextStyles.bodyBold(context).copyWith(color: t is SaleInvoiceModel ? AppColors.success : AppColors.error)),
              )),
            ],
          ),
        );
      },
    );
  }
}








