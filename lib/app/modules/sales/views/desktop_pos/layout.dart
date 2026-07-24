import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:collection/collection.dart';

import 'package:pharmacy_system/app/shared/presentation/widgets/index.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_colors.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_sizes.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../routes/app_routes.dart';
import 'package:pharmacy_system/app/core/models/contacts/customer_model.dart';
import 'package:pharmacy_system/app/core/models/inventory/medicine_model.dart';
import 'package:pharmacy_system/app/core/models/sales/cashier_shift_model.dart';
import '../../../../core/constants/app_strings.dart';

import '../../bloc/pos_bloc.dart';
import '../../bloc/catalog_cubit.dart';
import '../../widgets/pos_catalog_panel.dart';
import 'toolbar.dart';
import 'cart_table.dart';
import 'totals_bar.dart';
import 'bottom_actions.dart';

class DesktopLayout extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const DesktopLayout({super.key, required this.scaffoldKey});

  @override
  State<DesktopLayout> createState() => _DesktopLayoutState();
}

class _DesktopLayoutState extends State<DesktopLayout> {
  void _onMedicineSelected(BuildContext context, MedicineModel item) {
    context.read<PosBloc>().add(PosAddMedicine(item));
  }



  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PosBloc>();
    return BlocBuilder<PosBloc, PosState>(
      builder: (context, state) {
        return Focus(
          autofocus: true,
          onKeyEvent: (node, event) {
            if (event is KeyDownEvent || event is KeyRepeatEvent) {
              if (HardwareKeyboard.instance.isControlPressed) {
                switch (event.logicalKey) {
                  case LogicalKeyboardKey.keyS:
                    bloc.add(const PosCompleteSaleCash());
                    return KeyEventResult.handled;
                  case LogicalKeyboardKey.keyB:
                    bloc.add(const PosCompleteSaleCard());
                    return KeyEventResult.handled;
                  case LogicalKeyboardKey.keyM:
                    bloc.add(const PosCompleteSaleMixed());
                    return KeyEventResult.handled;
                  case LogicalKeyboardKey.keyA:
                    bloc.add(const PosCompleteSaleCredit());
                    return KeyEventResult.handled;
                  case LogicalKeyboardKey.keyT:
                    bloc.add(const PosSuspendSale());
                    return KeyEventResult.handled;
                  case LogicalKeyboardKey.keyD:
                    bloc.add(const PosRemoveSelectedLine());
                    return KeyEventResult.handled;
                  case LogicalKeyboardKey.keyP:
                    bloc.add(const PosCreateQuoteFromCart());
                    return KeyEventResult.handled;
                  case LogicalKeyboardKey.escape:
                    bloc.add(const PosClearCart());
                    return KeyEventResult.handled;
                  default:
                    break;
                }
              }
            }
            return KeyEventResult.ignored;
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(context, state),
              DesktopToolbar(controller: bloc),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(AppSpacing.sm.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: _buildPriceGroupDropdown(context, state),
                                    ),
                                    SizedBox(width: AppSpacing.sm.w),
                                    Expanded(
                                      flex: 5,
                                      child: BlocBuilder<CatalogCubit, CatalogState>(
                                        builder: (context, catalogState) {
                                          return MedicineSearchField(
                                            label: SalesStrings.barcodeOrNameSearch,
                                            hint: SalesStrings.startTypingOrScan,
                                            customItems: catalogState.medicines,
                                            onSelected: (med) => _onMedicineSelected(context, med),
                                            onChanged: (v) => context.read<CatalogCubit>().updateSearch(v),
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(width: AppSpacing.sm.w),
                                    Expanded(
                                      flex: 2,
                                      child: _buildCustomerSection(context, state, bloc),
                                    ),
                                  ],
                                ),
                                SizedBox(height: AppSpacing.sm.h),
                                Expanded(
                                  child: DesktopCartTable(controller: bloc),
                                ),
                                SizedBox(height: AppSpacing.xs.h),
                                DesktopTotalsBar(controller: bloc),
                              ],
                            ),
                          ),
                        ),
                        if (state.showProducts) ...[
                          _buildResizeDivider(context, bloc),
                          SizedBox(
                            width: state.catalogWidth.w,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(right: BorderSide(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3))),
                              ),
                              padding: EdgeInsets.all(AppSpacing.sm.w),
                              child: const PosCatalogPanel(),
                            ),
                          ),
                        ],
                      ],
                    );
                  },
                ),
              ),
              DesktopBottomActions(controller: bloc),
            ],
          ),
        );
      },
    );
  }

  Widget _buildResizeDivider(BuildContext context, PosBloc bloc) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onHorizontalDragUpdate: (details) {
        final newWidth = bloc.state.catalogWidth - details.delta.dx;
        if (newWidth > 200 && newWidth < 900) {
          bloc.add(PosUpdateCatalogWidth(newWidth));
        }
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.resizeColumn,
        child: Container(
          width: 8.w,
          color: Colors.transparent,
          child: Center(
            child: Container(
              width: 2.w,
              height: 80.h,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(1.r),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, PosState state) {
    final String formattedDate = DateFormat('EEEE، d MMMM y', 'ar').format(DateTime.now());
    final bloc = context.read<PosBloc>();
    final scheme = Theme.of(context).colorScheme;
    final isDark = AppColors.isDark(context);

    return Container(
      height: 52.h,
      color: isDark ? scheme.surface : AppColors.surfaceTintDarkAlt,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.menu_rounded, color: isDark ? scheme.onSurface : Colors.white, size: 22),
            tooltip: SalesStrings.quickNavTooltip,
            onPressed: () => widget.scaffoldKey.currentState?.openDrawer(),
          ),
          SizedBox(width: 8.w),
          _headerPill(
            context,
            icon: Icons.home_rounded,
            text: SalesStrings.homeAction,
            onTap: () => context.go('/home'),
          ),
          SizedBox(width: 12.w),
          _headerPill(
            context,
            icon: state.showProducts ? Icons.visibility_off_rounded : Icons.visibility_rounded,
            text: state.showProducts ? SalesStrings.posHideProducts : SalesStrings.posShowProducts,
            color: state.showProducts ? AppColors.warning : null,
            onTap: () => bloc.add(const PosToggleCatalog()),
          ),
          SizedBox(width: 12.w),
          _headerPill(context, icon: Icons.calendar_today_rounded, text: formattedDate),
          SizedBox(width: 12.w),
          BlocBuilder<PosBloc, PosState>(
            builder: (context, state) {
              final shift = state.currentShift;
              final isOpen = shift != null;
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _headerPill(
                    context,
                    icon: isOpen ? Icons.lock_open_rounded : Icons.lock_clock_rounded,
                    text: isOpen ? SalesStrings.shiftInfoFormat.replaceFirst('%s', shift.shiftNumber.toString()).replaceFirst('%s', FormatUtils.shiftDuration(shift.openedAt)) : SalesStrings.shiftIsClosed,
                    color: isOpen ? AppColors.success : AppColors.error,
                    onTap: () => context.go(Routes.SALES_CASHIER_SHIFTS),
                  ),
                  if (isOpen) ...[
                    SizedBox(width: 8.w),
                    IconButton(
                      icon: Icon(Icons.lock_rounded, color: isDark ? scheme.onSurface.withValues(alpha: 0.7) : Colors.white70, size: 18.sp),
                      tooltip: SalesStrings.closeShiftTitle,
                      onPressed: () => _showCloseShiftDialog(context, shift, state),
                    ),
                  ],
                ],
              );
            },
          ),
          const Spacer(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: (isDark ? scheme.primary : Colors.white).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Row(
              children: [
                Icon(Icons.person_pin_rounded, color: isDark ? scheme.primary : Colors.white70, size: 16.sp),
                SizedBox(width: 8.w),
                ReusableText(
                  bloc.userName,
                  style: TextStyle(color: isDark ? scheme.onSurface : Colors.white, fontSize: 12.sp, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerPill(BuildContext context, {required IconData icon, required String text, Color? color, VoidCallback? onTap}) {
    final isDark = AppColors.isDark(context);
    final scheme = Theme.of(context).colorScheme;
    final baseColor = isDark ? scheme.onSurface : Colors.white;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: baseColor.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(color: (color ?? baseColor).withValues(alpha: 0.15)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14.sp, color: color ?? baseColor.withValues(alpha: 0.7)),
            SizedBox(width: 6.w),
            ReusableText(
              text,
              style: TextStyle(color: color ?? baseColor, fontSize: 11.sp, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  void _showCloseShiftDialog(BuildContext context, CashierShiftModel shift, PosState state) {
    final cashController = TextEditingController();
    final notesController = TextEditingController();

    final cashSales = state.shiftCashSales;
    final expectedCash = shift.openingCash + cashSales;

    showDialog(
      context: context,
      builder: (ctx) => ReusableDialog(
        title: SalesStrings.closeShiftTitle,
        children: [
          ReusableText('${HomeStrings.sidebarCashierShifts} #${shift.shiftNumber}', style: const TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: AppSpacing.sm),
          TotalsRow(label: SalesStrings.cashSalesLabel, value: FormatUtils.currency(cashSales)),
          Divider(height: AppSpacing.md),
          TotalsRow(label: SalesStrings.expectedCashLabel, value: FormatUtils.currency(expectedCash), color: AppColors.primary, bold: true),
          SizedBox(height: AppSpacing.md),
          ReusableInput(
            controller: cashController,
            label: SalesStrings.actualCashLabel,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          SizedBox(height: AppSpacing.sm),
          ReusableInput(
            controller: notesController,
            label: SalesStrings.optionalNotesLabel,
            maxLines: 2,
          ),
          SizedBox(height: 16.h),
          DialogActions(
            cancelText: GeneralStrings.cancel,
            confirmText: SalesStrings.closeShiftTitle,
            onCancel: () => Navigator.of(ctx).pop(),
            onConfirm: () {
              final countedCash = double.tryParse(cashController.text) ?? 0;
              context.read<PosBloc>().add(PosCloseShift(countedCash, notes: notesController.text.trim().isEmpty ? null : notesController.text.trim()));
              Navigator.pop(ctx);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPriceGroupDropdown(BuildContext context, PosState state) {
    return ReusableDropdown<String>(
      hintText: SalesStrings.defaultSellPriceGroup,
      value: state.selectedPriceGroup,
      items: const ['default', 'wholesale', 'semi_wholesale'],
      itemAsString: (v) => switch (v) {
        'default' => SalesStrings.regularPriceLabel,
        'wholesale' => SalesStrings.wholesalePriceLabel,
        'semi_wholesale' => SalesStrings.semiWholesalePriceLabel,
        _ => '',
      },
      onChanged: (v) {
        if (v != null) {
          context.read<PosBloc>().add(PosSetPriceGroup(v));
        }
      },
      isCompact: true,
      prefixIcon: Icons.price_change_outlined,
    );
  }

  Widget _buildCustomerSection(BuildContext context, PosState state, PosBloc bloc) {
    final customers = state.customers;
    final selectedCustomer = state.selectedCustomerId != null ? customers.firstWhereOrNull((c) => c.id == state.selectedCustomerId) : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        ReusableDropdown<CustomerModel?>(
          hintText: SalesStrings.fastCashCustomer,
          value: selectedCustomer,
          items: [null, ...customers],
          itemAsString: (c) {
            if (c == null) return SalesStrings.fastCashCustomer;
            final name = c.name.trim().isEmpty ? SalesStrings.unnamedCustomer : c.name;
            final phone = c.phone?.isNotEmpty == true ? ' - ${c.phone}' : '';
            final isJoint = state.suppliers.any((s) => s.id == c.id);
            final type = isJoint ? SalesStrings.jointSupplierCustomer : (c.kind == CustomerKind.regular ? '(${SalesStrings.cartPaymentCredit})' : '(${GeneralStrings.enumCustomerCash})');
            final limit = c.creditLimit > 0 ? SalesStrings.creditLimitFormat.replaceFirst('%s', c.creditLimit.toStringAsFixed(0)) : '';
            return '$name$phone $type$limit';
          },
          onChanged: (v) {
            bloc.add(PosSelectCustomer(v?.id));
            if (v != null) {
              bloc.add(PosLoadCustomerBalance(v.id));
            }
          },
          isCompact: true,
          prefixIcon: Icons.person_search_rounded,
        ),
        _buildCustomerBalance(state, selectedCustomer),
      ],
    );
  }

  Widget _buildCustomerBalance(PosState state, CustomerModel? selectedCustomer) {
    if (selectedCustomer == null) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 4.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: AppColors.error.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(4.r),
            border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.account_balance_wallet_rounded, size: 12.sp, color: AppColors.error),
              SizedBox(width: 4.w),
              ReusableText(
                SalesStrings.balanceFormat.replaceFirst('%s', FormatUtils.currency(state.customerBalance)),
                style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold, color: AppColors.error),
              ),
            ],
          ),
        ),
      ],
    );
  }
}





