import 'dart:async';
import 'package:drift/drift.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/core/data/database/daos/contacts_dao.dart';
import 'package:pharmacy_system/app/core/injection.dart';
import 'package:pharmacy_system/app/core/models/contacts/supplier_model.dart';
import 'package:pharmacy_system/app/core/sync/sync_service.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/modules/archive/services/archive_service.dart';

class SuppliersRepository {
  SuppliersDao get _dao => sl<SuppliersDao>();
  SuppliersRepository();

  static final Map<String, List<SupplierModel>> _cache = {};
  static final Map<String, Timer> _cacheTimers = {};

  List<SupplierModel> _cached() => List<SupplierModel>.from(_cache[''] ?? []);

  void _updateCache(List<SupplierModel> items) {
    _cache[''] = items;
    _cacheTimers['']?.cancel();
    _cacheTimers[''] = Timer(const Duration(seconds: 5), () {
      _cache.remove('');
    });
  }

  SupplierModel _toModel(SuppliersTableData d) {
    return SupplierModel(
      id: d.id,
      name: d.name,
      contactPerson: d.contactPerson,
      phone: d.phone,
      email: d.email,
      address: d.address,
      taxId: d.taxId,
      creditAmount: d.creditAmount,
      debitAmount: d.debitAmount,
      paymentTermDays: d.paymentTermDays,
      isActive: d.isActive,
      accountId: d.accountId,
      branchId: d.branchId,
      notes: d.notes,
      lastModified: d.lastModified,
      isDeleted: d.isDeleted,
      syncVersion: d.syncVersion,
    );
  }

  SuppliersTableCompanion _toCompanion(SupplierModel m) {
    return SuppliersTableCompanion(
      id: Value(m.id),
      name: Value(m.name),
      contactPerson: Value(m.contactPerson),
      phone: Value(m.phone),
      email: Value(m.email),
      address: Value(m.address),
      taxId: Value(m.taxId),
      creditAmount: Value(m.creditAmount),
      debitAmount: Value(m.debitAmount),
      paymentTermDays: Value(m.paymentTermDays),
      isActive: Value(m.isActive),
      branchId: Value(m.branchId),
      accountId: Value(m.accountId),
      notes: Value(m.notes),
      lastModified: Value(m.lastModified),
      isDeleted: Value(m.isDeleted),
      syncVersion: Value(m.syncVersion),
    );
  }

  Future<List<SupplierModel>> getSuppliers({
    String? searchQuery,
    bool includeActive = true,
    bool includeDeleted = false,
  }) async {
    var data = await _dao.getAllSuppliers();
    var result = data.map(_toModel).toList();
    _updateCache(result);

    if (!includeDeleted) {
      result.removeWhere((s) => s.isDeleted);
    }

    if (!includeActive) {
      result.removeWhere((s) => !s.isActive);
    }

    if (searchQuery != null && searchQuery.isNotEmpty) {
      final q = searchQuery.trim().toLowerCase();
      result.removeWhere((s) => !_matchesSearch(s, q));
    }

    result.sort((a, b) => a.name.compareTo(b.name));
    return result;
  }

  List<SupplierModel> getSuppliersSync() {
    return _cached();
  }

  Stream<List<SupplierModel>> watchSuppliers() {
    return _dao.db.select(_dao.db.suppliersTable).watch().map((rows) {
      final result = rows.map(_toModel).toList();
      _updateCache(result);
      return result;
    });
  }

  Future<SupplierModel?> getByIdAsync(String id) async {
    final data = await _dao.getSupplierById(id);
    return data != null ? _toModel(data) : null;
  }

  SupplierModel? getById(String id) {
    for (final entry in _cache.entries) {
      final match = entry.value.where((s) => s.id == id);
      if (match.isNotEmpty) return match.first;
    }
    return null;
  }

  Future<void> create(SupplierModel supplier) async {
    final model = supplier.copyWith(lastModified: DateTime.now());
    await _dao.upsertSupplier(_toCompanion(model));
    SyncService.onTableUpdated?.call(
      'suppliers',
      AuthService.currentBranchId ?? '',
    );
    unawaited(
      SyncService.queueOperation(
        type: SyncOperationType.create,
        table: 'suppliers',
        data: model.toJson(),
        branchId: AuthService.currentBranchId ?? '',
      ),
    );
  }

  Future<void> update(SupplierModel supplier) async {
    final model = supplier.copyWith(lastModified: DateTime.now());
    await _dao.upsertSupplier(_toCompanion(model));
    SyncService.onTableUpdated?.call(
      'suppliers',
      AuthService.currentBranchId ?? '',
    );
    unawaited(
      SyncService.queueOperation(
        type: SyncOperationType.update,
        table: 'suppliers',
        data: model.toJson(),
        branchId: AuthService.currentBranchId ?? '',
      ),
    );
  }

  Future<void> delete(SupplierModel supplier) async {
    final branchId = AuthService.currentBranchId ?? '';
    await ArchiveService.record(
      entityType: 'supplier',
      entityId: supplier.id,
      entityName: supplier.name,
      entityData: supplier.toJson(),
      branchId: branchId,
    );
    await _dao.softDeleteSupplier(supplier.id);
    SyncService.onTableUpdated?.call('suppliers', branchId);
    unawaited(
      SyncService.queueOperation(
        type: SyncOperationType.delete,
        table: 'suppliers',
        data: supplier.toJson()..['is_deleted'] = true,
        branchId: branchId,
      ),
    );
  }

  Future<void> batchCreate(
    List<SupplierModel> suppliers, {
    bool skipSync = false,
  }) async {
    for (final supplier in suppliers) {
      await _dao.upsertSupplier(_toCompanion(supplier));
    }
  }

  bool _matchesSearch(SupplierModel supplier, String query) {
    return supplier.name.toLowerCase().contains(query) ||
        (supplier.phone?.contains(query) ?? false) ||
        (supplier.agentPhone?.contains(query) ?? false);
  }

  static void dispose() {
    for (final t in _cacheTimers.values) {
      t.cancel();
    }
    _cache.clear();
    _cacheTimers.clear();
  }
}
