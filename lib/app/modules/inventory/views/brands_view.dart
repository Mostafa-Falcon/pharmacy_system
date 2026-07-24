import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/bloc/base_paginated_bloc.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_colors.dart';
import 'package:pharmacy_system/app/core/models/inventory/medicine_brand_model.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/string_ext.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/index.dart';
import '../bloc/brands_bloc.dart';

class BrandsView extends StatelessWidget {
  const BrandsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BrandsBloc, PaginatedState<MedicineBrandModel>>(
      builder: (context, state) {
        return HomeShell(
          title: 'Ø§Ù„Ø¹Ù„Ø§Ù…Ø§Øª Ø§Ù„ØªØ¬Ø§Ø±ÙŠØ©',
          child: Container(
            color: Theme.of(context)
                .colorScheme
                .surfaceContainerLow
                .withValues(alpha: 0.3),
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

  Widget _buildHeader(BuildContext context, PaginatedState<MedicineBrandModel> state) {
    return Row(
      children: [
        AppButton(
          text: 'Ø¥Ø¶Ø§ÙØ© Ø¹Ù„Ø§Ù…Ø© ØªØ¬Ø§Ø±ÙŠØ©',
          prefixIcon: Icons.add_rounded,
          onPressed: () => _showBrandDialog(context),
        ),
        const Spacer(),
        AppText(
          '${state.items.length} Ø¹Ù„Ø§Ù…Ø© ØªØ¬Ø§Ø±ÙŠØ©',
          style: TextStyle(
            fontSize: 12.sp,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
  }

  Widget _buildSearchBar(BuildContext context, PaginatedState<MedicineBrandModel> state) {
    final bloc = context.read<BrandsBloc>();
    if (state.searchQuery != '' || state.items.length > 5) {
      return SearchField(
        hint: 'Ø¨Ø­Ø« Ø¹Ù† Ø¹Ù„Ø§Ù…Ø© ØªØ¬Ø§Ø±ÙŠØ©...',
        onChanged: (v) => bloc.add(SearchItems(v)),
        onClear: () => bloc.add(const SearchItems('')),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildList(BuildContext context, PaginatedState<MedicineBrandModel> state) {
    if (state.isLoading) {
      return const LoadingIndicator();
    }
    final items = state.items;
    if (items.isEmpty) {
      return const EmptyState(
        icon: Icons.branding_watermark_outlined,
        title: 'Ù„Ø§ ÙŠÙˆØ¬Ø¯ Ø¹Ù„Ø§Ù…Ø§Øª ØªØ¬Ø§Ø±ÙŠØ©',
      );
    }
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, _) => SizedBox(height: AppSpacing.sm.h),
      itemBuilder: (_, i) => _brandTile(context, items[i]),
    );
  }

  Widget _brandTile(BuildContext context, MedicineBrandModel brand) {
    final bloc = context.read<BrandsBloc>();
    final menuItems = <PopupMenuEntry<String>>[
      ReusableActionMenuItem(
        value: 'edit',
        icon: Icons.edit_outlined,
        label: GeneralStrings.edit,
      ),
      ReusableActionMenuItem(
        value: 'delete',
        icon: Icons.delete_outline_rounded,
        label: GeneralStrings.delete,
        color: AppColors.error,
      ),
    ];

    return PartyListTile(
      avatarIcon: Icons.branding_watermark_rounded,
      avatarColor: AppColors.primary,
      title: brand.name,
      subtitle: brand.description,
      menuItems: menuItems,
      onMenuSelected: (v) {
        switch (v) {
          case 'edit':
            _showBrandDialog(context, brand: brand);
            break;
          case 'delete':
            ConfirmDeleteDialog.show(
              context,
              title: 'Ø­Ø°Ù Ø¹Ù„Ø§Ù…Ø© ØªØ¬Ø§Ø±ÙŠØ©',
              message: 'Ù‡Ù„ Ø£Ù†Øª Ù…ØªØ£ÙƒØ¯ Ù…Ù† Ø­Ø°Ù "${brand.name}"ØŸ',
              onConfirm: () => bloc.add(DeleteBrand(brand.id)),
            );
            break;
        }
      },
      onTap: () => _showBrandDialog(context, brand: brand),
    );
  }

  void _showBrandDialog(BuildContext context, {MedicineBrandModel? brand}) {
    final bloc = context.read<BrandsBloc>();
    final nameCtrl = TextEditingController(text: brand?.name ?? '');
    final descCtrl = TextEditingController(text: brand?.description ?? '');
    final isEditing = brand != null;

    showDialog(
      context: context,
      builder: (context) => AppDialog(
        title: isEditing ? 'ØªØ¹Ø¯ÙŠÙ„ Ø¹Ù„Ø§Ù…Ø© ØªØ¬Ø§Ø±ÙŠØ©' : 'Ø¥Ø¶Ø§ÙØ© Ø¹Ù„Ø§Ù…Ø© ØªØ¬Ø§Ø±ÙŠØ© Ø¬Ø¯ÙŠØ¯Ø©',
        children: [
          AppInput.text(
            controller: nameCtrl,
            label: 'Ø§Ù„Ø§Ø³Ù… *',
            textDirection: TextDirection.rtl,
          ),
          SizedBox(height: AppSpacing.sm.h),
          AppInput.text(
            controller: descCtrl,
            label: 'Ø§Ù„ÙˆØµÙ',
            maxLines: 2,
            textDirection: TextDirection.rtl,
          ),
          SizedBox(height: AppSpacing.md.h),
          DialogActions(
            confirmText: isEditing ? 'Ø­ÙØ¸' : 'Ø¥Ø¶Ø§ÙØ©',
            onConfirm: () {
              if (nameCtrl.text.trim().isEmpty) return;
              if (isEditing) {
                bloc.add(UpdateBrand(
                  brand.copyWith(
                    name: nameCtrl.text.trim(),
                    description: descCtrl.text.trim().nullIfEmpty,
                  ),
                ));
              } else {
                bloc.add(AddBrand(
                  name: nameCtrl.text.trim(),
                  description: descCtrl.text.trim().nullIfEmpty,
                ));
              }
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}







