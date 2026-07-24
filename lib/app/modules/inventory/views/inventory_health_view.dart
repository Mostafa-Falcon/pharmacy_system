import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_system/app/core/constants/app_strings.dart';
import 'package:pharmacy_system/app/core/models/inventory/medicine_search_extension.dart';

import 'package:pharmacy_system/app/shared/presentation/widgets/index.dart';
import 'package:pharmacy_system/app/core/models/inventory/medicine_model.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_colors.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_sizes.dart';
import '../bloc/medicines_bloc.dart';

/// ????? ??? ??????? ?????????? — ????? ???? ???? ?????? ???? (World-Class Inventory Health Dashboard)
class InventoryHealthView extends StatelessWidget {
  const InventoryHealthView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MedicinesBloc(),
      child: const _InventoryHealthBody(),
    );
  }
}

class _InventoryHealthBody extends StatefulWidget {
  const _InventoryHealthBody();

  @override
  State<_InventoryHealthBody> createState() => _InventoryHealthViewState();
}

class _InventoryHealthViewState extends State<_InventoryHealthBody> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedSectionIndex = 0;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<MedicineModel> _getExpiringWithin(List<MedicineModel> medicines, int days) {
    final now = DateTime.now();
    final threshold = now.add(Duration(days: days));
    return medicines.where((m) =>
      m.expiryDate != null &&
      m.expiryDate!.isAfter(now) &&
      m.expiryDate!.isBefore(threshold)
    ).toList();
  }

  List<MedicineModel> _getActiveItems(List<MedicineModel> medicines) {
    List<MedicineModel> rawList = [];
    final now = DateTime.now();

    switch (_selectedSectionIndex) {
      case 0:
        rawList = medicines.where((m) => m.expiryDate != null && m.expiryDate!.isBefore(now)).toList();
        break;
      case 1:
        rawList = _getExpiringWithin(medicines, 30);
        break;
      case 2:
        rawList = _getExpiringWithin(medicines, 90);
        break;
      case 3:
        rawList = medicines.where((m) => m.alertEnabled && m.quantity <= m.minStock && m.quantity > 0).toList();
        break;
      case 4:
        rawList = medicines.where((m) => m.quantity <= 0).toList();
        break;
    }

    return rawList.filterByNameOrBarcode(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return HomeShell(
      title: InventoryStrings.inventoryHealthTitle,
      child: Container(
        color: scheme.surfaceContainerLow.withValues(alpha: 0.15),
        padding: EdgeInsets.all(20.w),
        child: BlocBuilder<MedicinesBloc, MedicinesState>(
          builder: (context, state) {
            final medicines = state.allMedicines;
            final isLoading = state.dataState.isLoading && medicines.isEmpty;

            return LayoutBuilder(
              builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < 900;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 1. ???? ???????? 100% Full-Width Responsive Row
                    _buildSummaryCards(medicines, constraints.maxWidth),
                    SizedBox(height: 16.h),

                    // 2. ??????? ??????? ?????? ??????? (Sidebar + Data Panel)
                    Expanded(
                      child: isLoading
                          ? const Center(child: LoadingIndicator())
                          : isNarrow
                              ? Column(
                                  children: [
                                    _buildHorizontalTabs(medicines),
                                    SizedBox(height: 12.h),
                                    Expanded(
                                      child: _buildItemsContentSection(scheme, medicines),
                                    ),
                                  ],
                                )
                              : Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // ??????? ???????? ??????? ?????????? ????????
                                    _buildSidebarRail(scheme, medicines),
                                    SizedBox(width: 16.w),

                                    // ?????? ???????? ???? ??????? ?????? ??????
                                    Expanded(
                                      child: _buildItemsContentSection(scheme, medicines),
                                    ),
                                  ],
                                ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildSummaryCards(List<MedicineModel> medicines, double maxWidth) {
    final expiredCount = medicines.where((m) => m.expiryDate != null && m.expiryDate!.isBefore(DateTime.now())).length;
    final exp30Count = _getExpiringWithin(medicines, 30).length;
    final exp90Count = _getExpiringWithin(medicines, 90).length;
    final lowStockCount = medicines.where((m) => m.alertEnabled && m.quantity <= m.minStock && m.quantity > 0).length;
    final outOfStockCount = medicines.where((m) => m.quantity <= 0).length;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 900;
        if (isWide) {
          return Row(
            children: [
              Expanded(child: _HealthCard(title: InventoryStrings.expiredItems, count: expiredCount, color: AppColors.error, icon: Icons.event_busy_rounded, isSelected: _selectedSectionIndex == 0, onTap: () => setState(() => _selectedSectionIndex = 0))),
              SizedBox(width: 10.w),
              Expanded(child: _HealthCard(title: InventoryStrings.expires30Days, count: exp30Count, color: AppColors.error, icon: Icons.schedule_rounded, isSelected: _selectedSectionIndex == 1, onTap: () => setState(() => _selectedSectionIndex = 1))),
              SizedBox(width: 10.w),
              Expanded(child: _HealthCard(title: InventoryStrings.expires90Days, count: exp90Count, color: AppColors.warning, icon: Icons.warning_amber_rounded, isSelected: _selectedSectionIndex == 2, onTap: () => setState(() => _selectedSectionIndex = 2))),
              SizedBox(width: 10.w),
              Expanded(child: _HealthCard(title: InventoryStrings.lowStockItems, count: lowStockCount, color: AppColors.warning, icon: Icons.trending_down_rounded, isSelected: _selectedSectionIndex == 3, onTap: () => setState(() => _selectedSectionIndex = 3))),
              SizedBox(width: 10.w),
              Expanded(child: _HealthCard(title: InventoryStrings.outOfStockItems, count: outOfStockCount, color: AppColors.error, icon: Icons.remove_shopping_cart_rounded, isSelected: _selectedSectionIndex == 4, onTap: () => setState(() => _selectedSectionIndex = 4))),
            ],
          );
        }

        return Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: [
            SizedBox(width: (constraints.maxWidth - 20.w) / 3, child: _HealthCard(title: InventoryStrings.expiredItems, count: expiredCount, color: AppColors.error, icon: Icons.event_busy_rounded, isSelected: _selectedSectionIndex == 0, onTap: () => setState(() => _selectedSectionIndex = 0))),
            SizedBox(width: (constraints.maxWidth - 20.w) / 3, child: _HealthCard(title: InventoryStrings.expires30Days, count: exp30Count, color: AppColors.error, icon: Icons.schedule_rounded, isSelected: _selectedSectionIndex == 1, onTap: () => setState(() => _selectedSectionIndex = 1))),
            SizedBox(width: (constraints.maxWidth - 20.w) / 3, child: _HealthCard(title: InventoryStrings.expires90Days, count: exp90Count, color: AppColors.warning, icon: Icons.warning_amber_rounded, isSelected: _selectedSectionIndex == 2, onTap: () => setState(() => _selectedSectionIndex = 2))),
          ],
        );
      },
    );
  }

  Widget _buildHorizontalTabs(List<MedicineModel> medicines) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildCategoryChip(0, InventoryStrings.expiredItemsDetailed, Icons.event_busy_rounded, AppColors.error, medicines),
          SizedBox(width: 8.w),
          _buildCategoryChip(1, InventoryStrings.expires30DaysDetailed, Icons.schedule_rounded, AppColors.error, medicines),
          SizedBox(width: 8.w),
          _buildCategoryChip(2, InventoryStrings.expires90DaysDetailed, Icons.warning_amber_rounded, AppColors.warning, medicines),
          SizedBox(width: 8.w),
          _buildCategoryChip(3, InventoryStrings.lowStockItemsDetailed, Icons.trending_down_rounded, AppColors.warning, medicines),
          SizedBox(width: 8.w),
          _buildCategoryChip(4, InventoryStrings.outOfStockItemsDetailed, Icons.remove_shopping_cart_rounded, AppColors.error, medicines),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(int index, String label, IconData icon, Color color, List<MedicineModel> medicines) {
    final isSelected = _selectedSectionIndex == index;
    final count = _getCategoryCount(index, medicines);

    return ChoiceChip(
      avatar: Icon(icon, size: 16.sp, color: isSelected ? color : color.withValues(alpha: 0.7)),
      label: Text('$label ($count)', style: TextStyle(fontSize: 12.sp, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? color : Theme.of(context).colorScheme.onSurfaceVariant)),
      selected: isSelected,
      onSelected: (s) {
        if (s) setState(() => _selectedSectionIndex = index);
      },
      selectedColor: color.withValues(alpha: 0.12),
      side: BorderSide(color: isSelected ? color.withValues(alpha: 0.4) : Colors.transparent),
    );
  }

  int _getCategoryCount(int index, List<MedicineModel> medicines) {
    final now = DateTime.now();
    switch (index) {
      case 0:
        return medicines.where((m) => m.expiryDate != null && m.expiryDate!.isBefore(now)).length;
      case 1:
        return _getExpiringWithin(medicines, 30).length;
      case 2:
        return _getExpiringWithin(medicines, 90).length;
      case 3:
        return medicines.where((m) => m.alertEnabled && m.quantity <= m.minStock && m.quantity > 0).length;
      case 4:
        return medicines.where((m) => m.quantity <= 0).length;
      default:
        return 0;
    }
  }

  Widget _buildSidebarRail(ColorScheme scheme, List<MedicineModel> medicines) {
    return Container(
      width: 270.w,
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            child: ReusableText(
              '????? ???????? ??????????',
              style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.bold, color: scheme.onSurfaceVariant),
            ),
          ),
          Divider(height: 12.h, color: scheme.outlineVariant.withValues(alpha: 0.2)),
          _buildRailItem(0, InventoryStrings.expiredItemsDetailed, Icons.event_busy_rounded, AppColors.error, medicines),
          _buildRailItem(1, InventoryStrings.expires30DaysDetailed, Icons.schedule_rounded, AppColors.error, medicines),
          _buildRailItem(2, InventoryStrings.expires90DaysDetailed, Icons.warning_amber_rounded, AppColors.warning, medicines),
          _buildRailItem(3, InventoryStrings.lowStockItemsDetailed, Icons.trending_down_rounded, AppColors.warning, medicines),
          _buildRailItem(4, InventoryStrings.outOfStockItemsDetailed, Icons.remove_shopping_cart_rounded, AppColors.error, medicines),
        ],
      ),
    );
  }

  Widget _buildRailItem(int index, String label, IconData icon, Color color, List<MedicineModel> medicines) {
    final isSelected = _selectedSectionIndex == index;
    final scheme = Theme.of(context).colorScheme;
    final count = _getCategoryCount(index, medicines);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: InkWell(
        onTap: () => setState(() {
          _selectedSectionIndex = index;
          _searchController.clear();
        }),
        borderRadius: BorderRadius.circular(AppRadius.button.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: isSelected ? color.withValues(alpha: 0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.button.r),
            border: Border.all(
              color: isSelected ? color.withValues(alpha: 0.4) : Colors.transparent,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 16.sp, color: color),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: ReusableText(
                  label,
                  style: AppTextStyles.body(context).copyWith(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? scheme.onSurface : scheme.onSurfaceVariant,
                    fontSize: 13.sp,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: isSelected ? color : scheme.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: ReusableText(
                  '$count',
                  style: AppTextStyles.caption(context).copyWith(
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : scheme.onSurfaceVariant,
                    fontSize: 11.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemsContentSection(ColorScheme scheme, List<MedicineModel> medicines) {
    final filteredItems = _getActiveItems(medicines);

    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: MedicineSearchField(
              controller: _searchController,
              customItems: medicines,
              onSelected: (m) => setState(() {
                _searchController.text = m.name;
              }),
            ),
          ),
          Divider(height: 1, color: scheme.outlineVariant.withValues(alpha: 0.2)),

          Expanded(
            child: filteredItems.isEmpty
                ? _buildHeroCleanDashboard(scheme)
                : ListView.separated(
                    padding: EdgeInsets.all(16.w),
                    physics: const BouncingScrollPhysics(),
                    itemCount: filteredItems.length,
                    separatorBuilder: (_, _) => SizedBox(height: 10.h),
                    itemBuilder: (context, idx) {
                      return _HealthItem(
                        medicine: filteredItems[idx],
                        color: _getSectionColor(),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Color _getSectionColor() {
    if (_selectedSectionIndex == 2 || _selectedSectionIndex == 3) {
      return AppColors.warning;
    }
    return AppColors.error;
  }

  Widget _buildHeroCleanDashboard(ColorScheme scheme) {
    return Padding(
      padding: EdgeInsets.all(24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.verified_user_rounded, size: 56.sp, color: AppColors.success),
          ),
          SizedBox(height: 16.h),
          ReusableText(
            _searchController.text.isNotEmpty ? SalesStrings.noMatchingResults : '??????? ?????? ???? 100%',
            style: AppTextStyles.title(context).copyWith(fontWeight: FontWeight.bold, color: scheme.onSurface),
          ),
          SizedBox(height: 8.h),
          ReusableText(
            _searchController.text.isNotEmpty
                ? '?? ??? ?????? ??? ????? ????? ????? ?? ??? ?????.'
                : '?? ???? ????? ?????? ???????? ?? ????? ???? ?? ??? ?????. ???? ??????? ?????? ????????.',
            style: AppTextStyles.body(context).copyWith(color: scheme.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),

          // ???? ????? ?????? ??????? ????? ???? ???? ????? (Zero Dead Space)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _HeroBadgePill(icon: Icons.shield_rounded, label: '??????? ?????', color: AppColors.success, scheme: scheme),
              SizedBox(width: 12.w),
              _HeroBadgePill(icon: Icons.inventory_rounded, label: '????? ????', color: AppColors.primary, scheme: scheme),
              SizedBox(width: 12.w),
              _HeroBadgePill(icon: Icons.tune_rounded, label: '???? ?????? ??????', color: AppColors.info, scheme: scheme),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroBadgePill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final ColorScheme scheme;

  const _HeroBadgePill({
    required this.icon,
    required this.label,
    required this.color,
    required this.scheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.button.r),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.sp, color: color),
          SizedBox(width: 6.w),
          ReusableText(label, style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.bold, color: color, fontSize: 12.sp)),
        ],
      ),
    );
  }
}

class _HealthCard extends StatelessWidget {
  final String title;
  final int count;
  final Color color;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _HealthCard({
    required this.title,
    required this.count,
    required this.color,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: isSelected ? color.withValues(alpha: 0.12) : scheme.surface,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(
              color: isSelected ? color : color.withValues(alpha: 0.2),
              width: isSelected ? 1.8 : 1.0,
            ),
            boxShadow: isSelected ? [
              BoxShadow(
                color: color.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ] : [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.input.r),
                ),
                child: Icon(icon, size: 20.sp, color: color),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ReusableText(
                      title,
                      style: AppTextStyles.caption(context).copyWith(color: isSelected ? color : scheme.onSurfaceVariant, fontWeight: FontWeight.w600, fontSize: 11.sp),
                      maxLines: 1,
                    ),
                    SizedBox(height: 2.h),
                    ReusableText(
                      '$count',
                      style: AppTextStyles.title(context).copyWith(fontWeight: FontWeight.w900, color: color, fontSize: 18.sp),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HealthItem extends StatelessWidget {
  final MedicineModel medicine;
  final Color color;

  const _HealthItem({
    required this.medicine,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.input.r),
            ),
            child: Icon(Icons.medication_rounded, size: 22.sp, color: color),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReusableText(
                  medicine.name,
                  style: AppTextStyles.bodyBold(context).copyWith(fontSize: 14.sp),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(Icons.inventory_2_outlined, size: 14.sp, color: scheme.onSurfaceVariant),
                    SizedBox(width: 4.w),
                    ReusableText(
                      '${InventoryStrings.stockBalanceLabel}${medicine.quantity} ${GeneralStrings.unit}',
                      style: AppTextStyles.caption(context).copyWith(color: scheme.onSurfaceVariant, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(width: 16.w),
                    Icon(Icons.notifications_active_outlined, size: 14.sp, color: color),
                    SizedBox(width: 4.w),
                    ReusableText(
                      '${InventoryStrings.safetyLimitLabel}${medicine.minStock}',
                      style: AppTextStyles.caption(context).copyWith(color: color, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (medicine.expiryDate != null) ...[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4.r)),
              child: ReusableText(
                '${InventoryStrings.expiryLabel}${medicine.expiryDate!.day}/${medicine.expiryDate!.month}/${medicine.expiryDate!.year}',
                style: AppTextStyles.caption(context).copyWith(color: color, fontWeight: FontWeight.bold, fontSize: 11.sp),
              ),
            ),
            SizedBox(width: 14.w),
          ],
          SizedBox(
            height: 36.h,
            child: ReusableButton(
              text: InventoryStrings.quickPurchaseRequest,
              prefixIcon: Icons.add_shopping_cart_rounded,
              onPressed: () {
                AppSnackbar.info(InventoryStrings.openingShortageInvoicesFormat.replaceFirst('%s', medicine.name), title: InventoryStrings.advancedPurchaseRequest);
              },
              type: ButtonType.outlined,
            ),
          ),
        ],
      ),
    );
  }
}







