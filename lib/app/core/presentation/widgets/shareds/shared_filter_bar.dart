import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pharmacy_system/app/core/presentation/theme/app_colors.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_sizes.dart';
import 'package:pharmacy_system/app/core/constants/app_strings.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/index.dart';

enum SharedViewMode { table, grid }

class SharedFilterBar extends StatelessWidget {
  final TextEditingController? searchController;
  final ValueChanged<String>? onSearchChanged;
  final String searchHint;
  final List<Widget>? filterWidgets;
  final VoidCallback? onClearFilters;
  final int activeFilterCount;
  final SharedViewMode? currentViewMode;
  final ValueChanged<SharedViewMode>? onViewModeChanged;
  final List<Widget>? trailingActions;

  const SharedFilterBar({
    super.key,
    this.searchController,
    this.onSearchChanged,
    this.searchHint = AppStrings.searchHint,
    this.filterWidgets,
    this.onClearFilters,
    this.activeFilterCount = 0,
    this.currentViewMode,
    this.onViewModeChanged,
    this.trailingActions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = AppColors.isDark(context);

    return Container(
      padding: EdgeInsets.all(AppSpacing.md.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(AppRadius.md.r),
        border: Border.all(
          color: AppColors.borderOf(context).withValues(alpha: 0.2),
          width: 1.w,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 700;

          final searchField = SizedBox(
            width: isCompact ? double.infinity : 280.w,
            child: ReusableInput(
              controller: searchController,
              onChanged: onSearchChanged,
              hint: searchHint,
              prefixIcon: Icon(Icons.search_rounded, size: 18.sp),
              suffixIcon: searchController?.text.isNotEmpty == true
                  ? IconButton(
                      icon: Icon(Icons.close_rounded, size: 16.sp),
                      onPressed: () {
                        searchController?.clear();
                        onSearchChanged?.call('');
                      },
                    )
                  : null,
            ),
          );

          final filtersWrap = Wrap(
            spacing: AppSpacing.sm.w,
            runSpacing: AppSpacing.xs.h,
            children: [
              ...?filterWidgets,
              if (activeFilterCount > 0 && onClearFilters != null)
                TextButton.icon(
                  onPressed: onClearFilters,
                  icon: Icon(
                    Icons.filter_alt_off_rounded,
                    size: 16.sp,
                    color: scheme.error,
                  ),
                  label: ReusableText(
                    AppStrings.filterClearFormat.replaceFirst('%s', '$activeFilterCount'),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: scheme.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 6.h,
                    ),
                    backgroundColor: scheme.error.withValues(
                      alpha: isDark ? 0.12 : 0.06,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.sm.r),
                    ),
                  ),
                ),
            ],
          );

          final viewToggleAndActions = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (currentViewMode != null && onViewModeChanged != null) ...[
                Container(
                  decoration: BoxDecoration(
                    color: scheme.primary.withValues(
                      alpha: isDark ? 0.12 : 0.05,
                    ),
                    borderRadius: BorderRadius.circular(AppRadius.sm.r),
                    border: Border.all(
                      color: scheme.primary.withValues(alpha: 0.15),
                      width: 1.w,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: AppStrings.filterViewTable,
                        icon: Icon(
                          Icons.table_chart_outlined,
                          size: 18.sp,
                          color: currentViewMode == SharedViewMode.table
                              ? scheme.primary
                              : AppColors.textSecondaryOf(context),
                        ),
                        onPressed: () =>
                            onViewModeChanged!(SharedViewMode.table),
                      ),
                      IconButton(
                        tooltip: AppStrings.filterViewGrid,
                        icon: Icon(
                          Icons.grid_view_rounded,
                          size: 18.sp,
                          color: currentViewMode == SharedViewMode.grid
                              ? scheme.primary
                              : AppColors.textSecondaryOf(context),
                        ),
                        onPressed: () =>
                            onViewModeChanged!(SharedViewMode.grid),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: AppSpacing.sm.w),
              ],
              ...?trailingActions,
            ],
          );

          if (isCompact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                searchField,
                if (filterWidgets != null || activeFilterCount > 0) ...[
                  SizedBox(height: AppSpacing.sm.h),
                  filtersWrap,
                ],
                if (currentViewMode != null || trailingActions != null) ...[
                  SizedBox(height: AppSpacing.sm.h),
                  viewToggleAndActions,
                ],
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              searchField,
              SizedBox(width: AppSpacing.md.w),
              Expanded(child: filtersWrap),
              SizedBox(width: AppSpacing.sm.w),
              viewToggleAndActions,
            ],
          );
        },
      ),
    );
  }
}
