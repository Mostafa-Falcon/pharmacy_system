import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:pharmacy_system/app/modules/contacts/models/customer_ledger_model.dart';
import 'package:pharmacy_system/app/modules/contacts/models/supplier_customer_model.dart';
import 'package:pharmacy_system/app/modules/contacts/models/supplier_ledger_model.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_colors.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/index.dart';
import '../../../../core/extensions/string_ext.dart';
import '../../../../routes/app_routes.dart';
import '../../../../core/injection.dart';
import '../bloc/supplier_customers_bloc.dart';
import '../bloc/supplier_customers_event.dart';
import '../bloc/supplier_customers_state.dart';

class SupplierCustomersListView extends StatelessWidget {
  const SupplierCustomersListView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return BlocProvider.value(
      value: sl<SupplierCustomersBloc>(),
      child: HomeShell(
        title: AppStrings.supplierCustomersTitle,
        subtitle: AppStrings.supplierCustomersSubtitle,
        child: Container(
          color: scheme.surfaceContainerLow.withValues(alpha: 0.3),
          padding: EdgeInsets.all(AppSpacing.xl.w),
          child: Row(
            children: [
              Expanded(flex: 2, child: _buildPartyList(context)),
              SizedBox(width: AppSpacing.lg.w),
              Expanded(flex: 3, child: _buildDetailPanel(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPartyList(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context),
        SizedBox(height: AppSpacing.lg.h),
        _buildSearchBar(context),
        SizedBox(height: AppSpacing.md.h),
        Expanded(child: _buildList(context)),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return BlocBuilder<SupplierCustomersBloc, SupplierCustomersState>(
      builder: (context, state) {
        return Row(
          children: [
            ReusableButton(
              text: AppStrings.addAction,
              prefixIcon: Icons.add_rounded,
              onPressed: () => context.push(Routes.SUPPLIER_CUSTOMER_ADD),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(child: SummaryCard(
                    icon: Icons.swap_horiz_rounded,
                    label: AppStrings.totalParties,
                    value: '${state.totalCount}',
                    color: AppColors.primary,
                  )),
                  SizedBox(width: AppSpacing.sm.w),
                  Expanded(child: SummaryCard(
                    icon: Icons.check_circle_outline,
                    label: AppStrings.activeParties,
                    value: '${state.activeCount}',
                    color: AppColors.success,
                  )),
                  SizedBox(width: AppSpacing.sm.w),
                  Expanded(child: SummaryCard(
                    icon: Icons.account_balance_rounded,
                    label: AppStrings.totalBalancesParties,
                    value: '${state.totalBalance.toStringAsFixed(0)} ${AppStrings.currency}',
                    color: AppColors.warning,
                  )),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return BlocBuilder<SupplierCustomersBloc, SupplierCustomersState>(
      builder: (context, state) {
        return Column(
          children: [
            if (state.searchQuery.isNotEmpty || state.allSuppliers.length > 5)
              SearchField(
                hint: AppStrings.searchHint,
                onChanged: (v) => context.read<SupplierCustomersBloc>().add(SearchSupplierCustomers(v)),
                onClear: () => context.read<SupplierCustomersBloc>().add(const SearchSupplierCustomers('')),
              ),
            SizedBox(height: AppSpacing.sm.h),
            SizedBox(
              height: 36.h,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (final filter in state.availableFilters)
                    Padding(
                      padding: EdgeInsets.only(right: AppSpacing.xs.w),
                      child: QuickFilterChip(
                        label: state.getFilterLabel(filter),
                        isSelected: state.selectedFilter == filter,
                        onTap: () => context.read<SupplierCustomersBloc>().add(SetSupplierCustomersFilter(filter)),
                        color: scheme.primary,
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildList(BuildContext context) {
    return BlocBuilder<SupplierCustomersBloc, SupplierCustomersState>(
      builder: (context, state) {
        if (state.status == SupplierCustomersStatus.loading && state.allSuppliers.isEmpty) {
          return const LoadingIndicator();
        }
        final items = state.filteredSuppliers;
        if (items.isEmpty) {
          return const EmptyState(
            icon: Icons.swap_horiz_rounded,
            title: AppStrings.noPartiesFound,
          );
        }
        return ListView.separated(
          itemCount: items.length,
          separatorBuilder: (_, _) => SizedBox(height: AppSpacing.sm.h),
          itemBuilder: (_, i) {
            final c = items[i];
            final isSelected = state.selectedParty?.id == c.id;
            final balance = state.currentBalances[c.id] ?? 0;
            final isPositive = balance > 0;
            return PartyListTile(
              avatarIcon: Icons.swap_horiz_rounded,
              avatarColor: c.isActive ? AppColors.info : AppColors.error,
              title: c.name,
              subtitle: c.subtitle + (c.companyName != null ? '\n${c.companyName!}' : ''),
              tags: const [],
              trailing: Tag(
                label: '${balance.toStringAsFixed(0)} ${AppStrings.currency}',
                color: isPositive ? AppColors.warning : AppColors.success,
              ),
              onTap: () => context.read<SupplierCustomersBloc>().add(LoadSupplierCustomerLedger(c.id)),
              selected: isSelected,
              menuItems: [
                ReusableActionMenuItem(
                  value: 'edit',
                  icon: Icons.edit_outlined,
                  label: AppStrings.edit,
                ),
                ReusableActionMenuItem(
                  value: 'delete',
                  icon: Icons.delete_outline_rounded,
                  label: AppStrings.delete,
                  color: AppColors.error,
                ),
              ],
              onMenuSelected: (v) {
                switch (v) {
                  case 'edit':
                    _showDialog(context, item: c);
                  case 'delete':
                    ConfirmDeleteDialog.show(
                      context,
                      title: AppStrings.delete,
                      message: AppStrings.deleteConfirmMessageFormat.replaceFirst('%s', c.name),
                      onConfirm: () => context.read<SupplierCustomersBloc>().add(DeleteSupplierCustomer(c.id)),
                    );
                }
              },
            );
          },
        );
      },
    );
  }

  Widget _buildDetailPanel(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return BlocBuilder<SupplierCustomersBloc, SupplierCustomersState>(
      builder: (context, state) {
        final selected = state.selectedParty;
        if (selected == null) {
          return const EmptyState(
            icon: Icons.touch_app_rounded,
            title: AppStrings.selectPartyToViewLedger,
          );
        }
        return _buildLedgerView(context, selected, scheme, state);
      },
    );
  }

  Widget _buildLedgerView(BuildContext context, SupplierCustomerModel party, ColorScheme scheme, SupplierCustomersState state) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPartyHeader(party, scheme),
          const Divider(height: 1),
          _buildTransactionSummary(context, state),
          const Divider(height: 1),
          _buildLedgerActions(context, party, scheme),
          const Divider(height: 1),
          Expanded(child: _buildLedgerTable(scheme, state)),
        ],
      ),
    );
  }

  Widget _buildPartyHeader(SupplierCustomerModel party, ColorScheme scheme) {
    return Padding(
      padding: EdgeInsets.all(AppSpacing.md.w),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: party.isActive ? AppColors.info.withValues(alpha: 0.15) : AppColors.error.withValues(alpha: 0.1),
            child: Icon(Icons.swap_horiz_rounded, color: party.isActive ? AppColors.info : AppColors.error),
          ),
          SizedBox(width: AppSpacing.md.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(party.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
                SizedBox(height: 4.h),
                Text(party.subtitle, style: TextStyle(fontSize: 11.sp, color: scheme.onSurfaceVariant)),
              ],
            ),
          ),
          if (party.creditLimit > 0)
            Tag(label: '${AppStrings.creditLimit}: ${party.creditLimit.toStringAsFixed(0)} ${AppStrings.currency}', color: AppColors.info),
        ],
      ),
    );
  }

  Widget _buildTransactionSummary(BuildContext context, SupplierCustomersState state) {
    final summary = state.transactionSummary;
    if (summary.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(AppSpacing.md.w),
      color: Theme.of(context).colorScheme.surfaceContainerLow.withValues(alpha: 0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReusableText(AppStrings.transactionSummary, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurfaceVariant)),
          SizedBox(height: AppSpacing.sm.h),
          Wrap(
            spacing: AppSpacing.md.w, runSpacing: AppSpacing.sm.h,
            children: [
              StatChip(label: AppStrings.totalSalesLabelStat, count: (summary['totalSales'] ?? 0).toStringAsFixed(0), color: AppColors.primary, icon: Icons.trending_up_rounded),
              StatChip(label: AppStrings.totalSalesReturnsLabelStat, count: (summary['totalSalesReturns'] ?? 0).toStringAsFixed(0), color: AppColors.error, icon: Icons.undo_rounded),
              StatChip(label: AppStrings.totalPurchasesLabelStat, count: (summary['totalPurchases'] ?? 0).toStringAsFixed(0), color: AppColors.info, icon: Icons.shopping_cart_rounded),
              StatChip(label: AppStrings.totalPurchaseReturnsLabelStat, count: (summary['totalPurchaseReturns'] ?? 0).toStringAsFixed(0), color: AppColors.error, icon: Icons.undo_rounded),
              StatChip(label: AppStrings.totalReceiptsLabelStat, count: (summary['totalReceipts'] ?? 0).toStringAsFixed(0), color: AppColors.success, icon: Icons.payments_rounded),
              StatChip(label: AppStrings.totalPaymentsLabelStat, count: (summary['totalPayments'] ?? 0).toStringAsFixed(0), color: AppColors.warning, icon: Icons.money_off_rounded),
              StatChip(label: AppStrings.totalAdditionsLabelStat, count: (summary['totalAdditions'] ?? 0).toStringAsFixed(0), color: AppColors.success, icon: Icons.add_circle_rounded),
              StatChip(label: AppStrings.totalDiscountsLabelStat, count: (summary['totalDiscounts'] ?? 0).toStringAsFixed(0), color: AppColors.error, icon: Icons.remove_circle_rounded),
              StatChip(label: AppStrings.totalCheckReceiptsLabelStat, count: (summary['totalCheckReceipts'] ?? 0).toStringAsFixed(0), color: AppColors.success, icon: Icons.account_balance_rounded),
              StatChip(label: AppStrings.totalCheckPaymentsLabelStat, count: (summary['totalCheckPayments'] ?? 0).toStringAsFixed(0), color: AppColors.warning, icon: Icons.account_balance_rounded),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLedgerActions(BuildContext context, SupplierCustomerModel party, ColorScheme scheme) {
    return Padding(
      padding: EdgeInsets.all(AppSpacing.md.w),
      child: Wrap(
        spacing: AppSpacing.sm.w, runSpacing: AppSpacing.sm.h,
        children: [
          ReusableButton(text: AppStrings.cashReceipt, prefixIcon: Icons.payments_rounded, onPressed: () => PaymentDialog.show(
            context,
            title: AppStrings.cashReceiptTitleFormat.replaceFirst('%s', party.name),
            onSubmit: (amount, notes) async {
              context.read<SupplierCustomersBloc>().add(RecordCashReceipt(partyId: party.id, amount: amount, notes: notes));
            },
          )),
          ReusableButton(text: AppStrings.cashPayment, prefixIcon: Icons.payments_rounded, onPressed: () => PaymentDialog.show(
            context,
            title: AppStrings.cashPaymentTitleFormat.replaceFirst('%s', party.name),
            onSubmit: (amount, notes) async {
              context.read<SupplierCustomersBloc>().add(RecordCashPayment(partyId: party.id, amount: amount, notes: notes));
            },
          )),
          ReusableButton(text: AppStrings.additionNotice, prefixIcon: Icons.add_circle_rounded, onPressed: () => _showAdjustmentDialog(context, title: AppStrings.additionNoticeTitleFormat.replaceFirst('%s', party.name), isAddition: true, onSubmit: (amount, notes) async {
            context.read<SupplierCustomersBloc>().add(RecordAdditionNotice(partyId: party.id, amount: amount, notes: notes));
          })),
          ReusableButton(text: AppStrings.discountNotice, prefixIcon: Icons.remove_circle_rounded, onPressed: () => _showAdjustmentDialog(context, title: AppStrings.discountNoticeTitleFormat.replaceFirst('%s', party.name), isAddition: false, onSubmit: (amount, notes) async {
            context.read<SupplierCustomersBloc>().add(RecordDiscountNotice(partyId: party.id, amount: amount, notes: notes));
          })),
          ReusableButton(text: AppStrings.checkReceipt, prefixIcon: Icons.account_balance_rounded, onPressed: () => _showCheckDialog(context, title: AppStrings.checkReceiptTitleFormat.replaceFirst('%s', party.name), isReceipt: true, onSubmit: (amount, checkNumber, bankName, dueDate, notes) async {
            context.read<SupplierCustomersBloc>().add(RecordCheckReceipt(partyId: party.id, amount: amount, checkNumber: checkNumber, bankName: bankName, dueDate: dueDate, notes: notes));
          })),
          ReusableButton(text: AppStrings.checkPayment, prefixIcon: Icons.account_balance_rounded, onPressed: () => _showCheckDialog(context, title: AppStrings.checkPaymentTitleFormat.replaceFirst('%s', party.name), isReceipt: false, onSubmit: (amount, checkNumber, bankName, dueDate, notes) async {
            context.read<SupplierCustomersBloc>().add(RecordCheckPayment(partyId: party.id, amount: amount, checkNumber: checkNumber, bankName: bankName, dueDate: dueDate, notes: notes));
          })),
          SizedBox(width: AppSpacing.sm.w),
          ReusableButton(text: AppStrings.refresh, prefixIcon: Icons.refresh_rounded, onPressed: () => context.read<SupplierCustomersBloc>().add(LoadSupplierCustomerLedger(party.id)), type: ButtonType.outlined),
          PopupMenuButton<String>(
            icon: Icon(Icons.download_rounded, size: 18.sp, color: scheme.primary),
            onSelected: (format) async => context.read<SupplierCustomersBloc>().add(ExportSupplierCustomerLedger(format)),
            itemBuilder: (_) => [
              PopupMenuItem(value: 'csv', child: Text(AppStrings.exportCsvAction)),
              PopupMenuItem(value: 'xlsx', child: Text(AppStrings.exportXlsxAction)),
              PopupMenuItem(value: 'html', child: Text(AppStrings.exportHtmlAction)),
              PopupMenuItem(value: 'xml', child: Text(AppStrings.exportXmlAction)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLedgerTable(ColorScheme scheme, SupplierCustomersState state) {
    if (state.isLoadingLedger) {
      return const LoadingIndicator();
    }
    final entries = state.combinedLedger;
    if (entries.isEmpty) {
      return const EmptyState(icon: Icons.account_balance_wallet_outlined, title: AppStrings.noFinancialMovements);
    }
    return ListView(
      padding: EdgeInsets.all(AppSpacing.sm.w),
      children: [
        _ledgerTableHeader(scheme),
        ...entries.map((e) => _ledgerRow(e, scheme)),
      ],
    );
  }

  Widget _ledgerTableHeader(ColorScheme scheme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
      decoration: BoxDecoration(color: scheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(6)),
      child: Row(
        children: [
          _cell(AppStrings.dateColumn, flex: 2),
          _cell(AppStrings.statementColumn, flex: 3),
          _cell(AppStrings.debitColumn, flex: 2, align: TextAlign.center),
          _cell(AppStrings.creditColumn, flex: 2, align: TextAlign.center),
          _cell(AppStrings.balanceColumn, flex: 2, align: TextAlign.center),
        ],
      ),
    );
  }

  Widget _ledgerRow(Map<String, dynamic> entry, ColorScheme scheme) {
    final type = entry['entryType'];
    String typeLabel = AppStrings.transactionPrefix;
    if (type is String) {
      CustomerLedgerEntryType? customerType;
      for (final t in CustomerLedgerEntryType.values) {
        if (t.name == type) { customerType = t; break; }
      }
      if (customerType != null) {
        typeLabel = switch (customerType) {
          CustomerLedgerEntryType.saleInvoice => AppStrings.saleInvoice,
          CustomerLedgerEntryType.saleReturn => AppStrings.saleReturn,
          CustomerLedgerEntryType.customerPayment => AppStrings.customerPayment,
          CustomerLedgerEntryType.saleVoid => AppStrings.saleVoid,
          CustomerLedgerEntryType.openingBalance => AppStrings.openingBalance,
          CustomerLedgerEntryType.manualAdjustment => AppStrings.manualAdjustment,
          CustomerLedgerEntryType.additionNotice => AppStrings.additionNotice,
          CustomerLedgerEntryType.discountNotice => AppStrings.discountNotice,
          CustomerLedgerEntryType.checkReceipt => AppStrings.checkReceipt,
          CustomerLedgerEntryType.checkPayment => AppStrings.checkPayment,
        };
      } else {
        SupplierLedgerEntryType? supplierType;
        for (final t in SupplierLedgerEntryType.values) {
          if (t.name == type) { supplierType = t; break; }
        }
        if (supplierType != null) {
          typeLabel = switch (supplierType) {
            SupplierLedgerEntryType.purchaseInvoice => AppStrings.entryTypePurchaseInvoice,
            SupplierLedgerEntryType.supplierPayment => AppStrings.customerPayment,
            SupplierLedgerEntryType.purchaseVoid => AppStrings.saleVoid,
            SupplierLedgerEntryType.openingBalance => AppStrings.openingBalance,
            SupplierLedgerEntryType.manualAdjustment => AppStrings.manualAdjustment,
            SupplierLedgerEntryType.additionNotice => AppStrings.additionNotice,
            SupplierLedgerEntryType.discountNotice => AppStrings.discountNotice,
            SupplierLedgerEntryType.checkReceipt => AppStrings.checkReceipt,
            SupplierLedgerEntryType.checkPayment => AppStrings.checkPayment,
          };
        } else {
          typeLabel = type;
        }
      }
    }

    final date = entry['date'] as DateTime;
    final debit = entry['debit'] as double;
    final credit = entry['credit'] as double;
    final runningBalance = entry['runningBalance'] as double;
    final referenceNumber = entry['referenceNumber'] as String?;
    final notes = entry['notes'] as String?;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.2)))),
      child: Row(
        children: [
          _cell('${date.day}/${date.month}', flex: 2),
          _cell('$typeLabel${referenceNumber != null ? '\n#$referenceNumber' : ''}${notes != null && notes.isNotEmpty ? '\n$notes' : ''}', flex: 3),
          _cell(debit > 0 ? debit.toStringAsFixed(2) : '-', flex: 2, align: TextAlign.center),
          _cell(credit > 0 ? credit.toStringAsFixed(2) : '-', flex: 2, align: TextAlign.center),
          _cell(runningBalance.toStringAsFixed(2), flex: 2, align: TextAlign.center, color: runningBalance > 0 ? AppColors.warning : AppColors.success),
        ],
      ),
    );
  }

  Widget _cell(String text, {int flex = 1, TextAlign align = TextAlign.start, Color? color}) {
    return Expanded(flex: flex, child: Text(text, style: TextStyle(fontSize: 10.sp, color: color), textAlign: align));
  }

  void _showDialog(BuildContext context, {SupplierCustomerModel? item}) {
    final nameCtrl = TextEditingController(text: item?.name ?? '');
    final phoneCtrl = TextEditingController(text: item?.phone ?? '');
    final addressCtrl = TextEditingController(text: item?.address ?? '');
    final emailCtrl = TextEditingController(text: item?.email ?? '');
    final companyNameCtrl = TextEditingController(text: item?.companyName ?? '');
    final taxIdCtrl = TextEditingController(text: item?.taxId ?? '');
    final notesCtrl = TextEditingController(text: item?.notes ?? '');
    final creditLimitCtrl = TextEditingController(text: item?.creditLimit.toString() ?? '0');
    final discountPercentCtrl = TextEditingController(text: item?.discountPercent.toString() ?? '0');
    final paymentTermDaysCtrl = TextEditingController(text: item?.paymentTermDays.toString() ?? '0');
    final openingBalanceCtrl = TextEditingController();
    var customerKindIndex = item?.customerKindIndex ?? 0;
    var supplierPartyTypeIndex = item?.supplierPartyTypeIndex ?? 0;
    var openingBalanceDirection = true;
    final isEditing = item != null;

    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setDialogState) {
          return ReusableDialog(
            maxWidth: 400,
            title: isEditing ? AppStrings.editPartyTitle : AppStrings.addNewPartyAction,
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReusableInput(label: AppStrings.partyNameLabel, controller: nameCtrl, textDirection: TextDirection.rtl),
                    SizedBox(height: AppSpacing.sm.h),
                    ReusableInput(label: AppStrings.phone, controller: phoneCtrl, keyboardType: TextInputType.phone, textDirection: TextDirection.rtl),
                    SizedBox(height: AppSpacing.sm.h),
                    ReusableInput(label: AppStrings.address, controller: addressCtrl, textDirection: TextDirection.rtl),
                    SizedBox(height: AppSpacing.sm.h),
                    ReusableInput(label: AppStrings.emailLabel, controller: emailCtrl, keyboardType: TextInputType.emailAddress, textDirection: TextDirection.rtl),
                    SizedBox(height: AppSpacing.sm.h),
                    ReusableInput(label: AppStrings.company, controller: companyNameCtrl, textDirection: TextDirection.rtl),
                    SizedBox(height: AppSpacing.sm.h),
                    ReusableInput(label: AppStrings.taxIdLabel, controller: taxIdCtrl, textDirection: TextDirection.rtl),
                    SizedBox(height: AppSpacing.sm.h),
                    ReusableDropdown<int>(
                      labelText: AppStrings.customerTypeLabel, hintText: AppStrings.selectCustomerTypeHint,
                      items: const [0, 1], value: customerKindIndex,
                      itemAsString: (i) => i == 0 ? AppStrings.regularInteraction : AppStrings.cashInteraction,
                      onChanged: (v) { if (v != null) setDialogState(() => customerKindIndex = v); },
                    ),
                    SizedBox(height: AppSpacing.sm.h),
                    ReusableInput(label: AppStrings.creditLimitLabelInputParty, controller: creditLimitCtrl, keyboardType: TextInputType.number),
                    SizedBox(height: AppSpacing.sm.h),
                    ReusableInput(label: AppStrings.discountPercentLabel, controller: discountPercentCtrl, keyboardType: TextInputType.number),
                    SizedBox(height: AppSpacing.sm.h),
                    ReusableInput(label: AppStrings.paymentTermDaysLabel, controller: paymentTermDaysCtrl, keyboardType: TextInputType.number),
                    SizedBox(height: AppSpacing.sm.h),
                    ReusableDropdown<int>(
                      labelText: AppStrings.entityTypeLabel, hintText: AppStrings.selectEntityTypeHint,
                      items: const [0, 1], value: supplierPartyTypeIndex,
                      itemAsString: (i) => i == 0 ? AppStrings.entityTypeCompany : AppStrings.entityTypeIndividual,
                      onChanged: (v) { if (v != null) setDialogState(() => supplierPartyTypeIndex = v); },
                    ),
                    SizedBox(height: AppSpacing.sm.h),
                    if (!isEditing) ...[
                      Row(children: [
                        Expanded(child: ReusableInput(label: AppStrings.openingBalance, controller: openingBalanceCtrl, keyboardType: TextInputType.number, hint: '0')),
                        SizedBox(width: AppSpacing.sm.w),
                        ReusableDropdown<bool>(
                          labelText: AppStrings.balanceStatusLabel, hintText: AppStrings.select,
                          items: const [true, false], value: openingBalanceDirection,
                          itemAsString: (v) => v ? AppStrings.debitLabel : AppStrings.creditLabel,
                          onChanged: (v) { if (v != null) setDialogState(() => openingBalanceDirection = v); },
                        ),
                      ]),
                      SizedBox(height: AppSpacing.sm.h),
                    ],
                    ReusableInput(label: AppStrings.notesLabel, controller: notesCtrl, maxLines: 2, textDirection: TextDirection.rtl),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.md.h),
              DialogActions(
                confirmText: isEditing ? AppStrings.save : AppStrings.add,
                onConfirm: () async {
                  if (nameCtrl.text.trim().isEmpty) return;
                  if (isEditing) {
                    context.read<SupplierCustomersBloc>().add(UpdateSupplierCustomer(
                      item.copyWith(
                        name: nameCtrl.text.trim(), phone: phoneCtrl.text.trim().nullIfEmpty,
                        address: addressCtrl.text.trim().nullIfEmpty, email: emailCtrl.text.trim().nullIfEmpty,
                        companyName: companyNameCtrl.text.trim().nullIfEmpty, taxId: taxIdCtrl.text.trim().nullIfEmpty,
                        notes: notesCtrl.text.trim().nullIfEmpty, customerKindIndex: customerKindIndex,
                        creditLimit: double.tryParse(creditLimitCtrl.text) ?? 0,
                        discountPercent: double.tryParse(discountPercentCtrl.text) ?? 0,
                        paymentTermDays: int.tryParse(paymentTermDaysCtrl.text) ?? 0,
                        supplierPartyTypeIndex: supplierPartyTypeIndex,
                      ),
                    ));
                  } else {
                    context.read<SupplierCustomersBloc>().add(AddSupplierCustomer(
                      name: nameCtrl.text.trim(), phone: phoneCtrl.text.trim().nullIfEmpty,
                      address: addressCtrl.text.trim().nullIfEmpty, email: emailCtrl.text.trim().nullIfEmpty,
                      companyName: companyNameCtrl.text.trim().nullIfEmpty, taxId: taxIdCtrl.text.trim().nullIfEmpty,
                      notes: notesCtrl.text.trim().nullIfEmpty, customerKindIndex: customerKindIndex,
                      creditLimit: double.tryParse(creditLimitCtrl.text) ?? 0,
                      discountPercent: double.tryParse(discountPercentCtrl.text) ?? 0,
                      paymentTermDays: int.tryParse(paymentTermDaysCtrl.text) ?? 0,
                      supplierPartyTypeIndex: supplierPartyTypeIndex,
                      openingBalance: double.tryParse(openingBalanceCtrl.text) ?? 0,
                      openingBalanceDirection: openingBalanceDirection ? 'debit' : 'credit',
                    ));
                  }
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
      },
    );
  }

  void _showAdjustmentDialog(BuildContext context, {required String title, required bool isAddition, required Future<void> Function(double amount, String? notes) onSubmit}) {
    final amountCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (ctx) {
        return ReusableDialog(
          maxWidth: 380,
          headerIcon: Icon(isAddition ? Icons.add_circle_rounded : Icons.remove_circle_rounded, color: isAddition ? AppColors.success : AppColors.warning, size: 22.w),
          headerIconColor: isAddition ? AppColors.success : AppColors.warning,
          title: title,
          children: [
            Form(key: formKey, child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              ReusableInput(label: AppStrings.amountLabel, hint: '0.00', controller: amountCtrl, prefixIcon: const Icon(Icons.attach_money_rounded), keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (val) { if (val == null || val.trim().isEmpty) return AppStrings.amountRequired; final num = double.tryParse(val); if (num == null || num <= 0) return AppStrings.enterCorrectNumber; return null; }),
              SizedBox(height: 16.h),
              ReusableInput(label: AppStrings.notesLabel, hint: AppStrings.processDetailsHint, controller: notesCtrl, textDirection: TextDirection.rtl, alignLabelWithHint: true, maxLines: 2, prefixIcon: const Icon(Icons.notes_rounded)),
              SizedBox(height: 24.h),
              DialogActions(confirmText: isAddition ? AppStrings.recordAdditionAction : AppStrings.recordDiscountAction, onConfirm: () async {
                if (!formKey.currentState!.validate()) return;
                await onSubmit(double.parse(amountCtrl.text), notesCtrl.text.trim().nullIfEmpty);
                if (context.mounted) Navigator.pop(context);
              }),
            ])),
          ],
        );
      },
    );
  }

  void _showCheckDialog(BuildContext context, {required String title, required bool isReceipt, required Future<void> Function(double amount, String? checkNumber, String? bankName, String? dueDate, String? notes) onSubmit}) {
    final amountCtrl = TextEditingController();
    final checkNumberCtrl = TextEditingController();
    final bankNameCtrl = TextEditingController();
    final dueDateCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (ctx) {
        return ReusableDialog(
          maxWidth: 400,
          headerIcon: const Icon(Icons.account_balance_rounded, color: AppColors.primary, size: 22),
          headerIconColor: AppColors.primary,
          title: title,
          children: [
            Form(key: formKey, child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              ReusableInput(label: AppStrings.checkValueLabel, hint: '0.00', controller: amountCtrl, prefixIcon: const Icon(Icons.attach_money_rounded), keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (val) { if (val == null || val.trim().isEmpty) return AppStrings.checkValueRequired; final num = double.tryParse(val); if (num == null || num <= 0) return AppStrings.enterCorrectNumber; return null; }),
              SizedBox(height: 12.h),
              ReusableInput(label: AppStrings.checkNumberLabel, hint: AppStrings.enterCheckNumberHint, controller: checkNumberCtrl, textDirection: TextDirection.rtl, prefixIcon: const Icon(Icons.confirmation_number_rounded)),
              SizedBox(height: 12.h),
              Row(children: [
                Expanded(child: ReusableInput(label: AppStrings.bankLabel, hint: AppStrings.bankNameHint, controller: bankNameCtrl, textDirection: TextDirection.rtl, prefixIcon: const Icon(Icons.account_balance_rounded))),
                SizedBox(width: 12.w),
                Expanded(child: ReusableInput(label: AppStrings.date, hint: AppStrings.dueDateHint, controller: dueDateCtrl, textDirection: TextDirection.rtl, prefixIcon: const Icon(Icons.calendar_today_rounded))),
              ]),
              SizedBox(height: 12.h),
              ReusableInput(label: AppStrings.notesLabel, hint: AppStrings.processDetailsHint, controller: notesCtrl, textDirection: TextDirection.rtl, alignLabelWithHint: true, maxLines: 2, prefixIcon: const Icon(Icons.notes_rounded)),
              SizedBox(height: 24.h),
              DialogActions(confirmText: isReceipt ? AppStrings.recordReceiptAction : AppStrings.recordPaymentAction, onConfirm: () async {
                if (!formKey.currentState!.validate()) return;
                await onSubmit(double.parse(amountCtrl.text), checkNumberCtrl.text.trim().nullIfEmpty, bankNameCtrl.text.trim().nullIfEmpty, dueDateCtrl.text.trim().nullIfEmpty, notesCtrl.text.trim().nullIfEmpty);
                if (context.mounted) Navigator.pop(context);
              }),
            ])),
          ],
        );
      },
    );
  }
}


