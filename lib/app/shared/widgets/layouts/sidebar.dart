import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_system/app/shared/widgets/display/app_text.dart';
import 'package:pharmacy_system/app/shared/ui_core.dart';

import 'package:pharmacy_system/app/core/data/services/ui/sound_service.dart';
import 'package:pharmacy_system/app/core/theme/sidebar_theme.dart';
import 'package:pharmacy_system/app/shared/widgets/index.dart';

class SidebarItem {
  final String id;
  final IconData icon;
  final String label;
  final List<SidebarItem>? children;
  final bool initiallyExpanded;

  const SidebarItem({
    required this.id,
    required this.icon,
    required this.label,
    this.children,
    this.initiallyExpanded = false,
  });
}

class SidebarGroup {
  final String id;
  final String label;
  final IconData? icon;
  final List<SidebarItem> children;
  final Color? color;
  final bool initiallyExpanded;

  const SidebarGroup({
    required this.id,
    required this.label,
    this.icon,
    required this.children,
    this.color,
    this.initiallyExpanded = false,
  });
}

class BranchOption {
  final String id;
  final String label;

  const BranchOption({required this.id, required this.label});
}

// ─── Main Sidebar Widget ───────────────────────────────────────

class HomeSidebar extends StatelessWidget {
  final bool isDrawer;
  final bool isSidebarVisible;
  final int selectedIndex;
  final List<SidebarGroup> groups;
  final List<BranchOption> branches;
  final String activeBranchId;
  final ValueChanged<int>? onNavigate;
  final ValueChanged<String>? onBranchChanged;

  const HomeSidebar({
    super.key,
    this.isDrawer = false,
    required this.isSidebarVisible,
    required this.selectedIndex,
    required this.groups,
    required this.onNavigate,
    this.branches = const [],
    this.activeBranchId = '',
    this.onBranchChanged,
  });

  @override
  Widget build(BuildContext context) {
    final sidebarTheme = Theme.of(context).extension<SidebarTheme>()!;
    final isDark = AppColors.isDark(context);

    if (isDrawer) {
      return Drawer(
        width: 260.w,
        elevation: 16,
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: sidebarTheme.backgroundColor,
            borderRadius: BorderRadiusDirectional.only(
              topEnd: Radius.circular(AppRadius.xl.r),
              bottomEnd: Radius.circular(AppRadius.xl.r),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.08),
                blurRadius: 20,
                offset: const Offset(4, 0),
              ),
            ],
          ),
          child: SafeArea(
            child: _SidebarBody(
              selectedIndex: selectedIndex,
              groups: groups,
              onNavigate: onNavigate,
              branches: branches,
              activeBranchId: activeBranchId,
              onBranchChanged: onBranchChanged,
              isCollapsed: false,
            ),
          ),
        ),
      );
    }

    final collapsed = !isSidebarVisible;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.fastOutSlowIn,
      width: collapsed ? 72.w : 264.w,
      decoration: BoxDecoration(
        color: sidebarTheme.backgroundColor,
        border: BorderDirectional(
          end: BorderSide(
            color: sidebarTheme.dividerColor.withValues(
              alpha: isDark ? 0.25 : 0.45,
            ),
            width: 1.w,
          ),
        ),
        boxShadow: [
          if (!collapsed)
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.02),
              blurRadius: 10,
              offset: const Offset(2, 0),
            ),
        ],
      ),
      child: _SidebarBody(
        selectedIndex: selectedIndex,
        groups: groups,
        onNavigate: onNavigate,
        branches: branches,
        activeBranchId: activeBranchId,
        onBranchChanged: onBranchChanged,
        isCollapsed: collapsed,
      ),
    );
  }
}

// ─── Sidebar Body ──────────────────────────────────────────────

class _SidebarBody extends StatefulWidget {
  final int selectedIndex;
  final List<SidebarGroup> groups;
  final ValueChanged<int>? onNavigate;
  final List<BranchOption> branches;
  final String activeBranchId;
  final ValueChanged<String>? onBranchChanged;
  final bool isCollapsed;

  const _SidebarBody({
    required this.selectedIndex,
    required this.groups,
    required this.onNavigate,
    this.branches = const [],
    this.activeBranchId = '',
    this.onBranchChanged,
    this.isCollapsed = false,
  });

  @override
  State<_SidebarBody> createState() => _SidebarBodyState();
}

class _SidebarBodyState extends State<_SidebarBody> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _expandedItemIds = <String>{};
  late Map<String, int> _destinationIndexById;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _expandedItemIds.addAll(
      widget.groups
          .where((group) => group.initiallyExpanded)
          .map((group) => group.id),
    );
    _expandedItemIds.addAll(
      widget.groups
          .expand((group) => group.children)
          .where((item) => item.initiallyExpanded)
          .map((item) => item.id),
    );
    _rebuildIndexMap();
    _expandSelectedPath();
  }

  @override
  void didUpdateWidget(covariant _SidebarBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.groups, widget.groups)) {
      _rebuildIndexMap();
    }
    if (oldWidget.selectedIndex != widget.selectedIndex ||
        oldWidget.isCollapsed != widget.isCollapsed) {
      _expandSelectedPath(rebuild: true);
    }
  }

  void _rebuildIndexMap() {
    _destinationIndexById = <String, int>{};
    var index = 0;
    for (final group in widget.groups) {
      for (final item in group.children) {
        _destinationIndexById[item.id] = index;
        index++;
        if (item.children != null) {
          for (final child in item.children!) {
            _destinationIndexById[child.id] = index;
            index++;
          }
        }
      }
    }
  }

  void _expandSelectedPath({bool rebuild = false}) {
    if (widget.selectedIndex < 0) return;

    final selectedId = _destinationIndexById.keys.firstWhere(
      (id) => _destinationIndexById[id] == widget.selectedIndex,
      orElse: () => '',
    );
    if (selectedId.isEmpty) return;

    final parentIds = <String>{};
    for (final group in widget.groups) {
      for (final item in group.children) {
        if (item.id == selectedId) {
          parentIds.add(group.id);
          break;
        }
        if (item.children != null &&
            item.children!.any((c) => c.id == selectedId)) {
          parentIds.add(group.id);
          parentIds.add(item.id);
          break;
        }
      }
    }

    final hasChanges = parentIds.any((id) => !_expandedItemIds.contains(id));
    if (!hasChanges) return;

    void update() => _expandedItemIds.addAll(parentIds);
    if (rebuild && mounted) {
      setState(update);
    } else {
      update();
    }
  }

  bool _groupHasSelectedChild(SidebarGroup group) {
    if (widget.selectedIndex < 0) return false;
    for (final item in group.children) {
      final childIndex = _destinationIndexById[item.id] ?? -1;
      if (childIndex == widget.selectedIndex) return true;
      if (_hasSelectedChild(item)) return true;
    }
    return false;
  }

  void _toggle(String itemId) {
    if (mounted) {
      setState(() {
        if (!_expandedItemIds.add(itemId)) {
          _expandedItemIds.remove(itemId);
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sidebarTheme = Theme.of(context).extension<SidebarTheme>()!;
    final isDark = AppColors.isDark(context);

    final isSearching = _searchQuery.trim().isNotEmpty;
    final searchMatches = isSearching ? _getFilteredItems() : <_SearchMatch>[];

    return Column(
      children: [
        _SidebarHeader(isCollapsed: widget.isCollapsed),
        if (!widget.isCollapsed) ...[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
            child: _SidebarSearchBox(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              onClear: () {
                _searchController.clear();
                setState(() => _searchQuery = '');
              },
            ),
          ),
        ],
        Divider(
          color: sidebarTheme.dividerColor.withValues(
            alpha: isDark ? 0.2 : 0.4,
          ),
          height: 1.h,
        ),
        Expanded(
          child: isSearching && !widget.isCollapsed
              ? _buildSearchResults(searchMatches)
              : ListView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsetsDirectional.fromSTEB(
                    widget.isCollapsed ? 6.w : 8.w,
                    AppSpacing.xs.h,
                    widget.isCollapsed ? 6.w : 10.w,
                    AppSpacing.lg.h,
                  ),
                  children: [
                    for (final group in widget.groups) ...[
                      if (!widget.isCollapsed)
                        _SidebarGroupHeader(
                          label: group.label,
                          icon: group.icon,
                          color: group.color,
                          isExpanded: _expandedItemIds.contains(group.id),
                          hasSelectedChild: _groupHasSelectedChild(group),
                          onToggle: () => _toggle(group.id),
                        ),
                      if (widget.isCollapsed ||
                          _expandedItemIds.contains(group.id))
                        for (final item in group.children)
                          _buildNavigationItem(item, groupColor: group.color),
                    ],
                  ],
                ),
        ),
        Divider(
          color: sidebarTheme.dividerColor.withValues(
            alpha: isDark ? 0.2 : 0.4,
          ),
          height: 1.h,
        ),
        if (!widget.isCollapsed)
          _SidebarBranchSwitcher(
            branches: widget.branches,
            activeBranchId: widget.activeBranchId,
            onChanged: widget.onBranchChanged,
          )
        else
          _SidebarBranchCollapsed(
            branches: widget.branches,
            activeBranchId: widget.activeBranchId,
            onChanged: widget.onBranchChanged,
          ),
      ],
    );
  }

  List<_SearchMatch> _getFilteredItems() {
    final matches = <_SearchMatch>[];
    final query = _searchQuery.trim().toLowerCase();

    for (final group in widget.groups) {
      for (final item in group.children) {
        if (item.label.toLowerCase().contains(query)) {
          matches.add(
            _SearchMatch(
              item: item,
              groupLabel: group.label,
              groupColor: group.color,
            ),
          );
        }
        if (item.children != null) {
          for (final child in item.children!) {
            if (child.label.toLowerCase().contains(query)) {
              matches.add(
                _SearchMatch(
                  item: child,
                  groupLabel: '${group.label} › ${item.label}',
                  groupColor: group.color,
                ),
              );
            }
          }
        }
      }
    }
    return matches;
  }

  Widget _buildSearchResults(List<_SearchMatch> matches) {
    if (matches.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.search_off_rounded,
                size: AppIconSize.xl.value,
                color: Theme.of(context).colorScheme.outline,
              ),
              SizedBox(height: 8.h),
              ReusableText(
                GeneralStrings.noData,
                style: AppTextStyles.body(context).copyWith(
                  color: Theme.of(context).colorScheme.outline,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      itemCount: matches.length,
      itemBuilder: (context, idx) {
        final match = matches[idx];
        final destinationIndex = _destinationIndexById[match.item.id] ?? -1;
        final isSelected = destinationIndex == widget.selectedIndex;

        return Padding(
          padding: EdgeInsets.symmetric(vertical: 2.h),
          child: _SidebarTile(
            icon: match.item.icon,
            label: match.item.label,
            subLabel: match.groupLabel,
            depth: 0,
            isSelected: isSelected,
            hasSelectedChild: false,
            isExpandable: false,
            isExpanded: false,
            isCollapsed: false,
            groupColor: match.groupColor,
            onTap: () {
              if (destinationIndex >= 0) {
                HapticFeedback.lightImpact();
                SoundService.instance.play(SoundEffect.click);
                widget.onNavigate?.call(destinationIndex);
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildNavigationItem(
    SidebarItem item, {
    int depth = 0,
    Color? groupColor,
  }) {
    final destinationIndex = _destinationIndexById[item.id] ?? -1;
    final isSelected = destinationIndex == widget.selectedIndex;
    final isExpanded = _expandedItemIds.contains(item.id);
    final hasSelectedChild = _hasSelectedChild(item);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _SidebarTile(
          icon: item.icon,
          label: item.label,
          depth: depth,
          isSelected: isSelected,
          hasSelectedChild: hasSelectedChild,
          isExpandable: item.children != null && item.children!.isNotEmpty,
          isExpanded: isExpanded,
          isCollapsed: widget.isCollapsed,
          groupColor: groupColor,
          onTap: () {
            if (item.children != null && item.children!.isNotEmpty) {
              _toggle(item.id);
            } else if (destinationIndex >= 0) {
              HapticFeedback.lightImpact();
              SoundService.instance.play(SoundEffect.click);
              widget.onNavigate?.call(destinationIndex);
            }
          },
        ),
        if (item.children != null &&
            item.children!.isNotEmpty &&
            !widget.isCollapsed)
          ClipRect(
            child: AnimatedSize(
              duration: const Duration(milliseconds: 220),
              curve: Curves.fastOutSlowIn,
              alignment: AlignmentDirectional.topStart,
              child: isExpanded
                  ? Padding(
                      padding: EdgeInsetsDirectional.only(start: 6.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (final child in item.children!)
                            _buildNavigationItem(
                              child,
                              depth: depth + 1,
                              groupColor: groupColor,
                            ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
      ],
    );
  }

  bool _hasSelectedChild(SidebarItem item) {
    if (item.children == null) return false;
    for (final child in item.children!) {
      final childIndex = _destinationIndexById[child.id] ?? -1;
      if (childIndex == widget.selectedIndex) return true;
      if (_hasSelectedChild(child)) return true;
    }
    return false;
  }
}

class _SearchMatch {
  final SidebarItem item;
  final String groupLabel;
  final Color? groupColor;

  const _SearchMatch({
    required this.item,
    required this.groupLabel,
    this.groupColor,
  });
}

// ─── Sidebar Search Box ────────────────────────────────────────

class _SidebarSearchBox extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SidebarSearchBox({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final sidebarTheme = Theme.of(context).extension<SidebarTheme>()!;
    final isDark = AppColors.isDark(context);

    return Container(
      height: 36.h,
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.black.withValues(alpha: 0.035),
        borderRadius: BorderRadius.circular(AppRadius.md.r),
        border: Border.all(
          color: sidebarTheme.dividerColor.withValues(
            alpha: isDark ? 0.2 : 0.3,
          ),
          width: 1.w,
        ),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: AppTextStyles.body(
          context,
        ).copyWith(color: sidebarTheme.textColor, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          isDense: true,
          hintText: GeneralStrings.searchHint,
          hintStyle: TextStyle(
            color: sidebarTheme.mutedColor.withValues(alpha: 0.7),
            fontSize: 11.5.sp,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            size: 17.sp,
            color: sidebarTheme.mutedColor,
          ),
          prefixIconConstraints: BoxConstraints(
            minWidth: 32.w,
            minHeight: 32.h,
          ),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.close_rounded,
                    size: 15.sp,
                    color: sidebarTheme.mutedColor,
                  ),
                  onPressed: onClear,
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(minWidth: 28.w, minHeight: 28.h),
                )
              : null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 8.h),
        ),
      ),
    );
  }
}

// ─── Sidebar Header ────────────────────────────────────────────

class _SidebarHeader extends StatelessWidget {
  final bool isCollapsed;

  const _SidebarHeader({required this.isCollapsed});

  @override
  Widget build(BuildContext context) {
    final sidebarTheme = Theme.of(context).extension<SidebarTheme>()!;
    final scheme = Theme.of(context).colorScheme;
    final isDark = AppColors.isDark(context);

    return SizedBox(
      height: 72.h,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isCollapsed ? 4.w : AppSpacing.md.w,
        ),
        child: Row(
          mainAxisAlignment: isCollapsed
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 40.w,
                  height: 40.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        scheme.primary,
                        scheme.primary.withValues(alpha: 0.8),
                        scheme.primary.withValues(alpha: 0.65),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(AppRadius.md.r),
                    boxShadow: [
                      BoxShadow(
                        color: scheme.primary.withValues(
                          alpha: isDark ? 0.35 : 0.22,
                        ),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.local_pharmacy_rounded,
                    color: Colors.white,
                    size: AppIconSize.md.value,
                  ),
                ),
                PositionedDirectional(
                  bottom: -1,
                  end: -1,
                  child: Container(
                    width: 11.w,
                    height: 11.w,
                    decoration: BoxDecoration(
                      color: const Color(
                        0xFF10B981,
                      ), // Emerald online status dot
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: sidebarTheme.backgroundColor,
                        width: 2.w,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF10B981).withValues(alpha: 0.4),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (!isCollapsed) ...[
              SizedBox(width: 12.w),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: AlignmentDirectional.centerStart,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ReusableText(
                            GeneralStrings.appName,
                            style: AppTextStyles.title(context).copyWith(
                              color: sidebarTheme.textColor,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      ReusableText(
                        GeneralStrings.pharmacyManagement,
                        style: AppTextStyles.caption(context).copyWith(
                          color: sidebarTheme.mutedColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Group Header ─────────────────────────────────────────────

class _SidebarGroupHeader extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color? color;
  final bool isExpanded;
  final bool hasSelectedChild;
  final VoidCallback onToggle;

  const _SidebarGroupHeader({
    required this.label,
    this.icon,
    this.color,
    required this.isExpanded,
    this.hasSelectedChild = false,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final sidebarTheme = Theme.of(context).extension<SidebarTheme>()!;
    final scheme = Theme.of(context).colorScheme;
    final displayColor = color ?? scheme.primary;

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(4.w, 14.h, 4.w, 4.h),
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(AppRadius.sm.r),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 6.w),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: hasSelectedChild
                      ? displayColor.withValues(alpha: 0.22)
                      : displayColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AppRadius.xs.r),
                  border: hasSelectedChild
                      ? Border.all(
                          color: displayColor.withValues(alpha: 0.35),
                          width: 1.w,
                        )
                      : null,
                ),
                child: Icon(
                  icon ?? Icons.grid_view_rounded,
                  size: 13.sp,
                  color: displayColor,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: ReusableText(
                  label,
                  style: TextStyle(
                    color: hasSelectedChild
                        ? displayColor
                        : sidebarTheme.textColor.withValues(alpha: 0.85),
                    fontSize: 11.5.sp,
                    fontWeight: hasSelectedChild
                        ? FontWeight.w800
                        : FontWeight.bold,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
              if (hasSelectedChild) ...[
                Container(
                  width: 6.w,
                  height: 6.w,
                  margin: EdgeInsetsDirectional.only(end: 6.w),
                  decoration: BoxDecoration(
                    color: displayColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: displayColor.withValues(alpha: 0.6),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ],
              AnimatedRotation(
                turns: isExpanded ? 0 : 0.5,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: AppIconSize.md.value,
                  color: hasSelectedChild
                      ? displayColor
                      : sidebarTheme.mutedColor.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Navigation Tile ───────────────────────────────────────────

class _SidebarTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subLabel;
  final int depth;
  final bool isSelected;
  final bool hasSelectedChild;
  final bool isExpandable;
  final bool isExpanded;
  final bool isCollapsed;
  final Color? groupColor;
  final VoidCallback? onTap;

  const _SidebarTile({
    required this.icon,
    required this.label,
    this.subLabel,
    required this.depth,
    required this.isSelected,
    required this.hasSelectedChild,
    required this.isExpandable,
    required this.isExpanded,
    required this.isCollapsed,
    this.groupColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final sidebarTheme = Theme.of(context).extension<SidebarTheme>()!;
    final scheme = Theme.of(context).colorScheme;
    final isDark = AppColors.isDark(context);
    final isEmphasized = isSelected || hasSelectedChild;

    final accentColor = groupColor ?? sidebarTheme.selectedIndicatorColor;
    final foreground = isSelected
        ? accentColor
        : (hasSelectedChild ? scheme.primary : sidebarTheme.textColor);

    final tileBg = isSelected
        ? accentColor.withValues(alpha: isDark ? 0.18 : 0.09)
        : Colors.transparent;

    final radius = BorderRadius.circular(AppRadius.md.r);

    final tile = AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      margin: EdgeInsets.symmetric(
        vertical: 2.5.h,
        horizontal: isCollapsed ? 2.w : 0,
      ),
      decoration: BoxDecoration(
        color: tileBg,
        borderRadius: radius,
        border: isSelected
            ? Border.all(
                color: accentColor.withValues(alpha: isDark ? 0.25 : 0.15),
                width: 1.w,
              )
            : null,
        boxShadow: [
          if (isSelected)
            BoxShadow(
              color: accentColor.withValues(alpha: isDark ? 0.12 : 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: radius,
        child: InkWell(
          onTap: onTap,
          hoverColor: sidebarTheme.hoverColor.withValues(
            alpha: isDark ? 0.25 : 0.45,
          ),
          splashColor: accentColor.withValues(alpha: 0.08),
          borderRadius: radius,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(
              isCollapsed ? AppSpacing.xs.w : (10 + (depth * 14)).w,
              depth == 0 ? 9.5.h : 7.5.h,
              isCollapsed ? AppSpacing.xs.w : 10.w,
              depth == 0 ? 9.5.h : 7.5.h,
            ),
            child: Row(
              mainAxisAlignment: isCollapsed
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: [
                // Glowing side indicator bar
                if (!isCollapsed && depth == 0)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOutCubic,
                    width: 3.5.w,
                    height: isSelected ? 18.h : 0.0,
                    margin: EdgeInsetsDirectional.only(
                      end: isSelected ? 8.w : 0,
                    ),
                    decoration: BoxDecoration(
                      color: accentColor,
                      borderRadius: BorderRadius.circular(AppRadius.sm.r),
                      boxShadow: [
                        if (isSelected)
                          BoxShadow(
                            color: accentColor.withValues(alpha: 0.5),
                            blurRadius: 6,
                            spreadRadius: 0.5,
                          ),
                      ],
                    ),
                  ),
                Icon(
                  icon,
                  size: depth == 0 ? 19.sp : 16.5.sp,
                  color: foreground,
                ),
                if (!isCollapsed) ...[
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ReusableText(
                          label,
                          style: TextStyle(
                            color: foreground,
                            fontSize: depth == 0 ? 13.5.sp : 12.5.sp,
                            fontWeight: isEmphasized
                                ? FontWeight.bold
                                : FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (subLabel != null) ...[
                          SizedBox(height: 1.h),
                          ReusableText(
                            subLabel!,
                            style: AppTextStyles.caption(context).copyWith(
                              color: sidebarTheme.mutedColor,
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (isExpandable)
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 180),
                      curve: Curves.easeInOut,
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: isEmphasized
                            ? accentColor
                            : sidebarTheme.mutedColor,
                        size: 18.sp,
                      ),
                    )
                  else if (isSelected && depth > 0)
                    Container(
                      width: 5.w,
                      height: 5.w,
                      decoration: BoxDecoration(
                        color: accentColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );

    if (isCollapsed) {
      return Tooltip(
        message: label,
        preferBelow: false,
        waitDuration: const Duration(milliseconds: 150),
        child: tile,
      );
    }

    return tile;
  }
}

// ─── Branch Switcher (expanded) ────────────────────────────────

class _SidebarBranchSwitcher extends StatelessWidget {
  final List<BranchOption> branches;
  final String activeBranchId;
  final ValueChanged<String>? onChanged;

  const _SidebarBranchSwitcher({
    required this.branches,
    required this.activeBranchId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final sidebarTheme = Theme.of(context).extension<SidebarTheme>()!;
    final isDark = AppColors.isDark(context);

    final activeBranch = branches.firstWhere(
      (b) => b.id == activeBranchId,
      orElse: () =>
          const BranchOption(id: '', label: GeneralStrings.mainBranchLabel),
    );

    final radius = BorderRadius.circular(AppRadius.lg.r);

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.sm.w),
        child: PopupMenuButton<String>(
          tooltip: GeneralStrings.switchBranchTooltip,
          position: PopupMenuPosition.over,
          surfaceTintColor: Colors.transparent,
          constraints: BoxConstraints(minWidth: 190.w, maxWidth: 240.w),
          shape: RoundedRectangleBorder(
            borderRadius: radius,
            side: BorderSide(
              color: AppColors.borderOf(context).withValues(alpha: 0.25),
              width: 1.w,
            ),
          ),
          onSelected: onChanged,
          itemBuilder: (context) => [
            for (final branch in branches)
              PopupMenuItem<String>(
                value: branch.id,
                child: Row(
                  children: [
                    Icon(
                      branch.id == activeBranchId
                          ? Icons.store_rounded
                          : Icons.store_outlined,
                      size: 18.sp,
                      color: branch.id == activeBranchId
                          ? scheme.primary
                          : AppColors.textSecondaryOf(context),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: ReusableText(
                        branch.label,
                        style: TextStyle(
                          color: branch.id == activeBranchId
                              ? scheme.primary
                              : AppColors.textPrimaryOf(context),
                          fontWeight: branch.id == activeBranchId
                              ? FontWeight.bold
                              : FontWeight.w500,
                          fontSize: 12.5.sp,
                        ),
                      ),
                    ),
                    if (branch.id == activeBranchId)
                      Icon(
                        Icons.check_rounded,
                        color: scheme.primary,
                        size: 18.sp,
                      ),
                  ],
                ),
              ),
          ],
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.04)
                  : Colors.black.withValues(alpha: 0.025),
              borderRadius: BorderRadius.circular(AppRadius.md.r),
              border: Border.all(
                color: sidebarTheme.dividerColor.withValues(
                  alpha: isDark ? 0.2 : 0.35,
                ),
                width: 1.w,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.12 : 0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(7.w),
                  decoration: BoxDecoration(
                    color: scheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.sm.r),
                  ),
                  child: Icon(
                    Icons.storefront_rounded,
                    color: scheme.primary,
                    size: 17.sp,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ReusableText(
                        GeneralStrings.currentBranchLabel,
                        style: TextStyle(
                          color: sidebarTheme.mutedColor,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      ReusableText(
                        activeBranch.label,
                        style: TextStyle(
                          color: sidebarTheme.textColor,
                          fontSize: 12.5.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.unfold_more_rounded,
                  color: sidebarTheme.mutedColor,
                  size: AppIconSize.md.value,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Branch Switcher (collapsed) ───────────────────────────────

class _SidebarBranchCollapsed extends StatelessWidget {
  final List<BranchOption> branches;
  final String activeBranchId;
  final ValueChanged<String>? onChanged;

  const _SidebarBranchCollapsed({
    required this.branches,
    required this.activeBranchId,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = AppColors.isDark(context);
    final radius = BorderRadius.circular(AppRadius.lg.r);

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
        child: PopupMenuButton<String>(
          tooltip: GeneralStrings.switchBranchTooltip,
          position: PopupMenuPosition.over,
          surfaceTintColor: Colors.transparent,
          constraints: BoxConstraints(minWidth: 180.w, maxWidth: 230.w),
          shape: RoundedRectangleBorder(
            borderRadius: radius,
            side: BorderSide(
              color: AppColors.borderOf(context).withValues(alpha: 0.25),
              width: 1.w,
            ),
          ),
          onSelected: onChanged,
          itemBuilder: (context) => [
            for (final branch in branches)
              PopupMenuItem<String>(
                value: branch.id,
                child: Row(
                  children: [
                    Icon(
                      branch.id == activeBranchId
                          ? Icons.store_rounded
                          : Icons.store_outlined,
                      size: 18.sp,
                      color: branch.id == activeBranchId
                          ? scheme.primary
                          : AppColors.textSecondaryOf(context),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: ReusableText(
                        branch.label,
                        style: TextStyle(
                          color: branch.id == activeBranchId
                              ? scheme.primary
                              : AppColors.textPrimaryOf(context),
                          fontWeight: branch.id == activeBranchId
                              ? FontWeight.bold
                              : FontWeight.w500,
                          fontSize: 12.5.sp,
                        ),
                      ),
                    ),
                    if (branch.id == activeBranchId)
                      Icon(
                        Icons.check_rounded,
                        color: scheme.primary,
                        size: 18.sp,
                      ),
                  ],
                ),
              ),
          ],
          child: Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.black.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(AppRadius.md.r),
              border: Border.all(
                color: AppColors.borderOf(
                  context,
                ).withValues(alpha: isDark ? 0.2 : 0.35),
                width: 1.w,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.1 : 0.015),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(
              Icons.storefront_rounded,
              color: scheme.primary,
              size: AppIconSize.md.value,
            ),
          ),
        ),
      ),
    );
  }
}




