import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' hide TextDirection;

import 'package:pharmacy_system/app/modules/sales/models/purchase_model.dart';
import 'package:pharmacy_system/app/modules/sales/models/return_model.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/core/data/services/admin/branch_data_service.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_colors.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_sizes.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/index.dart';
import 'package:pharmacy_system/app/core/utils/format_utils.dart';
import 'package:pharmacy_system/app/core/constants/strings/purchases_strings.dart';
import '../bloc/purchase_return_bloc.dart';
import '../bloc/purchase_return_event.dart';

class AddPurchaseReturnView extends StatefulWidget {
  final VoidCallback? onSaved;
  const AddPurchaseReturnView({super.key, this.onSaved});

  @override
  State<AddPurchaseReturnView> createState() => _AddPurchaseReturnViewState();
}

class _AddPurchaseReturnViewState extends State<AddPurchaseReturnView> {
  PurchaseModel? _selectedPurchase;
  ReturnReason _selectedReason = ReturnReason.damaged;
  final _notesController = TextEditingController();
  final _searchController = TextEditingController();
  final _searchResults = <PurchaseModel>[];
  final _returnQuantities = <String, int>{};
  var _isLoading = false;

  String get _branchId => AuthService.currentBranchId ?? '';

  @override
  void initState() {
    super.initState();
    _loadRecentPurchases();
  }

  void _loadRecentPurchases() {
    final all = BranchDataService.getPurchases(branchId: _branchId);
    setState(() {
      _searchResults.clear();
      _searchResults.addAll(all.take(15));
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _searchPurchase(String query) {
    final all = BranchDataService.getPurchases(branchId: _branchId);
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults.clear();
        _searchResults.addAll(all.take(15));
      });
      return;
    }
    final q = query.trim().toLowerCase();
    setState(() {
      _searchResults.clear();
      _searchResults.addAll(all.where((p) =>
        p.id.toLowerCase().contains(q) ||
        p.supplierName.toLowerCase().contains(q)
      ).take(20));
    });
  }

  void _selectPurchase(PurchaseModel p) {
    setState(() {
      _selectedPurchase = p;
      _returnQuantities.clear();
      for (final item in p.items) {
        _returnQuantities[item.medicineId] = 0;
      }
    });
  }

  double get _totalReturnAmount {
    if (_selectedPurchase == null) return 0.0;
    var total = 0.0;
    for (final item in _selectedPurchase!.items) {
      final qty = _returnQuantities[item.medicineId] ?? 0;
      total += qty * item.unitPrice;
    }
    return total;
  }

  int get _totalReturnItemsCount {
    var count = 0;
    for (final qty in _returnQuantities.values) {
      if (qty > 0) count++;
    }
    return count;
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
      AppSnackbar.error('يرجى تحديد كميات المرتجع لأحد الأصناف على الأقل');
      return;
    }

    setState(() => _isLoading = true);
    showDialog(
      context: context,
      builder: (ctx) => ReusableDialog(
        title: 'تأكيد إرجاع المشتريات',
        children: [
          ReusableText('هل أنت متأكد من حفظ مرتجع الفاتورة #${purchase.id.substring(0, 8).toUpperCase()}؟'),
          SizedBox(height: 8.h),
          ReusableText(
            'سيتم إرجاع المخزون وعكس القيود المحاسبية بمبلغ ${formatMoney(_totalReturnAmount)}',
            style: AppTextStyles.caption(ctx).copyWith(color: AppColors.warning),
          ),
          SizedBox(height: 16.h),
          DialogActions(
            confirmText: 'تأكيد وحفظ المرتجع',
            onConfirm: () async {
              context.read<PurchaseReturnBloc>().add(CreatePurchaseReturn(
                originalPurchase: purchase,
                selectedItems: items,
                reason: _selectedReason,
                notes: _notesController.text.trim(),
              ));
              Navigator.pop(ctx);
              AppSnackbar.success('تم تسجيل مرتجع المشتريات بنجاح وعكس القيود المحاسبية');
              setState(() {
                _isLoading = false;
                _selectedPurchase = null;
                _returnQuantities.clear();
                _notesController.clear();
              });
              if (widget.onSaved != null) {
                widget.onSaved!();
              }
            },
          ),
        ],
      ),
    ).then((_) {
      if (mounted && _isLoading) {
        setState(() => _isLoading = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 900;
        if (isWide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── الجانب الأيمن: البحث واختيار الفواتير ───
              SizedBox(
                width: 360.w,
                child: _buildSearchAndInvoiceSidebar(context, scheme),
              ),
              SizedBox(width: AppSpacing.lg.w),
              // ─── الجزء الرئيسي: أصناف الفاتورة وخيارات المرتجع ───
              Expanded(
                child: _buildMainReturnForm(context, scheme),
              ),
            ],
          );
        }

        // للشاشات الصغيرة
        return SingleChildScrollView(
          child: Column(
            children: [
              _buildSearchAndInvoiceSidebar(context, scheme),
              SizedBox(height: AppSpacing.lg.h),
              _buildMainReturnForm(context, scheme),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchAndInvoiceSidebar(BuildContext context, ColorScheme scheme) {
    return AppCard(
      padding: EdgeInsets.all(AppSpacing.lg.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.search_rounded, color: scheme.primary, size: 22.r),
              SizedBox(width: AppSpacing.sm.w),
              Text(
                'البحث عن فاتورة مشتريات',
                style: AppTextStyles.bodyBold(context),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md.h),
          ReusableInput(
            hint: PurchasesStrings.searchReturnHint,
            controller: _searchController,
            onChanged: _searchPurchase,
            prefixIcon: const Icon(Icons.receipt_long_rounded),
            textDirection: TextDirection.rtl,
          ),
          SizedBox(height: AppSpacing.md.h),
          Text(
            'فواتير المشتريات المتاحة (${_searchResults.length}):',
            style: AppTextStyles.caption(context).copyWith(
              fontWeight: FontWeight.bold,
              color: scheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: AppSpacing.sm.h),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 480.h),
            child: _searchResults.isEmpty
                ? Padding(
                    padding: EdgeInsets.all(AppSpacing.xl.w),
                    child: Center(
                      child: Text(
                        'لا توجد فواتير مطابقة للبحث',
                        style: AppTextStyles.caption(context).copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    itemCount: _searchResults.length,
                    separatorBuilder: (context, index) => Divider(
                      height: 1,
                      color: scheme.outlineVariant.withValues(alpha: 0.4),
                    ),
                    itemBuilder: (context, i) {
                      final p = _searchResults[i];
                      final isSelected = _selectedPurchase?.id == p.id;
                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => _selectPurchase(p),
                          borderRadius: BorderRadius.circular(AppRadius.sm.r),
                          child: Container(
                            padding: EdgeInsets.all(AppSpacing.md.w),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? scheme.primaryContainer.withValues(alpha: 0.25)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(AppRadius.sm.r),
                              border: Border.all(
                                color: isSelected
                                    ? scheme.primary
                                    : Colors.transparent,
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8.r),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? scheme.primary
                                        : scheme.surfaceContainerHigh,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.shopping_bag_outlined,
                                    size: 18.r,
                                    color: isSelected
                                        ? scheme.onPrimary
                                        : scheme.primary,
                                  ),
                                ),
                                SizedBox(width: AppSpacing.md.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'فاتورة #${p.id.substring(0, 8).toUpperCase()}',
                                        style: AppTextStyles.bodyBold(context).copyWith(
                                          color: isSelected ? scheme.primary : null,
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                      Text(
                                        'المورد: ${p.supplierName}',
                                        style: AppTextStyles.caption(context).copyWith(
                                          color: scheme.onSurfaceVariant,
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                      Text(
                                        DateFormat('yyyy/MM/dd').format(p.createdAt),
                                        style: AppTextStyles.caption(context).copyWith(
                                          fontSize: 10.sp,
                                          color: scheme.onSurfaceVariant.withValues(alpha: 0.7),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      formatMoney(p.totalAmount),
                                      style: AppTextStyles.bodyBold(context).copyWith(
                                        color: scheme.primary,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    StatusBadge(
                                      label: '${p.items.length} صنف',
                                      color: AppColors.info,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainReturnForm(BuildContext context, ColorScheme scheme) {
    if (_selectedPurchase == null) {
      return AppCard(
        padding: EdgeInsets.symmetric(vertical: 60.h, horizontal: 24.w),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(20.r),
                decoration: BoxDecoration(
                  color: scheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.assignment_return_rounded,
                  size: 54.r,
                  color: scheme.primary,
                ),
              ),
              SizedBox(height: AppSpacing.lg.h),
              Text(
                'اختر فاتورة مشتريات للبدء في إجراء المرتجع',
                style: AppTextStyles.title(context).copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: AppSpacing.sm.h),
              Text(
                'استخدم حقل البحث أو اختر فاتورة من القائمة الجانبية لاستعراض الأصناف وتحديد الكميات المراد إرجاعها',
                textAlign: TextAlign.center,
                style: AppTextStyles.body(context).copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final p = _selectedPurchase!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ─── كارت تفاصيل الفاتورة المحددة ───
        AppCard(
          padding: EdgeInsets.all(AppSpacing.lg.w),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: AppColors.homePurchases.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppRadius.md.r),
                ),
                child: Icon(
                  Icons.receipt_long_rounded,
                  color: AppColors.homePurchases,
                  size: 28.r,
                ),
              ),
              SizedBox(width: AppSpacing.md.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'الفاتورة المختارة: #${p.id.substring(0, 8).toUpperCase()}',
                          style: AppTextStyles.title(context).copyWith(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: AppSpacing.sm.w),
                        StatusBadge(
                          label: p.paymentMethod,
                          color: AppColors.info,
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'المورد: ${p.supplierName}  |  تاريخ الشراء: ${DateFormat('yyyy/MM/dd HH:mm').format(p.createdAt)}',
                      style: AppTextStyles.caption(context).copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'قيمة الفاتورة الأصلية',
                    style: AppTextStyles.caption(context).copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    formatMoney(p.totalAmount),
                    style: AppTextStyles.title(context).copyWith(
                      color: scheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        SizedBox(height: AppSpacing.lg.h),

        // ─── جدول الأصناف المتاحة للإرجاع ───
        AppCard(
          padding: EdgeInsets.all(AppSpacing.lg.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.inventory_2_outlined, color: scheme.primary, size: 20.r),
                  SizedBox(width: AppSpacing.sm.w),
                  Text(
                    'حدد أصناف وكميات المرتجع:',
                    style: AppTextStyles.bodyBold(context),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        for (final item in p.items) {
                          _returnQuantities[item.medicineId] = item.quantity;
                        }
                      });
                    },
                    icon: Icon(Icons.done_all_rounded, size: 16.r),
                    label: const Text('إرجاع كل الأصناف'),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        for (final item in p.items) {
                          _returnQuantities[item.medicineId] = 0;
                        }
                      });
                    },
                    icon: Icon(Icons.remove_done_rounded, size: 16.r),
                    label: const Text('تصفير الكميات'),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.md.h),

              // الجدول
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.md.r),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.5)),
                  ),
                  child: Table(
                    columnWidths: const {
                      0: FlexColumnWidth(3),
                      1: FlexColumnWidth(1.2),
                      2: FlexColumnWidth(1.5),
                      3: FlexColumnWidth(2.2),
                      4: FlexColumnWidth(1.8),
                    },
                    children: [
                      // Header Row
                      TableRow(
                        decoration: BoxDecoration(
                          color: scheme.surfaceContainerHigh,
                        ),
                        children: [
                          _buildTableCell('اسم الصنف', context, isHeader: true),
                          _buildTableCell('سعر الشراء', context, isHeader: true, isNumeric: true),
                          _buildTableCell('الكمية المشترات', context, isHeader: true, isNumeric: true),
                          _buildTableCell('كمية المرتجع', context, isHeader: true, isCenter: true),
                          _buildTableCell('إجمالي المرتجع', context, isHeader: true, isNumeric: true),
                        ],
                      ),

                      // Item Rows
                      ...p.items.map((item) {
                        final currentQty = _returnQuantities[item.medicineId] ?? 0;
                        final itemReturnTotal = currentQty * item.unitPrice;

                        return TableRow(
                          decoration: BoxDecoration(
                            color: currentQty > 0
                                ? AppColors.error.withValues(alpha: 0.05)
                                : Colors.transparent,
                            border: Border(
                              top: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.3)),
                            ),
                          ),
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.medicineName,
                                    style: AppTextStyles.bodyBold(context),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    'كود الصنف: ${item.medicineId.substring(0, 6)}',
                                    style: AppTextStyles.caption(context).copyWith(
                                      color: scheme.onSurfaceVariant,
                                      fontSize: 10.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            _buildTableCell(formatMoney(item.unitPrice), context, isNumeric: true),
                            _buildTableCell('${item.quantity} وحدة', context, isNumeric: true),
                            
                            // ─── عداد الكمية المرتجعة ───
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton.filledTonal(
                                    onPressed: currentQty > 0
                                        ? () => setState(() => _returnQuantities[item.medicineId] = currentQty - 1)
                                        : null,
                                    icon: const Icon(Icons.remove_rounded),
                                    iconSize: 16.r,
                                    visualDensity: VisualDensity.compact,
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(minWidth: 28.w, minHeight: 28.h),
                                  ),
                                  SizedBox(width: 8.w),
                                  Container(
                                    width: 44.w,
                                    padding: EdgeInsets.symmetric(vertical: 4.h),
                                    decoration: BoxDecoration(
                                      color: scheme.surface,
                                      borderRadius: BorderRadius.circular(AppRadius.xs.r),
                                      border: Border.all(
                                        color: currentQty > 0 ? AppColors.error : scheme.outline,
                                        width: currentQty > 0 ? 1.5 : 1,
                                      ),
                                    ),
                                    child: Text(
                                      '$currentQty',
                                      textAlign: TextAlign.center,
                                      style: AppTextStyles.bodyBold(context).copyWith(
                                        color: currentQty > 0 ? AppColors.error : null,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  IconButton.filledTonal(
                                    onPressed: currentQty < item.quantity
                                        ? () => setState(() => _returnQuantities[item.medicineId] = currentQty + 1)
                                        : null,
                                    icon: const Icon(Icons.add_rounded),
                                    iconSize: 16.r,
                                    visualDensity: VisualDensity.compact,
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(minWidth: 28.w, minHeight: 28.h),
                                  ),
                                ],
                              ),
                            ),

                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  formatMoney(itemReturnTotal),
                                  style: AppTextStyles.bodyBold(context).copyWith(
                                    color: currentQty > 0 ? AppColors.error : scheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: AppSpacing.lg.h),

        // ─── خيارات المرتجع والسبب والملاحظات ───
        AppCard(
          padding: EdgeInsets.all(AppSpacing.lg.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'سبب المرتجع والملاحظات:',
                style: AppTextStyles.bodyBold(context),
              ),
              SizedBox(height: AppSpacing.md.h),

              // Chips لسبب المرتجع
              Wrap(
                spacing: AppSpacing.md.w,
                runSpacing: AppSpacing.sm.h,
                children: [
                  _buildReasonChip(ReturnReason.damaged, 'تالف / متضرر', Icons.broken_image_outlined, scheme),
                  _buildReasonChip(ReturnReason.expired, 'منتهي الصلاحية', Icons.event_busy_outlined, scheme),
                  _buildReasonChip(ReturnReason.wrongItem, 'صنف خطأ / غير مطلوب', Icons.phonelink_erase_outlined, scheme),
                  _buildReasonChip(ReturnReason.customerReturn, 'مرتجع من عميل', Icons.assignment_return_outlined, scheme),
                  _buildReasonChip(ReturnReason.other, 'سبب آخر', Icons.more_horiz_outlined, scheme),
                ],
              ),

              SizedBox(height: AppSpacing.lg.h),
              ReusableInput(
                label: 'ملاحظات وتفاصيل إضافية عن المرتجع',
                hint: 'اكتب أي ملاحظات خاصة بطلب الارتجاع الموجه للمورد...',
                controller: _notesController,
                maxLines: 2,
                textDirection: TextDirection.rtl,
              ),
            ],
          ),
        ),

        SizedBox(height: AppSpacing.lg.h),

        // ─── ملخص المبالغ وأزرار الاعتماد ───
        Container(
          padding: EdgeInsets.all(AppSpacing.xl.w),
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg.r),
            border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.6)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'إجمالي المبالغ المستردة للمورد:',
                    style: AppTextStyles.caption(context).copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        formatMoney(_totalReturnAmount),
                        style: AppTextStyles.title(context).copyWith(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.error,
                        ),
                      ),
                      SizedBox(width: AppSpacing.md.w),
                      StatusBadge(
                        label: '$_totalReturnItemsCount صنف محدد',
                        color: _totalReturnItemsCount > 0 ? AppColors.error : AppColors.info,
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              ReusableButton(
                text: 'تفريغ الاختيار',
                type: ButtonType.outlined,
                onPressed: () {
                  setState(() {
                    _selectedPurchase = null;
                    _returnQuantities.clear();
                    _notesController.clear();
                  });
                },
              ),
              SizedBox(width: AppSpacing.md.w),
              ReusableButton(
                text: 'حفظ المرتجع وعكس القيود',
                prefixIcon: Icons.check_circle_rounded,
                color: AppColors.error,
                isLoading: _isLoading,
                onPressed: _totalReturnItemsCount > 0 ? _submit : null,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReasonChip(ReturnReason reason, String label, IconData icon, ColorScheme scheme) {
    final isSelected = _selectedReason == reason;
    return ChoiceChip(
      showCheckmark: false,
      selected: isSelected,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16.r,
            color: isSelected ? scheme.onError : scheme.onSurfaceVariant,
          ),
          SizedBox(width: 6.w),
          Text(label),
        ],
      ),
      selectedColor: AppColors.error,
      backgroundColor: scheme.surfaceContainerHigh,
      labelStyle: AppTextStyles.caption(context).copyWith(
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        color: isSelected ? scheme.onError : scheme.onSurface,
      ),
      onSelected: (selected) {
        if (selected) setState(() => _selectedReason = reason);
      },
    );
  }

  Widget _buildTableCell(String text, BuildContext context, {bool isHeader = false, bool isNumeric = false, bool isCenter = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      child: Align(
        alignment: isCenter ? Alignment.center : (isNumeric ? Alignment.centerLeft : Alignment.centerRight),
        child: Text(
          text,
          style: isHeader
              ? AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.bold)
              : AppTextStyles.body(context),
        ),
      ),
    );
  }
}
