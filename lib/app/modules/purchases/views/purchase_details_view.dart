import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pharmacy_system/app/core/domain/models/base/correction_model.dart';
import 'package:pharmacy_system/app/modules/sales/models/purchase_model.dart';
import 'package:pharmacy_system/app/core/constants/app_strings.dart';
import 'package:pharmacy_system/app/core/data/services/print_service.dart';
import 'package:pharmacy_system/app/core/data/services/supplier/supplier_service.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/correction_chain_widget.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_colors.dart';
import '../../../core/utils/format_utils.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_sizes.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/index.dart';
import '../../../core/injection.dart';
import '../bloc/purchases_bloc.dart';
import '../bloc/purchases_event.dart';

class PurchaseDetailsView extends StatelessWidget {
  final PurchaseModel purchase;
  const PurchaseDetailsView({super.key, required this.purchase});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final supplier = SupplierService.getById(purchase.supplierId);

    return BlocProvider.value(
      value: sl<PurchasesBloc>(),
      child: HomeShell(
        title: 'فاتورة مشتريات',
        child: Container(
          color: scheme.surfaceContainerLow.withValues(alpha: 0.3),
          padding: EdgeInsets.all(AppSpacing.xl.w),
          child: SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 1000.w),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _buildInvoiceHeader(context, scheme, purchase),
                  SizedBox(height: AppSpacing.lg.h),
                  _buildSupplierCard(context, scheme, purchase, supplier),
                  SizedBox(height: AppSpacing.lg.h),
                  _buildItemsTable(context, scheme, purchase),
                  SizedBox(height: AppSpacing.lg.h),
                  _buildFinancialSection(context, scheme, purchase),
                  SizedBox(height: AppSpacing.lg.h),
                  if (purchase.notes != null && purchase.notes!.isNotEmpty) ...[
                    _buildNotesSection(context, scheme, purchase),
                    SizedBox(height: AppSpacing.lg.h),
                  ],
                  _buildCorrectionChain(purchase),
                  SizedBox(height: AppSpacing.xl.h),
                  _buildActionButtons(context, purchase),
                  SizedBox(height: AppSpacing.xl.h),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInvoiceHeader(BuildContext context, ColorScheme scheme, PurchaseModel purchase) {
    return AppCard(
      padding: EdgeInsets.all(AppSpacing.xl.w),
      child: Column(children: [
        Row(children: [
          Icon(Icons.receipt_long_rounded, size: AppIconSize.xl.value, color: scheme.primary),
          SizedBox(width: AppSpacing.sm.w),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ReusableText('فاتورة مشتريات', style: AppTextStyles.title(context).copyWith(fontWeight: FontWeight.bold)),
            if (purchase.receiptNumber != null)
              ReusableText('رقم الإيصال: ${purchase.receiptNumber}', style: AppTextStyles.caption(context).copyWith(color: scheme.onSurfaceVariant)),
          ]),
          const Spacer(),
          _buildStatusBadge(purchase.status),
        ]),
        SizedBox(height: AppSpacing.md.h),
        Divider(color: scheme.outlineVariant.withValues(alpha: 0.3)),
        SizedBox(height: AppSpacing.md.h),
        Row(children: [
          InfoChip(icon: Icons.calendar_today_rounded, label: 'التاريخ', value: FormatUtils.date(purchase.createdAt), color: scheme.primary),
          SizedBox(width: AppSpacing.md.w),
          InfoChip(icon: Icons.tag_rounded, label: 'رقم الفاتورة', value: '#${purchase.id.substring(0, 8)}', color: scheme.primary),
          SizedBox(width: AppSpacing.md.w),
          InfoChip(icon: Icons.person_rounded, label: 'بواسطة', value: purchase.createdBy, color: scheme.primary),
        ]),
      ]),
    );
  }

  Widget _buildSupplierCard(BuildContext context, ColorScheme scheme, PurchaseModel purchase, dynamic supplier) {
    return AppCard(
      child: Row(children: [
        Container(
          padding: EdgeInsets.all(AppSpacing.md.w),
          decoration: BoxDecoration(color: scheme.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(AppRadius.md)),
          child: Icon(Icons.store_rounded, size: AppIconSize.lg.value, color: scheme.primary),
        ),
        SizedBox(width: AppSpacing.md.w),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ReusableText(purchase.supplierName, style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.bold)),
          SizedBox(height: 4.h),
          if (supplier != null)
            Row(children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: scheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                  child: ReusableText(AppStrings.supplierType, style: AppTextStyles.caption(context).copyWith(color: scheme.primary)),
              ),
              if (purchase.supplierPhone != null) ...[
                SizedBox(width: AppSpacing.md.w),
                  ReusableText(purchase.supplierPhone!, style: AppTextStyles.body(context).copyWith(color: scheme.onSurfaceVariant)),
              ],
            ]),
        ])),
        if (purchase.sourceType != null)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(color: AppColors.info.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(AppRadius.md)),
            child: ReusableText('المصدر: ${purchase.sourceType}', style: AppTextStyles.caption(context).copyWith(color: AppColors.info, fontWeight: FontWeight.bold)),
          ),
      ]),
    );
  }

  Widget _buildItemsTable(BuildContext context, ColorScheme scheme, PurchaseModel purchase) {
    final columns = ['#', 'الصنف', 'الوحدة', 'الكمية', 'سعر الوحدة', 'الخصم', 'الضريبة', 'الإجمالي', 'الصلاحية', 'الباتش'];
    final widths = [0.03, 0.25, 0.06, 0.07, 0.10, 0.07, 0.07, 0.10, 0.09, 0.09];

    return Container(
      padding: EdgeInsets.all(AppSpacing.lg.w),
      decoration: BoxDecoration(color: scheme.surface, borderRadius: BorderRadius.circular(AppRadius.lg), border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.25))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(Icons.inventory_2_outlined, size: AppIconSize.md.value, color: scheme.primary),
          SizedBox(width: AppSpacing.sm.w),
          ReusableText('الأصناف (${purchase.items.length})', style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.bold)),
        ]),
        SizedBox(height: AppSpacing.md.h),
        _buildTableHeader(context, scheme, columns, widths),
        SizedBox(height: 4.h),
        ...List.generate(purchase.items.length, (i) => _buildTableRow(context, scheme, purchase.items[i], i + 1, widths, purchase.items.length)),
      ]),
    );
  }

  Widget _buildTableHeader(BuildContext context, ColorScheme scheme, List<String> columns, List<double> widths) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(color: scheme.primaryContainer.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(AppRadius.sm)),
      child: Row(children: List.generate(columns.length, (i) {
        return SizedBox(width: (1.0).w * widths[i], child: ReusableText(columns[i], style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.bold, color: scheme.onSurface)));
      })),
    );
  }

  Widget _buildTableRow(BuildContext context, ColorScheme scheme, PurchaseItemModel item, int index, List<double> widths, int total) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(border: index < total - 1 ? Border(bottom: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.15))) : null),
      child: Row(children: [
        SizedBox(width: (1.0).w * widths[0], child: ReusableText('$index', style: AppTextStyles.caption(context))),
        SizedBox(width: (1.0).w * widths[1], child: ReusableText(item.medicineName, style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.bold))),
        SizedBox(width: (1.0).w * widths[2], child: ReusableText(item.unitName ?? '-', style: AppTextStyles.caption(context))),
        SizedBox(width: (1.0).w * widths[3], child: ReusableText('${item.quantity}', style: AppTextStyles.caption(context))),
        SizedBox(width: (1.0).w * widths[4], child: ReusableText(FormatUtils.currency(item.unitPrice), style: AppTextStyles.caption(context))),
        SizedBox(width: (1.0).w * widths[5], child: ReusableText(item.discount != null && item.discount! > 0 ? '-${FormatUtils.currency(item.discount!)}' : '-', style: AppTextStyles.caption(context).copyWith(color: item.discount != null && item.discount! > 0 ? AppColors.warning : null))),
        SizedBox(width: (1.0).w * widths[6], child: ReusableText(item.taxAmount != null && item.taxAmount! > 0 ? FormatUtils.currency(item.taxAmount!) : '-', style: AppTextStyles.caption(context).copyWith(color: item.taxAmount != null && item.taxAmount! > 0 ? AppColors.info : null))),
        SizedBox(width: (1.0).w * widths[7], child: ReusableText(FormatUtils.currency(item.totalPrice), style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.bold, color: scheme.primary))),
        SizedBox(width: (1.0).w * widths[8], child: ReusableText(item.expiryDate != null ? FormatUtils.date(item.expiryDate!) : '-', style: AppTextStyles.caption(context).copyWith(color: item.expiryDate != null && item.expiryDate!.isBefore(DateTime.now()) ? AppColors.error : null))),
        SizedBox(width: (1.0).w * widths[9], child: ReusableText(item.batchNumber ?? '-', style: AppTextStyles.caption(context))),
      ]),
    );
  }

  Widget _buildFinancialSection(BuildContext context, ColorScheme scheme, PurchaseModel purchase) {
    return AppCard(
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(flex: 3, child: _buildPaymentInfo(context, scheme, purchase)),
        SizedBox(width: AppSpacing.xl.w),
        Container(width: 1, height: 200, color: scheme.outlineVariant.withValues(alpha: 0.2)),
        SizedBox(width: AppSpacing.xl.w),
        Expanded(flex: 2, child: _buildTotalsBreakdown(context, scheme, purchase)),
      ]),
    );
  }

  Widget _buildPaymentInfo(BuildContext context, ColorScheme scheme, PurchaseModel purchase) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Icon(Icons.payment_rounded, size: AppIconSize.md.value, color: scheme.primary), SizedBox(width: AppSpacing.xs.w), ReusableText('معلومات الدفع', style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.bold))]),
      SizedBox(height: AppSpacing.md.h),
      _financeRow('طريقة الدفع', _getPaymentLabel(purchase.paymentMethod)),
      if (purchase.paidAmount != null) _financeRow('المدفوع', FormatUtils.currency(purchase.paidAmount!)),
      if (purchase.remainingAmount > 0) _financeRow('المتبقي', FormatUtils.currency(purchase.remainingAmount), valueColor: AppColors.error),
      if (purchase.paymentAccountName != null) _financeRow('حساب الدفع', purchase.paymentAccountName!),
      _financeRow('الحالة', purchase.status == 'completed' ? 'مكتملة' : purchase.status == 'cancelled' ? 'ملغاة' : 'مسودة'),
    ]);
  }

  Widget _buildTotalsBreakdown(BuildContext context, ColorScheme scheme, PurchaseModel purchase) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Icon(Icons.calculate_rounded, size: AppIconSize.md.value, color: scheme.primary), SizedBox(width: AppSpacing.xs.w), ReusableText('إجماليات الفاتورة', style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.bold))]),
      SizedBox(height: AppSpacing.md.h),
      _financeRow('المجموع الفرعي', FormatUtils.currency(purchase.totalAmount)),
      if (purchase.invoiceDiscountAmount != null && purchase.invoiceDiscountAmount! > 0)
        _financeRow('خصم الفاتورة (${purchase.invoiceDiscountType == '%' ? '${purchase.invoiceDiscountValue?.toStringAsFixed(1) ?? ''}%' : FormatUtils.currency(purchase.invoiceDiscountValue ?? 0)})', '-${FormatUtils.currency(purchase.invoiceDiscountAmount!)}', valueColor: AppColors.warning),
      if (purchase.invoiceTaxAmount != null && purchase.invoiceTaxAmount! > 0)
        _financeRow('ضريبة الفاتورة (${purchase.invoiceTaxType == '%' ? '${purchase.invoiceTaxValue?.toStringAsFixed(1) ?? ''}%' : FormatUtils.currency(purchase.invoiceTaxValue ?? 0)})', FormatUtils.currency(purchase.invoiceTaxAmount!), valueColor: AppColors.info),
      if ((purchase.shippingAmount ?? 0) > 0) _financeRow('الشحن', FormatUtils.currency(purchase.shippingAmount!)),
      if ((purchase.deliveryAmount ?? 0) > 0) _financeRow('التوصيل', FormatUtils.currency(purchase.deliveryAmount!)),
      Divider(color: scheme.outlineVariant.withValues(alpha: 0.3)),
      _financeRow('الإجمالي النهائي', FormatUtils.currency(purchase.finalAmount), valueColor: scheme.primary, bold: true, fontSize: 14),
    ]);
  }

  Widget _financeRow(String label, String value, {Color? valueColor, bool bold = false, double fontSize = 12}) {
    return TotalsRow(label: label, value: value, color: valueColor, bold: bold, fontSize: fontSize);
  }

  Widget _buildNotesSection(BuildContext context, ColorScheme scheme, PurchaseModel purchase) {
    return AppCard(child: Row(children: [
      Icon(Icons.notes_rounded, size: AppIconSize.md.value, color: AppColors.warning), SizedBox(width: AppSpacing.sm.w),
      ReusableText('ملاحظات:', style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.bold)), SizedBox(width: AppSpacing.sm.w),
      Expanded(child: ReusableText(purchase.notes!, style: AppTextStyles.body(context))),
    ]));
  }

  Widget _buildCorrectionChain(PurchaseModel purchase) {
    return CorrectionChainWidget(referenceType: CorrectionReferenceType.purchase, referenceId: purchase.id);
  }

  Widget _buildActionButtons(BuildContext context, PurchaseModel purchase) {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      ReusableButton(text: 'عودة', onPressed: () => Navigator.pop(context), type: ButtonType.outlined),
      SizedBox(width: AppSpacing.md.w),
      ReusableButton(text: 'طباعة', prefixIcon: Icons.print_rounded, onPressed: () async {
        final shouldPrint = await showDialog<bool>(
          context: context,
          builder: (context) => ReusableDialog(
          title: 'طباعة الفاتورة', headerIcon: const Icon(Icons.print_rounded),
          children: [
            ReusableText('هل تريد طباعة فاتورة المشتريات؟', style: AppTextStyles.body(context)),
            SizedBox(height: 16.h),
            DialogActions(
              cancelText: 'لا',
              confirmText: 'طباعة',
              onCancel: () => Navigator.pop(context, false),
              onConfirm: () => Navigator.pop(context, true),
            ),
          ],
        ));
        if (shouldPrint == true) PrintService.printPurchaseInvoice(purchase);
      }, type: ButtonType.outlined),
      SizedBox(width: AppSpacing.md.w),
      ReusableButton(text: 'إلغاء الفاتورة', prefixIcon: Icons.cancel_outlined, onPressed: () {
        ConfirmDeleteDialog.show(
          context,
          title: 'تأكيد الإلغاء', message: 'هل أنت متأكد من إلغاء فاتورة المشتريات هذه؟',
          confirmText: 'تأكيد الإلغاء',
          onConfirm: () => context.read<PurchasesBloc>().add(VoidPurchase(purchase.id)),
        );
      }),
    ]);
  }

  String _getPaymentLabel(String method) => switch (method) {
    'cash' => 'نقداً', 'credit' => 'آجل', 'card' => 'بطاقة', _ => method,
  };

  Widget _buildStatusBadge(String status) {
    final (color, label) = switch (status) {
      'completed' => (AppColors.success, 'مكتملة'),
      'cancelled' => (AppColors.error, 'ملغاة'),
      _ => (AppColors.warning, 'مسودة'),
    };
    return StatusBadge(label: label, color: color, icon: status == 'completed' ? Icons.check_circle_rounded : Icons.cancel_rounded);
  }
}



