import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pharmacy_system/app/shared/ui_core.dart';
import 'package:pharmacy_system/app/core/models/contacts/customer_model.dart';
import 'package:pharmacy_system/app/core/data/services/operations/export_service.dart';
import '../../../../../routes/app_routes.dart';
import '../bloc/customers_bloc.dart';
import '../bloc/customers_state.dart';
import '../bloc/customers_event.dart';

class CustomersListView extends StatelessWidget {
  const CustomersListView({super.key});

  @override
  Widget build(BuildContext context) {
    return const _CustomersBody();
  }
}

class _CustomersBody extends StatelessWidget {
  const _CustomersBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomersBloc, CustomersState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const HomeShell(
            title: CustomersStrings.customersTitle,
            child: Center(child: LoadingIndicator()),
          );
        }
        if (state.errorMessage != null) {
          return HomeShell(
            title: CustomersStrings.customersTitle,
            child: ReusableStateView(
              message: state.errorMessage ?? CustomersStrings.errorLoadingCustomers,
              action: ReusableButton(
                text: GeneralStrings.refresh,
                onPressed: () => context.read<CustomersBloc>().add(const LoadCustomers()),
              ),
            ),
          );
        }

        return StandardModuleLayout(
          title: CustomersStrings.customersTitle,
          actions: _buildActions(context),
          stats: _buildStats(state),
          filters: _buildFilters(context),
          content: _buildTable(context, state),
        );
      },
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    final bloc = context.read<CustomersBloc>();
    return [
      ReusableButton(
        text: CustomersStrings.addCustomer,
        prefixIcon: Icons.add_rounded,
        onPressed: () => context.push(Routes.CUSTOMER_ADD),
      ),
      ReusableButton(
        text: GeneralStrings.export,
        prefixIcon: Icons.download_rounded,
        type: ButtonType.outlined,
        onPressed: () => bloc.add(const ExportCustomers()),
      ),
      ReusableButton(
        text: 'استيراد من Excel',
        prefixIcon: Icons.file_upload_rounded,
        type: ButtonType.outlined,
        onPressed: () => context.push(Routes.CUSTOMERS_IMPORT),
      ),
    ];
  }

  List<Widget> _buildStats(CustomersState state) {
    return [
      SummaryCard(
        icon: Icons.people_alt,
        label: CustomersStrings.totalCustomers,
        value: '${state.allCustomers.length}',
      ),
      SummaryCard(
        icon: Icons.check_circle_outline,
        label: GeneralStrings.active,
        value: '${state.activeCustomerCount}',
        color: AppColors.success,
      ),
      SummaryCard(
        icon: Icons.monetization_on_outlined,
        label: CustomersStrings.totalDebt,
        value: '${state.totalBalance.toStringAsFixed(0)} ${GeneralStrings.currency}',
        color: AppColors.warning,
      ),
    ];
  }

  Widget _buildFilters(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.all(AppSpacing.md.w),
      child: ReusableInput(
        hint: CustomersStrings.searchCustomerHintInput,
        prefixIcon: const Icon(Icons.search_rounded, size: 20),
        showClearButton: true,
        onChanged: (q) => context.read<CustomersBloc>().add(SearchCustomers(q)),
        onClear: () => context.read<CustomersBloc>().add(const SearchCustomers('')),
      ),
    );
  }

  Widget _buildTable(BuildContext context, CustomersState state) {
    final bloc = context.read<CustomersBloc>();

    final columns = [
      ReusableTableColumn<CustomerModel>(
        id: 'name',
        title: CustomersStrings.customerTitle,
        flex: 1,
        isSortable: true,
        cellBuilder: (c) => TableContactNameCell(
          name: c.name,
          subtitle: c.kindName,
          icon: c.kind == CustomerKind.cash ? Icons.money_rounded : Icons.person_rounded,
          iconColor: c.isActive ? AppColors.success : AppColors.error,
        ),
      ),
      ReusableTableColumn<CustomerModel>(
        id: 'phone',
        title: GeneralStrings.phone,
        width: 130.w,
        textBuilder: (c) => c.phone ?? '-',
      ),
      ReusableTableColumn<CustomerModel>(
        id: 'company',
        title: GeneralStrings.company,
        width: 150.w,
        textBuilder: (c) => c.companyName ?? '-',
      ),
      ReusableTableColumn<CustomerModel>(
        id: 'balance',
        title: GeneralStrings.balance,
        width: 120.w,
        isSortable: true,
        isNumeric: true,
        cellBuilder: (c) {
          final balance = state.balances[c.id] ?? 0;
          return TableMoneyCell(
            amount: balance,
            currency: GeneralStrings.currency,
            isNegative: balance > 0,
          );
        },
      ),
      ReusableTableColumn<CustomerModel>(
        id: 'creditLimit',
        title: CustomersStrings.creditLimit,
        width: 120.w,
        isSortable: true,
        isNumeric: true,
        textBuilder: (c) => c.creditLimit > 0 ? '${c.creditLimit.toStringAsFixed(0)} ${GeneralStrings.currency}' : '-',
      ),
      ReusableTableColumn<CustomerModel>(
        id: 'discount',
        title: GeneralStrings.discount,
        width: 80.w,
        isSortable: true,
        isNumeric: true,
        textBuilder: (c) => '${c.discountPercent.toStringAsFixed(1)}%',
      ),
      ReusableTableColumn<CustomerModel>(
        id: 'status',
        title: GeneralStrings.status,
        width: 90.w,
        isSortable: true,
        cellBuilder: (c) => StatusBadge(
          label: c.isActive ? GeneralStrings.active : CustomersStrings.inactiveLabel,
          color: c.isActive ? AppColors.success : AppColors.error,
        ),
      ),
    ];

    return ReusableTable<CustomerModel>(
      columns: columns,
      items: state.pagedCustomers,
      sortColumnId: state.sortColumnId,
      isSortAscending: state.isSortAscending,
      onSort: (col) {
        final ascending = col == state.sortColumnId ? !state.isSortAscending : true;
        bloc.add(UpdateSort(col, ascending));
      },
      onTapRow: (c) => _showLedgerDialog(context, c),
      rowIdGetter: (c) => c.id,
      showCheckbox: true,
      selectedIds: state.selectedIds,
      onSelectRow: (id) => bloc.add(ToggleSelectCustomer(id)),
      onToggleAll: (v) => bloc.add(ToggleSelectAllCustomers(v)),
      showToolbar: true,
      onExportExcel: () => bloc.add(const ExportCustomers()),
      onSearchChanged: (q) => bloc.add(SearchCustomers(q)),
      bulkActions: _buildBulkActions(context, bloc, state),
      itemLabel: CustomersStrings.customerItemLabel,
      currentPage: state.currentPage + 1,
      totalPages: state.totalPages,
      totalItems: state.filteredCustomers.length,
      pageSize: state.currentPageSize,
      pageSizeOptions: const [10, 20, 30, 50, 100],
      onPageSizeChanged: (size) => bloc.add(ChangePageSize(size)),
      onNextPage: () => bloc.add(const NextPage()),
      onPreviousPage: () => bloc.add(const PreviousPage()),
      rowActions: (c) => _buildRowActions(context, bloc, c),
    );
  }

  List<Widget> _buildBulkActions(BuildContext context, CustomersBloc bloc, CustomersState state) {
    return [
      ReusableButton(
        text: GeneralStrings.delete,
        type: ButtonType.outlined,
        color: AppColors.error,
        prefixIcon: Icons.delete_outline_rounded,
        onPressed: () => ConfirmDeleteDialog.show(
          context,
          title: 'حذف العملاء',
          message: 'هل أنت متأكد من حذف ${state.selectedIds.length} من العملاء؟',
          onConfirm: () => bloc.add(const BulkDeleteCustomers()),
        ),
      ),
      ReusableButton(
        text: CustomersStrings.deactivate,
        type: ButtonType.outlined,
        color: AppColors.warning,
        prefixIcon: Icons.block_flipped,
        onPressed: () => bloc.add(const BulkToggleCustomersActive(false)),
      ),
      ReusableButton(
        text: CustomersStrings.activate,
        type: ButtonType.outlined,
        color: AppColors.success,
        prefixIcon: Icons.check_circle_outline_rounded,
        onPressed: () => bloc.add(const BulkToggleCustomersActive(true)),
      ),
    ];
  }

  Widget _buildRowActions(BuildContext context, CustomersBloc bloc, CustomerModel c) {
    return TableOptionsButton(
      onSelected: (v) {
        switch (v) {
          case 'edit': _showEditCustomerDialog(context, c); break;
          case 'toggle': bloc.add(ToggleCustomerActive(c.id)); break;
          case 'delete':
            ConfirmDeleteDialog.show(
              context,
              title: CustomersStrings.deleteCustomer,
              message: CustomersStrings.deleteCustomerConfirmMessageFormat.replaceFirst('%s', c.name),
              onConfirm: () => bloc.add(DeleteCustomer(c.id)),
            );
            break;
          case 'ledger': _showLedgerDialog(context, c); break;
        }
      },
      menuItems: [
        const PopupMenuItem(value: 'ledger', child: ReusableText(CustomersStrings.ledgerTitle)),
        const PopupMenuItem(value: 'edit', child: ReusableText(GeneralStrings.edit)),
        PopupMenuItem(value: 'toggle', child: ReusableText(c.isActive ? CustomersStrings.deactivate : CustomersStrings.activate)),
        PopupMenuItem(value: 'delete', child: ReusableText(GeneralStrings.delete, color: AppColors.error)),
      ],
    );
  }

  // --- Ledger Dialog ---

  void _showLedgerDialog(BuildContext context, CustomerModel customer) {
    final bloc = context.read<CustomersBloc>();
    bloc.add(LoadLedger(customer.id));

    showDialog(
      context: context,
      builder: (context) => BlocProvider.value(
        value: bloc,
        child: BlocBuilder<CustomersBloc, CustomersState>(
          builder: (context, state) {
            if (state.isLoadingLedger) {
              return const LoadingIndicator();
            }
            return _LedgerDialogContent(customer: customer);
          },
        ),
      ),
      barrierColor: Colors.black54,
    );
  }

  // --- Edit Customer Dialog ---

  void _showEditCustomerDialog(BuildContext context, CustomerModel customer) {
    final nameCtrl = TextEditingController(text: customer.name);
    final phoneCtrl = TextEditingController(text: customer.phone ?? '');
    final companyCtrl = TextEditingController(text: customer.companyName ?? '');
    final emailCtrl = TextEditingController(text: customer.email ?? '');
    final taxCtrl = TextEditingController(text: customer.taxId ?? '');
    final addressCtrl = TextEditingController(text: customer.address ?? '');
    final notesCtrl = TextEditingController(text: customer.notes ?? '');
    final creditLimitCtrl = TextEditingController(text: customer.creditLimit.toString());
    final discountCtrl = TextEditingController(text: customer.discountPercent.toString());
    final paymentDaysCtrl = TextEditingController(text: customer.paymentTermDays.toString());
    var kind = customer.kind;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => ReusableDialog(
          maxWidth: 450,
          title: CustomersStrings.editCustomer,
          headerIcon: const Icon(Icons.edit_rounded),
          footerActions: [
            DialogActions(
              confirmText: GeneralStrings.save,
              onConfirm: () async {
                if (nameCtrl.text.trim().isEmpty) return;
                context.read<CustomersBloc>().add(
                  UpdateCustomer(
                    customer.copyWith(
                      name: nameCtrl.text.trim(),
                      kind: kind,
                      phone: phoneCtrl.text.trim().nullIfEmpty,
                      companyName: companyCtrl.text.trim().nullIfEmpty,
                      email: emailCtrl.text.trim().nullIfEmpty,
                      taxId: taxCtrl.text.trim().nullIfEmpty,
                      address: addressCtrl.text.trim().nullIfEmpty,
                      notes: notesCtrl.text.trim().nullIfEmpty,
                      creditLimit: double.tryParse(creditLimitCtrl.text) ?? 0,
                      discountPercent: double.tryParse(discountCtrl.text) ?? 0,
                      paymentTermDays: int.tryParse(paymentDaysCtrl.text) ?? 0,
                    ),
                  ),
                );
                Navigator.pop(context);
              },
            ),
          ],
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ReusableInput(
                    label: '${GeneralStrings.name} *',
                    hint: CustomersStrings.customerNameHint,
                    controller: nameCtrl,
                  ),
                  SizedBox(height: AppSpacing.sm.h),
                  ReusableDropdown<CustomerKind>(
                    labelText: GeneralStrings.type,
                    hintText: CustomersStrings.selectType,
                    items: const [CustomerKind.regular, CustomerKind.cash],
                    value: kind,
                    itemAsString: (k) => k == CustomerKind.regular ? GeneralStrings.enumCustomerRegular : GeneralStrings.enumCustomerCash,
                    onChanged: (v) {
                      if (v != null) setState(() => kind = v);
                    },
                  ),
                  SizedBox(height: AppSpacing.sm.h),
                  ReusableInput(
                    label: GeneralStrings.phone,
                    controller: phoneCtrl,
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: AppSpacing.sm.h),
                  ReusableInput(
                    label: GeneralStrings.company,
                    controller: companyCtrl,
                  ),
                  SizedBox(height: AppSpacing.sm.h),
                  ReusableInput.email(
                    label: AuthStrings.emailLabel,
                    controller: emailCtrl,
                  ),
                  SizedBox(height: AppSpacing.sm.h),
                  ReusableInput(
                    label: CustomersStrings.taxIdLabel,
                    controller: taxCtrl,
                  ),
                  SizedBox(height: AppSpacing.sm.h),
                  ReusableInput(
                    label: CustomersStrings.address,
                    controller: addressCtrl,
                  ),
                  SizedBox(height: AppSpacing.sm.h),
                  ReusableInput(
                    label: CustomersStrings.creditLimit,
                    controller: creditLimitCtrl,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: AppSpacing.sm.h),
                  Row(
                    children: [
                      Expanded(
                        child: ReusableInput(
                          label: '${GeneralStrings.discount} %',
                          controller: discountCtrl,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(width: AppSpacing.sm.w),
                      Expanded(
                        child: ReusableInput(
                          label: '${CustomersStrings.paymentTerm} (${CustomersStrings.daySuffix})',
                          controller: paymentDaysCtrl,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.sm.h),
                  ReusableInput(
                    label: SuppliersStrings.notesLabel,
                    controller: notesCtrl,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      barrierColor: Colors.black54,
    ).whenComplete(() {
      nameCtrl.dispose();
      phoneCtrl.dispose();
      companyCtrl.dispose();
      emailCtrl.dispose();
      taxCtrl.dispose();
      addressCtrl.dispose();
      notesCtrl.dispose();
      creditLimitCtrl.dispose();
      discountCtrl.dispose();
      paymentDaysCtrl.dispose();
    });
  }
}


// --- Ledger Dialog Content ---

class _LedgerDialogContent extends StatelessWidget {
  final CustomerModel customer;
  const _LedgerDialogContent({required this.customer});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomersBloc, CustomersState>(
      builder: (context, state) {
        final bloc = context.read<CustomersBloc>();
        final scheme = Theme.of(context).colorScheme;

        return Center(
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(maxWidth: 700.w, maxHeight: 0.85.sh),
            margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: BorderRadius.circular(AppRadius.dialog),
              border: Border.all(color: AppColors.borderOf(context).withValues(alpha: 0.25)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(AppSpacing.md.w),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.3))),
                  ),
                  child: Wrap(
                    spacing: AppSpacing.md.w,
                    runSpacing: AppSpacing.sm.h,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.success.withValues(alpha: 0.15),
                        child: const Icon(Icons.person_rounded, color: AppColors.success),
                      ),
                      SizedBox(
                        width: 300.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ReusableText(customer.displayName, style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.bold)),
                            ReusableText(
                              [customer.identityPhone, customer.identityEmail, customer.identityAddress]
                                .where((s) => s.isNotEmpty).join(' • '),
                              style: AppTextStyles.caption(context).copyWith(color: scheme.onSurfaceVariant),
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                      if (customer.creditLimit > 0)
                        InfoChip(
                          icon: Icons.credit_card_rounded,
                          label: '${CustomersStrings.creditLimit}: ${customer.creditLimit.toStringAsFixed(0)} ${GeneralStrings.currency}',
                          color: AppColors.info,
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(AppSpacing.sm.w),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.2))),
                  ),
                  child: Wrap(
                    spacing: AppSpacing.sm.w,
                    runSpacing: AppSpacing.sm.h,
                    children: [
                  ReusableButton(
                    text: CustomersStrings.cashReceipt,
                    prefixIcon: Icons.payments_rounded,
                    onPressed: () {
                      PaymentDialog.show(
                        context,
                        title: '${CustomersStrings.cashReceipt} - ${customer.name}',
                        onSubmit: (amount, notes) async {
                          bloc.add(RecordCashReceipt(customerId: customer.id, amount: amount, notes: notes));
                        },
                      );
                    },
                  ),
                  ReusableButton(
                    text: SuppliersStrings.additionNotice,
                    prefixIcon: Icons.add_circle_rounded,
                    onPressed: () {
                      _showAdjustmentDialog(context, bloc, customer, isAddition: true);
                    },
                  ),
                  ReusableButton(
                    text: SuppliersStrings.discountNotice,
                    prefixIcon: Icons.remove_circle_rounded,
                    onPressed: () {
                      _showAdjustmentDialog(context, bloc, customer, isAddition: false);
                    },
                  ),
                  ReusableButton(
                    text: SuppliersStrings.checkReceipt,
                    prefixIcon: Icons.account_balance_rounded,
                    onPressed: () {
                      _showCheckDialog(context, bloc, customer, isReceipt: true);
                    },
                  ),
                  ReusableButton(
                    text: GeneralStrings.update,
                    prefixIcon: Icons.refresh_rounded,
                    type: ButtonType.outlined,
                    onPressed: () {
                      bloc.add(LoadLedger(customer.id));
                    },
                  ),

                      PopupMenuButton<String>(
                        icon: Icon(Icons.download_rounded, size: AppIconSize.md.value, color: scheme.primary),
                        onSelected: (format) async {
                          try {
                            if (format == 'xlsx') {
                              await ExportService.exportCustomerLedgerToXlsx(entries: state.ledgerEntries, customerName: customer.name);
                            } else {
                              await ExportService.exportCustomerLedgerToHtml(entries: state.ledgerEntries, customerName: customer.name);
                            }
                            AppSnackbar.success(CustomersStrings.exportSuccess);
                          } catch (e) {
                            AppSnackbar.error(CustomersStrings.exportLedgerFailedFormat.replaceFirst('%s', e.toString()));
                          }
                        },
                          itemBuilder: (_) => [
                            const PopupMenuItem(value: 'xlsx', child: ReusableText('${GeneralStrings.export} Excel')),
                            const PopupMenuItem(value: 'html', child: ReusableText('${GeneralStrings.export} HTML')),
                          ],

                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: state.ledgerEntries.isEmpty
                          ? const EmptyState(
                              icon: Icons.account_balance_wallet_outlined,
                              title: CustomersStrings.noFinancialMovements,
                            )

                      : ListView(
                          padding: EdgeInsets.all(AppSpacing.sm.w),
                          children: [
                            _ledgerTableHeader(scheme, context),
                            ...state.ledgerEntries.reversed.map((e) => _ledgerRow(e, scheme, context)),
                          ],
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _ledgerTableHeader(ColorScheme scheme, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
      decoration: BoxDecoration(color: scheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(AppRadius.button.r)),
      child: Row(
        children: [
          _cell(GeneralStrings.date, context, flex: 2),
          _cell(SuppliersStrings.notesLabel, context, flex: 3),
          _cell(ExportStrings.exportColumnDebit, context, flex: 2, align: TextAlign.center),
          _cell(ExportStrings.exportColumnCredit, context, flex: 2, align: TextAlign.center),
          _cell(GeneralStrings.balance, context, flex: 2, align: TextAlign.center),
        ],
      ),
    );
  }

  Widget _ledgerRow(ContactLedgerModel entry, ColorScheme scheme, BuildContext context) {
    final typeLabel = switch (entry.type) {
      CustomerLedgerEntryType.saleInvoice => CustomersStrings.saleInvoice,
      CustomerLedgerEntryType.saleReturn => CustomersStrings.saleReturn,
      CustomerLedgerEntryType.customerPayment => CustomersStrings.customerPayment,
      CustomerLedgerEntryType.saleVoid => CustomersStrings.saleVoid,
      CustomerLedgerEntryType.openingBalance => CustomersStrings.openingBalance,
      CustomerLedgerEntryType.manualAdjustment => CustomersStrings.manualAdjustment,
      CustomerLedgerEntryType.additionNotice => SuppliersStrings.additionNotice,
      CustomerLedgerEntryType.discountNotice => SuppliersStrings.discountNotice,
      CustomerLedgerEntryType.checkReceipt => SuppliersStrings.checkReceipt,
      CustomerLedgerEntryType.checkPayment => SuppliersStrings.checkPayment,
    };
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.2)))),
      child: Row(
        children: [
          _cell('${entry.entryDate.day}/${entry.entryDate.month}', context, flex: 2),
          _cell('$typeLabel${entry.referenceNumber != null ? '\n#${entry.referenceNumber}' : ''}', context, flex: 3),
          _cell(entry.debit > 0 ? entry.debit.toStringAsFixed(2) : '-', context, flex: 2, align: TextAlign.center),
          _cell(entry.credit > 0 ? entry.credit.toStringAsFixed(2) : '-', context, flex: 2, align: TextAlign.center),
          _cell(
            entry.balanceAfter.toStringAsFixed(2),
            context,
            flex: 2,
            align: TextAlign.center,
            color: entry.balanceAfter > 0 ? AppColors.warning : AppColors.success,
          ),
        ],
      ),
    );
  }

  Widget _cell(String text, BuildContext context, {int flex = 1, TextAlign align = TextAlign.start, Color? color}) {
    return Expanded(
      flex: flex,
      child: ReusableText(
        text,
        style: AppTextStyles.caption(context).copyWith(color: color),
        textAlign: align,
      ),
    );
  }
}

// --- Adjustment Dialog ---

void _showAdjustmentDialog(
  BuildContext context,
  CustomersBloc bloc,
  CustomerModel customer, {
  required bool isAddition,
}) {
  final amountCtrl = TextEditingController();
  final notesCtrl = TextEditingController();

  showDialog(
    context: context,
    builder: (context) => ReusableDialog(
      title: '${isAddition ? SuppliersStrings.additionNotice : SuppliersStrings.discountNotice} - ${customer.name}',
      headerIcon: Icon(
        isAddition ? Icons.add_circle_rounded : Icons.remove_circle_rounded,
        color: isAddition ? AppColors.success : AppColors.warning,
          ),
          footerActions: [
            DialogActions(
              confirmText: GeneralStrings.confirm,
              onConfirm: () {
                final amount = double.tryParse(amountCtrl.text);
                if (amount == null || amount <= 0) {
                  AppSnackbar.error(CustomersStrings.invalidAmount);
                  return;
                }
                if (isAddition) {

              bloc.add(
                RecordAdditionNotice(
                  customerId: customer.id,
                  amount: amount,
                  notes: notesCtrl.text.trim().nullIfEmpty,
                ),
              );
            } else {
              bloc.add(
                RecordDiscountNotice(
                  customerId: customer.id,
                  amount: amount,
                  notes: notesCtrl.text.trim().nullIfEmpty,
                ),
              );
            }
            Navigator.pop(context);
          },
        ),
      ],
      children: [
        ReusableInput(
          label: '${GeneralStrings.amount} *',
          hint: '0.00',
          controller: amountCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        SizedBox(height: AppSpacing.md.h),
        ReusableInput(
          label: SuppliersStrings.notesLabel,
          controller: notesCtrl,
          maxLines: 2,
        ),
      ],
    ),
    barrierColor: Colors.black54,
  ).whenComplete(() {
    amountCtrl.dispose();
    notesCtrl.dispose();
  });
}

// --- Check Dialog ---

void _showCheckDialog(
  BuildContext context,
  CustomersBloc bloc,
  CustomerModel customer, {
  required bool isReceipt,
}) {
  final amountCtrl = TextEditingController();
  final checkNumberCtrl = TextEditingController();
  final bankNameCtrl = TextEditingController();
  final dueDateCtrl = TextEditingController();
  final notesCtrl = TextEditingController();

  showDialog(
    context: context,
    builder: (context) => ReusableDialog(
      title: '${isReceipt ? SuppliersStrings.checkReceipt : SuppliersStrings.checkPayment} - ${customer.name}',
      headerIcon: const Icon(
        Icons.account_balance_rounded,
        color: AppColors.primary,
      ),
          footerActions: [
            DialogActions(
              confirmText: GeneralStrings.confirm,
              onConfirm: () {
                final amount = double.tryParse(amountCtrl.text);
                if (amount == null || amount <= 0) {
                  AppSnackbar.error(CustomersStrings.invalidAmount);
                  return;
                }

            if (isReceipt) {
              bloc.add(
                RecordCheckReceipt(
                  customerId: customer.id,
                  amount: amount,
                  checkNumber: checkNumberCtrl.text.trim().nullIfEmpty,
                  bankName: bankNameCtrl.text.trim().nullIfEmpty,
                  dueDate: dueDateCtrl.text.trim().nullIfEmpty,
                  notes: notesCtrl.text.trim().nullIfEmpty,
                ),
              );
            } else {
              bloc.add(
                RecordCheckPayment(
                  customerId: customer.id,
                  amount: amount,
                  checkNumber: checkNumberCtrl.text.trim().nullIfEmpty,
                  bankName: bankNameCtrl.text.trim().nullIfEmpty,
                  dueDate: dueDateCtrl.text.trim().nullIfEmpty,
                  notes: notesCtrl.text.trim().nullIfEmpty,
                ),
              );
            }
            Navigator.pop(context);
          },
        ),
      ],
      children: [
        ReusableInput(
          label: '${GeneralStrings.amount} *',
          hint: '0.00',
          controller: amountCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        SizedBox(height: AppSpacing.sm.h),
        ReusableInput(
          label: CustomersStrings.checkNumber,
          controller: checkNumberCtrl,
        ),
        SizedBox(height: AppSpacing.sm.h),
        ReusableInput(
          label: CustomersStrings.bankName,
          controller: bankNameCtrl,
        ),
        SizedBox(height: AppSpacing.sm.h),
        ReusableInput(
          label: CustomersStrings.dueDate,
          controller: dueDateCtrl,
          hint: 'YYYY-MM-DD',
        ),
        SizedBox(height: AppSpacing.sm.h),
        ReusableInput(
          label: SuppliersStrings.notesLabel,
          controller: notesCtrl,
          maxLines: 2,
        ),
      ],
    ),
    barrierColor: Colors.black54,
  ).whenComplete(() {
    amountCtrl.dispose();
    checkNumberCtrl.dispose();
    bankNameCtrl.dispose();
    dueDateCtrl.dispose();
    notesCtrl.dispose();
  });
}
