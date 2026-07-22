import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pharmacy_system/app/core/constants/app_strings.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_colors.dart';
import '../../../../routes/app_routes.dart';

class PosNavDrawer extends StatelessWidget {
  const PosNavDrawer({super.key});

  static const List<_NavItem> _items = [
    _NavItem(Icons.point_of_sale_rounded, AppStrings.saleScreenNav, Routes.SALES_POS),
    _NavItem(Icons.receipt_long_rounded, AppStrings.salesInvoicesNav, Routes.SALES_LIST),
    _NavItem(Icons.assignment_return_rounded, AppStrings.salesReturnNav, Routes.SALES_RETURN),
    _NavItem(Icons.confirmation_number_rounded, AppStrings.priceQuotes, Routes.PRICE_QUOTES),
    _NavItem(Icons.payments_rounded, AppStrings.shiftsNav, Routes.SALES_CASHIER_SHIFTS),
    _NavItem(Icons.inventory_2_rounded, AppStrings.inventoryNav, Routes.INVENTORY_LIST),
    _NavItem(Icons.local_shipping_rounded, AppStrings.purchasesNav, Routes.PURCHASE_LIST),
    _NavItem(Icons.people_alt_rounded, AppStrings.customersNav, Routes.CUSTOMERS),
    _NavItem(Icons.business_rounded, AppStrings.suppliersNav, Routes.SUPPLIERS),
    _NavItem(Icons.bar_chart_rounded, AppStrings.salesReportsNav, Routes.SALES_REPORT),
    _NavItem(Icons.account_balance_rounded, AppStrings.accountingNav, Routes.ACCOUNTING),
    _NavItem(Icons.settings_rounded, AppStrings.settings, Routes.SETTINGS),
    _NavItem(Icons.home_rounded, AppStrings.homeNav, Routes.HOME),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final router = GoRouter.of(context);
    return Drawer(
      width: 250.w,
      backgroundColor: scheme.surface,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
            color: AppColors.surfaceTintDarkAlt,
            child: Row(
              children: [
                const Icon(Icons.menu_rounded, color: Colors.white, size: 22),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    AppStrings.quickNavTooltip,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              itemCount: _items.length,
              separatorBuilder: (_, index) => Divider(height: 1, color: scheme.outline.withValues(alpha: 0.3)),
              itemBuilder: (_, i) {
                final item = _items[i];
                final isActive = GoRouterState.of(context).uri.path == item.route;
                return ListTile(
                  leading: Icon(
                    item.icon,
                    size: 20,
                    color: isActive ? scheme.primary : scheme.onSurfaceVariant,
                  ),
                  title: Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                      color: isActive ? scheme.primary : scheme.onSurface,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  selected: isActive,
                  selectedTileColor: scheme.primary.withValues(alpha: 0.08),
                  onTap: () {
                    router.go(item.route);
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  final String route;

  const _NavItem(this.icon, this.label, this.route);
}
