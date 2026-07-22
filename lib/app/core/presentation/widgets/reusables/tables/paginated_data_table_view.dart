import 'package:flutter/material.dart';

import 'package:pharmacy_system/app/core/presentation/widgets/index.dart';
import 'package:pharmacy_system/app/core/constants/app_strings.dart';

/// مكوّن ديناميكي لعرض أي قائمة بيانات في جدول [ReusableTable] جاهز:
/// فرز / تحديد جماعي / إجراءات صفوف / تقسيم صفحات / حالات (فارغ/تحميل/خطأ).
class PaginatedDataTableView<T> extends StatelessWidget {
  /// كل عناصر الصفحة الحالية (مصفّحة مسبقًا من الـ caller).
  final List<T> items;

  /// كل العناصر (لحساب التقسيم) — إن كانت الصفحات تُدار خارجيًا.
  final List<T>? allItems;

  final List<ReusableTableColumn<T>> columns;
  final String Function(T item) rowIdGetter;

  final ValueChanged<T>? onTapRow;
  final Widget Function(T item)? rowActions;
  final List<Widget>? bulkActions;

  final String emptyTitle;
  final String emptyMessage;

  /// تسمية العنصر لأزرار التقسيم.
  final String itemLabel;

  // ─── السورت (اختياري) ───
  final String? sortColumnId;
  final bool isSortAscending;
  final ValueChanged<String>? onSort;

  // ─── التحديد الجماعي (اختياري) ───
  final Set<String> selectedIds;
  final ValueChanged<String>? onSelectRow;
  final ValueChanged<bool>? onToggleAll;

  // ─── شريط الأدوات ───
  final bool showToolbar;
  final bool showSearch;
  final bool showColumnPicker;
  final bool showDensitySelector;
  final bool showExport;
  final VoidCallback? onExportCsv;
  final VoidCallback? onExportExcel;
  final VoidCallback? onPrint;
  final ValueChanged<String>? onSearchChanged;

  // ─── التقسيم (اختياري) ───
  final bool showPagination;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int pageSize;
  final List<int> pageSizeOptions;
  final ValueChanged<int>? onPageSizeChanged;
  final VoidCallback? onNextPage;
  final VoidCallback? onPreviousPage;
  final ValueChanged<int>? onGoToPage;

  // ─── الحالات ───
  final bool isLoading;
  final bool isFailure;
  final String? errorMessage;
  final VoidCallback? onRetry;

  final Widget? header;

  /// فوتر مخصص أسفل الجدول (مثل صف المجاميع).
  final Widget? tableFooter;
  final Widget? summaryRow;

  const PaginatedDataTableView({
    super.key,
    required this.items,
    this.allItems,
    required this.columns,
    required this.rowIdGetter,
    required this.emptyTitle,
    required this.emptyMessage,
    required this.itemLabel,
    this.onTapRow,
    this.rowActions,
    this.bulkActions,
    this.sortColumnId,
    this.isSortAscending = true,
    this.onSort,
    this.selectedIds = const {},
    this.onSelectRow,
    this.onToggleAll,
    this.showToolbar = false,
    this.showSearch = true,
    this.showColumnPicker = true,
    this.showDensitySelector = true,
    this.showExport = true,
    this.onExportCsv,
    this.onExportExcel,
    this.onPrint,
    this.onSearchChanged,
    this.showPagination = true,
    this.currentPage = 0,
    this.totalPages = 1,
    this.totalItems = 0,
    this.pageSize = 25,
    this.pageSizeOptions = const [10, 25, 50, 100, 250, 500, 1000],
    this.onPageSizeChanged,
    this.onNextPage,
    this.onPreviousPage,
    this.onGoToPage,
    this.isLoading = false,
    this.isFailure = false,
    this.errorMessage,
    this.onRetry,
    this.header,
    this.tableFooter,
    this.summaryRow,
  });

  @override
  Widget build(BuildContext context) {
    final data = items;

    // ─── التحميل الأولي ───
    if (isLoading && data.isEmpty) {
      return const Center(child: LoadingIndicator());
    }

    // ─── الخطأ ───
    if (isFailure && data.isEmpty) {
      return ReusableStateView(
        icon: Icons.error_outline_rounded,
        title: AppStrings.tableError,
        message: errorMessage ?? AppStrings.tableLoadError,
        action: onRetry != null
            ? ReusableButton(text: AppStrings.refresh, onPressed: onRetry!)
            : null,
      );
    }

    // ─── فارغ ───
    if (data.isEmpty && !isLoading) {
      return ReusableStateView.empty(title: emptyTitle, message: emptyMessage);
    }

    // ─── الجدول ───
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (header != null) header!,
        Expanded(
          child: ReusableTable<T>(
            columns: columns,
            items: data,
            sortColumnId: sortColumnId,
            isSortAscending: isSortAscending,
            onSort: onSort,
            showCheckbox: onSelectRow != null,
            selectedIds: selectedIds,
            onSelectRow: onSelectRow,
            onToggleAll: onToggleAll,
            rowIdGetter: rowIdGetter,
            onTapRow: onTapRow,
            rowActions: rowActions,
            bulkActions: bulkActions,
            showToolbar: showToolbar,
            showSearch: showSearch,
            showColumnPicker: showColumnPicker,
            showDensitySelector: showDensitySelector,
            showExport: showExport,
            onExportCsv: onExportCsv,
            onExportExcel: onExportExcel,
            onPrint: onPrint,
            onSearchChanged: onSearchChanged,
            itemLabel: itemLabel,
            showPagination: showPagination,
            currentPage: currentPage + 1,
            totalPages: totalPages,
            totalItems: totalItems,
            pageSize: pageSize,
            pageSizeOptions: pageSizeOptions,
            onPageSizeChanged: onPageSizeChanged,
            onNextPage: onNextPage,
            onPreviousPage: onPreviousPage,
            onGoToPage: onGoToPage,
            onFirstPage: onGoToPage != null ? () => onGoToPage!(0) : null,
            onLastPage: (onGoToPage != null && totalPages > 0)
                ? () => onGoToPage!(totalPages - 1)
                : null,
            isLoading: isLoading,
            tableFooter: tableFooter,
            summaryRow: summaryRow,
          ),
        ),
      ],
    );
  }
}
