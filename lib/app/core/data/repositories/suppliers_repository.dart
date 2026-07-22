import 'dart:async';
import 'package:drift/drift.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/core/data/database/daos/suppliers_dao.dart';
import 'package:pharmacy_system/app/core/injection.dart';
import 'package:pharmacy_system/app/modules/contacts/models/supplier_model.dart';
import 'package:pharmacy_system/app/core/data/services/sync/sync_service.dart';
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
      phone: d.phone,
      address: d.address,
      isActive: d.isActive,
      partyType: SupplierPartyType.values.firstWhere(
        (e) => e.name == d.partyType,
        orElse: () => SupplierPartyType.company,
      ),
      companyName: d.companyName,
      email: d.email,
      taxId: d.taxId,
      creditLimit: d.creditLimit,
      discountPercent: d.discountPercent,
      paymentTermDays: d.paymentTermDays,
      notes: d.notes,
      lastModified: d.lastModified,
      isDeleted: d.isDeleted,
      branchId: d.branchId,
    );
  }

  SuppliersTableCompanion _toCompanion(SupplierModel m) {
    return SuppliersTableCompanion(
      id: Value(m.id),
      name: Value(m.name),
      type: const Value('supplier'),
      phone: Value(m.phone),
      address: Value(m.address),
      isActive: Value(m.isActive),
      partyType: Value(m.partyType.name),
      companyName: Value(m.companyName),
      email: Value(m.email),
      taxId: Value(m.taxId),
      creditLimit: Value(m.creditLimit),
      discountPercent: Value(m.discountPercent),
      paymentTermDays: Value(m.paymentTermDays),
      notes: Value(m.notes),
      lastModified: Value(m.lastModified),
      isDeleted: Value(m.isDeleted),
      branchId: Value(m.branchId ?? AuthService.currentBranchId ?? ''),
    );
  }

  Future<List<SupplierModel>> getSuppliers({
    String? searchQuery,
    bool includeActive = true,
    bool includeDeleted = false,
  }) async {
    var data = await _dao.getAll();
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
    final data = await _dao.getById(id);
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
    supplier.lastModified = DateTime.now();
    supplier.branchId ??= AuthService.currentBranchId;
    await _dao.upsert(_toCompanion(supplier));
    SyncService.onTableUpdated?.call('suppliers', supplier.branchId ?? '');
    unawaited(
      SyncService.queueOperation(
        type: SyncOperationType.create,
        table: 'suppliers',
        data: supplier.toJson(),
        branchId: supplier.branchId ?? '',
      ),
    );
  }

  Future<void> update(SupplierModel supplier) async {
    supplier.lastModified = DateTime.now();
    supplier.branchId ??= AuthService.currentBranchId;
    await _dao.upsert(_toCompanion(supplier));
    SyncService.onTableUpdated?.call('suppliers', supplier.branchId ?? '');
    unawaited(
      SyncService.queueOperation(
        type: SyncOperationType.update,
        table: 'suppliers',
        data: supplier.toJson(),
        branchId: supplier.branchId ?? '',
      ),
    );
  }

  Future<void> delete(SupplierModel supplier) async {
    final branchId = supplier.branchId ?? AuthService.currentBranchId ?? '';
    await ArchiveService.record(
      entityType: 'supplier',
      entityId: supplier.id,
      entityName: supplier.name,
      entityData: supplier.toJson(),
      branchId: branchId,
    );
    await _dao.softDelete(supplier.id);
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

  Future<void> batchCreate(List<SupplierModel> suppliers, {bool skipSync = false}) async {
    await _dao.upsertBatch(suppliers.map(_toCompanion).toList());
  }

  bool _matchesSearch(SupplierModel supplier, String query) {
    return supplier.name.toLowerCase().contains(query) ||
        (supplier.phone?.contains(query) ?? false) ||
        (supplier.companyName?.toLowerCase().contains(query) ?? false);
  }

  static void dispose() {
    for (final t in _cacheTimers.values) {
      t.cancel();
    }
    _cache.clear();
    _cacheTimers.clear();
  }
}

