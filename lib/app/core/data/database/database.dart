import 'package:drift/drift.dart';
import 'tables/core_tables.dart';
import 'tables/medicine_tables.dart';
import 'tables/task_tables.dart';
import 'tables/customer_tables.dart';
import 'tables/supplier_tables.dart';
import 'tables/transaction_tables.dart';
import 'tables/inventory_tables.dart';
import 'tables/promotions_table.dart';
import 'tables/archive_table.dart';
import 'tables/sync_tables.dart';
import 'tables/settings_tables.dart';
import 'tables/lookup_tables.dart';
import 'tables/crm_tables.dart';
import 'tables/notifications_table.dart';
import 'tables/inventory_extra_tables.dart';
import 'tables/stock_transfer_tables.dart';
import 'tables/stock_adjustment_tables.dart';
import 'tables/inventory_transactions_table.dart';
import 'tables/accounting_tables.dart';
import 'tables/hr_tables.dart';
import 'tables/admin_tables.dart';
import 'tables/suspended_sales_table.dart';
import 'tables/items_archive_table.dart';
import 'tables/bulk_price_updates_table.dart';
import 'tables/report_tables.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    UsersTable,
    BranchesTable,
    PermissionsTable,
    MedicinesTable,
    MedicineUnitsTable,
    ItemBatchesTable,
    StocktakingTable,
    StocktakingItemsTable,
    CustomersTable,
    CustomerGroupsTable,
    CustomerLedgersTable,
    SupplierCustomersTable,
    SuppliersTable,
    SupplierLedgersTable,
    SalesTable,
    PurchasesTable,
    ReturnsTable,
    QuotesTable,
    CashierShiftsTable,
    InventoryTable,
    DamagedStockTable,
    OpeningStockTable,
    PromotionsTable,
    ArchiveRecords,
    OutboxTable,
    SyncStateTable,
    AppSettingsTable,
    ReceiptCountersTable,
    LookupsTable,
    SalesRepsTable,
    NotificationsTable,
    MedicineBrandsTable,
    MedicineVariantsTable,
    PriceGroupsTable,
    StockTransfersTable,
    StockAdjustmentsTable,
    InventoryTransactionsTable,
    AccountsTable,
    JournalEntriesTable,
    ExpensesTable,
    PartyPaymentsTable,
    DepartmentsTable,
    EmployeesTable,
    AttendanceTable,
    LeavesTable,
    PayrollTable,
    AdminRolesTable,
    AdminMembersTable,
    AuditLogsTable,
    SuspendedSalesTable,
    ItemsArchiveTable,
    BulkPriceUpdatesTable,
    ReportDefinitionsTable,
    TasksTable,
    NotesTable,
    RemindersTable,
    MessagesTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      if (from < 3) {
        await m.createAll();
      }
      if (from < 4) {
        // إضافة أعمدة branch_id للجداول اللي كانت ناقصة
        try {
          await m.addColumn(customersTable, customersTable.branchId);
          await m.addColumn(suppliersTable, suppliersTable.branchId);
          await m.addColumn(supplierCustomersTable, supplierCustomersTable.branchId);
        } catch (_) {}
      }
      if (from < 5) {
        // تحديث جدول المرتجعات لإضافة أعمدة المرتجع الحر
        try {
          await m.addColumn(returnsTable, returnsTable.returnType);
          await m.addColumn(returnsTable, returnsTable.partyId);
          await m.addColumn(returnsTable, returnsTable.partyName);
          await m.addColumn(returnsTable, returnsTable.partyType);
          await m.addColumn(returnsTable, returnsTable.discountPercent);
          await m.addColumn(returnsTable, returnsTable.finalAmount);
          await m.addColumn(returnsTable, returnsTable.safeId);
        } catch (_) {}
      }
      if (from < 6) {
        // إضافة أعمدة branch_id للجداول الإضافية لضمان سلامة المزامنة
        try {
          await m.addColumn(medicineBrandsTable, medicineBrandsTable.branchId as GeneratedColumn);
          await m.addColumn(priceGroupsTable, priceGroupsTable.branchId as GeneratedColumn);
          await m.addColumn(reportDefinitionsTable, reportDefinitionsTable.branchId as GeneratedColumn);
          await m.addColumn(medicineVariantsTable, medicineVariantsTable.branchId as GeneratedColumn);
        } catch (_) {}
      }
    },
  );
}
