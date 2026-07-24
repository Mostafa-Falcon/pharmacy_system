import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pharmacy_system/app/core/models/inventory/medicine_model.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_colors.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_sizes.dart';
import '../bloc/medicines_bloc.dart';
import 'package:pharmacy_system/app/core/constants/app_strings.dart';
import 'package:pharmacy_system/app/core/injection.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/index.dart';

class StockAdjustmentView extends StatelessWidget {
  final MedicineModel? medicine;
  const StockAdjustmentView({super.key, this.medicine});

  @override
  Widget build(BuildContext context) {
    if (medicine == null) {
      return HomeShell(
        title: InventoryStrings.stockAdjustmentTitle,
        child: Center(
          child: ReusableText(
            InventoryStrings.medicineNotFound,
            style: TextStyle(fontSize: 16.sp),
          ),
        ),
      );
    }
    return BlocProvider(
      create: (_) => sl<MedicinesBloc>(),
      child: _StockAdjustmentBody(medicine: medicine!),
    );
  }
}

class _StockAdjustmentBody extends StatefulWidget {
  final MedicineModel medicine;
  const _StockAdjustmentBody({required this.medicine});

  @override
  State<_StockAdjustmentBody> createState() => _StockAdjustmentBodyState();
}

class _StockAdjustmentBodyState extends State<_StockAdjustmentBody> {
  late MedicineModel medicine;
  late final TextEditingController _qtyController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    medicine = widget.medicine;
    _qtyController = TextEditingController(text: medicine.quantity.toString());
  }

  @override
  void dispose() {
    _qtyController.dispose();
    super.dispose();
  }

  void _onMedicineSelected(MedicineModel m) {
    setState(() {
      medicine = m;
      _qtyController.text = m.quantity.toString();
    });
  }

  Future<void> _save() async {
    final newQty = int.tryParse(_qtyController.text.trim());
    if (newQty == null || newQty < 0) {
      AppSnackbar.error(InventoryStrings.invalidStockQuantity, title: GeneralStrings.error);
      return;
    }
    if (newQty == medicine.quantity) {
      Navigator.pop(context);
      return;
    }
    setState(() => _isSaving = true);
    if (!mounted) return;
    context.read<MedicinesBloc>().add(AdjustMedicineQuantity(medicine, newQty));
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return HomeShell(
      title: '${InventoryStrings.stockAdjustmentTitle}: ${medicine.name}',
      subtitle: InventoryStrings.stockAdjustmentSubtitle,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Container(
                color: scheme.surfaceContainerLow.withValues(alpha: 0.15),
                padding: EdgeInsets.all(AppSpacing.xl.w),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 520.w),
                    child: AppCard(
                      padding: EdgeInsets.all(AppSpacing.xl.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MedicineSearchField(
                            onSelected: _onMedicineSelected,
                            hint: '???? ???? ??? ???????...',
                          ),
                          SizedBox(height: AppSpacing.lg.h),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(AppSpacing.md.w),
                                decoration: BoxDecoration(
                                  color: scheme.primary.withValues(alpha: 0.06),
                                  borderRadius: BorderRadius.circular(AppRadius.md.r),
                                ),
                                child: Icon(Icons.medication_rounded, size: 36.sp, color: scheme.primary),
                              ),
                              SizedBox(width: AppSpacing.md.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ReusableText(
                                      medicine.name,
                                      style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w800, color: scheme.onSurface),
                                    ),
                                    SizedBox(height: 6.h),
                                    Row(
                                      children: [
                                        Icon(Icons.inventory_2_outlined, size: 14.sp, color: scheme.onSurfaceVariant),
                                        SizedBox(width: AppSpacing.xs.w),
                                    ReusableText(
                                      InventoryStrings.currentSystemStock,
                                      style: TextStyle(fontSize: 12.sp, color: scheme.onSurfaceVariant, fontWeight: FontWeight.w500),
                                    ),

                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl.w, vertical: AppSpacing.sm.h),
                                decoration: BoxDecoration(
                                  color: scheme.primary.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(AppRadius.md.r),
                                  border: Border.all(color: scheme.primary.withValues(alpha: 0.15)),
                                ),
                                child: ReusableText(
                                  medicine.formattedQuantity,
                                  style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w900, color: scheme.primary),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: AppSpacing.xl.h),
                          Divider(color: scheme.outlineVariant.withValues(alpha: 0.3), height: 1),
                          SizedBox(height: AppSpacing.xl.h),

                          ReusableInput(
                            controller: _qtyController,
                            label: '${InventoryStrings.currentStockLabel} ?????? *',
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            prefixIcon: Icon(Icons.numbers_rounded, size: 20.sp, color: scheme.primary),
                            showClearButton: false,
                          ),

                          if (medicine.alertEnabled) ...[
                            SizedBox(height: AppSpacing.md.h),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w, vertical: AppSpacing.sm.h),
                              decoration: BoxDecoration(
                                color: AppColors.warning.withValues(alpha: 0.06),
                                borderRadius: BorderRadius.circular(AppRadius.sm.r),
                                border: Border.all(color: AppColors.warning.withValues(alpha: 0.2)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.warning_amber_rounded, size: 14.sp, color: AppColors.warning),
                                  SizedBox(width: AppSpacing.xs.w),
                                  ReusableText(
                                    '?? ??????? ???????? ???? ?????: ${medicine.minStock} ????',
                                    style: TextStyle(fontSize: 11.5.sp, color: AppColors.warning, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],

                          SizedBox(height: AppSpacing.xl.h),
                          Row(
                            children: [
                              ReusableButton(
                                text: GeneralStrings.cancel,
                                onPressed: () => Navigator.pop(context),
                                type: ButtonType.outlined,
                              ),
                              SizedBox(width: AppSpacing.xl.w),
                              Expanded(
                                child: ReusableButton(
                                  text: _isSaving ? InventoryStrings.submittingMedicine : InventoryStrings.approveNewQuantity,
                                  onPressed: _isSaving ? null : _save,
                                  prefixIcon: Icons.check_circle_rounded,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}







