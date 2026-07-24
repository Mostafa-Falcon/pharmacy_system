import 'dart:async';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'package:pharmacy_system/app/core/injection.dart';
import 'package:pharmacy_system/app/core/utils/app_utils.dart';
import 'package:pharmacy_system/app/core/data/database/daos/contacts_dao.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/core/sync/sync_service.dart';
import 'package:pharmacy_system/app/core/models/contacts/customer_ledger_model.dart';
import 'package:pharmacy_system/app/core/models/contacts/supplier_ledger_model.dart';

class LedgerService {
  static const _uuid = Uuid();

  static final ContactsDao _contactsDao = sl<ContactsDao>();

  static List<ContactLedgersTableData> _customerCache = [];
  static List<ContactLedgersTableData> _supplierCache = [];
  static bool _customerReady = false;
  static bool _supplierReady = false;

  static Future<void> _ensureCustomerReady() async {
    if (!_customerReady) {
      _customerCache = await _contactsDao.getAllContactLedgers();
      _customerReady = true;
    }
  }

  static Future<void> _ensureSupplierReady() async {
    if (!_supplierReady) {
      _supplierCache = await _contactsDao.getAllContactLedgers();
      _supplierReady = true;
    }
  }

  // ==================== Customer Ledger Methods ====================
  static Future<void> insertCustomerEntry(ContactLedgerModel entry) async {
    await _ensureCustomerReady();
    await _customerDao.upsert(CustomerLedgersTableCompanion(
      id: Value(entry.id),
      customerId: Value(entry.customerId),
      branchId: Value(entry.branchId),
      type: Value(entry.type.name),
      debit: Value(entry.debit),
      credit: Value(entry.credit),
      balanceAfter: Value(entry.balanceAfter),
      referenceId: Value(entry.referenceId),
      referenceNumber: Value(entry.referenceNumber),
      notes: Value(entry.notes),
      createdBy: Value(entry.createdBy),
      entryDate: Value(entry.entryDate),
      syncVersion: Value(entry.syncVersion),
      lastModified: Value(DateTime.now()),
      isDeleted: const Value(false),
    ));
    final saved = await _customerDao.getById(entry.id);
    if (saved != null) _customerCache.add(saved);

    SyncService.onTableUpdated?.call('customer_ledgers', entry.branchId);
    unawaited(
      SyncService.queueOperation(
        type: SyncOperationType.create,
        table: 'customer_ledgers',
        data: entry.toJson(),
        branchId: entry.branchId,
      ),
    );
  }

  static Future<void> updateCustomerEntry(ContactLedgerModel entry) async {
    await _ensureCustomerReady();
    await _customerDao.upsert(CustomerLedgersTableCompanion(
      id: Value(entry.id),
      customerId: Value(entry.customerId),
      branchId: Value(entry.branchId),
      type: Value(entry.type.name),
      debit: Value(entry.debit),
      credit: Value(entry.credit),
      balanceAfter: Value(entry.balanceAfter),
      referenceId: Value(entry.referenceId),
      referenceNumber: Value(entry.referenceNumber),
      notes: Value(entry.notes),
      createdBy: Value(entry.createdBy),
      entryDate: Value(entry.entryDate),
      syncVersion: Value(entry.syncVersion + 1),
      lastModified: Value(DateTime.now()),
      isDeleted: Value(entry.isDeleted),
    ));
    final saved = await _customerDao.getById(entry.id);
    if (saved != null) {
      final idx = _customerCache.indexWhere((e) => e.id == entry.id);
      if (idx >= 0) _customerCache[idx] = saved;
    }
    SyncService.onTableUpdated?.call('customer_ledgers', entry.branchId);
    unawaited(
      SyncService.queueOperation(
        type: SyncOperationType.update,
        table: 'customer_ledgers',
        data: entry.toJson(),
        branchId: entry.branchId,
      ),
    );
  }

  static Future<void> deleteCustomerEntry(String id) async {
    await _ensureCustomerReady();
    await _customerDao.softDelete(id);
    _customerCache.removeWhere((e) => e.id == id);
    SyncService.onTableUpdated?.call('customer_ledgers', '');
    unawaited(
      _queueOp(SyncOperationType.delete, 'customer_ledgers', {'id': id, 'is_deleted': true}, ''),
    );
  }

  static Future<List<ContactLedgerModel>> getCustomerEntries(
    String customerId,
    String branchId,
  ) async {
    await _ensureCustomerReady();
    return _customerCache
        .where((e) => e.customerId == customerId && e.branchId == branchId && !e.isDeleted)
        .map(_toCustomerModel)
        .toList()
      ..sort((a, b) => b.entryDate.compareTo(a.entryDate));
  }

  static Future<double> getCustomerBalance(
    String customerId,
    String branchId,
  ) async {
    final entries = await getCustomerEntries(customerId, branchId);
    return entries.fold<double>(0.0, (sum, e) => sum + e.debit - e.credit);
  }

  static Future<double> getSupplierBalance(
    String supplierId,
    String branchId,
  ) async {
    final entries = await getSupplierEntries(supplierId, branchId);
    return entries.fold<double>(0.0, (sum, e) => sum + e.debit - e.credit);
  }

  static Future<Map<String, double>> getAllCustomerBalances(String branchId) async {
    await _ensureCustomerReady();
    final balances = <String, double>{};
    final entries = _customerCache.where((e) => e.branchId == branchId && !e.isDeleted);

    for (final e in entries) {
      final current = balances[e.customerId] ?? 0.0;
      balances[e.customerId] = current + e.debit - e.credit;
    }
    return balances;
  }

  static Future<Map<String, double>> getAllSupplierBalances(String branchId) async {
    await _ensureSupplierReady();
    final balances = <String, double>{};
    final entries = _supplierCache.where((e) => e.branchId == branchId && !e.isDeleted);

    for (final e in entries) {
      final current = balances[e.supplierId] ?? 0.0;
      balances[e.supplierId] = current + e.debit - e.credit;
    }
    return balances;
  }

  static Future<Map<String, double>> getAllCombinedBalances() async {
    await _ensureCustomerReady();
    await _ensureSupplierReady();
    final balances = <String, double>{};

    for (final e in _customerCache.where((e) => !e.isDeleted)) {
      final current = balances[e.customerId] ?? 0.0;
      balances[e.customerId] = current + e.debit - e.credit;
    }

    for (final e in _supplierCache.where((e) => !e.isDeleted)) {
      final current = balances[e.supplierId] ?? 0.0;
      balances[e.supplierId] = current - (e.debit - e.credit);
    }

    return balances;
  }

  // ==================== Supplier Ledger Methods ====================
  static Future<void> insertSupplierEntry(SupplierLedgerModel entry) async {
    await _ensureSupplierReady();
    await _supplierDao.upsert(SupplierLedgersTableCompanion(
      id: Value(entry.id),
      supplierId: Value(entry.supplierId),
      branchId: Value(entry.branchId),
      type: Value(entry.type.name),
      debit: Value(entry.debit),
      credit: Value(entry.credit),
      balanceAfter: Value(entry.balanceAfter),
      referenceId: Value(entry.referenceId),
      referenceNumber: Value(entry.referenceNumber),
      notes: Value(entry.notes),
      createdBy: Value(entry.createdBy),
      entryDate: Value(entry.entryDate),
      syncVersion: Value(entry.syncVersion),
      lastModified: Value(DateTime.now()),
      isDeleted: const Value(false),
    ));
    final saved = await _supplierDao.getById(entry.id);
    if (saved != null) _supplierCache.add(saved);

    SyncService.onTableUpdated?.call('supplier_ledgers', entry.branchId);
    unawaited(
      SyncService.queueOperation(
        type: SyncOperationType.create,
        table: 'supplier_ledgers',
        data: entry.toJson(),
        branchId: entry.branchId,
      ),
    );
  }

  static Future<void> updateSupplierEntry(SupplierLedgerModel entry) async {
    await _ensureSupplierReady();
    await _supplierDao.upsert(SupplierLedgersTableCompanion(
      id: Value(entry.id),
      supplierId: Value(entry.supplierId),
      branchId: Value(entry.branchId),
      type: Value(entry.type.name),
      debit: Value(entry.debit),
      credit: Value(entry.credit),
      balanceAfter: Value(entry.balanceAfter),
      referenceId: Value(entry.referenceId),
      referenceNumber: Value(entry.referenceNumber),
      notes: Value(entry.notes),
      createdBy: Value(entry.createdBy),
      entryDate: Value(entry.entryDate),
      syncVersion: Value(entry.syncVersion + 1),
      lastModified: Value(DateTime.now()),
      isDeleted: Value(entry.isDeleted),
    ));
    final saved = await _supplierDao.getById(entry.id);
    if (saved != null) {
      final idx = _supplierCache.indexWhere((e) => e.id == entry.id);
      if (idx >= 0) _supplierCache[idx] = saved;
    }
    SyncService.onTableUpdated?.call('supplier_ledgers', entry.branchId);
    try {
      await SyncService.queueOperation(
        type: SyncOperationType.update,
        table: 'supplier_ledgers',
        data: entry.toJson(),
        branchId: entry.branchId,
      );
    } catch (e) {
      safeDebugPrint('LedgerService: queue supplier_ledgers update failed: $e');
    }
  }

  static Future<void> deleteSupplierEntry(String id) async {
    await _ensureSupplierReady();
    await _supplierDao.softDelete(id);
    _supplierCache.removeWhere((e) => e.id == id);
    unawaited(_queueOp(SyncOperationType.delete, 'supplier_ledgers', {'id': id, 'is_deleted': true}, ''));
  }

  static Future<List<SupplierLedgerModel>> getSupplierEntries(
    String supplierId,
    String branchId,
  ) async {
    await _ensureSupplierReady();
    return _supplierCache
        .where((e) => e.supplierId == supplierId && e.branchId == branchId && !e.isDeleted)
        .map(_toSupplierModel)
        .toList()
      ..sort((a, b) => b.entryDate.compareTo(a.entryDate));
  }

  // ==================== Combined Party Ledger ====================
  static Future<List<Map<String, dynamic>>> getCombinedLedger(
    String partyId, {
    String branchId = '',
  }) async {
    final customerEntries = await getCustomerEntries(partyId, branchId);
    final supplierEntries = await getSupplierEntries(partyId, branchId);

    final combined = <Map<String, dynamic>>[];

    for (final e in customerEntries) {
      combined.add({
        'id': e.id,
        'date': e.entryDate,
        'type': 'customer',
        'entryType': e.type.name,
        'debit': e.debit,
        'credit': e.credit,
        'balanceAfter': e.balanceAfter,
        'referenceNumber': e.referenceNumber,
        'notes': e.notes,
        'createdBy': e.createdBy,
        'runningBalance': 0.0,
      });
    }

    for (final e in supplierEntries) {
      combined.add({
        'id': e.id,
        'date': e.entryDate,
        'type': 'supplier',
        'entryType': e.type.name,
        'debit': e.debit,
        'credit': e.credit,
        'balanceAfter': e.balanceAfter,
        'referenceNumber': e.referenceNumber,
        'notes': e.notes,
        'createdBy': e.createdBy,
        'runningBalance': 0.0,
      });
    }

    combined.sort(
      (a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime),
    );

    double runningBalance = 0.0;
    for (final entry in combined) {
      final debit = entry['debit'] as double;
      final credit = entry['credit'] as double;
      runningBalance += debit - credit;
      entry['runningBalance'] = runningBalance;
    }

    return combined;
  }

  static Future<double> getCombinedBalance(String partyId, {String branchId = ''}) async {
    await _ensureCustomerReady();
    await _ensureSupplierReady();

    final customerBalance = _customerCache
        .where((e) => e.customerId == partyId && e.branchId == branchId && !e.isDeleted)
        .fold<double>(0.0, (sum, e) => sum + e.debit - e.credit);

    final supplierBalance = _supplierCache
        .where((e) => e.supplierId == partyId && e.branchId == branchId && !e.isDeleted)
        .fold<double>(0.0, (sum, e) => sum + e.debit - e.credit);

    return customerBalance - supplierBalance;
  }

  static Future<Map<String, double>> getTransactionSummary(
    String partyId, {
    String branchId = '',
  }) async {
    final customerEntries = await getCustomerEntries(partyId, branchId);
    final supplierEntries = await getSupplierEntries(partyId, branchId);

    double totalSales = 0;
    double totalSalesReturns = 0;
    double totalPurchases = 0;
    double totalPurchaseReturns = 0;
    double totalReceipts = 0;
    double totalPayments = 0;
    double totalAdditions = 0;
    double totalDiscounts = 0;
    double totalCheckReceipts = 0;
    double totalCheckPayments = 0;

    for (final e in customerEntries) {
      switch (e.type) {
        case CustomerLedgerEntryType.saleInvoice:
          totalSales += e.debit;
          break;
        case CustomerLedgerEntryType.saleReturn:
          totalSalesReturns += e.credit;
          break;
        case CustomerLedgerEntryType.customerPayment:
          totalReceipts += e.credit;
          break;
        case CustomerLedgerEntryType.additionNotice:
          totalAdditions += e.debit;
          break;
        case CustomerLedgerEntryType.discountNotice:
          totalDiscounts += e.credit;
          break;
        case CustomerLedgerEntryType.checkReceipt:
          totalCheckReceipts += e.credit;
          break;
        case CustomerLedgerEntryType.checkPayment:
          totalCheckPayments += e.debit;
          break;
        default:
          break;
      }
    }

    for (final e in supplierEntries) {
      switch (e.type) {
        case SupplierLedgerEntryType.purchaseInvoice:
          totalPurchases += e.debit;
          break;
        case SupplierLedgerEntryType.supplierPayment:
          totalPayments += e.credit;
          break;
        case SupplierLedgerEntryType.purchaseVoid:
          totalPurchaseReturns += e.credit;
          break;
        case SupplierLedgerEntryType.additionNotice:
          totalAdditions += e.debit;
          break;
        case SupplierLedgerEntryType.discountNotice:
          totalDiscounts += e.credit;
          break;
        case SupplierLedgerEntryType.checkReceipt:
          totalCheckReceipts += e.debit;
          break;
        case SupplierLedgerEntryType.checkPayment:
          totalCheckPayments += e.credit;
          break;
        default:
          break;
      }
    }

    return {
      'totalSales': totalSales,
      'totalSalesReturns': totalSalesReturns,
      'totalPurchases': totalPurchases,
      'totalPurchaseReturns': totalPurchaseReturns,
      'totalReceipts': totalReceipts,
      'totalPayments': totalPayments,
      'totalAdditions': totalAdditions,
      'totalDiscounts': totalDiscounts,
      'totalCheckReceipts': totalCheckReceipts,
      'totalCheckPayments': totalCheckPayments,
    };
  }

  // ==================== Record Entry Helpers ====================
  static String generateId() => _uuid.v4();

  // ==================== Sync Queue Helper ====================
  static Future<void> _queueOp(SyncOperationType type, String table, Map<String, dynamic> data, String branchId) async {
    try {
      await SyncService.queueOperation(type: type, table: table, data: data, branchId: branchId);
    } catch (e) {
      safeDebugPrint('LedgerService: queue $table failed: $e');
    }
  }

  static ContactLedgerModel _toCustomerModel(CustomerLedgersTableData d) =>
      ContactLedgerModel(
        id: d.id,
        customerId: d.customerId,
        branchId: d.branchId,
        type: CustomerLedgerEntryType.values.firstWhere(
          (e) => e.name == d.type,
          orElse: () => CustomerLedgerEntryType.saleInvoice,
        ),
        debit: d.debit,
        credit: d.credit,
        balanceAfter: d.balanceAfter,
        referenceId: d.referenceId,
        referenceNumber: d.referenceNumber,
        notes: d.notes,
        createdBy: d.createdBy,
        entryDate: d.entryDate,
        syncVersion: d.syncVersion,
        lastModified: d.lastModified,
        isDeleted: d.isDeleted,
      );

  static SupplierLedgerModel _toSupplierModel(SupplierLedgersTableData d) =>
      SupplierLedgerModel(
        id: d.id,
        supplierId: d.supplierId,
        branchId: d.branchId,
        type: SupplierLedgerEntryType.values.firstWhere(
          (e) => e.name == d.type,
          orElse: () => SupplierLedgerEntryType.purchaseInvoice,
        ),
        debit: d.debit,
        credit: d.credit,
        balanceAfter: d.balanceAfter,
        referenceId: d.referenceId,
        referenceNumber: d.referenceNumber,
        notes: d.notes,
        createdBy: d.createdBy,
        entryDate: d.entryDate,
        syncVersion: d.syncVersion,
        lastModified: d.lastModified,
        isDeleted: d.isDeleted,
      );
}






