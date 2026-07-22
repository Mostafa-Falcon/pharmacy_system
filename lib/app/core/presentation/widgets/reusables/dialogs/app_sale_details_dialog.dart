import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pharmacy_system/app/core/constants/app_strings.dart';
import 'package:pharmacy_system/app/core/utils/format_utils.dart';
import 'package:pharmacy_system/app/core/data/services/admin/branch_data_service.dart';
import 'package:pharmacy_system/app/modules/sales/models/sale_model.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_colors.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_sizes.dart';

import '../buttons/app_button.dart';
import '../dialogs/app_dialog.dart';
import '../display/app_text.dart';

class SaleDetailsDialog extends StatelessWidget {
  final SaleModel sale;

  const SaleDetailsDialog({super.key, required this.sale});

  static void show(BuildContext context, SaleModel sale) {
    showDialog(
      context: context,
      builder: (ctx) => SaleDetailsDialog(sale: sale),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ReusableDialog(
      title: AppStrings.saleDetailsTitle.replaceFirst('%s', sale.id.substring(0, 8).toUpperCase()),
      maxWidth: 950.w,
      children: [
        // Top Info
        Wrap(
          spacing: 24.w,
          runSpacing: 12.h,
          children: [
            _infoItem(context, AppStrings.invoiceNumberLabel, '#${sale.id.substring(0, 8).toUpperCase()}'),
            _infoItem(context, AppStrings.date, formatDateTime(sale.createdAt)),
            _infoItem(context, AppStrings.saleResponsibleEmployee, sale.createdBy), // هنعرض الـ ID أو الاسم لو توفر
            _infoItem(context, AppStrings.customerNameLabel, sale.customerName ?? AppStrings.cashCustomer),
            _infoItem(context, AppStrings.paymentMethodLabel, sale.paymentMethod),
          ],
        ),
        SizedBox(height: AppSpacing.lg.h),
        // Items Table
        ReusableText(AppStrings.itemsTitle, style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.bold)),
        SizedBox(height: AppSpacing.sm.h),
        _buildItemsTable(context),
        SizedBox(height: AppSpacing.lg.h),
        // Totals and Payments
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Totals column
            Expanded(
              flex: 1,
              child: Column(
                children: [
                   _totalRow(context, AppStrings.total, formatMoney(sale.totalAmount)),
                   _totalRow(context, AppStrings.discount, '- ${formatMoney(sale.discount ?? 0)}'),
                   _totalRow(context, AppStrings.tax, '+ ${formatMoney(sale.taxAmount ?? 0)}'),
                   _totalRow(context, AppStrings.saleShipping, '+ ${formatMoney(0)}'), 
                   const Divider(),
                   _totalRow(context, AppStrings.finalTotal, formatMoney(sale.finalAmount), isBold: true),
                   _totalRow(context, AppStrings.salePayments, formatMoney(sale.paidAmount ?? sale.finalAmount)),
                   _totalRow(context, AppStrings.saleRemaining, formatMoney(sale.dueAmount), color: sale.dueAmount > 0 ? AppColors.error : AppColors.success),
                ],
              ),
            ),
            SizedBox(width: AppSpacing.xl.w),
            // Payments column
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   ReusableText(AppStrings.paymentInfo, style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.bold)),
                  SizedBox(height: AppSpacing.sm.h),
                  _buildPaymentsTable(context),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.xl.h),
        // Footer Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ReusableButton(
              text: AppStrings.packing,
              prefixIcon: Icons.inventory_2_rounded,
              color: AppColors.success,
              onPressed: () {},
            ),
            SizedBox(width: 12.w),
            ReusableButton(
              text: AppStrings.printInvoice,
              prefixIcon: Icons.print_rounded,
              color: AppColors.info,
              onPressed: () {},
            ),
            SizedBox(width: 12.w),
            ReusableButton(
              text: AppStrings.close,
              type: ButtonType.outlined,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ],
    );
  }

  Widget _infoItem(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ReusableText(label, style: AppTextStyles.caption(context).copyWith(color: Colors.grey.shade600)),
        ReusableText(value, style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _totalRow(BuildContext context, String label, String value, {bool isBold = false, Color? color}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ReusableText(label, style: AppTextStyles.caption(context).copyWith(fontWeight: isBold ? FontWeight.bold : null)),
          ReusableText(value, style: AppTextStyles.caption(context).copyWith(fontWeight: isBold ? FontWeight.w900 : FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildItemsTable(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.success.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(AppRadius.input.r),
      ),
      child: Column(
        children: [
          Container(
            color: AppColors.success,
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Row(
              children: [
                _headerCell(context, '#', width: 40),
                _headerCell(context, AppStrings.cartProduct, flex: 3),
                _headerCell(context, AppStrings.cartQuantity, flex: 1),
                _headerCell(context, AppStrings.saleCurrentStore, flex: 1),
                _headerCell(context, AppStrings.cartPrice, flex: 2),
                _headerCell(context, AppStrings.total, flex: 2),
              ],
            ),
          ),
          ...sale.items.asMap().entries.map((e) {
            final i = e.key;
            final item = e.value;
            // محاولة جلب المخزن الحالي
            final medicine = BranchDataService.getMedicine(item.medicineId);
            final currentStock = medicine?.quantity ?? 0;

            return Container(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              decoration: BoxDecoration(border: Border(top: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.3)))),
              child: Row(
                children: [
                  _itemCell(context, '${i + 1}', width: 40),
                  _itemCell(context, item.medicineName, flex: 3, isBold: true),
                  _itemCell(context, '${item.quantity}', flex: 1),
                  _itemCell(context, '$currentStock', flex: 1, color: currentStock <= 5 ? AppColors.error : AppColors.success, isBold: true),
                  _itemCell(context, formatMoney(item.unitPrice), flex: 2),
                  _itemCell(context, formatMoney(item.totalPrice), flex: 2, isBold: true),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPaymentsTable(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.success.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(AppRadius.input.r),
      ),
      child: Column(
        children: [
          Container(
            color: AppColors.success,
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Row(
              children: [
                _headerCell(context, '#', width: 40),
                  _headerCell(context, AppStrings.date, flex: 2),
                  _headerCell(context, AppStrings.invoiceNumberLabel, flex: 2),
                  _headerCell(context, AppStrings.amountPaid, flex: 2),
                  _headerCell(context, AppStrings.method, flex: 2),
                  _headerCell(context, AppStrings.status, flex: 1),
                  _headerCell(context, AppStrings.saleActions, flex: 2),
                ],
              ),
          ),
          Padding(
            padding: EdgeInsets.all(16.h),
            child: const Center(child: ReusableText(AppStrings.saleNoRecords)),
          ),
        ],
      ),
    );
  }

  Widget _headerCell(BuildContext context, String text, {double? width, int? flex}) {
    final cell = ReusableText(text, style: AppTextStyles.caption(context).copyWith(color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center);
    return flex != null ? Expanded(flex: flex, child: cell) : SizedBox(width: width?.w, child: cell);
  }

  Widget _itemCell(BuildContext context, String text, {double? width, int? flex, bool isBold = false, Color? color}) {
    final cell = ReusableText(text, style: AppTextStyles.caption(context).copyWith(fontWeight: isBold ? FontWeight.bold : null, color: color), textAlign: TextAlign.center);
    return flex != null ? Expanded(flex: flex, child: cell) : SizedBox(width: width?.w, child: cell);
  }
}

