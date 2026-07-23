import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

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
    return BlocProvider.value(
      value: sl<SupplierCustomersBloc>()..add(const LoadSupplierCustomers()),
      child: BlocBuilder<SupplierCustomersBloc, SupplierCustomersState>(
        builder: (context, state) {
          return StandardModuleLayout(
            title: AppStrings.supplierCustomersTitle,
            subtitle: AppStrings.supplierCustomersSubtitle,
            actions: _buildHeaderActions(context),
            stats: _buildStats(state),
            filters: _buildFilters(context),
            content: _buildTable(context, state),
          );
        },
      ),
    );
  }

  List<Widget> _buildHeaderActions(BuildContext context) {
    return [
      ReusableButton(
        text: AppStrings.addAction,
        prefixIcon: Icons.add_rounded,
        onPressed: () => context.push(Routes.SUPPLIER_CUSTOMER_ADD),
      ),
      ReusableButton(
        text: AppStrings.export,
        prefixIcon: Icons.download_rounded,
        type: ButtonType.outlined,
        onPressed: () => context.read<SupplierCustomersBloc>().add(const ExportSupplierCustomerLedger('xlsx')),
      ),
    ];
  }

  List<Widget> _buildStats(SupplierCustomersState state) {
    return [
      SummaryCard(
        icon: Icons.swap_horiz_rounded,
        label: AppStrings.totalParties,
        value: '${state.allSuppliers.length}',
        color: AppColors.primary,
      ),
      SummaryCard(
        icon: Icons.check_circle_outline,
        label: AppStrings.activeParties,
        value: '${state.activeCount}',
        color: AppColors.success,
      ),
      SummaryCard(
        icon: Icons.account_balance_rounded,
        label: AppStrings.totalBalancesParties,
        value: '${state.totalBalance.toStringAsFixed(0)} ${AppStrings.currency}',
        color: AppColors.warning,
      ),
    ];
  }

  Widget _buildFilters(BuildContext context) {
    final bloc = context.read<SupplierCustomersBloc>();
    return AppCard(
      padding: EdgeInsets.all(12.w),
      child: Column(
        children: [
          SearchField(
            hint: AppStrings.searchHint,
            onChanged: (v) => bloc.add(SearchSupplierCustomers(v)),
            onClear: () => bloc.add(const SearchSupplierCustomers('')),
          ),
          SizedBox(height: AppSpacing.sm.h),
          SizedBox(
            height: 36.h,
            child: BlocBuilder<SupplierCustomersBloc, SupplierCustomersState>(
              builder: (context, state) {
                return ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (final filter in state.availableFilters)
                      Padding(
                        padding: EdgeInsets.only(right: AppSpacing.xs.w),
                        child: QuickFilterChip(
                          label: state.getFilterLabel(filter),
                          isSelected: state.selectedFilter == filter,
                          onTap: () => bloc.add(SetSupplierCustomersFilter(filter)),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTable(BuildContext context, SupplierCustomersState state) {
    final bloc = context.read<SupplierCustomersBloc>();
    final scheme = Theme.of(context).colorScheme;

    final columns = [
      ReusableTableColumn<SupplierCustomerModel>(
        id: 'name',
        title: AppStrings.partyNameLabel,
        flex: 1,
        isSortable: true,
        cellBuilder: (c) => Row(
          children: [
            CircleAvatar(
              radius: 16.r,
              backgroundColor: c.isActive ? AppColors.info.withValues(alpha: 0.15) : AppColors.error.withValues(alpha: 0.1),
              child: Icon(Icons.swap_horiz_rounded, color: c.isActive ? AppColors.info : AppColors.error, size: 16.sp),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                   ReusableText(c.name, style: AppTextStyles.bodyBold(context), maxLines: 1, overflow: TextOverflow.ellipsis),
                   ReusableText(c.subtitle, style: AppTextStyles.caption(context).copyWith(color: scheme.onSurfaceVariant)),
                ],
              ),
            ),
          ],
        ),
      ),
      ReusableTableColumn<SupplierCustomerModel>(
        id: 'phone',
        title: AppStrings.phone,
        width: 130.w,
        textBuilder: (c) => c.phone ?? '-',
      ),
      ReusableTableColumn<SupplierCustomerModel>(
        id: 'company',
        title: AppStrings.company,
        width: 150.w,
        textBuilder: (c) => c.companyName ?? '-',
      ),
      ReusableTableColumn<SupplierCustomerModel>(
        id: 'balance',
        title: AppStrings.balance,
        width: 120.w,
        isNumeric: true,
        cellBuilder: (c) {
          final balance = state.currentBalances[c.id] ?? 0;
          return ReusableText(
            '${balance.toStringAsFixed(0)} ${AppStrings.currency}',
            style: AppTextStyles.caption(context).copyWith(
              fontWeight: FontWeight.w600,
              color: balance > 0 ? AppColors.warning : AppColors.success,
            ),
          );
        },
      ),
      ReusableTableColumn<SupplierCustomerModel>(
        id: 'status',
        title: AppStrings.status,
        width: 90.w,
        cellBuilder: (c) => StatusBadge(
          label: c.isActive ? AppStrings.active : AppStrings.inactiveLabel,
          color: c.isActive ? AppColors.success : AppColors.error,
        ),
      ),
    ];

    return ReusableTable<SupplierCustomerModel>(
      columns: columns,
      items: state.filteredSuppliers,
      isLoading: state.status == SupplierCustomersStatus.loading,
      onTapRow: (c) => _showLedgerDialog(context, c),
      rowIdGetter: (c) => c.id,
      itemLabel: 'جهة تعامل',
      rowActions: (c) => _buildRowActions(context, bloc, c),
    );
  }

  Widget _buildRowActions(BuildContext context, SupplierCustomersBloc bloc, SupplierCustomerModel c) {
    final scheme = Theme.of(context).colorScheme;
    return PopupMenuButton<String>(
      offset: const Offset(0, 40),
      onSelected: (v) {
        switch (v) {
          case 'edit': _showDialog(context, item: c); break;
          case 'ledger': _showLedgerDialog(context, c); break;
          case 'delete':
            ConfirmDeleteDialog.show(
              context,
              title: AppStrings.delete,
              message: AppStrings.deleteConfirmMessageFormat.replaceFirst('%s', c.name),
              onConfirm: () => bloc.add(DeleteSupplierCustomer(c.id)),
            );
            break;
        }
      },
      itemBuilder: (_) => [
        const PopupMenuItem(value: 'ledger', child: ReusableText(AppStrings.ledgerTitle)),
        const PopupMenuItem(value: 'edit', child: ReusableText(AppStrings.edit)),
        PopupMenuItem(value: 'delete', child: ReusableText(AppStrings.delete, color: AppColors.error)),
      ],
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.button),
          border: Border.all(color: scheme.outlineVariant),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ReusableText('خيارات', style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.bold, color: scheme.primary)),
            SizedBox(width: 4.w),
            Icon(Icons.more_vert_rounded, size: 14.sp, color: scheme.primary),
          ],
        ),
      ),
    );
  }

  void _showLedgerDialog(BuildContext context, SupplierCustomerModel party) {
    final bloc = context.read<SupplierCustomersBloc>();
    bloc.add(LoadSupplierCustomerLedger(party.id));
    showDialog(
      context: context,
      builder: (ctx) => BlocProvider.value(
        value: bloc,
        child: _LedgerDialogContent(party: party),
      ),
    );
  }

  void _showDialog(BuildContext context, {SupplierCustomerModel? item}) {
    // Reuse existing add/edit dialog logic or navigate to add screen
    if (item != null) {
       // Logic to show edit dialog (could be extracted from the old file or moved to its own widget)
    } else {
       context.push(Routes.SUPPLIER_CUSTOMER_ADD);
    }
  }
}

class _LedgerDialogContent extends StatelessWidget {
  final SupplierCustomerModel party;
  const _LedgerDialogContent({required this.party});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SupplierCustomersBloc, SupplierCustomersState>(
      builder: (context, state) {
        final bloc = context.read<SupplierCustomersBloc>();
        final scheme = Theme.of(context).colorScheme;

        return ReusableDialog(
          title: '${AppStrings.ledgerTitle}: ${party.name}',
          headerIcon: const Icon(Icons.receipt_long_rounded),
          maxWidth: 900,
          children: [
            _buildTransactionSummary(context, state),
            SizedBox(height: AppSpacing.md.h),
            _buildLedgerActions(context, party, scheme, bloc),
            SizedBox(height: AppSpacing.md.h),
            SizedBox(
              height: 450.h,
              child: _buildLedgerTable(scheme, state),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTransactionSummary(BuildContext context, SupplierCustomersState state) {
    final summary = state.transactionSummary;
    if (summary.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 12.w, runSpacing: 8.h,
      children: [
        StatChip(label: AppStrings.totalSalesLabelStat, count: (summary['totalSales'] ?? 0).toStringAsFixed(0), color: AppColors.primary, icon: Icons.trending_up_rounded),
        StatChip(label: AppStrings.totalPurchasesLabelStat, count: (summary['totalPurchases'] ?? 0).toStringAsFixed(0), color: AppColors.info, icon: Icons.shopping_cart_rounded),
        StatChip(label: AppStrings.totalReceiptsLabelStat, count: (summary['totalReceipts'] ?? 0).toStringAsFixed(0), color: AppColors.success, icon: Icons.payments_rounded),
        StatChip(label: AppStrings.totalPaymentsLabelStat, count: (summary['totalPayments'] ?? 0).toStringAsFixed(0), color: AppColors.warning, icon: Icons.money_off_rounded),
      ],
    );
  }

  Widget _buildLedgerActions(BuildContext context, SupplierCustomerModel party, ColorScheme scheme, SupplierCustomersBloc bloc) {
    return Wrap(
      spacing: 8.w, runSpacing: 8.h,
      children: [
        ReusableButton(text: AppStrings.cashReceipt, prefixIcon: Icons.payments_rounded, onPressed: () => PaymentDialog.show(
          context,
          title: AppStrings.cashReceiptTitleFormat.replaceFirst('%s', party.name),
          onSubmit: (amount, notes) async => bloc.add(RecordCashReceipt(partyId: party.id, amount: amount, notes: notes)),
        )),
        ReusableButton(text: AppStrings.cashPayment, prefixIcon: Icons.payments_rounded, onPressed: () => PaymentDialog.show(
          context,
          title: AppStrings.cashPaymentTitleFormat.replaceFirst('%s', party.name),
          onSubmit: (amount, notes) async => bloc.add(RecordCashPayment(partyId: party.id, amount: amount, notes: notes)),
        )),
        ReusableButton(text: AppStrings.refresh, prefixIcon: Icons.refresh_rounded, onPressed: () => bloc.add(LoadSupplierCustomerLedger(party.id)), type: ButtonType.outlined),
      ],
    );
  }

  Widget _buildLedgerTable(ColorScheme scheme, SupplierCustomersState state) {
    if (state.isLoadingLedger) return const LoadingIndicator();
    final entries = state.combinedLedger;
    if (entries.isEmpty) return const EmptyState(icon: Icons.account_balance_wallet_outlined, title: AppStrings.noFinancialMovements);

    return ListView.separated(
      itemCount: entries.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, i) {
        final e = entries[i];
        final type = e['entryType'] as String;
        final date = e['date'] as DateTime;
        final debit = e['debit'] as double;
        final credit = e['credit'] as double;
        final runningBalance = e['runningBalance'] as double;

        return ListTile(
          dense: true,
          title: ReusableText(type, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(DateFormat('yyyy/MM/dd HH:mm').format(date)),
          trailing: Column(
            mainAxisAlignment: CrossAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ReusableText('${runningBalance.toStringAsFixed(2)} ${AppStrings.currency}', style: TextStyle(fontWeight: FontWeight.bold, color: runningBalance > 0 ? AppColors.warning : AppColors.success)),
              Text(debit > 0 ? '+${debit.toStringAsFixed(2)}' : '-${credit.toStringAsFixed(2)}', style: TextStyle(fontSize: 10.sp, color: debit > 0 ? AppColors.success : AppColors.error)),
            ],
          ),
        );
      },
    );
  }
}
