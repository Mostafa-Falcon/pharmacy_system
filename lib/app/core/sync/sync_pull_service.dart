import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:drift/drift.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/core/data/database/daos/sync_dao.dart';
import 'package:pharmacy_system/app/core/sync/sync_service.dart';
import 'package:pharmacy_system/app/shared/ui_core.dart';
import 'package:pharmacy_system/app/core/sync/sync_config.dart';

class SyncPullService {
  final SupabaseClient _supabase;
  SyncDao get _syncDao => GetIt.instance<SyncDao>();

  SyncPullService(this._supabase);

  Future<int> pullTable({
    required String tableName,
    required String branchId,
    DateTime? lastSyncedAt,
  }) async {
    int totalUpdated = 0;
    DateTime maxModified = lastSyncedAt ?? DateTime(2000);
    bool hasMore = true;
    final int pageSize = SyncConfig.pullPageSize;

    try {
      while (hasMore) {
        dynamic query = _supabase.from(tableName).select();

        // الجداول التي لا ترتبط بفرع محدد (تتم مزامنتها لكل الفروع)
        const globalTables = {
          'branches', 'users', 'permissions',
          'item_categories', 'medicine_brands', 'item_variants',
          'item_warranties', 'price_groups', 'barcode_settings',
          'customer_groups', 'account_tree', 'expense_categories', 
          'app_settings',
        };
        
        if (!globalTables.contains(tableName)) {
          query = query.eq('branch_id', branchId);
        }

        if (maxModified.isAfter(DateTime(2000))) {
          query = query.gt('last_modified', maxModified.toIso8601String());
        }

        final List<dynamic> response = await query
            .order('last_modified', ascending: true)
            .limit(pageSize);
            
        if (response.isEmpty) {
          hasMore = false;
          break;
        }

        for (final rawItem in response) {
          final Map<String, dynamic> json =
              Map<String, dynamic>.from(rawItem as Map);

          final itemModified = _dt(json['last_modified']);
          if (itemModified.isAfter(maxModified)) {
            maxModified = itemModified;
          }

          final recordId = json['id']?.toString() ?? '';
          if (recordId.isNotEmpty) {
            final hasPending = await _syncDao.hasUnsyncedForRecord(tableName, recordId);
            if (hasPending) {
              safeDebugPrint(
                'SyncPullService: Shielding $tableName/$recordId from remote overwrite (local changes pending)',
              );
              continue;
            }
          }

          await _upsertToTable(tableName, json);
          totalUpdated++;
        }

        if (response.length < pageSize) {
          hasMore = false;
        }

        await _syncDao.upsertWatermark(
          tableName: tableName,
          watermark: maxModified,
          branchId: branchId,
        );
      }

      if (totalUpdated > 0) {
        SyncService.notifyTableUpdated(tableName, branchId);
      }
      return totalUpdated;
    } catch (e, s) {
      safeDebugPrint('SyncPullService: Error pulling table $tableName: $e\n$s');
      return totalUpdated;
    }
  }

  Future<void> _upsertToTable(String tableName, Map<String, dynamic> data) async {
    final db = GetIt.instance<AppDatabase>();

    switch (tableName) {
      case 'medicines':
        await db.into(db.medicinesTable).insertOnConflictUpdate(_mapToMedicine(data));
        break;
      case 'item_batches':
        await db.into(db.itemBatchesTable).insertOnConflictUpdate(_mapToBatch(data));
        break;
      case 'item_categories':
        await db.into(db.itemCategoriesTable).insertOnConflictUpdate(_mapToCategory(data));
        break;
      case 'customers':
        await db.into(db.customersTable).insertOnConflictUpdate(_mapToCustomer(data));
        break;
      case 'suppliers':
        await db.into(db.suppliersTable).insertOnConflictUpdate(_mapToSupplier(data));
        break;
      case 'sales_agents':
        await db.into(db.salesRepsTable).insertOnConflictUpdate(_mapToSalesRep(data));
        break;
      case 'sale_invoices':
        await db.into(db.saleInvoicesTable).insertOnConflictUpdate(_mapToSaleInvoice(data));
        break;
      case 'purchase_invoices':
        await db.into(db.purchaseInvoicesTable).insertOnConflictUpdate(_mapToPurchaseInvoice(data));
        break;
      case 'expenses':
        await db.into(db.expensesTable).insertOnConflictUpdate(_mapToExpense(data));
        break;
      case 'journal_entries':
        await db.into(db.journalEntriesTable).insertOnConflictUpdate(_mapToJournalEntry(data));
        break;
      case 'account_tree':
        await db.into(db.accountTreeTable).insertOnConflictUpdate(_mapToAccountTree(data));
        break;
      case 'archive_records':
        await db.into(db.archiveRecordsTable).insertOnConflictUpdate(_mapToArchive(data));
        break;
      case 'receipt_counters':
        await db.into(db.receiptCountersTable).insertOnConflictUpdate(_mapToCounter(data));
        break;
      case 'price_groups':
        await db.into(db.priceGroupsTable).insertOnConflictUpdate(_mapToPriceGroup(data));
        break;
      case 'barcode_settings':
        await db.into(db.barcodeSettingsTable).insertOnConflictUpdate(_mapToBarcodeSettings(data));
        break;
      case 'item_variants':
        await db.into(db.itemVariantsTable).insertOnConflictUpdate(_mapToVariant(data));
        break;
      case 'item_warranties':
        await db.into(db.itemWarrantiesTable).insertOnConflictUpdate(_mapToWarranty(data));
        break;
      case 'medicine_brands':
        await db.into(db.medicineBrandsTable).insertOnConflictUpdate(_mapToBrand(data));
        break;
      case 'stocktaking':
        await db.into(db.stocktakingTable).insertOnConflictUpdate(_mapToStocktaking(data));
        break;
      case 'stock_adjustments':
        await db.into(db.stockAdjustmentsTable).insertOnConflictUpdate(_mapToStockAdjustment(data));
        break;
      case 'inventory_transactions':
        await db.into(db.inventoryTransactionsTable).insertOnConflictUpdate(_mapToInventoryTransaction(data));
        break;
      case 'item_swaps':
        await db.into(db.itemSwapsTable).insertOnConflictUpdate(_mapToItemSwap(data));
        break;
      case 'opening_stock':
        await db.into(db.openingStockTable).insertOnConflictUpdate(_mapToOpeningStock(data));
        break;
      case 'attendance':
        await db.into(db.attendanceTable).insertOnConflictUpdate(_mapToAttendance(data));
        break;
      case 'payroll':
        await db.into(db.payrollTable).insertOnConflictUpdate(_mapToPayroll(data));
        break;
      case 'employee_messages':
        await db.into(db.employeeMessagesTable).insertOnConflictUpdate(_mapToMessage(data));
        break;
      case 'promotions':
        await db.into(db.promotionsTable).insertOnConflictUpdate(_mapToPromotion(data));
        break;
      case 'free_returns':
        await db.into(db.freeReturnsTable).insertOnConflictUpdate(_mapToFreeReturn(data));
        break;
      case 'invoice_returns':
        await db.into(db.invoiceReturnsTable).insertOnConflictUpdate(_mapToInvoiceReturn(data));
        break;
      case 'quotations':
        await db.into(db.quotationsTable).insertOnConflictUpdate(_mapToQuotation(data));
        break;
      case 'shipping_orders':
        await db.into(db.shippingOrdersTable).insertOnConflictUpdate(_mapToShipping(data));
        break;
      case 'payment_vouchers':
        await db.into(db.paymentVouchersTable).insertOnConflictUpdate(_mapToVoucher(data));
        break;
      case 'expense_categories':
        await db.into(db.expenseCategoriesTable).insertOnConflictUpdate(_mapToExpenseCategory(data));
        break;
      case 'app_settings':
        await db.into(db.appSettingsTable).insertOnConflictUpdate(_mapToSettings(data));
        break;
      case 'branches':
        await db.into(db.branchesTable).insertOnConflictUpdate(_mapToBranch(data));
        break;
      case 'users':
        await db.into(db.usersTable).insertOnConflictUpdate(_mapToUser(data));
        break;
      case 'permissions':
        await db.into(db.permissionsTable).insertOnConflictUpdate(_mapToPermission(data));
        break;
      case 'app_notifications':
        await db.into(db.notificationsTable).insertOnConflictUpdate(_mapToNotification(data));
        break;
      case 'audit_logs':
        await db.into(db.auditLogsTable).insertOnConflictUpdate(_mapToAuditLog(data));
        break;
      case 'supplier_customers':
        await db.into(db.supplierCustomersTable).insertOnConflictUpdate(_mapToSupplierCustomer(data));
        break;
      case 'contact_ledger':
      case 'customer_ledgers':
      case 'supplier_ledgers':
        await db.into(db.contactLedgersTable).insertOnConflictUpdate(_mapToContactLedger(data));
        break;
      case 'customer_groups':
        await db.into(db.customerGroupsTable).insertOnConflictUpdate(_mapToCustomerGroup(data));
        break;
      default:
        safeDebugPrint('SyncPullService: Table $tableName mapping using generic or skipped.');
    }
  }

  // ─── Mappings (Aligned with Seed Models) ───────────────────────────

  MedicinesTableCompanion _mapToMedicine(Map<String, dynamic> raw) => MedicinesTableCompanion(
    id: Value(_s(raw['id'])),
    name: Value(_s(raw['name'])),
    nameEn: Value(_sn(raw['name_en'])),
    itemTypes: Value(_j(raw['item_types'])),
    therapeuticGroup: Value(_j(raw['therapeutic_group'])),
    barcodes: Value(_j(raw['barcodes'])),
    itemLevels: Value(_j(raw['item_levels'])),
    expiryDates: Value(_j(raw['expiry_dates'])),
    supplierId: Value(_sn(raw['supplier_id'])),
    manufacturer: Value(_sn(raw['manufacturer'])),
    dosageForm: Value(_sn(raw['dosage_form'])),
    strength: Value(_sn(raw['strength'])),
    packageSize: Value(_sn(raw['package_size'])),
    containerShape: Value(_sn(raw['container_shape'])),
    location: Value(_sn(raw['location'])),
    isTaxable: Value(_b(raw['is_taxable'])),
    taxType: Value(_sn(raw['tax_type'])),
    taxValue: Value(_ddn(raw['tax_value'])),
    pricesIncludeTax: Value(_b(raw['prices_include_tax'])),
    alertEnabled: Value(_b(raw['alert_enabled'])),
    minStock: Value(_i(raw['min_stock'])),
    expiryTrackingEnabled: Value(_b(raw['expiry_tracking_enabled'])),
    allowNegativeStock: Value(_b(raw['allow_negative_stock'])),
    isActive: Value(_b(raw['is_active'])),
    imageUrl: Value(_sn(raw['image_url'])),
    description: Value(_sn(raw['description'])),
    accountId: Value(_sn(raw['account_id'])),
    branchId: Value(_sn(raw['branch_id'])),
    syncVersion: Value(_i(raw['sync_version'])),
    lastModified: Value(_dt(raw['last_modified'])),
    isDeleted: Value(_b(raw['is_deleted'])),
    createdAt: Value(_dt(raw['created_at'])),
  );

  ItemBatchesTableCompanion _mapToBatch(Map<String, dynamic> raw) => ItemBatchesTableCompanion(
    id: Value(_s(raw['id'])),
    medicineId: Value(_s(raw['medicine_id'])),
    batchNumber: Value(_sn(raw['batch_number'])),
    expiryDate: Value(_dtn(raw['expiry_date'])),
    quantity: Value(_i(raw['quantity'])),
    damagedQuantity: Value(_i(raw['damaged_quantity'])),
    purchasePrice: Value(_ddn(raw['purchase_price'])),
    isActive: Value(_b(raw['is_active'])),
    accountId: Value(_sn(raw['account_id'])),
    branchId: Value(_sn(raw['branch_id'])),
    createdAt: Value(_dt(raw['created_at'])),
    lastModified: Value(_dt(raw['last_modified'])),
    isDeleted: Value(_b(raw['is_deleted'])),
    syncVersion: Value(_i(raw['sync_version'])),
  );

  ItemCategoriesTableCompanion _mapToCategory(Map<String, dynamic> raw) => ItemCategoriesTableCompanion(
    id: Value(_s(raw['id'])),
    name: Value(_s(raw['name'])),
    code: Value(_sn(raw['code'])),
    description: Value(_sn(raw['description'])),
    parentId: Value(_sn(raw['parent_id'])),
    isActive: Value(_b(raw['is_active'])),
    accountId: Value(_sn(raw['account_id'])),
    lastModified: Value(_dt(raw['last_modified'])),
    isDeleted: Value(_b(raw['is_deleted'])),
    syncVersion: Value(_i(raw['sync_version'])),
  );

  CustomersTableCompanion _mapToCustomer(Map<String, dynamic> raw) => CustomersTableCompanion(
    id: Value(_s(raw['id'])),
    name: Value(_s(raw['name'])),
    phone: Value(_sn(raw['phone'])),
    secondPhone: Value(_sn(raw['second_phone'])),
    address: Value(_sn(raw['address'])),
    email: Value(_sn(raw['email'])),
    groupId: Value(_sn(raw['group_id'])),
    groupName: Value(_sn(raw['group_name'])),
    creditLimit: Value(_d(raw['credit_limit'])),
    discountPercent: Value(_d(raw['discount_percent'])),
    debitAmount: Value(_d(raw['debit_amount'])),
    creditAmount: Value(_d(raw['credit_amount'])),
    isActive: Value(_b(raw['is_active'])),
    notes: Value(_sn(raw['notes'])),
    branchId: Value(_sn(raw['branch_id'])),
    accountId: Value(_sn(raw['account_id'])),
    lastModified: Value(_dt(raw['last_modified'])),
    isDeleted: Value(_b(raw['is_deleted'])),
    syncVersion: Value(_i(raw['sync_version'])),
  );

  SuppliersTableCompanion _mapToSupplier(Map<String, dynamic> raw) => SuppliersTableCompanion(
    id: Value(_s(raw['id'])),
    name: Value(_s(raw['name'])),
    phone: Value(_sn(raw['phone'])),
    address: Value(_sn(raw['address'])),
    email: Value(_sn(raw['email'])),
    contactPerson: Value(_sn(raw['contact_person'])),
    taxId: Value(_sn(raw['tax_id'])),
    creditAmount: Value(_d(raw['credit_amount'])),
    debitAmount: Value(_d(raw['debit_amount'])),
    paymentTermDays: Value(_i(raw['payment_term_days'])),
    isActive: Value(_b(raw['is_active'])),
    notes: Value(_sn(raw['notes'])),
    branchId: Value(_sn(raw['branch_id'])),
    accountId: Value(_sn(raw['account_id'])),
    lastModified: Value(_dt(raw['last_modified'])),
    isDeleted: Value(_b(raw['is_deleted'])),
    syncVersion: Value(_i(raw['sync_version'])),
  );

  SalesRepsTableCompanion _mapToSalesRep(Map<String, dynamic> raw) => SalesRepsTableCompanion(
    id: Value(_s(raw['id'])),
    name: Value(_s(raw['name'])),
    phone: Value(_sn(raw['phone'])),
    email: Value(_sn(raw['email'])),
    commissionPercentage: Value(_d(raw['commission_percentage'])),
    totalCommissionEarned: Value(_d(raw['total_commission_earned'])),
    isActive: Value(_b(raw['is_active'])),
    notes: Value(_sn(raw['notes'])),
    branchId: Value(_sn(raw['branch_id'])),
    accountId: Value(_sn(raw['account_id'])),
    lastModified: Value(_dt(raw['last_modified'])),
    isDeleted: Value(_b(raw['is_deleted'])),
    syncVersion: Value(_i(raw['sync_version'])),
  );

  SaleInvoicesTableCompanion _mapToSaleInvoice(Map<String, dynamic> raw) => SaleInvoicesTableCompanion(
    id: Value(_s(raw['id'])),
    invoiceNumber: Value(_s(raw['invoice_number'])),
    customerName: Value(_s(raw['customer_name'])),
    customerId: Value(_sn(raw['customer_id'])),
    cashRegisterId: Value(_s(raw['cash_register_id'])),
    items: Value(_j(raw['items'])),
    subtotalAmount: Value(_d(raw['subtotal_amount'])),
    discountAmount: Value(_d(raw['discount_amount'])),
    finalAmount: Value(_d(raw['final_amount'])),
    paidAmount: Value(_d(raw['paid_amount'])),
    remainingAmount: Value(_d(raw['remaining_amount'])),
    paymentMethod: Value(_s(raw['payment_method'])),
    createdBy: Value(_s(raw['created_by'])),
    branchId: Value(_s(raw['branch_id'])),
    accountId: Value(_s(raw['account_id'])),
    notes: Value(_sn(raw['notes'])),
    createdAt: Value(_dt(raw['created_at'])),
    lastModified: Value(_dt(raw['last_modified'])),
    isDeleted: Value(_b(raw['is_deleted'])),
    syncVersion: Value(_i(raw['sync_version'])),
  );

  PurchaseInvoicesTableCompanion _mapToPurchaseInvoice(Map<String, dynamic> raw) => PurchaseInvoicesTableCompanion(
    id: Value(_s(raw['id'])),
    invoiceNumber: Value(_s(raw['invoice_number'])),
    supplierId: Value(_s(raw['supplier_id'])),
    supplierName: Value(_s(raw['supplier_name'])),
    items: Value(_j(raw['items'])),
    subtotalAmount: Value(_d(raw['subtotal_amount'])),
    discountAmount: Value(_d(raw['discount_amount'])),
    finalAmount: Value(_d(raw['final_amount'])),
    paidAmount: Value(_d(raw['paid_amount'])),
    remainingAmount: Value(_d(raw['remaining_amount'])),
    paymentMethod: Value(_s(raw['payment_method'])),
    createdBy: Value(_s(raw['created_by'])),
    branchId: Value(_s(raw['branch_id'])),
    accountId: Value(_s(raw['account_id'])),
    notes: Value(_sn(raw['notes'])),
    createdAt: Value(_dt(raw['created_at'])),
    lastModified: Value(_dt(raw['last_modified'])),
    isDeleted: Value(_b(raw['is_deleted'])),
    syncVersion: Value(_i(raw['sync_version'])),
  );

  ExpensesTableCompanion _mapToExpense(Map<String, dynamic> raw) => ExpensesTableCompanion(
    id: Value(_s(raw['id'])),
    expenseNumber: Value(_i(raw['expense_number'])),
    category: Value(_s(raw['category'])),
    description: Value(_sn(raw['description'])),
    amount: Value(_d(raw['amount'])),
    paymentMethod: Value(_s(raw['payment_method'])),
    createdById: Value(_s(raw['created_by_id'])),
    createdByName: Value(_sn(raw['created_by_name'])),
    branchId: Value(_s(raw['branch_id'])),
    accountId: Value(_sn(raw['account_id'])),
    notes: Value(_sn(raw['notes'])),
    expenseDate: Value(_dt(raw['expense_date'])),
    createdAt: Value(_dt(raw['created_at'])),
    lastModified: Value(_dt(raw['last_modified'])),
    isDeleted: Value(_b(raw['is_deleted'])),
    syncVersion: Value(_i(raw['sync_version'])),
  );

  JournalEntriesTableCompanion _mapToJournalEntry(Map<String, dynamic> raw) => JournalEntriesTableCompanion(
    id: Value(_s(raw['id'])),
    entryNumber: Value(_i(raw['entry_number'])),
    entryDate: Value(_dt(raw['entry_date'])),
    entryType: Value(_s(raw['entry_type'])),
    referenceNumber: Value(_sn(raw['reference_number'])),
    description: Value(_sn(raw['description'])),
    lines: Value(_j(raw['lines'])),
    totalDebit: Value(_d(raw['total_debit'])),
    totalCredit: Value(_d(raw['total_credit'])),
    createdById: Value(_s(raw['created_by_id'])),
    branchId: Value(_s(raw['branch_id'])),
    accountId: Value(_sn(raw['account_id'])),
    createdAt: Value(_dt(raw['created_at'])),
    lastModified: Value(_dt(raw['last_modified'])),
    isDeleted: Value(_b(raw['is_deleted'])),
    syncVersion: Value(_i(raw['sync_version'])),
  );

  AccountTreeTableCompanion _mapToAccountTree(Map<String, dynamic> raw) => AccountTreeTableCompanion(
    id: Value(_s(raw['id'])),
    accountCode: Value(_s(raw['account_code'])),
    name: Value(_s(raw['name'])),
    accountType: Value(_s(raw['account_type'])),
    parentAccountId: Value(_sn(raw['parent_account_id'])),
    currentBalance: Value(_d(raw['current_balance'])),
    isDebitNature: Value(_b(raw['is_debit_nature'])),
    isSubAccount: Value(_b(raw['is_sub_account'])),
    isActive: Value(_b(raw['is_active'])),
    accountId: Value(_sn(raw['account_id'])),
    description: Value(_sn(raw['description'])),
    lastModified: Value(_dt(raw['last_modified'])),
    isDeleted: Value(_b(raw['is_deleted'])),
    syncVersion: Value(_i(raw['sync_version'])),
  );

  ArchiveRecordsTableCompanion _mapToArchive(Map<String, dynamic> raw) => ArchiveRecordsTableCompanion(
    id: Value(_s(raw['id'])),
    entityType: Value(_s(raw['entity_type'])),
    entityId: Value(_s(raw['entity_id'])),
    entityTitle: Value(_s(raw['entity_name'])),
    entityDataJson: Value(_s(raw['entity_data_json'])),
    deletedById: Value(_s(raw['deleted_by_id'])),
    deletedByName: Value(_s(raw['deleted_by_name'])),
    branchId: Value(_s(raw['branch_id'])),
    accountId: Value(_sn(raw['account_id'])),
    deletedAt: Value(_dt(raw['deleted_at'])),
    restoredAt: Value(_dtn(raw['restored_at'])),
    restoredBy: Value(_sn(raw['restored_by'])),
    permanentlyDeletedAt: Value(_dtn(raw['permanently_deleted_at'])),
    syncVersion: Value(_i(raw['sync_version'])),
  );

  ReceiptCountersTableCompanion _mapToCounter(Map<String, dynamic> raw) => ReceiptCountersTableCompanion(
    id: Value(_s(raw['id'])),
    counterType: Value(_s(raw['counter_type'])),
    lastNumber: Value(_i(raw['last_number'])),
    prefix: Value(_s(raw['prefix'])),
    branchId: Value(_s(raw['branch_id'])),
  );

  StocktakingTableCompanion _mapToStocktaking(Map<String, dynamic> raw) => StocktakingTableCompanion(
    id: Value(_s(raw['id'])),
    stocktakingNumber: Value(_s(raw['stocktaking_number'])),
    title: Value(_s(raw['title'])),
    createdBy: Value(_s(raw['created_by'])),
    branchId: Value(_s(raw['branch_id'])),
    accountId: Value(_s(raw['account_id'])),
    notes: Value(_sn(raw['notes'])),
    createdAt: Value(_dt(raw['created_at'])),
    lastModified: Value(_dt(raw['last_modified'])),
    isDeleted: Value(_b(raw['is_deleted'])),
    syncVersion: Value(_i(raw['sync_version'])),
  );

  StockAdjustmentsTableCompanion _mapToStockAdjustment(Map<String, dynamic> raw) => StockAdjustmentsTableCompanion(
    id: Value(_s(raw['id'])),
    adjustmentNumber: Value(_s(raw['adjustment_number'])),
    adjustmentType: Value(_s(raw['adjustment_type'])),
    items: Value(_j(raw['items'])),
    totalAmount: Value(_d(raw['total_amount'])),
    adjustedBy: Value(_s(raw['adjusted_by'])),
    branchId: Value(_s(raw['branch_id'])),
    accountId: Value(_s(raw['account_id'])),
    notes: Value(_sn(raw['notes'])),
    createdAt: Value(_dt(raw['created_at'])),
    lastModified: Value(_dt(raw['last_modified'])),
    isDeleted: Value(_b(raw['is_deleted'])),
    syncVersion: Value(_i(raw['sync_version'])),
  );

  InventoryTransactionsTableCompanion _mapToInventoryTransaction(Map<String, dynamic> raw) => InventoryTransactionsTableCompanion(
    id: Value(_s(raw['id'])),
    medicineId: Value(_s(raw['medicine_id'])),
    transactionType: Value(_s(raw['transaction_type'])),
    referenceId: Value(_s(raw['reference_id'])),
    referenceNumber: Value(_sn(raw['reference_number'])),
    quantityChange: Value(_i(raw['quantity_change'])),
    quantityAfter: Value(_i(raw['quantity_after'])),
    unitPrice: Value(_d(raw['unit_price'])),
    branchId: Value(_s(raw['branch_id'])),
    accountId: Value(_sn(raw['account_id'])),
    createdAt: Value(_dt(raw['created_at'])),
    lastModified: Value(_dt(raw['last_modified'])),
    isDeleted: Value(_b(raw['is_deleted'])),
    syncVersion: Value(_i(raw['sync_version'])),
  );

  ItemSwapsTableCompanion _mapToItemSwap(Map<String, dynamic> raw) => ItemSwapsTableCompanion(
    id: Value(_s(raw['id'])),
    swapNumber: Value(_s(raw['swap_number'])),
    partyType: Value(_s(raw['party_type'])),
    partyId: Value(_sn(raw['party_id'])),
    partyName: Value(_s(raw['party_name'])),
    cashRegisterId: Value(_sn(raw['cash_register_id'])),
    totalIncomingAmount: Value(_d(raw['total_incoming_amount'])),
    totalOutgoingAmount: Value(_d(raw['total_outgoing_amount'])),
    netCashDifference: Value(_d(raw['net_cash_difference'])),
    items: Value(_j(raw['items'])),
    createdBy: Value(_s(raw['created_by'])),
    branchId: Value(_s(raw['branch_id'])),
    accountId: Value(_s(raw['account_id'])),
    notes: Value(_sn(raw['notes'])),
    swapDate: Value(_dt(raw['swap_date'])),
    lastModified: Value(_dt(raw['last_modified'])),
    isDeleted: Value(_b(raw['is_deleted'])),
    syncVersion: Value(_i(raw['sync_version'])),
  );

  OpeningStockTableCompanion _mapToOpeningStock(Map<String, dynamic> raw) => OpeningStockTableCompanion(
    id: Value(_s(raw['id'])),
    voucherNumber: Value(_s(raw['voucher_number'])),
    items: Value(_j(raw['items'])),
    createdBy: Value(_s(raw['created_by'])),
    branchId: Value(_s(raw['branch_id'])),
    accountId: Value(_s(raw['account_id'])),
    notes: Value(_sn(raw['notes'])),
    createdAt: Value(_dt(raw['created_at'])),
    lastModified: Value(_dt(raw['last_modified'])),
    isDeleted: Value(_b(raw['is_deleted'])),
    syncVersion: Value(_i(raw['sync_version'])),
  );

  PriceGroupsTableCompanion _mapToPriceGroup(Map<String, dynamic> raw) => PriceGroupsTableCompanion(
    id: Value(_s(raw['id'])),
    name: Value(_s(raw['name'])),
    markupPercentage: Value(_d(raw['markup_percentage'])),
    discountPercentage: Value(_d(raw['discount_percentage'])),
    isDefault: Value(_b(raw['is_default'])),
    isActive: Value(_b(raw['is_active'])),
    accountId: Value(_sn(raw['account_id'])),
    lastModified: Value(_dt(raw['last_modified'])),
    isDeleted: Value(_b(raw['is_deleted'])),
    syncVersion: Value(_i(raw['sync_version'])),
  );

  BarcodeSettingsTableCompanion _mapToBarcodeSettings(Map<String, dynamic> raw) => BarcodeSettingsTableCompanion(
    id: Value(_s(raw['id'])),
    prefix: Value(_s(raw['prefix'])),
    labelWidthMm: Value(_d(raw['label_width_mm'])),
    labelHeightMm: Value(_d(raw['label_height_mm'])),
    copiesPerItem: Value(_i(raw['copies_per_item'])),
    showPrice: Value(_b(raw['show_price'])),
    showItemName: Value(_b(raw['show_item_name'])),
    showUnitName: Value(_b(raw['show_unit_name'])),
    showPharmacyName: Value(_b(raw['show_pharmacy_name'])),
    pharmacyName: Value(_s(raw['pharmacy_name'])),
    showExpiry: Value(_b(raw['show_expiry'])),
    showBatch: Value(_b(raw['show_batch'])),
    printLayout: Value(_s(raw['print_layout'])),
    directPrint: Value(_b(raw['direct_print'])),
    printerName: Value(_s(raw['printer_name'])),
    accountId: Value(_sn(raw['account_id'])),
    lastModified: Value(_dt(raw['last_modified'])),
    isDeleted: Value(_b(raw['is_deleted'])),
    syncVersion: Value(_i(raw['sync_version'])),
  );

  ItemVariantsTableCompanion _mapToVariant(Map<String, dynamic> raw) => ItemVariantsTableCompanion(
    id: Value(_s(raw['id'])),
    name: Value(_s(raw['name'])),
    values: Value(_j(raw['values'])),
    isActive: Value(_b(raw['is_active'])),
    accountId: Value(_sn(raw['account_id'])),
    lastModified: Value(_dt(raw['last_modified'])),
    isDeleted: Value(_b(raw['is_deleted'])),
    syncVersion: Value(_i(raw['sync_version'])),
  );

  ItemWarrantiesTableCompanion _mapToWarranty(Map<String, dynamic> raw) => ItemWarrantiesTableCompanion(
    id: Value(_s(raw['id'])),
    name: Value(_s(raw['name'])),
    description: Value(_sn(raw['description'])),
    duration: Value(_i(raw['duration'])),
    durationUnit: Value(_s(raw['duration_unit'])),
    isActive: Value(_b(raw['is_active'])),
    accountId: Value(_sn(raw['account_id'])),
    lastModified: Value(_dt(raw['last_modified'])),
    isDeleted: Value(_b(raw['is_deleted'])),
    syncVersion: Value(_i(raw['sync_version'])),
  );

  MedicineBrandsTableCompanion _mapToBrand(Map<String, dynamic> raw) => MedicineBrandsTableCompanion(
    id: Value(_s(raw['id'])),
    name: Value(_s(raw['name'])),
    description: Value(_sn(raw['description'])),
    useForRepair: Value(_b(raw['use_for_repair'])),
    isActive: Value(_b(raw['is_active'])),
    accountId: Value(_sn(raw['account_id'])),
    lastModified: Value(_dt(raw['last_modified'])),
    isDeleted: Value(_b(raw['is_deleted'])),
    syncVersion: Value(_i(raw['sync_version'])),
  );

  AttendanceTableCompanion _mapToAttendance(Map<String, dynamic> raw) => AttendanceTableCompanion(
    id: Value(_s(raw['id'])),
    employeeId: Value(_s(raw['employee_id'])),
    employeeName: Value(_s(raw['employee_name'])),
    date: Value(_dt(raw['date'])),
    checkInTime: Value(_dt(raw['check_in_time'])),
    checkOutTime: Value(_dtn(raw['check_out_time'])),
    workHours: Value(_d(raw['work_hours'])),
    overtimeHours: Value(_d(raw['overtime_hours'])),
    lateMinutes: Value(_i(raw['late_minutes'])),
    status: Value(_s(raw['status'])),
    accountId: Value(_sn(raw['account_id'])),
    branchId: Value(_sn(raw['branch_id'])),
    notes: Value(_sn(raw['notes'])),
    lastModified: Value(_dt(raw['last_modified'])),
    isDeleted: Value(_b(raw['is_deleted'])),
    syncVersion: Value(_i(raw['sync_version'])),
  );

  PayrollTableCompanion _mapToPayroll(Map<String, dynamic> raw) => PayrollTableCompanion(
    id: Value(_s(raw['id'])),
    employeeId: Value(_s(raw['employee_id'])),
    employeeName: Value(_s(raw['employee_name'])),
    period: Value(_s(raw['period'])),
    basicSalary: Value(_d(raw['basic_salary'])),
    allowances: Value(_d(raw['allowances'])),
    deductions: Value(_d(raw['deductions'])),
    advances: Value(_d(raw['advances'])),
    netSalary: Value(_d(raw['net_salary'])),
    isPaid: Value(_b(raw['is_paid'])),
    paidAt: Value(_dtn(raw['paid_at'])),
    accountId: Value(_sn(raw['account_id'])),
    branchId: Value(_sn(raw['branch_id'])),
    notes: Value(_sn(raw['notes'])),
    lastModified: Value(_dt(raw['last_modified'])),
    isDeleted: Value(_b(raw['is_deleted'])),
    syncVersion: Value(_i(raw['sync_version'])),
  );

  EmployeeMessagesTableCompanion _mapToMessage(Map<String, dynamic> raw) => EmployeeMessagesTableCompanion(
    id: Value(_s(raw['id'])),
    title: Value(_s(raw['title'])),
    content: Value(_s(raw['content'])),
    senderName: Value(_s(raw['sender_name'])),
    recipientEmployeeIds: Value(_sn(raw['recipient_employee_ids'])),
    isBroadcast: Value(_b(raw['is_broadcast'])),
    readByEmployeeIds: Value(_s(raw['read_by_employee_ids'])),
    accountId: Value(_sn(raw['account_id'])),
    branchId: Value(_sn(raw['branch_id'])),
    sentAt: Value(_dt(raw['sent_at'])),
    lastModified: Value(_dt(raw['last_modified'])),
    isDeleted: Value(_b(raw['is_deleted'])),
    syncVersion: Value(_i(raw['sync_version'])),
  );

  PromotionsTableCompanion _mapToPromotion(Map<String, dynamic> raw) => PromotionsTableCompanion(
    id: Value(_s(raw['id'])),
    name: Value(_s(raw['name'])),
    selectedMedicineIds: Value(_sn(raw['selected_medicine_ids'])),
    categoryId: Value(_sn(raw['category_id'])),
    brandId: Value(_sn(raw['brand_id'])),
    priority: Value(_i(raw['priority'])),
    discountType: Value(_s(raw['discount_type'])),
    discountValue: Value(_d(raw['discount_value'])),
    startDate: Value(_dt(raw['start_date'])),
    endDate: Value(_dt(raw['end_date'])),
    isActive: Value(_b(raw['is_active'])),
    branchId: Value(_s(raw['branch_id'])),
    accountId: Value(_s(raw['account_id'])),
    lastModified: Value(_dt(raw['last_modified'])),
    isDeleted: Value(_b(raw['is_deleted'])),
    syncVersion: Value(_i(raw['sync_version'])),
  );

  FreeReturnsTableCompanion _mapToFreeReturn(Map<String, dynamic> raw) => FreeReturnsTableCompanion(
    id: Value(_s(raw['id'])),
    returnNumber: Value(_s(raw['return_number'])),
    returnCategory: Value(_s(raw['return_category'])),
    partyType: Value(_s(raw['party_type'])),
    partyId: Value(_sn(raw['party_id'])),
    partyName: Value(_s(raw['party_name'])),
    cashRegisterId: Value(_s(raw['cash_register_id'])),
    items: Value(_j(raw['items'])),
    reasonNotes: Value(_sn(raw['reason_notes'])),
    totalAmount: Value(_d(raw['total_amount'])),
    createdBy: Value(_s(raw['created_by'])),
    branchId: Value(_s(raw['branch_id'])),
    accountId: Value(_s(raw['account_id'])),
    createdAt: Value(_dt(raw['created_at'])),
    lastModified: Value(_dt(raw['last_modified'])),
    isDeleted: Value(_b(raw['is_deleted'])),
    syncVersion: Value(_i(raw['sync_version'])),
  );

  InvoiceReturnsTableCompanion _mapToInvoiceReturn(Map<String, dynamic> raw) => InvoiceReturnsTableCompanion(
    id: Value(_s(raw['id'])),
    returnNumber: Value(_s(raw['return_number'])),
    originalInvoiceNumber: Value(_s(raw['original_invoice_number'])),
    originalInvoiceId: Value(_s(raw['original_invoice_id'])),
    customerName: Value(_s(raw['customer_name'])),
    customerId: Value(_sn(raw['customer_id'])),
    items: Value(_j(raw['items'])),
    returnDiscount: Value(_d(raw['return_discount'])),
    totalReturnAmount: Value(_d(raw['total_return_amount'])),
    createdBy: Value(_s(raw['created_by'])),
    branchId: Value(_s(raw['branch_id'])),
    accountId: Value(_s(raw['account_id'])),
    notes: Value(_sn(raw['notes'])),
    createdAt: Value(_dt(raw['created_at'])),
    lastModified: Value(_dt(raw['last_modified'])),
    isDeleted: Value(_b(raw['is_deleted'])),
    syncVersion: Value(_i(raw['sync_version'])),
  );

  QuotationsTableCompanion _mapToQuotation(Map<String, dynamic> raw) => QuotationsTableCompanion(
    id: Value(_s(raw['id'])),
    quotationNumber: Value(_s(raw['quotation_number'])),
    customerName: Value(_s(raw['customer_name'])),
    customerPhone: Value(_sn(raw['customer_phone'])),
    items: Value(_j(raw['items'])),
    subtotalAmount: Value(_d(raw['subtotal_amount'])),
    discountAmount: Value(_d(raw['discount_amount'])),
    finalAmount: Value(_d(raw['final_amount'])),
    status: Value(_s(raw['status'])),
    createdBy: Value(_s(raw['created_by'])),
    branchId: Value(_s(raw['branch_id'])),
    accountId: Value(_s(raw['account_id'])),
    notes: Value(_sn(raw['notes'])),
    createdAt: Value(_dt(raw['created_at'])),
    lastModified: Value(_dt(raw['last_modified'])),
    isDeleted: Value(_b(raw['is_deleted'])),
    syncVersion: Value(_i(raw['sync_version'])),
  );

  ShippingOrdersTableCompanion _mapToShipping(Map<String, dynamic> raw) => ShippingOrdersTableCompanion(
    id: Value(_s(raw['id'])),
    invoiceNumber: Value(_s(raw['invoice_number'])),
    invoiceId: Value(_s(raw['invoice_id'])),
    shippingDate: Value(_dt(raw['shipping_date'])),
    customerName: Value(_s(raw['customer_name'])),
    customerPhone: Value(_sn(raw['customer_phone'])),
    shippingAddress: Value(_s(raw['shipping_address'])),
    shippingDetails: Value(_sn(raw['shipping_details'])),
    deliveredTo: Value(_sn(raw['delivered_to'])),
    deliveryAgentId: Value(_sn(raw['delivery_agent_id'])),
    deliveryAgentName: Value(_sn(raw['delivery_agent_name'])),
    shippingStatus: Value(_s(raw['shipping_status'])),
    isPaid: Value(_b(raw['is_paid'])),
    notes: Value(_sn(raw['notes'])),
    documentUrls: Value(_sn(raw['document_urls'])),
    createdBy: Value(_s(raw['created_by'])),
    branchId: Value(_s(raw['branch_id'])),
    accountId: Value(_s(raw['account_id'])),
    lastModified: Value(_dt(raw['last_modified'])),
    isDeleted: Value(_b(raw['is_deleted'])),
    syncVersion: Value(_i(raw['sync_version'])),
  );

  PaymentVouchersTableCompanion _mapToVoucher(Map<String, dynamic> raw) => PaymentVouchersTableCompanion(
    id: Value(_s(raw['id'])),
    voucherNumber: Value(_i(raw['voucher_number'])),
    voucherType: Value(_s(raw['voucher_type'])),
    partyId: Value(_sn(raw['party_id'])),
    partyName: Value(_s(raw['party_name'])),
    amount: Value(_d(raw['amount'])),
    paymentMethod: Value(_s(raw['payment_method'])),
    referenceNumber: Value(_sn(raw['reference_number'])),
    description: Value(_sn(raw['description'])),
    createdById: Value(_s(raw['created_by_id'])),
    branchId: Value(_s(raw['branch_id'])),
    accountId: Value(_s(raw['account_id'])),
    voucherDate: Value(_dt(raw['voucher_date'])),
    createdAt: Value(_dt(raw['created_at'])),
    lastModified: Value(_dt(raw['last_modified'])),
    isDeleted: Value(_b(raw['is_deleted'])),
    syncVersion: Value(_i(raw['sync_version'])),
  );

  ExpenseCategoriesTableCompanion _mapToExpenseCategory(Map<String, dynamic> raw) => ExpenseCategoriesTableCompanion(
    id: Value(_s(raw['id'])),
    name: Value(_s(raw['name'])),
    code: Value(_sn(raw['code'])),
    description: Value(_sn(raw['description'])),
    isActive: Value(_b(raw['is_active'])),
    accountId: Value(_sn(raw['account_id'])),
    lastModified: Value(_dt(raw['last_modified'])),
    isDeleted: Value(_b(raw['is_deleted'])),
    syncVersion: Value(_i(raw['sync_version'])),
  );

  AppSettingsTableCompanion _mapToSettings(Map<String, dynamic> raw) => AppSettingsTableCompanion(
    id: Value(_s(raw['id'])),
    pharmacyName: Value(_s(raw['pharmacy_name'])),
    pharmacyPhone: Value(_sn(raw['pharmacy_phone'])),
    pharmacyAddress: Value(_sn(raw['pharmacy_address'])),
    taxNumber: Value(_sn(raw['tax_number'])),
    currency: Value(_s(raw['currency'])),
    enableAutomaticPrint: Value(_b(raw['enable_automatic_print'])),
    enablePOSDrawer: Value(_b(raw['enable_pos_drawer'])),
    defaultReceiptFooter: Value(_sn(raw['default_receipt_footer'])),
    pharmacyNameEn: Value(_sn(raw['pharmacy_name_en'])),
    commercialRegister: Value(_sn(raw['commercial_register'])),
    logoUrl: Value(_sn(raw['logo_url'])),
    email: Value(_sn(raw['email'])),
    defaultLowStockThreshold: Value(_i(raw['default_low_stock_threshold'])),
    nearExpiryAlertDays: Value(_i(raw['near_expiry_alert_days'])),
    accountId: Value(_sn(raw['account_id'])),
    lastModified: Value(_dt(raw['last_modified'])),
  );

  BranchesTableCompanion _mapToBranch(Map<String, dynamic> raw) => BranchesTableCompanion(
    id: Value(_s(raw['id'])),
    name: Value(_s(raw['name'])),
    code: Value(_sn(raw['code'])),
    address: Value(_sn(raw['address'])),
    phone: Value(_sn(raw['phone'])),
    isMainBranch: Value(_b(raw['is_main_branch'])),
    isActive: Value(_b(raw['is_active'])),
    accountId: Value(_sn(raw['account_id'])),
    lastModified: Value(_dt(raw['last_modified'])),
    isDeleted: Value(_b(raw['is_deleted'])),
  );

  UsersTableCompanion _mapToUser(Map<String, dynamic> raw) => UsersTableCompanion(
    id: Value(_s(raw['id'])),
    name: Value(_s(raw['name'])),
    email: Value(_s(raw['email'])),
    role: Value(_s(raw['role'])),
    assignedBranchId: Value(_sn(raw['assigned_branch_id'])),
    accountId: Value(_sn(raw['account_id'])),
    isActive: Value(_b(raw['is_active'])),
    createdAt: Value(_dt(raw['created_at'])),
    lastLogin: Value(_dtn(raw['last_login'])),
    activeDeviceId: Value(_sn(raw['active_device_id'])),
    syncVersion: Value(_i(raw['sync_version'])),
    lastModified: Value(_dt(raw['last_modified'])),
    isDeleted: Value(_b(raw['is_deleted'])),
  );

  PermissionsTableCompanion _mapToPermission(Map<String, dynamic> raw) => PermissionsTableCompanion(
    id: Value(_s(raw['id'])),
    userId: Value(_s(raw['user_id'])),
    permissionKey: Value(_s(raw['permission_key'])),
    isAllowed: Value(_b(raw['is_allowed'])),
    accountId: Value(_sn(raw['account_id'])),
    lastModified: Value(_dt(raw['last_modified'])),
  );

  NotificationsTableCompanion _mapToNotification(Map<String, dynamic> raw) => NotificationsTableCompanion(
    id: Value(_s(raw['id'])),
    title: Value(_s(raw['title'])),
    message: Value(_s(raw['message'])),
    type: Value(_s(raw['type'])),
    targetRoute: Value(_sn(raw['target_route'])),
    isRead: Value(_b(raw['is_read'])),
    accountId: Value(_sn(raw['account_id'])),
    branchId: Value(_sn(raw['branch_id'])),
    createdAt: Value(_dt(raw['created_at'])),
  );

  AuditLogsTableCompanion _mapToAuditLog(Map<String, dynamic> raw) => AuditLogsTableCompanion(
    id: Value(_s(raw['id'])),
    actionType: Value(_s(raw['action_type'])),
    actionDetails: Value(_s(raw['action_details'])),
    performedById: Value(_s(raw['performed_by_id'])),
    performedByName: Value(_s(raw['performed_by_name'])),
    branchId: Value(_s(raw['branch_id'])),
    accountId: Value(_sn(raw['account_id'])),
    createdAt: Value(_dt(raw['created_at'])),
  );

  SupplierCustomersTableCompanion _mapToSupplierCustomer(Map<String, dynamic> raw) => SupplierCustomersTableCompanion(
    id: Value(_s(raw['id'])),
    name: Value(_s(raw['name'])),
    phone: Value(_sn(raw['phone'])),
    address: Value(_sn(raw['address'])),
    email: Value(_sn(raw['email'])),
    companyName: Value(_sn(raw['company_name'])),
    taxId: Value(_sn(raw['tax_id'])),
    creditLimit: Value(_d(raw['credit_limit'])),
    discountPercent: Value(_d(raw['discount_percent'])),
    paymentTermDays: Value(_i(raw['payment_term_days'])),
    supplierBalance: Value(_d(raw['supplier_balance'])),
    customerBalance: Value(_d(raw['customer_balance'])),
    isActive: Value(_b(raw['is_active'])),
    notes: Value(_sn(raw['notes'])),
    branchId: Value(_sn(raw['branch_id'])),
    accountId: Value(_sn(raw['account_id'])),
    lastModified: Value(_dt(raw['last_modified'])),
    isDeleted: Value(_b(raw['is_deleted'])),
  );

  ContactLedgersTableCompanion _mapToContactLedger(Map<String, dynamic> raw) => ContactLedgersTableCompanion(
    id: Value(_s(raw['id'])),
    contactId: Value(_s(raw['contact_id'] ?? raw['customer_id'] ?? raw['supplier_id'])),
    entryDate: Value(_dt(raw['entry_date'] ?? raw['transaction_date'] ?? raw['created_at'])),
    referenceNumber: Value(_s(raw['reference_number'] ?? raw['reference_id'])),
    entryType: Value(_s(raw['entry_type'] ?? raw['transaction_type'] ?? raw['type'])),
    debit: Value(_d(raw['debit'] ?? raw['debit_amount'])),
    credit: Value(_d(raw['credit'] ?? raw['credit_amount'])),
    balanceAfter: Value(_d(raw['balance_after'] ?? raw['running_balance'])),
    description: Value(_sn(raw['description'] ?? raw['notes'])),
    branchId: Value(_sn(raw['branch_id'])),
    accountId: Value(_sn(raw['account_id'])),
    lastModified: Value(_dt(raw['last_modified'])),
    isDeleted: Value(_b(raw['is_deleted'])),
    syncVersion: Value(_i(raw['sync_version'])),
  );

  CustomerGroupsTableCompanion _mapToCustomerGroup(Map<String, dynamic> raw) => CustomerGroupsTableCompanion(
    id: Value(_s(raw['id'])),
    name: Value(_s(raw['name'])),
    discountPercent: Value(_d(raw['discount_percent'] ?? raw['amount'])),
    priceGroupId: Value(_sn(raw['price_group_id'])),
    description: Value(_sn(raw['description'])),
    isActive: Value(_b(raw['is_active'])),
    accountId: Value(_sn(raw['account_id'])),
    lastModified: Value(_dt(raw['last_modified'])),
    isDeleted: Value(_b(raw['is_deleted'])),
    syncVersion: Value(_i(raw['sync_version'])),
  );

  // ─── Helpers ──────────────────────────────────────────────────────

  String _s(dynamic v) => (v as String?) ?? '';
  String? _sn(dynamic v) => v as String?;
  int _i(dynamic v) => (v as num?)?.toInt() ?? 0;
  double _d(dynamic v) => (v as num?)?.toDouble() ?? 0.0;
  double? _ddn(dynamic v) => (v as num?)?.toDouble();
  bool _b(dynamic v) => v as bool? ?? false;
  DateTime _dt(dynamic v) {
    if (v == null) return DateTime(2000);
    if (v is DateTime) return v;
    return DateTime.tryParse(v.toString()) ?? DateTime(2000);
  }
  DateTime? _dtn(dynamic v) {
    if (v == null) return null;
    if (v is DateTime) return v;
    return DateTime.tryParse(v.toString());
  }
  String _j(dynamic v) {
    if (v == null) return '[]';
    if (v is String) return v;
    return jsonEncode(v);
  }
}
