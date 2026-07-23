import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_colors.dart';

import '../../../../core/constants/app_strings.dart';
import 'package:pharmacy_system/app/core/presentation/design_system/design_system.dart';
import '../../../../routes/app_routes.dart';
import '../../bloc/pos_bloc.dart';
import 'dialogs.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/index.dart';

class DesktopToolbar extends StatelessWidget {
  final PosBloc controller;
  const DesktopToolbar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border(bottom: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.5))),
      ),
      child: BlocBuilder<PosBloc, PosState>(
        builder: (context, state) {
          final showProductsVal = state.showProducts;
          final isFSVal = state.isFullScreen;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _toolBtn(
                  context,
                  AppStrings.posAddExpenses,
                  Icons.add_card_rounded,
                  AppColors.posCategoryColor(0),
                  () => DesktopDialogs.showExpenseDialog(context, controller),
                ),
                _toolBtn(
                  context,
                  AppStrings.posItemInquiry,
                  Icons.search_rounded,
                  AppColors.posCategoryColor(1),
                  () => showDialog(
                    context: context,
                    builder: (context) => ReusableDialog(
                      title: AppStrings.posItemInquiry,
                      children: [
                        MedicineSearchField(
                          onSelected: (m) {
                            Navigator.pop(context);
                            DesktopDialogs.showItemInquiryDialog(context, controller, preSelected: m);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                _toolBtn(
                  context,
                  AppStrings.posQuickItems,
                  Icons.bolt_rounded,
                  AppColors.posCategoryColor(2),
                  () => DesktopDialogs.showQuickItemsDialog(context, controller),
                ),
                _toolBtn(
                  context,
                  AppStrings.promotionsTitle,
                  Icons.local_offer_rounded,
                  AppColors.posCategoryColor(14),
                  () => DesktopDialogs.showPromotionsDialog(context, controller),
                ),
                _toolBtn(
                  context,
                  AppStrings.damagedStockTitle,
                  Icons.warning_amber_rounded,
                  AppColors.posCategoryColor(15),
                  () => DesktopDialogs.showDamagedStockDialog(context, controller),
                ),
                _toolBtn(
                  context,
                  AppStrings.openingStockTitle,
                  Icons.playlist_add_check_rounded,
                  AppColors.posCategoryColor(16),
                  () => DesktopDialogs.showOpeningStockDialog(context, controller),
                ),
                _toolBtn(
                  context,
                  AppStrings.posSuspendedSales,
                  Icons.pause_circle_outline,
                  AppColors.posCategoryColor(3),
                  () => DesktopDialogs.showSuspendedSalesDialog(
                    context,
                    controller,
                  ),
                ),
                _toolBtn(
                  context,
                  AppStrings.posRecentTransactions,
                  Icons.history_rounded,
                  AppColors.posCategoryColor(4),
                  () => DesktopDialogs.showRecentSalesDialog(context, controller),
                ),
                _toolBtn(
                  context,
                  AppStrings.posLoadFromCustomer,
                  Icons.download_rounded,
                  AppColors.posCategoryColor(5),
                  () => DesktopDialogs.showLoadFromCustomerDialog(context, controller),
                ),
                _toolBtn(
                  context,
                  AppStrings.posCustomerPayment,
                  Icons.payments_rounded,
                  AppColors.posCategoryColor(6),
                  () => DesktopDialogs.showPaymentDialog(
                    context,
                    controller,
                    isCustomer: true,
                  ),
                ),
                _toolBtn(
                  context,
                  AppStrings.posSupplierPayment,
                  Icons.account_balance_wallet_rounded,
                  AppColors.posCategoryColor(7),
                  () => DesktopDialogs.showPaymentDialog(
                    context,
                    controller,
                    isCustomer: false,
                  ),
                ),
                _toolBtn(
                  context,
                  AppStrings.posSalesReturn,
                  Icons.assignment_return_outlined,
                  AppColors.posCategoryColor(8),
                  () => context.push(Routes.SALES_RETURN),
                ),
                _toolBtn(
                  context,
                  AppStrings.posCalculator,
                  Icons.calculate_outlined,
                  AppColors.posCategoryColor(9),
                  () => ReusableCalculator.show(context),
                ),
                _toolBtn(
                  context,
                  showProductsVal ? AppStrings.posHideProducts : AppStrings.posShowProducts,
                  Icons.grid_view_rounded,
                  AppColors.posCategoryColor(10),
                  () => controller.add(const PosToggleCatalog()),
                ),
                _toolBtn(
                  context,
                  isFSVal ? AppStrings.posExitFullScreen : AppStrings.posFullScreen,
                  Icons.fullscreen_rounded,
                  AppColors.posCategoryColor(11),
                  () => controller.add(const PosToggleFullScreen()),
                ),
                _toolBtn(
                  context,
                  AppStrings.posSessionDetails,
                  Icons.info_outline_rounded,
                  AppColors.posCategoryColor(12),
                  () => DesktopDialogs.showSessionDetailsDialog(
                    context,
                    controller,
                  ),
                ),
                _toolBtn(
                  context,
                  AppStrings.posCloseShift,
                  Icons.exit_to_app_rounded,
                  AppColors.posCategoryColor(13),
                  () => DesktopDialogs.showCloseShiftDialog(context, controller),
                ),
                _toolBtn(
                  context,
                  state.isPrintEnabled ? AppStrings.printEnabled : AppStrings.printDisabled,
                  state.isPrintEnabled ? Icons.print_rounded : Icons.print_disabled_rounded,
                  state.isPrintEnabled ? AppColors.success : AppColors.error,
                  () => controller.add(const PosTogglePrint()),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _toolBtn(BuildContext context, String title, IconData icon, Color color, VoidCallback onPressed) {
    final isDark = AppColors.isDark(context);
    final adjustedColor = isDark ? Color.lerp(color, Colors.white, 0.2) ?? color : color;

    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        foregroundColor: adjustedColor,
        backgroundColor: adjustedColor.withValues(alpha: isDark ? 0.12 : 0.05),
        side: BorderSide(color: adjustedColor.withValues(alpha: isDark ? 0.4 : 0.3), width: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      ),
      onPressed: onPressed,
      icon: Icon(icon, color: adjustedColor, size: 14.sp),
      label: Text(
        title,
        style: TextStyle(color: adjustedColor, fontSize: 11.sp, fontWeight: FontWeight.bold),
      ),
    );
  }
}
