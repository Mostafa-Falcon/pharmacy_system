import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_colors.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/format_utils.dart';
import '../../bloc/pos_bloc.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/index.dart';
import 'package:pharmacy_system/app/core/models/sales/cashier_shift_model.dart';

class MobileAppBar extends StatelessWidget implements PreferredSizeWidget {
  final PosBloc controller;
  const MobileAppBar({super.key, required this.controller});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.surfaceTintDarkAlt,
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.menu_rounded, color: Colors.white),
            tooltip: SalesStrings.quickNavTooltip,
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      title: BlocBuilder<PosBloc, PosState>(
        builder: (context, state) {
          final shift = state.currentShift;
          final isOpen = shift != null;
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.circle,
                size: 8,
                color: isOpen ? AppColors.success : AppColors.error,
              ),
              SizedBox(width: 6.w),
              Text(
                controller.userName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (isOpen) ...[
                SizedBox(width: 6.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text(
                    '#${shift.shiftNumber}',
                    style: TextStyle(color: Colors.white70, fontSize: 10.sp),
                  ),
                ),
              ],
            ],
          );
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.calculate_outlined, color: Colors.white70),
          onPressed: () => ReusableCalculator.show(context),
        ),
        BlocBuilder<PosBloc, PosState>(
          builder: (context, state) {
            final count =
                state.nearExpiryCount + state.lowStockCount + state.expiredCount;
            return Badge(
              isLabelVisible: count > 0,
              label: Text('$count', style: TextStyle(fontSize: 9.sp)),
              child: IconButton(
                icon: const Icon(
                  Icons.notifications_none_rounded,
                  color: Colors.white70,
                ),
                onPressed: () => _showNotificationsDialog(context),
              ),
            );
          },
        ),
        BlocBuilder<PosBloc, PosState>(
          builder: (context, state) {
            final shift = state.currentShift;
            if (shift == null) return const SizedBox.shrink();
            return IconButton(
              icon: const Icon(Icons.lock_rounded, color: Colors.white70),
              tooltip: SalesStrings.closeShiftTitle,
              onPressed: () => _showCloseShiftDialog(context, shift),
            );
          },
        ),
      ],
    );
  }

  void _showNotificationsDialog(BuildContext context) {
    final state = controller.state;
    final nearExpiry = state.nearExpiryItems;
    final lowStock = state.lowStockItems;

    showDialog(
      context: context,
      builder: (context) => ReusableDialog(
        headerIcon: const Icon(
          Icons.notifications_active_rounded,
          color: Colors.white,
        ),
        headerIconColor: AppColors.warning,
        title: NotificationsStrings.notificationsCenterTitle,
        maxWidth: 500,
        children: [
          if (nearExpiry.isEmpty && lowStock.isEmpty)
            const EmptyState(
              icon: Icons.check_circle_outline_rounded,
              title: NotificationsStrings.noNotificationsCurrent,
            )
          else
            SizedBox(
              height: 400.h,
              child: ListView(
                children: [
                  if (nearExpiry.isNotEmpty) ...[
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.h),
                      child: Text(
                        '${NotificationsStrings.nearExpiryTitle} (${nearExpiry.length})',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 11.sp,
                          color: AppColors.warning,
                        ),
                      ),
                    ),
                    ...nearExpiry.take(10).map(
                      (m) => ListTile(
                        dense: true,
                        leading: const Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: AppColors.warning,
                        ),
                        title: Text(m.name, style: TextStyle(fontSize: 11.sp)),
                        trailing: Text(
                          '${m.expiryDate!.difference(DateTime.now()).inDays} ${PurchasesStrings.days}',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: AppColors.warning,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                  if (lowStock.isNotEmpty) ...[
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.h),
                      child: Text(
                        '${NotificationsStrings.lowStockTitle} (${lowStock.length})',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 11.sp,
                          color: AppColors.info,
                        ),
                      ),
                    ),
                    ...lowStock.take(10).map(
                      (m) => ListTile(
                        dense: true,
                        leading: const Icon(
                          Icons.inventory_2_outlined,
                          size: 16,
                          color: AppColors.info,
                        ),
                        title: Text(m.name, style: TextStyle(fontSize: 11.sp)),
                        trailing: Text(
                          '${m.quantity}/${m.minStock}',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: AppColors.info,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _showCloseShiftDialog(BuildContext context, CashierShiftModel shift) {
    final cashController = TextEditingController();
    final notesController = TextEditingController();
    
    final state = controller.state;
    final cashSales = state.shiftCashSales;
    final expectedCash = shift.openingCash + cashSales;

    showDialog(
      context: context,
      builder: (ctx) => ReusableDialog(
        title: SalesStrings.closeShiftTitle,
        children: [
          ReusableText('${SalesStrings.shiftLabel} #${shift.shiftNumber}', style: const TextStyle(fontWeight: FontWeight.bold)),
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
              controller.add(PosCloseShift(countedCash, notes: notesController.text.trim().isEmpty ? null : notesController.text.trim()));
              Navigator.pop(ctx);
            },
          ),
        ],
      ),
    );
  }
}





