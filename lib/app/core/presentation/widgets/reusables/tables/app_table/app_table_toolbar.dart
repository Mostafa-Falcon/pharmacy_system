import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_system/app/core/constants/app_strings.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_sizes.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/index.dart';

/// شريط أدوات الجدول الذكي المتقدم (Toolbar)
/// يحتوي على: البحث اللحظي، تخصيص الأعمدة الظاهرة، التحكم في الكثافة، وأزرار التصدير والطباعة.
class AppTableToolbar<T> extends StatelessWidget {
  final String searchQuery;
  final ValueChanged<String>? onSearchChanged;
  final List<ReusableTableColumn<T>> allColumns;
  final Set<String> visibleColumnIds;
  final ValueChanged<String>? onToggleColumnVisibility;
  final VoidCallback? onResetColumnsVisibility;
  final AppTableDensity density;
  final ValueChanged<AppTableDensity>? onDensityChanged;
  final VoidCallback? onExportCsv;
  final VoidCallback? onExportExcel;
  final VoidCallback? onPrint;
  final Widget? leading;
  final Widget? trailing;
  final bool showSearch;
  final bool showColumnPicker;
  final bool showDensitySelector;
  final bool showExport;

  const AppTableToolbar({
    super.key,
    this.searchQuery = '',
    this.onSearchChanged,
    required this.allColumns,
    required this.visibleColumnIds,
    this.onToggleColumnVisibility,
    this.onResetColumnsVisibility,
    this.density = AppTableDensity.medium,
    this.onDensityChanged,
    this.onExportCsv,
    this.onExportExcel,
    this.onPrint,
    this.leading,
    this.trailing,
    this.showSearch = true,
    this.showColumnPicker = true,
    this.showDensitySelector = true,
    this.showExport = true,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border(
          bottom: BorderSide(
            color: scheme.outlineVariant.withValues(alpha: 0.4),
            width: 1,
          ),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 600;

          if (isCompact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ?leading,
                if (leading != null) SizedBox(height: 8.h),
                if (showSearch && onSearchChanged != null)
                  _buildSearchField(context, scheme),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    const Spacer(),
                    if (showColumnPicker) _buildColumnPicker(context, scheme),
                    if (showDensitySelector) _buildDensityMenu(context, scheme),
                    if (showExport) _buildExportMenu(context, scheme),
                    ?trailing,
                  ],
                ),
              ],
            );
          }

          return Row(
            children: [
              ?leading,
              if (leading != null) SizedBox(width: 12.w),
              if (showSearch && onSearchChanged != null)
                Expanded(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 320.w),
                    child: _buildSearchField(context, scheme),
                  ),
                ),
              const Spacer(),
              if (showColumnPicker) ...[
                _buildColumnPicker(context, scheme),
                SizedBox(width: 8.w),
              ],
              if (showDensitySelector) ...[
                _buildDensityMenu(context, scheme),
                SizedBox(width: 8.w),
              ],
              if (showExport) ...[
                _buildExportMenu(context, scheme),
                SizedBox(width: 8.w),
              ],
              ?trailing,
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchField(BuildContext context, ColorScheme scheme) {
    return SizedBox(
      height: 38.h,
      child: TextField(
        controller: TextEditingController(text: searchQuery)
          ..selection = TextSelection.fromPosition(
            TextPosition(offset: searchQuery.length),
          ),
        onChanged: onSearchChanged,
        style: AppTextStyles.body(context).copyWith(fontSize: 12.sp),
        decoration: InputDecoration(
          hintText: AppStrings.tableSearchHint,
          hintStyle: AppTextStyles.caption(context).copyWith(
            color: scheme.onSurfaceVariant.withValues(alpha: 0.6),
            fontSize: 12.sp,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            size: AppIconSize.md.value,
            color: scheme.primary,
          ),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.cancel_rounded,
                    size: AppIconSize.sm.value,
                    color: scheme.onSurfaceVariant,
                  ),
                  onPressed: () => onSearchChanged?.call(''),
                )
              : null,
          contentPadding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
          isDense: true,
          filled: true,
          fillColor: scheme.surfaceContainerLowest,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.input.r),
            borderSide: BorderSide(color: scheme.outline.withValues(alpha: 0.3)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.input.r),
            borderSide: BorderSide(color: scheme.outline.withValues(alpha: 0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.input.r),
            borderSide: BorderSide(color: scheme.primary, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildColumnPicker(BuildContext context, ColorScheme scheme) {
    final hiddenCount = allColumns.length - visibleColumnIds.length;

    return MenuAnchor(
      builder: (context, controller, child) {
        return Tooltip(
          message: AppStrings.tableColumnsVisibility,
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              side: BorderSide(color: scheme.outline.withValues(alpha: 0.3)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.button.r),
              ),
            ),
            onPressed: () {
              if (controller.isOpen) {
                controller.close();
              } else {
                controller.open();
              }
            },
            icon: Icon(
              Icons.view_column_rounded,
              size: AppIconSize.md.value,
              color: hiddenCount > 0 ? scheme.primary : scheme.onSurfaceVariant,
            ),
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ReusableText(
                  AppStrings.viewColumns,
                  style: AppTextStyles.caption(context).copyWith(
                    fontWeight: FontWeight.w600,
                    color: scheme.onSurface,
                  ),
                ),
                if (hiddenCount > 0) ...[
                  SizedBox(width: 4.w),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: scheme.primaryContainer,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: ReusableText(
                      '-$hiddenCount',
                      style: AppTextStyles.caption(context).copyWith(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                        color: scheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
      menuChildren: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ReusableText(
                AppStrings.tableColumnsVisibility,
                style: AppTextStyles.body(context).copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (onResetColumnsVisibility != null && hiddenCount > 0)
                TextButton(
                  onPressed: onResetColumnsVisibility,
                  child: ReusableText(
                    AppStrings.tableDeselectAll,
                    style: AppTextStyles.caption(context).copyWith(
                      color: scheme.primary,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const PopupMenuDivider(),
        ...allColumns.map((col) {
          final isVisible = visibleColumnIds.contains(col.id);
          return MenuItemButton(
            closeOnActivate: false,
            onPressed: () => onToggleColumnVisibility?.call(col.id),
            leadingIcon: Checkbox(
              value: isVisible,
              onChanged: (_) => onToggleColumnVisibility?.call(col.id),
              activeColor: scheme.primary,
            ),
            child: SizedBox(
              width: 180.w,
              child: ReusableText(
                col.title,
                style: AppTextStyles.body(context).copyWith(
                  fontSize: 12.sp,
                  fontWeight: isVisible ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildDensityMenu(BuildContext context, ColorScheme scheme) {
    return PopupMenuButton<AppTableDensity>(
      tooltip: AppStrings.tableDensity,
      initialValue: density,
      onSelected: onDensityChanged,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.card.r),
      ),
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          border: Border.all(color: scheme.outline.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(AppRadius.button.r),
        ),
        child: Icon(
          density.icon,
          size: AppIconSize.md.value,
          color: scheme.onSurfaceVariant,
        ),
      ),
      itemBuilder: (context) {
        return AppTableDensity.values.map((d) {
          return PopupMenuItem<AppTableDensity>(
            value: d,
            child: Row(
              children: [
                Icon(
                  d.icon,
                  size: AppIconSize.sm.value,
                  color: d == density ? scheme.primary : scheme.onSurfaceVariant,
                ),
                SizedBox(width: 8.w),
                ReusableText(
                  d.label,
                  style: AppTextStyles.body(context).copyWith(
                    fontWeight: d == density ? FontWeight.bold : FontWeight.normal,
                    color: d == density ? scheme.primary : scheme.onSurface,
                  ),
                ),
              ],
            ),
          );
        }).toList();
      },
    );
  }

  Widget _buildExportMenu(BuildContext context, ColorScheme scheme) {
    if (onExportCsv == null && onExportExcel == null && onPrint == null) {
      return const SizedBox.shrink();
    }

    return PopupMenuButton<String>(
      tooltip: AppStrings.tableExport,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.card.r),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: scheme.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppRadius.button.r),
          border: Border.all(color: scheme.primary.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.download_rounded,
              size: AppIconSize.md.value,
              color: scheme.primary,
            ),
            SizedBox(width: 4.w),
            ReusableText(
              AppStrings.tableExport,
              style: AppTextStyles.caption(context).copyWith(
                fontWeight: FontWeight.bold,
                color: scheme.primary,
              ),
            ),
          ],
        ),
      ),
      itemBuilder: (context) => [
        if (onExportExcel != null)
          PopupMenuItem<String>(
            onTap: onExportExcel,
            child: Row(
              children: [
                Icon(
                  Icons.table_view_rounded,
                  color: Colors.green,
                  size: AppIconSize.sm.value,
                ),
                SizedBox(width: 8.w),
                ReusableText(AppStrings.tableExportExcel),
              ],
            ),
          ),
        if (onExportCsv != null)
          PopupMenuItem<String>(
            onTap: onExportCsv,
            child: Row(
              children: [
                Icon(
                  Icons.insert_drive_file_rounded,
                  color: scheme.primary,
                  size: AppIconSize.sm.value,
                ),
                SizedBox(width: 8.w),
                ReusableText(AppStrings.tableExportCsv),
              ],
            ),
          ),
        if (onPrint != null)
          PopupMenuItem<String>(
            onTap: onPrint,
            child: Row(
              children: [
                Icon(
                  Icons.print_rounded,
                  color: scheme.onSurfaceVariant,
                  size: AppIconSize.sm.value,
                ),
                SizedBox(width: 8.w),
                ReusableText(AppStrings.tablePrint),
              ],
            ),
          ),
      ],
    );
  }
}
