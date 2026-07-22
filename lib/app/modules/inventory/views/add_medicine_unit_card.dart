import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_strings.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_colors.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_sizes.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/index.dart';
import 'add_medicine_form_data.dart';

class AddUnitCard extends StatefulWidget {
  final AddUnitFormData data;
  final int index;
  final bool showOldPrice;
  final bool canDelete;
  final VoidCallback onDelete;
  final VoidCallback onPriceChanged;

  const AddUnitCard({
    super.key,
    required this.data,
    required this.index,
    required this.showOldPrice,
    required this.canDelete,
    required this.onDelete,
    required this.onPriceChanged,
  });

  @override
  State<AddUnitCard> createState() => _AddUnitCardState();
}

class _AddUnitCardState extends State<AddUnitCard> {
  bool get isMain => widget.index == 0;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final data = widget.data;
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg.w),
      margin: EdgeInsets.only(bottom: AppSpacing.lg.h),
      decoration: BoxDecoration(
        color: isMain
            ? scheme.primary.withValues(alpha: 0.01)
            : scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: isMain
              ? scheme.primary.withValues(alpha: 0.2)
              : scheme.outline.withValues(alpha: 0.4),
          width: isMain ? 1.5 : 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 26.w,
                height: 26.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isMain ? scheme.primary : scheme.outline,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: ReusableText(
                  '${widget.index + 1}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: AppSpacing.sm.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReusableText(
                      isMain
                          ? AppStrings.mainUnitTitleSimple
                          : AppStrings.subUnitTitleSimple,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (!isMain)
                      Padding(
                        padding: EdgeInsets.only(top: 2.h),
                        child: ReusableText(
                          '${AppStrings.conversionFactorInfoSimplePrefix}${data.factorController.text}${AppStrings.fromThisSubUnit}',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: scheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (widget.canDelete)
                IconButton(
                  icon: Icon(
                    Icons.delete_forever_rounded,
                    color: AppColors.error,
                    size: 20.sp,
                  ),
                  onPressed: widget.onDelete,
                ),
            ],
          ),
          SizedBox(height: AppSpacing.lg.h),
          Row(
            children: [
              Expanded(
                child: ReusableInput(
                  controller: data.nameController,
                  label: isMain
                      ? AppStrings.mainUnitNameLabelSimple
                      : AppStrings.subUnitNameLabelSimple,
                  prefixIcon: const Icon(Icons.straighten_rounded),
                ),
              ),
              if (!isMain) ...[
                SizedBox(width: AppSpacing.lg.w),
                Expanded(
                  child: ReusableInput(
                    controller: data.factorController,
                    label: AppStrings.factorLabelSimple,
                    prefixIcon: const Icon(Icons.pin_outlined),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: AppSpacing.lg.h),
          Row(
            children: [
              Expanded(
                child: ReusableInput(
                  controller: data.buyPriceController,
                  label: AppStrings.buyPriceLabelSimple,
                  prefixIcon: Icon(
                    Icons.price_change_outlined,
                    color: Colors.green[600],
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  onChanged: (_) => widget.onPriceChanged(),
                ),
              ),
              SizedBox(width: AppSpacing.lg.w),
              Expanded(
                child: ReusableInput(
                  controller: data.sellPriceController,
                  label: AppStrings.sellPriceLabelSimple,
                  prefixIcon: Icon(
                    Icons.sell_outlined,
                    color: scheme.primary,
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  onChanged: (_) => widget.onPriceChanged(),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.lg.h),
          Row(
            children: [
              if (widget.showOldPrice) ...[
                Expanded(
                  child: ReusableInput(
                    controller: data.oldPriceController,
                    label: AppStrings.oldSellPriceLabelSimple,
                    prefixIcon: const Icon(Icons.money_off_rounded),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                ),
                SizedBox(width: AppSpacing.lg.w),
              ],
              Expanded(
                child: ReusableInput(
                  controller: data.quantityController,
                  label: AppStrings.currentStockLabelSimple,
                  prefixIcon: const Icon(Icons.store_rounded),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.lg.h),
          Row(
            children: [
              Expanded(
                child: ReusableInput(
                  controller: data.discountController,
                  label: AppStrings.discountLabelSimple,
                  prefixIcon: const Icon(Icons.percent_rounded),
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(width: AppSpacing.lg.w),
              Expanded(
                child: Center(
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () =>
                            setState(() => data.allowSale = !data.allowSale),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.xl.w,
                            vertical: AppSpacing.sm.h,
                          ),
                          decoration: BoxDecoration(
                            color: data.allowSale
                                ? AppColors.success.withValues(alpha: 0.08)
                                : AppColors.error.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            border: Border.all(
                              color: data.allowSale
                                  ? AppColors.success.withValues(alpha: 0.3)
                                  : AppColors.error.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                data.allowSale
                                    ? Icons.check_circle_rounded
                                    : Icons.block_rounded,
                                size: 16.sp,
                                color: data.allowSale
                                    ? AppColors.success
                                    : AppColors.error,
                              ),
                              SizedBox(width: AppSpacing.xs.w),
                              ReusableText(
                                data.allowSale
                                    ? AppStrings.allowSaleLabel
                                    : AppStrings.blockSaleLabelSimple,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: data.allowSale
                                      ? AppColors.success
                                      : AppColors.error,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
