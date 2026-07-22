import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/bloc/base_paginated_bloc.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_colors.dart';
import 'package:pharmacy_system/app/modules/inventory/models/medicine_brand_model.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/string_ext.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/index.dart';
import '../bloc/brands_bloc.dart';

class BrandsView extends StatelessWidget {
  const BrandsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BrandsBloc, PaginatedState<MedicineBrandModel>>(
      builder: (context, state) {
        return HomeShell(
          title: 'Ã˜Â§Ã™â€žÃ˜Â¹Ã™â€žÃ˜Â§Ã™â€¦Ã˜Â§Ã˜Âª Ã˜Â§Ã™â€žÃ˜ÂªÃ˜Â¬Ã˜Â§Ã˜Â±Ã™Å Ã˜Â©',
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
        ReusableButton(
          text: 'Ã˜Â¥Ã˜Â¶Ã˜Â§Ã™ÂÃ˜Â© Ã˜Â¹Ã™â€žÃ˜Â§Ã™â€¦Ã˜Â© Ã˜ÂªÃ˜Â¬Ã˜Â§Ã˜Â±Ã™Å Ã˜Â©',
          prefixIcon: Icons.add_rounded,
          onPressed: () => _showBrandDialog(context),
        ),
        const Spacer(),
        ReusableText(
          '${state.items.length} Ã˜Â¹Ã™â€žÃ˜Â§Ã™â€¦Ã˜Â© Ã˜ÂªÃ˜Â¬Ã˜Â§Ã˜Â±Ã™Å Ã˜Â©',
          style: TextStyle(
            fontSize: 12.sp,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context, PaginatedState<MedicineBrandModel> state) {
    final bloc = context.read<BrandsBloc>();
    if (state.searchQuery != '' || state.items.length > 5) {
      return SearchField(
        hint: 'Ã˜Â¨Ã˜Â­Ã˜Â« Ã˜Â¹Ã™â€  Ã˜Â¹Ã™â€žÃ˜Â§Ã™â€¦Ã˜Â© Ã˜ÂªÃ˜Â¬Ã˜Â§Ã˜Â±Ã™Å Ã˜Â©...',
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
        title: 'Ã™â€žÃ˜Â§ Ã™Å Ã™Ë†Ã˜Â¬Ã˜Â¯ Ã˜Â¹Ã™â€žÃ˜Â§Ã™â€¦Ã˜Â§Ã˜Âª Ã˜ÂªÃ˜Â¬Ã˜Â§Ã˜Â±Ã™Å Ã˜Â©',
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
        label: AppStrings.edit,
      ),
      ReusableActionMenuItem(
        value: 'delete',
        icon: Icons.delete_outline_rounded,
        label: AppStrings.delete,
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
              title: 'Ã˜Â­Ã˜Â°Ã™Â Ã˜Â¹Ã™â€žÃ˜Â§Ã™â€¦Ã˜Â© Ã˜ÂªÃ˜Â¬Ã˜Â§Ã˜Â±Ã™Å Ã˜Â©',
              message: 'Ã™â€¡Ã™â€ž Ã˜Â£Ã™â€ Ã˜Âª Ã™â€¦Ã˜ÂªÃ˜Â£Ã™Æ’Ã˜Â¯ Ã™â€¦Ã™â€  Ã˜Â­Ã˜Â°Ã™Â "${brand.name}"Ã˜Å¸',
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
      builder: (context) => ReusableDialog(
        title: isEditing ? 'Ã˜ÂªÃ˜Â¹Ã˜Â¯Ã™Å Ã™â€ž Ã˜Â¹Ã™â€žÃ˜Â§Ã™â€¦Ã˜Â© Ã˜ÂªÃ˜Â¬Ã˜Â§Ã˜Â±Ã™Å Ã˜Â©' : 'Ã˜Â¥Ã˜Â¶Ã˜Â§Ã™ÂÃ˜Â© Ã˜Â¹Ã™â€žÃ˜Â§Ã™â€¦Ã˜Â© Ã˜ÂªÃ˜Â¬Ã˜Â§Ã˜Â±Ã™Å Ã˜Â© Ã˜Â¬Ã˜Â¯Ã™Å Ã˜Â¯Ã˜Â©',
        children: [
          ReusableInput.text(
            controller: nameCtrl,
            label: 'Ã˜Â§Ã™â€žÃ˜Â§Ã˜Â³Ã™â€¦ *',
            textDirection: TextDirection.rtl,
          ),
          SizedBox(height: AppSpacing.sm.h),
          ReusableInput.text(
            controller: descCtrl,
            label: 'Ã˜Â§Ã™â€žÃ™Ë†Ã˜ÂµÃ™Â',
            maxLines: 2,
            textDirection: TextDirection.rtl,
          ),
          SizedBox(height: AppSpacing.md.h),
          DialogActions(
            confirmText: isEditing ? 'Ã˜Â­Ã™ÂÃ˜Â¸' : 'Ã˜Â¥Ã˜Â¶Ã˜Â§Ã™ÂÃ˜Â©',
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


