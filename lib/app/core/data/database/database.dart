import 'package:drift/drift.dart';
import 'tables/inventory_tables.dart';
import 'tables/sales_tables.dart';
import 'tables/contacts_tables.dart';
import 'tables/purchases_tables.dart';
import 'tables/accounting_tables.dart';
import 'tables/hr_tables.dart';
import 'tables/system_tables.dart';

import 'daos/inventory_dao.dart';
import 'daos/sales_dao.dart';
import 'daos/contacts_dao.dart';
import 'daos/purchases_dao.dart';
import 'daos/accounting_dao.dart';
import 'daos/hr_dao.dart';
import 'daos/system_dao.dart';
import 'daos/sync_dao.dart';

import 'drift_executor_stub.dart'
    if (dart.library.ffi) 'drift_executor_native.dart'
    if (dart.library.html) 'drift_executor_web.dart';

part 'database.g.dart';

/// 🏛️ محرك قاعدة البيانات المحلية الموحد لمشروع نظام الصيدلية (AppDatabase Drift)
@DriftDatabase(
  tables: [
    // 1. حزمة الأصناف والمخزون
    MedicinesTable,
    ItemBatchesTable,
    ItemCategoriesTable,
    MedicineBrandsTable,
    ItemVariantsTable,
    ItemWarrantiesTable,
    PriceGroupsTable,
    StocktakingTable,
    StockAdjustmentsTable,
    ItemSwapsTable,
    OpeningStockTable,
    BarcodeSettingsTable,
    InventoryTransactionsTable,

    // 2. حزمة المبيعات والمرتجعات
    SaleInvoicesTable,
    InvoiceReturnsTable,
    FreeReturnsTable,
    CashierShiftsTable,
    ShippingOrdersTable,
    QuotationsTable,
    SuspendedSalesTable,
    PromotionsTable,

    // 3. حزمة الموردين والعملاء والشركاء
    SuppliersTable,
    CustomersTable,
    SupplierCustomersTable,
    SalesRepsTable,
    CustomerGroupsTable,
    ContactLedgersTable,

    // 4. حزمة المشتريات والتوريدات
    PurchaseInvoicesTable,
    SuppliedItemsTable,

    // 5. حزمة المحاسبة والماليات
    AccountTreeTable,
    ExpenseCategoriesTable,
    ExpensesTable,
    JournalEntriesTable,
    PaymentVouchersTable,

    // 6. حزمة الموارد البشرية
    AttendanceTable,
    PayrollTable,
    EmployeeMessagesTable,

    // 7. حزمة النظام والأرشيف والمستخدمين
    UsersTable,
    BranchesTable,
    PermissionsTable,
    AppSettingsTable,
    ArchiveRecordsTable,
    AuditLogsTable,
    NotificationsTable,
    SyncOutboxTable,
    SyncStateTable,
    ReceiptCountersTable,
    LookupsTable,
    ErrorLogsTable,
    CorrectionsTable,

    // 8. حزمة الباركودات ووحدات القياس
    MedicineBarcodesTable,
    MedicineUnitsTable,

    // 9. حزمة المرتجعات العامة
    ReturnsTable,
  ],
  daos: [
    InventoryDao,
    SalesDao,
    ContactsDao,
    PurchasesDao,
    AccountingDao,
    HrDao,
    SystemDao,
    SyncDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? LazyDatabase(createDriftExecutor));

  @override
  int get schemaVersion => 4; // v4: Added Lookups, ErrorLogs, Corrections, MedicineBarcodes, MedicineUnits, Returns tables
}


