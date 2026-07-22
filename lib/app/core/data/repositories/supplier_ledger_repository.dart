import 'dart:async';
import 'package:drift/drift.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/core/data/database/daos/supplier_ledgers_dao.dart';
import 'package:pharmacy_system/app/core/injection.dart';
import 'package:pharmacy_system/app/modules/contacts/models/supplier_ledger_model.dart';
import 'package:pharmacy_system/app/core/data/services/sync/sync_service.dart';

class SupplierLedgerRepository {
  SupplierLedgersDao get _dao => sl<SupplierLedgersDao>();
  SupplierLedgerRepository();

  static final Map<String, List<SupplierLedgerModel>> _cache = {};
  static final Map<String, Timer> _cacheTimers = {};

  List<SupplierLedgerModel> _cached(String branchId) =>
      List<SupplierLedgerModel>.from(_cache[branchId] ?? []);

  void _updateCache(String branchId, List<SupplierLedgerModel> items) {
    _cache[branchId] = items;
    _cacheTimers[branchId]?.cancel();
    _cacheTimers[branchId] = Timer(const Duration(seconds: 5), () {
      _cache.remove(branchId);
    });
  }

  SupplierLedgerModel _toModel(SupplierLedgersTableData d) {
    return SupplierLedgerModel(
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

  SupplierLedgersTableCompanion _toCompanion(SupplierLedgerModel m) {
    return SupplierLedgersTableCompanion(
      id: Value(m.id),
      supplierId: Value(m.supplierId),
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

  Future<List<SupplierLedgerModel>> getByBranch(String branchId) async {
    final items = await _dao.getByBranch(branchId);
    final data = items.map(_toModel).toList();
    _updateCache(branchId, data);
    return data;
  }

  List<SupplierLedgerModel> getSync(String branchId) {
    return _cached(branchId);
  }

  Future<List<SupplierLedgerModel>> getBySupplier(String supplierId) async {
    final items = await _dao.getBySupplier(supplierId);
    return items.map(_toModel).toList();
  }

  Future<SupplierLedgerModel?> getByIdAsync(String id) async {
    final data = await _dao.getById(id);
    return data != null ? _toModel(data) : null;
  }

  Future<double> getBalance(String supplierId) =>
      _dao.getBalance(supplierId);

  Future<void> upsert(SupplierLedgerModel entry) async {
    await _dao.upsert(_toCompanion(entry));
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

  Future<void> softDelete(String id) async {
    await _dao.softDelete(id);
    SyncService.onTableUpdated?.call('supplier_ledgers', '');
    unawaited(
      SyncService.queueOperation(
        type: SyncOperationType.delete,
        table: 'supplier_ledgers',
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

