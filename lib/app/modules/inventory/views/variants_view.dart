import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pharmacy_system/app/modules/inventory/models/medicine_model.dart';
import 'package:pharmacy_system/app/core/data/services/admin/branch_data_service.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_colors.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/index.dart';
import 'package:pharmacy_system/app/modules/inventory/models/medicine_variant_model.dart';
import '../services/variant_service.dart';

class VariantsView extends StatefulWidget {
  const VariantsView({super.key});

  @override
  State<VariantsView> createState() => _VariantsViewState();
}

class _VariantsViewState extends State<VariantsView> {
  bool isLoading = false;
  List<MedicineModel> medicines = [];
  List<MedicineVariantModel> variants = [];
  String searchQuery = '';

  MedicineModel? selectedMedicine;
  final medicineSearchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMedicines();
  }

  @override
  void dispose() {
    medicineSearchCtrl.dispose();
    super.dispose();
  }

  void _loadMedicines() {
    setState(() => isLoading = true);
    try {
      medicines = BranchDataService.getMedicines(branchId: '')
          .where((m) => !m.isDeleted)
          .toList()
        ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _selectMedicine(MedicineModel medicine) {
    setState(() {
      selectedMedicine = medicine;
      variants = VariantService.getByMedicine(medicine.id);
      medicineSearchCtrl.text = medicine.name;
    });
  }

  List<MedicineModel> get _filteredMedicines {
    final q = medicineSearchCtrl.text.trim().toLowerCase();
    if (q.isEmpty) return medicines;
    return medicines
        .where((m) =>
            m.name.toLowerCase().contains(q) ||
            (m.nameEn?.toLowerCase().contains(q) ?? false) ||
            m.barcodes.any((b) => b.toLowerCase().contains(q)))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return HomeShell(
      title: 'Ã˜Â¥Ã˜Â¯Ã˜Â§Ã˜Â±Ã˜Â© Ã˜Â§Ã™â€žÃ™â€¦Ã˜ÂªÃ˜ÂºÃ™Å Ã˜Â±Ã˜Â§Ã˜Âª',
      child: Container(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerLow
            .withValues(alpha: 0.3),
        padding: EdgeInsets.all(AppSpacing.xl.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMedicineSelector(context),
            SizedBox(width: AppSpacing.lg.w),
            Expanded(child: _buildVariantsPanel(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicineSelector(BuildContext context) {
    return Container(
      width: 320.w,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      padding: EdgeInsets.all(AppSpacing.md.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReusableText(
            'Ã˜Â§Ã˜Â®Ã˜ÂªÃ™Å Ã˜Â§Ã˜Â± Ã˜Â§Ã™â€žÃ˜ÂµÃ™â€ Ã™Â',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppSpacing.sm.h),
          ReusableInput.text(
            controller: medicineSearchCtrl,
            label: 'Ã˜Â¨Ã˜Â­Ã˜Â« Ã˜Â¹Ã™â€  Ã˜ÂµÃ™â€ Ã™Â...',
            textDirection: TextDirection.rtl,
            onChanged: (_) => setState(() {}),
          ),
          SizedBox(height: AppSpacing.sm.h),
          Expanded(
            child: () {
              if (isLoading) return const LoadingIndicator();
              final list = _filteredMedicines;
              if (list.isEmpty) {
                return const EmptyState(
                  icon: Icons.medication_outlined,
                  title: 'Ã™â€žÃ˜Â§ Ã™Å Ã™Ë†Ã˜Â¬Ã˜Â¯ Ã˜Â£Ã˜ÂµÃ™â€ Ã˜Â§Ã™Â',
                );
              }
              return ListView.separated(
                itemCount: list.length.clamp(0, 50),
                separatorBuilder: (_, _) => SizedBox(height: AppSpacing.xs.h),
                itemBuilder: (_, i) {
                  final m = list[i];
                  final isSelected = selectedMedicine?.id == m.id;
                  return ListTile(
                    dense: true,
                    selected: isSelected,
                    selectedTileColor:
                        AppColors.primary.withValues(alpha: 0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    leading: Icon(
                      Icons.medication,
                      color: isSelected ? AppColors.primary : null,
                      size: AppSizes.iconSizeSmall,
                    ),
                    title: Text(
                      m.name,
                                      style: TextStyle(fontSize: 12.sp),
                    ),
                    subtitle: m.nameEn != null
                        ? Text(m.nameEn!, style: TextStyle(fontSize: 10.sp))
                        : null,
                    onTap: () => _selectMedicine(m),
                  );
                },
              );
            }(),
          ),
        ],
      ),
    );
  }

  Widget _buildVariantsPanel(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      padding: EdgeInsets.all(AppSpacing.md.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (selectedMedicine != null) ...[
            Row(
              children: [
                ReusableText(
                  'Ã™â€¦Ã˜ÂªÃ˜ÂºÃ™Å Ã˜Â±Ã˜Â§Ã˜Âª: ${selectedMedicine!.name}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                ReusableButton(
                  text: 'Ã˜Â¥Ã˜Â¶Ã˜Â§Ã™ÂÃ˜Â© Ã™â€¦Ã˜ÂªÃ˜ÂºÃ™Å Ã˜Â±',
                  prefixIcon: Icons.add_rounded,
                  onPressed: () => _showVariantDialog(context),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.md.h),
            Expanded(
              child: () {
                if (variants.isEmpty) {
                  return const EmptyState(
                    icon: Icons.swap_horiz_rounded,
                    title: 'Ã™â€žÃ˜Â§ Ã™Å Ã™Ë†Ã˜Â¬Ã˜Â¯ Ã™â€¦Ã˜ÂªÃ˜ÂºÃ™Å Ã˜Â±Ã˜Â§Ã˜Âª Ã™â€žÃ™â€¡Ã˜Â°Ã˜Â§ Ã˜Â§Ã™â€žÃ˜ÂµÃ™â€ Ã™Â',
                  );
                }
                return ListView.separated(
                  itemCount: variants.length,
                  separatorBuilder: (_, _) =>
                      SizedBox(height: AppSpacing.sm.h),
                  itemBuilder: (_, i) =>
                      _variantTile(context, variants[i]),
                );
              }(),
            ),
          ] else
            const Expanded(
              child: Center(
                child: EmptyState(
                  icon: Icons.touch_app_outlined,
                  title: 'Ã˜Â§Ã˜Â®Ã˜ÂªÃ˜Â± Ã˜ÂµÃ™â€ Ã™ÂÃ˜Â§Ã™â€¹ Ã™â€¦Ã™â€  Ã˜Â§Ã™â€žÃ™â€šÃ˜Â§Ã˜Â¦Ã™â€¦Ã˜Â©',
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _variantTile(BuildContext context, MedicineVariantModel v) {
    final menuItems = <PopupMenuEntry<String>>[
      ReusableActionMenuItem(
        value: 'edit',
        icon: Icons.edit_outlined,
        label: AppStrings.edit,
      ),
      ReusableActionMenuItem(
        value: 'delete',
        icon: Icons.delete_outline_rounded,
        label: AppStrings.delete,
        color: AppColors.error,
      ),
    ];

    final attrs = v.attributes.entries.map((e) => '${e.key}: ${e.value}').join(', ');

    return PartyListTile(
      avatarIcon: Icons.swap_horiz_rounded,
      avatarColor: AppColors.info,
      title: v.name,
      subtitle: 'SKU: ${v.sku}${attrs.isNotEmpty ? ' | $attrs' : ''}',
      tags: [
        Tag(
          label: 'Ã˜Â§Ã™â€žÃ˜Â³Ã˜Â¹Ã˜Â±: ${v.price.toStringAsFixed(2)}',
          color: AppColors.success,
        ),
        Tag(
          label: 'Ã˜Â§Ã™â€žÃ˜ÂªÃ™Æ’Ã™â€žÃ™ÂÃ˜Â©: ${v.cost.toStringAsFixed(2)}',
          color: AppColors.warning,
        ),
      ],
      menuItems: menuItems,
      onMenuSelected: (val) {
        switch (val) {
          case 'edit':
            _showVariantDialog(context, variant: v);
          case 'delete':
            ConfirmDeleteDialog.show(
              context,
              title: 'Ã˜Â­Ã˜Â°Ã™Â Ã™â€¦Ã˜ÂªÃ˜ÂºÃ™Å Ã˜Â±',
              message: 'Ã™â€¡Ã™â€ž Ã˜Â£Ã™â€ Ã˜Âª Ã™â€¦Ã˜ÂªÃ˜Â£Ã™Æ’Ã˜Â¯ Ã™â€¦Ã™â€  Ã˜Â­Ã˜Â°Ã™Â Ã˜Â§Ã™â€žÃ™â€¦Ã˜ÂªÃ˜ÂºÃ™Å Ã˜Â± "${v.name}"Ã˜Å¸',
              onConfirm: () async {
                await VariantService.delete(v.id);
                setState(() {
                  variants = VariantService.getByMedicine(selectedMedicine!.id);
                });
              },
            );
        }
      },
      onTap: () => _showVariantDialog(context, variant: v),
    );
  }

  void _showVariantDialog(BuildContext context, {MedicineVariantModel? variant}) {
    if (selectedMedicine == null) return;
    final nameCtrl = TextEditingController(text: variant?.name ?? '');
    final skuCtrl = TextEditingController(text: variant?.sku ?? '');
    final priceCtrl =
        TextEditingController(text: variant?.price.toString() ?? '0');
    final costCtrl =
        TextEditingController(text: variant?.cost.toString() ?? '0');
    final attrKeyCtrl = TextEditingController();
    final attrValCtrl = TextEditingController();
    final extraAttrs = <MapEntry<String, String>>[];
    if (variant != null) {
      extraAttrs.addAll(variant.attributes.entries.map((e) => MapEntry(e.key, e.value)));
    }
    final isEditing = variant != null;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => ReusableDialog(
          title: isEditing ? 'Ã˜ÂªÃ˜Â¹Ã˜Â¯Ã™Å Ã™â€ž Ã™â€¦Ã˜ÂªÃ˜ÂºÃ™Å Ã˜Â±' : 'Ã˜Â¥Ã˜Â¶Ã˜Â§Ã™ÂÃ˜Â© Ã™â€¦Ã˜ÂªÃ˜ÂºÃ™Å Ã˜Â± Ã˜Â¬Ã˜Â¯Ã™Å Ã˜Â¯',
          children: [
            ReusableInput.text(
              controller: nameCtrl,
              label: 'Ã˜Â§Ã˜Â³Ã™â€¦ Ã˜Â§Ã™â€žÃ™â€¦Ã˜ÂªÃ˜ÂºÃ™Å Ã˜Â± *',
              textDirection: TextDirection.rtl,
            ),
            SizedBox(height: AppSpacing.sm.h),
            ReusableInput.text(
              controller: skuCtrl,
              label: 'SKU *',
              textDirection: TextDirection.ltr,
            ),
            SizedBox(height: AppSpacing.sm.h),
            ReusableInput(
              controller: priceCtrl,
              label: 'Ã˜Â³Ã˜Â¹Ã˜Â± Ã˜Â§Ã™â€žÃ˜Â¨Ã™Å Ã˜Â¹',
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: AppSpacing.sm.h),
            ReusableInput(
              controller: costCtrl,
              label: 'Ã˜Â§Ã™â€žÃ˜ÂªÃ™Æ’Ã™â€žÃ™ÂÃ˜Â©',
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: AppSpacing.sm.h),
            Row(
              children: [
                Expanded(
                  child: ReusableInput.text(
                    controller: attrKeyCtrl,
                    label: 'Ã˜Â§Ã™â€žÃ˜Â®Ã˜Â§Ã˜ÂµÃ™Å Ã˜Â©',
                    textDirection: TextDirection.rtl,
                  ),
                ),
                SizedBox(width: AppSpacing.sm.w),
                Expanded(
                  child: ReusableInput.text(
                    controller: attrValCtrl,
                    label: 'Ã˜Â§Ã™â€žÃ™â€šÃ™Å Ã™â€¦Ã™â‚¬Ã˜Â©',
                    textDirection: TextDirection.rtl,
                  ),
                ),
                SizedBox(width: AppSpacing.xs.w),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () {
                    if (attrKeyCtrl.text.trim().isNotEmpty &&
                        attrValCtrl.text.trim().isNotEmpty) {
                      setDialogState(() {
                        extraAttrs.add(MapEntry(
                          attrKeyCtrl.text.trim(),
                          attrValCtrl.text.trim(),
                        ));
                      });
                      attrKeyCtrl.clear();
                      attrValCtrl.clear();
                    }
                  },
                ),
              ],
            ),
            if (extraAttrs.isNotEmpty) ...[
              SizedBox(height: AppSpacing.xs.h),
              ...extraAttrs.asMap().entries.map((entry) {
                final idx = entry.key;
                final attr = entry.value;
                return Chip(
                  label: Text('${attr.key}: ${attr.value}'),
                  onDeleted: () {
                    setDialogState(() {
                      extraAttrs.removeAt(idx);
                    });
                  },
                );
              }),
            ],
            SizedBox(height: AppSpacing.md.h),
            DialogActions(
              confirmText: isEditing ? 'Ã˜Â­Ã™ÂÃ˜Â¸' : 'Ã˜Â¥Ã˜Â¶Ã˜Â§Ã™ÂÃ˜Â©',
              onConfirm: () async {
                if (nameCtrl.text.trim().isEmpty ||
                    skuCtrl.text.trim().isEmpty) {
                  return;
                }
                final attrs = Map<String, String>.fromEntries(extraAttrs);
                if (isEditing) {
                  await VariantService.update(variant.copyWith(
                    name: nameCtrl.text.trim(),
                    sku: skuCtrl.text.trim(),
                    price: double.tryParse(priceCtrl.text) ?? 0,
                    cost: double.tryParse(costCtrl.text) ?? 0,
                    attributes: attrs,
                  ));
                } else {
                  await VariantService.add(
                    medicineId: selectedMedicine!.id,
                    name: nameCtrl.text.trim(),
                    sku: skuCtrl.text.trim(),
                    price: double.tryParse(priceCtrl.text) ?? 0,
                    cost: double.tryParse(costCtrl.text) ?? 0,
                    attributes: attrs,
                  );
                }
                setState(() {
                  variants = VariantService.getByMedicine(selectedMedicine!.id);
                });
                if (context.mounted) Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}


