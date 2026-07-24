import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_system/app/shared/ui_core.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class PaymentDialog {
  PaymentDialog._();

  static Future<void> show(
    BuildContext context, {
    required String title,
    required Future<void> Function(double amount, String? notes) onSubmit,
  }) {
    final amountCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return WoltModalSheet.show<void>(
      context: context,
      pageListBuilder: (modalSheetContext) {
        return [
          WoltModalSheetPage(
            leadingNavBarWidget: IconButton(
              icon: const Icon(Icons.close_rounded),
              onPressed: () => Navigator.of(modalSheetContext).pop(),
            ),
            pageTitle: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  Icon(
                    Icons.account_balance_wallet_rounded,
                    color: AppColors.primary,
                    size: AppIconSize.md.value,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      title,
                      style: AppTextStyles.title(context).copyWith(
                        color: AppColors.textPrimaryOf(modalSheetContext),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                16.w,
                16.h,
                16.w,
                100.h,
              ), // Extra padding at bottom to avoid blocking by sticky action bar
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // حقل إدخال المبلغ
                    AppInput(
                      label: WidgetStrings.paymentAmountLabel,
                      hint: '0.00',
                      controller: amountCtrl,
                      prefixIcon: const Icon(Icons.attach_money_rounded),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return WidgetStrings.paymentAmountRequired;
                        }
                        final num = double.tryParse(val);
                        if (num == null || num <= 0) {
                          return WidgetStrings.paymentValidNumber;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),

                    // حقل إدخال الملاحظات
                    AppInput(
                      label: WidgetStrings.paymentNotesLabel,
                      hint: WidgetStrings.paymentNotesHint,
                      controller: notesCtrl,
                      textDirection: TextDirection.rtl,
                      alignLabelWithHint: true,
                      maxLines: 2,
                      prefixIcon: const Icon(Icons.notes_rounded),
                    ),
                  ],
                ),
              ),
            ),
            stickyActionBar: Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  Expanded(
                    child: ReusableButton(
                      text: GeneralStrings.cancel,
                      type: ButtonType.text,
                      onPressed: () => Navigator.of(modalSheetContext).pop(),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ReusableButton(
                      text: SalesStrings.recordPayment,
                      type: ButtonType.primary,
                      onPressed: () {
                        if (!formKey.currentState!.validate()) return;

                        final amount = double.parse(amountCtrl.text);
                        final notes = notesCtrl.text.trim().nullIfEmpty;

                        // نقفل الديالوج فوراً لتأمين الـ Navigation Stack
                        Navigator.of(modalSheetContext).pop();

                        // تنفيذ العملية في الخلفية
                        onSubmit(amount, notes);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ];
      },
    );
  }
}
