import 'dart:async';
import 'package:drift/drift.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/core/data/database/daos/customer_ledgers_dao.dart';
import 'package:pharmacy_system/app/core/injection.dart';
import 'package:pharmacy_system/app/modules/contacts/models/customer_ledger_model.dart';
import 'package:pharmacy_system/app/core/data/services/sync/sync_service.dart';

class CustomerLedgerRepository {
  CustomerLedgersDao get _dao => sl<CustomerLedgersDao>();
  CustomerLedgerRepository();

  static final Map<String, List<CustomerLedgerModel>> _cache = {};
  static final Map<String, Timer> _cacheTimers = {};

  List<CustomerLedgerModel> _cached(String branchId) =>
      List<CustomerLedgerModel>.from(_cache[branchId] ?? []);

  void _updateCache(String branchId, List<CustomerLedgerModel> items) {
    _cache[branchId] = items;
    _cacheTimers[branchId]?.cancel();
    _cacheTimers[branchId] = Timer(const Duration(seconds: 5), () {
      _cache.remove(branchId);
    });
  }

  CustomerLedgerModel _toModel(CustomerLedgersTableData d) {
    return CustomerLedgerModel(
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
  }

  CustomerLedgersTableCompanion _toCompanion(CustomerLedgerModel m) {
    return CustomerLedgersTableCompanion(
      id: Value(m.id),
      customerId: Value(m.customerId),
      branchId: Value(m.branchId),
      type: Value(m.type.name),
      debit: Value(m.debit),
      credit: Value(m.credit),
      balanceAfter: Value(m.balanceAfter),
      referenceId: Value(m.referenceId),
      referenceNumber: Value(m.referenceNumber),
      notes: Value(m.notes),
      createdBy: Value(m.createdBy),
      entryDate: Value(m.entryDate),
      syncVersion: Value(m.syncVersion),
      lastModified: Value(m.lastModified),
      isDeleted: Value(m.isDeleted),
    );
  }

  Future<List<CustomerLedgerModel>> getByBranch(String branchId) async {
    final items = await _dao.getByBranch(branchId);
    final data = items.map(_toModel).toList();
    _updateCache(branchId, data);
    return data;
  }

  List<CustomerLedgerModel> getSync(String branchId) {
    return _cached(branchId);
  }

  Future<List<CustomerLedgerModel>> getByCustomer(String customerId) async {
    final items = await _dao.getByCustomer(customerId);
    return items.map(_toModel).toList();
  }

  Future<CustomerLedgerModel?> getByIdAsync(String id) async {
    final data = await _dao.getById(id);
    return data != null ? _toModel(data) : null;
  }

  Future<double> getBalance(String customerId) =>
      _dao.getBalance(customerId);

  Future<void> upsert(CustomerLedgerModel entry) async {
    await _dao.upsert(_toCompanion(entry));
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

  Future<void> softDelete(String id) async {
    await _dao.softDelete(id);
    SyncService.onTableUpdated?.call('customer_ledgers', '');
    unawaited(
      SyncService.queueOperation(
        type: SyncOperationType.delete,
        table: 'customer_ledgers',
        data: {'id': id, 'is_deleted': true},
        branchId: '',
      ),
    );
  }

  static void dispose() {
    for (final t in _cacheTimers.values) {
      t.cancel();
    }
    _cache.clear();
    _cacheTimers.clear();
  }
}

