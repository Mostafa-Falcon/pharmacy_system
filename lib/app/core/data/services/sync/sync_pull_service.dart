import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:drift/drift.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/core/data/database/daos/sync_dao.dart';
import 'package:pharmacy_system/app/core/data/services/sync/sync_service.dart';
import 'package:pharmacy_system/app/core/utils/app_utils.dart';

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
    const int pageSize = 1000;

    try {
      while (hasMore) {
        dynamic query = _supabase.from(tableName).select();

        // التصفية بالفرع إذا لم يكن جدولاً عالمياً
        const globalTables = {
          'branches',
          'users',
          'permissions',
          'customer_groups',
          'app_settings',
          'item_batches',
          'medicine_units'
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

          // تتبع أحدث تاريخ تعديل
          final itemModified = _dt(json['last_modified']);
          if (itemModified.isAfter(maxModified)) {
            maxModified = itemModified;
          }

          final recordId = json['id']?.toString() ?? '';
          if (recordId.isNotEmpty) {
            final hasPending = await _syncDao.hasUnsyncedForRecord(tableName, recordId);
            if (hasPending) {
              safeDebugPrint(
                'SyncPullService: Protecting unsynced local record $recordId in $tableName from remote overwrite',
              );
              continue;
            }
          }

          await _upsertToTable(tableName, json);
          totalUpdated++;
        }

        // إذا كان عدد النتائج أقل من الصفحة، فهذا يعني أننا انتهينا
        if (response.length < pageSize) {
          hasMore = false;
        }

        // تحديث العلامة المائية تدريجياً لضمان عدم فقدان التقدم
        await _syncDao.upsertWatermark(
          tableName: tableName,
          watermark: maxModified,
          branchId: branchId,
        );
      }

      if (totalUpdated > 0) {
        // إخطار المنظومة بأن الجدول تم تحديثه لتنشيط الـ Streams
        SyncService.onTableUpdated?.call(tableName, branchId);
        
        safeDebugPrint(
          'SyncPullService: Succeeded pulling $totalUpdated records for table $tableName',
        );
      }
      return totalUpdated;
    } catch (e, s) {
      safeDebugPrint(
        'SyncPullService: Error pulling table $tableName: $e\n$s',
      );
      return totalUpdated; // نرجع ما تم سحبه فعلياً قبل الخطأ
    }
  }

  Future<void> _upsertToTable(String tableName, Map<String, dynamic> data) async {
    final db = GetIt.instance<AppDatabase>();

    switch (tableName) {
      case 'branches':
        await db.into(db.branchesTable).insertOnConflictUpdate(_mapToBranch(data));
        break;
      case 'users':
        await db.into(db.usersTable).insertOnConflictUpdate(_mapToUser(data));
        break;
      case 'permissions':
        await db.into(db.permissionsTable).insertOnConflictUpdate(_mapToPermission(data));
        break;
      case 'customers':
        await db.into(db.customersTable).insertOnConflictUpdate(_mapToCustomer(data));
        break;
      case 'suppliers':
        await db.into(db.suppliersTable).insertOnConflictUpdate(_mapToSupplier(data));
        break;
      case 'supplier_customers':
        await db.into(db.supplierCustomersTable).insertOnConflictUpdate(_mapToSupplierCustomer(data));
        break;
      case 'medicines':
        await db.into(db.medicinesTable).insertOnConflictUpdate(_mapToMedicine(data));
        break;
      case 'sales':
        await db.into(db.salesTable).insertOnConflictUpdate(_mapToSale(data));
        break;
      case 'purchases':
        await db.into(db.purchasesTable).insertOnConflictUpdate(_mapToPurchase(data));
        break;
      case 'inventory':
        await db.into(db.inventoryTable).insertOnConflictUpdate(_mapToInventory(data));
        break;
      case 'customer_groups':
        await db.into(db.customerGroupsTable).insertOnConflictUpdate(_mapToCustomerGroup(data));
        break;
      case 'cashier_shifts':
        await db.into(db.cashierShiftsTable).insertOnConflictUpdate(_mapToCashierShift(data));
        break;
      case 'quotes':
        await db.into(db.quotesTable).insertOnConflictUpdate(_mapToQuote(data));
        break;
      case 'returns':
        await db.into(db.returnsTable).insertOnConflictUpdate(_mapToReturn(data));
        break;
      case 'stock_transfers':
        await db.into(db.stockTransfersTable).insertOnConflictUpdate(_mapToStockTransfer(data));
        break;
      case 'customer_ledgers':
        await db.into(db.customerLedgersTable).insertOnConflictUpdate(_mapToCustomerLedger(data));
        break;
      case 'supplier_ledgers':
        await db.into(db.supplierLedgersTable).insertOnConflictUpdate(_mapToSupplierLedger(data));
        break;
      default:
        safeDebugPrint('SyncPullService: Table $tableName mapping not implemented yet.');
    }
  }

  // ─── Mappings ──────────────────────────────────────────────────────

  BranchesTableCompanion _mapToBranch(Map<String, dynamic> raw) => BranchesTableCompanion(
    id: Value(_s(raw['id'])),
    name: Value(_s(raw['name'])),
    address: Value(_sn(raw['address'])),
    phone: Value(_sn(raw['phone'])),
    isActive: Value(_b(raw['is_active'])),
    createdAt: Value(_dt(raw['created_at'])),
    syncVersion: Value(_i(raw['sync_version'])),
    lastModified: Value(_dt(raw['last_modified'])),
    isDeleted: Value(_b(raw['is_deleted'])),
  );

  UsersTableCompanion _mapToUser(Map<String, dynamic> raw) => UsersTableCompanion(
    id: Value(_s(raw['id'])),
    name: Value(_s(raw['name'])),
    email: Value(_s(raw['email'])),
    passwordHash: Value(_s(raw['password_hash'])),
    role: Value(_s(raw['role'])),
    assignedBranchId: Value(_sn(raw['assigned_branch_id'])),
    isActive: Value(_b(raw['is_active'])),
    createdAt: Value(_dt(raw['created_at'])),
    lastLogin: Value(_dn(raw['last_login'])),
    syncVersion: Value(_i(raw['sync_version'])),
    lastModified: Value(_dt(raw['last_modified'])),
    isDeleted: Value(_b(raw['is_deleted'])),
    activeDeviceId: Value(_sn(raw['active_device_id'])),
  );

  PermissionsTableCompanion _mapToPermission(Map<String, dynamic> raw) => PermissionsTableCompanion(
    id: Value(_s(raw['id'])),
    userId: Value(_s(raw['user_id'])),
    permissionKey: Value(_s(raw['permission_key'])),
    isAllowed: Value(_b(raw['is_allowed'])),
    createdAt: Value(_dt(raw['created_at'])),
    syncVersion: Value(_i(raw['sync_version'])),
    isDeleted: Value(_b(raw['is_deleted'])),
    lastModified: Value(_dt(raw['last_modified'])),
  );

  CustomersTableCompanion _mapToCustomer(Map<String, dynamic> raw) => CustomersTableCompanion(
    id: Value(_s(raw['id'])),
    name: Value(_s(raw['name'])),
    phone: Value(_sn(raw['phone'])),
    address: Value(_sn(raw['address'])),
    isActive: Value(_b(raw['is_active'])),
    kind: Value(_s(raw['kind'])),
    companyName: Value(_sn(raw['company_name'])),
    email: Value(_sn(raw['email'])),
    taxId: Value(_sn(raw['tax_id'])),
    creditLimit: Value(_d(raw['credit_limit'])),
    discountPercent: Value(_d(raw['discount_percent'])),
    paymentTermDays: Value(_i(raw['payment_term_days'])),
    notes: Value(_sn(raw['notes'])),
    lastModified: Value(_dt(raw['last_modified'])),
    isDeleted: Value(_b(raw['is_deleted'])),
    salesRepId: Value(_sn(raw['sales_rep_id'])),
    branchId: Value(_s(raw['branch_id'])),
  );

  SuppliersTableCompanion _mapToSupplier(Map<String, dynamic> raw) => SuppliersTableCompanion(
    id: Value(_s(raw['id'])),
    name: Value(_s(raw['name'])),
    phone: Value(_sn(raw['phone'])),
    address: Value(_sn(raw['address'])),
    isActive: Value(_b(raw['is_active'])),
    isDeleted: Value(_b(raw['is_deleted'])),
    lastModified: Value(_dt(raw['last_modified'])),
    partyType: Value(_s(raw['party_type'])),
    companyName: Value(_sn(raw['company_name'])),
    email: Value(_sn(raw['email'])),
    taxId: Value(_sn(raw['tax_id'])),
    creditLimit: Value(_d(raw['credit_limit'])),
    discountPercent: Value(_d(raw['discount_percent'])),
    paymentTermDays: Value(_i(raw['payment_term_days'])),
    notes: Value(_sn(raw['notes'])),
    branchId: Value(_s(raw['branch_id'])),
  );

  SupplierCustomersTableCompanion _mapToSupplierCustomer(Map<String, dynamic> raw) => SupplierCustomersTableCompanion(
    id: Value(_s(raw['id'])),
    name: Value(_s(raw['name'])),
    phone: Value(_sn(raw['phone'])),
    address: Value(_sn(raw['address'])),
    email: Value(_sn(raw['email'])),
    companyName: Value(_sn(raw['company_name'])),
    taxId: Value(_sn(raw['tax_id'])),
    isActive: Value(_b(raw['is_active'])),
    notes: Value(_sn(raw['notes'])),
    customerKindIndex: Value(_i(raw['customer_kind_index'])),
    creditLimit: Value(_d(raw['credit_limit'])),
    discountPercent: Value(_d(raw['discount_percent'])),
    paymentTermDays: Value(_i(raw['payment_term_days'])),
    supplierPartyTypeIndex: Value(_i(raw['supplier_party_type_index'])),
    lastModified: Value(_dt(raw['last_modified'])),
    isDeleted: Value(_b(raw['is_deleted'])),
    branchId: Value(_s(raw['branch_id'])),
  );

  MedicinesTableCompanion _mapToMedicine(Map<String, dynamic> raw) => MedicinesTableCompanion(
    id: Value(_s(raw['id'])),
    name: Value(_s(raw['name'])),
    nameEn: Value(_sn(raw['name_en'])),
    category: Value(_sn(raw['category'])),
    barcodes: Value(_j(raw['barcodes'])),
    buyPrice: Value(_d(raw['buy_price'])),
    sellPrice: Value(_d(raw['sell_price'])),
    quantity: Value(_i(raw['quantity'])),
    minStock: Value(_i(raw['min_stock'])),
    expiryDate: Value(_dn(raw['expiry_date'])),
    manufacturer: Value(_sn(raw['manufacturer'])),
    branchId: Value(_s(raw['branch_id'])),
    syncVersion: Value(_i(raw['sync_version'])),
    lastModified: Value(_dt(raw['last_modified'])),
    isDeleted: Value(_b(raw['is_deleted'])),
    dosageForm: Value(_sn(raw['dosage_form'])),
    strength: Value(_sn(raw['strength'])),
    packageSize: Value(_sn(raw['package_size'])),
    expiryTrackingEnabled: Value(_b(raw['expiry_tracking_enabled'])),
    supplierName: Value(_sn(raw['supplier_name'])),
    description: Value(_sn(raw['description'])),
    oldSellPrice: Value(_ddn(raw['old_sell_price'])),
    itemTypeId: Value(_sn(raw['item_type_id'])),
    groupId: Value(_sn(raw['group_id'])),
    units: Value(_j(raw['units'])),
    alertEnabled: Value(_b(raw['alert_enabled'])),
    dosageFormEnabled: Value(_b(raw['dosage_form_enabled'])),
    imageUrl: Value(_sn(raw['image_url'])),
    containerShape: Value(_sn(raw['container_shape'])),
    allowNegativeStock: Value(_b(raw['allow_negative_stock'])),
    isTaxable: Value(_b(raw['is_taxable'])),
    taxType: Value(_sn(raw['tax_type'])),
    taxValue: Value(_ddn(raw['tax_value'])),
    pricesIncludeTax: Value(_b(raw['prices_include_tax'])),
    location: Value(_sn(raw['location'])),
    isActive: Value(_b(raw['is_active'])),
    createdAt: Value(_dn(raw['created_at'])),
  );

  SalesTableCompanion _mapToSale(Map<String, dynamic> raw) => SalesTableCompanion(
    id: Value(_s(raw['id'])),
    branchId: Value(_s(raw['branch_id'])),
    customerId: Value(_sn(raw['customer_id'])),
    customerName: Value(_sn(raw['customer_name'])),
    items: Value(_j(raw['items'])),
    totalAmount: Value(_d(raw['total_amount'])),
    discount: Value(_ddn(raw['discount'])),
    finalAmount: Value(_d(raw['final_amount'])),
    taxAmount: Value(_ddn(raw['tax_amount'])),
    paymentMethod: Value(_s(raw['payment_method'])),
    notes: Value(_sn(raw['notes'])),
    createdBy: Value(_s(raw['created_by'])),
    createdAt: Value(_dt(raw['created_at'])),
    syncVersion: Value(_i(raw['sync_version'])),
    lastModified: Value(_dt(raw['last_modified'])),
    isDeleted: Value(_b(raw['is_deleted'])),
    paidAmount: Value(_ddn(raw['paid_amount'])),
    receiptNumber: Value(_sn(raw['receipt_number'])),
    salesRepId: Value(_sn(raw['sales_rep_id'])),
  );

  PurchasesTableCompanion _mapToPurchase(Map<String, dynamic> raw) => PurchasesTableCompanion(
    id: Value(_s(raw['id'])),
    branchId: Value(_s(raw['branch_id'])),
    supplierId: Value(_sn(raw['supplier_id'])),
    supplierName: Value(_s(raw['supplier_name'])),
    items: Value(_j(raw['items'])),
    totalAmount: Value(_d(raw['total_amount'])),
    discount: Value(_ddn(raw['discount'])),
    finalAmount: Value(_d(raw['final_amount'])),
    paymentMethod: Value(_s(raw['payment_method'])),
    notes: Value(_sn(raw['notes'])),
    createdBy: Value(_s(raw['created_by'])),
    createdAt: Value(_dt(raw['created_at'])),
    syncVersion: Value(_i(raw['sync_version'])),
    lastModified: Value(_dt(raw['last_modified'])),
    isDeleted: Value(_b(raw['is_deleted'])),
    status: Value(_s(raw['status'])),
    sourceType: Value(_sn(raw['source_type'])),
    receiptNumber: Value(_sn(raw['receipt_number'])),
    shippingAmount: Value(_ddn(raw['shipping_amount'])),
    deliveryAmount: Value(_ddn(raw['delivery_amount'])),
    supplierPartyType: Value(_sn(raw['supplier_party_type'])),
    invoiceDiscountType: Value(_sn(raw['invoice_discount_type'])),
    invoiceDiscountValue: Value(_ddn(raw['invoice_discount_value'])),
    invoiceDiscountAmount: Value(_ddn(raw['invoice_discount_amount'])),
    invoiceTaxType: Value(_sn(raw['invoice_tax_type'])),
    invoiceTaxValue: Value(_ddn(raw['invoice_tax_value'])),
    invoiceTaxAmount: Value(_ddn(raw['invoice_tax_amount'])),
    paymentAccountId: Value(_sn(raw['payment_account_id'])),
    paymentAccountName: Value(_sn(raw['payment_account_name'])),
  );

  InventoryTableCompanion _mapToInventory(Map<String, dynamic> raw) => InventoryTableCompanion(
    id: Value(_s(raw['id'])),
    branchId: Value(_s(raw['branch_id'])),
    medicineId: Value(_s(raw['medicine_id'])),
    currentQuantity: Value(_i(raw['quantity'])),
    lastModified: Value(_dt(raw['last_modified'])),
    syncVersion: Value(_i(raw['sync_version'])),
  );

  CustomerGroupsTableCompanion _mapToCustomerGroup(Map<String, dynamic> raw) => CustomerGroupsTableCompanion(
    id: Value(_s(raw['id'])),
    name: Value(_s(raw['name'])),
    discountPercent: Value(_d(raw['discount_percent'])),
    priceGroupId: Value(_sn(raw['price_group_id'])),
    description: Value(_sn(raw['description'])),
    isActive: Value(_b(raw['is_active'])),
    lastModified: Value(_dt(raw['last_modified'])),
    isDeleted: Value(_b(raw['is_deleted'])),
  );

  CashierShiftsTableCompanion _mapToCashierShift(Map<String, dynamic> raw) => CashierShiftsTableCompanion(
    id: Value(_s(raw['id'])),
    branchId: Value(_s(raw['branch_id'])),
    shiftNumber: Value(_i(raw['shift_number'])),
    cashierId: Value(_s(raw['user_id'])),
    cashierName: Value(_s(raw['user_name'])),
    deviceId: Value(_s(raw['device_id'])),
    openedAt: Value(_dt(raw['start_time'])),
    closedAt: Value(_dn(raw['end_time'])),
    openingCash: Value(_d(raw['starting_cash'])),
    expectedCash: Value(_ddn(raw['expected_cash'])),
    countedCash: Value(_ddn(raw['actual_cash'])),
    difference: Value(_ddn(raw['difference'])),
    status: Value(_s(raw['status'])),
    notes: Value(_sn(raw['notes'])),
    syncVersion: Value(_i(raw['sync_version'])),
    lastModified: Value(_dt(raw['last_modified'])),
    isDeleted: Value(_b(raw['is_deleted'])),
  );

  QuotesTableCompanion _mapToQuote(Map<String, dynamic> raw) => QuotesTableCompanion(
    id: Value(_s(raw['id'])),
    branchId: Value(_s(raw['branch_id'])),
    customerName: Value(_s(raw['customer_name'])),
    items: Value(_j(raw['items'])),
    total: Value(_d(raw['total_amount'])),
    status: Value(_s(raw['status'])),
    notes: Value(_sn(raw['notes'])),
    createdAt: Value(_dt(raw['created_at'])),
    syncVersion: Value(_i(raw['sync_version'])),
    lastModified: Value(_dt(raw['last_modified'])),
    isDeleted: Value(_b(raw['is_deleted'])),
  );

  ReturnsTableCompanion _mapToReturn(Map<String, dynamic> raw) => ReturnsTableCompanion(
    id: Value(_s(raw['id'])),
    branchId: Value(_s(raw['branch_id'])),
    items: Value(_j(raw['items'])),
    totalAmount: Value(_d(raw['total_amount'])),
    reason: Value(_s(raw['reason'] ?? '')),
    createdBy: Value(_s(raw['created_by'])),
    createdAt: Value(_dt(raw['created_at'])),
    syncVersion: Value(_i(raw['sync_version'])),
    lastModified: Value(_dt(raw['last_modified'])),
    isDeleted: Value(_b(raw['is_deleted'])),
  );


  StockTransfersTableCompanion _mapToStockTransfer(Map<String, dynamic> raw) => StockTransfersTableCompanion(
    id: Value(_s(raw['id'])),
    branchId: Value(_s(raw['branch_id'])),
    fromBranchId: Value(_s(raw['from_branch_id'])),
    toBranchId: Value(_s(raw['to_branch_id'])),
    fromBranchName: Value(_s(raw['from_branch_name'])),
    toBranchName: Value(_s(raw['to_branch_name'])),
    transferNumber: Value(_i(raw['transfer_number'])),
    items: Value(_j(raw['items'])),
    status: Value(_s(raw['status'])),
    notes: Value(_sn(raw['notes'])),
    createdBy: Value(_s(raw['created_by'])),
    createdAt: Value(_dt(raw['created_at'])),
    updatedAt: Value(_dt(raw['updated_at'])),
    receivedAt: Value(_dn(raw['received_at'])),
    receivedBy: Value(_sn(raw['received_by'])),
    syncVersion: Value(_i(raw['sync_version'])),
    isDeleted: Value(_b(raw['is_deleted'])),
  );

  CustomerLedgersTableCompanion _mapToCustomerLedger(Map<String, dynamic> raw) => CustomerLedgersTableCompanion(
    id: Value(_s(raw['id'])),
    customerId: Value(_s(raw['customer_id'])),
    branchId: Value(_s(raw['branch_id'])),
    type: Value(_s(raw['type'])),
    debit: Value(_d(raw['debit'])),
    credit: Value(_d(raw['credit'])),
    balanceAfter: Value(_d(raw['balance_after'])),
    referenceId: Value(_sn(raw['reference_id'])),
    referenceNumber: Value(_sn(raw['reference_number'])),
    notes: Value(_sn(raw['notes'])),
    createdBy: Value(_sn(raw['created_by'])),
    entryDate: Value(_dt(raw['entry_date'])),
    syncVersion: Value(_i(raw['sync_version'])),
    lastModified: Value(_dt(raw['last_modified'])),
    isDeleted: Value(_b(raw['is_deleted'])),
  );

  SupplierLedgersTableCompanion _mapToSupplierLedger(Map<String, dynamic> raw) => SupplierLedgersTableCompanion(
    id: Value(_s(raw['id'])),
    supplierId: Value(_s(raw['supplier_id'])),
    branchId: Value(_s(raw['branch_id'])),
    type: Value(_s(raw['type'])),
    debit: Value(_d(raw['debit'])),
    credit: Value(_d(raw['credit'])),
    balanceAfter: Value(_d(raw['balance_after'])),
    referenceId: Value(_sn(raw['reference_id'])),
    referenceNumber: Value(_sn(raw['reference_number'])),
    notes: Value(_sn(raw['notes'])),
    createdBy: Value(_sn(raw['created_by'])),
    entryDate: Value(_dt(raw['entry_date'])),
    syncVersion: Value(_i(raw['sync_version'])),
    lastModified: Value(_dt(raw['last_modified'])),
    isDeleted: Value(_b(raw['is_deleted'])),
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
  DateTime? _dn(dynamic v) => v is DateTime ? v : (v != null ? DateTime.tryParse(v.toString()) : null);
  String _j(dynamic v) {
    if (v == null) return '[]';
    if (v is String) return v;
    return jsonEncode(v);
  }
}
