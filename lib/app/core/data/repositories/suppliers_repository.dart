import 'dart:async';
import 'package:drift/drift.dart';
import 'package:pharmacy_system/app/core/data/database/daos/contacts_dao.dart';
import 'package:pharmacy_system/app/core/injection.dart';
import 'package:pharmacy_system/app/core/models/contacts/supplier_model.dart';
import 'package:pharmacy_system/app/core/sync/sync_service.dart';
import 'package:pharmacy_system/app/modules/archive/services/archive_service.dart';

import '../mappers/contacts_mapper.dart';

class SuppliersRepository {
  ContactsDao get _dao => sl<ContactsDao>();
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

  Future<List<SupplierModel>> getSuppliers({
    String? searchQuery,
    bool includeActive = true,
    bool includeDeleted = false,
  }) async {
    var data = await _dao.getAllSuppliers();
    var result = data.map(ContactsMapper.supplierFromData).toList();
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
      final result = rows.map(ContactsMapper.supplierFromData).toList();
      _updateCache(result);
      return result;
    });
  }

  Future<SupplierModel?> getByIdAsync(String id) async {
    final data = await _dao.getSupplierById(id);
    return data != null ? ContactsMapper.supplierFromData(data) : null;
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
    await _dao.upsertSupplier(ContactsMapper.supplierToCompanion(model));
    SyncService.notifyTableUpdated('suppliers', model.branchId ?? '');
    unawaited(
      SyncService.queueOperation(
        type: SyncOperationType.create,
        table: 'suppliers',
        data: model.toJson(),
        branchId: model.branchId,
      ),
    );
  }

  Future<void> update(SupplierModel supplier) async {
    final model = supplier.copyWith(lastModified: DateTime.now());
    await _dao.upsertSupplier(ContactsMapper.supplierToCompanion(model));
    SyncService.notifyTableUpdated('suppliers', model.branchId ?? '');
    unawaited(
      SyncService.queueOperation(
        type: SyncOperationType.update,
        table: 'suppliers',
        data: model.toJson(),
        branchId: model.branchId,
      ),
    );
  }

  Future<void> delete(SupplierModel supplier) async {
    final branchId = supplier.branchId ?? '';
    await ArchiveService.archiveRecord(
      entityType: 'supplier',
      entityId: supplier.id,
      entityName: supplier.name,
      entityData: supplier.toJson(),
      branchId: branchId,
    );
    final model = supplier.copyWith(isDeleted: true, lastModified: DateTime.now());
    await update(model);
  }

  Future<void> batchCreate(
    List<SupplierModel> suppliers, {
    bool skipSync = false,
  }) async {
    for (final supplier in suppliers) {
      await _dao.upsertSupplier(ContactsMapper.supplierToCompanion(supplier));
    }
  }

  bool _matchesSearch(SupplierModel supplier, String query) {
    return supplier.name.toLowerCase().contains(query) ||
        (supplier.phone?.contains(query) ?? false);
  }

  static void dispose() {
    for (final t in _cacheTimers.values) {
      t.cancel();
    }
    _cache.clear();
    _cacheTimers.clear();
  }
}
