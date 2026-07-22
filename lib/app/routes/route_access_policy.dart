abstract final class RouteAccessPolicy {
  static const ownerOnlyDestinations = <String>{
    'admin/permissions',
    'admin/branches',
    'admin/employees',
    'admin/activity-log',
    'admin/archive',
    'admin/inventory/archive',
  };

  static String? permissionForRoute(String route) {
    if (route.contains('/admin/dashboard')) return 'dashboard';
    if (route.contains('/admin/employees')) return 'employees';
    if (route.contains('/admin/branches')) return 'branches';
    if (route.contains('/admin/permissions')) return 'permissions';
    if (route.contains('/admin/settings')) return 'settings';
    if (route.contains('/admin/profile')) return null;
    if (route.contains('/admin/document-control')) return 'settings';
    if (route.contains('/admin/archive')) return null;
    if (route.contains('/admin/activity-log')) return 'reports';
    if (route.contains('/admin/crm')) return 'crm';
    if (route.contains('/admin/tasks')) return 'tasks';
    if (route.contains('/admin/inventory/stocktaking')) return 'inventory';
    if (route.contains('/admin/void-operations')) return 'sales';

    // Accounting sub-routes
    if (route.contains('/admin/accounting')) return 'admin_panel';

    // HR sub-routes
    if (route.contains('/admin/hr')) return 'admin_panel';

    if (route.contains('/employee/')) return null;

    if (route.contains('/sales/pos')) return 'pos';
    if (route.contains('/sales/open-shift')) return 'pos';
    if (route.contains('/sales/cashier-shifts')) return 'pos';
    if (route.contains('/sales/list')) return 'sales';
    if (route.contains('/sales/details')) return 'sales';
    if (route.contains('/sales/return')) return 'sales';
    if (route.contains('/sales/quotes')) return 'sales';
    if (route.contains('/sales/import')) return 'sales';

    if (route.contains('/reports/')) return 'reports';

    if (route.contains('/sync-status')) return null;
    if (route.contains('/notifications')) return null;

    if (route.contains('/admin/contacts/customers')) return 'customers';
    if (route.contains('/admin/contacts/suppliers')) return 'suppliers';
    if (route.contains('/admin/contacts/customer-groups')) return 'customers';
    if (route.contains('/admin/contacts/supplier-customers')) return 'customers';
    if (route.contains('/admin/contacts/customer-suppliers')) return 'customers';

    if (route.contains('/admin/purchases/')) return 'purchases';

    if (route.contains('/admin/inventory/')) return 'inventory';

    return null;
  }
}
