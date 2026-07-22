import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' hide TextDirection;

import 'package:pharmacy_system/app/modules/sales/models/return_model.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_colors.dart';
import '../../../core/utils/format_utils.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/injection.dart';
import 'package:pharmacy_system/app/core/data/services/admin/branch_data_service.dart';
import '../bloc/purchase_return_bloc.dart';
import '../bloc/purchase_return_event.dart';
import '../bloc/purchase_return_state.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/index.dart';

class PurchaseReturnListView extends StatelessWidget {
  const PurchaseReturnListView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return BlocProvider.value(
      value: sl<PurchaseReturnBloc>()..add(const LoadPurchaseReturns()),
      child: HomeShell(
        title: AppStrings.allReturns,
        child: Container(
          color: scheme.surfaceContainerLow.withValues(alpha: 0.15),
          padding: EdgeInsets.all(AppSpacing.xl.w),
          child: BlocBuilder<PurchaseReturnBloc, PurchaseReturnState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(context, state),
                  SizedBox(height: AppSpacing.lg.h),
                  _buildFilters(context, state),
                  SizedBox(height: AppSpacing.md.h),
                  Expanded(child: _buildList(context, state)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, PurchaseReturnState state) {
    return Row(
      children: [
        ReusableButton(
          text: AppStrings.add,
          prefixIcon: Icons.add_rounded,
          color: AppColors.homePurchases,
          onPressed: () => context.push('/admin/purchases/returns/add'),
        ),
        const Spacer(),
        ReusableButton(
          text: AppStrings.back,
          type: ButtonType.outlined,
          prefixIcon: Icons.arrow_back_rounded,
          onPressed: () => context.pop(),
        ),
      ],
    );
  }

  Widget _buildFilters(BuildContext context, PurchaseReturnState state) {
    final scheme = Theme.of(context).colorScheme;
    return AppCard(
      padding: EdgeInsets.all(AppSpacing.xl.w),
      child: Column(
        children: [
          Row(
            children: [
              SummaryCard(
                label: 'إجمالي المرتجعات',
                value: '${state.totalCount}',
                color: scheme.primary,
                icon: Icons.assignment_return_rounded,
                minWidth: 160.w,
              ),
              SizedBox(width: AppSpacing.md.w),
              SummaryCard(
                label: 'إجمالي القيمة المرتجعة',
                value: formatMoney(state.totalReturned),
                color: AppColors.error,
                icon: Icons.money_off_rounded,
                minWidth: 200.w,
              ),
              const Spacer(),
              const DateRangePicker(),
            ],
          ),
          SizedBox(height: AppSpacing.lg.h),
          Row(
            children: [
              FilterDropdown.string(
                label: AppStrings.supplierLabel,
                items: ['الكل'],
                onChanged: (v) {},
              ),
              SizedBox(width: AppSpacing.md.w),
              FilterDropdown.string(
                label: AppStrings.reasonLabel,
                items: ['الكل', 'منتهي الصلاحية', 'تالف', 'خطأ في الصنف'],
                onChanged: (v) {},
              ),
              SizedBox(width: AppSpacing.md.w),
              FilterDropdown.string(
                label: 'المخزن',
                items: ['الكل'],
                onChanged: (v) {},
              ),
              SizedBox(width: AppSpacing.md.w),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context, PurchaseReturnState state) {
    final scheme = Theme.of(context).colorScheme;
    if (state.status == PurchaseReturnStatus.loading && state.returns.isEmpty) return const LoadingIndicator();

    final items = state.filteredReturns;
    final totalAmount = items.fold(0.0, (sum, r) => sum + r.totalAmount);

    final columns = [
      ReusableTableColumn<ReturnModel>(
        id: 'actions',
        title: 'خيار',
        width: 100.w,
        cellBuilder: (r) => _buildRowActions(context, r),
      ),
      ReusableTableColumn<ReturnModel>(
        id: 'date',
        title: AppStrings.date,
        width: 160.w,
        isSortable: true,
        textBuilder: (r) => DateFormat('yyyy/MM/dd HH:mm').format(r.createdAt),
      ),
      ReusableTableColumn<ReturnModel>(
        id: 'id',
        title: 'رقم المرتجع',
        width: 120.w,
        isSortable: true,
        textBuilder: (r) => '#${r.id.substring(0, 8).toUpperCase()}',
      ),
      ReusableTableColumn<ReturnModel>(
        id: 'purchaseId',
        title: 'الفاتورة الأصلية',
        width: 120.w,
        textBuilder: (r) => r.purchaseId != null ? '#${r.purchaseId!.substring(0, 8).toUpperCase()}' : '---',
      ),
      ReusableTableColumn<ReturnModel>(
        id: 'supplier',
        title: 'المورد',
        flex: 2,
        textBuilder: (r) {
          if (r.purchaseId != null) {
            final p = BranchDataService.getPurchase(r.purchaseId!);
            if (p != null) return p.supplierName;
          }
          return 'غير محدد';
        },
      ),
      ReusableTableColumn<ReturnModel>(
        id: 'reason',
        title: AppStrings.reasonLabel,
        width: 130.w,
        cellBuilder: (r) {
          final label = switch (r.reason) {
            ReturnReason.expired => AppStrings.reasonExpired,
            ReturnReason.damaged => AppStrings.reasonDamaged,
            ReturnReason.wrongItem => AppStrings.reasonWrongItem,
            _ => AppStrings.reasonOther,
          };
          return StatusBadge(label: label, color: AppColors.warning);
        },
      ),
      ReusableTableColumn<ReturnModel>(
        id: 'amount',
        title: 'القيمة الإجمالية',
        width: 140.w,
        isNumeric: true,
        textBuilder: (r) => formatMoney(r.totalAmount),
      ),
      ReusableTableColumn<ReturnModel>(
        id: 'qty',
        title: AppStrings.quantity,
        width: 80.w,
        isNumeric: true,
        textBuilder: (r) => '${r.items.length}.00',
      ),
      ReusableTableColumn<ReturnModel>(
        id: 'added_by',
        title: AppStrings.addedBy,
        width: 120.w,
        textBuilder: (r) => 'المسؤول',
      ),
    ];

    return Column(
      children: [
        _buildTableToolbar(context, state),
        Expanded(
          child: ReusableTable<ReturnModel>(
            columns: columns,
            items: items,
            itemLabel: 'مرتجع مشتريات',
            bodyRowHeight: 56.h,
            tableFooter: Container(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              decoration: BoxDecoration(
                color: scheme.surface,
                border: Border(top: BorderSide(color: scheme.outlineVariant, width: 2)),
              ),
              child: Row(
                children: [
                  SizedBox(width: 100.w), // actions
                  SizedBox(width: 160.w), // date
                  SizedBox(width: 120.w), // id
                  SizedBox(width: 120.w), // purchaseId
                  Expanded(flex: 2, child: const SizedBox()), // supplier
                  SizedBox(width: 130.w, child: _cellPadding(ReusableText('المجموع:', style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.bold)), false)),
                  SizedBox(width: 140.w, child: _cellPadding(ReusableText(formatMoney(totalAmount), style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.bold)), true)),
                  SizedBox(width: 80.w), // qty
                  SizedBox(width: 120.w), // added_by
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _cellPadding(Widget child, bool isNumeric) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Align(
        alignment: isNumeric ? Alignment.centerLeft : Alignment.centerRight,
        child: child,
      ),
    );
  }

  Widget _buildTableToolbar(BuildContext context, PurchaseReturnState state) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
      child: Row(
        children: [
          ReusableText('إدخالات', style: AppTextStyles.body(context)),
          SizedBox(width: 8.w),
          _rowsPerPageDropdown(),
          SizedBox(width: 8.w),
          ReusableText('عرض', style: AppTextStyles.body(context)),
          const Spacer(),
          _toolbarButton(Icons.ios_share_rounded, 'تصدير إلى CSV'),
          _toolbarButton(Icons.print_outlined, AppStrings.print),
          _toolbarButton(Icons.view_column_outlined, AppStrings.viewColumns),
          SizedBox(width: 16.w),
          SizedBox(
            width: 250.w,
            child: ReusableInput(
              hint: 'بحث...',
              prefixIcon: const Icon(Icons.search_rounded),
              onChanged: (v) => context.read<PurchaseReturnBloc>().add(SearchPurchaseReturns(v)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _rowsPerPageDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(6.r)),
      child: DropdownButton<int>(
        value: 25,
        items: [25, 50, 100].map((e) => DropdownMenuItem(value: e, child: ReusableText('$e'))).toList(),
        onChanged: (v) {},
        underline: const SizedBox(),
        isDense: true,
      ),
    );
  }

  Widget _toolbarButton(IconData icon, String label) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: 8.w),
      child: ReusableButton(
        text: label,
        prefixIcon: icon,
        type: ButtonType.outlined,
        size: ButtonSize.small,
        onPressed: () {},
      ),
    );
  }

  Widget _buildRowActions(BuildContext context, ReturnModel r) {
    final scheme = Theme.of(context).colorScheme;
    return PopupMenuButton<String>(
      offset: const Offset(0, 40),
      onSelected: (v) {
        if (v == 'view') { /* logic */ }
      },
      itemBuilder: (ctx) => [
        _menuItem(ctx, 'view', Icons.visibility_rounded, AppStrings.inspect),
        _menuItem(ctx, 'print', Icons.print_rounded, AppStrings.print),
        _menuItem(ctx, 'delete', Icons.delete_outline_rounded, AppStrings.delete, color: AppColors.error),
      ],
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: scheme.primary,
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ReusableText('خيارات', style: AppTextStyles.caption(context).copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
            Icon(Icons.keyboard_arrow_down_rounded, size: AppIconSize.sm.value, color: Colors.white),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<String> _menuItem(BuildContext context, String value, IconData icon, String label, {Color? color}) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: AppIconSize.md.value, color: color ?? Colors.grey.shade700),
          SizedBox(width: 12.w),
          ReusableText(label, style: AppTextStyles.body(context).copyWith(color: color)),
        ],
      ),
    );
  }
}


