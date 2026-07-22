import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pharmacy_system/app/core/presentation/theme/app_colors.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/index.dart';
import '../bloc/barcode_settings_bloc.dart';

class BarcodeSettingsView extends StatefulWidget {
  const BarcodeSettingsView({super.key});

  @override
  State<BarcodeSettingsView> createState() => _BarcodeSettingsViewState();
}

class _BarcodeSettingsViewState extends State<BarcodeSettingsView> {
  final _prefixCtrl = TextEditingController();
  final _serialLengthCtrl = TextEditingController();
  final _widthCtrl = TextEditingController();
  final _heightCtrl = TextEditingController();
  final _pharmacyNameCtrl = TextEditingController();
  final _copiesCtrl = TextEditingController();

  @override
  void dispose() {
    _prefixCtrl.dispose();
    _serialLengthCtrl.dispose();
    _widthCtrl.dispose();
    _heightCtrl.dispose();
    _pharmacyNameCtrl.dispose();
    _copiesCtrl.dispose();
    super.dispose();
  }

  bool _initialized = false;

  void _updateControllers(BarcodeSettingsState state) {
    if (_prefixCtrl.text != state.prefix) {
      _prefixCtrl.text = state.prefix;
    }
    if (_serialLengthCtrl.text != state.serialLength.toString()) {
      _serialLengthCtrl.text = state.serialLength.toString();
    }
    if (_widthCtrl.text != state.labelWidth.toString()) {
      _widthCtrl.text = state.labelWidth.toString();
    }
    if (_heightCtrl.text != state.labelHeight.toString()) {
      _heightCtrl.text = state.labelHeight.toString();
    }
    if (_pharmacyNameCtrl.text != state.pharmacyName) {
      _pharmacyNameCtrl.text = state.pharmacyName;
    }
    if (_copiesCtrl.text != state.copiesPerItem.toString()) {
      _copiesCtrl.text = state.copiesPerItem.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<BarcodeSettingsBloc>();

    return BlocConsumer<BarcodeSettingsBloc, BarcodeSettingsState>(
      listener: (context, state) {
        if (!_initialized && state.status == BarcodeSettingsStatus.loaded) {
          _updateControllers(state);
          _initialized = true;
        }
      },
      builder: (context, state) {
        if (!_initialized && state.status == BarcodeSettingsStatus.loaded) {
          _updateControllers(state);
          _initialized = true;
        }

        return StandardModuleLayout(
          title: AppStrings.barcodeSettingsTitle,
          subtitle: AppStrings.barcodeSettingsSubtitle,
          content: LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth > 900;
              return isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: _buildSettingsColumn(context, bloc, state),
                        ),
                        SizedBox(width: AppSpacing.xl),
                        Expanded(
                          flex: 2,
                          child: _buildPreviewColumn(context, state),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        _buildPreviewColumn(context, state),
                        SizedBox(height: AppSpacing.lg),
                        _buildSettingsColumn(context, bloc, state),
                      ],
                    );
            },
          ),
        );
      },
    );
  }

  Widget _buildSettingsColumn(
    BuildContext context,
    BarcodeSettingsBloc bloc,
    BarcodeSettingsState state,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildGenerationSection(context, bloc, state),
        SizedBox(height: AppSpacing.lg.h),
        _buildVisualSection(context, bloc, state),
        SizedBox(height: AppSpacing.lg.h),
        _buildPrintLayoutSection(context, bloc, state),
        SizedBox(height: AppSpacing.xl.h),
        SizedBox(
          width: double.infinity,
          height: 52.h,
          child: ReusableButton(
            text: AppStrings.saveBarcodeSettings,
            prefixIcon: Icons.save_rounded,
            isLoading: state.status == BarcodeSettingsStatus.saving,
            onPressed: () => bloc.add(const SaveBarcodeSettings()),
          ),
        ),
      ],
    );
  }

  Widget _buildGenerationSection(
    BuildContext context,
    BarcodeSettingsBloc bloc,
    BarcodeSettingsState state,
  ) {
    return FormCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            icon: Icons.auto_awesome_rounded,
            title: AppStrings.generationAlgorithm,
          ),
          SizedBox(height: AppSpacing.md.h),
          Row(
            children: [
              Expanded(
                child: ReusableInput(
                  label: AppStrings.barcodePrefixLabel,
                  hint: 'PH',
                  controller: _prefixCtrl,
                  onChanged: (v) => bloc.add(UpdatePrefix(v)),
                  prefixIcon: const Icon(Icons.text_fields_rounded, size: 18),
                ),
              ),
              SizedBox(width: AppSpacing.md.w),
              Expanded(
                child: ReusableInput(
                  label: AppStrings.serialLengthLabel,
                  hint: '8',
                  keyboardType: TextInputType.number,
                  controller: _serialLengthCtrl,
                  onChanged: (v) =>
                      bloc.add(UpdateSerialLength(int.tryParse(v) ?? 8)),
                  prefixIcon: const Icon(Icons.numbers_rounded, size: 18),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md.h),
          ReusableDropdown<String>(
            labelText: AppStrings.encodingFormatLabel,
            hintText: AppStrings.encodingFormatHint,
            items: BarcodeSettingsState.formatOptions,
            value: BarcodeSettingsState.formatOptions[state.formatIndex],
            itemAsString: (f) => f == 'shortCode128'
                ? AppStrings.code128Desc
                : AppStrings.ean13Desc,
            onChanged: (v) {
              if (v != null) {
                bloc.add(
                  UpdateFormatIndex(
                    BarcodeSettingsState.formatOptions.indexOf(v),
                  ),
                );
              }
            },
            prefixIcon: Icons.qr_code_scanner_rounded,
          ),
          SizedBox(height: AppSpacing.md.h),
          _buildSwitchTile(
            context,
            icon: Icons.verified_user_rounded,
            title: AppStrings.pharmacySignatureTitle,
            subtitle: AppStrings.pharmacySignatureSubtitle,
            value: state.usePharmacySignature,
            onChanged: (v) => bloc.add(const ToggleUsePharmacySignature()),
          ),
          if (state.usePharmacySignature) ...[
            SizedBox(height: AppSpacing.sm.h),
            ReusableInput(
              label: AppStrings.pharmacyNameSignature,
              hint: AppStrings.pharmacyNameSignatureHint,
              controller: _pharmacyNameCtrl,
              onChanged: (v) => bloc.add(UpdatePharmacyName(v)),
              prefixIcon: const Icon(Icons.store_rounded, size: 18),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildVisualSection(
    BuildContext context,
    BarcodeSettingsBloc bloc,
    BarcodeSettingsState state,
  ) {
    return FormCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            icon: Icons.design_services_rounded,
            title: AppStrings.visualLabelDesign,
          ),
          SizedBox(height: AppSpacing.md.h),
          Row(
            children: [
              Expanded(
                child: ReusableInput(
                  label: AppStrings.labelWidthMm,
                  controller: _widthCtrl,
                  keyboardType: TextInputType.number,
                  onChanged: (v) =>
                      bloc.add(UpdateLabelWidth(double.tryParse(v) ?? 50)),
                  prefixIcon: const Icon(Icons.width_normal_rounded, size: 18),
                ),
              ),
              SizedBox(width: AppSpacing.md.w),
              Expanded(
                child: ReusableInput(
                  label: AppStrings.labelHeightMm,
                  controller: _heightCtrl,
                  keyboardType: TextInputType.number,
                  onChanged: (v) =>
                      bloc.add(UpdateLabelHeight(double.tryParse(v) ?? 30)),
                  prefixIcon: const Icon(Icons.height_rounded, size: 18),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.lg.h),
          ReusableText(
            AppStrings.labelContents,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp),
          ),
          SizedBox(height: AppSpacing.sm.h),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8.h,
            crossAxisSpacing: 16.w,
            childAspectRatio: 4,
            children: [
              _buildModernCheckbox(
                label: AppStrings.showSellPrice,
                value: state.showPrice,
                onChanged: (_) => bloc.add(const ToggleShowPrice()),
              ),
              _buildModernCheckbox(
                label: AppStrings.showItemName,
                value: state.showName,
                onChanged: (_) => bloc.add(const ToggleShowName()),
              ),
              _buildModernCheckbox(
                label: AppStrings.showBarcodeCode,
                value: state.showBarcode,
                onChanged: (_) => bloc.add(const ToggleShowBarcode()),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPrintLayoutSection(
    BuildContext context,
    BarcodeSettingsBloc bloc,
    BarcodeSettingsState state,
  ) {
    return FormCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            icon: Icons.print_rounded,
            title: AppStrings.printLayoutTitle,
          ),
          SizedBox(height: AppSpacing.md.h),
          ReusableDropdown<String>(
            labelText: AppStrings.pageLayoutLabel,
            items: BarcodeSettingsState.layoutOptions,
            value: BarcodeSettingsState.layoutOptions[state.printLayoutIndex],
            itemAsString: (l) => l == 'labelPrinter'
                ? AppStrings.thermalPrinterDesc
                : AppStrings.a4PaperDesc,
            onChanged: (v) {
              if (v != null) {
                bloc.add(
                  UpdatePrintLayoutIndex(
                    BarcodeSettingsState.layoutOptions.indexOf(v),
                  ),
                );
              }
            },
            prefixIcon: Icons.layers_rounded,
            hintText: AppStrings.pageLayoutLabel,
          ),
          SizedBox(height: AppSpacing.md.h),
          ReusableInput(
            label: AppStrings.defaultCopiesPerItem,
            controller: _copiesCtrl,
            keyboardType: TextInputType.number,
            onChanged: (v) =>
                bloc.add(UpdateCopiesPerItem(int.tryParse(v) ?? 1)),
            prefixIcon: const Icon(Icons.copy_all_rounded, size: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewColumn(BuildContext context, BarcodeSettingsState state) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                icon: Icons.remove_red_eye_rounded,
                title: AppStrings.barcodePreviewTitle,
              ),
              SizedBox(height: AppSpacing.lg.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 40.h),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(
                    color: scheme.outlineVariant.withValues(alpha: 0.5),
                  ),
                ),
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        width: (state.labelWidth * 3).w,
                        height: (state.labelHeight * 3).h,
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                          border: Border.all(
                            color: Colors.grey.shade400,
                            width: 1.w,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (state.showName)
                              Text(
                                'بندول اكسترا ٥٠٠ مجم',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontFamily: 'Cairo',
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            if (state.showPrice)
                              Text(
                                'السعر: ٧٥٫٠٠ ج.م',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black,
                                ),
                              ),
                            Expanded(
                              child: Center(
                                child: LinearBarcodePreview(
                                  code: state.previewCode.isNotEmpty
                                      ? state.previewCode
                                      : '2012345678',
                                  showText: state.showBarcode,
                                  height: (state.labelHeight * 1.2).h,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            if (state.usePharmacySignature &&
                                state.pharmacyName.isNotEmpty)
                              Text(
                                state.pharmacyName,
                                style: TextStyle(
                                  fontSize: 8.sp,
                                  color: Colors.grey.shade800,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.md.h),
              _buildInfoNote(
                AppStrings.barcodePreviewNote.replaceFirst('%s', state.labelWidth.toString()).replaceFirst('%s', state.labelHeight.toString()),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(AppSpacing.md.w),
      decoration: BoxDecoration(
        color: value
            ? scheme.primary.withValues(alpha: 0.04)
            : scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: value
              ? scheme.primary.withValues(alpha: 0.2)
              : scheme.outlineVariant,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: value
                  ? scheme.primary.withValues(alpha: 0.1)
                  : scheme.surfaceContainerHigh,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: value ? scheme.primary : scheme.onSurfaceVariant,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReusableText(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                ReusableText(subtitle, variant: ReusableTextVariant.caption),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeThumbColor: scheme.primary,
            activeTrackColor: scheme.primary.withValues(alpha: 0.5),
          ),
        ],
      ),
    );
  }

  Widget _buildModernCheckbox({
    required String label,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            value: value,
            onChanged: onChanged,
            visualDensity: VisualDensity.compact,
          ),
          SizedBox(width: 4.w),
          ReusableText(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: value ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoNote(String text) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.sm.w),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: AppColors.info.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.info,
            size: 18,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: ReusableText(
              text,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.info,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
