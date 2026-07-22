import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pharmacy_system/app/core/constants/app_strings.dart';
import 'package:pharmacy_system/app/core/injection.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_colors.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_sizes.dart';
import 'package:pharmacy_system/app/routes/app_routes.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/index.dart';
import 'package:pharmacy_system/app/core/utils/format_utils.dart';
import 'package:pharmacy_system/app/modules/sales/bloc/sales_bloc.dart';
import 'package:pharmacy_system/app/modules/sales/models/sale_model.dart';

class SalesListView extends StatefulWidget {
  const SalesListView({super.key});

  @override
  State<SalesListView> createState() => _SalesListViewState();
}

class _SalesListViewState extends State<SalesListView> {
  String _selectedPaymentFilter = AppStrings.all;
  String _selectedPaymentStatusFilter = AppStrings.all;
  String _selectedShippingFilter = AppStrings.all;
  DateTime? _dateFrom;
  DateTime? _dateTo;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return BlocProvider(
      create: (_) => sl<SalesBloc>()..add(const LoadSales()),
      child: HomeShell(
        title: AppStrings.allSales,
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
            ReusableText(
              AppStrings.allSales,
              style: AppTextStyles.title(context).copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimaryOf(context)),
            ),
            SizedBox(height: 2.h),
            ReusableText(
              SalesStrings.salesSubtitle,
              style: AppTextStyles.caption(context).copyWith(color: AppColors.textSecondaryOf(context)),
            ),
          ],
        ),
        const Spacer(),
        ReusableButton(
          text: AppStrings.newSale,
          prefixIcon: Icons.add_shopping_cart_rounded,
          color: AppColors.homeSales,
          onPressed: () => context.go(Routes.SALES_POS),
        ),
        SizedBox(width: 8.w),
        ReusableButton(
          text: AppStrings.back,
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
              title: AppStrings.todaySales,
              value: formatMoney(state.todayTotal),
              icon: Icons.today_rounded,
              color: const Color(0xFF00B4D8),
            ),
            _MetricCard(
              width: cardWidth,
              title: AppStrings.thisMonthSales,
              value: formatMoney(state.monthTotal),
              icon: Icons.calendar_month_rounded,
              color: AppColors.success,
            ),
            _MetricCard(
              width: cardWidth,
              title: AppStrings.creditSales,
              value: formatMoney(state.creditTotal),
              icon: Icons.credit_score_rounded,
              color: AppColors.warning,
            ),
            _MetricCard(
              width: cardWidth,
              title: AppStrings.totalInvoices,
              value: '${state.totalCount} ${AppStrings.invoiceLabelSales}',
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
                    _statusChip(context, bloc, 'all', '${AppStrings.all} (${state.sales.length})', state.selectedFilter),
                    _statusChip(context, bloc, 'today', AppStrings.todaySales, state.selectedFilter),
                    _statusChip(context, bloc, 'this_month', AppStrings.thisMonth, state.selectedFilter),
                    _statusChip(context, bloc, 'credit', AppStrings.cartPaymentCredit, state.selectedFilter),
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
                label: AppStrings.paymentMethodLabel,
                value: _selectedPaymentFilter,
                items: <String>[AppStrings.all, AppStrings.cartPaymentCash, AppStrings.cartPaymentCard, AppStrings.cartPaymentCredit],
                onChanged: (v) => setState(() => _selectedPaymentFilter = v!),
              ),
              SizedBox(width: AppSpacing.md.w),
              FilterDropdown.string(
                label: AppStrings.paymentStatus,
                value: _selectedPaymentStatusFilter,
                items: <String>[AppStrings.all, AppStrings.paymentPaid, AppStrings.paymentPartial, AppStrings.paymentUnpaid],
                onChanged: (v) => setState(() => _selectedPaymentStatusFilter = v!),
              ),
              SizedBox(width: AppSpacing.md.w),
              FilterDropdown.string(
                label: AppStrings.shippingStatus,
                value: _selectedShippingFilter,
                items: <String>[AppStrings.all, AppStrings.shippingPending, AppStrings.shippingDelivered],
                onChanged: (v) => setState(() => _selectedShippingFilter = v!),
              ),
              SizedBox(width: AppSpacing.md.w),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 18.h),
                  child: ReusableButton(
                    text: AppStrings.resetFilters,
                    prefixIcon: Icons.restart_alt_rounded,
                    type: ButtonType.text,
                    onPressed: () {
                      setState(() {
                        _selectedPaymentFilter = AppStrings.all;
                        _selectedPaymentStatusFilter = AppStrings.all;
                        _selectedShippingFilter = AppStrings.all;
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
    final scheme = Theme.of(context).colorScheme;

    if (state.isLoading && state.sales.isEmpty) return const LoadingIndicator();

    // Apply UI dropdown filters
    var items = state.filteredSales.where((s) {
      if (_selectedPaymentFilter != AppStrings.all) {
        final pm = s.paymentMethod;
        if (_selectedPaymentFilter == AppStrings.cartPaymentCash && pm != 'cash') return false;
        if (_selectedPaymentFilter == AppStrings.cartPaymentCard && pm != 'card') return false;
        if (_selectedPaymentFilter == AppStrings.cartPaymentCredit && pm != 'credit') return false;
      }
      if (_selectedPaymentStatusFilter != AppStrings.all) {
        final isPaid = s.dueAmount <= 0;
        if (_selectedPaymentStatusFilter == AppStrings.paymentPaid && !isPaid) return false;
        if (_selectedPaymentStatusFilter == AppStrings.paymentUnpaid && isPaid) return false;
      }
      if (_dateFrom != null && s.createdAt.isBefore(_dateFrom!)) return false;
      if (_dateTo != null && s.createdAt.isAfter(_dateTo!.add(const Duration(days: 1)))) return false;
      return true;
    }).toList();

    if (items.isEmpty) {
      return _buildEmptyState(context);
    }

    final totalAmount = items.fold(0.0, (sum, s) => sum + s.finalAmount);
    final totalPaid = items.fold(0.0, (sum, s) => sum + (s.paidAmount ?? s.finalAmount));
    final totalDue = items.fold(0.0, (sum, s) => sum + s.dueAmount);

    final columns = [
      ReusableTableColumn<SaleModel>(
        id: 'actions',
        title: AppStrings.options,
        width: 100.w,
        cellBuilder: (s) => _buildRowActions(context, s),
      ),
      ReusableTableColumn<SaleModel>(
        id: 'date',
        title: AppStrings.date,
        width: 150.w,
        isSortable: true,
        textBuilder: (s) => formatDateTime(s.createdAt),
      ),
      ReusableTableColumn<SaleModel>(
        id: 'id',
        title: AppStrings.invoiceNumberLabel,
        width: 110.w,
        isSortable: true,
        textBuilder: (s) => '#${s.id.substring(0, 6).toUpperCase()}',
      ),
      ReusableTableColumn<SaleModel>(
        id: 'customer',
        title: AppStrings.customerNameLabel,
        flex: 2,
        isSortable: true,
        textBuilder: (s) => s.customerName ?? AppStrings.cashCustomer,
      ),
      ReusableTableColumn<SaleModel>(
        id: 'contact',
        title: AppStrings.contactNumber,
        width: 120.w,
        textBuilder: (s) => '—',
      ),
      ReusableTableColumn<SaleModel>(
        id: 'method',
        title: AppStrings.paymentMethodLabel,
        width: 110.w,
        cellBuilder: (s) {
          final label = switch (s.paymentMethod) {
            'cash' => AppStrings.cartPaymentCash,
            'card' => AppStrings.cartPaymentCard,
            'credit' => AppStrings.cartPaymentCredit,
            _ => s.paymentMethod,
          };
          return StatusBadge(
            label: label, 
            color: s.paymentMethod == 'cash' ? AppColors.success : (s.paymentMethod == 'card' ? AppColors.info : AppColors.warning),
          );
        },
      ),
      ReusableTableColumn<SaleModel>(
        id: 'payment_status',
        title: AppStrings.paymentStatus,
        width: 110.w,
        cellBuilder: (s) {
          final isPaid = s.dueAmount <= 0;
          return StatusBadge(
            label: isPaid ? AppStrings.paymentPaid : AppStrings.paymentPartial,
            color: isPaid ? AppColors.success : AppColors.error,
          );
        },
      ),
      ReusableTableColumn<SaleModel>(
        id: 'amount',
        title: AppStrings.totalValue,
        width: 120.w,
        isNumeric: true,
        textBuilder: (s) => formatMoney(s.finalAmount),
      ),
      ReusableTableColumn<SaleModel>(
        id: 'paid',
        title: AppStrings.paidAmount,
        width: 120.w,
        isNumeric: true,
        textBuilder: (s) => formatMoney(s.paidAmount ?? s.finalAmount),
      ),
      ReusableTableColumn<SaleModel>(
        id: 'due',
        title: AppStrings.dueAmount,
        width: 120.w,
        isNumeric: true,
        textBuilder: (s) => formatMoney(s.dueAmount),
      ),
      ReusableTableColumn<SaleModel>(
        id: 'shipping',
        title: AppStrings.shippingStatus,
        width: 110.w,
        cellBuilder: (s) => StatusBadge(label: AppStrings.shippingPending, color: AppColors.warning),
      ),
      ReusableTableColumn<SaleModel>(
        id: 'qty',
        title: AppStrings.quantity,
        width: 70.w,
        isNumeric: true,
        textBuilder: (s) => '${s.items.length}',
      ),
    ];

    return Column(
      children: [
        _buildTableToolbar(context, state),
        Expanded(
          child: ReusableTable<SaleModel>(
            columns: columns,
            items: items,
            itemLabel: AppStrings.invoiceLabelSales,
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
                  SizedBox(width: 150.w), // date
                  SizedBox(width: 110.w), // id
                  Expanded(flex: 2, child: const SizedBox()), // customer
                  SizedBox(width: 120.w), // contact
                  SizedBox(width: 110.w), // method
                  SizedBox(width: 110.w, child: _cellPadding(ReusableText('${AppStrings.total}:', style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.bold)), false)),
                  SizedBox(width: 120.w, child: _cellPadding(ReusableText(formatMoney(totalAmount), style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.bold)), true)),
                  SizedBox(width: 120.w, child: _cellPadding(ReusableText(formatMoney(totalPaid), style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.bold)), true)),
                  SizedBox(width: 120.w, child: _cellPadding(ReusableText(formatMoney(totalDue), style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.bold)), true)),
                  SizedBox(width: 110.w), // shipping
                  SizedBox(width: 70.w), // qty
                ],
              ),
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
            ReusableText(
              AppStrings.noSalesInvoices,
              style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimaryOf(context)),
            ),
            SizedBox(height: 6.h),
            ReusableText(
              SalesStrings.emptySalesSubtitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.caption(context).copyWith(color: AppColors.textSecondaryOf(context)),
            ),
            SizedBox(height: 20.h),
            ReusableButton(
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
          ReusableText(AppStrings.showEntries, style: AppTextStyles.caption(context).copyWith(color: AppColors.textSecondaryOf(context))),
          SizedBox(width: 8.w),
          _rowsPerPageDropdown(),
          const Spacer(),
          _toolbarButton(Icons.ios_share_rounded, AppStrings.exportCsv),
          _toolbarButton(Icons.description_outlined, AppStrings.exportExcel),
          _toolbarButton(Icons.print_outlined, AppStrings.print),
          _toolbarButton(Icons.view_column_outlined, AppStrings.viewColumns),
          SizedBox(width: 14.w),
          SizedBox(
            width: 240.w,
            child: ReusableInput(
              hint: AppStrings.searchSalesInvoicesHint,
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
        items: [25, 50, 100].map((e) => DropdownMenuItem(value: e, child: ReusableText('$e'))).toList(),
        onChanged: (v) {},
        underline: const SizedBox(),
        isDense: true,
      ),
    );
  }

  Widget _toolbarButton(IconData icon, String label) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: 6.w),
      child: ReusableButton(
        text: label,
        prefixIcon: icon,
        type: ButtonType.outlined,
        size: ButtonSize.small,
        onPressed: () {},
      ),
    );
  }

  Widget _buildRowActions(BuildContext context, SaleModel sale) {
    final primary = Theme.of(context).colorScheme.primary;

    return PopupMenuButton<String>(
      offset: const Offset(0, 40),
      onSelected: (v) {
        if (v == 'inspect') {
          SaleDetailsDialog.show(context, sale);
        } else if (v == 'void') {
          _confirmVoidSale(context, sale);
        }
      },
      itemBuilder: (_) => [
        _menuItem('inspect', Icons.visibility_rounded, AppStrings.inspect, color: AppColors.info),
        _menuItem('edit', Icons.edit_rounded, AppStrings.edit),
        _menuItem('print', Icons.print_rounded, AppStrings.printInvoice),
        _menuItem('void', Icons.delete_outline_rounded, AppStrings.voidInvoice, color: AppColors.error),
      ],
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: primary.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ReusableText(AppStrings.options, style: AppTextStyles.caption(context).copyWith(color: primary, fontWeight: FontWeight.bold)),
            SizedBox(width: 4.w),
            Icon(Icons.keyboard_arrow_down_rounded, size: AppIconSize.md.value, color: primary),
          ],
        ),
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
          ReusableText(
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

  void _confirmVoidSale(BuildContext context, SaleModel sale) {
    showDialog(
      context: context,
      builder: (ctx) => ReusableDialog(
        title: AppStrings.voidInvoice,
        headerIcon: const Icon(Icons.warning_amber_rounded, color: Colors.white),
        headerIconColor: AppColors.error,
        children: [
          ReusableText(
            '${AppStrings.voidInvoiceConfirmPrefix}${sale.id.substring(0, 6).toUpperCase()}؟',
            style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.h),
          ReusableText(
            AppStrings.voidInvoiceWarning,
            style: AppTextStyles.caption(context).copyWith(color: AppColors.textSecondaryOf(context)),
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ReusableButton(
                text: AppStrings.backActionSales,
                type: ButtonType.outlined,
                onPressed: () => Navigator.pop(ctx),
              ),
              SizedBox(width: 10.w),
              ReusableButton(
                text: AppStrings.voidInvoice,
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
                  ReusableText(
                    title,
                    style: AppTextStyles.caption(context).copyWith(
                      color: AppColors.textSecondaryOf(context),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  ReusableText(
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



