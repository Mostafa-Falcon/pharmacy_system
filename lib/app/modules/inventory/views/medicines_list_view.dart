import 'dart:async';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_strings.dart';
import 'package:pharmacy_system/app/modules/inventory/models/medicine_model.dart';
import '../../../core/navigation/route_cubit.dart';
import 'package:pharmacy_system/app/core/data/services/lookup_service.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_colors.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_sizes.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/index.dart';
import '../../../routes/app_routes.dart';
import '../bloc/medicines_bloc.dart';

class MedicinesListView extends StatefulWidget {
  const MedicinesListView({super.key});

  @override
  State<MedicinesListView> createState() => _MedicinesListViewState();
}

class _MedicinesListViewState extends State<MedicinesListView> {
  Timer? _debounce;
  StreamSubscription<String>? _routeSubscription;
  String? _previousRoute;

  @override
  void initState() {
    super.initState();
    _previousRoute = routeCubit.currentRoute;
    _routeSubscription = routeCubit.stream.listen((route) {
      if (route == Routes.INVENTORY_LIST &&
          _previousRoute != Routes.INVENTORY_LIST) {
        if (mounted) {
          final bloc = context.read<MedicinesBloc>();
          if (!bloc.isClosed) bloc.add(const LoadMedicines());
        }
      }
      _previousRoute = route;
    });
    final bloc = context.read<MedicinesBloc>();
    if (!bloc.isClosed) bloc.add(const LoadMedicines());
  }

  @override
  void dispose() {
    _routeSubscription?.cancel();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        context.read<MedicinesBloc>().add(SearchMedicines(query));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MedicinesBloc, MedicinesState>(
      builder: (context, state) {
        if (state.dataState.isLoading && state.allMedicines.isEmpty) {
          return const HomeShell(
            title: AppStrings.inventoryTitle,
            child: Center(child: LoadingIndicator()),
          );
        }

        return StandardModuleLayout(
          title: AppStrings.inventoryTitle,
          subtitle: AppStrings.inventorySubtitle,
          actions: _buildHeaderActions(context, state),
          stats: _buildStats(context, state),
          filters: _buildFilters(context, state),
          content: _buildTable(context, state),
          showProgress: state.isLoadingAction,
          progress: state.bulkActionProgress,
          progressTitle: state.bulkActionTitle,
        );
      },
    );
  }

  List<Widget> _buildHeaderActions(BuildContext context, MedicinesState state) {
    return [
      ReusableButton(
        text: AppStrings.addMedicine,
        prefixIcon: Icons.add_rounded,
        onPressed: () => context.push(Routes.INVENTORY_ADD),
      ),
      SizedBox(width: 8.w),
      ReusableButton(
        text: AppStrings.importExcel,
        type: ButtonType.tonal,
        prefixIcon: Icons.file_upload_rounded,
        onPressed: () => context.push(Routes.INVENTORY_IMPORT),
      ),
      SizedBox(width: 8.w),
      ReusableButton(
        text: AppStrings.importExcelProducts,
        type: ButtonType.tonal,
        prefixIcon: Icons.inventory_2_rounded,
        onPressed: () => context.push(Routes.INVENTORY_IMPORT_PRODUCTS),
      ),
      SizedBox(width: 8.w),
      ReusableButton(
        text: AppStrings.deleteAllMedicines,
        type: ButtonType.outlined,
        color: AppColors.error,
        prefixIcon: Icons.delete_sweep_rounded,
        onPressed: () => _showDeleteAllDialog(context, state),
      ),
    ];
  }

  void _showDeleteAllDialog(BuildContext context, MedicinesState state) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: Icon(
          Icons.warning_rounded,
          color: Theme.of(context).colorScheme.error,
          size: AppIconSize.xl.value,
        ),
        title: ReusableText(
          AppStrings.confirmDeleteAllTitle,
          style: AppTextStyles.title(context),
        ),
        content: ReusableText(
          AppStrings.confirmDeleteAllMessage.replaceAll('%s', '${state.totalCount}'),
          style: AppTextStyles.body(context),
        ),
        actions: [
          TextButton(
            onPressed: () => ctx.pop(),
            child: ReusableText(AppStrings.cancel),
          ),
          FilledButton(
            onPressed: () {
              ctx.pop();
              context.read<MedicinesBloc>().add(const DeleteAllMedicines());
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: ReusableText(
              AppStrings.deleteAllMedicines,
              style: AppTextStyles.body(context).copyWith(
                color: Theme.of(context).colorScheme.onError,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildStats(BuildContext context, MedicinesState state) {
    return [
      SummaryCard(
        label: AppStrings.totalItems,
        value: '${state.totalCount}',
        icon: Icons.inventory_2_rounded,
      ),
      SummaryCard(
        label: AppStrings.lowStock,
        value: '${state.lowStockCount}',
        color: AppColors.warning,
        icon: Icons.warning_amber_rounded,
      ),
      SummaryCard(
        label: AppStrings.expired,
        value: '${state.expiredCount}',
        color: AppColors.error,
        icon: Icons.event_busy_rounded,
      ),
    ];
  }

  Widget _buildFilters(BuildContext context, MedicinesState state) {
    final bloc = context.read<MedicinesBloc>();
    final categories = [
      AppStrings.all,
      ...LookupService.getItemTypes().map((e) => e.name),
    ];

    return AppCard(
      padding: EdgeInsets.all(12.w),
      child: Row(
        children: [
          // حقل البحث الذكي بترميز الباركود والاسم
          Expanded(
            flex: 4,
            child: MedicineSearchField(
              hint: AppStrings.searchInventoryHint,
              clearOnSelect: false,
              onChanged: _onSearchChanged,
              onSelected: (m) => bloc.add(SearchMedicines(m.name)),
            ),
          ),
          SizedBox(width: 12.w),

          // القائمة المنسدلة للتصنيفات
          SizedBox(
            width: 180.w,
            child: ReusableDropdown<String>(
              items: categories,
              value: state.selectedCategory ?? AppStrings.all,
              hintText: AppStrings.displayCategory,
              itemAsString: (cat) => cat,
              onChanged: (v) => bloc.add(FilterByCategory(v == AppStrings.all ? null : v)),
            ),
          ),
          SizedBox(width: 12.w),

          // شرائح التصفية السريعة
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                _buildFilterChip(AppStrings.all, 'all', state.selectedFilter, bloc),
                SizedBox(width: 6.w),
                _buildFilterChip(AppStrings.lowStock, 'low_stock', state.selectedFilter, bloc),
                SizedBox(width: 6.w),
                _buildFilterChip(AppStrings.outOfStock, 'out_of_stock', state.selectedFilter, bloc),
                SizedBox(width: 6.w),
                _buildFilterChip(AppStrings.expiringSoon, 'expiring', state.selectedFilter, bloc),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    String label,
    String value,
    String selected,
    MedicinesBloc bloc,
  ) {
    final isSelected = selected == value;
    final scheme = Theme.of(context).colorScheme;
    return ChoiceChip(
      label: Text(label, style: TextStyle(fontSize: 12.sp, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? scheme.primary : scheme.onSurfaceVariant)),
      selected: isSelected,
      onSelected: (_) => bloc.add(FilterMedicines(value)),
      selectedColor: scheme.primary.withValues(alpha: 0.12),
      backgroundColor: scheme.surfaceContainerLowest,
      side: BorderSide(color: isSelected ? scheme.primary.withValues(alpha: 0.4) : scheme.outlineVariant.withValues(alpha: 0.2)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.button.r)),
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildTable(BuildContext context, MedicinesState state) {
    final bloc = context.read<MedicinesBloc>();
    final f = NumberFormat('#,##0.##');

    final columns = [
      ReusableTableColumn<MedicineModel>(
        id: 'name',
        title: AppStrings.name,
        flex: 4,
        isSortable: true,
        cellBuilder: (m) => Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Icons.medication_rounded,
                size: 18.sp,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ReusableText(
                    m.name,
                    style: AppTextStyles.bodyBold(context).copyWith(fontSize: 13.sp),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (m.dosageForm != null && m.dosageForm!.isNotEmpty)
                    Text(
                      m.dosageForm!,
                      style: AppTextStyles.caption(context).copyWith(
                        fontSize: 11.sp,
                        color: AppColors.textSecondaryOf(context),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      ReusableTableColumn<MedicineModel>(
        id: 'barcode',
        title: AppStrings.barcodeLabel,
        flex: 2,
        isSortable: true,
        cellBuilder: (m) {
          String? barcode;
          if (m.barcodes.isNotEmpty) {
            barcode = m.barcodes.first;
          } else if (m.units.isNotEmpty) {
            final unitWithBarcode = m.units.firstWhereOrNull(
              (u) => u.barcode != null && u.barcode!.isNotEmpty,
            );
            barcode = unitWithBarcode?.barcode;
          }

          return ReusableText(
            barcode ?? '—',
            style: AppTextStyles.caption(context).copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 12.sp,
            ),
          );
        },
      ),
      ReusableTableColumn<MedicineModel>(
        id: 'category',
        title: AppStrings.displayCategory,
        flex: 2,
        isSortable: true,
        textBuilder: (m) => m.category ?? '—',
      ),
      ReusableTableColumn<MedicineModel>(
        id: 'location',
        title: AppStrings.storageLocation,
        flex: 2,
        isSortable: true,
        cellBuilder: (m) => ReusableText(
          m.location ?? '—',
          style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.w500),
        ),
      ),
      ReusableTableColumn<MedicineModel>(
        id: 'quantity',
        title: AppStrings.quantity,
        flex: 2,
        isSortable: true,
        isNumeric: true,
        cellBuilder: (m) {
          final isOut = m.quantity <= 0;
          final isLow = m.quantity <= m.minStock;
          final color = isOut ? AppColors.error : (isLow ? AppColors.warning : AppColors.success);

          return Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: ReusableText(
              '${m.quantity}',
              style: AppTextStyles.bodyBold(context).copyWith(
                color: color,
                fontSize: 12.sp,
              ),
            ),
          );
        },
      ),
      ReusableTableColumn<MedicineModel>(
        id: 'sellPrice',
        title: AppStrings.sellPriceLabel,
        flex: 2,
        isSortable: true,
        isNumeric: true,
        textBuilder: (m) => '${f.format(m.sellPrice)} ${AppStrings.currency}',
      ),
      ReusableTableColumn<MedicineModel>(
        id: 'expiry',
        title: AppStrings.currentExpiryDate,
        flex: 2,
        isSortable: true,
        cellBuilder: (m) {
          if (m.expiryDate == null) return const ReusableText('—');
          final now = DateTime.now();
          final isExpired = m.expiryDate!.isBefore(now);
          final isExpiring = m.expiryDate!.isBefore(
            now.add(const Duration(days: 90)),
          );
          final color = isExpired ? AppColors.error : (isExpiring ? AppColors.warning : AppColors.success);

          return Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: ReusableText(
              DateFormat('yyyy/MM').format(m.expiryDate!),
              style: AppTextStyles.caption(context).copyWith(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 11.sp,
              ),
            ),
          );
        },
      ),
    ];

    if (state.allMedicines.isEmpty && !state.dataState.isLoading) {
      return const EmptyState(
        icon: Icons.medication_liquid_rounded,
        title: AppStrings.emptyInventoryTitle,
        subtitle: AppStrings.emptyInventorySubtitle,
      );
    }

    final scheme = Theme.of(context).colorScheme;

    return ReusableTable<MedicineModel>(
      columns: columns,
      items: state.pagedMedicines,
      isLoading: state.dataState.isLoading,
      currentPage: state.currentPage + 1,
      totalPages: state.totalPages,
      totalItems: state.filteredMedicines.length,
      pageSize: state.pageSize,
      pageSizeOptions: state.pageSizeOptions,
      onPageSizeChanged: (newSize) => bloc.add(ChangePageSize(newSize)),
      onNextPage: () => bloc.add(const NextPage()),
      onPreviousPage: () => bloc.add(const PreviousPage()),
      onFirstPage: () => bloc.add(const GoToPage(0)),
      onLastPage: () => bloc.add(GoToPage(state.totalPages - 1)),
      onGoToPage: (page) => bloc.add(GoToPage(page - 1)),
      onSort: (colId) => bloc.add(SortMedicines(colId)),
      sortColumnId: state.sortColumnId,
      isSortAscending: state.isSortAscending,
      itemLabel: AppStrings.itemLabel,
      showCheckbox: true,
      selectedIds: state.selectedIds,
      rowIdGetter: (m) => m.id,
      onSelectRow: (id) => bloc.add(ToggleSelectRow(id)),
      onToggleAll: (selectAll) => bloc.add(ToggleSelectAll(selectAll)),
      bulkActions: [
        ReusableButton(
          text: AppStrings.delete,
          type: ButtonType.outlined,
          color: AppColors.error,
          prefixIcon: Icons.delete_sweep_rounded,
          onPressed: () {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                icon: Icon(
                  Icons.warning_rounded,
                  color: Theme.of(context).colorScheme.error,
                  size: AppIconSize.xl.value,
                ),
                title: ReusableText(
                  AppStrings.confirmDeleteSelectedTitle,
                  style: AppTextStyles.title(context),
                ),
                content: ReusableText(
                  AppStrings.confirmDeleteSelectedMessage.replaceAll('%s', '${state.selectedIds.length}'),
                  style: AppTextStyles.body(context),
                ),
                actions: [
                  TextButton(
                    onPressed: () => ctx.pop(),
                    child: ReusableText(AppStrings.cancel),
                  ),
                  FilledButton(
                    onPressed: () {
                      ctx.pop();
                      bloc.add(const DeleteSelectedMedicines());
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                    child: ReusableText(
                      AppStrings.delete,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onError,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        ReusableButton(
          text: AppStrings.editPrice,
          type: ButtonType.outlined,
          prefixIcon: Icons.price_change_rounded,
          onPressed: () {},
        ),
      ],
      rowActions: (m) => PopupMenuButton<String>(
        offset: const Offset(0, 36),
        onSelected: (v) {
          switch (v) {
            case 'edit':
              context.push('/admin/inventory/edit/${m.id}');
              break;
            case 'delete':
              ConfirmDeleteDialog.show(
                context,
                title: AppStrings.confirmDeleteItemTitle,
                message: AppStrings.confirmDeleteItemMessage.replaceAll('%s', m.name),
                onConfirm: () => bloc.add(DeleteMedicine(m)),
              );
              break;
          }
        },
        itemBuilder: (_) => [
          const PopupMenuItem(value: 'edit', child: ReusableText(AppStrings.edit)),
          const PopupMenuItem(value: 'delete', child: ReusableText(AppStrings.delete, color: AppColors.error)),
        ],
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(AppRadius.button),
            border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.5)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ReusableText(
                AppStrings.options,
                style: AppTextStyles.caption(context).copyWith(
                  fontWeight: FontWeight.bold,
                  color: scheme.primary,
                ),
              ),
              SizedBox(width: 4.w),
              Icon(Icons.more_vert_rounded, size: 14.sp, color: scheme.primary),
            ],
          ),
        ),
      ),
    );
  }
}

