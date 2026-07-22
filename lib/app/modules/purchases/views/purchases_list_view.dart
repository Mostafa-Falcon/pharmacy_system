import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:go_router/go_router.dart';

import 'package:pharmacy_system/app/modules/sales/models/purchase_model.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_colors.dart';
import '../../../core/utils/format_utils.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../routes/app_routes.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/index.dart';
import '../../../core/injection.dart';
import '../bloc/purchases_bloc.dart';
import '../bloc/purchases_event.dart';
import '../bloc/purchases_state.dart';

class PurchasesListView extends StatelessWidget {
  const PurchasesListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<PurchasesBloc>()..add(const LoadPurchases()),
      child: BlocBuilder<PurchasesBloc, PurchasesState>(
        builder: (context, state) {
          return StandardModuleLayout(
            title: AppStrings.allPurchases,
            actions: _buildHeaderActions(context, state),
            stats: _buildStats(context, state),
            filters: _buildDateFilter(context, state),
            content: _buildPurchasesList(context, state),
          );
        },
      ),
    );
  }

  List<Widget> _buildHeaderActions(BuildContext context, PurchasesState state) {
    return [
      ReusableButton(
        text: AppStrings.add,
        prefixIcon: Icons.add_rounded,
        color: AppColors.homePurchases,
        onPressed: () => context.push(Routes.PURCHASE_ADD),
      ),
      SizedBox(width: 8.w),
      ReusableButton(
        text: AppStrings.back,
        type: ButtonType.outlined,
        prefixIcon: Icons.arrow_back_rounded,
        onPressed: () => context.pop(),
      ),
    ];
  }

  List<Widget> _buildStats(BuildContext context, PurchasesState state) {
    final scheme = Theme.of(context).colorScheme;
    return [
      SummaryCard(
        label: 'إجمالي الفواتير',
        value: '${state.totalCount}',
        color: scheme.primary,
        icon: Icons.inventory_2_rounded,
      ),
      SummaryCard(
        label: 'ديون الموردين',
        value: FormatUtils.currency(state.creditTotal),
        color: AppColors.warning,
        icon: Icons.account_balance_wallet_rounded,
      ),
    ];
  }

  Widget _buildDateFilter(BuildContext context, PurchasesState state) {
    return AppCard(
      padding: EdgeInsets.all(12.w),
      child: Row(
        children: [
          const Spacer(),
          DateRangePicker(
            fromDate: state.dateFrom,
            toDate: state.dateTo,
          ),
        ],
      ),
    );
  }

  Widget _buildPurchasesList(BuildContext context, PurchasesState state) {
    if (state.status == PurchasesStatus.loading && state.allPurchases.isEmpty) return const LoadingIndicator();

    final items = state.filteredPurchases;
    final totalAmount = items.fold(0.0, (sum, p) => sum + p.finalAmount);
    final totalRemaining = items.fold(0.0, (sum, p) => sum + p.remainingAmount);

    final columns = [
      ReusableTableColumn<PurchaseModel>(
        id: 'date',
        title: AppStrings.date,
        width: 160.w,
        isSortable: true,
        textBuilder: (p) => DateFormat('yyyy/MM/dd HH:mm').format(p.createdAt),
      ),
      ReusableTableColumn<PurchaseModel>(
        id: 'id',
        title: 'رقم الفاتورة',
        width: 120.w,
        isSortable: true,
        textBuilder: (p) => '#${p.id.substring(0, 8).toUpperCase()}',
      ),
      ReusableTableColumn<PurchaseModel>(
        id: 'supplier',
        title: 'المورد',
        flex: 2,
        isSortable: true,
        textBuilder: (p) => p.supplierName,
      ),
      ReusableTableColumn<PurchaseModel>(
        id: 'status',
        title: 'الحالة',
        width: 110.w,
        cellBuilder: (p) => StatusBadge(label: 'استلم', color: AppColors.success),
      ),
      ReusableTableColumn<PurchaseModel>(
        id: 'payment_status',
        title: AppStrings.paymentStatus,
        width: 110.w,
        cellBuilder: (p) {
          final isPaid = p.remainingAmount <= 0;
          return StatusBadge(
            label: isPaid ? AppStrings.paymentPaid : AppStrings.paymentPartial,
            color: isPaid ? AppColors.success : AppColors.warning,
          );
        },
      ),
      ReusableTableColumn<PurchaseModel>(
        id: 'amount',
        title: 'المبلغ الإجمالي',
        width: 130.w,
        isNumeric: true,
        textBuilder: (p) => formatMoney(p.finalAmount),
      ),
      ReusableTableColumn<PurchaseModel>(
        id: 'paid',
        title: AppStrings.paidAmount,
        width: 130.w,
        isNumeric: true,
        textBuilder: (p) => formatMoney(p.finalAmount - p.remainingAmount),
      ),
      ReusableTableColumn<PurchaseModel>(
        id: 'due',
        title: AppStrings.dueAmount,
        width: 130.w,
        isNumeric: true,
        textBuilder: (p) => formatMoney(p.remainingAmount),
      ),
      ReusableTableColumn<PurchaseModel>(
        id: 'added_by',
        title: AppStrings.addedBy,
        width: 120.w,
        textBuilder: (p) => 'المسؤول',
      ),
    ];

    final bloc = context.read<PurchasesBloc>();

    return ReusableTable<PurchaseModel>(
      columns: columns,
      items: items,
      itemLabel: 'فاتورة مشتريات',
      showToolbar: true,
      onExportCsv: () => bloc.add(const ExportPurchasesCsv()),
      onSearchChanged: (v) => bloc.add(SearchPurchases(v)),
      rowActions: (p) => _buildRowActions(context, p),
      summaryRow: Row(
        children: [
          SizedBox(width: 100.w), // actions width
          SizedBox(
            width: 160.w + 120.w + 110.w, // date + id + status
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: ReusableText(
                'المجموع:',
                style: AppTextStyles.bodyBold(context),
              ),
            ),
          ),
          Expanded(flex: 2, child: const SizedBox()), // supplier
          SizedBox(
            width: 110.w, // payment_status
            child: const SizedBox(),
          ),
          SizedBox(
            width: 130.w,
            child: _cellPadding(ReusableText(formatMoney(totalAmount), style: AppTextStyles.bodyBold(context)), true),
          ),
          SizedBox(
            width: 130.w,
            child: _cellPadding(ReusableText(formatMoney(totalAmount - totalRemaining), style: AppTextStyles.bodyBold(context)), true),
          ),
          SizedBox(
            width: 130.w,
            child: _cellPadding(ReusableText(formatMoney(totalRemaining), style: AppTextStyles.bodyBold(context)), true),
          ),
          SizedBox(width: 120.w), // added_by
        ],
      ),
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

  Widget _buildRowActions(BuildContext context, PurchaseModel p) {
    final scheme = Theme.of(context).colorScheme;
    final bloc = context.read<PurchasesBloc>();

    return PopupMenuButton<String>(
      offset: const Offset(0, 40),
      onSelected: (v) {
        if (v == 'view') context.push(Routes.PURCHASE_DETAILS, extra: p);
        if (v == 'edit') {
          bloc.add(LoadPurchaseForEdit(p));
          context.push(Routes.PURCHASE_ADD, extra: p);
        }
        if (v == 'delete') {
          ConfirmDeleteDialog.show(
            context,
            title: 'إلغاء فاتورة المشتريات',
            message: 'هل أنت متأكد من إلغاء الفاتورة؟ سيتم خصم الكميات من المخزون.',
            onConfirm: () => bloc.add(VoidPurchase(p.id)),
          );
        }
      },
      itemBuilder: (ctx) => [
        _menuItem(ctx, 'view', Icons.visibility_rounded, AppStrings.inspect),
        _menuItem(ctx, 'print', Icons.print_rounded, AppStrings.print),
        _menuItem(ctx, 'payments', Icons.account_balance_wallet_rounded, AppStrings.invoicePayments),
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


