import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../bloc/pos_bloc.dart';
import '../../../../models/pos_cart_line.dart';
import 'package:pharmacy_system/app/core/constants/app_strings.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/index.dart';

class EditCartLineDialog {
  static void show(
    BuildContext context,
    PosBloc controller,
    PosCartLine line,
  ) {
    final priceCtrl = TextEditingController(
      text: line.unitPrice.toStringAsFixed(2),
    );
    final discountCtrl = TextEditingController();

    String discountType = AppStrings.fixedAmountShort;

    if (line.discountPercent > 0) {
      discountCtrl.text = line.discountAmount.toStringAsFixed(2);
    } else {
      discountCtrl.text = '0.00';
    }

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => ReusableDialog(
          title: '${line.medicine.name} - ${line.medicine.barcodes.firstOrNull ?? ""}',
          headerIcon: const Icon(Icons.edit_rounded),
          maxWidth: 500,
          children: [
            Row(
              children: [
                Expanded(
                  child: ReusableInput(
                    label: AppStrings.unitPriceLabel,
                    controller: priceCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    prefixIcon: const Icon(Icons.attach_money_rounded),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ReusableDropdown<String>(
                    labelText: AppStrings.discountTypeFieldLabel,
                    hintText: AppStrings.select,
                    value: discountType,
                    items: const [AppStrings.fixedAmountShort, AppStrings.cartDiscountPercent],
                    itemAsString: (v) => v,
                    onChanged: (v) {
                      if (v != null) {
                        setState(() => discountType = v);
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            ReusableInput(
              label: AppStrings.discountAmountFieldLabel,
              controller: discountCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              prefixIcon: const Icon(Icons.money_off_rounded),
            ),
            SizedBox(height: 12.h),
            ReusableInput(
              label: AppStrings.itemNotesFieldLabel,
              controller: TextEditingController(
                text: line.medicine.description ?? line.medicine.name,
              ),
              readOnly: true,
              maxLines: 2,
            ),
            SizedBox(height: 24.h),
            DialogActions(
              confirmText: AppStrings.apply,
              onConfirm: () {
                final newPrice = double.tryParse(priceCtrl.text) ?? line.unitPrice;
                final discountVal = double.tryParse(discountCtrl.text) ?? 0.0;

                double percent = 0.0;
                if (discountType == AppStrings.cartDiscountPercent) {
                  percent = discountVal;
                } else {
                  final gross = newPrice * line.quantity;
                  if (gross > 0) {
                    percent = (discountVal / gross) * 100;
                  }
                }

                controller.add(PosUpdateLinePrice(line.medicine.id, newPrice));
                controller.add(PosUpdateLineDiscount(line.medicine.id, percent));
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
