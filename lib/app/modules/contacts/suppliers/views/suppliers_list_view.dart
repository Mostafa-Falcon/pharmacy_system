import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/navigation/app_navigator.dart';

import 'package:pharmacy_system/app/modules/contacts/models/supplier_model.dart';
import 'package:pharmacy_system/app/modules/contacts/models/supplier_ledger_model.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_colors.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_sizes.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/index.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/reusables/tables/shared_table_cells.dart';
import '../../../../routes/app_routes.dart';
import '../bloc/suppliers_bloc.dart';
import '../bloc/suppliers_state.dart';
import '../bloc/suppliers_event.dart';

class SuppliersListView extends StatelessWidget {
  const SuppliersListView({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SuppliersBody();
  }
}

class _SuppliersBody extends StatelessWidget {
  const _SuppliersBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SuppliersBloc, SuppliersState>(
      builder: (context, state) {
        if (state.status == SuppliersStatus.initial || state.status == SuppliersStatus.loading) {
          return const HomeShell(
            title: AppStrings.suppliersTitle,
            child: Center(child: LoadingIndicator()),
          );
        }
        if (state.status == SuppliersStatus.error) {
          return HomeShell(
            title: AppStrings.suppliersTitle,
            child: ReusableStateView(
              message: state.error ?? AppStrings.errorLoadingSuppliers,
              action: ReusableButton(
                text: AppStrings.refresh,
                onPressed: () => context.read<SuppliersBloc>().add(const LoadSuppliers()),
              ),
            ),
          );
        }

        return StandardModuleLayout(
          title: AppStrings.suppliersTitle,
          actions: _buildActions(context),
          stats: _buildStats(state),
          filters: _buildFilters(context),
          content: _buildTable(context, state),
        );
      },
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    final bloc = context.read<SuppliersBloc>();
    return [
      ReusableButton(
        text: AppStrings.addSupplier,
        prefixIcon: Icons.add_rounded,
        onPressed: () => context.push(Routes.SUPPLIER_ADD),
      ),
      ReusableButton(
        text: AppStrings.export,
        prefixIcon: Icons.download_rounded,
        type: ButtonType.outlined,
        onPressed: () => bloc.add(const ExportSuppliers()),
      ),
      ReusableButton(
        text: 'استيراد من Excel',
        prefixIcon: Icons.file_upload_rounded,
        type: ButtonType.outlined,
        onPressed: () => context.push(Routes.SUPPLIERS_IMPORT),
      ),
    ];
  }

  List<Widget> _buildStats(SuppliersState state) {
    return [
      SummaryCard(
        icon: Icons.people_alt,
        label: AppStrings.totalSuppliers,
        value: '${state.allSuppliers.length}',
      ),
      SummaryCard(
        icon: Icons.check_circle_outline,
        label: AppStrings.activeSuppliers,
        value: '${state.activeSupplierCount}',
        color: AppColors.success,
      ),
      SummaryCard(
        icon: Icons.monetization_on_outlined,
        label: AppStrings.totalBalances,
        value: '${state.totalBalance.toStringAsFixed(0)} ${AppStrings.currency}',
        color: AppColors.warning,
      ),
    ];
  }

  Widget _buildFilters(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.all(AppSpacing.md),
      child: ReusableInput(
        hint: AppStrings.searchSupplierHint,
        prefixIcon: const Icon(Icons.search_rounded, size: 20), // تغيير من AppIconSize.md.value لـ رقم ثابت أو استخدام .value بره الـ const
        showClearButton: true,
        textDirection: TextDirection.rtl,
        onChanged: (q) => context.read<SuppliersBloc>().add(SearchSuppliers(q)),
        onClear: () => context.read<SuppliersBloc>().add(const SearchSuppliers('')),
      ),
    );
  }

  Widget _buildTable(BuildContext context, SuppliersState state) {
    final bloc = context.read<SuppliersBloc>();
    final f = NumberFormat('#,##0.##');

    final columns = [
      ReusableTableColumn<SupplierModel>(
        id: 'name',
        title: AppStrings.supplierLabelTable,
        flex: 1,
        isSortable: true,
        cellBuilder: (s) => TableContactNameCell(
          name: s.name,
          subtitle: AppStrings.supplierType,
          icon: Icons.local_shipping_rounded,
          iconColor: s.isActive ? AppColors.success : AppColors.error,
        ),
      ),
      ReusableTableColumn<SupplierModel>(
        id: 'phone',
        title: AppStrings.phoneLabel,
        width: 130.w,
        cellBuilder: (s) => ReusableText(s.phone ?? '-', style: AppTextStyles.caption(context)),
      ),
      ReusableTableColumn<SupplierModel>(
        id: 'company',
        title: AppStrings.companyLabel,
        width: 150.w,
        cellBuilder: (s) => ReusableText(s.companyName ?? '-', style: AppTextStyles.caption(context)),
      ),
      ReusableTableColumn<SupplierModel>(
        id: 'balance',
        title: AppStrings.balanceLabel,
        width: 130.w,
        isSortable: true,
        isNumeric: true,
        cellBuilder: (s) {
          final balance = state.balances[s.id] ?? 0;
          return TableMoneyCell(
            amount: balance,
            currency: AppStrings.currency,
            isNegative: balance > 0, // In suppliers, debit balance usually means we owe them
          );
        },
      ),
      ReusableTableColumn<SupplierModel>(
        id: 'creditLimit',
        title: AppStrings.creditLimitLabel,
        width: 130.w,
        isNumeric: true,
        textBuilder: (s) => s.creditLimit > 0 ? '${f.format(s.creditLimit)} ${AppStrings.currency}' : '-',
      ),
      ReusableTableColumn<SupplierModel>(
        id: 'discount',
        title: AppStrings.discountLabelTable,
        width: 80.w,
        isNumeric: true,
        textBuilder: (s) => s.discountPercent > 0 ? '${s.discountPercent}%' : '-',
      ),
      ReusableTableColumn<SupplierModel>(
        id: 'type',
        title: AppStrings.typeLabel,
        width: 100.w,
        cellBuilder: (s) => Tag(label: AppStrings.supplierType, color: AppColors.info),
      ),
      ReusableTableColumn<SupplierModel>(
        id: 'status',
        title: AppStrings.statusLabel,
        width: 90.w,
        cellBuilder: (s) => StatusBadge(
          label: s.isActive ? AppStrings.activeLabelSupplier : AppStrings.inactiveLabelSupplier,
          color: s.isActive ? AppColors.success : AppColors.error,
        ),
      ),
    ];

    return ReusableTable<SupplierModel>(
      columns: columns,
      items: state.pagedSuppliers,
      sortColumnId: state.sortColumnId,
      isSortAscending: state.isSortAscending,
      onSort: (colId) => bloc.add(UpdateSupplierSort(colId, !state.isSortAscending)),
      onTapRow: (s) => _showSupplierActions(context, s),
      isLoading: state.status == SuppliersStatus.loading,
      currentPage: state.currentPage + 1,
      totalPages: state.totalPages,
      totalItems: state.filteredSuppliers.length,
      itemLabel: AppStrings.supplier,
      showCheckbox: true,
      selectedIds: state.selectedIds,
      onSelectRow: (id) => bloc.add(ToggleSelectSupplier(id)),
      onToggleAll: (v) => bloc.add(ToggleSelectAllSuppliers(v)),
      showToolbar: true,
      onExportExcel: () => bloc.add(const ExportSuppliers()),
      onSearchChanged: (q) => bloc.add(SearchSuppliers(q)),
      bulkActions: _buildBulkActions(context, bloc, state),
      onNextPage: () => bloc.add(const NextSupplierPage()),
      onPreviousPage: () => bloc.add(const PreviousSupplierPage()),
      emptyState: const EmptyState(
        icon: Icons.local_shipping_outlined,
        title: AppStrings.noSuppliersTitle,
        subtitle: AppStrings.noSuppliersSubtitle,
      ),
      rowActions: (s) => _buildRowActions(context, bloc, s),
    );
  }

  List<Widget> _buildBulkActions(BuildContext context, SuppliersBloc bloc, SuppliersState state) {
    return [
      ReusableButton(
        text: AppStrings.delete,
        type: ButtonType.outlined,
        color: AppColors.error,
        prefixIcon: Icons.delete_outline_rounded,
        onPressed: () => ConfirmDeleteDialog.show(
          context,
          title: 'حذف المحدد',
          message: 'هل أنت متأكد من حذف ${state.selectedIds.length} من الموردين؟',
          onConfirm: () => bloc.add(const BulkDeleteSuppliers()),
        ),
      ),
      ReusableButton(
        text: AppStrings.deactivateLabel,
        type: ButtonType.outlined,
        color: AppColors.warning,
        prefixIcon: Icons.block_flipped,
        onPressed: () => bloc.add(const BulkToggleSuppliersActive(false)),
      ),
      ReusableButton(
        text: AppStrings.activate,
        type: ButtonType.outlined,
        color: AppColors.success,
        prefixIcon: Icons.check_circle_outline_rounded,
        onPressed: () => bloc.add(const BulkToggleSuppliersActive(true)),
      ),
    ];
  }

  Widget _buildRowActions(BuildContext context, SuppliersBloc bloc, SupplierModel s) {
    return TableOptionsButton(
      onSelected: (v) {
        switch (v) {
          case 'ledger':
            bloc.add(LoadSupplierLedger(s.id));
            showDialog(
              context: context,
              builder: (context) => BlocProvider.value(
                value: bloc,
                child: SupplierLedgerDialog(supplierName: s.name),
              ),
            );
            break;
          case 'edit':
            AppNavigator.to(Routes.SUPPLIER_ADD);
            break;
          case 'toggle':
            bloc.add(ToggleSupplierActive(s.id));
            break;
          case 'delete':
            ConfirmDeleteDialog.show(
              context,
              title: 'حذف المورد',
              message: 'هل أنت متأكد من حذف ${s.name}؟',
              onConfirm: () => bloc.add(DeleteSupplier(s.id)),
            );
            break;
        }
      },
      menuItems: [
        const PopupMenuItem(value: 'ledger', child: ReusableText(AppStrings.accountStatement)),
        const PopupMenuItem(value: 'edit', child: ReusableText(AppStrings.edit)),
        PopupMenuItem(value: 'toggle', child: ReusableText(s.isActive ? AppStrings.deactivateLabel : AppStrings.activate)),
        const PopupMenuItem(value: 'delete', child: ReusableText(AppStrings.delete, color: AppColors.error)),
      ],
    );
  }

  void _showSupplierActions(BuildContext context, SupplierModel s) {
    final bloc = context.read<SuppliersBloc>();
    final isArchived = s.isDeleted;
    ReusableBottomSheet.show(
      context: context,
      title: s.name,
      children: [
        const Divider(height: 1),
        ListTile(
          leading: const Icon(Icons.receipt_long_rounded),
          title: const ReusableText(AppStrings.accountStatement),
          onTap: () {
            Navigator.pop(context);
            bloc.add(LoadSupplierLedger(s.id));
            showDialog(
              context: context,
              builder: (context) => BlocProvider.value(
                value: bloc,
                child: SupplierLedgerDialog(supplierName: s.name),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.edit_rounded),
          title: const ReusableText(AppStrings.edit),
          onTap: () {
            Navigator.pop(context);
            AppNavigator.to(Routes.SUPPLIER_ADD);
          },
        ),
        ListTile(
          leading: Icon(s.isActive ? Icons.toggle_off_outlined : Icons.toggle_on_outlined),
          title: ReusableText(s.isActive ? AppStrings.deactivateLabel : AppStrings.activate),
          onTap: () {
            Navigator.pop(context);
            bloc.add(ToggleSupplierActive(s.id));
          },
        ),
        if (isArchived)
          ListTile(
            leading: const Icon(Icons.restore_rounded),
            title: const ReusableText(AppStrings.restoreLabel),
            onTap: () {
              Navigator.pop(context);
              bloc.add(RestoreSupplier(s.id));
            },
          )
        else
          ListTile(
            leading: const Icon(Icons.archive_rounded),
            title: const ReusableText(AppStrings.archive),
            onTap: () {
              Navigator.pop(context);
              bloc.add(ArchiveSupplier(s.id));
            },
          ),
        ListTile(
          leading: const Icon(Icons.delete_forever_rounded, color: AppColors.error),
          title: ReusableText(AppStrings.delete, color: AppColors.error),
          onTap: () {
            Navigator.pop(context);
            ReusableDialog.show(
              context,
              title: AppStrings.deleteSupplierConfirmTitle,
              headerIcon: const Icon(Icons.delete_forever_rounded, color: AppColors.error),
              children: [
                const ReusableText(AppStrings.deleteSupplierPermanentMessage),
                SizedBox(height: 24.h),
                DialogActions(
                  confirmText: AppStrings.permanentDeleteActionSupplier,
                  confirmType: ButtonType.primary,
                  onConfirm: () {
                    Navigator.pop(context);
                    bloc.add(DeleteSupplier(s.id));
                  },
                ),
              ],
            );
          },
        ),
        SizedBox(height: 12.h),
      ],
    );
  }
}

class SupplierLedgerDialog extends StatefulWidget {
  final String supplierName;
  const SupplierLedgerDialog({super.key, required this.supplierName});
  @override
  State<SupplierLedgerDialog> createState() => _SupplierLedgerDialogState();
}

class _SupplierLedgerDialogState extends State<SupplierLedgerDialog> {
  final amountCtrl = TextEditingController();
  final notesCtrl = TextEditingController();
  final checkNoCtrl = TextEditingController();
  final bankCtrl = TextEditingController();
  final dueDateCtrl = TextEditingController();

  @override
  void dispose() {
    amountCtrl.dispose();
    notesCtrl.dispose();
    checkNoCtrl.dispose();
    bankCtrl.dispose();
    dueDateCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SuppliersBloc>();
    final scheme = Theme.of(context).colorScheme;

    return ReusableDialog(
      title: '${AppStrings.accountStatement}: ${widget.supplierName}',
      headerIcon: const Icon(Icons.receipt_long_rounded),
      maxWidth: 750,
      footerActions: [
        ReusableButton(
          text: AppStrings.exit,
          type: ButtonType.text,
          onPressed: () {
            bloc.add(const ClearSupplierLedger());
            Navigator.pop(context);
          },
        ),
      ],
      children: [
        BlocBuilder<SuppliersBloc, SuppliersState>(
          builder: (context, state) {
            if (state.isLoadingLedger) return const Center(child: LoadingIndicator());
            final f = NumberFormat('#,##0.##');
            final balance = state.selectedSupplier != null ? (state.balances[state.selectedSupplier!.id] ?? 0) : 0;
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: balance > 0 ? AppColors.error.withValues(alpha: 0.05) : AppColors.success.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(AppRadius.card),
                    border: Border.all(color: (balance > 0 ? AppColors.error : AppColors.success).withValues(alpha: 0.15)),
                  ),
                  child: Row(
                    children: [
                      ReusableText(AppStrings.currentBalanceLabel, style: AppTextStyles.bodyBold(context)),
                      ReusableText(
                        '${f.format(balance)} ${AppStrings.currency}',
                        style: AppTextStyles.bodyBold(context).copyWith(
                          color: balance > 0 ? AppColors.error : AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppSpacing.md.h),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: ReusableInput(
                        controller: amountCtrl,
                        label: AppStrings.amountLabel,
                        hint: '0.00',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(width: AppSpacing.sm.w),
                    Expanded(
                      flex: 3,
                      child: ReusableInput(
                        controller: notesCtrl,
                        label: AppStrings.notesLabel,
                        hint: AppStrings.enterTransactionDetailsHint,
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.md.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: [
                    ReusableButton(
                      text: AppStrings.cashPayment,
                      type: ButtonType.tonal,
                      prefixIcon: Icons.payments_rounded,
                      onPressed: () => _recordCashPayment(bloc),
                    ),
                    ReusableButton(
                      text: AppStrings.additionNotice,
                      type: ButtonType.tonal,
                      prefixIcon: Icons.add_circle_rounded,
                      onPressed: () => _recordAddition(bloc),
                    ),
                    ReusableButton(
                      text: AppStrings.discountNotice,
                      type: ButtonType.tonal,
                      prefixIcon: Icons.remove_circle_rounded,
                      onPressed: () => _recordDiscount(bloc),
                    ),
                    ReusableButton(
                      text: AppStrings.checkPayment,
                      type: ButtonType.tonal,
                      prefixIcon: Icons.account_balance_rounded,
                      onPressed: () => _showCheckFields(context, bloc, true),
                    ),
                    ReusableButton(
                      text: AppStrings.checkReceipt,
                      type: ButtonType.tonal,
                      prefixIcon: Icons.account_balance_wallet_rounded,
                      onPressed: () => _showCheckFields(context, bloc, false),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.lg.h),
                const SectionHeader(icon: Icons.history_rounded, title: AppStrings.recentLedgerEntries),
                SizedBox(height: AppSpacing.sm.h),
                if (state.ledgerEntries.isEmpty)
                  const ReusableStateView.empty(message: AppStrings.noLedgerEntries, compact: true)
                else
                  SizedBox(
                    height: 350.h,
                    child: ListView.separated(
                      itemCount: state.ledgerEntries.length,
                      separatorBuilder: (_, index) => Divider(height: 1, color: scheme.outline.withValues(alpha: 0.1)),
                      itemBuilder: (_, i) {
                        final e = state.ledgerEntries[i];
                        return ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 4.w),
                          title: ReusableText(e.type.label, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: ReusableText(
                            DateFormat('yyyy-MM-dd HH:mm').format(e.entryDate),
                            style: TextStyle(fontSize: 10.sp, color: scheme.onSurfaceVariant),
                          ),
                          trailing: ReusableText(
                            '${f.format(e.debit > 0 ? e.debit : -e.credit)} ${AppStrings.currency}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: e.debit > 0 ? AppColors.error : AppColors.success,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  void _recordCashPayment(SuppliersBloc bloc) {
    final amount = double.tryParse(amountCtrl.text);
    if (amount == null || amount <= 0) {
      AppSnackbar.error(AppStrings.invalidAmount);
      return;
    }
    bloc.add(RecordCashPayment(
      supplierId: bloc.state.selectedSupplier!.id,
      amount: amount,
      notes: notesCtrl.text.isEmpty ? null : notesCtrl.text,
    ));
    amountCtrl.clear();
    notesCtrl.clear();
  }

  void _recordAddition(SuppliersBloc bloc) {
    final amount = double.tryParse(amountCtrl.text);
    if (amount == null || amount <= 0) {
      AppSnackbar.error(AppStrings.invalidAmount);
      return;
    }
    bloc.add(RecordSupplierAdditionNotice(
      supplierId: bloc.state.selectedSupplier!.id,
      amount: amount,
      notes: notesCtrl.text.isEmpty ? null : notesCtrl.text,
    ));
    amountCtrl.clear();
    notesCtrl.clear();
  }

  void _recordDiscount(SuppliersBloc bloc) {
    final amount = double.tryParse(amountCtrl.text);
    if (amount == null || amount <= 0) {
      AppSnackbar.error(AppStrings.invalidAmount);
      return;
    }
    bloc.add(RecordSupplierDiscountNotice(
      supplierId: bloc.state.selectedSupplier!.id,
      amount: amount,
      notes: notesCtrl.text.isEmpty ? null : notesCtrl.text,
    ));
    amountCtrl.clear();
    notesCtrl.clear();
  }

  void _showCheckFields(BuildContext context, SuppliersBloc bloc, bool isPayment) {
    final amountValue = double.tryParse(amountCtrl.text);
    if (amountValue == null || amountValue <= 0) {
      AppSnackbar.error(AppStrings.enterCorrectAmountFirstError);
      return;
    }
    showDialog(
      context: context,
      builder: (context) => ReusableDialog(
        title: isPayment ? AppStrings.checkPaymentDataTitle : AppStrings.checkReceiptDataTitle,
        headerIcon: const Icon(Icons.account_balance_rounded),
        footerActions: [
          DialogActions(
            confirmText: AppStrings.confirmOperationAction,
            onConfirm: () {
              Navigator.pop(context);
              if (isPayment) {
                bloc.add(RecordSupplierCheckPayment(
                  supplierId: bloc.state.selectedSupplier!.id,
                  amount: amountValue,
                  checkNumber: checkNoCtrl.text.isEmpty ? null : checkNoCtrl.text,
                  bankName: bankCtrl.text.isEmpty ? null : bankCtrl.text,
                  dueDate: dueDateCtrl.text.isEmpty ? null : dueDateCtrl.text,
                  notes: notesCtrl.text.isEmpty ? null : notesCtrl.text,
                ));
              } else {
                bloc.add(RecordSupplierCheckReceipt(
                  supplierId: bloc.state.selectedSupplier!.id,
                  amount: amountValue,
                  checkNumber: checkNoCtrl.text.isEmpty ? null : checkNoCtrl.text,
                  bankName: bankCtrl.text.isEmpty ? null : bankCtrl.text,
                  dueDate: dueDateCtrl.text.isEmpty ? null : dueDateCtrl.text,
                  notes: notesCtrl.text.isEmpty ? null : notesCtrl.text,
                ));
              }
              amountCtrl.clear();
              notesCtrl.clear();
              checkNoCtrl.clear();
              bankCtrl.clear();
              dueDateCtrl.clear();
            },
          ),
        ],
        children: [
          ReusableInput(
            controller: checkNoCtrl,
            label: AppStrings.checkNumber,
            textDirection: TextDirection.rtl,
          ),
          SizedBox(height: AppSpacing.sm.h),
          ReusableInput(
            controller: bankCtrl,
            label: AppStrings.bankName,
            textDirection: TextDirection.rtl,
          ),
          SizedBox(height: AppSpacing.sm.h),
          ReusableInput(
            controller: dueDateCtrl,
            label: AppStrings.dueDate,
            hint: AppStrings.dueDateHint,
          ),
        ],
      ),
    );
  }
}


