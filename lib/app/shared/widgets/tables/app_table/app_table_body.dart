import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_system/app/shared/ui_core.dart';

/// مكون جسم الجدول التفاعلي عالي الأداء والافتراضية الفائقة (Virtualized High-Performance Body).
/// يقوم بإنشاء الصفوف الظاهرة للعين فقط بدون تخصيص ذاكرة إضافية أو حدوث Lag في الشاشة.
class AppTableBody<T> extends StatelessWidget {
  final List<T> items;
  final List<AppTableColumn<T>> columns;
  final bool showCheckbox;
  final Set<String> selectedIds;
  final ValueChanged<String>? onSelectRow;
  final ValueChanged<T>? onTapRow;
  final ValueChanged<T>? onLongPressRow;
  final Widget Function(T item)? rowActions;
  final Widget? emptyState;
  final bool isLoading;
  final int shimmerRows;
  final AppTableDensity density;
  final double? customBodyRowHeight;
  final Color? borderColor;
  final String Function(T item)? rowIdGetter;
  final Widget Function(BuildContext context, int index)? rowBuilder;
  final Widget Function(
    BuildContext context,
    T item,
    AppTableColumn<T> column,
  )? cellOverrideBuilder;
  final ScrollController? verticalScrollController;

  const AppTableBody({
    super.key,
    required this.items,
    required this.columns,
    this.showCheckbox = false,
    this.selectedIds = const {},
    this.onSelectRow,
    this.onTapRow,
    this.onLongPressRow,
    this.rowActions,
    this.emptyState,
    this.isLoading = false,
    this.shimmerRows = 5,
    this.density = AppTableDensity.medium,
    this.customBodyRowHeight,
    this.borderColor,
    this.rowIdGetter,
    this.rowBuilder,
    this.cellOverrideBuilder,
    this.verticalScrollController,
  });

  @override
  Widget build(BuildContext context) {
    final rowHeight = customBodyRowHeight ?? density.rowHeight;

    if (isLoading) {
      return _ShimmerBody<T>(
        columns: columns,
        rowCount: shimmerRows,
        showCheckbox: showCheckbox,
        rowHeight: rowHeight,
        hasActions: rowActions != null,
        density: density,
      );
    }

    if (items.isEmpty) {
      return emptyState ?? const _DefaultEmptyState();
    }

    final borderCol = borderColor ?? Theme.of(context).colorScheme.outline.withValues(alpha: 0.2);
    final visibleColumns = columns.where((c) => c.isVisible).toList();

    // Virtualized ListView.builder - Only builds items visible inside the viewport
    return ListView.builder(
      controller: verticalScrollController,
      physics: const BouncingScrollPhysics(),
      itemExtent: rowHeight, // Fixed height optimization for hyper-fast scrolling
      itemCount: items.length,
      itemBuilder: (context, i) {
        final item = items[i];
        final idKey = rowIdGetter != null ? rowIdGetter!(item) : i.toString();

        if (rowBuilder != null) {
          return KeyedSubtree(
            key: ValueKey(idKey),
            child: RepaintBoundary(child: rowBuilder!(context, i)),
          );
        }

        final isSelected = rowIdGetter != null && selectedIds.contains(rowIdGetter!(item));

        return KeyedSubtree(
          key: ValueKey(idKey),
          child: RepaintBoundary(
            child: _TableRow<T>(
              item: item,
              columns: visibleColumns,
              index: i,
              showCheckbox: showCheckbox,
              isSelected: isSelected,
              onSelect: onSelectRow != null && rowIdGetter != null ? () => onSelectRow!(rowIdGetter!(item)) : null,
              onTap: onTapRow != null ? () => onTapRow!(item) : null,
              onLongPress: onLongPressRow != null ? () => onLongPressRow!(item) : null,
              rowActions: rowActions,
              isLast: i == items.length - 1,
              borderColor: borderCol,
              rowHeight: rowHeight,
              density: density,
              cellOverrideBuilder: cellOverrideBuilder,
            ),
          ),
        );
      },
    );
  }
}

class _TableRow<T> extends StatelessWidget {
  final T item;
  final List<AppTableColumn<T>> columns;
  final int index;
  final bool showCheckbox;
  final bool isSelected;
  final VoidCallback? onSelect;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Widget Function(T item)? rowActions;
  final bool isLast;
  final Color borderColor;
  final double rowHeight;
  final AppTableDensity density;
  final Widget Function(
    BuildContext context,
    T item,
    AppTableColumn<T> column,
  )? cellOverrideBuilder;

  const _TableRow({
    required this.item,
    required this.columns,
    required this.index,
    required this.showCheckbox,
    required this.isSelected,
    this.onSelect,
    this.onTap,
    this.onLongPress,
    this.rowActions,
    required this.isLast,
    required this.borderColor,
    required this.rowHeight,
    required this.density,
    this.cellOverrideBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isEven = index % 2 == 0;

    final bgColor = isSelected
        ? scheme.primary.withValues(alpha: 0.08)
        : isEven
            ? scheme.surface
            : scheme.surfaceContainerLowest.withValues(alpha: 0.4);

    return Container(
      height: rowHeight,
      color: bgColor,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          hoverColor: scheme.primary.withValues(alpha: 0.04),
          splashColor: scheme.primary.withValues(alpha: 0.08),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: borderColor, width: isLast ? 0 : 0.8),
                left: isSelected ? BorderSide(color: scheme.primary, width: 3.w) : BorderSide.none,
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
                          value: isSelected,
                          onChanged: (_) => onSelect?.call(),
                          activeColor: scheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.input.r),
                          ),
                        ),
                      ),
                    ),
                  ),
                if (rowActions != null)
                  SizedBox(
                    width: 100.w,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: rowActions!(item),
                      ),
                    ),
                  ),
                for (final col in columns)
                  col.flex > 0
                      ? Expanded(
                          flex: col.flex,
                          child: _BodyCell<T>(
                            item: item,
                            column: col,
                            density: density,
                            overrideBuilder: cellOverrideBuilder,
                          ),
                        )
                      : _BodyCell<T>(
                          item: item,
                          column: col,
                          density: density,
                          overrideBuilder: cellOverrideBuilder,
                        ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BodyCell<T> extends StatelessWidget {
  final T item;
  final AppTableColumn<T> column;
  final AppTableDensity density;
  final Widget Function(
    BuildContext context,
    T item,
    AppTableColumn<T> column,
  )? overrideBuilder;

  const _BodyCell({
    required this.item,
    required this.column,
    required this.density,
    this.overrideBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (overrideBuilder != null) {
      return overrideBuilder!(context, item, column);
    }

    final scheme = Theme.of(context).colorScheme;

    final cellContent = column.cellBuilder != null
        ? column.cellBuilder!(item)
        : column.textBuilder != null
            ? ReusableText(
                column.textBuilder!(item),
                style: AppTextStyles.body(context).copyWith(
                  fontWeight: FontWeight.w500,
                  color: scheme.onSurface,
                  fontSize: density.fontSize,
                ),
                textAlign: column.alignment != null
                    ? null
                    : (column.isNumeric ? TextAlign.left : TextAlign.right),
                overflow: TextOverflow.ellipsis,
              )
            : column.emptyCellWidget ??
                ReusableText(
                  '—',
                  style: AppTextStyles.caption(context).copyWith(
                    color: scheme.onSurfaceVariant.withValues(alpha: 0.4),
                  ),
                  textAlign: TextAlign.center,
                );

    return SizedBox(
      width: column.flex > 0 ? null : (column.width ?? 160.w),
      child: Align(
        alignment: column.alignment ??
            (column.isNumeric ? Alignment.centerLeft : Alignment.centerRight),
        child: Padding(
          padding: column.cellPadding ?? density.cellPadding,
          child: cellContent,
        ),
      ),
    );
  }
}

class _ShimmerBody<T> extends StatefulWidget {
  final List<AppTableColumn<T>> columns;
  final int rowCount;
  final bool showCheckbox;
  final double rowHeight;
  final bool hasActions;
  final AppTableDensity density;

  const _ShimmerBody({
    required this.columns,
    required this.rowCount,
    required this.showCheckbox,
    required this.rowHeight,
    required this.hasActions,
    required this.density,
  });

  @override
  State<_ShimmerBody<T>> createState() => _ShimmerBodyState<T>();
}

class _ShimmerBodyState<T> extends State<_ShimmerBody<T>>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final visibleColumns = widget.columns.where((c) => c.isVisible).toList();

    return Column(
      children: List.generate(widget.rowCount, (rowIndex) {
        return Container(
          height: widget.rowHeight,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: scheme.outline.withValues(alpha: 0.15),
                width: 0.8,
              ),
            ),
          ),
          child: Row(
            children: [
              if (widget.showCheckbox)
                SizedBox(
                  width: 56.w,
                  child: Center(
                    child: _ShimmerBox(
                      animation: _controller,
                      width: 18,
                      height: 18,
                    ),
                  ),
                ),
              if (widget.hasActions) SizedBox(width: 100.w),
              for (final column in visibleColumns)
                column.flex > 0
                    ? Expanded(
                        flex: column.flex,
                        child: _ShimmerCell(
                          animation: _controller,
                          column: column,
                          rowIndex: rowIndex,
                          density: widget.density,
                        ),
                      )
                    : _ShimmerCell(
                        animation: _controller,
                        column: column,
                        rowIndex: rowIndex,
                        density: widget.density,
                      ),
            ],
          ),
        );
      }),
    );
  }
}

class _ShimmerCell<T> extends StatelessWidget {
  final Animation<double> animation;
  final AppTableColumn<T> column;
  final int rowIndex;
  final AppTableDensity density;

  const _ShimmerCell({
    required this.animation,
    required this.column,
    required this.rowIndex,
    required this.density,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: column.flex > 0 ? null : (column.width ?? 160.w),
      child: Align(
        alignment: column.alignment ?? Alignment.centerRight,
        child: Padding(
          padding: column.cellPadding ?? density.cellPadding,
          child: _ShimmerBox(
            animation: animation,
            width: column.width != null
                ? (column.width! * 0.5)
                : (80 + (rowIndex * 20) % 60).toDouble(),
            height: 12,
          ),
        ),
      ),
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  final Animation<double> animation;
  final double width;
  final double height;
  const _ShimmerBox({
    required this.animation,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Container(
          width: width.w,
          height: height.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.input.r),
            gradient: LinearGradient(
              colors: [
                scheme.outline.withValues(alpha: 0.1),
                scheme.outline.withValues(alpha: 0.25),
                scheme.outline.withValues(alpha: 0.1),
              ],
              stops: [
                (animation.value - 0.2).clamp(0.0, 1.0),
                animation.value,
                (animation.value + 0.2).clamp(0.0, 1.0),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DefaultEmptyState extends StatelessWidget {
  const _DefaultEmptyState();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 48.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerLowest,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.inbox_rounded,
                size: AppIconSize.xl.value,
                color: scheme.onSurfaceVariant.withValues(alpha: 0.4),
              ),
            ),
            SizedBox(height: 16.h),
            ReusableText(
              WidgetStrings.paginationNoData,
              style: AppTextStyles.body(context).copyWith(
                fontWeight: FontWeight.w600,
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}




