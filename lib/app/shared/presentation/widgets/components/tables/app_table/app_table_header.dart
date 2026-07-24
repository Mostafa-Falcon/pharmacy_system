import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_system/app/shared/ui_core.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/index.dart';

class ReusableTableHeader<T> extends StatelessWidget {
  final List<ReusableTableColumn<T>> columns;
  final String? sortColumnId;
  final bool isSortAscending;
  final ValueChanged<String>? onSort;
  final bool showCheckbox;
  final bool isAllSelected;
  final ValueChanged<bool>? onToggleAll;
  final AppTableDensity density;
  final double? customHeaderRowHeight;
  final Color? backgroundColor;
  final Color? borderColor;
  final bool hasActions;

  const ReusableTableHeader({
    super.key,
    required this.columns,
    this.sortColumnId,
    this.isSortAscending = true,
    this.onSort,
    this.showCheckbox = false,
    this.isAllSelected = false,
    this.onToggleAll,
    this.density = AppTableDensity.medium,
    this.customHeaderRowHeight,
    this.backgroundColor,
    this.borderColor,
    required this.hasActions,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final visibleColumns = columns.where((c) => c.isVisible).toList();
    final headerHeight = customHeaderRowHeight ?? density.headerHeight;

    return Container(
      height: headerHeight,
      decoration: BoxDecoration(
        color: backgroundColor ?? scheme.surfaceContainerHigh,
        border: Border(
          bottom: BorderSide(
            color: borderColor ?? scheme.outline.withValues(alpha: 0.35),
            width: 1.5,
          ),
          top: BorderSide(
            color: borderColor ?? scheme.outline.withValues(alpha: 0.1),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          if (showCheckbox)
            SizedBox(
              width: 56.w,
              child: Center(
                child: Transform.scale(
                  scale: 0.85,
                  child: Checkbox(
                    value: isAllSelected,
                    onChanged: (val) => onToggleAll?.call(val ?? false),
                    activeColor: scheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.input.r),
                    ),
                  ),
                ),
              ),
            ),
          if (hasActions) SizedBox(width: 100.w),
          for (final col in visibleColumns)
            col.flex > 0
                ? Expanded(
                    flex: col.flex,
                    child: _HeaderCell<T>(
                      column: col,
                      isSorted: sortColumnId == col.id,
                      isAscending: isSortAscending,
                      onSort: onSort,
                      density: density,
                    ),
                  )
                : _HeaderCell<T>(
                    column: col,
                    isSorted: sortColumnId == col.id,
                    isAscending: isSortAscending,
                    onSort: onSort,
                    density: density,
                  ),
        ],
      ),
    );
  }
}

class _HeaderCell<T> extends StatelessWidget {
  final ReusableTableColumn<T> column;
  final bool isSorted;
  final bool isAscending;
  final ValueChanged<String>? onSort;
  final AppTableDensity density;

  const _HeaderCell({
    required this.column,
    required this.isSorted,
    required this.isAscending,
    this.onSort,
    required this.density,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isSortable = column.isSortable;

    final child = SizedBox(
      width: column.flex > 0 ? null : (column.width ?? 160.w),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isSortable ? () => onSort?.call(column.id) : null,
          hoverColor: scheme.primary.withValues(alpha: 0.04),
          child: Container(
            alignment: Alignment.center,
            padding: column.cellPadding ?? density.cellPadding,
            child: Row(
              children: [
                // مساحة تعويضية في جهة اليمين (للحفاظ على توسط النص في RTL)
                SizedBox(width: (density.fontSize + 12).sp),
                
                Expanded(
                  child: ReusableText(
                    column.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: density.fontSize,
                      fontWeight: FontWeight.bold,
                      color: isSorted
                          ? scheme.primary
                          : scheme.onSurfaceVariant.withValues(alpha: 0.9),
                      letterSpacing: 0.2,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // أيقونة الترتيب في جهة اليسار (الشمال)
                SizedBox(
                  width: (density.fontSize + 12).sp,
                  child: isSortable 
                      ? Center(
                          child: AnimatedRotation(
                            turns: isSorted ? (isAscending ? 0 : 0.5) : 0,
                            duration: const Duration(milliseconds: 200),
                            child: Icon(
                              isSorted
                                  ? Icons.arrow_upward_rounded
                                  : Icons.unfold_more_rounded,
                              size: (density.fontSize + 2).sp,
                              color: isSorted
                                  ? scheme.primary
                                  : scheme.onSurfaceVariant.withValues(alpha: 0.4),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (column.tooltip != null && column.tooltip!.isNotEmpty) {
      return Tooltip(message: column.tooltip!, child: child);
    }
    return child;
  }
}



