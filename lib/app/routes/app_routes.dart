// ignore_for_file: constant_identifier_names

abstract class Routes {
  Routes._();

  static const SPLASH = '/splash';
  static const LOGIN = '/login';
  static const FORGOT_PASSWORD = '/forgot-password';
  static const SIGNUP = '/register';
  static const AUTH_CALLBACK = '/auth/callback';
  static const ADMIN_DASHBOARD = '/admin/dashboard';
  static const EMPLOYEES = '/admin/employees';
  static const BRANCHES = '/admin/branches';
  static const PERMISSIONS = '/admin/permissions';
  static const SETTINGS = '/admin/settings';
  static const PROFILE = '/admin/profile';
  static const EMPLOYEE_DASHBOARD = '/employee/dashboard';
  static const HOME = '/home';
  static const MAIN_PAGE = '/home/main-page';
  static const MONITORING_DASHBOARD = '/home/monitoring';

  // ─── Sales / Cashier ───
  static const SALES_POS = '/sales/pos';
  static const SALES_LIST = '/sales/list';
  static const SALES_IMPORT = '/sales/import';
  static const SALES_DETAILS = '/sales/details';
  static const SALES_RETURN = '/sales/return';
  static const SALES_OPEN_SHIFT = '/sales/open-shift';
  static const SALES_CASHIER_SHIFTS = '/sales/cashier-shifts';
  static const SALES_REPORT = '/reports/sales';
  static const CONTACTS_REPORT = '/reports/contacts';
  static const PURCHASE_REPORT = '/reports/purchases';
  static const PROFIT_REPORT = '/reports/profit';
  static const EXTRA_REPORTS = '/reports/extra';
  static const ADVANCED_LEDGER_REPORT = '/reports/ledger';
  static const NOTIFICATIONS = '/notifications';
  static const SYNC_STATUS = '/sync-status';
  static const TASKS = '/admin/tasks';
  static const STOCKTAKING = '/admin/inventory/stocktaking';
  static const STOCKTAKING_DETAIL = '/admin/inventory/stocktaking/detail';
  static const VOID_OPERATIONS = '/admin/void-operations';
  static const CRM = '/admin/crm';
  static const PRICE_QUOTES = '/sales/quotes';

  static const INVENTORY_LIST = '/admin/inventory/list';
  static const INVENTORY_ADD = '/admin/inventory/add';
  static const INVENTORY_EDIT = '/admin/inventory/edit/:id';
  static const INVENTORY_HEALTH = '/admin/inventory/health';
  static const INVENTORY_STOCK_ADJUSTMENT = '/admin/inventory/stock-adjustment';
  static const INVENTORY_ARCHIVE = '/admin/inventory/archive';
  static const INVENTORY_IMPORT = '/admin/inventory/import';
  static const INVENTORY_IMPORT_PRODUCTS = '/admin/inventory/import/products';
  static const STOCK_TRANSFER = '/admin/inventory/stock-transfer';
  static const STOCK_TRANSFER_ADD = '/admin/inventory/stock-transfer/add';
  static const BRANDS = '/admin/inventory/brands';
  static const PRICE_GROUPS = '/admin/inventory/price-groups';
  static const VARIANTS = '/admin/inventory/variants';
  static const INVENTORY_BULK_PRICE_UPDATE = '/admin/inventory/bulk-price-update';
  static const INVENTORY_PROMOTIONS = '/admin/inventory/promotions';

  // ─── Purchases ───
  static const PURCHASE_LIST = '/admin/purchases/list';
  static const PURCHASE_ADD = '/admin/purchases/add';
  static const PURCHASE_DETAILS = '/admin/purchases/details';
  static const PURCHASE_RETURN = '/admin/purchases/returns';
  static const PURCHASE_RETURN_ADD = '/admin/purchases/returns/add';
  static const FREE_RETURN = '/admin/returns/free';

  // ─── Accounting ───
  static const ACCOUNTING = '/admin/accounting';
  static const ACCOUNTING_ACCOUNTS = '/admin/accounting/accounts';
  static const ACCOUNTING_JOURNAL = '/admin/accounting/journal';
  static const ACCOUNTING_EXPENSES = '/admin/accounting/expenses';
  static const ACCOUNTING_EXPENSES_IMPORT = '/admin/accounting/expenses/import';
  static const ACCOUNTING_PAYMENTS = '/admin/accounting/payments';

  // ─── HR ───
  static const HR = '/admin/hr';
  static const HR_EMPLOYEES = '/admin/hr/employees';
  static const HR_ATTENDANCE = '/admin/hr/attendance';
  static const HR_LEAVE = '/admin/hr/leave';
  static const HR_PAYROLL = '/admin/hr/payroll';
  static const HR_DEPARTMENTS = '/admin/hr/departments';

  // ─── Barcodes ───
  static const BARCODE_LABELS = '/admin/inventory/barcodes';
  static const BARCODE_SETTINGS = '/admin/inventory/barcodes/settings';

  // ─── Contacts ───
  static const CUSTOMERS = '/admin/contacts/customers';
  static const CUSTOMERS_IMPORT = '/admin/contacts/customers/import';
  static const CUSTOMER_ADD = '/admin/contacts/customers/add';
  static const SUPPLIERS = '/admin/contacts/suppliers';
  static const SUPPLIERS_IMPORT = '/admin/contacts/suppliers/import';
  static const SUPPLIER_ADD = '/admin/contacts/suppliers/add';
  static const CUSTOMER_GROUPS = '/admin/contacts/customer-groups';
  static const SUPPLIER_CUSTOMERS = '/admin/contacts/supplier-customers';
  static const SUPPLIER_CUSTOMER_ADD = '/admin/contacts/supplier-customers/add';
  static const DOCUMENT_CONTROL = '/admin/document-control';
  static const ARCHIVE = '/admin/archive';
  static const ACTIVITY_LOG = '/admin/activity-log';

  /// Maps route path → sidebar destination ID
  static const Map<String, String> routeToDestination = {
    '/admin/accounting': 'accounting',
    '/admin/accounting/accounts': 'accounting',
    '/admin/accounting/journal': 'accounting',
    '/admin/accounting/expenses': 'accounting',
    '/admin/accounting/expenses/import': 'accounting',
    '/admin/accounting/payments': 'accounting',
    '/admin/dashboard': 'admin_dashboard',
    '/admin/employees': 'employees',
    '/admin/branches': 'branches',
    '/admin/permissions': 'permissions',
    '/admin/settings': 'settings',
    '/admin/profile': 'profile',
    '/employee/dashboard': 'employee_dashboard',
    '/home': 'main_page',
    '/home/main-page': 'main_page',
    '/home/monitoring': 'main_page',
    '/sales/pos': 'pos',
    '/sales/cashier-shifts': 'cashier_shifts',
    '/sales/list': 'sales_invoice',
    '/sales/import': 'sales_invoice',
    '/sales/details': 'sales_invoice',
    '/sales/return': 'sales_return',
    '/sales/quotes': 'price_quotes',
    '/admin/inventory/list': 'items_list',
    '/admin/inventory/add': 'add_item',
    '/admin/inventory/edit': 'items_list',
    '/admin/inventory/health': 'inventory_health',
    '/admin/purchases/list': 'purchase_invoice',
    '/admin/purchases/add': 'purchase_order',
    '/admin/purchases/details': 'purchase_invoice',
    '/admin/purchases/returns': 'purchase_return',
    '/admin/purchases/returns/add': 'purchase_return',
    '/admin/returns/free': 'free_return',
    '/admin/inventory/barcodes': 'barcode_label',
    '/admin/inventory/barcodes/settings': 'barcode_settings',
    '/admin/inventory/archive': 'items_archive',
    '/admin/inventory/import': 'inventory_import',
    '/admin/inventory/import/products': 'inventory_import',
    '/admin/inventory/stock-transfer': 'inventory_stock_transfer',
    '/admin/inventory/stock-transfer/add': 'inventory_stock_transfer',
    '/admin/inventory/brands': 'brands',
    '/admin/inventory/price-groups': 'price_groups',
    '/admin/inventory/variants': 'variants',
    '/admin/inventory/stock-adjustment': 'stock_adjustment',
    '/admin/inventory/bulk-price-update': 'bulk_price_update',
    '/admin/inventory/promotions': 'inventory_promotions',
    '/admin/contacts/customers': 'customers',
    '/admin/contacts/customers/import': 'customers',
    '/admin/contacts/suppliers': 'suppliers',
    '/admin/contacts/suppliers/import': 'suppliers',
    '/admin/contacts/customer-groups': 'customer_groups',
    '/admin/contacts/supplier-customers': 'supplier_customers',
    '/admin/document-control': 'document_control',
    '/admin/archive': 'advanced_archive',
    '/admin/activity-log': 'activity_log',
    '/admin/hr': 'hr',
    '/admin/hr/employees': 'hr',
    '/admin/hr/attendance': 'hr',
    '/admin/hr/leave': 'hr',
    '/admin/hr/payroll': 'hr',
    '/admin/hr/departments': 'hr',
    '/reports/sales': 'sales_report',
    '/reports/contacts': 'contacts_report',
    '/reports/purchases': 'purchase_report',
    '/reports/profit': 'profit_report',
    '/reports/extra': 'extra_reports',
    '/reports/ledger': 'advanced_ledger_report',
    '/admin/crm': 'crm',
    '/admin/tasks': 'tasks',
    '/admin/inventory/stocktaking': 'inventory_stocktaking',
    '/admin/inventory/stocktaking/detail': 'inventory_stocktaking',
    '/admin/void-operations': 'void_operations',
  };

  /// Maps sidebar destination ID → route path
  static const Map<String, String> destinationToRoute = {
    'hr': '/admin/hr',
    'accounting': '/admin/accounting',
    'employees': '/admin/employees',
    'branches': '/admin/branches',
    'permissions': '/admin/permissions',
    'settings': '/admin/settings',
    'profile': '/admin/profile',
    'employee_dashboard': '/employee/dashboard',
    'home': '/home',
    'admin_dashboard': '/home/main-page',
    'main_page': '/home',
    'pos': '/sales/pos',
    'cashier_shifts': '/sales/cashier-shifts',
    'sales_invoice': '/sales/list',
    'sales_return': '/sales/return',
    'price_quotes': '/sales/quotes',
    'sales_report': '/reports/sales',
    'items_list': '/admin/inventory/list',
    'add_item': '/admin/inventory/add',
    'inventory_health': '/admin/inventory/health',
    'items_archive': '/admin/inventory/archive',
    'inventory_import': '/admin/inventory/import',
    'inventory_stock_transfer': '/admin/inventory/stock-transfer',
    'stock_adjustment': '/admin/inventory/stock-adjustment',
    'brands': '/admin/inventory/brands',
    'price_groups': '/admin/inventory/price-groups',
    'variants': '/admin/inventory/variants',
    'barcode_label': '/admin/inventory/barcodes',
    'barcode_settings': '/admin/inventory/barcodes/settings',
    'purchase_invoice': '/admin/purchases/list',
    'purchase_order': '/admin/purchases/add',
    'purchase_return': '/admin/purchases/returns',
    'free_return': '/admin/returns/free',
    'customers': '/admin/contacts/customers',
    'suppliers': '/admin/contacts/suppliers',
    'customer_groups': '/admin/contacts/customer-groups',
    'supplier_customers': '/admin/contacts/supplier-customers',
    'document_control': '/admin/document-control',
    'advanced_archive': '/admin/archive',
    'activity_log': '/admin/activity-log',
    'contacts_report': '/reports/contacts',
    'purchase_report': '/reports/purchases',
    'profit_report': '/reports/profit',
    'extra_reports': '/reports/extra',
    'advanced_ledger_report': '/reports/ledger',
    'crm': '/admin/crm',
    'tasks': '/admin/tasks',
    'notifications': '/notifications',
    'sync_status': '/sync-status',
    'bulk_price_update': '/admin/inventory/bulk-price-update',
    'inventory_promotions': '/admin/inventory/promotions',
    'inventory_stocktaking': '/admin/inventory/stocktaking',
    'stocktaking': '/admin/inventory/stocktaking',
    'void_operations': '/admin/void-operations',
  };

  static String? destinationForRoute(String route) {
    final exact = routeToDestination[route];
    if (exact != null) return exact;
    // Handle parameterized routes like /admin/inventory/edit/abc123
    final parts = route.split('/');
    for (var i = parts.length; i >= 2; i--) {
      final key = parts.take(i).join('/');
      if (routeToDestination.containsKey(key)) return routeToDestination[key];
    }
    return null;
  }
  static String? routeForDestination(String destination) =>
      destinationToRoute[destination];
}
