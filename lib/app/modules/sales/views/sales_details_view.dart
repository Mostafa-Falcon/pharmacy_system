import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:pharmacy_system/app/core/models/base/correction_model.dart';
import 'package:pharmacy_system/app/core/models/sales/sale_invoice_model.dart';
import 'package:pharmacy_system/app/core/data/services/print_service.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/format_utils.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_sizes.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/correction_chain_widget.dart';
import '../bloc/sales_bloc.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/index.dart';

class SalesDetailsView extends StatelessWidget {
  const SalesDetailsView({super.key});

  SaleInvoiceModel _getSale(BuildContext context) {
    final arg = GoRouterState.of(context).extra;
    if (arg is SaleInvoiceModel) return arg;
    final id = arg is String ? arg : null;
    if (id != null) {
      final found = context.read<SalesBloc>().state.sales.where((s) => s.id == id).firstOrNull;
      if (found != null) return found;
    }
    throw Exception(SalesStrings.errorInvalidInvoice);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final sale = _getSale(context);

    return HomeShell(
      title: SalesStrings.saleInvoiceDetails,
      child: Container(
        color: scheme.surfaceContainerLow.withValues(alpha: 0.3),
        padding: EdgeInsets.all(AppSpacing.xl.w),
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: 760.w),
              decoration: BoxDecoration(
                color: scheme.surface,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(
                  color: scheme.outline.withValues(alpha: 0.35),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _Header(sale: sale),
                  const Divider(height: 1),
                  _ItemsTable(sale: sale),
                  const Divider(height: 1),
                  _Totals(sale: sale),
                  SizedBox(height: AppSpacing.md.h),
                  Padding(
                    padding: EdgeInsets.all(AppSpacing.md.w),
                    child: CorrectionChainWidget(
                      referenceType: CorrectionReferenceType.sale,
                      referenceId: sale.id,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final SaleInvoiceModel sale;
  const _Header({required this.sale});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.all(AppSpacing.lg.w),
      child: Row(
        children: [
          Icon(
            Icons.receipt_long_rounded,
            size: 26.sp,
            color: AppColors.primary,
          ),
          SizedBox(width: AppSpacing.sm.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  '${SalesStrings.invoiceLabelSales} #${sale.id.substring(0, 8)}',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w800,
                    color: scheme.onSurface,
                  ),
                ),
                SizedBox(height: 2.h),
                AppText(
                  '${sale.createdAt.day}/${sale.createdAt.month}/${sale.createdAt.year}  •  '
                  '${sale.customerName?.isEmpty ?? true ? SalesStrings.cashCustomer : sale.customerName}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Tag(
            label: _paymentLabel(sale.paymentMethod),
            color: AppColors.info,
          ),
        ],
      ),
    );
  }

  String _paymentLabel(String method) => switch (method) {
    'cash' => SalesStrings.cartPaymentCash,
    'credit' => SalesStrings.cartPaymentCredit,
    'card' => SalesStrings.cartPaymentCard,
    _ => method,
  };
}

class _ItemsTable extends StatelessWidget {
  final SaleInvoiceModel sale;
  const _ItemsTable({required this.sale});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.all(AppSpacing.lg.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...sale.items.map(
            (item) => Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.xs.h),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          item.medicineName,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: scheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        AppText(
                          '${item.unitPrice.toStringAsFixed(2)} × ${item.quantity}',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AppText(
                    item.totalPrice.toStringAsFixed(2),
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: scheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Totals extends StatelessWidget {
  final SaleInvoiceModel sale;
  const _Totals({required this.sale});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppSpacing.lg.w),
      child: Column(
        children: [
          _Row(
            label: GeneralStrings.subtotal,
            value: formatMoney(sale.totalAmount),
          ),
          if (sale.discount != null && sale.discount! > 0)
            _Row(
              label: GeneralStrings.discount,
              value: '- ${formatMoney(sale.discount!)}',
              color: AppColors.warning,
            ),
          Divider(height: AppSpacing.lg),
          _Row(
            label: GeneralStrings.total,
            value: formatMoney(sale.finalAmount),
            bold: true,
            color: AppColors.primary,
          ),
          SizedBox(height: AppSpacing.lg.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppButton(text: GeneralStrings.back, onPressed: () => context.pop(), type: ButtonType.outlined),
              AppButton(
                text: GeneralStrings.print,
                prefixIcon: Icons.print_rounded,
                onPressed: () => PrintService.printSalesInvoice(sale),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label, value;
  final bool bold;
  final Color? color;
  const _Row({
    required this.label,
    required this.value,
    this.bold = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText(
            label,
            style: TextStyle(
              fontSize: bold ? 15.sp : 13.sp,
              fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
              color: color ?? scheme.onSurfaceVariant,
            ),
          ),
          AppText(
            value,
            style: TextStyle(
              fontSize: bold ? 16.sp : 13.sp,
              fontWeight: bold ? FontWeight.w900 : FontWeight.w700,
              color: color ?? scheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}







