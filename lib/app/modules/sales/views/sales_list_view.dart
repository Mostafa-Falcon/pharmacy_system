import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pharmacy_system/app/core/constants/app_strings.dart';
import 'package:pharmacy_system/app/core/injection.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_colors.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_sizes.dart';
import 'package:pharmacy_system/app/routes/app_routes.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/index.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/components/tables/shared_table_cells.dart';
import 'package:pharmacy_system/app/core/utils/format_utils.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_system/app/core/models/sales/sale_invoice_model.dart';
import 'package:pharmacy_system/app/modules/sales/bloc/sales_bloc.dart';
import 'package:pharmacy_system/app/core/extensions/string_ext.dart';

class SalesListView extends StatefulWidget {
  const SalesListView({super.key});

  @override
  State<SalesListView> createState() => _SalesListViewState();
}

class _SalesListViewState extends State<SalesListView> {
  String _selectedPaymentFilter = GeneralStrings.all;
  String _selectedPaymentStatusFilter = GeneralStrings.all;
  String _selectedShippingFilter = GeneralStrings.all;
  DateTime? _dateFrom;
  DateTime? _dateTo;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return BlocProvider(
      create: (_) => sl<SalesBloc>()..add(const LoadSales()),
      child: HomeShell(
        title: SalesStrings.allSales,
        child: Container(
          color: scheme.surfaceContainerLowest.withValues(alpha: 0.5),
          padding: EdgeInsets.all(AppSpacing.lg.w),
          child: BlocBuilder<SalesBloc, SalesState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(context),
                  SizedBox(height: AppSpacing.md.h),
                  _buildSalesMetrics(context, state),
                  SizedBox(height: AppSpacing.md.h),
                  _buildFilters(context, state),
                  SizedBox(height: AppSpacing.md.h),
                  Expanded(child: _buildSalesList(context, state)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              SalesStrings.allSales,
              style: AppTextStyles.title(context).copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimaryOf(context)),
            ),
            SizedBox(height: 2.h),
            AppText(
              SalesStrings.salesSubtitle,
              style: AppTextStyles.caption(context).copyWith(color: AppColors.textSecondaryOf(context)),
            ),
          ],
        ),
        const Spacer(),
        AppButton(
          text: SalesStrings.newSale,
          prefixIcon: Icons.add_shopping_cart_rounded,
          color: AppColors.homeSales,
          onPressed: () => context.go(Routes.SALES_POS),
        ),
        SizedBox(width: 8.w),
        AppButton(
          text: GeneralStrings.back,
          type: ButtonType.outlined,
          prefixIcon: Icons.arrow_back_rounded,
          onPressed: () => context.pop(),
        ),
      ],
    );
  }

  Widget _buildSalesMetrics(BuildContext context, SalesState state) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        final isMobile = constraints.maxWidth < 650;
        final cardWidth = isMobile ? (constraints.maxWidth - 12.w) / 2 : (constraints.maxWidth - 36.w) / 4;

        return Wrap(
          spacing: 12.w,
          runSpacing: 12.h,
          children: [
            _MetricCard(
              width: cardWidth,
              title: SalesStrings.todaySales,
              value: formatMoney(state.todayTotal),
              icon: Icons.today_rounded,
              color: const Color(0xFF00B4D8),
            ),
            _MetricCard(
              width: cardWidth,
              title: SalesStrings.thisMonthSales,
              value: formatMoney(state.monthTotal),
              icon: Icons.calendar_month_rounded,
              color: AppColors.success,
            ),
            _MetricCard(
              width: cardWidth,
              title: SalesStrings.creditSales,
              value: formatMoney(state.creditTotal),
              icon: Icons.credit_score_rounded,
              color: AppColors.warning,
            ),
            _MetricCard(
              width: cardWidth,
              title: SalesStrings.totalInvoices,
              value: '${state.totalCount} ${SalesStrings.invoiceLabelSales}',
              icon: Icons.receipt_long_rounded,
              color: const Color(0xFF6366F1),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFilters(BuildContext context, SalesState state) {
    final bloc = context.read<SalesBloc>();

    return AppCard(
      padding: EdgeInsets.all(AppSpacing.md.w),
      child: Column(
        children: [
          // Row 1: Filter Chips + Date Selectors
          Row(
            children: [
              // Status Quick Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _statusChip(context, bloc, 'all', '${GeneralStrings.all} (${state.sales.length})', state.selectedFilter),
                    _statusChip(context, bloc, 'today', SalesStrings.todaySales, state.selectedFilter),
                    _statusChip(context, bloc, 'this_month', GeneralStrings.thisMonth, state.selectedFilter),
                    _statusChip(context, bloc, 'credit', SalesStrings.cartPaymentCredit, state.selectedFilter),
                  ],
                ),
              ),
              const Spacer(),
              DateRangePicker(
                fromDate: _dateFrom,
                toDate: _dateTo,
                onFromTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null) setState(() => _dateFrom = picked);
                },
                onToTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null) setState(() => _dateTo = picked);
                },
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm.h),
          const Divider(height: 1),
          SizedBox(height: AppSpacing.sm.h),

          // Row 2: Dropdown filters
          Row(
            children: [
              FilterDropdown.string(
                label: SalesStrings.paymentMethodLabel,
                value: _selectedPaymentFilter,
                items: <String>[GeneralStrings.all, SalesStrings.cartPaymentCash, SalesStrings.cartPaymentCard, SalesStrings.cartPaymentCredit],
                onChanged: (v) => setState(() => _selectedPaymentFilter = v!),
              ),
              SizedBox(width: AppSpacing.md.w),
              FilterDropdown.string(
                label: SalesStrings.paymentStatus,
                value: _selectedPaymentStatusFilter,
                items: <String>[GeneralStrings.all, SalesStrings.paymentPaid, SalesStrings.paymentPartial, SalesStrings.paymentUnpaid],
                onChanged: (v) => setState(() => _selectedPaymentStatusFilter = v!),
              ),
              SizedBox(width: AppSpacing.md.w),
              FilterDropdown.string(
                label: SalesStrings.shippingStatus,
                value: _selectedShippingFilter,
                items: <String>[GeneralStrings.all, SalesStrings.shippingPending, SalesStrings.shippingDelivered],
                onChanged: (v) => setState(() => _selectedShippingFilter = v!),
              ),
              SizedBox(width: AppSpacing.md.w),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 18.h),
                  child: AppButton(
                    text: SalesStrings.resetFilters,
                    prefixIcon: Icons.restart_alt_rounded,
                    type: ButtonType.text,
                    onPressed: () {
                      setState(() {
                        _selectedPaymentFilter = GeneralStrings.all;
                        _selectedPaymentStatusFilter = GeneralStrings.all;
                        _selectedShippingFilter = GeneralStrings.all;
                        _dateFrom = null;
                        _dateTo = null;
                      });
                      bloc.add(const FilterSalesByStatus('all'));
                      bloc.add(const FilterSalesQuery(''));
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusChip(BuildContext context, SalesBloc bloc, String key, String label, String activeFilter) {
    final isSelected = activeFilter == key;
    return Padding(
      padding: EdgeInsetsDirectional.only(end: 6.w),
      child: ChoiceChip(
        label: Text(
          label,
          style: AppTextStyles.caption(context).copyWith(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        selected: isSelected,
        onSelected: (val) {
          if (val) bloc.add(FilterSalesByStatus(key));
        },
        selectedColor: Theme.of(context).colorScheme.primary,
        labelStyle: AppTextStyles.caption(context).copyWith(
          color: isSelected ? Colors.white : AppColors.textPrimaryOf(context),
        ),
        showCheckmark: false,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      ),
    );
  }


  Widget _buildSalesList(BuildContext context, SalesState state) {
    if (state.isLoading && state.sales.isEmpty) return const LoadingIndicator();

    // Apply UI dropdown filters
    var items = state.filteredSales.where((s) {
      if (_selectedPaymentFilter != GeneralStrings.all) {
        final pm = s.paymentMethod;
        if (_selectedPaymentFilter == SalesStrings.cartPaymentCash && pm != 'cash') return false;
        if (_selectedPaymentFilter == SalesStrings.cartPaymentCard && pm != 'card') return false;
        if (_selectedPaymentFilter == SalesStrings.cartPaymentCredit && pm != 'credit') return false;
      }
      if (_selectedPaymentStatusFilter != GeneralStrings.all) {
        final isPaid = s.dueAmount <= 0;
        if (_selectedPaymentStatusFilter == SalesStrings.paymentPaid && !isPaid) return false;
        if (_selectedPaymentStatusFilter == SalesStrings.paymentUnpaid && isPaid) return false;
      }
      if (_dateFrom != null && s.createdAt.isBefore(_dateFrom!)) return false;
      if (_dateTo != null && s.createdAt.isAfter(_dateTo!.add(const Duration(days: 1)))) return false;
      return true;
    }).toList();

    if (items.isEmpty) {
      return _buildEmptyState(context);
    }

    final totalAmount = items.fold(0.0, (sum, s) => sum + s.finalAmount);
    final totalDue = items.fold(0.0, (sum, s) => sum + s.dueAmount);

    final columns = [
      AppTableColumn<SaleInvoiceModel>(
        id: 'id',
        title: SalesStrings.invoiceNumberLabel,
        width: 110.w,
        isSortable: true,
        textBuilder: (s) => '#${s.id.substring(0, 6).toUpperCase()}',
      ),
      AppTableColumn<SaleInvoiceModel>(
        id: 'customer',
        title: SalesStrings.customerNameLabel,
        flex: 2,
        isSortable: true,
        cellBuilder: (s) => TableContactNameCell(
          name: s.customerName ?? SalesStrings.cashCustomer,
          subtitle: s.notes?.nullIfEmpty ?? 'لا توجد ملاحظات',
          icon: s.paymentMethod == 'credit' ? Icons.person_rounded : Icons.money_rounded,
          iconColor: s.paymentMethod == 'cash' ? AppColors.success : (s.paymentMethod == 'card' ? AppColors.info : AppColors.warning),
        ),
      ),
      AppTableColumn<SaleInvoiceModel>(
        id: 'method',
        title: SalesStrings.paymentMethodLabel,
        width: 110.w,
        cellBuilder: (s) {
          final label = switch (s.paymentMethod) {
            'cash' => SalesStrings.cartPaymentCash,
            'card' => SalesStrings.cartPaymentCard,
            'credit' => SalesStrings.cartPaymentCredit,
            _ => s.paymentMethod,
          };
          return StatusBadge(
            label: label, 
            color: s.paymentMethod == 'cash' ? AppColors.success : (s.paymentMethod == 'card' ? AppColors.info : AppColors.warning),
          );
        },
      ),
      AppTableColumn<SaleInvoiceModel>(
        id: 'payment_status',
        title: SalesStrings.paymentStatus,
        width: 110.w,
        cellBuilder: (s) {
          final isPaid = s.dueAmount <= 0;
          return StatusBadge(
            label: isPaid ? SalesStrings.paymentPaid : SalesStrings.paymentPartial,
            color: isPaid ? AppColors.success : AppColors.error,
          );
        },
      ),
      AppTableColumn<SaleInvoiceModel>(
        id: 'amount',
        title: SalesStrings.totalValue,
        width: 120.w,
        isNumeric: true,
        cellBuilder: (s) => TableMoneyCell(amount: s.finalAmount, currency: GeneralStrings.currency, isHighlight: true),
      ),
      AppTableColumn<SaleInvoiceModel>(
        id: 'due',
        title: SalesStrings.dueAmount,
        width: 120.w,
        isNumeric: true,
        cellBuilder: (s) => TableMoneyCell(amount: s.dueAmount, currency: GeneralStrings.currency, isNegative: s.dueAmount > 0),
      ),
      AppTableColumn<SaleInvoiceModel>(
        id: 'date',
        title: GeneralStrings.date,
        width: 150.w,
        isSortable: true,
        textBuilder: (s) => DateFormat('yyyy/MM/dd HH:mm').format(s.createdAt),
      ),
    ];

    return Column(
      children: [
        _buildTableToolbar(context, state),
        Expanded(
          child: AppTable<SaleInvoiceModel>(
            columns: columns,
            items: items,
            itemLabel: SalesStrings.invoiceLabelSales,
            bodyRowHeight: 56.h,
            rowActions: (s) => TableOptionsButton(
              onSelected: (v) {
                if (v == 'inspect') {
                  SaleDetailsDialog.show(context, s);
                } else if (v == 'void') {
                  _confirmVoidSale(context, s);
                }
              },
              menuItems: [
                _menuItem('inspect', Icons.visibility_rounded, SalesStrings.inspect, color: AppColors.info),
                _menuItem('edit', Icons.edit_rounded, GeneralStrings.edit),
                _menuItem('print', Icons.print_rounded, SalesStrings.printInvoice),
                _menuItem('void', Icons.delete_outline_rounded, SalesStrings.voidInvoice, color: AppColors.error),
              ],
            ),
            summaryRow: Row(
              children: [
                SizedBox(width: 100.w), // actions
                SizedBox(width: 110.w), // id
                Expanded(flex: 2, child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  child: AppText('المجموع:', style: AppTextStyles.bodyBold(context)),
                )), // customer
                SizedBox(width: 110.w), // method
                SizedBox(width: 110.w), // payment_status
                SizedBox(width: 120.w, child: _cellPadding(AppText(formatMoney(totalAmount), style: AppTextStyles.bodyBold(context)), true)),
                SizedBox(width: 120.w, child: _cellPadding(AppText(formatMoney(totalDue), style: AppTextStyles.bodyBold(context)), true)),
                SizedBox(width: 150.w), // date
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.all(36.w),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.point_of_sale_rounded,
                size: AppIconSize.xxl.value,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            SizedBox(height: 16.h),
            AppText(
              SalesStrings.noSalesInvoices,
              style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimaryOf(context)),
            ),
            SizedBox(height: 6.h),
            AppText(
              SalesStrings.emptySalesSubtitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.caption(context).copyWith(color: AppColors.textSecondaryOf(context)),
            ),
            SizedBox(height: 20.h),
            AppButton(
              text: SalesStrings.posTitle,
              prefixIcon: Icons.add_shopping_cart_rounded,
              onPressed: () => context.go(Routes.SALES_POS),
            ),
          ],
        ),
      ),
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

  Widget _buildTableToolbar(BuildContext context, SalesState state) {
    final bloc = context.read<SalesBloc>();

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 4.w),
      child: Row(
        children: [
          AppText(SalesStrings.showEntries, style: AppTextStyles.caption(context).copyWith(color: AppColors.textSecondaryOf(context))),
          SizedBox(width: 8.w),
          _rowsPerPageDropdown(),
          const Spacer(),
          _toolbarButton(Icons.ios_share_rounded, SalesStrings.exportCsv),
          _toolbarButton(Icons.description_outlined, SalesStrings.exportExcel),
          _toolbarButton(Icons.print_outlined, GeneralStrings.print),
          _toolbarButton(Icons.view_column_outlined, SalesStrings.viewColumns),
          SizedBox(width: 14.w),
          SizedBox(
            width: 240.w,
            child: AppInput(
              hint: SalesStrings.searchSalesInvoicesHint,
              prefixIcon: const Icon(Icons.search_rounded),
              onChanged: (query) => bloc.add(FilterSalesQuery(query)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _rowsPerPageDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300), 
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: DropdownButton<int>(
        value: 25,
        items: [25, 50, 100].map((e) => DropdownMenuItem(value: e, child: AppText('$e'))).toList(),
        onChanged: (v) {},
        underline: const SizedBox(),
        isDense: true,
      ),
    );
  }

  Widget _toolbarButton(IconData icon, String label) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: 6.w),
      child: AppButton(
        text: label,
        prefixIcon: icon,
        type: ButtonType.outlined,
        size: ButtonSize.small,
        onPressed: () {},
      ),
    );
  }

  PopupMenuItem<String> _menuItem(String value, IconData icon, String label, {Color? color}) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: AppIconSize.md.value, color: color ?? Colors.grey.shade700),
          SizedBox(width: 10.w),
          AppText(
            label, 
            style: AppTextStyles.caption(context).copyWith(
              color: color ?? Colors.black87,
              fontWeight: color != null ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  void _confirmVoidSale(BuildContext context, SaleInvoiceModel sale) {
    showDialog(
      context: context,
      builder: (ctx) => AppDialog(
        title: SalesStrings.voidInvoice,
        headerIcon: const Icon(Icons.warning_amber_rounded, color: Colors.white),
        headerIconColor: AppColors.error,
        children: [
          AppText(
            '${SalesStrings.voidInvoiceConfirmPrefix}${sale.id.substring(0, 6).toUpperCase()}؟',
            style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.h),
          AppText(
            SalesStrings.voidInvoiceWarning,
            style: AppTextStyles.caption(context).copyWith(color: AppColors.textSecondaryOf(context)),
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppButton(
                text: SalesStrings.back,
                type: ButtonType.outlined,
                onPressed: () => Navigator.pop(ctx),
              ),
              SizedBox(width: 10.w),
              AppButton(
                text: SalesStrings.voidInvoice,
                color: AppColors.error,
                onPressed: () {
                  Navigator.pop(ctx);
                  context.read<SalesBloc>().add(VoidSale(sale));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final double width;
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _MetricCard({
    required this.width,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: AppCard(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, size: AppIconSize.md.value, color: color),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    title,
                    style: AppTextStyles.caption(context).copyWith(
                      color: AppColors.textSecondaryOf(context),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  AppText(
                    value,
                    style: AppTextStyles.body(context).copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimaryOf(context),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}










