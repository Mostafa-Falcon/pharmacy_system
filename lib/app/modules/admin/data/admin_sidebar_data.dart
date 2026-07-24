import 'package:flutter/material.dart';
import 'package:pharmacy_system/app/core/constants/app_strings.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/layouts/sidebar.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_colors.dart';

List<SidebarGroup> getAdminSidebarGroups() {
  final user = AuthService.currentUser;
  if (user == null) return [];

  final groups = <SidebarGroup>[];

  // 1. ─── الرئيسية ───
  groups.add(
    const SidebarGroup(
      id: 'group_main',
      label: HomeStrings.mainPageTitle,
      icon: Icons.home_rounded,
      children: [
        SidebarItem(
          id: 'main_page',
          icon: Icons.home_rounded,
          label: HomeStrings.mainPageTitle,
        ),
      ],
    ),
  );

  // 2. ─── لوحة المتابعة ───
  groups.add(
    const SidebarGroup(
      id: 'group_dashboard',
      label: HomeStrings.sidebarDashboard,
      icon: Icons.show_chart_rounded,
      children: [
        SidebarItem(
          id: 'admin_dashboard',
          icon: Icons.show_chart_rounded,
          label: HomeStrings.sidebarDashboard,
        ),
      ],
    ),
  );

  // 3. ─── الأصناف (Flattened) ───
  if (AuthService.hasPermission('inventory.view')) {
    groups.add(
      const SidebarGroup(
        id: 'group_inventory',
        label: AdminStrings.sidebarGroupInventory,
        icon: Icons.inventory_2_rounded,
        color: AppHomeColors.inventory,
        children: [
          SidebarItem(
            id: 'add_item',
            icon: Icons.add_circle_outline_rounded,
            label: HomeStrings.sidebarAddItem,
          ),
          SidebarItem(
            id: 'items_list',
            icon: Icons.list_alt_rounded,
            label: HomeStrings.sidebarItemsList,
          ),
          SidebarItem(
            id: 'inventory_health',
            icon: Icons.health_and_safety_outlined,
            label: HomeStrings.sidebarInventoryHealth,
          ),
          SidebarItem(
            id: 'inventory_stocktaking',
            icon: Icons.inventory_2_rounded,
            label: AdminStrings.sidebarItemStocktaking,
          ),
          SidebarItem(
            id: 'barcode_label',
            icon: Icons.document_scanner_outlined,
            label: HomeStrings.sidebarBarcodeLabel,
          ),
          SidebarItem(
            id: 'units',
            icon: Icons.straighten_rounded,
            label: InventoryStrings.sidebarItemItemUnits,
          ),
          SidebarItem(
            id: 'groups',
            icon: Icons.category_outlined,
            label: InventoryStrings.sidebarItemItemGroups,
          ),
          SidebarItem(
            id: 'bulk_price_update',
            icon: Icons.price_change_rounded,
            label: AdminStrings.sidebarItemBulkPriceUpdate,
          ),
          SidebarItem(
            id: 'price_groups',
            icon: Icons.attach_money_rounded,
            label: AdminStrings.sidebarItemPriceGroups,
          ),
          SidebarItem(
            id: 'brands',
            icon: Icons.branding_watermark_rounded,
            label: AdminStrings.sidebarItemBrands,
          ),
          SidebarItem(
            id: 'warranties',
            icon: Icons.security_rounded,
            label: InventoryStrings.sidebarItemItemWarranties,
          ),
          SidebarItem(
            id: 'variants',
            icon: Icons.category_rounded,
            label: AdminStrings.sidebarItemVariants,
          ),
          SidebarItem(
            id: 'inventory_import',
            icon: Icons.file_upload_outlined,
            label: AdminStrings.sidebarItemImportItems,
          ),
          SidebarItem(
            id: 'opening_stock',
            icon: Icons.input_rounded,
            label: InventoryStrings.sidebarItemImportOpeningStock,
          ),
          SidebarItem(
            id: 'inventory_stock_transfer',
            icon: Icons.swap_horiz_rounded,
            label: InventoryStrings.sidebarItemSwapItems,
          ),
        ],
      ),
    );
  }

  // 4. ─── المبيعات ───
  if (AuthService.hasPermission('sales.view')) {
    groups.add(
      SidebarGroup(
        id: 'group_sales',
        label: AdminStrings.sidebarGroupSales,
        icon: Icons.shopping_cart_rounded,
        color: AppHomeColors.sales,
        children: [
          SidebarItem(
            id: 'pos',
            icon: Icons.shopping_cart_rounded,
            label: HomeStrings.sidebarPos,
          ),
          const SidebarItem(
            id: 'cashier_shifts',
            icon: Icons.access_time_rounded,
            label: HomeStrings.sidebarCashierShifts,
          ),
          const SidebarItem(
            id: 'sales_invoice',
            icon: Icons.description_rounded,
            label: HomeStrings.sidebarSalesInvoices,
          ),
          const SidebarItem(
            id: 'sales_return',
            icon: Icons.currency_exchange_rounded,
            label: HomeStrings.sidebarSalesReturns,
          ),
          const SidebarItem(
            id: 'price_quotes',
            icon: Icons.sell_outlined,
            label: HomeStrings.sidebarPriceQuotes,
          ),
          const SidebarItem(
            id: 'customers',
            icon: Icons.group_outlined,
            label: HomeStrings.sidebarCustomers,
          ),
        ],
      ),
    );
  }

  // 5. ─── المشتريات ───
  if (AuthService.hasPermission('purchases.view')) {
    groups.add(
      const SidebarGroup(
        id: 'group_purchases',
        label: AdminStrings.sidebarGroupPurchases,
        icon: Icons.file_download_outlined,
        color: AppHomeColors.purchases,
        children: [
          SidebarItem(
            id: 'purchase_order',
            icon: Icons.add_shopping_cart_rounded,
            label: HomeStrings.sidebarNewPurchase,
          ),
          SidebarItem(
            id: 'purchase_invoice',
            icon: Icons.receipt_rounded,
            label: HomeStrings.sidebarPurchaseInvoices,
          ),
          SidebarItem(
            id: 'purchase_return',
            icon: Icons.inventory_rounded,
            label: HomeStrings.sidebarPurchaseReturns,
          ),
          SidebarItem(
            id: 'suppliers',
            icon: Icons.business_outlined,
            label: HomeStrings.sidebarSuppliers,
          ),
        ],
      ),
    );
  }

  // 6. ─── المستخدمين ───
  if (AuthService.hasPermission('admin_panel')) {
    groups.add(
      SidebarGroup(
        id: 'group_users',
        label: 'المستخدمين',
        icon: Icons.people_outline_rounded,
        children: [
          SidebarItem(
            id: 'employees',
            icon: Icons.people_rounded,
            label: HomeStrings.sidebarEmployees,
          ),
          const SidebarItem(
            id: 'permissions',
            icon: Icons.security_rounded,
            label: HomeStrings.sidebarPermissions,
          ),
        ],
      ),
    );
  }

  // 7. ─── إدارة الحسابات ───
  if (AuthService.hasPermission('admin_panel')) {
    groups.add(
      const SidebarGroup(
        id: 'group_accounting',
        label: AdminStrings.sidebarItemAccounting,
        icon: Icons.menu_book_rounded,
        children: [
          SidebarItem(
            id: 'accounting',
            icon: Icons.dashboard_rounded,
            label: AdminStrings.sidebarItemAccountingDashboard,
          ),
          SidebarItem(
            id: 'expenses',
            icon: Icons.money_off_rounded,
            label: AccountingStrings.accountingExpenses,
          ),
          SidebarItem(
            id: 'journal',
            icon: Icons.list_alt_rounded,
            label: AccountingStrings.accountingJournal,
          ),
        ],
      ),
    );
  }

  // 8. ─── التقارير ───
  if (AuthService.hasPermission('reports.view')) {
    groups.add(
      const SidebarGroup(
        id: 'group_reports',
        label: HomeStrings.sidebarReports,
        icon: Icons.bar_chart_rounded,
        children: [
          SidebarItem(
            id: 'reports_hub',
            icon: Icons.analytics_rounded,
            label: AdminStrings.sidebarItemReportsHub,
          ),
          SidebarItem(
            id: 'sales_report',
            icon: Icons.bar_chart_rounded,
            label: HomeStrings.sidebarSalesReport,
          ),
          SidebarItem(
            id: 'profit_report',
            icon: Icons.monetization_on_rounded,
            label: HomeStrings.sidebarProfitReport,
          ),
        ],
      ),
    );
  }

  // 9. ─── الموارد البشرية ───
  if (AuthService.hasPermission('admin_panel')) {
    groups.add(
      const SidebarGroup(
        id: 'group_hr',
        label: AdminStrings.sidebarItemHr,
        icon: Icons.access_time_rounded,
        children: [
          SidebarItem(
            id: 'hr_attendance',
            icon: Icons.how_to_reg_rounded,
            label: HrStrings.hrAttendance,
          ),
          SidebarItem(
            id: 'hr_payroll',
            icon: Icons.payments_rounded,
            label: HrStrings.hrPayroll,
          ),
          SidebarItem(
            id: 'hr_departments',
            icon: Icons.business_rounded,
            label: HrStrings.hrDepartments,
          ),
        ],
      ),
    );
  }

  // 10. ─── السجلات الممسوحة ───
  groups.add(
    const SidebarGroup(
      id: 'group_void_logs',
      label: HomeStrings.sidebarActivityLog,
      icon: Icons.delete_outline_rounded,
      children: [
        SidebarItem(
          id: 'void_operations',
          icon: Icons.block_rounded,
          label: AdminStrings.sidebarItemVoidOperations,
        ),
      ],
    ),
  );

  // 11. ─── الإعدادات ───
  groups.add(
    const SidebarGroup(
      id: 'group_settings',
      label: HomeStrings.sidebarSettings,
      icon: Icons.settings_outlined,
      children: [
        SidebarItem(
          id: 'settings',
          icon: Icons.settings_rounded,
          label: HomeStrings.sidebarSettings,
        ),
        SidebarItem(
          id: 'branches',
          icon: Icons.store_rounded,
          label: HomeStrings.sidebarBranches,
        ),
        SidebarItem(
          id: 'sync_status',
          icon: Icons.sync_rounded,
          label: AdminStrings.sidebarItemSyncStatus,
        ),
      ],
    ),
  );

  return groups;
}





