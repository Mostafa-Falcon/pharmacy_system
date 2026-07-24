import 'package:flutter/material.dart';

import 'package:pharmacy_system/app/core/theme/design_system.dart';
import 'package:pharmacy_system/app/shared/ui_core.dart';

class ReusablePagination extends StatelessWidget {
  final int currentPage;
  final int pageCount;
  final VoidCallback onNextPage;
  final VoidCallback onPreviousPage;
  final int? pageSize;
  final List<int> pageSizeOptions;
  final ValueChanged<int>? onPageSizeChanged;
  final String? itemLabel;
  final bool showPageSizeSelector;

  const ReusablePagination({
    super.key,
    required this.currentPage,
    required this.pageCount,
    required this.onNextPage,
    required this.onPreviousPage,
    this.pageSize,
    this.pageSizeOptions = const [25, 50, 100, 250, 500, 1000],
    this.onPageSizeChanged,
    this.itemLabel,
    this.showPageSizeSelector = true,
  });

  @override
  Widget build(BuildContext context) {
    final page = currentPage + 1;
    final isMobile = ScreenTierResolver.isMobile(context);

    final effectiveItemLabel = itemLabel ?? WidgetStrings.paginationItemLabel;

    final pageSizeSelector = showPageSizeSelector && onPageSizeChanged != null
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ReusableText(
                GeneralStrings.view,
                style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(width: AppSpacing.xs.w),
              AppDropdown<int>(
                value: pageSize,
                hintText: WidgetStrings.paginationPageSize,
                items: pageSizeOptions,
                isCompact: true,
                itemAsString: (value) => '$value',
                onChanged: (value) {
                  if (value != null) onPageSizeChanged!(value);
                },
              ),
              SizedBox(width: AppSpacing.xs.w),
              ReusableText(
                effectiveItemLabel,
                style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          )
        : const SizedBox.shrink();

    final navControls = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: GeneralStrings.previous,
          onPressed: currentPage > 0 ? onPreviousPage : null,
          icon: Icon(Icons.chevron_right_rounded, size: AppIconSize.md.value),
          splashRadius: 20.r,
        ),
        ReusableText(
          WidgetStrings.paginationPageFormat.replaceFirst('%s', '$page').replaceFirst('%s', '$pageCount'),
          style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.bold),
        ),
        IconButton(
          tooltip: GeneralStrings.nextLabel,
          onPressed: page < pageCount ? onNextPage : null,
          icon: Icon(Icons.chevron_left_rounded, size: AppIconSize.md.value),
          splashRadius: 20.r,
        ),
      ],
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w, vertical: AppSpacing.xs.h),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (pageSizeSelector is Row) Center(child: pageSizeSelector),
                if (pageSizeSelector is Row) SizedBox(height: AppSpacing.sm.h),
                Center(child: navControls),
              ],
            )
          : Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: AppSpacing.sm.w,
              runSpacing: AppSpacing.sm.h,
              children: [pageSizeSelector, navControls],
            ),
    );
  }
}




