import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_system/app/shared/ui_core.dart';
import 'package:pharmacy_system/app/modules/layout/bloc/shell_bloc.dart';
import 'package:pharmacy_system/app/modules/layout/bloc/shell_event.dart';
import 'package:pharmacy_system/app/modules/layout/bloc/shell_state.dart';
import 'package:pharmacy_system/app/routes/app_routes.dart';

class HomeDashboardView extends StatefulWidget {
  const HomeDashboardView({super.key});

  @override
  State<HomeDashboardView> createState() => _HomeDashboardViewState();
}

class _HomeDashboardViewState extends State<HomeDashboardView> {
  // ignore: prefer_final_fields
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<ShellBloc>().add(const LoadShell());
  }

  void _navigateToIndex(String destinationId) {
    final route = Routes.routeForDestination(destinationId);
    if (route != null) {
      context.go(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShellBloc, ShellState>(
      builder: (context, state) {
        if (state.status == ShellStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == ShellStatus.error) {
          return Center(
            child: Text(
              state.error ?? 'حدث خطأ',
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontFamily: 'Cairo',
              ),
            ),
          );
        }

        final user = state.user;
        final today = DateFormat(
          'EEEE، d MMMM yyyy',
          'ar',
        ).format(DateTime.now());

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Row(
            children: [
              // Sidebar
              HomeSidebar(
                isSidebarVisible: state.sidebarVisible,
                selectedIndex: _selectedIndex,
                groups: state.groups,
                branches: state.branches,
                activeBranchId: state.activeBranchId,
                onNavigate: (index) {
                  // Navigation is handled via the sidebar tiles
                },
                onBranchChanged: (branchId) {
                  context.read<ShellBloc>().add(SelectBranch(branchId));
                },
              ),
              // Main Content
              Expanded(
                child: Column(
                  children: [
                    // Header
                    _buildHeader(context, user, today, state),
                    // Content
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(24.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ReusableText(
                              'لوحة التحكم',
                              style: AppTextStyles.headline(context).copyWith(
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimaryOf(context),
                              ),
                            ),
                            SizedBox(height: 24.h),
                            // Four Sections
                            GridView.count(
                              crossAxisCount: 2,
                              crossAxisSpacing: 20.w,
                              mainAxisSpacing: 20.h,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              childAspectRatio: 1.3,
                              children: [
                                // 1. الشؤون الإدارية والمالية (Blue)
                                _DashboardSectionCard(
                                  title: 'الشؤون الإدارية والمالية',
                                  icon: Icons.admin_panel_settings_rounded,
                                  gradient:
                                      AppColors.homeGradientAdministration,
                                  color: AppColors.homeAdministration,
                                  items: [
                                    DashboardItem(
                                      id: 'settings',
                                      icon: Icons.settings_rounded,
                                      label: 'الإعدادات',
                                    ),
                                    DashboardItem(
                                      id: 'employees',
                                      icon: Icons.badge_rounded,
                                      label: 'المستخدمين',
                                    ),
                                    DashboardItem(
                                      id: 'activity_log',
                                      icon: Icons.history_rounded,
                                      label: 'سجل النشاط',
                                    ),
                                    DashboardItem(
                                      id: 'cashier_shifts',
                                      icon: Icons.access_time_rounded,
                                      label: 'تقرير المناوبات',
                                    ),
                                    DashboardItem(
                                      id: 'profit_report',
                                      icon: Icons.trending_up_rounded,
                                      label: 'الربح / الخسارة',
                                    ),
                                  ],
                                  onItemSelected: _navigateToIndex,
                                ),
                                // 2. المخزون (Green/Tiffany)
                                _DashboardSectionCard(
                                  title: 'المخزون',
                                  icon: Icons.inventory_2_rounded,
                                  gradient: AppColors.homeGradientInventory,
                                  color: AppColors.homeInventory,
                                  items: [
                                    DashboardItem(
                                      id: 'add_item',
                                      icon: Icons.add_circle_rounded,
                                      label: 'إضافة صنف',
                                    ),
                                    DashboardItem(
                                      id: 'items_list',
                                      icon: Icons.medication_rounded,
                                      label: 'الأصناف',
                                    ),
                                    DashboardItem(
                                      id: 'barcode_label',
                                      icon: Icons.qr_code_rounded,
                                      label: 'ملصق باركود',
                                    ),
                                  ],
                                  onItemSelected: _navigateToIndex,
                                ),
                                // 3. المشتريات (Orange/Gold)
                                _DashboardSectionCard(
                                  title: 'المشتريات',
                                  icon: Icons.shopping_basket_rounded,
                                  gradient: AppColors.homeGradientPurchases,
                                  color: AppColors.homePurchases,
                                  items: [
                                    DashboardItem(
                                      id: 'purchase_order',
                                      icon: Icons.add_shopping_cart_rounded,
                                      label: 'إضافة شراء',
                                    ),
                                    DashboardItem(
                                      id: 'suppliers',
                                      icon: Icons.local_shipping_rounded,
                                      label: 'الموردين',
                                    ),
                                    DashboardItem(
                                      id: 'purchase_return',
                                      icon: Icons.undo_rounded,
                                      label: 'مرجع شراء',
                                    ),
                                    DashboardItem(
                                      id: 'accounting_expenses',
                                      icon: Icons.receipt_long_rounded,
                                      label: 'المصاريف',
                                    ),
                                  ],
                                  onItemSelected: _navigateToIndex,
                                ),
                                // 4. المبيعات (Dark Blue)
                                _DashboardSectionCard(
                                  title: 'المبيعات',
                                  icon: Icons.shopping_cart_rounded,
                                  gradient: AppColors.homeGradientSales,
                                  color: AppColors.homeSales,
                                  items: [
                                    DashboardItem(
                                      id: 'pos',
                                      icon: Icons.point_of_sale_rounded,
                                      label: 'الكاشير',
                                    ),
                                    DashboardItem(
                                      id: 'price_quotes',
                                      icon: Icons.request_quote_rounded,
                                      label: 'عروض الأسعار',
                                    ),
                                    DashboardItem(
                                      id: 'sales_report',
                                      icon: Icons.bar_chart_rounded,
                                      label: 'تقرير المبيعات',
                                    ),
                                    DashboardItem(
                                      id: 'sales_return',
                                      icon: Icons.keyboard_return_rounded,
                                      label: 'مرتجع',
                                    ),
                                    DashboardItem(
                                      id: 'customers',
                                      icon: Icons.people_rounded,
                                      label: 'الزبائن',
                                    ),
                                  ],
                                  onItemSelected: _navigateToIndex,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(
    BuildContext context,
    dynamic user,
    String today,
    ShellState state,
  ) {
    final isDark = AppColors.isDark(context);
    final scheme = Theme.of(context).colorScheme;

    return Container(
      height: 64.h,
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          bottom: BorderSide(
            color: AppColors.dividerOf(
              context,
            ).withValues(alpha: isDark ? 0.2 : 0.4),
          ),
        ),
      ),
      child: Row(
        children: [
          // Welcome Message
          Expanded(
            child: Row(
              children: [
                Icon(
                  Icons.waving_hand_rounded,
                  color: scheme.primary,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                ReusableText(
                  'أهلاً وسهلاً، ${user?.name ?? 'د. أحمد'}',
                  style: AppTextStyles.body(
                    context,
                  ).copyWith(fontWeight: FontWeight.w600),
                ),
                SizedBox(width: 16.w),
                Container(
                  width: 1.w,
                  height: 20.h,
                  color: AppColors.dividerOf(
                    context,
                  ).withValues(alpha: isDark ? 0.3 : 0.5),
                ),
                SizedBox(width: 16.w),
                ReusableText(
                  today,
                  style: AppTextStyles.caption(
                    context,
                  ).copyWith(color: AppColors.textSecondaryOf(context)),
                ),
              ],
            ),
          ),
          // Quick Action Buttons
          Row(
            children: [
              _HeaderActionButton(
                icon: Icons.point_of_sale_rounded,
                label: 'الكاشير',
                onTap: () => context.go(Routes.SALES_POS),
              ),
              SizedBox(width: 8.w),
              _HeaderActionButton(
                icon: Icons.notifications_rounded,
                label: 'الإشعارات',
                hasBadge: true,
                onTap: () => context.go(Routes.NOTIFICATIONS),
              ),
              SizedBox(width: 8.w),
              _HeaderActionButton(
                icon: Icons.calculate_rounded,
                label: 'الآلة الحاسبة',
                onTap: () => ReusableCalculator.show(context),
              ),
              SizedBox(width: 16.w),
              // User Avatar
              CircleAvatar(
                radius: 18.r,
                backgroundColor: scheme.primary,
                child: Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 20.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Dashboard Item Model
class DashboardItem {
  final String id;
  final IconData icon;
  final String label;

  const DashboardItem({
    required this.id,
    required this.icon,
    required this.label,
  });
}

// Dashboard Section Card
class _DashboardSectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Color> gradient;
  final Color color;
  final List<DashboardItem> items;
  final void Function(String id) onItemSelected;

  const _DashboardSectionCard({
    required this.title,
    required this.icon,
    required this.gradient,
    required this.color,
    required this.items,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppRadius.lg.r),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 24.sp),
                SizedBox(width: 12.w),
                ReusableText(
                  title,
                  style: AppTextStyles.body(context).copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15.sp,
                  ),
                ),
              ],
            ),
          ),
          // Items Grid
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(12.w),
              child: Wrap(
                alignment: WrapAlignment.start,
                spacing: 8.w,
                runSpacing: 8.h,
                children: items.map((item) {
                  return _DashboardItemButton(
                    item: item,
                    color: color,
                    onTap: () => onItemSelected(item.id),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Dashboard Item Button
class _DashboardItemButton extends StatefulWidget {
  final DashboardItem item;
  final Color color;
  final VoidCallback onTap;

  const _DashboardItemButton({
    required this.item,
    required this.color,
    required this.onTap,
  });

  @override
  State<_DashboardItemButton> createState() => _DashboardItemButtonState();
}

class _DashboardItemButtonState extends State<_DashboardItemButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        transform: Matrix4.diagonal3Values(
          _isHovered ? 1.05 : 1.0,
          _isHovered ? 1.05 : 1.0,
          1.0,
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.md.r),
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(AppRadius.md.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: widget.color.withValues(alpha: isDark ? 0.15 : 0.08),
                borderRadius: BorderRadius.circular(AppRadius.md.r),
                border: Border.all(
                  color: widget.color.withValues(alpha: isDark ? 0.3 : 0.2),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(widget.item.icon, color: widget.color, size: 16.sp),
                  SizedBox(width: 6.w),
                  ReusableText(
                    widget.item.label,
                    style: AppTextStyles.caption(context).copyWith(
                      color: widget.color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Header Action Button
class _HeaderActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool hasBadge;
  final VoidCallback onTap;

  const _HeaderActionButton({
    required this.icon,
    required this.label,
    this.hasBadge = false,
    required this.onTap,
  });

  @override
  State<_HeaderActionButton> createState() => _HeaderActionButtonState();
}

class _HeaderActionButtonState extends State<_HeaderActionButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          IconButton(
            onPressed: widget.onTap,
            icon: Icon(
              widget.icon,
              size: 20.sp,
              color: _isHovered
                  ? Theme.of(context).colorScheme.primary
                  : AppColors.textSecondaryOf(context),
            ),
            style: IconButton.styleFrom(
              backgroundColor: _isHovered
                  ? Theme.of(context).colorScheme.primary.withValues(
                      alpha: isDark ? 0.15 : 0.08,
                    )
                  : Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md.r),
              ),
            ),
          ),
          if (widget.hasBadge)
            Positioned(
              top: 8.r,
              right: 8.r,
              child: Container(
                width: 8.r,
                height: 8.r,
                decoration: BoxDecoration(
                  color: Colors.red.shade400,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).cardColor,
                    width: 2.w,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
