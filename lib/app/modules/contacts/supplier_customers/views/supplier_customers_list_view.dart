import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/components/tables/shared_table_cells.dart';

import 'package:pharmacy_system/app/core/models/contacts/supplier_customer_model.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_colors.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/index.dart';
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
            title: CrmStrings.supplierCustomersTitle,
            subtitle: CrmStrings.supplierCustomersSubtitle,
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
      AppButton(
        text: CrmStrings.addAction,
        prefixIcon: Icons.add_rounded,
        onPressed: () => context.push(Routes.SUPPLIER_CUSTOMER_ADD),
      ),
      AppButton(
        text: GeneralStrings.export,
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
        label: CrmStrings.totalParties,
        value: '${state.totalCount}',
        color: AppColors.primary,
      ),
      SummaryCard(
        icon: Icons.check_circle_outline,
        label: CrmStrings.activeParties,
        value: '${state.activeCount}',
        color: AppColors.success,
      ),
      SummaryCard(
        icon: Icons.account_balance_rounded,
        label: CrmStrings.totalBalancesParties,
        value: '${state.totalBalance.toStringAsFixed(0)} ${GeneralStrings.currency}',
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
            hint: GeneralStrings.searchHint,
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

    final columns = [
      AppTableColumn<SupplierCustomerModel>(
        id: 'name',
        title: CrmStrings.partyNameLabel,
        flex: 1,
        isSortable: true,
        cellBuilder: (c) => TableContactNameCell(
          name: c.name,
          subtitle: c.subtitle,
          icon: Icons.swap_horiz_rounded,
          iconColor: c.isActive ? AppColors.info : AppColors.error,
        ),
      ),
      AppTableColumn<SupplierCustomerModel>(
        id: 'phone',
        title: GeneralStrings.phone,
        width: 130.w,
        textBuilder: (c) => c.phone ?? '-',
      ),
      AppTableColumn<SupplierCustomerModel>(
        id: 'company',
        title: GeneralStrings.company,
        width: 150.w,
        textBuilder: (c) => c.companyName ?? '-',
      ),
      AppTableColumn<SupplierCustomerModel>(
        id: 'balance',
        title: GeneralStrings.balance,
        width: 120.w,
        isNumeric: true,
        cellBuilder: (c) {
          final balance = state.currentBalances[c.id] ?? 0;
          return TableMoneyCell(
            amount: balance,
            currency: GeneralStrings.currency,
            isNegative: balance > 0,
          );
        },
      ),
      AppTableColumn<SupplierCustomerModel>(
        id: 'status',
        title: GeneralStrings.status,
        width: 90.w,
        cellBuilder: (c) => StatusBadge(
          label: c.isActive ? GeneralStrings.active : CustomersStrings.inactiveLabel,
          color: c.isActive ? AppColors.success : AppColors.error,
        ),
      ),
    ];

    return AppTable<SupplierCustomerModel>(
      columns: columns,
      items: state.filteredSuppliers,
      isLoading: state.status == SupplierCustomersStatus.loading,
      onTapRow: (c) => _showLedgerDialog(context, c),
      rowIdGetter: (c) => c.id,
      itemLabel: '??? ?????',
      rowActions: (c) => TableOptionsButton(
        onSelected: (v) {
          switch (v) {
            case 'edit': _showDialog(context, item: c); break;
            case 'ledger': _showLedgerDialog(context, c); break;
            case 'delete':
              ConfirmDeleteDialog.show(
                context,
                title: GeneralStrings.delete,
                message: CrmStrings.deleteConfirmMessageFormat.replaceFirst('%s', c.name),
                onConfirm: () => bloc.add(DeleteSupplierCustomer(c.id)),
              );
              break;
          }
        },
        menuItems: [
          const PopupMenuItem(value: 'ledger', child: AppText(CustomersStrings.ledgerTitle)),
          PopupMenuItem(value: 'edit', child: AppText(GeneralStrings.edit)),
          PopupMenuItem(value: 'delete', child: AppText(GeneralStrings.delete, color: AppColors.error)),
        ],
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

        return AppDialog(
          title: '${CustomersStrings.ledgerTitle}: ${party.name}',
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
        StatChip(label: CrmStrings.totalSalesLabel, count: (summary['totalSales'] ?? 0).toStringAsFixed(0), color: AppColors.primary, icon: Icons.trending_up_rounded),
        StatChip(label: CrmStrings.totalPurchasesLabel, count: (summary['totalPurchases'] ?? 0).toStringAsFixed(0), color: AppColors.info, icon: Icons.shopping_cart_rounded),
        StatChip(label: CrmStrings.totalReceiptsLabel, count: (summary['totalReceipts'] ?? 0).toStringAsFixed(0), color: AppColors.success, icon: Icons.payments_rounded),
        StatChip(label: CrmStrings.totalPaymentsLabel, count: (summary['totalPayments'] ?? 0).toStringAsFixed(0), color: AppColors.warning, icon: Icons.money_off_rounded),
      ],
    );
  }

  Widget _buildLedgerActions(BuildContext context, SupplierCustomerModel party, ColorScheme scheme, SupplierCustomersBloc bloc) {
    return Wrap(
      spacing: 8.w, runSpacing: 8.h,
      children: [
        AppButton(text: CustomersStrings.cashReceipt, prefixIcon: Icons.payments_rounded, onPressed: () => PaymentDialog.show(
          context,
          title: CrmStrings.cashReceiptTitle.replaceFirst('%s', party.name),
          onSubmit: (amount, notes) async => bloc.add(RecordCashReceipt(partyId: party.id, amount: amount, notes: notes)),
        )),
        AppButton(text: SuppliersStrings.cashPayment, prefixIcon: Icons.payments_rounded, onPressed: () => PaymentDialog.show(
          context,
          title: CrmStrings.cashPaymentTitle.replaceFirst('%s', party.name),
          onSubmit: (amount, notes) async => bloc.add(RecordCashPayment(partyId: party.id, amount: amount, notes: notes)),
        )),
        AppButton(text: GeneralStrings.refresh, prefixIcon: Icons.refresh_rounded, onPressed: () => bloc.add(LoadSupplierCustomerLedger(party.id)), type: ButtonType.outlined),
      ],
    );
  }

  Widget _buildLedgerTable(ColorScheme scheme, SupplierCustomersState state) {
    if (state.isLoadingLedger) return const LoadingIndicator();
    final entries = state.combinedLedger;
    if (entries.isEmpty) return EmptyState(icon: Icons.account_balance_wallet_outlined, title: CustomersStrings.noFinancialMovements);

    return ListView.separated(
      itemCount: entries.length,
      separatorBuilder: (_, index) => const Divider(height: 1),
      itemBuilder: (context, i) {
        final e = entries[i];
        final type = e['entryType'] as String;
        final date = e['date'] as DateTime;
        final debit = e['debit'] as double;
        final credit = e['credit'] as double;
        final runningBalance = e['runningBalance'] as double;

        return ListTile(
          dense: true,
          title: AppText(type, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(DateFormat('yyyy/MM/dd HH:mm').format(date)),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AppText('${runningBalance.toStringAsFixed(2)} ${GeneralStrings.currency}', style: TextStyle(fontWeight: FontWeight.bold, color: runningBalance > 0 ? AppColors.warning : AppColors.success)),
              Text(debit > 0 ? '+${debit.toStringAsFixed(2)}' : '-${credit.toStringAsFixed(2)}', style: TextStyle(fontSize: 10.sp, color: debit > 0 ? AppColors.success : AppColors.error)),
            ],
          ),
        );
      },
    );
  }
}





