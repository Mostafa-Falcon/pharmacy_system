import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_system/app/shared/ui_core.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/index.dart';

/// جدول البيانات الذكي التفاعلي عالي الأداء والجماليات [ReusableTable].
/// مصمم هندسياً للتعامل مع البيانات الضخمة بدون أي لغبطة أو تهنيج (Zero Lag).
class AppTable<T> extends StatefulWidget {
  final List<AppTableColumn<T>> columns;
  final List<T> items;

  // ─── السورت والفرز ───
  final String? sortColumnId;
  final bool isSortAscending;
  final ValueChanged<String>? onSort;

  // ─── التحديد الجماعي ───
  final bool showCheckbox;
  final Set<String> selectedIds;
  final ValueChanged<String>? onSelectRow;
  final ValueChanged<bool>? onToggleAll;
  final String Function(T item)? rowIdGetter;

  // ─── التفاعلات والإجراءات ───
  final ValueChanged<T>? onTapRow;
  final ValueChanged<T>? onLongPressRow;
  final Widget Function(T item)? rowActions;
  final List<Widget>? bulkActions;

  // ─── شريط الأدوات والبحث والفلترة ───
  final bool showToolbar;
  final bool showSearch;
  final bool showColumnPicker;
  final bool showDensitySelector;
  final bool showExport;
  final Widget? toolbarLeading;
  final Widget? toolbarTrailing;
  final VoidCallback? onExportCsv;
  final VoidCallback? onExportExcel;
  final VoidCallback? onPrint;
  final ValueChanged<String>? onSearchChanged;

  // ─── الكثافة والتعديلات البصرية ───
  final AppTableDensity initialDensity;
  final double? headerRowHeight;
  final double? bodyRowHeight;
  final Color? headerBackgroundColor;
  final Color? borderColor;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? padding;
  final Widget? headerTrailing;
  final Widget Function(BuildContext context, int index)? rowBuilder;
  final Widget Function(
    BuildContext context,
    T item,
    AppTableColumn<T> column,
  )? cellOverrideBuilder;

  // ─── التقسيم والفوتر ───
  final bool showPagination;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int pageSize;
  final List<int> pageSizeOptions;
  final ValueChanged<int>? onPageSizeChanged;
  final VoidCallback? onNextPage;
  final VoidCallback? onPreviousPage;
  final VoidCallback? onFirstPage;
  final VoidCallback? onLastPage;
  final ValueChanged<int>? onGoToPage;
  final String? itemLabel;
  final bool showGoToPage;
  final Widget? tableFooter;
  final Widget? summaryRow;

  // ─── الحالات والتحميل ───
  final bool isLoading;
  final int shimmerRows;
  final Widget? emptyState;

  const AppTable({
    super.key,
    required this.columns,
    required this.items,
    this.sortColumnId,
    this.isSortAscending = true,
    this.onSort,
    this.showCheckbox = false,
    this.selectedIds = const {},
    this.onSelectRow,
    this.onToggleAll,
    this.rowIdGetter,
    this.onTapRow,
    this.onLongPressRow,
    this.bulkActions,
    this.rowActions,
    this.showToolbar = false,
    this.showSearch = true,
    this.showColumnPicker = true,
    this.showDensitySelector = true,
    this.showExport = true,
    this.toolbarLeading,
    this.toolbarTrailing,
    this.onExportCsv,
    this.onExportExcel,
    this.onPrint,
    this.onSearchChanged,
    this.initialDensity = AppTableDensity.medium,
    this.headerRowHeight,
    this.bodyRowHeight,
    this.headerBackgroundColor,
    this.borderColor,
    this.borderRadius,
    this.padding,
    this.headerTrailing,
    this.rowBuilder,
    this.cellOverrideBuilder,
    this.tableFooter,
    this.summaryRow,
    this.showPagination = true,
    this.currentPage = 1,
    this.totalPages = 1,
    this.totalItems = 0,
    this.pageSize = 25,
    this.pageSizeOptions = const [10, 25, 50, 100, 250, 500, 1000],
    this.onPageSizeChanged,
    this.onNextPage,
    this.onPreviousPage,
    this.onFirstPage,
    this.onLastPage,
    this.onGoToPage,
    this.itemLabel,
    this.showGoToPage = true,
    this.isLoading = false,
    this.shimmerRows = 5,
    this.emptyState,
  });

  @override
  State<AppTable<T>> createState() => _AppTableState<T>();
}

class _AppTableState<T> extends State<AppTable<T>> {
  final ScrollController _horizontalController = ScrollController();
  final ScrollController _verticalController = ScrollController();

  late Set<String> _visibleColumnIds;
  late AppTableDensity _currentDensity;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _visibleColumnIds = widget.columns.where((c) => c.isVisible).map((c) => c.id).toSet();
    _currentDensity = widget.initialDensity;
  }

  @override
  void didUpdateWidget(covariant ReusableTable<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.columns != oldWidget.columns) {
      _visibleColumnIds = widget.columns.where((c) => c.isVisible).map((c) => c.id).toSet();
    }
  }

  @override
  void dispose() {
    _horizontalController.dispose();
    _verticalController.dispose();
    super.dispose();
  }

  List<T> get _processedItems {
    if (_searchQuery.trim().isEmpty) {
      return widget.items;
    }

    final query = _searchQuery.trim().toLowerCase();
    final searchableColumns = widget.columns.where((c) => c.isSearchable && _visibleColumnIds.contains(c.id)).toList();

    return widget.items.where((item) {
      for (final col in searchableColumns) {
        String val = '';
        if (col.searchValueGetter != null) {
          val = col.searchValueGetter!(item);
        } else if (col.textBuilder != null) {
          val = col.textBuilder!(item);
        }
        if (val.toLowerCase().contains(query)) {
          return true;
        }
      }
      return false;
    }).toList();
  }

  void _toggleColumnVisibility(String colId) {
    setState(() {
      if (_visibleColumnIds.contains(colId)) {
        if (_visibleColumnIds.length > 1) {
          _visibleColumnIds.remove(colId);
        }
      } else {
        _visibleColumnIds.add(colId);
      }
    });
  }

  void _resetColumnsVisibility() {
    setState(() {
      _visibleColumnIds = widget.columns.map((c) => c.id).toSet();
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final radius = widget.borderRadius ?? BorderRadius.circular(AppRadius.card.r);
    final borderCol = widget.borderColor ?? scheme.outline.withValues(alpha: 0.3);

    final updatedColumns = widget.columns.map((col) {
      return col.copyWith(isVisible: _visibleColumnIds.contains(col.id));
    }).toList();

    final displayedItems = _processedItems;
    final isAllSelected = displayedItems.isNotEmpty &&
        widget.rowIdGetter != null &&
        widget.selectedIds.length == displayedItems.length;

    return Container(
      margin: widget.padding ?? EdgeInsets.zero,
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: radius,
        border: Border.all(color: borderCol, width: 1),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Toolbar (Search, Column Picker, Density, Export)
            if (widget.showToolbar)
              AppTableToolbar<T>(
                searchQuery: _searchQuery,
                onSearchChanged: (val) {
                  setState(() => _searchQuery = val);
                  widget.onSearchChanged?.call(val);
                },
                allColumns: widget.columns,
                visibleColumnIds: _visibleColumnIds,
                onToggleColumnVisibility: _toggleColumnVisibility,
                onResetColumnsVisibility: _resetColumnsVisibility,
                density: _currentDensity,
                onDensityChanged: (d) => setState(() => _currentDensity = d),
                onExportCsv: widget.onExportCsv,
                onExportExcel: widget.onExportExcel,
                onPrint: widget.onPrint,
                leading: widget.toolbarLeading,
                trailing: widget.toolbarTrailing,
                showSearch: widget.showSearch,
                showColumnPicker: widget.showColumnPicker,
                showDensitySelector: widget.showDensitySelector,
                showExport: widget.showExport,
              ),

            // Virtualized Table Header + Body Viewport
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double totalTableWidth = widget.showCheckbox ? 56.w : 0;
                  for (final col in updatedColumns.where((c) => c.isVisible)) {
                    totalTableWidth += col.width ?? 160.w;
                  }
                  if (widget.rowActions != null) totalTableWidth += 100.w;

                  final double finalTableWidth = totalTableWidth > constraints.maxWidth
                      ? totalTableWidth
                      : constraints.maxWidth;

                  return Scrollbar(
                    controller: _horizontalController,
                    interactive: true,
                    child: SingleChildScrollView(
                      controller: _horizontalController,
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: SizedBox(
                        width: finalTableWidth,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Sticky Table Header
                            Stack(
                              children: [
                                AppTableHeader<T>(
                                  columns: updatedColumns,
                                  sortColumnId: widget.sortColumnId,
                                  isSortAscending: widget.isSortAscending,
                                  onSort: widget.onSort,
                                  showCheckbox: widget.showCheckbox,
                                  isAllSelected: isAllSelected,
                                  onToggleAll: widget.onToggleAll,
                                  density: _currentDensity,
                                  customHeaderRowHeight: widget.headerRowHeight,
                                  backgroundColor: widget.headerBackgroundColor ??
                                      scheme.surfaceContainerLow.withValues(alpha: 0.6),
                                  borderColor: borderCol,
                                  hasActions: widget.rowActions != null,
                                ),
                                if (widget.headerTrailing != null)
                                  PositionedDirectional(
                                    end: 16.w,
                                    top: 0,
                                    bottom: 0,
                                    child: Center(child: widget.headerTrailing),
                                  ),
                              ],
                            ),

                            // Virtualized Lazy Table Body
                            Expanded(
                              child: AppTableBody<T>(
                                items: displayedItems,
                                columns: updatedColumns,
                                showCheckbox: widget.showCheckbox,
                                selectedIds: widget.selectedIds,
                                onSelectRow: widget.onSelectRow,
                                onTapRow: widget.onTapRow,
                                onLongPressRow: widget.onLongPressRow,
                                rowActions: widget.rowActions,
                                emptyState: widget.emptyState,
                                isLoading: widget.isLoading,
                                shimmerRows: widget.shimmerRows,
                                density: _currentDensity,
                                customBodyRowHeight: widget.bodyRowHeight,
                                borderColor: borderCol,
                                rowIdGetter: widget.rowIdGetter,
                                rowBuilder: widget.rowBuilder,
                                cellOverrideBuilder: widget.cellOverrideBuilder,
                                verticalScrollController: _verticalController,
                              ),
                            ),

                            // Summary / Totals Row (If specified)
                            if (widget.summaryRow != null)
                              Container(
                                width: finalTableWidth,
                                decoration: BoxDecoration(
                                  color: scheme.surface,
                                  border: Border(
                                    top: BorderSide(color: borderCol, width: 2),
                                  ),
                                ),
                                child: widget.summaryRow!,
                              ),
                            
                            if (widget.tableFooter != null) widget.tableFooter!,
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Bulk Actions Bar
            if (widget.bulkActions != null && widget.selectedIds.isNotEmpty)
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: scheme.surface,
                  border: Border(
                    top: BorderSide(
                      color: scheme.outlineVariant.withValues(alpha: 0.5),
                      width: 1,
                    ),
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      color: scheme.primary,
                      size: AppIconSize.md.value,
                    ),
                    SizedBox(width: 10.w),
                    AppText(
                      WidgetStrings.paginationSelectedFormat
                          .replaceFirst('%s', '${widget.selectedIds.length}')
                          .replaceFirst('%s', widget.itemLabel ?? ''),
                      style: AppTextStyles.body(context).copyWith(
                        fontWeight: FontWeight.bold,
                        color: scheme.onSurface,
                      ),
                    ),
                    const Spacer(),
                    Wrap(
                      spacing: 8.w,
                      children: widget.bulkActions!,
                    ),
                    SizedBox(width: 8.w),
                    IconButton(
                      icon: Icon(
                        Icons.close_rounded,
                        size: AppIconSize.md.value,
                        color: scheme.onSurfaceVariant,
                      ),
                      onPressed: () => widget.onToggleAll?.call(false),
                      tooltip: WidgetStrings.paginationDeselect,
                    ),
                  ],
                ),
              ),

            // Footer / Pagination Controls
            if (widget.showPagination)
              AppTableFooter(
                totalItems: widget.totalItems > 0 ? widget.totalItems : displayedItems.length,
                currentPage: widget.currentPage,
                totalPages: widget.totalPages,
                pageSize: widget.pageSize,
                pageSizeOptions: widget.pageSizeOptions,
                onPageSizeChanged: widget.onPageSizeChanged,
                onNextPage: widget.onNextPage,
                onPreviousPage: widget.onPreviousPage,
                onFirstPage: widget.onFirstPage,
                onLastPage: widget.onLastPage,
                onGoToPage: widget.onGoToPage,
                itemLabel: widget.itemLabel,
                showGoToPage: widget.showGoToPage,
                backgroundColor: scheme.surface,
              ),
          ],
        ),
      ),
    );
  }
}




