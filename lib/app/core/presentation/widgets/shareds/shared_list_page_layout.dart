import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pharmacy_system/app/core/presentation/theme/app_colors.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_sizes.dart';
import 'package:pharmacy_system/app/core/constants/app_strings.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/index.dart';
import 'shared_filter_bar.dart';
import 'shared_page_header.dart';
import 'shared_stat_card.dart';

class SharedListPageLayout extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;
  final List<Widget>? headerActions;
  final List<SharedStatCard>? stats;
  final TabBar? tabBar;

  // Filter options
  final TextEditingController? searchController;
  final ValueChanged<String>? onSearchChanged;
  final String searchHint;
  final List<Widget>? filterWidgets;
  final VoidCallback? onClearFilters;
  final int activeFilterCount;
  final SharedViewMode? currentViewMode;
  final ValueChanged<SharedViewMode>? onViewModeChanged;

  // Body content & state
  final Widget body;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRetry;
  final bool isEmpty;
  final String emptyTitle;
  final String? emptySubtitle;
  final IconData emptyIcon;
  final Widget? emptyAction;
  final Widget? paginationFooter;

  const SharedListPageLayout({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.headerActions,
    this.stats,
    this.tabBar,
    this.searchController,
    this.onSearchChanged,
    this.searchHint = AppStrings.searchHint,
    this.filterWidgets,
    this.onClearFilters,
    this.activeFilterCount = 0,
    this.currentViewMode,
    this.onViewModeChanged,
    required this.body,
    this.isLoading = false,
    this.errorMessage,
    this.onRetry,
    this.isEmpty = false,
    this.emptyTitle = AppStrings.noDataAvailableShort,
    this.emptySubtitle,
    this.emptyIcon = Icons.inbox_rounded,
    this.emptyAction,
    this.paginationFooter,
  });

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (isLoading) {
      content = const AppStateView.loading(message: AppStrings.listLoadingLabel);
    } else if (errorMessage != null) {
      content = AppStateView.error(
        message: errorMessage!,
        action: onRetry != null
            ? ReusableButton(text: AppStrings.refresh, onPressed: onRetry)
            : null,
      );
    } else if (isEmpty) {
      content = AppStateView.empty(
        title: emptyTitle,
        subtitle: emptySubtitle,
        icon: emptyIcon,
        action: emptyAction,
      );
    } else {
      content = body;
    }

    final hasFilterBar =
        searchController != null ||
        onSearchChanged != null ||
        (filterWidgets != null && filterWidgets!.isNotEmpty);

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Shared Header
              SharedPageHeader(
                title: title,
                subtitle: subtitle,
                icon: icon,
                iconColor: iconColor,
                actions: headerActions,
                stats: stats,
                tabBar: tabBar,
              ),

              // 2. Shared Filter Bar
              if (hasFilterBar) ...[
                SizedBox(height: AppSpacing.md.h),
                SharedFilterBar(
                  searchController: searchController,
                  onSearchChanged: onSearchChanged,
                  searchHint: searchHint,
                  filterWidgets: filterWidgets,
                  onClearFilters: onClearFilters,
                  activeFilterCount: activeFilterCount,
                  currentViewMode: currentViewMode,
                  onViewModeChanged: onViewModeChanged,
                ),
              ],

              SizedBox(height: AppSpacing.md.h),

              // 3. Body Content
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceOf(context),
                    borderRadius: BorderRadius.circular(AppRadius.md.r),
                    border: Border.all(
                      color: AppColors.borderOf(context).withValues(alpha: 0.2),
                      width: 1.w,
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      Expanded(child: content),
                      if (paginationFooter != null &&
                          !isLoading &&
                          !isEmpty &&
                          errorMessage == null)
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: AppColors.borderOf(
                                  context,
                                ).withValues(alpha: 0.2),
                                width: 1.w,
                              ),
                            ),
                          ),
                          child: paginationFooter!,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
