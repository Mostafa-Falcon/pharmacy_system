import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_colors.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_sizes.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/index.dart';
import 'package:pharmacy_system/app/core/models/contacts/customer_model.dart';
import 'package:pharmacy_system/app/core/models/contacts/supplier_model.dart';
import 'package:pharmacy_system/app/core/models/sales/return_model.dart';
import 'package:pharmacy_system/app/core/data/services/admin/branch_data_service.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/core/data/services/supplier/supplier_service.dart';
import '../bloc/free_return_bloc.dart';
import '../bloc/free_return_event.dart';
import '../bloc/free_return_state.dart';

class FreeReturnView extends StatelessWidget {
  const FreeReturnView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FreeReturnBloc(),
      child: BlocListener<FreeReturnBloc, FreeReturnState>(
        listener: (context, state) {
          if (state.status == FreeReturnStatus.success) {
            AppSnackbar.success('تم تسجيل المرتجع بنجاح');
            context.pop();
          } else if (state.status == FreeReturnStatus.error) {
            AppSnackbar.error(state.error ?? 'فشل تسجيل المرتجع');
          }
        },
        child: HomeShell(
          title: 'مرتجع حر',
          subtitle: 'تسجيل مرتجع مبيعات أو مشتريات بدون فاتورة. يحدّث المخزون والخزينة والقيد المحاسبي تلقائياً.',
          child: SingleChildScrollView(
            padding: EdgeInsets.all(AppSpacing.xl.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildReturnTypeToggle(),
                SizedBox(height: 24.h),
                _buildPartySection(),
                SizedBox(height: 24.h),
                _buildNoteSection(),
                SizedBox(height: 24.h),
                _buildItemsSection(context),
                SizedBox(height: 32.h),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReturnTypeToggle() {
    return BlocBuilder<FreeReturnBloc, FreeReturnState>(
      builder: (context, state) {
        return Center(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(AppRadius.button),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ToggleTab(
                  label: 'مرتجع مبيعات',
                  isSelected: state.returnType == 'sales',
                  onTap: () => context.read<FreeReturnBloc>().add(const SetReturnType('sales')),
                ),
                _ToggleTab(
                  label: 'مرتجع مشتريات',
                  isSelected: state.returnType == 'purchase',
                  onTap: () => context.read<FreeReturnBloc>().add(const SetReturnType('purchase')),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPartySection() {
    return BlocBuilder<FreeReturnBloc, FreeReturnState>(
      builder: (context, state) {
        return AppCard(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ReusableText('الطرف:', style: AppTextStyles.bodyBold(context)),
                  SizedBox(width: 16.w),
                  _SegmentButton(
                    label: 'نقدي',
                    isSelected: state.partyType == 'cash',
                    onTap: () => context.read<FreeReturnBloc>().add(const SetPartyType('cash')),
                  ),
                  SizedBox(width: 12.w),
                  _SegmentButton(
                    label: 'عميل',
                    isSelected: state.partyType == 'customer',
                    onTap: () => context.read<FreeReturnBloc>().add(const SetPartyType('customer')),
                  ),
                  SizedBox(width: 12.w),
                  _SegmentButton(
                    label: 'مورد',
                    isSelected: state.partyType == 'supplier',
                    onTap: () => context.read<FreeReturnBloc>().add(const SetPartyType('supplier')),
                  ),
                ],
              ),
              if (state.partyType != 'cash') ...[
                SizedBox(height: 16.h),
                _buildPartyDropdown(context, state),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildPartyDropdown(BuildContext context, FreeReturnState state) {
    if (state.partyType == 'customer') {
      final customers = BranchDataService.getCustomers(branchId: AuthService.currentBranchId);
      return ReusableDropdown<CustomerModel>(
        labelText: 'العميل *',
        hintText: '— اختر —',
        items: customers,
        itemAsString: (c) => c.name,
        value: customers.where((c) => c.id == state.selectedPartyId).firstOrNull,
        onChanged: (c) {
          if (c != null) {
            context.read<FreeReturnBloc>().add(SetSelectedParty(c.id, c.name));
          }
        },
      );
    } else {
      final suppliers = SupplierService.getAll();
      return ReusableDropdown<SupplierModel>(
        labelText: 'المورد *',
        hintText: '— اختر —',
        items: suppliers,
        itemAsString: (s) => s.name,
        value: suppliers.where((s) => s.id == state.selectedPartyId).firstOrNull,
        onChanged: (s) {
          if (s != null) {
            context.read<FreeReturnBloc>().add(SetSelectedParty(s.id, s.name));
          }
        },
      );
    }
  }

  Widget _buildNoteSection() {
    return BlocBuilder<FreeReturnBloc, FreeReturnState>(
      builder: (context, state) {
        return AppCard(
          padding: EdgeInsets.all(20.w),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: ReusableDropdown<String>(
                  labelText: 'الخزينة *',
                  hintText: 'الخزينة الرئيسية',
                  items: const ['الخزينة الرئيسية'],
                  itemAsString: (s) => s,
                  value: 'الخزينة الرئيسية',
                  onChanged: (v) {},
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                flex: 2,
                child: ReusableInput(
                  label: 'السبب / ملاحظة',
                  hint: 'مثال: تالف، خطأ في الطلب...',
                  textDirection: TextDirection.rtl,
                  onChanged: (v) => context.read<FreeReturnBloc>().add(SetReturnNotes(v)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildItemsSection(BuildContext context) {
    return BlocBuilder<FreeReturnBloc, FreeReturnState>(
      builder: (context, state) {
        return AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTableHeader(context),
              if (state.items.isEmpty)
                _buildEmptyItems(context)
              else
                ...state.items.asMap().entries.map((entry) => _buildItemRow(context, entry.key, entry.value)),
              _buildAddRow(context),
              _buildSubtotalRow(context, state),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTableHeader(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.4),
        border: Border(bottom: BorderSide(color: scheme.outlineVariant)),
      ),
      child: Row(
        children: [
          Expanded(flex: 3, child: ReusableText('الصنف', style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.bold))),
          Expanded(flex: 1, child: ReusableText('الوحدة', style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.bold))),
          Expanded(flex: 1, child: ReusableText('الكمية', style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.bold))),
          Expanded(flex: 1, child: ReusableText('سعر الوحدة', style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.bold))),
          Expanded(flex: 1, child: ReusableText('تاريخ الصلاحية', style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.bold))),
          Expanded(flex: 1, child: Align(alignment: Alignment.centerLeft, child: ReusableText('الإجمالي', style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.bold)))),
          SizedBox(width: 40.w), // space for delete icon
        ],
      ),
    );
  }

  Widget _buildEmptyItems(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(32.w),
      child: Center(
        child: ReusableText('لا توجد أصناف مضافة للمرتجع', style: AppTextStyles.caption(context)),
      ),
    );
  }

  Widget _buildItemRow(BuildContext context, int index, ReturnItemModel item) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.5))),
      ),
      child: Row(
        children: [
          Expanded(flex: 3, child: ReusableText(item.medicineName, style: AppTextStyles.body(context))),
          Expanded(flex: 1, child: ReusableText('علبة', style: AppTextStyles.body(context))),
          Expanded(
            flex: 1,
            child: SizedBox(
              height: 32.h,
              child: TextField(
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.r)),
                ),
                controller: TextEditingController(text: '${item.quantity}'),
                onSubmitted: (v) {
                  final q = int.tryParse(v) ?? item.quantity;
                  context.read<FreeReturnBloc>().add(UpdateReturnItem(index, item..quantity = q..totalPrice = q * item.unitPrice));
                },
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            flex: 1,
            child: SizedBox(
              height: 32.h,
              child: TextField(
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.r)),
                ),
                controller: TextEditingController(text: item.unitPrice.toStringAsFixed(2)),
                onSubmitted: (v) {
                  final p = double.tryParse(v) ?? item.unitPrice;
                  context.read<FreeReturnBloc>().add(UpdateReturnItem(index, item..unitPrice = p..totalPrice = item.quantity * p));
                },
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(flex: 1, child: ReusableText('سنة / شهر / يوم', style: AppTextStyles.caption(context).copyWith(color: scheme.onSurfaceVariant))),
          Expanded(flex: 1, child: Align(alignment: Alignment.centerLeft, child: ReusableText('${item.totalPrice.toStringAsFixed(2)} ج.م', style: AppTextStyles.bodyBold(context)))),
          SizedBox(
            width: 40.w,
            child: IconButton(
              icon: Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 20.sp),
              onPressed: () => context.read<FreeReturnBloc>().add(RemoveReturnItem(index)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddRow(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: MedicineSearchField(
              hint: 'ابحث أو اكتب اسم منتج جديد...',
              onSelected: (m) {
                context.read<FreeReturnBloc>().add(AddReturnItem(ReturnItemModel(
                  medicineId: m.id,
                  medicineName: m.name,
                  quantity: 1,
                  unitPrice: m.sellPrice,
                  totalPrice: m.sellPrice,
                )));
              },
            ),
          ),
          const Spacer(flex: 4),
          TextButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('إضافة صنف'),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSubtotalRow(BuildContext context, FreeReturnState state) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      color: scheme.surfaceContainerHighest.withValues(alpha: 0.2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
           ReusableText('الإجمالي: ', style: AppTextStyles.bodyBold(context)),
           ReusableText('${state.subtotal.toStringAsFixed(2)} ج.م', style: AppTextStyles.bodyBold(context).copyWith(color: scheme.primary)),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return BlocBuilder<FreeReturnBloc, FreeReturnState>(
      builder: (context, state) {
        final scheme = Theme.of(context).colorScheme;
        return AppCard(
          padding: EdgeInsets.all(20.w),
          child: Row(
            children: [
              SizedBox(
                width: 150.w,
                child: ReusableInput(
                  label: 'نسبة خصم %',
                  hint: '0',
                  keyboardType: TextInputType.number,
                  onChanged: (v) => context.read<FreeReturnBloc>().add(SetDiscountPercent(double.tryParse(v) ?? 0)),
                ),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ReusableText('صافي المرتجع:', style: AppTextStyles.caption(context)),
                  ReusableText(
                    '${state.finalAmount.toStringAsFixed(2)} ج.م',
                    style: AppTextStyles.title(context).copyWith(color: scheme.primary, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(width: 32.w),
              ReusableButton(
                text: state.returnType == 'sales' ? 'تسجيل مرتجع مبيعات' : 'تسجيل مرتجع مشتريات',
                prefixIcon: Icons.check_circle_rounded,
                isLoading: state.status == FreeReturnStatus.loading,
                onPressed: () => context.read<FreeReturnBloc>().add(const SubmitFreeReturn()),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ToggleTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ToggleTab({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? scheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.button),
        ),
        child: ReusableText(
          label,
          style: AppTextStyles.bodyBold(context).copyWith(
            color: isSelected ? Colors.white : scheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SegmentButton({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        decoration: BoxDecoration(
          border: Border.all(color: isSelected ? scheme.primary : scheme.outlineVariant),
          borderRadius: BorderRadius.circular(8.r),
          color: isSelected ? scheme.primary.withValues(alpha: 0.1) : Colors.transparent,
        ),
        child: ReusableText(
          label,
          style: AppTextStyles.caption(context).copyWith(
            fontWeight: FontWeight.bold,
            color: isSelected ? scheme.primary : scheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}




