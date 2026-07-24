import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_system/app/core/constants/app_strings.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_colors.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/index.dart';
import '../../bloc/pos_bloc.dart';

class DesktopBottomActions extends StatelessWidget {
  final PosBloc controller;
  const DesktopBottomActions({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54.h,
      color: Theme.of(context).colorScheme.surface,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
      child: Row(
        children: [
          _bottomActionBtn(
            SalesStrings.drafts,
            'Ctrl+D',
            AppColors.info,
            () => controller.add(const PosSuspendSale()),
          ),
          _bottomActionBtn(
            SalesStrings.priceQuotes,
            'Ctrl+P',
            AppColors.warning,
            () => controller.add(const PosCreateQuoteFromCart()),
          ),
          _bottomActionBtn(
            SalesStrings.cartPaymentCredit,
            'Ctrl+A',
            AppColors.posCategoryColor(1),
            () => controller.add(const PosCompleteSaleCredit()),
          ),
          _bottomActionBtn(
            SalesStrings.cartPaymentCard,
            'Ctrl+B',
            AppColors.posCategoryColor(11),
            () => controller.add(const PosCompleteSaleCard()),
          ),
          _bottomActionBtn(
            SalesStrings.cartPaymentMixed,
            'Ctrl+M',
            AppColors.surfaceTintDarkAlt,
            () => controller.add(const PosCompleteSaleMixed()),
          ),
          _bottomActionBtn(
            SalesStrings.cartPaymentCash,
            'Ctrl+S',
            AppColors.success,
            () => controller.add(const PosCompleteSaleCash()),
          ),
          _bottomActionBtn(
            GeneralStrings.cancel,
            'Esc',
            AppColors.error,
            () => controller.add(const PosClearCart()),
          ),
        ],
      ),
    );
  }

  Widget _bottomActionBtn(String label, String shortcut, Color color, VoidCallback onPressed) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        child: ReusableButton(
          text: label,
          color: color,
          onPressed: onPressed,
          height: double.infinity,
        ),
      ),
    );
  }
}




