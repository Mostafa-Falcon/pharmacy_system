import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' hide TextDirection;

import 'package:pharmacy_system/app/core/models/sales/return_model.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_colors.dart';
import '../../../core/utils/format_utils.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/injection.dart';
import 'package:pharmacy_system/app/core/data/services/admin/branch_data_service.dart';
import '../bloc/purchase_return_bloc.dart';
import '../bloc/purchase_return_event.dart';
import '../bloc/purchase_return_state.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/index.dart';
import 'add_purchase_return_view.dart';

class PurchaseReturnListView extends StatefulWidget {
  final int initialIndex;
  const PurchaseReturnListView({super.key, this.initialIndex = 0});

  @override
  State<PurchaseReturnListView> createState() => _PurchaseReturnListViewState();
}

class _PurchaseReturnListViewState extends State<PurchaseReturnListView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialIndex.clamp(0, 1),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return BlocProvider.value(
      value: sl<PurchaseReturnBloc>()..add(const LoadPurchaseReturns()),
      child: HomeShell(
        title: 'إدارة مرتجعات المشتريات',
        child: Container(
          color: scheme.surfaceContainerLow.withValues(alpha: 0.15),
          padding: EdgeInsets.all(AppSpacing.xl.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ─── شريط التبويب العريض والاحترافي ───
              Container(
                decoration: BoxDecoration(
                  color: scheme.surface,
                  borderRadius: BorderRadius.circular(AppRadius.lg.r),
                  border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.6)),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  indicator: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppRadius.lg.r),
                    border: Border.all(color: AppColors.error, width: 1.5),
                  ),
                  labelColor: AppColors.error,
                  unselectedLabelColor: scheme.onSurfaceVariant,
                  labelStyle: AppTextStyles.bodyBold(context),
                  unselectedLabelStyle: AppTextStyles.body(context),
                  tabs: [
                    Tab(
                      height: 48.h,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.assignment_return_rounded),
                          SizedBox(width: AppSpacing.sm.w),
                          const Text('سجل المرتجعات والقائمة'),
                        ],
                      ),
                    ),
                    Tab(
                      height: 48.h,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.add_shopping_cart_rounded),
                          SizedBox(width: AppSpacing.sm.w),
                          const Text('إضافة مرتجع مشتريات جديد'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: AppSpacing.lg.h),

              // ─── محتوى التبويبات ───
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // 1. سجل المرتجعات
                    BlocBuilder<PurchaseReturnBloc, PurchaseReturnState>(
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

                    // 2. إضافة مرتجع جديد
                    AddPurchaseReturnView(
                      onSaved: () {
                        _tabController.animateTo(0);
                        context.read<PurchaseReturnBloc>().add(const LoadPurchaseReturns());
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, PurchaseReturnState state) {
    return Row(
      children: [
        ReusableButton(
          text: 'إضافة مرتجع جديد',
          prefixIcon: Icons.add_rounded,
          color: AppColors.error,
          onPressed: () => _tabController.animateTo(1),
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

  Widget _buildFilters(BuildContext context, PurchaseReturnState state) {
    final scheme = Theme.of(context).colorScheme;
    return AppCard(
      padding: EdgeInsets.all(AppSpacing.xl.w),
      child: Column(
        children: [
          Row(
            children: [
              SummaryCard(
                label: 'إجمالي المرتجعات',
                value: '${state.totalCount}',
                color: scheme.primary,
                icon: Icons.assignment_return_rounded,
                minWidth: 160.w,
              ),
              SizedBox(width: AppSpacing.md.w),
              SummaryCard(
                label: 'إجمالي القيمة المرتجعة',
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
                label: InventoryStrings.supplierLabel,
                items: const ['الكل'],
                onChanged: (v) {},
              ),
              SizedBox(width: AppSpacing.md.w),
              FilterDropdown.string(
                label: PurchasesStrings.reasonLabel,
                items: const ['الكل', 'منتهي الصلاحية', 'تالف', 'خطأ في الصنف'],
                onChanged: (v) {},
              ),
              SizedBox(width: AppSpacing.md.w),
              FilterDropdown.string(
                label: 'المخزن',
                items: const ['الكل'],
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

  Widget _buildList(BuildContext context, PurchaseReturnState state) {
    final scheme = Theme.of(context).colorScheme;
    if (state.status == PurchaseReturnStatus.loading && state.returns.isEmpty) return const LoadingIndicator();

    final items = state.filteredReturns;
    final totalAmount = items.fold(0.0, (sum, r) => sum + r.totalAmount);

    final columns = [
      ReusableTableColumn<ReturnModel>(
        id: 'actions',
        title: 'خيار',
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
        title: 'رقم المرتجع',
        width: 120.w,
        isSortable: true,
        textBuilder: (r) => '#${r.id.substring(0, 8).toUpperCase()}',
      ),
      ReusableTableColumn<ReturnModel>(
        id: 'purchaseId',
        title: 'الفاتورة الأصلية',
        width: 120.w,
        textBuilder: (r) => r.purchaseId != null ? '#${r.purchaseId!.substring(0, 8).toUpperCase()}' : '---',
      ),
      ReusableTableColumn<ReturnModel>(
        id: 'supplier',
        title: 'المورد',
        flex: 2,
        textBuilder: (r) {
          if (r.purchaseId != null) {
            final p = BranchDataService.getPurchase(r.purchaseId!);
            if (p != null) return p.supplierName;
          }
          return 'غير محدد';
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
        title: 'القيمة الإجمالية',
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
        textBuilder: (r) => 'المسؤول',
      ),
    ];

    return Column(
      children: [
        _buildTableToolbar(context, state),
        Expanded(
          child: ReusableTable<ReturnModel>(
            columns: columns,
            items: items,
            itemLabel: 'مرتجع مشتريات',
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
                  SizedBox(width: 120.w), // purchaseId
                  Expanded(flex: 2, child: const SizedBox()), // supplier
                  SizedBox(width: 130.w, child: _cellPadding(ReusableText('المجموع:', style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.bold)), false)),
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

  Widget _buildTableToolbar(BuildContext context, PurchaseReturnState state) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md.w),
      child: Row(
        children: [
          SizedBox(
            width: 250.w,
            child: ReusableInput(
              hint: GeneralStrings.search,
              prefixIcon: const Icon(Icons.search),
              onChanged: (v) {},
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => context.read<PurchaseReturnBloc>().add(const LoadPurchaseReturns()),
          ),
        ],
      ),
    );
  }

  Widget _buildRowActions(BuildContext context, ReturnModel item) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.visibility_outlined, size: 18),
          onPressed: () {},
        ),
      ],
    );
  }
}





