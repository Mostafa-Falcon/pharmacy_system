// lib/app/modules/sync/models/sync_table_meta.dart
//
// بيانات وصفية لجداول المزامنة — اسم الجدول في Supabase،
// اسم صندوق Hive المحلي، والتسمية المعروضة للمستخدم.
// مركزية عشان الصفحة والراوتر والـ SyncService يتكلموا بنفس القايمة.

import '../../../core/constants/app_strings.dart';

class SyncTableMeta {
  final String table;
  final String box;
  final String label;

  const SyncTableMeta({
    required this.table,
    required this.box,
    required this.label,
  });
}

/// قايمة جداول المزامنة المرتبة (نفس ترتيب السحب في [SyncService]).
const List<SyncTableMeta> syncTables = [
  SyncTableMeta(table: 'medicines', box: 'medicines', label: AppStrings.tableMedicines),
  SyncTableMeta(table: 'sales', box: 'sales', label: AppStrings.tableSales),
  SyncTableMeta(table: 'purchases', box: 'purchases', label: AppStrings.tablePurchases),
  SyncTableMeta(table: 'cashier_shifts', box: 'cashier_shifts', label: AppStrings.tableShifts),
  SyncTableMeta(table: 'quotes', box: 'quotes', label: AppStrings.tableQuotes),
  SyncTableMeta(table: 'inventory', box: 'inventory', label: AppStrings.tableInventory),
  SyncTableMeta(table: 'returns', box: 'returns', label: AppStrings.tableReturns),
  SyncTableMeta(table: 'branches', box: 'branches', label: AppStrings.tableBranches),
  SyncTableMeta(table: 'users', box: 'users', label: AppStrings.tableUsers),
  SyncTableMeta(table: 'permissions', box: 'permissions', label: AppStrings.tablePermissions),
  SyncTableMeta(table: 'customers', box: 'customers', label: AppStrings.tableCustomers),
  SyncTableMeta(table: 'suppliers', box: 'suppliers', label: AppStrings.tableSuppliers),
  SyncTableMeta(table: 'supplier_customers', box: 'supplier_customers', label: AppStrings.tableSupplierCustomers),
  SyncTableMeta(table: 'customer_ledgers', box: 'customer_ledgers', label: AppStrings.tableCustomerLedgers),
  SyncTableMeta(table: 'supplier_ledgers', box: 'supplier_ledgers', label: AppStrings.tableSupplierLedgers),
  SyncTableMeta(table: 'expenses', box: 'expenses', label: 'المصروفات'),
  SyncTableMeta(table: 'journal_entries', box: 'journal_entries', label: 'القيود المحاسبية'),
  SyncTableMeta(table: 'accounts', box: 'accounts', label: 'شجرة الحسابات'),
  SyncTableMeta(table: 'employees', box: 'employees', label: 'شؤون الموظفين'),
  SyncTableMeta(table: 'attendance', box: 'attendance', label: 'الحضور والانصراف'),
  SyncTableMeta(table: 'payroll', box: 'payroll', label: 'المرتبات'),
  SyncTableMeta(table: 'departments', box: 'departments', label: 'الأقسام'),
  SyncTableMeta(table: 'notifications', box: 'notifications', label: 'التنبيهات'),
  SyncTableMeta(table: 'tasks', box: 'tasks', label: 'المهام'),
  SyncTableMeta(table: 'stock_adjustments', box: 'stock_adjustments', label: 'تسويات المخزون'),
  SyncTableMeta(table: 'inventory_transactions', box: 'inventory_transactions', label: 'حركات المخزن'),
  SyncTableMeta(table: 'price_groups', box: 'price_groups', label: 'مجموعات الأسعار'),
  SyncTableMeta(table: 'brands', box: 'brands', label: 'العلامات التجارية'),
  SyncTableMeta(table: 'variants', box: 'variants', label: 'بدائل الأصناف'),
  SyncTableMeta(table: 'items_archive', box: 'items_archive', label: 'أرشيف الأصناف'),
];

String syncTableLabel(String table) =>
    syncTables.firstWhere((t) => t.table == table, orElse: () => SyncTableMeta(table: table, box: table, label: table)).label;
