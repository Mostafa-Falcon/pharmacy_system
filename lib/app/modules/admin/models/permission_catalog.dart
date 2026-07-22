abstract final class PermissionCatalog {
  static const wildcard = '*';

  static const dashboardRead = 'dashboard.read';
  static const cashierUse = 'cashier.use';
  static const salesRead = 'sales.read';
  static const salesWrite = 'sales.write';
  static const purchasesRead = 'purchases.read';
  static const purchasesWrite = 'purchases.write';
  static const inventoryRead = 'inventory.read';
  static const inventoryWrite = 'inventory.write';
  static const contactsRead = 'contacts.read';
  static const contactsWrite = 'contacts.write';
  static const accountingRead = 'accounting.read';
  static const accountingWrite = 'accounting.write';
  static const reportsRead = 'reports.read';
  static const settingsRead = 'settings.read';
  static const settingsWrite = 'settings.write';
  static const branchesRead = 'branches.read';
  static const branchesWrite = 'branches.write';
  static const usersRead = 'users.read';
  static const usersWrite = 'users.write';
  static const rolesRead = 'roles.read';
  static const rolesWrite = 'roles.write';
  static const activityRead = 'activity.read';

  static const all = <String>{
    dashboardRead, cashierUse,
    salesRead, salesWrite,
    purchasesRead, purchasesWrite,
    inventoryRead, inventoryWrite,
    contactsRead, contactsWrite,
    accountingRead, accountingWrite,
    reportsRead,
    settingsRead, settingsWrite,
    branchesRead, branchesWrite,
    usersRead, usersWrite,
    rolesRead, rolesWrite,
    activityRead,
  };

  static const labelsAr = <String, String>{
    dashboardRead: 'عرض لوحة المتابعة',
    cashierUse: 'استخدام الكاشير',
    salesRead: 'عرض المبيعات',
    salesWrite: 'تنفيذ المبيعات والمرتجعات',
    purchasesRead: 'عرض المشتريات',
    purchasesWrite: 'تنفيذ المشتريات والمرتجعات',
    inventoryRead: 'عرض الأصناف والمخزون',
    inventoryWrite: 'تعديل الأصناف والمخزون',
    contactsRead: 'عرض العملاء والموردين',
    contactsWrite: 'تعديل العملاء والموردين',
    accountingRead: 'عرض الحسابات',
    accountingWrite: 'تنفيذ العمليات المحاسبية',
    reportsRead: 'عرض التقارير',
    settingsRead: 'عرض الإعدادات',
    settingsWrite: 'تعديل الإعدادات',
    branchesRead: 'عرض الفروع',
    branchesWrite: 'إدارة الفروع',
    usersRead: 'عرض المستخدمين',
    usersWrite: 'إدارة المستخدمين',
    rolesRead: 'عرض الأدوار والصلاحيات',
    rolesWrite: 'إدارة الأدوار والصلاحيات',
    activityRead: 'عرض سجل النشاط',
  };

  static Set<String> defaultsForRole(String role) {
    switch (role.trim().toLowerCase()) {
      case 'developer':
      case 'owner':
        return {wildcard};
      case 'manager':
        return {...all};
      case 'pharmacist':
        return {
          dashboardRead, cashierUse, salesRead, salesWrite,
          purchasesRead, inventoryRead, inventoryWrite,
          contactsRead, contactsWrite, reportsRead,
        };
      case 'accountant':
        return {
          dashboardRead, salesRead, purchasesRead,
          accountingRead, accountingWrite, reportsRead, contactsRead,
        };
      case 'cashier':
        return {dashboardRead, cashierUse, salesRead, salesWrite, contactsRead};
      default:
        return {dashboardRead};
    }
  }
}
