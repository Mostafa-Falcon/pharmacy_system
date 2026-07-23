import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:pharmacy_system/app/core/constants/app_strings.dart';

import '../bloc/items_archive_bloc.dart';
import 'package:pharmacy_system/app/modules/inventory/models/medicine_model.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/index.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/reusables/tables/shared_table_cells.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_colors.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_sizes.dart';

class ItemsArchiveView extends StatelessWidget {
  const ItemsArchiveView({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ItemsArchiveBloc>();
    if (!bloc.canManage) {
      return const HomeShell(
        title: AppStrings.medicinesArchive,
        child: ReusableStateView.permissionDenied(
          title: AppStrings.permissionDenied,
          message:
              'أرشيف الأصناف المحذوفة متاح فقط لمدير النظام أو صاحب الصيدلية.',
        ),
      );
    }

    return BlocBuilder<ItemsArchiveBloc, ItemsArchiveState>(
      builder: (context, state) {
        return StandardModuleLayout(
          title: AppStrings.medicinesArchive,
          subtitle: AppStrings.archiveSubtitle,
          actions: _buildHeaderActions(context, state),
          filters: _buildFilters(context, state),
          content: _buildContent(context, state),
        );
      },
    );
  }

  List<Widget> _buildHeaderActions(
    BuildContext context,
    ItemsArchiveState state,
  ) {
    final bloc = context.read<ItemsArchiveBloc>();
    if (state.selectedIds.isEmpty) return [];

    return [
      ReusableText(
        'تم تحديد ${state.selectedIds.length} صنف',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      ReusableButton(
        text: AppStrings.restoreSelected,
        prefixIcon: Icons.restore_rounded,
        onPressed:
            state.isWorking ? null : () => bloc.add(const RestoreSelected()),
        type: ButtonType.text,
      ),
      ReusableButton(
        text: AppStrings.archivePermanentDelete,
        prefixIcon: Icons.delete_forever_rounded,
        onPressed:
            state.isWorking ? null : () => bloc.add(const DeleteSelected()),
        type: ButtonType.outlined,
        color: AppColors.error,
      ),
    ];
  }

  Widget _buildFilters(BuildContext context, ItemsArchiveState state) {
    final bloc = context.read<ItemsArchiveBloc>();
    return AppCard(
      padding: EdgeInsets.all(AppSpacing.md),
      child: ReusableInput(
        hint: 'ابحث في الأرشيف بالاسم أو الباركود...',
        prefixIcon: const Icon(Icons.search_rounded),
        showClearButton: true,
        textDirection: TextDirection.rtl,
        onChanged: (v) => bloc.add(SearchItemsArchive(v)),
        onClear: () => bloc.add(const SearchItemsArchive('')),
      ),
    );
  }

  Widget _buildContent(BuildContext context, ItemsArchiveState state) {
    final bloc = context.read<ItemsArchiveBloc>();
    final scheme = Theme.of(context).colorScheme;

    if (state.status == ItemsArchiveStatus.loading) {
      return const Center(child: LoadingIndicator(message: 'جاري تحميل الأرشيف...'));
    }

    final items = state.items;
    if (items.isEmpty) {
      return const EmptyState(
        icon: Icons.inventory_2_outlined,
        title: AppStrings.archiveEmpty,
        subtitle: 'لا توجد أصناف مؤرشفة مطابقة لبحثك.',
      );
    }

    final columns = [
      ReusableTableColumn<MedicineModel>(
        id: 'name',
        title: 'الصنف والباركود',
        flex: 2,
        isSortable: true,
        cellBuilder: (m) => TableContactNameCell(
          name: m.name,
          subtitle: m.barcodes.firstOrNull ?? 'بدون باركود',
          icon: Icons.inventory_2_rounded,
          iconColor: scheme.primary,
        ),
      ),
      ReusableTableColumn<MedicineModel>(
        id: 'category',
        title: 'التصنيف',
        width: 150.w,
        textBuilder: (m) => m.category ?? '—',
      ),
      ReusableTableColumn<MedicineModel>(
        id: 'sellPrice',
        title: 'سعر البيع',
        width: 120.w,
        isNumeric: true,
        cellBuilder: (m) => TableMoneyCell(amount: m.sellPrice, currency: AppStrings.currency, isHighlight: true),
      ),
      ReusableTableColumn<MedicineModel>(
        id: 'quantity',
        title: 'المخزون',
        width: 100.w,
        isNumeric: true,
        textBuilder: (m) => '${m.quantity}',
      ),
      ReusableTableColumn<MedicineModel>(
        id: 'archivedAt',
        title: 'تاريخ الأرشفة',
        width: 160.w,
        textBuilder: (m) => DateFormat('yyyy/MM/dd HH:mm').format(m.lastModified),
      ),
    ];

    return ReusableTable<MedicineModel>(
      columns: columns,
      items: items,
      isLoading: state.isWorking,
      showCheckbox: true,
      selectedIds: state.selectedIds,
      rowIdGetter: (m) => m.id,
      onSelectRow: (id) => bloc.add(ToggleItemSelection(id)),
      onToggleAll: (v) => bloc.add(const ToggleAllSelection()),
      itemLabel: 'صنف مؤرشف',
      rowActions: (m) => TableOptionsButton(
        onSelected: (v) {
          if (v == 'restore') bloc.add(RestoreItem(m.id));
          if (v == 'delete') bloc.add(DeleteItem(m.id));
        },
        menuItems: [
          const PopupMenuItem(value: 'restore', child: ReusableText('استعادة الصنف', color: AppColors.success)),
          const PopupMenuItem(value: 'delete', child: ReusableText('حذف نهائي', color: AppColors.error)),
        ],
      ),
    );
  }
}

