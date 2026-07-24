import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_strings.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_colors.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_sizes.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/index.dart';
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
    final scheme = Theme.of(context).colorScheme;

    return BlocConsumer<BulkPriceUpdateBloc, BulkPriceUpdateState>(
      listener: (context, state) {
        if (state.isSuccess && state.message != null) {
          AppSnackbar.success(state.message!);
        }
      },
      builder: (context, state) {
        return StandardModuleLayout(
          title: InventoryStrings.bulkPriceUpdateTitle,
          subtitle: InventoryStrings.bulkPriceUpdateDesc,
          content: SingleChildScrollView(
            padding: EdgeInsets.all(AppSpacing.xl.w),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 900.w),
                child: Column(
                  children: [
                    // Card 1: Scope Selection (Apply To)
                    _buildStepCard(
                      title: '????? ??? (??????)',
                      icon: Icons.filter_list_rounded,
                      child: _buildCategorySection(state),
                    ),
                    SizedBox(height: 16.h),

                    // Card 2: Parameters (Field & Operation)
                    _buildStepCard(
                      title: '???????? ???????? ???? ???????',
                      icon: Icons.settings_suggest_rounded,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldSection(state),
                          SizedBox(height: 24.h),
                          _buildOperationSection(state),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Card 3: Execution (Value & Apply)
                    _buildStepCard(
                      title: '????? ?????? ????????',
                      icon: Icons.bolt_rounded,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildValueSection(state),
                          if (state.affectedCount > 0) ...[
                            SizedBox(height: 20.h),
                            _buildPreviewSection(state),
                          ],
                          SizedBox(height: 32.h),
                          _buildActions(state, scheme),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStepCard({required String title, required IconData icon, required Widget child}) {
    return AppCard(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: title, icon: icon),
          SizedBox(height: 20.h),
          child,
        ],
      ),
    );
  }

  Widget _buildCategorySection(BulkPriceUpdateState state) {
    return Wrap(
      spacing: 12.w,
      runSpacing: 12.h,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _segmentButton(
          label: InventoryStrings.bulkPriceUpdateAllItems,
          isSelected: state.selectedCategory == null,
          onTap: () => context.read<BulkPriceUpdateBloc>().add(BulkPriceUpdateApply(
            field: state.selectedField,
            operation: state.selectedOperation,
            value: state.value,
          )),
        ),
        if (state.categories.isNotEmpty) ...[
          AppText('?? ???? ?????:', style: AppTextStyles.caption(context)),
          SizedBox(
            width: 250.w,
            child: ReusableDropdown<String>(
              items: state.categories,
              value: state.selectedCategory,
              hintText: InventoryStrings.bulkPriceUpdateCategoryHint,
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
      ],
    );
  }

  Widget _buildFieldSection(BulkPriceUpdateState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText('????? ??????? ??????:', style: AppTextStyles.bodyBold(context)),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 10.w,
          children: [
            _segmentButton(
              label: InventoryStrings.bulkPriceUpdateFieldSellPrice,
              isSelected: state.selectedField == 'sellPrice',
              onTap: () => _updateApply(state, field: 'sellPrice'),
            ),
            _segmentButton(
              label: InventoryStrings.bulkPriceUpdateFieldBuyPrice,
              isSelected: state.selectedField == 'buyPrice',
              onTap: () => _updateApply(state, field: 'buyPrice'),
            ),
            _segmentButton(
              label: InventoryStrings.bulkPriceUpdateFieldBoth,
              isSelected: state.selectedField == 'both',
              onTap: () => _updateApply(state, field: 'both'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOperationSection(BulkPriceUpdateState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText('??? ??????? ????????:', style: AppTextStyles.bodyBold(context)),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: [
            _segmentButton(label: InventoryStrings.bulkPriceUpdateOpSet, isSelected: state.selectedOperation == 'set', onTap: () => _updateApply(state, op: 'set')),
            _segmentButton(label: InventoryStrings.bulkPriceUpdateOpIncrease, isSelected: state.selectedOperation == 'increase', onTap: () => _updateApply(state, op: 'increase')),
            _segmentButton(label: InventoryStrings.bulkPriceUpdateOpDecrease, isSelected: state.selectedOperation == 'decrease', onTap: () => _updateApply(state, op: 'decrease')),
            _segmentButton(label: InventoryStrings.bulkPriceUpdateOpIncreasePercent, isSelected: state.selectedOperation == 'increasePercent', onTap: () => _updateApply(state, op: 'increasePercent')),
            _segmentButton(label: InventoryStrings.bulkPriceUpdateOpDecreasePercent, isSelected: state.selectedOperation == 'decreasePercent', onTap: () => _updateApply(state, op: 'decreasePercent')),
          ],
        ),
      ],
    );
  }
  }

  void _updateApply(BulkPriceUpdateState state, {String? field, String? op, double? val}) {
    context.read<BulkPriceUpdateBloc>().add(BulkPriceUpdateApply(
      category: state.selectedCategory,
      field: field ?? state.selectedField,
      operation: op ?? state.selectedOperation,
      value: val ?? state.value,
    ));
  }

  Widget _buildValueSection(BulkPriceUpdateState state) {
    final isPercent = state.selectedOperation.contains('Percent');
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: AppInput(
            label: isPercent ? InventoryStrings.bulkPriceUpdatePercentage : InventoryStrings.bulkPriceUpdateValue,
            hint: isPercent ? '????: 10' : '0.00',
            controller: _valueController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            prefixIcon: Icon(isPercent ? Icons.percent_rounded : Icons.payments_rounded, size: 20),
            onChanged: (v) => _updateApply(state, val: double.tryParse(v) ?? 0),
          ),
        ),
        if (isPercent) ...[
          SizedBox(width: 12.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.md.r),
            ),
            child: AppText('???? ?????? ?????? ?? ????? ??????', style: AppTextStyles.caption(context).copyWith(color: AppColors.info)),
          ),
        ],
      ],
    );
  }

  Widget _buildPreviewSection(BulkPriceUpdateState state) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.md.r),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.analytics_rounded, color: AppColors.warning),
          SizedBox(width: 12.w),
          Expanded(
            child: AppText(
              '???? ????? ????? ${state.affectedCount} ??? ????? ??? ????????? ???????.',
              style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BulkPriceUpdateState state, ColorScheme scheme) {
    return Row(
      children: [
        Expanded(
          child: AppButton(
            text: InventoryStrings.bulkPriceUpdateApply,
            prefixIcon: Icons.check_circle_rounded,
            size: ButtonSize.large,
            isLoading: state.isLoading,
            enabled: state.affectedCount > 0 && !state.isLoading,
            onPressed: () => _confirmApply(context, state),
          ),
        ),
        SizedBox(width: 16.w),
        AppButton(
          text: '????? ?????',
          type: ButtonType.outlined,
          onPressed: () {
            _valueController.clear();
            context.read<BulkPriceUpdateBloc>().add(const BulkPriceUpdateLoadCategories());
          },
        ),
      ],
    );
  }

  void _confirmApply(BuildContext context, BulkPriceUpdateState state) {
    AppDialog.show(
      context,
      title: '????? ??????? ???????',
      headerIcon: const Icon(Icons.warning_amber_rounded, color: AppColors.warning),
      children: [
        AppText('?? ??? ????? ?? ????? ?? ????? ????? ${state.affectedCount} ????'),
        AppText('??? ??????? ????? ??? ???? ?????? ?????? ?????? ??????? ????????.', style: AppTextStyles.caption(context).copyWith(color: AppColors.error)),
        SizedBox(height: 24.h),
        DialogActions(
          confirmText: '???? ?? ???????? ????',
          confirmType: ButtonType.primary,
          onConfirm: () {
            Navigator.pop(context);
            context.read<BulkPriceUpdateBloc>().add(const BulkPriceUpdateConfirmApply());
          },
        ),
      ],
    );
  }

  Widget _segmentButton({required String label, required bool isSelected, required VoidCallback onTap}) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? scheme.primary : scheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: isSelected ? scheme.primary : scheme.outlineVariant.withValues(alpha: 0.5)),
        ),
        child: AppText(
          label,
          style: AppTextStyles.caption(context).copyWith(
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : scheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
  }
}




