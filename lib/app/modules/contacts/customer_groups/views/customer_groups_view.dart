import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/bloc/base_paginated_bloc.dart';
import 'package:pharmacy_system/app/core/models/contacts/customer_group_model.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_colors.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/string_ext.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/index.dart';
import '../bloc/customer_groups_bloc.dart';

class CustomerGroupsView extends StatelessWidget {
  const CustomerGroupsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const _CustomerGroupsBody();
  }
}

class _CustomerGroupsBody extends StatelessWidget {
  const _CustomerGroupsBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerGroupsBloc, PaginatedState<CustomerGroupModel>>(
      builder: (context, state) {
        if (state.isLoading && state.items.isEmpty) {
          return HomeShell(
            title: 'مجموعات العملاء',
            child: const Center(child: LoadingIndicator()),
          );
        }

        if (state.isFailure) {
          return HomeShell(
            title: 'مجموعات العملاء',
            child: ReusableStateView(
              message: state.error ?? 'خطأ في تحميل المجموعات',
              action: ReusableButton(
                text: 'إعادة المحاولة',
                onPressed: () => context
                    .read<CustomerGroupsBloc>()
                    .add(const LoadItems()),
              ),
            ),
          );
        }

        final items = state.items;

        return StandardModuleLayout(
          title: 'مجموعات العملاء',
          actions: [
            ReusableButton(
              text: 'إضافة مجموعة',
              prefixIcon: Icons.add_rounded,
              onPressed: () => _showGroupDialog(context),
            ),
          ],
          stats: [
            SummaryCard(
              label: 'إجمالي المجموعات',
              value: '${state.totalItems}',
              icon: Icons.group_work_rounded,
            ),
          ],
          filters: _buildFilters(context, state),
          content: _buildContent(context, items),
        );
      },
    );
  }

  Widget _buildFilters(
      BuildContext context, PaginatedState<CustomerGroupModel> state) {
    final bloc = context.read<CustomerGroupsBloc>();
    if (state.totalItems <= 5 && state.searchQuery == '') {
      return const SizedBox.shrink();
    }

    return AppCard(
      padding: EdgeInsets.all(AppSpacing.md),
      child: SearchField(
        hint: 'بحث عن مجموعة عملاء...',
        onChanged: (v) => bloc.add(SearchItems(v)),
        onClear: () => bloc.add(const SearchItems('')),
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<CustomerGroupModel> items) {
    if (items.isEmpty) {
      return EmptyState(
        icon: Icons.group_work_outlined,
        title: 'لا يوجد مجموعات عملاء',
        subtitle: 'ابدأ بإضافة أول مجموعة لتنظيم عملائك وتطبيق خصومات تلقائية.',
      );
    }

    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, _) => SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, i) => _groupTile(context, items[i]),
    );
  }

  Widget _groupTile(BuildContext context, CustomerGroupModel g) {
    final bloc = context.read<CustomerGroupsBloc>();
    final menuItems = <PopupMenuEntry<String>>[
      ReusableActionMenuItem(
        value: 'edit',
        icon: Icons.edit_outlined,
        label: GeneralStrings.edit,
      ),
      ReusableActionMenuItem(
        value: 'toggle',
        icon: g.isActive ? Icons.toggle_off_outlined : Icons.toggle_on_outlined,
        label: g.isActive ? CustomersStrings.deactivate : CustomersStrings.activate,
      ),
      ReusableActionMenuItem(
        value: 'delete',
        icon: Icons.delete_outline_rounded,
        label: GeneralStrings.delete,
        color: AppColors.error,
      ),
    ];

    return PartyListTile(
      avatarIcon: Icons.group_rounded,
      avatarColor: g.isActive ? AppColors.primary : AppColors.error,
      title: g.name,
      subtitle: g.description,
      tags: [
        Tag(
          label: 'خصم ${g.discountPercent.toStringAsFixed(0)}%${g.priceGroupId != null ? ' | مجموعة أسعار: ${g.priceGroupId}' : ''}',
          color: AppColors.info,
        ),
      ],
      menuItems: menuItems,
      onMenuSelected: (v) {
        switch (v) {
          case 'edit':
            _showGroupDialog(context, group: g);
            break;
          case 'toggle':
            bloc.add(ToggleActiveCustomerGroup(g.id));
            break;
          case 'delete':
            ConfirmDeleteDialog.show(
              context,
              title: 'حذف مجموعة',
              message: 'هل أنت متأكد من حذف المجموعة "${g.name}"؟',
              onConfirm: () => bloc.add(DeleteCustomerGroup(g.id)),
            );
            break;
        }
      },
      onTap: () => _showGroupDialog(context, group: g),
    );
  }

  void _showGroupDialog(BuildContext context, {CustomerGroupModel? group}) {
    final nameCtrl = TextEditingController(text: group?.name ?? '');
    final discountCtrl = TextEditingController(
      text: group?.discountPercent.toString() ?? '0',
    );
    final descCtrl = TextEditingController(text: group?.description ?? '');
    final isEditing = group != null;
    final bloc = context.read<CustomerGroupsBloc>();

    showDialog(
      context: context,
      builder: (context) => ReusableDialog(
        title: isEditing ? 'تعديل مجموعة' : 'إضافة مجموعة جديدة',
        children: [
          ReusableInput.text(
            controller: nameCtrl,
            label: 'الاسم *',
            textDirection: TextDirection.rtl,
          ),
          SizedBox(height: AppSpacing.sm.h),
          ReusableInput(
            controller: discountCtrl,
            label: 'نسبة الخصم %',
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: AppSpacing.sm.h),
          ReusableInput.text(
            controller: descCtrl,
            label: 'الوصف',
            maxLines: 2,
            textDirection: TextDirection.rtl,
          ),
          SizedBox(height: AppSpacing.md.h),
          DialogActions(
            confirmText: isEditing ? 'حفظ' : 'إضافة',
            onConfirm: () async {
              if (nameCtrl.text.trim().isEmpty) return;
              if (isEditing) {
                bloc.add(UpdateCustomerGroup(
                  group.copyWith(
                    name: nameCtrl.text.trim(),
                    discountPercent: double.tryParse(discountCtrl.text) ?? 0,
                    description: descCtrl.text.trim().nullIfEmpty,
                  ),
                ));
              } else {
                bloc.add(AddCustomerGroup(
                  name: nameCtrl.text.trim(),
                  discountPercent: double.tryParse(discountCtrl.text) ?? 0,
                  description: descCtrl.text.trim().nullIfEmpty,
                ));
              }
              Navigator.pop(context);
            },
          ),
        ],
      ),
    ).whenComplete(() {
      nameCtrl.dispose();
      discountCtrl.dispose();
      descCtrl.dispose();
    });
  }
}






