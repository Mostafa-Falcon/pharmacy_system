import 'package:flutter/material.dart';
import 'package:pharmacy_system/app/core/constants/app_strings.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/shareds/sidebar.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_colors.dart';

List<SidebarGroup> getAdminSidebarGroups() {
  final user = AuthService.currentUser;
  if (user == null) return [];

  final groups = <SidebarGroup>[];

  // 1. ─── الرئيسية ───
  groups.add(
    const SidebarGroup(
      id: 'group_main',
      label: AppStrings.mainPageTitle,
      icon: Icons.dashboard_customize_rounded,
      children: [
        SidebarItem(
          id: 'main_page',
          icon: Icons.home_rounded,
          label: AppStrings.mainPageTitle,
        ),
        SidebarItem(
          id: 'admin_dashboard',
          icon: Icons.analytics_rounded,
          label: AppStrings.sidebarDashboard,
        ),
      ],
    ),
  );

  // 2. ─── إدارة المبيعات ───
  if (AuthService.hasPermission('sales.view')) {
    groups.add(
      const SidebarGroup(
        id: 'group_sales',
        label: AppStrings.sidebarGroupSales,
        icon: Icons.point_of_sale_rounded,
        color: AppHomeColors.sales,
        children: [
          SidebarItem(
            id: 'pos',
            icon: Icons.shopping_cart_rounded,
            label: AppStrings.sidebarPos,
          ),
          SidebarItem(
            id: 'cashier_shifts',
            icon: Icons.access_time_rounded,
            label: AppStrings.sidebarCashierShifts,
          ),
          SidebarItem(
            id: 'sales_invoice',
            icon: Icons.description_rounded,
            label: AppStrings.sidebarSalesInvoices,
          ),
          SidebarItem(
            id: 'sales_return',
            icon: Icons.currency_exchange_rounded,
            label: AppStrings.sidebarSalesReturns,
          ),
          SidebarItem(
            id: 'free_return',
            icon: Icons.assignment_return_rounded,
            label: 'مرتجع حر',
          ),
          SidebarItem(
            id: 'price_quotes',
            icon: Icons.sell_outlined,
            label: AppStrings.sidebarPriceQuotes,
          ),
          SidebarItem(
            id: 'contacts_sales',
            icon: Icons.contacts_outlined,
            label: AppStrings.sidebarItemCustomersContacts,
            children: [
              SidebarItem(
                id: 'customers',
                icon: Icons.group_outlined,
                label: AppStrings.sidebarItemCustomerDirectory,
              ),
              SidebarItem(
                id: 'customer_groups',
                icon: Icons.group_work_outlined,
                label: AppStrings.sidebarCustomerGroups,
              ),
              SidebarItem(
                id: 'crm',
                icon: Icons.trending_up_rounded,
                label: AppStrings.sidebarCrm,
              ),
              SidebarItem(
                id: 'supplier_customers',
                icon: Icons.swap_horiz_rounded,
                label: AppStrings.sidebarSupplierCustomers,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 3. ─── المشتريات ───
  if (AuthService.hasPermission('purchases.view')) {
    groups.add(
      const SidebarGroup(
        id: 'group_purchases',
        label: AppStrings.sidebarGroupPurchases,
        icon: Icons.shopping_bag_rounded,
        color: AppHomeColors.purchases,
        children: [
          SidebarItem(
            id: 'purchase_order',
            icon: Icons.add_shopping_cart_rounded,
            label: AppStrings.sidebarNewPurchase,
          ),
          SidebarItem(
            id: 'purchase_invoice',
            icon: Icons.receipt_rounded,
            label: AppStrings.sidebarPurchaseInvoices,
          ),
          SidebarItem(
            id: 'purchase_return',
            icon: Icons.inventory_rounded,
            label: AppStrings.sidebarPurchaseReturns,
          ),
          SidebarItem(
            id: 'suppliers',
            icon: Icons.business_outlined,
            label: AppStrings.sidebarSuppliers,
          ),
        ],
      ),
    );
  }

  // 4. ─── الأدوية والمخزون ───
  if (AuthService.hasPermission('inventory.view')) {
    groups.add(
      SidebarGroup(
        id: 'group_inventory',
        label: AppStrings.sidebarGroupInventory,
        icon: Icons.medication_rounded,
        color: AppHomeColors.inventory,
        children: [
          const SidebarItem(
            id: 'items_list',
            icon: Icons.list_alt_rounded,
            label: AppStrings.sidebarItemsList,
          ),
          const SidebarItem(
            id: 'inventory_health',
            icon: Icons.health_and_safety_outlined,
            label: AppStrings.sidebarInventoryHealth,
          ),
          const SidebarItem(
            id: 'inventory_stocktaking',
            icon: Icons.inventory_2_rounded,
            label: AppStrings.sidebarItemStocktaking,
          ),
          SidebarItem(
            id: 'inventory_tools',
            icon: Icons.build_circle_outlined,
            label: AppStrings.sidebarItemInventoryTools,
            children: [
              const SidebarItem(
                id: 'add_item',
                icon: Icons.add_circle_outline_rounded,
                label: AppStrings.sidebarAddItem,
              ),
              const SidebarItem(
                id: 'barcode_label',
                icon: Icons.document_scanner_outlined,
                label: AppStrings.sidebarBarcodeLabel,
              ),
              const SidebarItem(
                id: 'inventory_stock_transfer',
                icon: Icons.swap_horiz_rounded,
                label: AppStrings.sidebarItemStockTransfer,
              ),
              const SidebarItem(
                id: 'stock_adjustment',
                icon: Icons.tune_rounded,
                label: AppStrings.sidebarItemStockAdjustment,
              ),
              const SidebarItem(
                id: 'bulk_price_update',
                icon: Icons.price_change_rounded,
                label: AppStrings.sidebarItemBulkPriceUpdate,
              ),
              const SidebarItem(
                id: 'inventory_promotions',
                icon: Icons.local_offer_rounded,
                label: AppStrings.sidebarItemPromotions,
              ),
              const SidebarItem(
                id: 'inventory_import',
                icon: Icons.file_upload_outlined,
                label: AppStrings.sidebarItemImportItems,
              ),
              const SidebarItem(
                id: 'items_archive',
                icon: Icons.archive_outlined,
                label: AppStrings.sidebarItemItemsArchive,
              ),
            ],
          ),
          SidebarItem(
            id: 'inventory_settings',
            icon: Icons.settings_applications_outlined,
            label: AppStrings.sidebarItemInventorySettings,
            children: [
              const SidebarItem(
                id: 'brands',
                icon: Icons.branding_watermark_rounded,
                label: AppStrings.sidebarItemBrands,
              ),
              const SidebarItem(
                id: 'price_groups',
                icon: Icons.attach_money_rounded,
                label: AppStrings.sidebarItemPriceGroups,
              ),
              const SidebarItem(
                id: 'variants',
                icon: Icons.category_rounded,
                label: AppStrings.sidebarItemVariants,
              ),
              const SidebarItem(
                id: 'barcode_settings',
                icon: Icons.settings_rounded,
                label: AppStrings.sidebarBarcodeSettings,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 5. ─── التقارير والمالية ───
  final reportItems = <SidebarItem>[];
  if (AuthService.hasPermission('reports.view')) {
    reportItems.add(
      const SidebarItem(
        id: 'reports_hub',
        icon: Icons.analytics_rounded,
        label: AppStrings.sidebarItemReportsHub,
        children: [
          SidebarItem(
            id: 'sales_report',
            icon: Icons.bar_chart_rounded,
            label: AppStrings.sidebarSalesReport,
          ),
          SidebarItem(
            id: 'profit_report',
            icon: Icons.monetization_on_rounded,
            label: AppStrings.sidebarProfitReport,
          ),
          SidebarItem(
            id: 'purchase_report',
            icon: Icons.trending_up_rounded,
            label: AppStrings.sidebarPurchaseReport,
          ),
          SidebarItem(
            id: 'contacts_report',
            icon: Icons.contacts_rounded,
            label: AppStrings.sidebarContactsReport,
          ),
          SidebarItem(
            id: 'extra_reports',
            icon: Icons.assessment_rounded,
            label: AppStrings.sidebarItemExtraReports,
          ),
          SidebarItem(
            id: 'advanced_ledger_report',
            icon: Icons.book_rounded,
            label: AppStrings.sidebarItemAdvancedLedger,
          ),
        ],
      ),
    );
  }

  if (AuthService.hasPermission('admin_panel')) {
    reportItems.add(
      const SidebarItem(
        id: 'accounting_hub',
        icon: Icons.account_balance_rounded,
        label: AppStrings.sidebarItemAccounting,
        children: [
          SidebarItem(
            id: 'accounting',
            icon: Icons.dashboard_rounded,
            label: AppStrings.sidebarItemAccountingDashboard,
          ),
          SidebarItem(
            id: 'hr',
            icon: Icons.people_outline_rounded,
            label: AppStrings.sidebarItemHr,
          ),
        ],
      ),
    );
  }

  if (reportItems.isNotEmpty) {
    groups.add(
      SidebarGroup(
        id: 'group_reports',
        label: AppStrings.sidebarGroupReports,
        icon: Icons.bar_chart_rounded,
        color: AppHomeColors.administration,
        children: reportItems,
      ),
    );
  }

  // 6. ─── الإدارة والنظام ───
  final adminChildren = <SidebarItem>[
    const SidebarItem(
      id: 'settings',
      icon: Icons.settings_rounded,
      label: AppStrings.sidebarSettings,
    ),
    const SidebarItem(
      id: 'admin_tools',
      icon: Icons.admin_panel_settings_rounded,
      label: AppStrings.sidebarItemAdminTools,
      children: [
        SidebarItem(
          id: 'employees',
          icon: Icons.people_rounded,
          label: AppStrings.sidebarEmployees,
        ),
        SidebarItem(
          id: 'branches',
          icon: Icons.store_rounded,
          label: AppStrings.sidebarBranches,
        ),
        SidebarItem(
          id: 'permissions',
          icon: Icons.security_rounded,
          label: AppStrings.sidebarPermissions,
        ),
        SidebarItem(
          id: 'tasks',
          icon: Icons.task_alt_rounded,
          label: AppStrings.sidebarItemAdminTasks,
        ),
        SidebarItem(
          id: 'void_operations',
          icon: Icons.block_rounded,
          label: AppStrings.sidebarItemVoidOperations,
        ),
        SidebarItem(
          id: 'document_control',
          icon: Icons.folder_open_rounded,
          label: AppStrings.sidebarDocumentControl,
        ),
        SidebarItem(
          id: 'activity_log',
          icon: Icons.assignment_outlined,
          label: AppStrings.sidebarActivityLog,
        ),
      ],
    ),
  ];

  if (user.isOwner) {
    adminChildren.add(
      const SidebarItem(
        id: 'advanced_archive',
        icon: Icons.archive_outlined,
        label: AppStrings.sidebarAdvancedArchive,
      ),
    );
  }

  adminChildren.addAll([
    const SidebarItem(
      id: 'profile',
      icon: Icons.person_rounded,
      label: AppStrings.sidebarProfile,
    ),
    const SidebarItem(
      id: 'notifications',
      icon: Icons.notifications_rounded,
      label: AppStrings.sidebarItemNotifications,
    ),
    const SidebarItem(
      id: 'sync_status',
      icon: Icons.sync_rounded,
      label: AppStrings.sidebarItemSyncStatus,
    ),
  ]);

  groups.add(
    SidebarGroup(
      id: 'group_admin',
      label: AppStrings.sidebarGroupAdmin,
      icon: Icons.settings_applications_rounded,
      children: adminChildren,
    ),
  );

  return groups;
}
