import 'package:flutter/material.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/shared/ui_core.dart';

List<SidebarGroup> getEmployeeSidebarGroups() {
  final user = AuthService.currentUser;
  if (user == null) return [];

  final groups = <SidebarGroup>[];

  // 1. ─── الرئيسية ───
  groups.add(
    const SidebarGroup(
      id: 'group_main',
      label: 'الرئيسية',
      icon: Icons.dashboard_customize_rounded,
      children: [
        SidebarItem(
          id: 'main_page',
          icon: Icons.home_rounded,
          label: 'الصفحة الرئيسية',
        ),
        SidebarItem(
          id: 'employee_dashboard',
          icon: Icons.analytics_rounded,
          label: 'لوحة المتابعة',
        ),
      ],
    ),
  );

  // 2. ─── المبيعات ───
  final salesItems = <SidebarItem>[];
  if (AuthService.hasPermission('sales.view')) {
    salesItems.addAll([
      const SidebarItem(
        id: 'pos',
        icon: Icons.shopping_cart_rounded,
        label: 'نقطة البيع',
      ),
      const SidebarItem(
        id: 'cashier_shifts',
        icon: Icons.access_time_rounded,
        label: 'ورديات الكاشير',
      ),
      const SidebarItem(
        id: 'sales_invoice',
        icon: Icons.description_rounded,
        label: 'فواتير المبيعات',
      ),
      const SidebarItem(
        id: 'sales_return',
        icon: Icons.currency_exchange_rounded,
        label: 'مرتجعات المبيعات',
      ),
    ]);
  }

  if (salesItems.isNotEmpty) {
    groups.add(
      SidebarGroup(
        id: 'group_sales',
        label: 'المبيعات',
        icon: Icons.point_of_sale_rounded,
        color: AppHomeColors.sales,
        children: salesItems,
      ),
    );
  }

  // 3. ─── المشتريات ───
  final purchaseItems = <SidebarItem>[];
  if (AuthService.hasPermission('purchases.view')) {
    purchaseItems.addAll([
      const SidebarItem(
        id: 'purchase_order',
        icon: Icons.add_shopping_cart_rounded,
        label: 'فاتورة شراء جديدة',
      ),
      const SidebarItem(
        id: 'purchase_return',
        icon: Icons.inventory_rounded,
        label: 'مرتجعات المشتريات',
      ),
    ]);
  }

  if (purchaseItems.isNotEmpty) {
    groups.add(
      SidebarGroup(
        id: 'group_purchases',
        label: 'المشتريات',
        icon: Icons.shopping_bag_rounded,
        color: AppHomeColors.purchases,
        children: purchaseItems,
      ),
    );
  }

  // 4. ─── الأدوية والمخزون ───
  final inventoryItems = <SidebarItem>[];
  if (AuthService.hasPermission('inventory.view')) {
    inventoryItems.addAll([
      const SidebarItem(
        id: 'items_list',
        icon: Icons.list_alt_rounded,
        label: 'قائمة الأدوية',
      ),
      const SidebarItem(
        id: 'inventory_health',
        icon: Icons.health_and_safety_outlined,
        label: 'حالة المخزون',
      ),
    ]);
  }

  if (inventoryItems.isNotEmpty) {
    groups.add(
      SidebarGroup(
        id: 'group_inventory',
        label: 'الأدوية والمخزون',
        icon: Icons.medication_rounded,
        color: AppHomeColors.inventory,
        children: inventoryItems,
      ),
    );
  }

  // 5. ─── جهات الاتصال ───
  final contactItems = <SidebarItem>[];
  if (AuthService.hasPermission('contacts.view')) {
    contactItems.addAll([
      const SidebarItem(
        id: 'customers',
        icon: Icons.group_outlined,
        label: 'العملاء',
      ),
      const SidebarItem(
        id: 'suppliers',
        icon: Icons.business_outlined,
        label: 'الموردين',
      ),
      const SidebarItem(
        id: 'supplier_customers',
        icon: Icons.swap_horiz_rounded,
        label: 'موردين/عملاء',
      ),
    ]);
  }

  if (contactItems.isNotEmpty) {
    groups.add(
      SidebarGroup(
        id: 'group_contacts',
        label: 'جهات الاتصال',
        icon: Icons.contacts_rounded,
        color: AppHomeColors.administration,
        children: contactItems,
      ),
    );
  }

  // 6. ─── النظام ───
  groups.add(
    const SidebarGroup(
      id: 'group_system',
      label: 'النظام',
      icon: Icons.settings_applications_rounded,
      children: [
        SidebarItem(
          id: 'profile',
          icon: Icons.person_rounded,
          label: 'الملف الشخصي',
        ),
        SidebarItem(
          id: 'notifications',
          icon: Icons.notifications_rounded,
          label: 'الإشعارات',
        ),
        SidebarItem(
          id: 'sync_status',
          icon: Icons.sync_rounded,
          label: 'حالة المزامنة',
        ),
      ],
    ),
  );

  return groups;
}
