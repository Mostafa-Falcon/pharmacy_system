import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pharmacy_system/app/core/presentation/theme/app_colors.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/index.dart';
import '../bloc/price_groups_bloc.dart';

class PriceGroupsView extends StatelessWidget {
  const PriceGroupsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PriceGroupsBloc, PriceGroupsState>(
      builder: (context, state) {
        return HomeShell(
          title: 'مجموعات الأسعار',
          child: Container(
            color: Theme.of(
              context,
            ).colorScheme.surfaceContainerLow.withValues(alpha: 0.3),
            padding: EdgeInsets.all(AppSpacing.xl.w),
            child: Column(
              children: [
                _buildHeader(context, state),
                SizedBox(height: AppSpacing.lg.h),
                _buildSearchBar(context, state),
                SizedBox(height: AppSpacing.md.h),
                Expanded(child: _buildList(context, state)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, PriceGroupsState state) {
    return Row(
      children: [
        ReusableButton(
          text: 'إضافة مجموعة أسعار',
          prefixIcon: Icons.add_rounded,
          onPressed: () => _showPriceGroupDialog(context),
        ),
        const Spacer(),
        ReusableText(
          '${state.priceGroups.length} مجموعة',
          style: TextStyle(
            fontSize: 12.sp,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context, PriceGroupsState state) {
    final bloc = context.read<PriceGroupsBloc>();
    if (state.searchQuery.isNotEmpty || state.priceGroups.length > 5) {
      return SearchField(
        hint: 'بحث عن مجموعة أسعار...',
        onChanged: (v) => bloc.add(FilterPriceGroups(v)),
        onClear: () => bloc.add(const FilterPriceGroups('')),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildList(BuildContext context, PriceGroupsState state) {
    if (state.isLoading) {
      return const LoadingIndicator();
    }
    final items = state.filteredPriceGroups;
    if (items.isEmpty) {
      return const EmptyState(
        icon: Icons.attach_money_outlined,
        title: 'لا يوجد مجموعات أسعار',
      );
    }
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, _) => SizedBox(height: AppSpacing.sm.h),
      itemBuilder: (_, i) => _priceGroupTile(context, items[i]),
    );
  }

  Widget _priceGroupTile(BuildContext context, dynamic group) {
    final bloc = context.read<PriceGroupsBloc>();
    final menuItems = <PopupMenuEntry<String>>[
      ReusableActionMenuItem(
        value: 'edit',
        icon: Icons.edit_outlined,
        label: AppStrings.edit,
      ),
      if (!group.isDefault)
        ReusableActionMenuItem(
          value: 'set_default',
          icon: Icons.star_outline_rounded,
          label: InventoryStrings.setAsDefault,
        ),
      ReusableActionMenuItem(
        value: 'delete',
        icon: Icons.delete_outline_rounded,
        label: AppStrings.delete,
        color: AppColors.error,
      ),
    ];

    return PartyListTile(
      avatarIcon: Icons.price_change_rounded,
      avatarColor: group.isDefault ? AppColors.success : AppColors.primary,
      title: group.name,
      subtitle:
          'إضافة ${group.markupPercentage.toStringAsFixed(1)}% | خصم ${group.discountPercentage.toStringAsFixed(1)}%',
      tags: [
        if (group.isDefault) Tag(label: 'افتراضي', color: AppColors.success),
      ],
      menuItems: menuItems,
      onMenuSelected: (v) {
        switch (v) {
          case 'edit':
            _showPriceGroupDialog(context, group: group);
            break;
          case 'set_default':
            bloc.add(SetPriceGroupDefault(group.id));
            break;
          case 'delete':
            ConfirmDeleteDialog.show(
              context,
              title: 'حذف مجموعة أسعار',
              message: 'هل أنت متأكد من حذف "${group.name}"؟',
              onConfirm: () => bloc.add(DeletePriceGroup(group.id)),
            );
            break;
        }
      },
      onTap: () => _showPriceGroupDialog(context, group: group),
    );
  }

  void _showPriceGroupDialog(BuildContext context, {dynamic group}) {
    final bloc = context.read<PriceGroupsBloc>();
    final nameCtrl = TextEditingController(text: group?.name ?? '');
    final markupCtrl = TextEditingController(
      text: group?.markupPercentage.toString() ?? '0',
    );
    final discountCtrl = TextEditingController(
      text: group?.discountPercentage.toString() ?? '0',
    );
    final isEditing = group != null;

    showDialog(
      context: context,
      builder: (context) => ReusableDialog(
        title: isEditing ? 'تعديل مجموعة أسعار' : 'إضافة مجموعة أسعار جديدة',
        children: [
          ReusableInput.text(
            controller: nameCtrl,
            label: 'الاسم *',
            textDirection: TextDirection.rtl,
          ),
          SizedBox(height: AppSpacing.sm.h),
          ReusableInput(
            controller: markupCtrl,
            label: 'نسبة الربح %',
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: AppSpacing.sm.h),
          ReusableInput(
            controller: discountCtrl,
            label: 'نسبة الخصم %',
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: AppSpacing.md.h),
          DialogActions(
            confirmText: isEditing ? 'حفظ' : 'إضافة',
            onConfirm: () {
              if (nameCtrl.text.trim().isEmpty) return;
              if (isEditing) {
                bloc.add(
                  UpdatePriceGroup(
                    group.copyWith(
                      name: nameCtrl.text.trim(),
                      markupPercentage: double.tryParse(markupCtrl.text) ?? 0,
                      discountPercentage:
                          double.tryParse(discountCtrl.text) ?? 0,
                    ),
                  ),
                );
              } else {
                bloc.add(
                  AddPriceGroup(
                    name: nameCtrl.text.trim(),
                    markupPercentage: double.tryParse(markupCtrl.text) ?? 0,
                    discountPercentage: double.tryParse(discountCtrl.text) ?? 0,
                  ),
                );
              }
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
