import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pharmacy_system/app/modules/sales/models/purchase_model.dart';
import 'package:pharmacy_system/app/modules/sales/models/return_model.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/core/data/services/admin/branch_data_service.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_colors.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_sizes.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/index.dart';
import '../bloc/purchase_return_bloc.dart';
import '../bloc/purchase_return_event.dart';

class AddPurchaseReturnView extends StatefulWidget {
  const AddPurchaseReturnView({super.key});

  @override
  State<AddPurchaseReturnView> createState() => _AddPurchaseReturnViewState();
}

class _AddPurchaseReturnViewState extends State<AddPurchaseReturnView> {
  PurchaseModel? _selectedPurchase;
  ReturnReason _selectedReason = ReturnReason.damaged;
  final _notesController = TextEditingController();
  final _purchaseIdController = TextEditingController();
  final _searchResults = <PurchaseModel>[];
  final _returnQuantities = <String, int>{};
  var _isLoading = false;

  String get _branchId => AuthService.currentBranchId ?? '';

  @override
  void dispose() {
    _notesController.dispose();
    _purchaseIdController.dispose();
    super.dispose();
  }

  void _searchPurchase(String query) {
    if (query.trim().isEmpty) {
      setState(() => _searchResults.clear());
      return;
    }
    final q = query.trim().toLowerCase();
    final all = BranchDataService.getPurchases(branchId: _branchId);
    setState(() {
      _searchResults.clear();
      _searchResults.addAll(all.where((p) =>
        p.id.toLowerCase().contains(q) || p.supplierName.toLowerCase().contains(q)
      ).take(10));
    });
  }

  Future<void> _submit() async {
    final purchase = _selectedPurchase;
    if (purchase == null) return;

    final items = <PurchaseReturnItem>[];
    for (final item in purchase.items) {
      final qty = _returnQuantities[item.medicineId] ?? 0;
      if (qty > 0) {
        items.add(PurchaseReturnItem(
          medicineId: item.medicineId,
          medicineName: item.medicineName,
          returnQuantity: qty,
          maxQuantity: item.quantity,
          unitPrice: item.unitPrice,
        ));
      }
    }
    if (items.isEmpty) {
      AppSnackbar.error('يرجى تحديد كميات المرتجع');
      return;
    }

    setState(() => _isLoading = true);
    showDialog(
      context: context,
      builder: (context) => ReusableDialog(
        title: 'إضافة مرتجع مشتريات',
        children: [
          ReusableText('هل أنت متأكد من حفظ هذا المرتجع؟'),
          SizedBox(height: 16.h),
          DialogActions(
            confirmText: 'نعم، حفظ',
            onConfirm: () async {
              context.read<PurchaseReturnBloc>().add(CreatePurchaseReturn(
                    originalPurchase: purchase,
                    selectedItems: items,
                    reason: _selectedReason,
                    notes: _notesController.text.trim(),
                  ));
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return HomeShell(
      title: 'إضافة مرتجع مشتريات',
      child: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.xl.w),
        child: FormCard(
          maxWidth: 600,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ReusableInput(
                label: 'البحث عن فاتورة مشتريات',
                hint: 'رقم الفاتورة أو اسم المورد',
                controller: _purchaseIdController,
                onChanged: _searchPurchase,
                textDirection: TextDirection.rtl,
              ),
              if (_searchResults.isNotEmpty) ...[
                SizedBox(height: AppSpacing.sm.h),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.borderOf(context)),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Column(
                    children: _searchResults.map((p) => ListTile(
                      dense: true,
                      title: Text('فاتورة #${p.id.substring(0, 8)}'),
                      subtitle: Text('${p.supplierName} - ${p.createdAt.toString().substring(0, 10)}'),
                      trailing: Text('${p.totalAmount.toStringAsFixed(0)} ج.م'),
                      selected: _selectedPurchase?.id == p.id,
                      onTap: () => setState(() {
                        _selectedPurchase = p;
                        _searchResults.clear();
                        _purchaseIdController.text = 'فاتورة #${p.id.substring(0, 8)}';
                        for (final item in p.items) {
                          _returnQuantities[item.medicineId] = 0;
                        }
                      }),
                    )).toList(),
                  ),
                ),
              ],
              if (_selectedPurchase != null) ...[
                SizedBox(height: AppSpacing.lg.h),
                ReusableText('فاتورة: #${_selectedPurchase!.id.substring(0, 8)}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
                SizedBox(height: AppSpacing.sm.h),
                ReusableText('المورد: ${_selectedPurchase!.supplierName}', style: TextStyle(fontSize: 12.sp)),
                SizedBox(height: AppSpacing.md.h),
                ..._selectedPurchase!.items.map((item) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: Row(
                    children: [
                      Expanded(child: Text(item.medicineName, style: TextStyle(fontSize: 13.sp))),
                      SizedBox(width: AppSpacing.sm.w),
                      SizedBox(width: 100.w, child: ReusableInput(
                        label: 'الكمية', hint: '0-${item.quantity}',
                        keyboardType: TextInputType.number,
                        onChanged: (v) => setState(() => _returnQuantities[item.medicineId] = int.tryParse(v) ?? 0),
                      )),
                      SizedBox(width: AppSpacing.sm.w),
                      Text('${item.unitPrice.toStringAsFixed(0)} ج.م', style: TextStyle(fontSize: 11.sp, color: Colors.grey)),
                    ],
                  ),
                )),
                SizedBox(height: AppSpacing.md.h),
                ReusableDropdown<ReturnReason>(
                  labelText: 'سبب المرتجع',
                  hintText: 'اختر السبب',
                  items: ReturnReason.values,
                  value: _selectedReason,
                  itemAsString: (r) => r == ReturnReason.damaged ? 'تالف' : r == ReturnReason.expired ? 'منتهي الصلاحية' : r == ReturnReason.wrongItem ? 'صنف خطأ' : r == ReturnReason.customerReturn ? 'مرتجع عميل' : 'أخرى',
                  onChanged: (v) { if (v != null) setState(() => _selectedReason = v); },
                ),
                SizedBox(height: AppSpacing.md.h),
                ReusableInput(label: 'ملاحظات', controller: _notesController, maxLines: 2, textDirection: TextDirection.rtl),
                SizedBox(height: AppSpacing.lg.h),
                Row(
                  children: [
                    Expanded(child: ReusableButton(text: 'إلغاء', type: ButtonType.outlined, onPressed: () => Navigator.pop(context))),
                    SizedBox(width: AppSpacing.md.w),
                    Expanded(child: ReusableButton(text: 'حفظ المرتجع', isLoading: _isLoading, onPressed: _submit)),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}


