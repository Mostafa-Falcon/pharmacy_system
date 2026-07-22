import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pharmacy_system/app/core/presentation/widgets/index.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_colors.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../bloc/barcode_label_bloc.dart';

class BarcodeLabelView extends StatefulWidget {
  const BarcodeLabelView({super.key});

  @override
  State<BarcodeLabelView> createState() => _BarcodeLabelViewState();
}

class _BarcodeLabelViewState extends State<BarcodeLabelView> {
  // إعدادات الطباعة القابلة للتخصيص
  double labelWidth = 50; // بالمليمتر
  double labelHeight = 30; // بالمليمتر
  int defaultCopies = 1;
  bool showName = true;
  bool showPrice = true;
  bool showUnit = true;
  bool showBarcode = true;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return HomeShell(
      title: AppStrings.barcodePrintTitle,
      subtitle: AppStrings.barcodePrintSubtitle,
      child: Container(
        color: scheme.surfaceContainerLow.withValues(alpha: 0.15),
        padding: EdgeInsets.all(AppSpacing.lg.w),
        child: Column(
          children: [
            _buildSettingsSection(context),
            SizedBox(height: AppSpacing.md.h),
            _buildSearchSection(context),
            SizedBox(height: AppSpacing.md.h),
            Expanded(child: _buildSelectionList(context)),
            _buildBottomBar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: ExpansionTile(
        shape: const Border(),
        leading: const Icon(Icons.settings_rounded, color: AppColors.primary),
        title: ReusableText(
          AppStrings.labelSettingsAndSizes,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp),
        ),
        subtitle: ReusableText(
          AppStrings.labelSizeCopiesFormat
              .replaceFirst('%s', labelWidth.toString())
              .replaceFirst('%s', labelHeight.toString())
              .replaceFirst('%s', defaultCopies.toString()),
          variant: ReusableTextVariant.caption,
        ),
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.md.w,
              0,
              AppSpacing.md.w,
              AppSpacing.md.h,
            ),
            child: Column(
              children: [
                Wrap(
                  spacing: AppSpacing.md.w,
                  runSpacing: AppSpacing.md.h,
                  children: [
                    SizedBox(
                      width: 250.w,
                      child: ReusableInput(
                        label: AppStrings.labelWidthMm,
                        keyboardType: TextInputType.number,
                        prefixIcon: const Icon(
                          Icons.width_normal_rounded,
                          size: 18,
                        ),
                        onChanged: (v) => setState(
                          () => labelWidth = double.tryParse(v) ?? 50,
                        ),
                        controller: TextEditingController(
                          text: labelWidth.toString(),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 250.w,
                      child: ReusableInput(
                        label: AppStrings.labelHeightMm,
                        keyboardType: TextInputType.number,
                        prefixIcon: const Icon(Icons.height_rounded, size: 18),
                        onChanged: (v) => setState(
                          () => labelHeight = double.tryParse(v) ?? 30,
                        ),
                        controller: TextEditingController(
                          text: labelHeight.toString(),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.md.h),
                ReusableInput(
                  label: AppStrings.copiesPerItemLabel,
                  keyboardType: TextInputType.number,
                  prefixIcon: const Icon(Icons.copy_all_rounded, size: 18),
                  onChanged: (v) =>
                      setState(() => defaultCopies = int.tryParse(v) ?? 1),
                  controller: TextEditingController(
                    text: defaultCopies.toString(),
                  ),
                ),
                SizedBox(height: AppSpacing.md.h),
                Wrap(
                  spacing: AppSpacing.sm.w,
                  runSpacing: AppSpacing.sm.h,
                  children: [
                    QuickFilterChip(
                      label: AppStrings.showNameLabel,
                      isSelected: showName,
                      onTap: () => setState(() => showName = !showName),
                    ),
                    QuickFilterChip(
                      label: AppStrings.showPriceLabel,
                      isSelected: showPrice,
                      onTap: () => setState(() => showPrice = !showPrice),
                    ),
                    QuickFilterChip(
                      label: AppStrings.showUnitLabel,
                      isSelected: showUnit,
                      onTap: () => setState(() => showUnit = !showUnit),
                    ),
                    QuickFilterChip(
                      label: AppStrings.showBarcodeLabel,
                      isSelected: showBarcode,
                      onTap: () => setState(() => showBarcode = !showBarcode),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bloc = context.read<BarcodeLabelBloc>();
    return AppCard(
      padding: EdgeInsets.all(AppSpacing.md.w),
      child: BlocBuilder<BarcodeLabelBloc, BarcodeLabelState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ReusableInput(
                hint: AppStrings.searchMedicineToPrintHint,
                prefixIcon: const Icon(Icons.search_rounded),
                textDirection: TextDirection.rtl,
                onChanged: (v) => bloc.add(SearchLabelMedicines(v)),
              ),
              if (state.searchResults.isNotEmpty)
                Container(
                  margin: EdgeInsets.only(top: AppSpacing.sm.h),
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerLow.withValues(alpha: 0.5),
                    border: Border.all(
                      color: scheme.outlineVariant.withValues(alpha: 0.3),
                    ),
                    borderRadius: BorderRadius.circular(AppRadius.md.r),
                  ),
                  constraints: BoxConstraints(maxHeight: 250.h),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: state.searchResults.length,
                    separatorBuilder: (_, index) => const Divider(height: 1),
                    itemBuilder: (_, i) {
                      final m = state.searchResults[i];
                      return ListTile(
                        dense: true,
                        title: ReusableText(
                          m.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: ReusableText(
                          m.barcodes.isNotEmpty
                              ? m.barcodes.first
                              : AppStrings.noBarcode,
                          variant: ReusableTextVariant.caption,
                        ),
                        trailing: Icon(
                          Icons.add_circle_outline_rounded,
                          color: scheme.primary,
                        ),
                        onTap: () => bloc.add(AddLabelMedicine(m)),
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSelectionList(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bloc = context.read<BarcodeLabelBloc>();
    return BlocBuilder<BarcodeLabelBloc, BarcodeLabelState>(
      builder: (context, state) {
        if (state.selectedMedicines.isEmpty) {
          return const EmptyState(
            icon: Icons.local_print_shop_outlined,
            title: AppStrings.emptyPrintListTitle,
            subtitle: AppStrings.emptyPrintListSubtitle,
          );
        }

        return ListView.separated(
          itemCount: state.selectedMedicines.length,
          padding: EdgeInsets.only(bottom: 12.h),
          separatorBuilder: (_, _) => SizedBox(height: AppSpacing.sm.h),
          itemBuilder: (_, i) {
            final item = state.selectedMedicines[i];
            final m = item.medicine;
            return AppCard(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.md.w,
                vertical: AppSpacing.sm.h,
              ),
              child: Row(
                children: [
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: scheme.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(AppRadius.sm.r),
                    ),
                    child: Icon(
                      Icons.medication_rounded,
                      size: 20.sp,
                      color: scheme.primary,
                    ),
                  ),
                  SizedBox(width: AppSpacing.md.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ReusableText(
                          m.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        ReusableText(
                          '${m.barcodes.firstOrNull ?? '---'} | ${AppStrings.stockBalanceFormat.replaceFirst('%s', m.quantity.toString())}',
                          variant: ReusableTextVariant.caption,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 110.w,
                    child: QuantityStepper(
                      value: item.copies,
                      min: 1,
                      onChanged: (v) => bloc.add(UpdateLabelCopies(i, v)),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      color: AppColors.error,
                    ),
                    onPressed: () => bloc.add(RemoveLabelMedicine(i)),
                    tooltip: AppStrings.deleteLineTooltip,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    final bloc = context.read<BarcodeLabelBloc>();
    final scheme = Theme.of(context).colorScheme;

    return BlocBuilder<BarcodeLabelBloc, BarcodeLabelState>(
      builder: (context, state) {
        if (state.selectedMedicines.isEmpty) return const SizedBox.shrink();

        final totalLabels = state.selectedMedicines.fold(
          0,
          (sum, item) => sum + item.copies,
        );

        return AppCard(
          margin: EdgeInsets.only(top: AppSpacing.md.h),
          backgroundColor: scheme.surface,
          child: Wrap(
            spacing: AppSpacing.md.w,
            runSpacing: AppSpacing.md.h,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ReusableText(
                    InventoryStrings.totalLabelsFormat(totalLabels.toString()),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ReusableText(
                    InventoryStrings.differentItemsFormat(
                      state.selectedMedicines.length.toString(),
                    ),
                    variant: ReusableTextVariant.caption,
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ReusableButton(
                    text: AppStrings.view,
                    prefixIcon: Icons.preview_rounded,
                    type: ButtonType.outlined,
                    onPressed: () => _showPreviewDialog(context),
                  ),
                  SizedBox(width: AppSpacing.md.w),
                  ReusableButton(
                    text: AppStrings.startPrinting,
                    prefixIcon: Icons.print_rounded,
                    onPressed: () => bloc.add(const PrintLabels()),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPreviewDialog(BuildContext context) {
    final bloc = context.read<BarcodeLabelBloc>();

    showDialog(
      context: context,
      builder: (_) => ReusableDialog(
        title: AppStrings.labelPreviewDialogTitle,
        headerIcon: const Icon(Icons.preview_rounded),
        footerActions: [
          ReusableButton(
            text: AppStrings.closePreview,
            type: ButtonType.text,
            onPressed: () => Navigator.pop(context),
          ),
        ],
        children: [
          Center(
            child: BlocBuilder<BarcodeLabelBloc, BarcodeLabelState>(
              bloc: bloc,
              builder: (context, state) {
                final firstSelected = state.selectedMedicines.firstOrNull;
                if (firstSelected == null) {
                  return const EmptyState(
                    icon: Icons.error_outline,
                    title: AppStrings.noData,
                  );
                }

                return Container(
                  width: labelWidth.w * 2,
                  height: labelHeight.h * 2,
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade400, width: 2),
                    borderRadius: BorderRadius.circular(4.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (showName)
                        ReusableText(
                          firstSelected.medicine.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      if (showPrice)
                        ReusableText(
                          '${firstSelected.medicine.sellPrice.toStringAsFixed(2)} ${AppStrings.currency}',
                          style: TextStyle(
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                          ),
                        ),
                      if (showUnit && firstSelected.medicine.units.isNotEmpty)
                        ReusableText(
                          firstSelected.medicine.units.first.name,
                          style: TextStyle(
                            fontSize: 7.sp,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      if (showBarcode &&
                          firstSelected.medicine.barcodes.isNotEmpty) ...[
                        SizedBox(height: 4.h),
                        ReusableText(
                          '||||||||||||||||',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.black,
                            letterSpacing: 1,
                          ),
                        ),
                        ReusableText(
                          firstSelected.medicine.barcodes.first,
                          style: TextStyle(fontSize: 6.sp, color: Colors.black),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 12.h),
          const Center(
            child: ReusableText(
              AppStrings.previewMagnifiedNote,
              variant: ReusableTextVariant.caption,
            ),
          ),
        ],
      ),
    );
  }
}
