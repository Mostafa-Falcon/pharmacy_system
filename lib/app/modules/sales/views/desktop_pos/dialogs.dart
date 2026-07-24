import 'package:flutter/material.dart';
import 'package:pharmacy_system/app/core/models/inventory/medicine_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collection/collection.dart';

import '../../../../core/constants/app_strings.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_colors.dart';
import '../../../../core/extensions/string_ext.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_sizes.dart';
import '../../../../core/utils/format_utils.dart';
import '../package:pharmacy_system/app/modules/sales/models/pos_cart_line.dart';
import '../../bloc/pos_bloc.dart';
import 'package:pharmacy_system/app/core/data/services/print_service.dart';
import 'package:pharmacy_system/app/core/data/services/sales/quote_service.dart';
import 'package:pharmacy_system/app/core/data/services/admin/branch_data_service.dart';
import 'package:pharmacy_system/app/core/data/services/inventory/promotion_service.dart';
import 'package:pharmacy_system/app/core/data/services/inventory/damaged_stock_service.dart';
import 'package:pharmacy_system/app/core/data/services/inventory/opening_stock_service.dart';
import 'package:pharmacy_system/app/core/models/inventory/promotion_model.dart';
import 'package:pharmacy_system/app/core/models/inventory/damaged_stock_model.dart';
import 'package:pharmacy_system/app/core/models/inventory/opening_stock_model.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';

// Modular Sub-Dialogs
import 'dialogs/shift_report_dialog.dart';
import 'dialogs/edit_cart_line_dialog.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/index.dart';

class PosDiscountResult {
  final double value;
  final bool isPercentage;
  const PosDiscountResult(this.value, {this.isPercentage = false});
}

class PosDiscountDialog {
  static Future<void> show(
    BuildContext context, {
    required double initialValue,
    bool isTax = false,
    required Function(PosDiscountResult) onApply,
  }) async {
    final ctrl = TextEditingController(text: initialValue > 0 ? initialValue.toString() : '');
    bool isPercent = false;

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(isTax ? SalesStrings.addTaxTitle : SalesStrings.addInvoiceDiscountTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: ctrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: isTax ? SalesStrings.taxAmountFieldLabel : SalesStrings.discountAmountFieldLabel,
                  suffixText: isPercent ? '%' : GeneralStrings.currency,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  ChoiceChip(
                    label: const Text(SalesStrings.fixedAmountChipLabel),
                    selected: !isPercent,
                    onSelected: (v) => setState(() => isPercent = !v),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text(SalesStrings.cartDiscountPercent),
                    selected: isPercent,
                    onSelected: (v) => setState(() => isPercent = v),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text(GeneralStrings.cancel)),
            FilledButton(
              onPressed: () {
                final val = double.tryParse(ctrl.text) ?? 0.0;
                onApply(PosDiscountResult(val, isPercentage: isPercent));
                Navigator.of(ctx).pop();
              },
              child: const Text(GeneralStrings.apply),
            ),
          ],
        ),
      ),
    );
  }
}


class DesktopDialogs {
  static void showItemInquiryDialog(BuildContext context, PosBloc bloc, {MedicineModel? preSelected}) {
    showDialog(
      context: context,
      builder: (context) => AppDialog(
        headerIcon: const Icon(Icons.search_rounded),
        headerIconColor: Theme.of(context).colorScheme.primary,
        title: SalesStrings.posItemInquiry,
        maxWidth: 700,
        children: [
          SizedBox(
            height: 500.h,
            child: Column(
              children: [
                MedicineSearchField(
                  onSelected: (m) => bloc.add(PosAddMedicine(m)),
                ),
                SizedBox(height: 12.h),
                Expanded(
                  child: BlocBuilder<PosBloc, PosState>(
                    bloc: bloc,
                    builder: (context, state) {
                      final items = preSelected != null ? [preSelected] : state.filteredMedicines;
                      if (items.isEmpty) {
                        return const AppStateView.empty(
                          icon: Icons.search_off_rounded, 
                          title: SalesStrings.noMatchingSearchResults,
                        );
                      }
                      return ListView.separated(
                        itemCount: items.length,
                        separatorBuilder: (context, index) => Divider(height: 1, color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1)),
                        itemBuilder: (context, i) {
                          final m = items[i];
                          return ListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                            title: AppText(m.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: AppText(
                              '${GeneralStrings.balance}: ${m.quantity} | ${SalesStrings.cartPrice}: ${FormatUtils.currency(m.sellPrice)}',
                              style: AppTextStyles.caption(context).copyWith(color: AppColors.textSecondaryOf(context)),
                            ),
                            trailing: AppButton(
                              text: SalesStrings.addToCart,
                              onPressed: () {
                                bloc.add(PosAddMedicine(m));
                                Navigator.pop(context);
                              },
                              type: ButtonType.tonal,
                              height: 32.h,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static void showSessionDetailsDialog(BuildContext context, PosBloc bloc) {
    final state = bloc.state;
    ShiftReportDialog.showSessionDetails(context, state);
  }

  static void showCloseShiftDialog(BuildContext context, PosBloc bloc) {
    ShiftReportDialog.showCloseShift(context, bloc);
  }

  static void showEditCartLineDialog(
    BuildContext context,
    PosBloc bloc,
    PosCartLine line,
  ) {
    EditCartLineDialog.show(context, bloc, line);
  }

  static void showExpenseDialog(BuildContext context, PosBloc bloc) {
    final amountCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final List<String> commonExpenses = SalesStrings.quickExpenseOptions;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AppDialog(
          headerIcon: const Icon(Icons.add_card_rounded),
          headerIconColor: AppColors.error,
          title: SalesStrings.addExpensesFromCashier,
          footerActions: [
            DialogActions(
              confirmText: SalesStrings.recordExpense,
              confirmType: ButtonType.error,
              onConfirm: () async {
                final amount = double.tryParse(amountCtrl.text);
                final desc = descCtrl.text.trim();
                if (desc.isEmpty || amount == null || amount <= 0) {
                  AppSnackbar.error(SalesStrings.invalidExpenseInput);
                  return;
                }
                bloc.add(PosAddExpense(desc, amount));
                Navigator.of(context).pop();
              },
            ),
          ],
          children: [
            AppText(
              SalesStrings.quickExpensesLabel,
              style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: commonExpenses.map((cat) => ActionChip(
                label: AppText(cat, style: AppTextStyles.caption(context)),
                onPressed: () => setState(() => descCtrl.text = cat),
                backgroundColor: descCtrl.text == cat ? AppColors.error.withValues(alpha: 0.1) : null,
              )).toList(),
            ),
            SizedBox(height: 16.h),
            AppInput(
              label: SalesStrings.expenseDescriptionLabel,
              hint: SalesStrings.expenseDescriptionHint,
              controller: descCtrl,
              textDirection: TextDirection.rtl,
              onChanged: (v) => setState(() {}),
            ),
            SizedBox(height: AppSpacing.sm.h),
            AppInput(
              label: SalesStrings.expenseAmountLabel,
              hint: '0.00',
              controller: amountCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              prefixIcon: const Icon(Icons.payments_rounded, size: 18),
            ),
          ],
        ),
      ),
    );
  }

  static void showQuickItemsDialog(BuildContext context, PosBloc bloc) {
    final state = bloc.state;
    final scheme = Theme.of(context).colorScheme;
    final topItems = state.medicines
        .where((m) => m.quantity > 0)
        .take(24)
        .toList();
    showDialog(
      context: context,
      builder: (context) => AppDialog(
        headerIcon: const Icon(Icons.bolt_rounded),
        headerIconColor: AppColors.warning,
        title: SalesStrings.topRequestedItems,
        maxWidth: 600,
        children: [
          SizedBox(
            height: 400.h,
            child: topItems.isEmpty
                ? const AppStateView.empty(
                    icon: Icons.inventory_2_outlined,
                    title: SalesStrings.noItemsAvailable,
                  )
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1,
                        ),
                    itemCount: topItems.length,
                    itemBuilder: (context, i) => AppCard(
                      padding: EdgeInsets.zero,
                      onTap: () {
                        bloc.add(PosAddMedicine(topItems[i]));
                        Navigator.of(context).pop();
                      },
                      backgroundColor: AppColors.warning.withValues(alpha: 0.05),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.medication_rounded, color: AppColors.warning, size: AppIconSize.lg.value),
                          SizedBox(height: 6.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            child: AppText(
                              topItems[i].name,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(height: 2.h),
                          AppText(
                            FormatUtils.currency(topItems[i].sellPrice),
                            style: AppTextStyles.caption(context).copyWith(color: scheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  static void showSuspendedSalesDialog(BuildContext context, PosBloc bloc) {
    final suspended = bloc.state.suspendedSales;
    showDialog(
      context: context,
      builder: (context) => AppDialog(
        headerIcon: const Icon(Icons.pause_circle_outline_rounded),
        headerIconColor: AppColors.info,
        title: '${SalesStrings.posSuspendedSales} (${SalesStrings.drafts})',
        maxWidth: 600,
        children: [
              suspended.isEmpty
                  ? const AppStateView.empty(
                      icon: Icons.pause_circle_outline_rounded,
                      title: SalesStrings.noPendingSales,
                      subtitle: SalesStrings.emptySalesSubtitle,
                    )

              : SizedBox(
                  height: 400.h,
                  child: ListView.separated(
                    itemCount: suspended.length,
                    separatorBuilder: (_, index) => SizedBox(height: 8.h),
                    itemBuilder: (context, i) {
                      final s = suspended[i];
                      final total = (s['total'] as num?)?.toDouble() ?? 0;
                      final date = s['created_at'] as String? ?? '';
                      return AppCard(
                        padding: EdgeInsets.zero,
                        child: ListTile(
                          leading: Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(color: AppColors.info.withValues(alpha: 0.1), shape: BoxShape.circle),
                            child: const Icon(Icons.receipt_long_rounded, color: AppColors.info, size: 20),
                          ),
                          title: AppText(FormatUtils.currency(total), style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: AppText(date, variant: AppTextVariant.caption),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.play_circle_fill_rounded, color: AppColors.success),
                                 tooltip: SalesStrings.resumeSale,
                                 onPressed: () {

                                  bloc.add(PosResumeSale(s));
                                  Navigator.of(context).pop();
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
                                 tooltip: GeneralStrings.delete,
                                 onPressed: () {

                                  bloc.add(PosDeleteSuspendedSale(s['id'] as String));
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }

  static void showRecentSalesDialog(BuildContext context, PosBloc bloc) {
    showDialog(
      context: context,
      builder: (context) => BlocProvider.value(
        value: bloc,
        child: const RecentOperationsDialog(),
      ),
    );
  }

  static void showPaymentDialog(
    BuildContext context,
    PosBloc bloc, {
    required bool isCustomer,
  }) {
    final amountCtrl = TextEditingController();
    final notesCtrl = TextEditingController();

    final state = bloc.state;
    final selectedId = isCustomer
        ? state.selectedCustomerId
        : state.selectedSupplierId;

    if (selectedId == null) {
      AppSnackbar.warning(
        isCustomer
            ? SalesStrings.selectCustomerFirst
            : SalesStrings.selectSupplierFirst,
      );
      return;
    }

    final name = isCustomer
        ? (state.customers.firstWhereOrNull((c) => c.id == selectedId)?.name ?? '')
        : (state.suppliers.firstWhereOrNull((s) => s.id == selectedId)?.name ?? '');

    showDialog(
      context: context,
      builder: (context) => AppDialog(
        headerIcon: Icon(isCustomer ? Icons.payments_rounded : Icons.account_balance_wallet_rounded),
        headerIconColor: AppColors.success,
        title: '${isCustomer ? SalesStrings.customerPaymentTitle : SalesStrings.supplierPaymentTitle}: $name',
        footerActions: [
          DialogActions(
            confirmText: SalesStrings.recordPayment,
            onConfirm: () async {
              final amount = double.tryParse(amountCtrl.text);
              if (amount == null || amount <= 0) {
                AppSnackbar.error(CustomersStrings.invalidAmount);
                return;
              }
              if (isCustomer) {
                bloc.add(PosRecordCustomerPayment(selectedId, amount, notes: notesCtrl.text.trim().nullIfEmpty));
              } else {
                bloc.add(PosRecordSupplierPayment(selectedId, amount, notes: notesCtrl.text.trim().nullIfEmpty));
              }
              Navigator.of(context).pop();
            },
          ),
        ],
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(color: AppColors.info.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.info),
                SizedBox(width: 8.w),
                AppText(
                  SalesStrings.currentBalanceFormat.replaceFirst('%s', FormatUtils.currency(isCustomer ? state.customerBalance : state.supplierBalance)),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          AppInput(
            label: '${GeneralStrings.amount} *',
            controller: amountCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            prefixIcon: const Icon(Icons.payments_rounded, size: 18),
          ),
          SizedBox(height: AppSpacing.sm.h),
          AppInput(
            label: SuppliersStrings.notesLabel,
            controller: notesCtrl,
            maxLines: 2,
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }

  static void showLoadFromCustomerDialog(BuildContext context, PosBloc bloc) {
    final state = bloc.state;
    final scheme = Theme.of(context).colorScheme;
    final selectedId = state.selectedCustomerId;

    if (selectedId == null) {
      AppSnackbar.warning(SalesStrings.selectCustomerFirstWarning);
      return;
    }

    final customer = state.customers.firstWhereOrNull((c) => c.id == selectedId);
    if (customer == null) return;

    final quotes = QuoteService.getAll().where((q) => q.customerName == customer.name).toList();
    final drafts = state.suspendedSales.where((d) {
      return true; 
    }).toList();

    showDialog(
      context: context,
      builder: (context) => AppDialog(
        headerIcon: const Icon(Icons.download_rounded),
        headerIconColor: scheme.primary,
        title: '${SalesStrings.posLoadFromCustomer}: ${customer.name}',
        maxWidth: 600,
        children: [
          if (quotes.isEmpty && drafts.isEmpty)
            const AppStateView.empty(
              icon: Icons.folder_open_rounded,
              title: SalesStrings.noDataForCustomerTitle,
              subtitle: SalesStrings.noDataForCustomerSubtitle,
            )
          else
            SizedBox(
              height: 400.h,
              child: ListView(
                children: [
                  if (quotes.isNotEmpty) ...[
                    const SectionHeader(title: SalesStrings.customerQuotesSectionTitle, icon: Icons.request_quote_rounded),
                    ...quotes.map((q) => AppCard(
                      margin: EdgeInsets.only(bottom: 8.h),
                      onTap: () {
                        bloc.add(PosEditQuote(q));
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(SalesStrings.quoteNumberFormatShort.replaceFirst('%s', '${q.number}'), style: const TextStyle(fontWeight: FontWeight.bold)),
                                AppText(FormatUtils.dateTime(q.createdAt), variant: AppTextVariant.caption),
                              ],
                            ),
                          ),
                          AppText(FormatUtils.currency(q.total), style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.bold, color: scheme.primary)),
                        ],
                      ),
                    )),
                  ],
                  if (drafts.isNotEmpty) ...[
                    SizedBox(height: 16.h),
                    const SectionHeader(title: SalesStrings.pendingDraftsSectionTitle, icon: Icons.drafts_rounded),
                    ...drafts.map((d) => AppCard(
                      margin: EdgeInsets.only(bottom: 8.h),
                      onTap: () {
                        bloc.add(PosResumeSale(d));
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(d['notes']?.isNotEmpty == true ? d['notes'] : SalesStrings.untitledDraft, style: const TextStyle(fontWeight: FontWeight.bold)),
                                AppText(FormatUtils.dateTime(DateTime.tryParse(d['created_at']) ?? DateTime.now()), variant: AppTextVariant.caption),
                              ],
                            ),
                          ),
                          AppText(FormatUtils.currency((d['total'] as num).toDouble()), style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    )),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }

  static void showInvoiceDiscountDialog(BuildContext context, PosBloc bloc) {
    PosDiscountDialog.show(
      context,
      initialValue: bloc.state.invoiceDiscount,
      onApply: (res) => bloc.add(PosSetInvoiceDiscount(res.value, isPercentage: res.isPercentage)),
    );
  }

  static void showInvoiceTaxDialog(BuildContext context, PosBloc bloc) {
    PosDiscountDialog.show(
      context,
      initialValue: bloc.state.invoiceTax,
      isTax: true,
      onApply: (res) => bloc.add(PosSetInvoiceTax(res.value, isPercentage: res.isPercentage)),
    );
  }

  static void showPromotionsDialog(BuildContext context, PosBloc bloc) {
    final branchId = AuthService.currentBranchId ?? '';
    showDialog(
      context: context,
      builder: (context) => AppDialog(
        headerIcon: const Icon(Icons.local_offer_rounded),
        headerIconColor: AppColors.warning,
        title: SalesStrings.promotionsTitle,
        maxWidth: 700,
        children: [
          SizedBox(
            height: 500.h,
            child: FutureBuilder<List<PromotionModel>>(
              future: PromotionService.getAll(branchId: branchId),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const AppStateView.empty(
                    icon: Icons.local_offer_outlined,
                    title: SalesStrings.noPromotions,
                  );
                }
                final promos = snapshot.data!;
                return ListView.separated(
                  itemCount: promos.length,
                  separatorBuilder: (_, _) => SizedBox(height: 8.h),
                  itemBuilder: (context, i) {
                    final p = promos[i];
                    return AppCard(
                      padding: EdgeInsets.all(10.w),
                      child: Row(
                        children: [
                          Container(
                            width: 36.w,
                            height: 36.w,
                            decoration: BoxDecoration(
                              color: p.isCurrentlyActive ? AppColors.success.withValues(alpha: 0.1) : AppColors.error.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              p.isCurrentlyActive ? Icons.check_circle_rounded : Icons.cancel_rounded,
                              color: p.isCurrentlyActive ? AppColors.success : AppColors.error,
                              size: 18.sp,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(p.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                AppText(
                                  p.isPercentage
                                      ? SalesStrings.discountPercentFormat.replaceFirst('%s', p.value.toStringAsFixed(0))
                                      : SalesStrings.discountFixedFormat.replaceFirst('%s', FormatUtils.currency(p.value)),
                                  variant: AppTextVariant.caption,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  static void showDamagedStockDialog(BuildContext context, PosBloc bloc) {
    final branchId = AuthService.currentBranchId ?? '';
    showDialog(
      context: context,
      builder: (context) => AppDialog(
        headerIcon: const Icon(Icons.warning_amber_rounded),
        headerIconColor: AppColors.error,
        title: SalesStrings.damagedStockTitle,
        maxWidth: 700,
        children: [
          SizedBox(
            height: 500.h,
            child: FutureBuilder<List<DamagedStockModel>>(
              future: DamagedStockService.getAll(branchId: branchId),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const AppStateView.empty(
                    icon: Icons.inventory_2_outlined,
                    title: SalesStrings.noDamagedStock,
                  );
                }
                final items = snapshot.data!;
                return ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, _) => SizedBox(height: 8.h),
                  itemBuilder: (context, i) {
                    final d = items[i];
                    return AppCard(
                      padding: EdgeInsets.all(10.w),
                      child: Row(
                        children: [
                          Container(
                            width: 36.w,
                            height: 36.w,
                            decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.1), shape: BoxShape.circle),
                            child: Icon(Icons.error_outline_rounded, color: AppColors.error, size: 18.sp),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(d.medicineName, style: const TextStyle(fontWeight: FontWeight.bold)),
                                AppText('${SalesStrings.cartQuantity}: ${d.quantity} — ${d.reason}', variant: AppTextVariant.caption),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  static void showOpeningStockDialog(BuildContext context, PosBloc bloc) {
    final branchId = AuthService.currentBranchId ?? '';
    showDialog(
      context: context,
      builder: (context) => AppDialog(
        headerIcon: const Icon(Icons.playlist_add_check_rounded),
        headerIconColor: AppColors.info,
        title: SalesStrings.openingStockTitle,
        maxWidth: 700,
        children: [
          SizedBox(
            height: 500.h,
            child: FutureBuilder<List<OpeningStockModel>>(
              future: OpeningStockService.getAll(branchId: branchId),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const AppStateView.empty(
                    icon: Icons.inventory_2_outlined,
                    title: SalesStrings.noOpeningStock,
                  );
                }
                final items = snapshot.data!;
                return ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, _) => SizedBox(height: 8.h),
                  itemBuilder: (context, i) {
                    final o = items[i];
                    return AppCard(
                      padding: EdgeInsets.all(10.w),
                      child: Row(
                        children: [
                          Container(
                            width: 36.w,
                            height: 36.w,
                            decoration: BoxDecoration(color: AppColors.info.withValues(alpha: 0.1), shape: BoxShape.circle),
                            child: Icon(Icons.check_circle_outline_rounded, color: AppColors.info, size: 18.sp),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(o.medicineName, style: const TextStyle(fontWeight: FontWeight.bold)),
                                AppText('${SalesStrings.cartQuantity}: ${o.quantity} — ${FormatUtils.currency(o.buyPrice)}', variant: AppTextVariant.caption),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


class RecentOperationsDialog extends StatefulWidget {
  const RecentOperationsDialog({super.key});

  @override
  State<RecentOperationsDialog> createState() => _RecentOperationsDialogState();
}

class _RecentOperationsDialogState extends State<RecentOperationsDialog> {
  int _activeTab = 0;

  Widget _tabHeader(int index, String title, IconData icon) {
    final isSelected = _activeTab == index;
    final scheme = Theme.of(context).colorScheme;

    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _activeTab = index),
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            color: isSelected ? scheme.primary : scheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16.sp, color: isSelected ? scheme.onPrimary : scheme.onSurfaceVariant),
              SizedBox(width: 8.w),
              AppText(
                title,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? scheme.onPrimary : scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      headerIcon: const Icon(Icons.history_rounded),
      headerIconColor: AppColors.primary,
      title: SalesStrings.recentOperations,
      maxWidth: 800,
      children: [
        Row(
          children: [
            _tabHeader(0, SalesStrings.salesInvoices, Icons.receipt_long_rounded),
            SizedBox(width: 8.w),
            _tabHeader(1, SalesStrings.priceQuotes, Icons.request_quote_rounded),
            SizedBox(width: 8.w),
            _tabHeader(2, SalesStrings.drafts, Icons.drafts_rounded),
          ],
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 450.h,
          child: _buildActiveTabContent(),
        ),
      ],
    );
  }

  Widget _buildActiveTabContent() {
    final scheme = Theme.of(context).colorScheme;
    if (_activeTab == 0) {
      return BlocBuilder<PosBloc, PosState>(
        builder: (context, state) {
          final sales =
              BranchDataService.getSales().where((s) => !s.isDeleted).toList()
                ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

          if (sales.isEmpty) {
            return const AppStateView.empty(
              icon: Icons.receipt_long_outlined,
              title: SalesStrings.noSalesInvoices,
            );
          }

          return ListView.separated(
            itemCount: sales.length,
            separatorBuilder: (_, index) => SizedBox(height: 8.h),
            itemBuilder: (context, i) {
              final sale = sales[i];
              final customerLabel = sale.customerName ?? SalesStrings.cashCustomerLabel;
              final paymentLabel = switch(sale.paymentMethod) {
                'cash' => SalesStrings.cartPaymentCash,
                'card' => SalesStrings.cartPaymentCard,
                _ => SalesStrings.cartPaymentCredit,
              };

              return AppCard(
                padding: EdgeInsets.all(10.w),
                child: Row(
                  children: [
                    Container(
                      width: 32.w,
                      height: 32.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
                      child: AppText('${i + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            '${sale.id.substring(0, 8).toUpperCase()} ($customerLabel)',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          AppText(
                            SalesStrings.invoiceItemSummaryFormat
                                .replaceFirst('%s', FormatUtils.dateTime(sale.createdAt))
                                .replaceFirst('%s', '${sale.items.length}')
                                .replaceFirst('%s', paymentLabel),
                            variant: AppTextVariant.caption,
                          ),
                        ],
                      ),
                    ),
                    AppText(
                      FormatUtils.currency(sale.finalAmount),
                      style: AppTextStyles.body(context).copyWith(fontSize: 13.sp, fontWeight: FontWeight.w800, color: scheme.primary),
                    ),
                    SizedBox(width: 16.w),
                    Row(
                      children: [
                        _miniAction(Icons.edit_rounded, scheme.primary, () {
                          Navigator.of(context).pop();
                          context.read<PosBloc>().add(PosEditSale(sale));
                        }),
                        SizedBox(width: 6.w),
                        _miniAction(Icons.print_rounded, AppColors.info, () {
                          PrintService.printSalesInvoice(sale);
                        }),
                        SizedBox(width: 6.w),
                        _miniAction(Icons.delete_outline_rounded, AppColors.error, () {
                          _confirmDelete(
                            context,
                            SalesStrings.confirmVoidInvoiceMsg,
                            () async {
                              await BranchDataService.voidSale(sale.id);
                              setState(() {});
                            },
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    } else if (_activeTab == 1) {
      final quotes = QuoteService.getAll();
      final scheme = Theme.of(context).colorScheme;
      if (quotes.isEmpty) return const AppStateView.empty(icon: Icons.request_quote_outlined, title: SalesStrings.noPriceQuotes);

      return ListView.separated(
        itemCount: quotes.length,
        separatorBuilder: (_, index) => SizedBox(height: 8.h),
        itemBuilder: (context, i) {
          final quote = quotes[i];
          return AppCard(
            padding: EdgeInsets.all(10.w),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText('${SalesStrings.priceQuotes} #${quote.number} (${quote.customerName})', style: const TextStyle(fontWeight: FontWeight.bold)),
                      AppText('${FormatUtils.dateTime(quote.createdAt)} — ${quote.items.length} ${HomeStrings.item}', variant: AppTextVariant.caption),
                    ],
                  ),
                ),
                AppText(FormatUtils.currency(quote.total), style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.bold, color: scheme.primary)),
                SizedBox(width: 12.w),
                Row(
                  children: [
                    _miniAction(Icons.edit_rounded, scheme.primary, () {
                      Navigator.of(context).pop();
                      context.read<PosBloc>().add(PosEditQuote(quote));
                    }),
                    SizedBox(width: 6.w),
                    _miniAction(Icons.print_rounded, AppColors.info, () {
                      PrintService.printQuote(quote);
                    }),
                    SizedBox(width: 6.w),
                     _miniAction(Icons.delete_outline_rounded, AppColors.error, () {
                        _confirmDelete(context, SalesStrings.confirmDeleteQuote, () async {

                        await QuoteService.softDelete(quote.id);
                        setState(() {});
                      });
                    }),
                  ],
                ),
              ],
            ),
          );
        },
      );
    } else {
      return BlocBuilder<PosBloc, PosState>(
        builder: (context, state) {
          final drafts = state.suspendedSales;
          if (drafts.isEmpty) return const AppStateView.empty(icon: Icons.drafts_outlined, title: SalesStrings.noDraftsPending);

          return ListView.separated(
            itemCount: drafts.length,
            separatorBuilder: (_, index) => SizedBox(height: 8.h),
            itemBuilder: (context, i) {
              final d = drafts[i];
              final notes = d['notes']?.isNotEmpty == true ? d['notes'] : SalesStrings.untitledDraft;
              return AppCard(
                padding: EdgeInsets.all(10.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(notes, style: const TextStyle(fontWeight: FontWeight.bold)),
                          AppText(FormatUtils.dateTime(DateTime.tryParse(d['created_at']) ?? DateTime.now()), variant: AppTextVariant.caption),
                        ],
                      ),
                    ),
                    AppText(FormatUtils.currency((d['total'] as num).toDouble()), style: const TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(width: 12.w),
                    _miniAction(Icons.play_circle_fill_rounded, AppColors.success, () {
                      Navigator.of(context).pop();
                      context.read<PosBloc>().add(PosResumeSale(d));
                    }),
                  ],
                ),
              );
            },
          );
        },
      );
    }
  }

  Widget _miniAction(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: EdgeInsets.all(6.w),
        decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
        child: Icon(icon, size: 16.sp, color: color),
      ),
    );
  }

  void _confirmDelete(BuildContext context, String msg, VoidCallback onConfirm) {
    AppDialog.show(
      context,
      title: SalesStrings.confirmDelete,
      headerIcon: const Icon(Icons.delete_forever_rounded, color: AppColors.error),
      children: [
        AppText(msg),
        SizedBox(height: 24.h),
        DialogActions(
          confirmText: SalesStrings.permanentDelete,
          confirmType: ButtonType.primary,
          onConfirm: () {
            Navigator.pop(context);
            onConfirm();
          },
        ),
      ],
    );
  }
}






