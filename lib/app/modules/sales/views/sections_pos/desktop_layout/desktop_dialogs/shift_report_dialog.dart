import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:collection/collection.dart';

import 'package:pharmacy_system/app/core/constants/app_strings.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/index.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_colors.dart';
import 'package:pharmacy_system/app/core/data/services/sales/cashier_shift_service.dart';
import 'package:pharmacy_system/app/core/data/services/admin/branch_data_service.dart';
import 'package:pharmacy_system/app/core/data/services/print_service.dart';
import 'package:pharmacy_system/app/modules/contacts/models/customer_ledger_model.dart';
import 'package:pharmacy_system/app/core/data/repositories/customer_ledger_repository.dart';
import 'package:pharmacy_system/app/core/injection.dart';
import 'package:pharmacy_system/app/routes/app_routes.dart';
import 'package:pharmacy_system/app/modules/sales/bloc/pos_bloc.dart';

import 'package:pharmacy_system/app/core/presentation/theme/app_sizes.dart';

class ShiftReportDialog {
  static Future<void> showSessionDetails(
    BuildContext context,
    PosState state,
  ) async {
    final shift = state.currentShift;
    if (shift == null) {
      AppSnackbar.warning(AppStrings.noOpenShiftWarning);
      return;
    }

    final data = await _calculateShiftData(state);
    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (context) => ReusableDialog(
        headerIcon: const Icon(Icons.info_outline_rounded),
        title: AppStrings.sessionDetailsTitle,
        maxWidth: 800,
        footerActions: [
          ReusableButton(
            text: AppStrings.printReportLabel,
            prefixIcon: Icons.print_rounded,
            type: ButtonType.outlined,
            onPressed: () {
              PrintService.printShiftReport(
                openedAt: shift.openedAt,
                closedAt: shift.closedAt,
                totalSales: data.totalSales,
                totalReturns: data.totalReturns,
                netSales: data.netSales,
                salesCount: data.salesCount,
                expectedCash: data.expectedCashInDrawer,
                actualCash: data.expectedCashInDrawer, // In view mode, we use expected as default
                difference: 0,
              );
            },
          ),
          ReusableButton(
            text: AppStrings.close,
            onPressed: () => Navigator.pop(context),
          ),
        ],
        children: [
          SizedBox(
            height: 500.h,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: _buildReportBody(context, state, data),
            ),
          ),
        ],
      ),
    );
  }

  static Future<void> showCloseShift(BuildContext context, PosBloc bloc) async {
    final shift = bloc.state.currentShift;
    if (shift == null) {
      AppSnackbar.warning(AppStrings.noOpenShiftEndWarning);
      return;
    }
    final data = await _calculateShiftData(bloc.state);
    if (!context.mounted) return;

    final countedCashController = TextEditingController();
    final notesController = TextEditingController();

    countedCashController.text = data.expectedCashInDrawer.toStringAsFixed(2);

    showDialog(
      context: context,
      builder: (context) => ReusableDialog(
        headerIcon: const Icon(Icons.exit_to_app_rounded),
        headerIconColor: AppColors.error,
        title: AppStrings.endSessionTitle,
        maxWidth: 800,
        footerActions: [
          ReusableButton(
            text: AppStrings.cancel,
            type: ButtonType.text,
            onPressed: () => Navigator.pop(context),
          ),
          ReusableButton(
            text: AppStrings.endSessionNowLabel,
            color: AppColors.error,
            onPressed: () async {
              final amt = double.tryParse(countedCashController.text);
              if (amt == null || amt < 0) {
                AppSnackbar.error(AppStrings.enterValidAmountMsg);
                return;
              }

              try {
                await CashierShiftService.closeShift(
                  shiftId: shift.id,
                  countedCash: amt,
                  notes: notesController.text.trim().isEmpty ? null : notesController.text.trim(),
                );
                bloc.add(const PosRefreshShift());
                if (!context.mounted) return;
                Navigator.pop(context);
                context.go(Routes.LOGIN);
                AppSnackbar.success(AppStrings.sessionClosedSuccessMsg);
              } catch (e) {
                AppSnackbar.error(e.toString());
              }
            },
          ),
        ],
        children: [
          SizedBox(
            height: 550.h,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  _buildReportBody(context, bloc.state, data),
                  const Divider(),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ReusableInput(
                            controller: countedCashController,
                            label: AppStrings.actualCashFieldLabel,
                            prefixIcon: const Icon(Icons.payments_rounded),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: ReusableInput(
                            controller: notesController,
                            label: AppStrings.closingNoteFieldLabel,
                            maxLines: 2,
                          ),
                        ),
                      ],
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

  static Widget _buildReportBody(
    BuildContext context,
    PosState state,
    _ShiftData data,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            _cardStat(context, AppStrings.invoiceCount, '${data.salesCount}', Colors.blue),
            SizedBox(width: 8.w),
            _cardStat(context, AppStrings.shiftTotalSales, '${data.totalSales.toStringAsFixed(2)} ${AppStrings.currency}', Colors.green),
            SizedBox(width: 8.w),
            _cardStat(context, AppStrings.returnsLabel, '-${data.totalReturns.toStringAsFixed(2)} ${AppStrings.currency}', Colors.red),
            SizedBox(width: 8.w),
            _cardStat(context, AppStrings.netAmount, '${data.netSales.toStringAsFixed(2)} ${AppStrings.currency}', Colors.amber),
          ],
        ),
        SizedBox(height: 20.h),

        const SectionHeader(title: AppStrings.paymentSummaryTitle, icon: Icons.payments_outlined),
        SizedBox(height: 8.h),
        AppCard(
          padding: EdgeInsets.zero,
          child: Table(
            border: TableBorder.symmetric(inside: BorderSide(color: Colors.grey.shade100)),
            children: [
              _tableHeaderRow(context, [AppStrings.paymentMethodLabel, AppStrings.salesColumnHeader, AppStrings.expenseColumnHeader]),
              _tableDataRow(context, AppStrings.openingStockTitle, '${data.openingCash.toStringAsFixed(2)} ${AppStrings.currency}', '--'),
              _tableDataRow(context, AppStrings.paymentCashRow, '${data.cashSales.toStringAsFixed(2)} ${AppStrings.currency}', '0.00 ${AppStrings.currency}'),
              _tableDataRow(context, AppStrings.paymentCardRow, '${data.cardSales.toStringAsFixed(2)} ${AppStrings.currency}', '0.00 ${AppStrings.currency}'),
              _tableDataRow(context, AppStrings.creditSaleRow, '${data.creditSales.toStringAsFixed(2)} ${AppStrings.currency}', '0.00 ${AppStrings.currency}'),
              _tableDataRow(context, AppStrings.mixedPaymentRow, '${data.mixedSales.toStringAsFixed(2)} ${AppStrings.currency}', '0.00 ${AppStrings.currency}'),
              _tableTotalRow(context, AppStrings.expectedDrawerTotalRow, '${data.expectedCashInDrawer.toStringAsFixed(2)} ${AppStrings.currency}', bg: Colors.green.withValues(alpha: 0.05), textColor: Colors.green.shade900),
            ],
          ),
        ),
        SizedBox(height: 24.h),

        const SectionHeader(title: AppStrings.soldItemsSectionTitle, icon: Icons.medication_rounded),
        SizedBox(height: 8.h),
        AppCard(
          padding: EdgeInsets.zero,
          child: Table(
            border: TableBorder.symmetric(inside: BorderSide(color: Colors.grey.shade100)),
            columnWidths: const {
              0: FlexColumnWidth(0.8),
              1: FlexColumnWidth(4),
              2: FlexColumnWidth(1.5),
              3: FlexColumnWidth(2),
            },
            children: [
              _tableHeaderRow(context, ['#', AppStrings.itemNameLabel, AppStrings.cartQuantity, AppStrings.amount]),
              if (data.soldItems.isEmpty)
                _tableEmptyRow(4, AppStrings.noSalesInShiftMsg)
              else
                ...data.soldItems.asMap().entries.map((e) {
                  final idx = e.key;
                  final item = e.value;
                  return _tableDataRow4(
                    context,
                    '${idx + 1}',
                    item['name'],
                    '${item['quantity']}',
                    '${(item['total'] as double).toStringAsFixed(2)} ${AppStrings.currency}',
                  );
                }),
            ],
          ),
        ),
        SizedBox(height: 24.h),

        const SectionHeader(title: AppStrings.drawerDetailsSectionTitle, icon: Icons.account_balance_wallet_outlined),
        SizedBox(height: 8.h),
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              _tableLedgerRow(context, AppStrings.openingBalanceRow, '${data.openingCash.toStringAsFixed(2)} ${AppStrings.currency}', Colors.green.shade700),
              _tableLedgerRow(context, AppStrings.cashSalesRow, '${data.cashSales.toStringAsFixed(2)} ${AppStrings.currency}', Colors.green.shade700),
              _tableLedgerRow(context, AppStrings.customerCollectionsRow, '${data.customerPayments.toStringAsFixed(2)} ${AppStrings.currency}', Colors.green.shade700),
              _tableLedgerRow(context, AppStrings.cashExpensesRow, '0.00 ${AppStrings.currency}', Colors.red.shade700),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(AppRadius.lg.r), bottomRight: Radius.circular(AppRadius.lg.r)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ReusableText(AppStrings.finalExpectedTotalRow, style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.bold, color: Colors.blue.shade900)),
                    ReusableText('${data.expectedCashInDrawer.toStringAsFixed(2)} ${AppStrings.currency}', style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.w900, color: Colors.blue.shade900)),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
      ],
    );
  }

  static Widget _cardStat(BuildContext context, String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(AppRadius.button.r),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            ReusableText(label, style: AppTextStyles.caption(context).copyWith(color: color, fontWeight: FontWeight.bold)),
            SizedBox(height: 4.h),
            ReusableText(value, style: AppTextStyles.body(context).copyWith(color: color, fontWeight: FontWeight.w900)),
          ],
        ),
      ),
    );
  }

  static TableRow _tableHeaderRow(BuildContext context, List<String> cells) {
    return TableRow(
      decoration: BoxDecoration(color: Colors.grey.shade50),
      children: cells.map((c) => Padding(
        padding: EdgeInsets.all(10.w),
        child: ReusableText(c, style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
      )).toList(),
    );
  }

  static TableRow _tableDataRow(BuildContext context, String col1, String col2, String col3) {
    return TableRow(
      children: [
        Padding(padding: EdgeInsets.all(10.w), child: ReusableText(col1, style: AppTextStyles.caption(context))),
        Padding(padding: EdgeInsets.all(10.w), child: ReusableText(col2, style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
        Padding(padding: EdgeInsets.all(10.w), child: ReusableText(col3, style: AppTextStyles.caption(context), textAlign: TextAlign.center)),
      ],
    );
  }

  static TableRow _tableDataRow4(BuildContext context, String col1, String col2, String col3, String col4) {
    return TableRow(
      children: [
        Padding(padding: EdgeInsets.all(10.w), child: ReusableText(col1, style: AppTextStyles.caption(context), textAlign: TextAlign.center)),
        Padding(padding: EdgeInsets.all(10.w), child: ReusableText(col2, style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.w600))),
        Padding(padding: EdgeInsets.all(10.w), child: ReusableText(col3, style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
        Padding(padding: EdgeInsets.all(10.w), child: ReusableText(col4, style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.bold, color: Colors.blue.shade800), textAlign: TextAlign.center)),
      ],
    );
  }

  static TableRow _tableEmptyRow(int cols, String text) {
    return TableRow(
      children: List.generate(cols, (i) => i == 1
        ? Padding(padding: EdgeInsets.all(20.w), child: ReusableText(text, style: const TextStyle(color: Colors.grey)))
        : const SizedBox()),
    );
  }

  static TableRow _tableTotalRow(BuildContext context, String label, String value, {required Color bg, required Color textColor}) {
    return TableRow(
      decoration: BoxDecoration(color: bg),
      children: [
        Padding(padding: EdgeInsets.all(10.w), child: ReusableText(label, style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.bold, color: textColor))),
        Padding(padding: EdgeInsets.all(10.w), child: ReusableText(value, style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.w900, color: textColor), textAlign: TextAlign.center)),
        const SizedBox(),
      ],
    );
  }

  static Widget _tableLedgerRow(BuildContext context, String label, String value, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ReusableText(label, style: AppTextStyles.caption(context)),
          ReusableText(value, style: AppTextStyles.caption(context).copyWith(color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  static Future<_ShiftData> _calculateShiftData(PosState state) async {
    final shift = state.currentShift!;
    final branchId = shift.branchId;

    final sales = BranchDataService.getSales(branchId: branchId)
        .where((s) => !s.isDeleted && s.createdAt.isAfter(shift.openedAt) &&
            (shift.closedAt == null || s.createdAt.isBefore(shift.closedAt!)))
        .toList();

    final returns = BranchDataService.getReturns(branchId: branchId)
        .where((r) => !r.isDeleted && r.createdAt.isAfter(shift.openedAt) &&
            (shift.closedAt == null || r.createdAt.isBefore(shift.closedAt!)))
        .toList();

    double customerPayments = 0;
    try {
      final repo = sl<CustomerLedgerRepository>();
      final all = await repo.getByBranch(branchId);
      customerPayments = all
          .where((l) => l.type == CustomerLedgerEntryType.customerPayment &&
              l.entryDate.isAfter(shift.openedAt) && (shift.closedAt == null || l.entryDate.isBefore(shift.closedAt!)))
          .fold<double>(0.0, (sum, l) => sum + l.credit);
    } catch (_) {}

    final salesCount = sales.length;
    final totalSales = sales.fold<double>(0.0, (sum, s) => sum + s.finalAmount);
    final totalReturns = returns.fold<double>(0.0, (sum, r) => sum + r.totalAmount);
    final netSales = totalSales - totalReturns;

    final cashSales = sales.where((s) => s.paymentMethod == 'cash' || s.paymentMethod == 'mixed').fold<double>(0.0, (sum, s) => sum + s.finalAmount);
    final cardSales = sales.where((s) => s.paymentMethod == 'card').fold<double>(0.0, (sum, s) => sum + s.finalAmount);
    final bankSales = sales.where((s) => s.paymentMethod == 'bank').fold<double>(0.0, (sum, s) => sum + s.finalAmount);
    final creditSales = sales.where((s) => s.paymentMethod == 'credit').fold<double>(0.0, (sum, s) => sum + s.finalAmount);
    final mixedSales = sales.where((s) => s.paymentMethod == 'mixed').fold<double>(0.0, (sum, s) => sum + s.finalAmount);

    final expectedCashInDrawer = shift.openingCash + cashSales + customerPayments;

    final soldItemsMap = <String, Map<String, dynamic>>{};
    for (final sale in sales) {
      for (final item in sale.items) {
        final med = state.medicines.firstWhereOrNull((m) => m.id == item.medicineId);
        if (soldItemsMap.containsKey(item.medicineId)) {
          soldItemsMap[item.medicineId]!['quantity'] += item.quantity;
          soldItemsMap[item.medicineId]!['total'] += item.totalPrice;
        } else {
          soldItemsMap[item.medicineId] = {
            'name': med?.name ?? item.medicineName,
            'barcode': med?.barcodes.firstOrNull ?? '--',
            'quantity': item.quantity,
            'total': item.totalPrice,
          };
        }
      }
    }
    
    return _ShiftData(
      salesCount: salesCount, totalSales: totalSales, totalReturns: totalReturns, netSales: netSales,
      openingCash: shift.openingCash, cashSales: cashSales, cardSales: cardSales, bankSales: bankSales,
      creditSales: creditSales, mixedSales: mixedSales, expectedCashInDrawer: expectedCashInDrawer,
      customerPayments: customerPayments, soldItems: soldItemsMap.values.toList(),
      totalQuantity: soldItemsMap.values.fold(0, (sum, item) => sum + (item['quantity'] as int)),
    );
  }
}

class _ShiftData {
  final int salesCount;
  final double totalSales;
  final double totalReturns;
  final double netSales;
  final double openingCash;
  final double cashSales;
  final double cardSales;
  final double bankSales;
  final double creditSales;
  final double mixedSales;
  final double expectedCashInDrawer;
  final double customerPayments;
  final List<Map<String, dynamic>> soldItems;
  final int totalQuantity;

  _ShiftData({
    required this.salesCount, required this.totalSales, required this.totalReturns, required this.netSales,
    required this.openingCash, required this.cashSales, required this.cardSales, required this.bankSales,
    required this.creditSales, required this.mixedSales, required this.expectedCashInDrawer,
    required this.customerPayments, required this.soldItems, required this.totalQuantity,
  });
}

