import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_system/app/core/models/sales/sale_invoice_model.dart';
import 'package:pharmacy_system/app/shared/ui_core.dart';

class SaleDetailsDialog extends StatelessWidget {
  final SaleInvoiceModel sale;

  const SaleDetailsDialog({super.key, required this.sale});

  static void show(BuildContext context, SaleInvoiceModel sale) {
    showDialog(
      context: context,
      builder: (ctx) => SaleDetailsDialog(sale: sale),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ReusableDialog(
      title: SalesStrings.saleDetailsTitle.replaceFirst(
        '%s',
        sale.id.substring(0, 8).toUpperCase(),
      ),
      maxWidth: 950.w,
      children: [
        // Top Info
        Wrap(
          spacing: 24.w,
          runSpacing: 12.h,
          children: [
            _infoItem(
              context,
              SalesStrings.invoiceNumberLabel,
              '#${sale.id.substring(0, 8).toUpperCase()}',
            ),
            _infoItem(
              context,
              GeneralStrings.date,
              formatDateTime(sale.createdAt),
            ),
            _infoItem(
              context,
              WidgetStrings.saleResponsibleEmployee,
              sale.createdBy,
            ), // اسم أو كود الموظف المسؤول عن البيع
            _infoItem(
              context,
              SalesStrings.customerNameLabel,
              sale.customerName ?? SalesStrings.cashCustomer,
            ),
            _infoItem(
              context,
              SalesStrings.paymentMethodLabel,
              sale.paymentMethod,
            ),
          ],
        ),
        SizedBox(height: AppSpacing.lg.h),
        // Items Table
        ReusableText(
          SalesStrings.itemsTitle,
          style: AppTextStyles.body(
            context,
          ).copyWith(fontWeight: FontWeight.bold),
        ),
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
                  _totalRow(
                    context,
                    GeneralStrings.total,
                    formatMoney(sale.totalAmount),
                  ),
                  _totalRow(
                    context,
                    GeneralStrings.discount,
                    '- ${formatMoney(sale.discount ?? 0)}',
                  ),
                  _totalRow(
                    context,
                    GeneralStrings.tax,
                    '+ ${formatMoney(sale.taxAmount ?? 0)}',
                  ),
                  _totalRow(
                    context,
                    WidgetStrings.saleShipping,
                    '+ ${formatMoney(0)}',
                  ),
                  const Divider(),
                  _totalRow(
                    context,
                    SalesStrings.finalTotal,
                    formatMoney(sale.finalAmount),
                    isBold: true,
                  ),
                  _totalRow(
                    context,
                    WidgetStrings.salePayments,
                    formatMoney(sale.paidAmount),
                  ),
                  _totalRow(
                    context,
                    WidgetStrings.saleRemaining,
                    formatMoney(sale.dueAmount),
                    color: sale.dueAmount > 0
                        ? AppColors.error
                        : AppColors.success,
                  ),
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
                  ReusableText(
                    SalesStrings.paymentInfo,
                    style: AppTextStyles.body(
                      context,
                    ).copyWith(fontWeight: FontWeight.bold),
                  ),
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
              text: SalesStrings.packing,
              prefixIcon: Icons.inventory_2_rounded,
              color: AppColors.success,
              onPressed: () {},
            ),
            SizedBox(width: 12.w),
            ReusableButton(
              text: SalesStrings.printInvoice,
              prefixIcon: Icons.print_rounded,
              color: AppColors.info,
              onPressed: () {},
            ),
            SizedBox(width: 12.w),
            ReusableButton(
              text: GeneralStrings.close,
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
        ReusableText(
          label,
          style: AppTextStyles.caption(
            context,
          ).copyWith(color: Colors.grey.shade600),
        ),
        ReusableText(
          value,
          style: AppTextStyles.body(
            context,
          ).copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _totalRow(
    BuildContext context,
    String label,
    String value, {
    bool isBold = false,
    Color? color,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ReusableText(
            label,
            style: AppTextStyles.caption(
              context,
            ).copyWith(fontWeight: isBold ? FontWeight.bold : null),
          ),
          ReusableText(
            value,
            style: AppTextStyles.caption(context).copyWith(
              fontWeight: isBold ? FontWeight.w900 : FontWeight.bold,
              color: color,
            ),
          ),
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
                _headerCell(context, SalesStrings.cartProduct, flex: 3),
                _headerCell(context, SalesStrings.cartQuantity, flex: 1),
                _headerCell(context, WidgetStrings.saleCurrentStore, flex: 1),
                _headerCell(context, SalesStrings.cartPrice, flex: 2),
                _headerCell(context, GeneralStrings.total, flex: 2),
              ],
            ),
          ),
          ...sale.items.asMap().entries.map((e) {
            final i = e.key;
            final item = e.value;
            // الحصول على رصيد الصنف الحالي
            final medicine = BranchDataService.getMedicine(item.medicineId);
            final currentStock = medicine?.quantity ?? 0;

            return Container(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: scheme.outlineVariant.withValues(alpha: 0.3),
                  ),
                ),
              ),
              child: Row(
                children: [
                  _itemCell(context, '${i + 1}', width: 40),
                  _itemCell(context, item.medicineName, flex: 3, isBold: true),
                  _itemCell(context, '${item.quantity}', flex: 1),
                  _itemCell(
                    context,
                    '$currentStock',
                    flex: 1,
                    color: currentStock <= 5
                        ? AppColors.error
                        : AppColors.success,
                    isBold: true,
                  ),
                  _itemCell(context, formatMoney(item.unitPrice), flex: 2),
                  _itemCell(
                    context,
                    formatMoney(item.totalPrice),
                    flex: 2,
                    isBold: true,
                  ),
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
                _headerCell(context, GeneralStrings.date, flex: 2),
                _headerCell(context, SalesStrings.invoiceNumberLabel, flex: 2),
                _headerCell(context, SalesStrings.amountPaid, flex: 2),
                _headerCell(context, SalesStrings.method, flex: 2),
                _headerCell(context, GeneralStrings.status, flex: 1),
                _headerCell(context, WidgetStrings.saleActions, flex: 2),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.h),
            child: const Center(
              child: ReusableText(WidgetStrings.saleNoRecords),
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerCell(
    BuildContext context,
    String text, {
    double? width,
    int? flex,
  }) {
    final cell = ReusableText(
      text,
      style: AppTextStyles.caption(
        context,
      ).copyWith(color: Colors.white, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
    return flex != null
        ? Expanded(flex: flex, child: cell)
        : SizedBox(width: width?.w, child: cell);
  }

  Widget _itemCell(
    BuildContext context,
    String text, {
    double? width,
    int? flex,
    bool isBold = false,
    Color? color,
  }) {
    final cell = ReusableText(
      text,
      style: AppTextStyles.caption(
        context,
      ).copyWith(fontWeight: isBold ? FontWeight.bold : null, color: color),
      textAlign: TextAlign.center,
    );
    return flex != null
        ? Expanded(flex: flex, child: cell)
        : SizedBox(width: width?.w, child: cell);
  }
}
