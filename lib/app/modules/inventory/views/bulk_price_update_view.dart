import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_strings.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_colors.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_sizes.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/index.dart';
import '../bloc/bulk_price/bulk_price_update_bloc.dart';

class BulkPriceUpdateView extends StatefulWidget {
  const BulkPriceUpdateView({super.key});

  @override
  State<BulkPriceUpdateView> createState() => _BulkPriceUpdateViewState();
}

class _BulkPriceUpdateViewState extends State<BulkPriceUpdateView> {
  final _valueController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<BulkPriceUpdateBloc>().add(const BulkPriceUpdateLoadCategories());
  }

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BulkPriceUpdateBloc, BulkPriceUpdateState>(
      listener: (context, state) {
        if (state.isSuccess && state.message != null) {
          AppSnackbar.success(state.message!);
        }
      },
      builder: (context, state) {
        return StandardModuleLayout(
          title: AppStrings.bulkPriceUpdateTitle,
          useShell: state.categories.isEmpty,
          content: ListView(
            padding: EdgeInsets.all(AppSpacing.md.w),
            children: [
              AppCard(
                padding: EdgeInsets.all(AppSpacing.md.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionHeader(
                      icon: Icons.price_change_rounded,
                      title: AppStrings.bulkPriceUpdateTitle,
                    ),
                    SizedBox(height: AppSpacing.sm.h),
                    ReusableText(AppStrings.bulkPriceUpdateDesc,
                        variant: ReusableTextVariant.caption),
                    SizedBox(height: AppSpacing.lg.h),
                    _buildCategorySection(state),
                    SizedBox(height: AppSpacing.md.h),
                    _buildFieldSection(state),
                    SizedBox(height: AppSpacing.md.h),
                    _buildOperationSection(state),
                    SizedBox(height: AppSpacing.md.h),
                    _buildValueSection(state),
                    if (state.affectedCount > 0) ...[
                      SizedBox(height: AppSpacing.md.h),
                      _buildPreviewSection(state),
                    ],
                    SizedBox(height: AppSpacing.lg.h),
                    _buildActions(state),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategorySection(BulkPriceUpdateState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ReusableText(AppStrings.bulkPriceUpdateApplyTo, style: const TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: AppSpacing.sm.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: [
            _choiceChip(AppStrings.bulkPriceUpdateAllItems, state.selectedCategory == null, () {
              context.read<BulkPriceUpdateBloc>().add(BulkPriceUpdateApply(
                field: state.selectedField,
                operation: state.selectedOperation,
                value: state.value,
              ));
            }),
            if (state.categories.isNotEmpty)
              SizedBox(
                width: 200.w,
                child: ReusableDropdown<String>(
                  labelText: AppStrings.bulkPriceUpdateCategory,
                  hintText: AppStrings.bulkPriceUpdateCategoryHint,
                  items: state.categories,
                  value: state.selectedCategory,
                  itemAsString: (s) => s,
                  onChanged: (v) {
                    if (v != null) {
                      context.read<BulkPriceUpdateBloc>().add(BulkPriceUpdateApply(
                        category: v,
                        field: state.selectedField,
                        operation: state.selectedOperation,
                        value: state.value,
                      ));
                    }
                  },
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _choiceChip(String label, bool selected, VoidCallback onTap) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
    );
  }

  Widget _buildFieldSection(BulkPriceUpdateState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ReusableText(AppStrings.bulkPriceUpdateField, style: const TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: AppSpacing.sm.h),
        Wrap(
          spacing: 8.w,
          children: [
            _choiceChip(AppStrings.bulkPriceUpdateFieldSellPrice, state.selectedField == 'sellPrice', () {
              context.read<BulkPriceUpdateBloc>().add(BulkPriceUpdateApply(
                field: 'sellPrice',
                operation: state.selectedOperation,
                value: state.value,
              ));
            }),
            _choiceChip(AppStrings.bulkPriceUpdateFieldBuyPrice, state.selectedField == 'buyPrice', () {
              context.read<BulkPriceUpdateBloc>().add(BulkPriceUpdateApply(
                field: 'buyPrice',
                operation: state.selectedOperation,
                value: state.value,
              ));
            }),
            _choiceChip(AppStrings.bulkPriceUpdateFieldBoth, state.selectedField == 'both', () {
              context.read<BulkPriceUpdateBloc>().add(BulkPriceUpdateApply(
                field: 'both',
                operation: state.selectedOperation,
                value: state.value,
              ));
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildOperationSection(BulkPriceUpdateState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ReusableText(AppStrings.bulkPriceUpdateOperation, style: const TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: AppSpacing.sm.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: [
            _opChip(AppStrings.bulkPriceUpdateOpSet, 'set', state),
            _opChip(AppStrings.bulkPriceUpdateOpIncrease, 'increase', state),
            _opChip(AppStrings.bulkPriceUpdateOpDecrease, 'decrease', state),
            _opChip(AppStrings.bulkPriceUpdateOpIncreasePercent, 'increasePercent', state),
            _opChip(AppStrings.bulkPriceUpdateOpDecreasePercent, 'decreasePercent', state),
          ],
        ),
      ],
    );
  }

  Widget _opChip(String label, String value, BulkPriceUpdateState state) {
    return ChoiceChip(
      label: Text(label),
      selected: state.selectedOperation == value,
      onSelected: (_) {
        context.read<BulkPriceUpdateBloc>().add(BulkPriceUpdateApply(
          field: state.selectedField,
          operation: value,
          value: state.value,
        ));
      },
    );
  }

  Widget _buildValueSection(BulkPriceUpdateState state) {
    final isPercent = state.selectedOperation.contains('Percent');
    return ReusableInput(
      label: isPercent ? AppStrings.bulkPriceUpdatePercentage : AppStrings.bulkPriceUpdateValue,
      hint: isPercent ? '10' : '0.00',
      controller: _valueController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      prefixIcon: Icon(isPercent ? Icons.percent_rounded : Icons.payments_rounded, size: 18),
      onChanged: (v) {
        final val = double.tryParse(v) ?? 0;
        context.read<BulkPriceUpdateBloc>().add(BulkPriceUpdateApply(
          field: state.selectedField,
          operation: state.selectedOperation,
          value: val,
        ));
      },
    );
  }

  Widget _buildPreviewSection(BulkPriceUpdateState state) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md.w),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.button.r),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded, color: AppColors.info, size: AppIconSize.md.value),
          SizedBox(width: AppSpacing.sm.w),
          Expanded(
            child: ReusableText(
              AppStrings.bulkPriceUpdateAffectedItems,
              variant: ReusableTextVariant.body,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.chip.r),
            ),
            child: ReusableText(
              state.affectedCount.toString(),
              style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BulkPriceUpdateState state) {
    return ReusableButton(
      text: AppStrings.bulkPriceUpdateApply,
      prefixIcon: Icons.price_change_rounded,
      type: ButtonType.primary,
      isLoading: state.isLoading,
      enabled: state.affectedCount > 0 && !state.isLoading,
      onPressed: () {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(AppStrings.bulkPriceUpdateApply),
            content: Text(AppStrings.bulkPriceUpdateConfirm.replaceAll('%s', state.affectedCount.toString())),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(AppStrings.cancel),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  context.read<BulkPriceUpdateBloc>().add(const BulkPriceUpdateConfirmApply());
                },
                child: Text(AppStrings.apply),
              ),
            ],
          ),
        );
      },
    );
  }
}

