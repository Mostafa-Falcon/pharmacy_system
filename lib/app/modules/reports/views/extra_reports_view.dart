import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/core/data/services/admin/branch_data_service.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_colors.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_sizes.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/index.dart';
import 'package:pharmacy_system/app/core/constants/app_strings.dart';
import '../bloc/extra_reports_bloc.dart';
import '../services/extra_reports_service.dart';


class ExtraReportsView extends StatelessWidget {
  const ExtraReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExtraReportsBloc, ExtraReportsState>(
      builder: (context, state) {
        return HomeShell(
          title: ReportsStrings.reportsExtraTitle,
          child: Container(
            color: Theme.of(context)
                .colorScheme
                .surfaceContainerLow
                .withValues(alpha: 0.3),
            padding: EdgeInsets.all(AppSpacing.xl.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(context, state),
                SizedBox(height: AppSpacing.lg.h),
                Expanded(child: _buildContent(context, state)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, ExtraReportsState state) {
    final bloc = context.read<ExtraReportsBloc>();
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
              Expanded(
                child: AppText(ReportsStrings.dateRangePrefix.replaceFirst('%s', state.dateLabel),
                    style: AppTextStyles.body(context).copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondaryOf(context),
                    )),
              ),
              AppButton(
                text: ReportsStrings.reportsCustomRange,
                prefixIcon: Icons.calendar_month_outlined,
                type: ButtonType.text,
                onPressed: () => _pickDateRange(context),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md.h),
          SizedBox(
            height: 38.h,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: ExtraReportType.values.map((type) {
                final isSelected = state.selectedType == type;
                return QuickFilterChip(
                  label: _typeLabel(type),
                  isSelected: isSelected,
                  onTap: () => bloc.add(SelectExtraReportType(type)),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: AppSpacing.sm.h),
          AppText(
            state.typeSubtitle,
            style: AppTextStyles.caption(context).copyWith(color: AppColors.textMutedOf(context)),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDateRange(BuildContext context) async {
    final bloc = context.read<ExtraReportsBloc>();
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
      bloc.add(SetExtraReportRange(range.start, range.end));
    }
  }

  Widget _buildContent(BuildContext context, ExtraReportsState state) {
    if (state.isLoading) {
      return const LoadingIndicator(message: ReportsStrings.loadingReportMessage);
    }

    switch (state.selectedType) {
      case ExtraReportType.inventory:
        return SingleChildScrollView(
          child: _InventoryReportSection(rows: state.inventoryRows),
        );
      case ExtraReportType.inventoryCount:
        return SingleChildScrollView(
          child: _InventoryReportSection(rows: state.inventoryRows),
        );
      case ExtraReportType.popularItems:
        return SingleChildScrollView(
          child: _buildPopularItemsSection(context, state),
        );
      case ExtraReportType.itemMovement:
        return SingleChildScrollView(
          child: _buildItemMovementSection(context, state),
        );
      case ExtraReportType.taxSummary:
        return SingleChildScrollView(
          child: _TaxSummarySection(rows: state.taxSummaryRows),
        );
      case ExtraReportType.employeeActivity:
        return SingleChildScrollView(
          child: _EmployeeActivitySection(rows: state.employeeActivityRows),
        );
      case ExtraReportType.customerGroups:
        return SingleChildScrollView(
          child: _buildCustomerGroupsSection(context, state),
        );
      case ExtraReportType.receipts:
        return SingleChildScrollView(
          child: _buildReceiptsSection(context, state),
        );
      case ExtraReportType.salesRepPerformance:
        return SingleChildScrollView(
          child: _buildSalesRepPerformanceSection(context, state),
        );
    }
  }

  Widget _buildPopularItemsSection(BuildContext context, ExtraReportsState state) {
    final rows = state.popularItemRows;
    if (rows.isEmpty) {
      return const AppStateView.empty(
        title: ReportsStrings.noSalesTitle,
        subtitle: ReportsStrings.noSalesSubtitle,
        icon: Icons.star_outline_rounded,
      );
    }

    final totalQuantity = rows.fold<int>(0, (s, r) => s + r.soldQuantity);
    final totalSales = rows.fold<double>(0, (s, r) => s + r.salesTotal);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth > 800 ? 3 : 2;
            return GridView.count(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: AppSpacing.md.w,
              mainAxisSpacing: AppSpacing.md.h,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.8,
              children: [
                ReportCard(
                  title: ReportsStrings.soldItemsCountLabel,
                  value: rows.length.toString(),
                  color: AppColors.info,
                  icon: Icons.inventory_rounded,
                ),
                ReportCard(
                  title: ReportsStrings.soldUnitsTotalLabel,
                  value: totalQuantity.toString(),
                  color: AppColors.success,
                  icon: Icons.shopping_cart_rounded,
                ),
                ReportCard(
                  title: ReportsStrings.totalSalesAmountLabel,
                  value: '${totalSales.toStringAsFixed(2)} ${GeneralStrings.currency}',
                  color: AppColors.warning,
                  icon: Icons.attach_money_rounded,
                ),
              ],
            );
          },
        ),
        SizedBox(height: AppSpacing.lg.h),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 700) {
              return _buildPopularDataTable(context, rows);
            }
            return _buildPopularCards(context, rows);
          },
        ),
      ],
    );
  }

  Widget _buildPopularDataTable(BuildContext context, List<PopularItemRow> rows) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.sm.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(AppRadius.lg.r),
        border: Border.all(color: AppColors.borderOf(context).withValues(alpha: 0.3)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(AppColors.primarySoftOf(context)),
          columnSpacing: 20.w,
          columns: [
            DataColumn(label: AppText(ReportsStrings.itemHeader, style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.w700))),
            DataColumn(label: AppText(ReportsStrings.salesHeader, style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.w700)), numeric: true),
            DataColumn(label: AppText(ReportsStrings.totalSalesAmountLabel, style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.w700)), numeric: true),
            DataColumn(label: AppText(ReportsStrings.avgPriceHeader, style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.w700)), numeric: true),
            DataColumn(label: AppText(ReportsStrings.invoicesCountHeader, style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.w700)), numeric: true),
          ],
          rows: rows.map((r) => DataRow(cells: [
            DataCell(AppText(r.item, style: AppTextStyles.caption(context))),
            DataCell(AppText(r.soldQuantity.toString(), style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.w700))),
            DataCell(AppText('${r.salesTotal.toStringAsFixed(2)} ${GeneralStrings.currency}', style: AppTextStyles.caption(context).copyWith(color: AppColors.success))),
            DataCell(AppText('${r.avgPrice.toStringAsFixed(2)} ${GeneralStrings.currency}', style: AppTextStyles.caption(context))),
            DataCell(AppText(r.invoices.toString(), style: AppTextStyles.caption(context))),
          ])).toList(),
        ),
      ),
    );
  }

  Widget _buildPopularCards(BuildContext context, List<PopularItemRow> rows) {
    return Column(
      children: rows.map((r) => Container(
        margin: EdgeInsets.only(bottom: AppSpacing.sm.h),
        padding: EdgeInsets.all(AppSpacing.md.w),
        decoration: BoxDecoration(
          color: AppColors.surfaceOf(context),
          borderRadius: BorderRadius.circular(AppRadius.md.r),
          border: Border.all(color: AppColors.borderOf(context).withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(r.item, style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.w700)),
                  SizedBox(height: 4.h),
                  AppText(ReportsStrings.unitAndInvoiceFormat.replaceFirst('%s', r.soldQuantity.toString()).replaceFirst('%s', r.invoices.toString()),
                      style: AppTextStyles.caption(context).copyWith(color: AppColors.textMutedOf(context))),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AppText('${r.salesTotal.toStringAsFixed(2)} ${GeneralStrings.currency}',
                    style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.w700, color: AppColors.success)),
                AppText('@ ${r.avgPrice.toStringAsFixed(2)}',
                    style: AppTextStyles.caption(context).copyWith(color: AppColors.textMutedOf(context))),
              ],
            ),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildItemMovementSection(BuildContext context, ExtraReportsState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildMedicineSelector(context, state),
        SizedBox(height: AppSpacing.md.h),
        Builder(
          builder: (context) {
            final rows = state.movementRows;
            if (state.selectedMedicineId == null) {
              return const AppStateView.empty(
                title: ReportsStrings.selectItemTitle,
                subtitle: ReportsStrings.selectItemHint,
                icon: Icons.search_rounded,
              );
            }
            if (rows.isEmpty) {
              return const AppStateView.empty(
                title: ReportsStrings.noMovementsTitle,
                subtitle: ReportsStrings.noMovementsSubtitle,
                icon: Icons.motion_photos_off_rounded,
              );
            }
            return _buildMovementTable(context, rows);
          },
        ),
      ],
    );
  }

  Widget _buildMedicineSelector(BuildContext context, ExtraReportsState state) {
    final medicines = BranchDataService.getMedicines(
      branchId: AuthService.currentBranchId ?? '',
    ).where((m) => !m.isDeleted).toList();
    medicines.sort((a, b) => a.name.compareTo(b.name));

    return Container(
      padding: EdgeInsets.all(AppSpacing.md.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(AppRadius.md.r),
        border: Border.all(color: AppColors.borderOf(context).withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(ReportsStrings.selectItemTitle,
              style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.w600, color: AppColors.textSecondaryOf(context))),
          SizedBox(height: AppSpacing.sm.h),
          SizedBox(
            height: 40.h,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: medicines.map((m) {
                final isSelected = state.selectedMedicineId == m.id;
                return Padding(
                  padding: EdgeInsetsDirectional.only(end: 8.w),
                  child: QuickFilterChip(
                    label: m.name,
                    isSelected: isSelected,
                    onTap: () => context.read<ExtraReportsBloc>().add(SelectMovementMedicine(m.id)),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovementTable(BuildContext context, List<MovementRow> rows) {
    final totalQuantity = rows.fold<int>(0, (s, r) => s + r.quantity);
    final totalValue = rows.fold<double>(0, (s, r) => s + r.total);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth > 800 ? 3 : 2;
            return GridView.count(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: AppSpacing.md.w,
              mainAxisSpacing: AppSpacing.md.h,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.8,
              children: [
                ReportCard(
                  title: ReportsStrings.movementCountLabel,
                  value: rows.length.toString(),
                  color: AppColors.info,
                  icon: Icons.swap_horiz_rounded,
                ),
                ReportCard(
                  title: ReportsStrings.totalQuantityLabel,
                  value: totalQuantity.toString(),
                  color: AppColors.success,
                  icon: Icons.inventory_rounded,
                ),
                ReportCard(
                  title: ReportsStrings.totalValueLabel,
                  value: '${totalValue.toStringAsFixed(2)} ${GeneralStrings.currency}',
                  color: AppColors.warning,
                  icon: Icons.attach_money_rounded,
                ),
              ],
            );
          },
        ),
        SizedBox(height: AppSpacing.lg.h),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 700) {
              return _buildMovementDataTable(context, rows);
            }
            return _buildMovementCards(context, rows);
          },
        ),
      ],
    );
  }

  Widget _buildMovementDataTable(BuildContext context, List<MovementRow> rows) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.sm.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(AppRadius.lg.r),
        border: Border.all(color: AppColors.borderOf(context).withValues(alpha: 0.3)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(AppColors.primarySoftOf(context)),
          columnSpacing: 16.w,
          columns: [
            DataColumn(label: AppText(ReportsStrings.taxColumnDate, style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.w700))),
            DataColumn(label: AppText(ReportsStrings.taxColumnType, style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.w700))),
            DataColumn(label: AppText(ReportsStrings.taxColumnRef, style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.w700))),
            DataColumn(label: AppText(ReportsStrings.taxColumnParty, style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.w700))),
            DataColumn(label: AppText(SalesStrings.cartQuantity, style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.w700)), numeric: true),
            DataColumn(label: AppText(ReportsStrings.unitPriceHeader, style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.w700)), numeric: true),
            DataColumn(label: AppText(SalesStrings.cartTotal, style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.w700)), numeric: true),
          ],
          rows: rows.map((r) => DataRow(cells: [
            DataCell(AppText(r.date, style: AppTextStyles.caption(context))),
            DataCell(_movementTypeBadge(context, r.type)),
            DataCell(AppText(r.reference, style: AppTextStyles.caption(context).copyWith(color: AppColors.textMutedOf(context)))),
            DataCell(AppText(r.party, style: AppTextStyles.caption(context))),
            DataCell(AppText(r.quantity.toString(), style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.w700))),
            DataCell(AppText(r.unitPrice.toStringAsFixed(2), style: AppTextStyles.caption(context))),
            DataCell(AppText(r.total.toStringAsFixed(2), style: AppTextStyles.caption(context).copyWith(color: AppColors.warning))),
          ])).toList(),
        ),
      ),
    );
  }

  Widget _buildMovementCards(BuildContext context, List<MovementRow> rows) {
    return Column(
      children: rows.map((r) => Container(
        margin: EdgeInsets.only(bottom: AppSpacing.sm.h),
        padding: EdgeInsets.all(AppSpacing.md.w),
        decoration: BoxDecoration(
          color: AppColors.surfaceOf(context),
          borderRadius: BorderRadius.circular(AppRadius.md.r),
          border: Border.all(color: AppColors.borderOf(context).withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _movementTypeBadge(context, r.type),
                const Spacer(),
                 AppText(r.date, style: AppTextStyles.caption(context).copyWith(color: AppColors.textMutedOf(context))),
              ],
            ),
            SizedBox(height: 6.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(r.party, style: AppTextStyles.caption(context).copyWith(color: AppColors.textSecondaryOf(context))),
                AppText('${r.quantity} × ${r.unitPrice.toStringAsFixed(2)}',
                    style: AppTextStyles.caption(context).copyWith(color: AppColors.textSecondaryOf(context))),
              ],
            ),
            SizedBox(height: 4.h),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: AppText('${r.total.toStringAsFixed(2)} ${GeneralStrings.currency}',
                  style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.w700, color: AppColors.warning)),
            ),
          ],
        ),
      )).toList(),
    );
  }

  Widget _movementTypeBadge(BuildContext context, String type) {
    Color color;
    switch (type) {
      case ReportsStrings.movementTypeSale:
        color = AppColors.success;
        break;
      case ReportsStrings.movementTypePurchase:
        color = AppColors.info;
        break;
      case ReportsStrings.movementTypeSaleReturn:
        color = AppColors.error;
        break;
      case ReportsStrings.movementTypePurchaseReturn:
        color = AppColors.warning;
        break;
      default:
        color = AppColors.primary;
    }
    return StatusBadge(label: type, color: color);
  }

  String _typeLabel(ExtraReportType type) {
    switch (type) {
      case ExtraReportType.inventory: return ReportsStrings.reportsInventory;
      case ExtraReportType.inventoryCount: return ReportsStrings.reportsStocktake;
      case ExtraReportType.popularItems: return ReportsStrings.reportsPopularItems;
      case ExtraReportType.itemMovement: return ReportsStrings.reportsItemMovement;
      case ExtraReportType.taxSummary: return ReportsStrings.reportsTaxSummary;
      case ExtraReportType.employeeActivity: return ReportsStrings.reportsEmployeeActivity;
      case ExtraReportType.customerGroups: return ReportsStrings.typeCustomerGroups;
      case ExtraReportType.receipts: return ReportsStrings.typeReceipts;
      case ExtraReportType.salesRepPerformance: return ReportsStrings.typeSalesRepPerformance;
    }
  }

  Widget _buildCustomerGroupsSection(BuildContext context, ExtraReportsState state) {
    final rows = state.customerGroupRows;
    if (rows.isEmpty) {
      return const AppStateView.empty(
        title: ReportsStrings.noRepsTitle,
        subtitle: ReportsStrings.noCustomersSubtitle,
        icon: Icons.people_outline_rounded,
      );
    }

    final totalPurchases = rows.fold<double>(0, (s, r) => s + r.netPurchases);
    final totalCustomers = rows.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth > 800 ? 3 : 2;
            return GridView.count(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: AppSpacing.md.w,
              mainAxisSpacing: AppSpacing.md.h,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.8,
              children: [
                ReportCard(
                  title: ReportsStrings.customerCountLabel,
                  value: totalCustomers.toString(),
                  color: AppColors.info,
                  icon: Icons.people_rounded,
                ),
                ReportCard(
                  title: ReportsStrings.netPurchasesLabel,
                  value: '${totalPurchases.toStringAsFixed(2)} ${GeneralStrings.currency}',
                  color: AppColors.success,
                  icon: Icons.attach_money_rounded,
                ),
                ReportCard(
                  title: ReportsStrings.groupsLabel,
                  value: rows.map((r) => r.groupName).toSet().length.toString(),
                  color: AppColors.warning,
                  icon: Icons.category_rounded,
                ),
              ],
            );
          },
        ),
        SizedBox(height: AppSpacing.lg.h),
        _buildCustomerGroupsTable(context, rows),
      ],
    );
  }

  Widget _buildCustomerGroupsTable(BuildContext context, List<CustomerGroupRow> rows) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.sm.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(AppRadius.lg.r),
        border: Border.all(color: AppColors.borderOf(context).withValues(alpha: 0.3)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(AppColors.primarySoftOf(context)),
          columnSpacing: 16.w,
          columns: [
            DataColumn(label: AppText(ReportsStrings.groupHeader, style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.w700))),
            DataColumn(label: AppText(ReportsStrings.customerHeader, style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.w700))),
            DataColumn(label: AppText(ReportsStrings.phoneHeader, style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.w700))),
            DataColumn(label: AppText(ReportsStrings.visitsHeader, style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.w700)), numeric: true),
            DataColumn(label: AppText(ReportsStrings.purchasesHeader, style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.w700)), numeric: true),
            DataColumn(label: AppText(ReportsStrings.returnsHeader, style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.w700)), numeric: true),
            DataColumn(label: AppText(ReportsStrings.netHeader, style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.w700)), numeric: true),
          ],
          rows: rows.map((r) => DataRow(cells: [
            DataCell(AppText(r.groupName, style: AppTextStyles.caption(context))),
            DataCell(AppText(r.customerName, style: AppTextStyles.caption(context))),
            DataCell(AppText(r.phone, style: AppTextStyles.caption(context).copyWith(color: AppColors.textMutedOf(context)))),
            DataCell(AppText(r.visits.toString(), style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.w700))),
            DataCell(AppText('${r.totalPurchases.toStringAsFixed(2)} ${GeneralStrings.currency}', style: AppTextStyles.caption(context).copyWith(color: AppColors.success))),
            DataCell(AppText('${r.totalReturns.toStringAsFixed(2)} ${GeneralStrings.currency}', style: AppTextStyles.caption(context).copyWith(color: AppColors.error))),
            DataCell(AppText('${r.netPurchases.toStringAsFixed(2)} ${GeneralStrings.currency}', style: AppTextStyles.caption(context).copyWith(color: AppColors.warning))),
          ])).toList(),
        ),
      ),
    );
  }

  Widget _buildReceiptsSection(BuildContext context, ExtraReportsState state) {
    final rows = state.receiptRows;
    if (rows.isEmpty) {
      return const AppStateView.empty(
        title: ReportsStrings.noReceiptsTitle,
        subtitle: ReportsStrings.noReceiptsSubtitle,
        icon: Icons.receipt_long_outlined,
      );
    }

    final totalAmount = rows.fold<double>(0, (s, r) => s + r.amount);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth > 800 ? 3 : 2;
            return GridView.count(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: AppSpacing.md.w,
              mainAxisSpacing: AppSpacing.md.h,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.8,
              children: [
                ReportCard(
                  title: ReportsStrings.receiptsCountLabel,
                  value: rows.length.toString(),
                  color: AppColors.info,
                  icon: Icons.receipt_long_rounded,
                ),
                ReportCard(
                  title: ReportsStrings.totalAmountsLabel,
                  value: '${totalAmount.toStringAsFixed(2)} ${GeneralStrings.currency}',
                  color: AppColors.success,
                  icon: Icons.attach_money_rounded,
                ),
                ReportCard(
                  title: ReportsStrings.reportsSales,
                  value: rows.where((r) => r.type == ReportsStrings.receiptTypeSaleInvoice).length.toString(),
                  color: AppColors.primary,
                  icon: Icons.shopping_cart_rounded,
                ),
              ],
            );
          },
        ),
        SizedBox(height: AppSpacing.lg.h),
        _buildReceiptsTable(context, rows),
      ],
    );
  }

  Widget _buildReceiptsTable(BuildContext context, List<ReceiptRow> rows) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.sm.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(AppRadius.lg.r),
        border: Border.all(color: AppColors.borderOf(context).withValues(alpha: 0.3)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(AppColors.primarySoftOf(context)),
          columnSpacing: 16.w,
          columns: [
            DataColumn(label: AppText(ReportsStrings.taxColumnDate, style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.w700))),
            DataColumn(label: AppText(ReportsStrings.taxColumnType, style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.w700))),
            DataColumn(label: AppText(ReportsStrings.taxColumnRef, style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.w700))),
            DataColumn(label: AppText(ReportsStrings.taxColumnParty, style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.w700))),
            DataColumn(label: AppText(ReportsStrings.amountHeader, style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.w700)), numeric: true),
            DataColumn(label: AppText(ReportsStrings.taxColumnMethod, style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.w700))),
            DataColumn(label: AppText(ReportsStrings.notesHeader, style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.w700))),
          ],
          rows: rows.map((r) => DataRow(cells: [
            DataCell(AppText(r.date, style: AppTextStyles.caption(context))),
            DataCell(_receiptTypeBadge(context, r.type)),
            DataCell(AppText(r.reference.substring(0, 8).toUpperCase(), style: AppTextStyles.caption(context).copyWith(color: AppColors.textMutedOf(context)))),
            DataCell(AppText(r.contact, style: AppTextStyles.caption(context))),
            DataCell(AppText('${r.amount.toStringAsFixed(2)} ${GeneralStrings.currency}', style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.w700, color: AppColors.success))),
            DataCell(AppText(r.paymentMethod, style: AppTextStyles.caption(context))),
            DataCell(AppText(r.notes, style: AppTextStyles.caption(context).copyWith(color: AppColors.textMutedOf(context)))),
          ])).toList(),
        ),
      ),
    );
  }

  Widget _receiptTypeBadge(BuildContext context, String type) {
    Color color;
    switch (type) {
      case ReportsStrings.receiptTypeSaleInvoice:
        color = AppColors.success;
        break;
      case ReportsStrings.receiptTypePurchaseInvoice:
        color = AppColors.info;
        break;
      case ReportsStrings.movementTypeSaleReturn:
        color = AppColors.error;
        break;
      case ReportsStrings.movementTypePurchaseReturn:
        color = AppColors.warning;
        break;
      default:
        color = AppColors.primary;
    }
    return StatusBadge(label: type, color: color);
  }

  Widget _buildSalesRepPerformanceSection(BuildContext context, ExtraReportsState state) {
    final rows = state.salesRepPerformanceRows;
    if (rows.isEmpty) {
      return const AppStateView.empty(
        title: ReportsStrings.noRepsTitle,
        subtitle: ReportsStrings.noRepsSubtitle,
        icon: Icons.business_center_outlined,
      );
    }

    final totalCustomers = rows.fold<int>(0, (s, r) => s + r.customers);
    final totalVisits = rows.fold<int>(0, (s, r) => s + r.visits);
    final totalNetSales = rows.fold<double>(0, (s, r) => s + r.netSales);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth > 800 ? 4 : 2;
            return GridView.count(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: AppSpacing.md.w,
              mainAxisSpacing: AppSpacing.md.h,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.8,
              children: [
                ReportCard(
                  title: ReportsStrings.repsCountLabel,
                  value: rows.length.toString(),
                  color: AppColors.info,
                  icon: Icons.business_center_rounded,
                ),
                ReportCard(
                  title: ReportsStrings.totalCustomersLabel,
                  value: totalCustomers.toString(),
                  color: AppColors.success,
                  icon: Icons.people_rounded,
                ),
                ReportCard(
                  title: ReportsStrings.visitsLabel,
                  value: totalVisits.toString(),
                  color: AppColors.warning,
                  icon: Icons.visibility_rounded,
                ),
                ReportCard(
                  title: ReportsStrings.reportsSales,
                  value: '${totalNetSales.toStringAsFixed(2)} ${GeneralStrings.currency}',
                  color: AppColors.primary,
                  icon: Icons.attach_money_rounded,
                ),
              ],
            );
          },
        ),
        SizedBox(height: AppSpacing.lg.h),
        _buildSalesRepPerformanceTable(context, rows),
      ],
    );
  }

  Widget _buildSalesRepPerformanceTable(BuildContext context, List<SalesRepPerformanceRow> rows) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.sm.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(AppRadius.lg.r),
        border: Border.all(color: AppColors.borderOf(context).withValues(alpha: 0.3)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(AppColors.primarySoftOf(context)),
          columnSpacing: 16.w,
          columns: [
            DataColumn(label: AppText(ReportsStrings.repHeader, style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.w700))),
            DataColumn(label: AppText(ReportsStrings.contactFilterCustomers, style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.w700)), numeric: true),
            DataColumn(label: AppText(ReportsStrings.visitsHeader, style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.w700)), numeric: true),
            DataColumn(label: AppText(ReportsStrings.salesHeader, style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.w700)), numeric: true),
            DataColumn(label: AppText(ReportsStrings.returnsHeader, style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.w700)), numeric: true),
            DataColumn(label: AppText(ReportsStrings.netHeader, style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.w700)), numeric: true),
          ],
          rows: rows.map((r) => DataRow(cells: [
            DataCell(AppText(r.repName, style: AppTextStyles.caption(context))),
            DataCell(AppText(r.customers.toString(), style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.w700))),
            DataCell(AppText(r.visits.toString(), style: AppTextStyles.caption(context))),
            DataCell(AppText('${r.totalSales.toStringAsFixed(2)} ${GeneralStrings.currency}', style: AppTextStyles.caption(context).copyWith(color: AppColors.success))),
            DataCell(AppText('${r.totalReturns.toStringAsFixed(2)} ${GeneralStrings.currency}', style: AppTextStyles.caption(context).copyWith(color: AppColors.error))),
            DataCell(AppText('${r.netSales.toStringAsFixed(2)} ${GeneralStrings.currency}', style: AppTextStyles.caption(context).copyWith(color: AppColors.warning))),
          ])).toList(),
        ),
      ),
    );
  }
}

class _InventoryReportSection extends StatelessWidget {
  final List<dynamic> rows;
  const _InventoryReportSection({required this.rows});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(ReportsStrings.inventoryMovementReportTitleFormat.replaceFirst('%s', rows.length.toString()), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          if (rows.isEmpty)
            const Center(child: Text(ReportsStrings.noInventoryData))
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: rows.length,
              itemBuilder: (_, i) => ListTile(title: Text(rows[i].toString())),
            ),
        ],
      ),
    );
  }
}

class _TaxSummarySection extends StatelessWidget {
  final List<dynamic> rows;
  const _TaxSummarySection({required this.rows});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${ReportsStrings.reportsTaxSummary} (${rows.length})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          if (rows.isEmpty)
            const Center(child: Text(ReportsStrings.noTaxRecords))
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: rows.length,
              itemBuilder: (_, i) => ListTile(title: Text(rows[i].toString())),
            ),
        ],
      ),
    );
  }
}

class _EmployeeActivitySection extends StatelessWidget {
  final List<dynamic> rows;
  const _EmployeeActivitySection({required this.rows});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${ReportsStrings.reportsEmployeeActivity} (${rows.length})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          if (rows.isEmpty)
            const Center(child: Text(ReportsStrings.noEmployeeActivityData))
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: rows.length,
              itemBuilder: (_, i) => ListTile(title: Text(rows[i].toString())),
            ),
        ],
      ),
    );
  }
}





