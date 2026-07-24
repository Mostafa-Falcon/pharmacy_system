import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/index.dart';

import 'package:pharmacy_system/app/core/models/inventory/medicine_model.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_colors.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_sizes.dart';
import '../bloc/stock_transfer_bloc.dart';
import 'package:pharmacy_system/app/core/models/inventory/stock_transfer_model.dart';
import '../services/stock_quantity_guard.dart';

class AddStockTransferView extends StatefulWidget {
  const AddStockTransferView({super.key});

  @override
  State<AddStockTransferView> createState() => _AddStockTransferViewState();
}

class _AddStockTransferViewState extends State<AddStockTransferView> {
  final _notesController = TextEditingController();
  String? _selectedBranchId;
  final _items = <StockTransferItemModel>[];
  MedicineModel? _selectedMedicine;
  final _qtyController = TextEditingController();
  final _costController = TextEditingController();
  final _batchNumberController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    _qtyController.dispose();
    _costController.dispose();
    _batchNumberController.dispose();
    super.dispose();
  }

  void _addItem(MedicineModel medicine) {
    final qty = int.tryParse(_qtyController.text.trim());
    if (qty == null || qty <= 0) {
      AppSnackbar.error('???? ????? ???? ?????');
      return;
    }

    final cost = double.tryParse(_costController.text.trim()) ?? medicine.buyPrice;

    if (_items.any((i) => i.medicineId == medicine.id)) {
      AppSnackbar.warning('??? ????? ???? ??????');
      return;
    }

    setState(() {
      _items.add(StockTransferItemModel(
        medicineId: medicine.id,
        medicineName: medicine.name,
        quantity: qty,
        unitCost: cost,
        barcode: medicine.barcodes.isNotEmpty ? medicine.barcodes.first : null,
        batchNumber: _batchNumberController.text.trim().isEmpty
            ? null
            : _batchNumberController.text.trim(),
      ));
      _selectedMedicine = null;
      _qtyController.clear();
      _costController.clear();
      _batchNumberController.clear();
    });
  }

  void _removeItem(int index) {
    setState(() => _items.removeAt(index));
  }

  void _submit() {
    if (_selectedBranchId == null) {
      AppSnackbar.error('???? ?????? ????? ????????');
      return;
    }

    for (final item in _items) {
      if (!StockQuantityGuard.canTransfer(
          AuthService.currentBranchId ?? '',
          item.medicineId,
          item.quantity.toDouble())) {
        AppSnackbar.error('?????? ??? ????? ?????: ${item.medicineName}');
        return;
      }
    }

    final branchName = () {
      final branches = context.read<StockTransferBloc>().state.branches;
      final branch = branches.firstWhere(
        (b) => b.id == _selectedBranchId,
        orElse: () => branches.first,
      );
      return branch.name;
    }();

    final now = DateTime.now();
    context.read<StockTransferBloc>().add(SendTransfer(
      StockTransferModel(
        id: now.millisecondsSinceEpoch.toString(),
        branchId: AuthService.currentBranchId ?? '',
        fromBranchId: AuthService.currentBranchId ?? '',
        toBranchId: _selectedBranchId!,
        fromBranchName: AuthService.currentBranch?.name ?? '',
        toBranchName: branchName,
        transferNumber: 0,
        items: List.from(_items),
        createdBy: AuthService.currentUser?.id ?? '',
        createdAt: now,
        updatedAt: now,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StockTransferBloc, StockTransferState>(
      builder: (context, state) {
        return StandardFormLayout(
          title: '????? ????? ????',
          maxWidth: 700,
          isSaving: state.isProcessing,
          confirmText: '????? ???????',
          onConfirm: _submit,
          onCancel: () => Navigator.pop(context),
          children: [
            _buildBranchSelector(context, state),
            SizedBox(height: AppSpacing.lg),
            _buildItemsSection(context, state),
            SizedBox(height: AppSpacing.lg),
            _buildNotesField(context),
          ],
        );
      },
    );
  }

  Widget _buildBranchSelector(BuildContext context, StockTransferState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          icon: Icons.business_rounded,
          title: '????? ????????',
        ),
        ReusableDropdown<String>(
          hintText: '???? ?????',
          items: state.branches.map((b) => b.id).toList(),
          value: _selectedBranchId,
          itemAsString: (id) {
            final branch = state.branches.firstWhere((b) => b.id == id,
                orElse: () => state.branches.first);
            return branch.name;
          },
          onChanged: (v) => setState(() => _selectedBranchId = v),
          prefixIcon: Icons.business_rounded,
        ),
      ],
    );
  }

  Widget _buildItemsSection(BuildContext context, StockTransferState state) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          icon: Icons.inventory_2_rounded,
          title: '??????? ????????',
        ),
        MedicineSearchField(
          onSelected: (med) {
            setState(() {
              _selectedMedicine = med;
              _costController.text = med.buyPrice.toStringAsFixed(2);
            });
          },
          autofocus: true,
        ),
        if (_selectedMedicine != null) _buildItemForm(context, scheme),
        SizedBox(height: AppSpacing.md),
        if (_items.isEmpty)
          const EmptyState(
            icon: Icons.inventory_2_outlined,
            title: '?? ??? ????? ????? ???',
          )
        else
          _buildAddedItemsList(context, scheme),
      ],
    );
  }

  Widget _buildItemForm(BuildContext context, ColorScheme scheme) {
    final med = _selectedMedicine!;
    return Padding(
      padding: EdgeInsets.only(top: AppSpacing.md.h),
      child: Container(
        padding: EdgeInsets.all(AppSpacing.md.w),
        decoration: BoxDecoration(
          color: scheme.primary.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
              color: scheme.primary.withValues(alpha: 0.15)),
        ),
        child: Column(
          children: [
            Wrap(
              spacing: AppSpacing.md.w,
              runSpacing: AppSpacing.sm.h,
              children: [
                SizedBox(
                  width: 300.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ReusableText(
                        med.name,
                        style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: scheme.onSurface),
                      ),
                      ReusableText(
                        '??????: ${med.quantity}',
                        style: TextStyle(
                            fontSize: 11.sp,
                            color: scheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 120.w,
                  child: ReusableInput(
                    controller: _qtyController,
                    label: '??????',
                    hint: '0',
                    keyboardType: TextInputType.number,
                    showClearButton: false,
                  ),
                ),
                SizedBox(
                  width: 140.w,
                  child: ReusableInput(
                    controller: _costController,
                    hint: '????? ??????',
                    label: '??? ???????',
                    keyboardType:
                        const TextInputType.numberWithOptions(
                            decimal: true),
                    showClearButton: false,
                  ),
                ),
                SizedBox(
                  width: 180.w,
                  child: ReusableInput(
                    controller: _batchNumberController,
                    hint: '??? ??????',
                    label: '?????? (???????)',
                    showClearButton: false,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.md.h),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: ReusableButton(
                text: '????? ?????',
                onPressed: () => _addItem(med),
                prefixIcon: Icons.add_rounded,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddedItemsList(BuildContext context, ColorScheme scheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          icon: Icons.list_alt_rounded,
          title: '??????? ??????? (${_items.length})',
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _items.length,
          separatorBuilder: (_, _) => Divider(
              height: 1,
              color: scheme.outlineVariant.withValues(alpha: 0.2)),
          itemBuilder: (context, index) {
            final item = _items[index];
            return ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.medication_rounded,
                  size: 20.sp, color: scheme.primary),
              title: ReusableText(
                item.medicineName,
                style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: scheme.onSurface),
              ),
              subtitle: Row(
                children: [
                  ReusableText(
                    '${item.quantity} × ${item.unitCost.toStringAsFixed(2)} ?.?',
                    style: TextStyle(
                        fontSize: 11.sp,
                        color: scheme.onSurfaceVariant),
                  ),
                  if (item.batchNumber != null) ...[
                    SizedBox(width: 8.w),
                    Icon(Icons.batch_prediction_outlined,
                        size: 12.sp,
                        color: scheme.onSurfaceVariant),
                    SizedBox(width: 2.w),
                    ReusableText(
                      '????: ${item.batchNumber}',
                      style: TextStyle(
                          fontSize: 10.sp,
                          color: scheme.onSurfaceVariant),
                    ),
                  ],
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.remove_circle_rounded,
                    size: 20.sp, color: AppColors.error),
                onPressed: () => _removeItem(index),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildNotesField(BuildContext context) {
    return ReusableInput(
      controller: _notesController,
      label: '???????',
      hint: '??????? ?????? (???????)',
      maxLines: 3,
    );
  }

}





