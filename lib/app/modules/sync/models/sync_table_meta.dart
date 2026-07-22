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
];

String syncTableLabel(String table) =>
    syncTables.firstWhere((t) => t.table == table, orElse: () => SyncTableMeta(table: table, box: table, label: table)).label;
