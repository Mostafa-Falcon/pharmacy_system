import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:pharmacy_system/app/core/constants/app_strings.dart';

import '../bloc/items_archive_bloc.dart';
import 'package:pharmacy_system/app/modules/inventory/models/medicine_model.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/index.dart';
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
    if (state.status == ItemsArchiveStatus.loading) {
      return const Center(
          child: LoadingIndicator(message: 'جاري تحميل الأرشيف...'));
    }
    final items = state.items;
    if (items.isEmpty) {
      return const EmptyState(
        icon: Icons.inventory_2_outlined,
        title: AppStrings.archiveEmpty,
        subtitle: 'لا توجد أصناف مؤرشفة مطابقة لبحثك.',
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 800) {
          return ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, index) => SizedBox(height: AppSpacing.sm),
            itemBuilder: (_, index) => _ArchiveCard(item: items[index]),
          );
        }
        return _ArchiveTable(items: items);
      },
    );
  }
}

class _ArchiveTable extends StatelessWidget {
  final List<MedicineModel> items;
  const _ArchiveTable({required this.items});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ItemsArchiveBloc>();
    final scheme = Theme.of(context).colorScheme;
    
    return BlocBuilder<ItemsArchiveBloc, ItemsArchiveState>(
      builder: (context, state) {
        return AppCard(
          padding: EdgeInsets.zero,
          child: SingleChildScrollView(
            child: DataTable(
              showCheckboxColumn: false,
              headingRowColor: WidgetStatePropertyAll(scheme.surfaceContainerLow.withValues(alpha: 0.5)),
              columns: [
                DataColumn(
                  label: Checkbox(
                    value: items.isNotEmpty && items.every((i) => state.selectedIds.contains(i.id)),
                    onChanged: (_) => bloc.add(const ToggleAllSelection()),
                  ),
                ),
                const DataColumn(label: ReusableText('الصنف والباركود', style: TextStyle(fontWeight: FontWeight.bold))),
                const DataColumn(label: ReusableText('التصنيف', style: TextStyle(fontWeight: FontWeight.bold))),
                const DataColumn(label: ReusableText('سعر البيع', style: TextStyle(fontWeight: FontWeight.bold))),
                const DataColumn(label: ReusableText('المخزون', style: TextStyle(fontWeight: FontWeight.bold))),
                const DataColumn(label: ReusableText('تاريخ الأرشفة', style: TextStyle(fontWeight: FontWeight.bold))),
                const DataColumn(label: ReusableText('الإجراءات', style: TextStyle(fontWeight: FontWeight.bold))),
              ],
              rows: [
                for (final item in items)
                  DataRow(cells: [
                    DataCell(
                      Checkbox(
                        value: state.selectedIds.contains(item.id),
                        onChanged: (_) => bloc.add(ToggleItemSelection(item.id)),
                      ),
                    ),
                    DataCell(
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ReusableText(item.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                          if (item.barcodes.isNotEmpty)
                            ReusableText(item.barcodes.first, variant: ReusableTextVariant.caption),
                        ],
                      ),
                    ),
                    DataCell(ReusableText(item.category ?? '—')),
                    DataCell(
                      ReusableText(
                        '${item.sellPrice.toStringAsFixed(2)} ${AppStrings.currency}',
                        style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.bold, color: scheme.primary),
                      ),
                    ),
                    DataCell(ReusableText('${item.quantity}')),
                    DataCell(
                      ReusableText(
                        DateFormat('yyyy/MM/dd HH:mm').format(item.lastModified.toLocal()),
                        style: AppTextStyles.caption(context).copyWith(color: AppColors.textSecondaryOf(context)),
                      ),
                    ),
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            tooltip: AppStrings.restore,
                            onPressed: state.isWorking ? null : () => bloc.add(RestoreItem(item.id)),
                            icon: const Icon(Icons.restore_rounded, color: AppColors.success),
                          ),
                          IconButton(
                            tooltip: AppStrings.archivePermanentDelete,
                            onPressed: state.isWorking ? null : () => bloc.add(DeleteItem(item.id)),
                            icon: const Icon(Icons.delete_forever_rounded, color: AppColors.error),
                          ),
                        ],
                      ),
                    ),
                  ]),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ArchiveCard extends StatelessWidget {
  final MedicineModel item;
  const _ArchiveCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ItemsArchiveBloc>();
    final scheme = Theme.of(context).colorScheme;
    
    return BlocBuilder<ItemsArchiveBloc, ItemsArchiveState>(
      builder: (context, state) {
        return AppCard(
          padding: EdgeInsets.all(AppSpacing.sm.w),
          child: Row(
            children: [
              Checkbox(
                value: state.selectedIds.contains(item.id),
                onChanged: (_) => bloc.add(ToggleItemSelection(item.id)),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReusableText(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    ReusableText(
                      '${item.barcodes.firstOrNull ?? 'بدون باركود'} | ${item.category ?? 'بدون تصنيف'}',
                      variant: ReusableTextVariant.caption,
                    ),
                    ReusableText(
                      'المخزون عند الأرشفة: ${item.quantity}',
                      style: AppTextStyles.caption(context).copyWith(color: AppColors.textMutedOf(context)),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ReusableText(
                    '${item.sellPrice.toStringAsFixed(2)} ${AppStrings.currency}',
                    style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.bold, color: scheme.primary),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        onPressed: state.isWorking ? null : () => bloc.add(RestoreItem(item.id)),
                        icon: const Icon(Icons.restore_rounded, color: AppColors.success, size: 20),
                      ),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        onPressed: state.isWorking ? null : () => bloc.add(DeleteItem(item.id)),
                        icon: const Icon(Icons.delete_forever_rounded, color: AppColors.error, size: 20),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

