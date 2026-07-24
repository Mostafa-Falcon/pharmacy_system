import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pharmacy_system/app/shared/ui_core.dart';

class AppTableFooter extends StatelessWidget {
  final int totalItems;
  final int currentPage;
  final int totalPages;
  final int pageSize;
  final List<int> pageSizeOptions;
  final ValueChanged<int>? onPageSizeChanged;
  final VoidCallback? onNextPage;
  final VoidCallback? onPreviousPage;
  final VoidCallback? onFirstPage;
  final VoidCallback? onLastPage;
  final ValueChanged<int>? onGoToPage;
  final String? itemLabel;
  final bool showPageSizeSelector;
  final bool showGoToPage;
  final Color? backgroundColor;

  const ReusableTableFooter({
    super.key,
    required this.totalItems,
    required this.currentPage,
    required this.totalPages,
    this.pageSize = 25,
    this.pageSizeOptions = const [10, 25, 50, 100, 250, 500, 1000],
    this.onPageSizeChanged,
    this.onNextPage,
    this.onPreviousPage,
    this.onFirstPage,
    this.onLastPage,
    this.onGoToPage,
    this.itemLabel,
    this.showPageSizeSelector = true,
    this.showGoToPage = true,
    this.backgroundColor,
  });

  int get _startItem => totalItems == 0 ? 0 : (currentPage - 1) * pageSize + 1;
  int get _endItem => (currentPage * pageSize).clamp(0, totalItems);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      height: 54.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: backgroundColor ?? scheme.surfaceContainerLowest,
        border: Border(
          top: BorderSide(
            color: scheme.outline.withValues(alpha: 0.35),
            width: 1.5,
          ),
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppRadius.card.r),
          bottomRight: Radius.circular(AppRadius.card.r),
        ),
      ),
      child: Row(
        children: [
          _buildItemCountLabel(context, scheme),
          const Spacer(),
          if (showPageSizeSelector) ...[
            _buildPageSizeSelector(context, scheme),
            SizedBox(width: 12.w),
          ],
          if (showGoToPage && totalPages > 1) ...[
            _buildGoToPage(context, scheme),
            SizedBox(width: 12.w),
          ],
          if (totalPages > 1) _buildPaginationControls(context, scheme),
        ],
      ),
    );
  }

  Widget _buildItemCountLabel(BuildContext context, ColorScheme scheme) {
    final label = itemLabel ?? WidgetStrings.paginationItemLabel;
    final text = WidgetStrings.paginationFooterFormat
        .replaceFirst('%s', '$_startItem')
        .replaceFirst('%s', '$_endItem')
        .replaceFirst('%s', '$totalItems')
        .replaceFirst('%s', label);

    return ReusableText(
      text,
      style: AppTextStyles.caption(context).copyWith(
        fontWeight: FontWeight.w600,
        color: scheme.onSurfaceVariant,
        fontSize: 11.sp,
      ),
    );
  }

  Widget _buildPageSizeSelector(BuildContext context, ColorScheme scheme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
      decoration: BoxDecoration(
        border: Border.all(color: scheme.outline.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(AppRadius.button.r),
      ),
      child: DropdownButton<int>(
        value: pageSizeOptions.contains(pageSize) ? pageSize : pageSizeOptions.first,
        underline: const SizedBox.shrink(),
        isDense: true,
        icon: Icon(
          Icons.arrow_drop_down_rounded,
          size: AppIconSize.md.value,
          color: scheme.onSurfaceVariant,
        ),
        style: AppTextStyles.caption(context).copyWith(
          fontWeight: FontWeight.w600,
          color: scheme.onSurface,
        ),
        items: pageSizeOptions
            .map(
              (size) => DropdownMenuItem(
                value: size,
                child: ReusableText(
                  '$size',
                  style: AppTextStyles.caption(context).copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
            .toList(),
        onChanged: (val) {
          if (val != null) onPageSizeChanged?.call(val);
        },
      ),
    );
  }

  Widget _buildGoToPage(BuildContext context, ColorScheme scheme) {
    return SizedBox(
      width: 64.w,
      height: 32.h,
      child: TextField(
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: '$currentPage',
          hintStyle: AppTextStyles.caption(context).copyWith(
            fontSize: 11.sp,
            color: scheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 6.h),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.button.r),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.button.r),
            borderSide: BorderSide(color: scheme.primary, width: 1.5),
          ),
        ),
        onSubmitted: (value) {
          final page = int.tryParse(value);
          if (page != null && page >= 1 && page <= totalPages) {
            onGoToPage?.call(page);
          }
        },
      ),
    );
  }

  Widget _buildPaginationControls(BuildContext context, ColorScheme scheme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _PaginationButton(
          icon: Icons.first_page_rounded,
          onPressed: currentPage > 1 ? onFirstPage : null,
        ),
        _PaginationButton(
          icon: Icons.chevron_right_rounded, // اتجاه الـ RTL العربي الأصيل
          onPressed: currentPage > 1 ? onPreviousPage : null,
        ),
        SizedBox(width: 4.w),
        ..._buildPageNumbers(context, scheme),
        SizedBox(width: 4.w),
        _PaginationButton(
          icon: Icons.chevron_left_rounded,
          onPressed: currentPage < totalPages ? onNextPage : null,
        ),
        _PaginationButton(
          icon: Icons.last_page_rounded,
          onPressed: currentPage < totalPages ? onLastPage : null,
        ),
      ],
    );
  }

  List<Widget> _buildPageNumbers(BuildContext context, ColorScheme scheme) {
    final pages = <int>[];
    if (totalPages <= 5) {
      pages.addAll(List.generate(totalPages, (i) => i + 1));
    } else {
      pages.add(1);
      if (currentPage > 3) pages.add(-1);
      final start = (currentPage - 1).clamp(2, totalPages - 2);
      final end = (currentPage + 1).clamp(3, totalPages - 1);
      pages.addAll(List.generate(end - start + 1, (i) => start + i));
      if (currentPage < totalPages - 2) pages.add(-2);
      pages.add(totalPages);
    }

    return pages.map((page) {
      if (page < 0) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: ReusableText(
            '...',
            style: AppTextStyles.caption(context).copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        );
      }

      final isCurrent = page == currentPage;
      return Container(
        width: 28.w,
        height: 28.w,
        margin: EdgeInsets.symmetric(horizontal: 2.w),
        child: Material(
          color: isCurrent ? scheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.button.r),
          child: InkWell(
            borderRadius: BorderRadius.circular(AppRadius.button.r),
            onTap: isCurrent ? null : () => onGoToPage?.call(page),
            child: Center(
              child: ReusableText(
                '$page',
                style: AppTextStyles.caption(context).copyWith(
                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.w600,
                  color: isCurrent ? Colors.white : scheme.onSurface,
                  fontSize: 11.sp,
                ),
              ),
            ),
          ),
        ),
      );
    }).toList();
  }
}

class _PaginationButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _PaginationButton({required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isEnabled = onPressed != null;

    return SizedBox(
      width: 30.w,
      height: 30.w,
      child: IconButton(
        padding: EdgeInsets.zero,
        iconSize: AppIconSize.md.value,
        icon: Icon(
          icon,
          color: isEnabled
              ? scheme.onSurface
              : scheme.onSurfaceVariant.withValues(alpha: 0.3),
        ),
        onPressed: onPressed,
      ),
    );
  }
}




