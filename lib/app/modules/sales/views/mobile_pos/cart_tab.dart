import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pharmacy_system/app/core/presentation/theme/app_colors.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/index.dart';
import 'package:pharmacy_system/app/modules/sales/bloc/pos_bloc.dart';
import 'package:pharmacy_system/app/core/constants/app_strings.dart';
import 'package:pharmacy_system/app/modules/sales/widgets/pos_cart_panel.dart';

class MobileCartTab extends StatelessWidget {
  final PosBloc controller;
  const MobileCartTab({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PosBloc, PosState>(
      bloc: controller,
      builder: (context, state) {
        final isEnabled = !state.isProcessing;
        return SingleChildScrollView(
          padding: EdgeInsets.all(8.w),
          child: Column(
            children: [
              const PosCartPanel(),
              SizedBox(height: 8.h),
              Row(
                children: [
                  ReusableIconTextButton(
                    icon: Icons.cancel_outlined,
                    label: AppStrings.cancel,
                    color: AppColors.error,
                    onPressed: () => controller.add(const PosClearCart()),
                    isEnabled: isEnabled,
                  ),
                  ReusableIconTextButton(
                    icon: Icons.monetization_on_outlined,
                    label: AppStrings.enumCustomerCash,
                    color: AppColors.posCategoryColor(6),
                    onPressed: () => controller.add(const PosCompleteSaleCash()),
                    isEnabled: isEnabled,
                  ),
                ],
              ),
              SizedBox(height: 6.h),
              Row(
                children: [
                  ReusableIconTextButton(
                    icon: Icons.credit_card_outlined,
                    label: AppStrings.cartPaymentCard,
                    color: AppColors.posCategoryColor(11),
                    onPressed: () => controller.add(const PosCompleteSaleCard()),
                    isEnabled: isEnabled,
                  ),
                  ReusableIconTextButton(
                    icon: Icons.account_balance_wallet_rounded,
                    label: AppStrings.cartPaymentMixed,
                    color: AppColors.surfaceTintDark,
                    onPressed: () => controller.add(const PosCompleteSaleMixed()),
                    isEnabled: isEnabled,
                  ),
                ],
              ),
              SizedBox(height: 6.h),
              Row(
                children: [
                  ReusableIconTextButton(
                    icon: Icons.handshake_outlined,
                    label: AppStrings.cartPaymentCredit,
                    color: AppColors.posCategoryColor(1),
                    onPressed: () => controller.add(const PosCompleteSaleCredit()),
                    isEnabled: isEnabled,
                  ),
                  ReusableIconTextButton(
                    icon: Icons.pause_circle_outlined,
                    label: AppStrings.cartSuspend,
                    color: AppColors.posCategoryColor(7),
                    onPressed: () => controller.add(const PosSuspendSale()),
                    isEnabled: isEnabled,
                  ),
                ],
              ),
              SizedBox(height: 6.h),
              Row(
                children: [
                  Expanded(
                    child: ReusableIconTextButton(
                      icon: Icons.description_outlined,
                      label: AppStrings.printQuote,
                      color: AppColors.posCategoryColor(9),
                      onPressed: () => controller.add(const PosCreateQuoteFromCart()),
                      isEnabled: isEnabled,
                      expand: false,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
