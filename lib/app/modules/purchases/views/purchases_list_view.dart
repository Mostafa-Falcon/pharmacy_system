import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:go_router/go_router.dart';

import 'package:pharmacy_system/app/core/models/purchases/purchase_invoice_model.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_colors.dart';
import '../../../core/utils/format_utils.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/string_ext.dart';
import '../../../routes/app_routes.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/index.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/reusables/tables/shared_table_cells.dart';
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
            title: PurchasesStrings.allPurchases,
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
        text: GeneralStrings.add,
        prefixIcon: Icons.add_rounded,
        color: AppColors.homePurchases,
        onPressed: () => context.push(Routes.PURCHASE_ADD),
      ),
      SizedBox(width: 8.w),
      ReusableButton(
        text: GeneralStrings.back,
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
    final scheme = Theme.of(context).colorScheme;
    final items = state.filteredPurchases;
    final totalAmount = items.fold(0.0, (sum, p) => sum + p.finalAmount);
    final totalRemaining = items.fold(0.0, (sum, p) => sum + p.remainingAmount);

    final columns = [
      ReusableTableColumn<PurchaseInvoiceModel>(
        id: 'id',
        title: 'رقم الفاتورة',
        width: 120.w,
        isSortable: true,
        textBuilder: (p) => '#${p.id.substring(0, 8).toUpperCase()}',
      ),
      ReusableTableColumn<PurchaseInvoiceModel>(
        id: 'supplier',
        title: 'المورد والبيان',
        flex: 2,
        isSortable: true,
        cellBuilder: (p) => TableContactNameCell(
          name: p.supplierName,
          subtitle: p.notes?.nullIfEmpty ?? 'لا توجد ملاحظات',
          icon: Icons.local_shipping_rounded,
          iconColor: scheme.primary,
        ),
      ),
      ReusableTableColumn<PurchaseInvoiceModel>(
        id: 'status',
        title: 'الحالة',
        width: 110.w,
        cellBuilder: (p) => StatusBadge(label: 'استلم', color: AppColors.success),
      ),
      ReusableTableColumn<PurchaseInvoiceModel>(
        id: 'payment_status',
        title: SalesStrings.paymentStatus,
        width: 110.w,
        cellBuilder: (p) {
          final isPaid = p.remainingAmount <= 0;
          return StatusBadge(
            label: isPaid ? SalesStrings.paymentPaid : SalesStrings.paymentPartial,
            color: isPaid ? AppColors.success : AppColors.warning,
          );
        },
      ),
      ReusableTableColumn<PurchaseInvoiceModel>(
        id: 'amount',
        title: 'المبلغ الإجمالي',
        width: 130.w,
        isNumeric: true,
        cellBuilder: (p) => TableMoneyCell(amount: p.finalAmount, currency: GeneralStrings.currency, isHighlight: true),
      ),
      ReusableTableColumn<PurchaseInvoiceModel>(
        id: 'due',
        title: SalesStrings.dueAmount,
        width: 130.w,
        isNumeric: true,
        cellBuilder: (p) => TableMoneyCell(amount: p.remainingAmount, currency: GeneralStrings.currency, isNegative: p.remainingAmount > 0),
      ),
      ReusableTableColumn<PurchaseInvoiceModel>(
        id: 'date',
        title: GeneralStrings.date,
        width: 160.w,
        isSortable: true,
        textBuilder: (p) => DateFormat('yyyy/MM/dd HH:mm').format(p.createdAt),
      ),
    ];

    final bloc = context.read<PurchasesBloc>();

    return ReusableTable<PurchaseInvoiceModel>(
      columns: columns,
      items: items,
      itemLabel: 'فاتورة مشتريات',
      showToolbar: true,
      onExportCsv: () => bloc.add(const ExportPurchasesCsv()),
      onSearchChanged: (v) => bloc.add(SearchPurchases(v)),
      rowActions: (p) => TableOptionsButton(
        onSelected: (v) {
          if (v == 'view') context.push(Routes.PURCHASE_DETAILS, extra: p);
          if (v == 'edit') {
            bloc.add(LoadPurchaseForEdit(p));
            context.push(Routes.PURCHASE_ADD);
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
        menuItems: [
          const PopupMenuItem(value: 'view', child: ReusableText(SalesStrings.inspect)),
          const PopupMenuItem(value: 'edit', child: ReusableText(GeneralStrings.edit)),
          const PopupMenuItem(value: 'print', child: ReusableText(GeneralStrings.print)),
          const PopupMenuItem(value: 'delete', child: ReusableText(GeneralStrings.delete, color: AppColors.error)),
        ],
      ),
      summaryRow: Row(
        children: [
          SizedBox(width: 100.w), // actions width
          SizedBox(
            width: 120.w, // id
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: ReusableText(
                'المجموع:',
                style: AppTextStyles.bodyBold(context),
              ),
            ),
          ),
          Expanded(flex: 2, child: const SizedBox()), // supplier
          SizedBox(width: 110.w), // status
          SizedBox(width: 110.w), // payment_status
          SizedBox(
            width: 130.w,
            child: _cellPadding(ReusableText(formatMoney(totalAmount), style: AppTextStyles.bodyBold(context)), true),
          ),
          SizedBox(
            width: 130.w,
            child: _cellPadding(ReusableText(formatMoney(totalRemaining), style: AppTextStyles.bodyBold(context)), true),
          ),
          SizedBox(width: 160.w), // date
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








