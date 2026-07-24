import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' hide TextDirection;

import 'package:pharmacy_system/app/core/models/sales/sale_invoice_model.dart';
import 'package:pharmacy_system/app/core/models/sales/return_model.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_colors.dart';
import '../../../core/utils/format_utils.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/index.dart';
import '../../../core/injection.dart';
import 'package:pharmacy_system/app/core/data/services/admin/branch_data_service.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import '../bloc/sales_return_bloc.dart';
import '../bloc/sales_return_event.dart';
import '../bloc/sales_return_state.dart';

class SalesReturnView extends StatelessWidget {
  const SalesReturnView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return BlocProvider.value(
      value: sl<SalesReturnBloc>()..add(const LoadSalesReturns()),
      child: HomeShell(
        title: SalesStrings.salesReturnsTitle,
        child: Container(
          color: scheme.surfaceContainerLow.withValues(alpha: 0.15),
          padding: EdgeInsets.all(AppSpacing.xl.w),
          child: BlocBuilder<SalesReturnBloc, SalesReturnState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(context, state),
                  SizedBox(height: AppSpacing.lg.h),
                  _buildFilters(context, state),
                  SizedBox(height: AppSpacing.md.h),
                  Expanded(child: _buildList(context, state)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, SalesReturnState state) {
    return Row(
      children: [
        ReusableButton(
          text: GeneralStrings.add,
          prefixIcon: Icons.add_rounded,
          color: AppColors.homeSales,
          onPressed: () => _showCreateReturnDialog(context),
        ),
        const Spacer(),
        ReusableButton(
          text: GeneralStrings.back,
          type: ButtonType.outlined,
          prefixIcon: Icons.arrow_back_rounded,
          onPressed: () => context.pop(),
        ),
      ],
    );
  }

  Widget _buildFilters(BuildContext context, SalesReturnState state) {
    final scheme = Theme.of(context).colorScheme;
    return AppCard(
      padding: EdgeInsets.all(AppSpacing.xl.w),
      child: Column(
        children: [
          Row(
            children: [
              SummaryCard(
                label: '?????? ??????? ?????',
                value: '${state.totalCount}',
                color: scheme.primary,
                icon: Icons.assignment_return_rounded,
                minWidth: 160.w,
              ),
              SizedBox(width: AppSpacing.md.w),
              SummaryCard(
                label: '?????? ??????? ????????',
                value: formatMoney(state.totalReturned),
                color: AppColors.error,
                icon: Icons.money_off_rounded,
                minWidth: 200.w,
              ),
              const Spacer(),
              const DateRangePicker(),
            ],
          ),
          SizedBox(height: AppSpacing.lg.h),
          Row(
            children: [
              FilterDropdown.string(
                label: SalesStrings.customerNameLabel,
                items: ['????'],
                onChanged: (v) {},
              ),
              SizedBox(width: AppSpacing.md.w),
              FilterDropdown.string(
                label: PurchasesStrings.reasonLabel,
                items: ['????', '????? ????????', '????', '??? ?? ?????'],
                onChanged: (v) {},
              ),
              SizedBox(width: AppSpacing.md.w),
              FilterDropdown.string(
                label: '??????',
                items: ['????'],
                onChanged: (v) {},
              ),
              SizedBox(width: AppSpacing.md.w),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context, SalesReturnState state) {
    final scheme = Theme.of(context).colorScheme;

    if (state.status == SalesReturnStatus.loading && state.returns.isEmpty) return const LoadingIndicator();

    final items = state.filteredReturns;
    final totalAmount = items.fold(0.0, (sum, r) => sum + r.totalAmount);

    final columns = [
      ReusableTableColumn<ReturnModel>(
        id: 'actions',
        title: '????',
        width: 100.w,
        cellBuilder: (r) => _buildRowActions(context, r),
      ),
      ReusableTableColumn<ReturnModel>(
        id: 'date',
        title: GeneralStrings.date,
        width: 160.w,
        isSortable: true,
        textBuilder: (r) => DateFormat('yyyy/MM/dd HH:mm').format(r.createdAt),
      ),
      ReusableTableColumn<ReturnModel>(
        id: 'id',
        title: '??? ???????',
        width: 120.w,
        isSortable: true,
        textBuilder: (r) => '#${r.id.substring(0, 8).toUpperCase()}',
      ),
      ReusableTableColumn<ReturnModel>(
        id: 'saleId',
        title: '???????? ???????',
        width: 120.w,
        textBuilder: (r) => r.saleId != null ? '#${r.saleId!.substring(0, 8).toUpperCase()}' : '---',
      ),
      ReusableTableColumn<ReturnModel>(
        id: 'customer',
        title: '??????',
        flex: 2,
        textBuilder: (r) {
          if (r.saleId != null) {
            final s = BranchDataService.getSale(r.saleId!);
            if (s != null) return s.customerName ?? SalesStrings.cashCustomer;
          }
          return '??? ????';
        },
      ),
      ReusableTableColumn<ReturnModel>(
        id: 'reason',
        title: PurchasesStrings.reasonLabel,
        width: 130.w,
        cellBuilder: (r) {
          final label = switch (r.reason) {
            ReturnReason.expired => PurchasesStrings.reasonExpired,
            ReturnReason.damaged => PurchasesStrings.reasonDamaged,
            ReturnReason.wrongItem => PurchasesStrings.reasonWrongItem,
            _ => PurchasesStrings.reasonOther,
          };
          return StatusBadge(label: label, color: AppColors.warning);
        },
      ),
      ReusableTableColumn<ReturnModel>(
        id: 'amount',
        title: '?????? ?????????',
        width: 140.w,
        isNumeric: true,
        textBuilder: (r) => formatMoney(r.totalAmount),
      ),
      ReusableTableColumn<ReturnModel>(
        id: 'qty',
        title: SalesStrings.quantityLabel,
        width: 80.w,
        isNumeric: true,
        textBuilder: (r) => '${r.items.length}.00',
      ),
      ReusableTableColumn<ReturnModel>(
        id: 'added_by',
        title: SalesStrings.addedBy,
        width: 120.w,
        textBuilder: (r) => '???????',
      ),
    ];

    return Column(
      children: [
        _buildTableToolbar(context, state),
        Expanded(
          child: ReusableTable<ReturnModel>(
            columns: columns,
            items: items,
            itemLabel: '????? ??????',
            bodyRowHeight: 56.h,
            tableFooter: Container(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              decoration: BoxDecoration(
                color: scheme.surface,
                border: Border(top: BorderSide(color: scheme.outlineVariant, width: 2)),
              ),
              child: Row(
                children: [
                  SizedBox(width: 100.w), // actions
                  SizedBox(width: 160.w), // date
                  SizedBox(width: 120.w), // id
                  SizedBox(width: 120.w), // saleId
                  Expanded(flex: 2, child: const SizedBox()), // customer
                  SizedBox(width: 130.w, child: _cellPadding(ReusableText('???????:', style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.bold)), false)),
                  SizedBox(width: 140.w, child: _cellPadding(ReusableText(formatMoney(totalAmount), style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.bold)), true)),
                  SizedBox(width: 80.w), // qty
                  SizedBox(width: 120.w), // added_by
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _cellPadding(Widget child, bool isNumeric) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Align(
        alignment: isNumeric ? Alignment.centerLeft : Alignment.centerRight,
        child: child,
      ),
    );
  }

  Widget _buildTableToolbar(BuildContext context, SalesReturnState state) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
      child: Row(
        children: [
          ReusableText('???????', style: AppTextStyles.body(context)),
          SizedBox(width: 8.w),
          _rowsPerPageDropdown(),
          SizedBox(width: 8.w),
          ReusableText('???', style: AppTextStyles.body(context)),
          const Spacer(),
          _toolbarButton(Icons.ios_share_rounded, '????? ??? CSV'),
          _toolbarButton(Icons.print_outlined, GeneralStrings.print),
          _toolbarButton(Icons.view_column_outlined, SalesStrings.viewColumns),
          SizedBox(width: 16.w),
          SizedBox(
            width: 250.w,
            child: ReusableInput(
              hint: '???...',
              prefixIcon: const Icon(Icons.search_rounded),
              onChanged: (v) => context.read<SalesReturnBloc>().add(SearchSalesReturns(v)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _rowsPerPageDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(6.r)),
      child: DropdownButton<int>(
        value: 25,
        items: [25, 50, 100].map((e) => DropdownMenuItem(value: e, child: ReusableText('$e'))).toList(),
        onChanged: (v) {},
        underline: const SizedBox(),
        isDense: true,
      ),
    );
  }

  Widget _toolbarButton(IconData icon, String label) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: 8.w),
      child: ReusableButton(
        text: label,
        prefixIcon: icon,
        type: ButtonType.outlined,
        size: ButtonSize.small,
        onPressed: () {},
      ),
    );
  }

  Widget _buildRowActions(BuildContext context, ReturnModel r) {
    final scheme = Theme.of(context).colorScheme;
    return PopupMenuButton<String>(
      offset: const Offset(0, 40),
      onSelected: (v) {
        if (v == 'view') { /* logic */ }
      },
      itemBuilder: (ctx) => [
        _menuItem(ctx, 'view', Icons.visibility_rounded, SalesStrings.inspect),
        _menuItem(ctx, 'print', Icons.print_rounded, GeneralStrings.print),
        _menuItem(ctx, 'delete', Icons.delete_outline_rounded, GeneralStrings.delete, color: AppColors.error),
      ],
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: scheme.primary,
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ReusableText('??????', style: AppTextStyles.caption(context).copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
            Icon(Icons.keyboard_arrow_down_rounded, size: AppIconSize.sm.value, color: Colors.white),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<String> _menuItem(BuildContext context, String value, IconData icon, String label, {Color? color}) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: AppIconSize.md.value, color: color ?? Colors.grey.shade700),
          SizedBox(width: 12.w),
          ReusableText(label, style: AppTextStyles.body(context).copyWith(color: color)),
        ],
      ),
    );
  }

  void _showCreateReturnDialog(BuildContext context) {
    final branchId = AuthService.currentBranchId ?? '';
    final sales = BranchDataService.getSales(branchId: branchId)
        .where((s) => !s.isDeleted)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    showDialog(
      context: context,
      builder: (ctx) => ReusableDialog(
        title: SalesStrings.createSalesReturnTitle,
        maxWidth: 500,
        children: [
          ReusableText(SalesStrings.selectOriginalInvoiceHint, style: AppTextStyles.body(context)),
          SizedBox(height: AppSpacing.md.h),
          StatefulBuilder(
            builder: (ctx2, setLocalState) {
              SaleInvoiceModel? selectedSale;
              ReturnReason? selectedReason = ReturnReason.damaged;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ReusableDropdown<SaleInvoiceModel>(
                    hintText: SalesStrings.selectInvoiceHint,
                    items: sales,
                    itemAsString: (s) => SalesStrings.invoiceNumberDateFormat.replaceFirst('%s', s.id.substring(0, 8)).replaceFirst('%s', formatDate(s.createdAt)),
                    onChanged: (sale) {
                      if (sale != null) {
                        setLocalState(() => selectedSale = sale);
                      }
                    },
                  ),
                  if (selectedSale != null) ...[
                    SizedBox(height: AppSpacing.md.h),
                    ReusableDropdown<ReturnReason>(
                      hintText: SalesStrings.returnReasonLabel,
                      value: selectedReason,
                      items: ReturnReason.values,
                      itemAsString: (r) => switch (r) {
                        ReturnReason.expired => PurchasesStrings.reasonExpired,
                        ReturnReason.damaged => PurchasesStrings.reasonDamaged,
                        ReturnReason.wrongItem => SalesStrings.reasonWrongItemSales,
                        ReturnReason.customerReturn => SalesStrings.reasonCustomerReturn,
                        ReturnReason.other => PurchasesStrings.reasonOther,
                      },
                      onChanged: (r) {
                        if (r != null) {
                          setLocalState(() => selectedReason = r);
                        }
                      },
                    ),
                    SizedBox(height: AppSpacing.md.h),
                    _SaleReturnItemSelector(sale: selectedSale!, onConfirm: (items) {
                      Navigator.pop(ctx);
                      context.read<SalesReturnBloc>().add(CreateSalesReturn(
                        originalSale: selectedSale!,
                        selectedItems: items,
                        reason: selectedReason ?? ReturnReason.damaged,
                      ));
                    }),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SaleReturnItemSelector extends StatefulWidget {
  final SaleInvoiceModel sale;
  final void Function(List<SelectedItem>) onConfirm;
  const _SaleReturnItemSelector({required this.sale, required this.onConfirm});

  @override
  State<_SaleReturnItemSelector> createState() => _SaleReturnItemSelectorState();
}

class _SaleReturnItemSelectorState extends State<_SaleReturnItemSelector> {
  final _ctrls = <TextEditingController>[];

  @override
  void initState() {
    super.initState();
    for (final item in widget.sale.items) {
      _ctrls.add(TextEditingController(text: '${item.quantity}'));
    }
  }

  @override
  void dispose() {
    for (final c in _ctrls) { c.dispose(); }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 300.h),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.sale.items.length,
            itemBuilder: (_, i) {
              final item = widget.sale.items[i];
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h),
                child: Row(
                  children: [
                    Expanded(child: Text(item.medicineName, style: AppTextStyles.body(context))),
                    SizedBox(width: AppSpacing.sm.w),
                    SizedBox(width: 80.w, child: ReusableInput(
                      controller: _ctrls[i], keyboardType: TextInputType.number, label: SalesStrings.quantityLabel, hint: '1-${item.quantity}',
                    )),
                    SizedBox(width: AppSpacing.sm.w),
                    Text('${SalesStrings.cartPrice}: ${item.unitPrice.toStringAsFixed(0)} ${GeneralStrings.currency}', style: AppTextStyles.caption(context).copyWith(color: Colors.grey)),
                  ],
                ),
              );
            },
          ),
        ),
        SizedBox(height: AppSpacing.md.h),
        DialogActions(
          confirmText: SalesStrings.confirmReturnAction,
          onConfirm: () {
            final items = <SelectedItem>[];
            for (var i = 0; i < widget.sale.items.length; i++) {
              final qty = int.tryParse(_ctrls[i].text) ?? 0;
              final maxQty = widget.sale.items[i].quantity;
              if (qty > 0 && qty <= maxQty) {
                items.add(SelectedItem(
                  medicineId: widget.sale.items[i].medicineId,
                  medicineName: widget.sale.items[i].medicineName,
                  unitPrice: widget.sale.items[i].unitPrice,
                  returnQuantity: qty,
                  maxQuantity: maxQty,
                ));
              }
            }
            if (items.isEmpty) { AppSnackbar.error(SalesStrings.selectAtLeastOneItemError); return; }
            widget.onConfirm(items);
          },
        ),
      ],
    );
  }
}








