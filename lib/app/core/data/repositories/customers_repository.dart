import 'dart:async';
import 'package:drift/drift.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/core/data/database/daos/customers_dao.dart';
import 'package:pharmacy_system/app/core/injection.dart';
import 'package:pharmacy_system/app/modules/contacts/models/customer_model.dart';
import 'package:pharmacy_system/app/core/data/services/sync/sync_service.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/modules/archive/services/archive_service.dart';

class CustomersRepository {
  CustomersDao get _dao => sl<CustomersDao>();
  CustomersRepository();

  static final Map<String, List<CustomerModel>> _cache = {};
  static final Map<String, Timer> _cacheTimers = {};

  List<CustomerModel> _cached() => List<CustomerModel>.from(_cache[''] ?? []);

  void _updateCache(List<CustomerModel> items) {
    _cache[''] = items;
    _cacheTimers['']?.cancel();
    _cacheTimers[''] = Timer(const Duration(seconds: 5), () {
      _cache.remove('');
    });
  }

  CustomerModel _toModel(CustomersTableData d) {
    return CustomerModel(
      id: d.id,
      name: d.name,
      phone: d.phone,
      address: d.address,
      isActive: d.isActive,
      kind: CustomerKind.values.firstWhere(
        (e) => e.name == d.kind,
        orElse: () => CustomerKind.regular,
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
      salesRepId: d.salesRepId,
      branchId: d.branchId,
    );
  }

  CustomersTableCompanion _toCompanion(CustomerModel m) {
    return CustomersTableCompanion(
      id: Value(m.id),
      name: Value(m.name),
      phone: Value(m.phone),
      address: Value(m.address),
      isActive: Value(m.isActive),
      kind: Value(m.kind.name),
      companyName: Value(m.companyName),
      email: Value(m.email),
      taxId: Value(m.taxId),
      creditLimit: Value(m.creditLimit),
      discountPercent: Value(m.discountPercent),
      paymentTermDays: Value(m.paymentTermDays),
      notes: Value(m.notes),
      lastModified: Value(m.lastModified),
      isDeleted: Value(m.isDeleted),
      salesRepId: Value(m.salesRepId),
      branchId: Value(m.branchId ?? AuthService.currentBranchId ?? ''),
    );
  }

  List<CustomerModel> getCachedCustomers({bool activeOnly = false}) {
    var data = _cached();
    if (activeOnly) {
      data = data.where((c) => c.isActive && !c.isDeleted).toList();
    }
    return data;
  }

  Future<List<CustomerModel>> getCustomers({
    bool activeOnly = false,
    String? searchQuery,
    bool includeInactive = true,
    bool includeDeleted = false,
  }) async {
    var items = await _dao.search(searchQuery ?? '');
    var data = items.map(_toModel).toList();
    _updateCache(data);

    if (activeOnly) {
      data.removeWhere((c) => !c.isActive || c.isDeleted);
    } else {
      if (!includeDeleted) {
        data.removeWhere((c) => c.isDeleted);
      }
      if (!includeInactive) {
        data.removeWhere((c) => !c.isActive);
      }
    }

    if (searchQuery != null && searchQuery.isNotEmpty) {
      final q = searchQuery.trim().toLowerCase();
      data.removeWhere((c) => !_matchesSearch(c, q));
    }

    data.sort((a, b) => a.name.compareTo(b.name));
    return data;
  }

  List<CustomerModel> getCustomersSync() {
    return _cached();
  }

  Stream<List<CustomerModel>> watchCustomers() {
    return _dao.db.select(_dao.db.customersTable).watch().map((rows) {
      final result = rows.map(_toModel).toList();
      _updateCache(result);
      return result;
    });
  }

  Future<CustomerModel?> getByIdAsync(String id) async {
    final data = await _dao.getById(id);
    return data != null ? _toModel(data) : null;
  }

  CustomerModel? getById(String id) {
    for (final entry in _cache.entries) {
      final match = entry.value.where((c) => c.id == id);
      if (match.isNotEmpty) return match.first;
    }
    return null;
  }

  Future<void> create(CustomerModel customer) async {
    customer.lastModified = DateTime.now();
    customer.branchId ??= AuthService.currentBranchId;
    await _dao.upsert(_toCompanion(customer));
    SyncService.onTableUpdated?.call('customers', customer.branchId ?? '');
    unawaited(
      SyncService.queueOperation(
        type: SyncOperationType.create,
        table: 'customers',
        data: customer.toJson(),
        branchId: customer.branchId ?? '',
      ),
    );
  }

  Future<void> update(CustomerModel customer) async {
    customer.lastModified = DateTime.now();
    customer.branchId ??= AuthService.currentBranchId;
    await _dao.upsert(_toCompanion(customer));
    SyncService.onTableUpdated?.call('customers', customer.branchId ?? '');
    unawaited(
      SyncService.queueOperation(
        type: SyncOperationType.update,
        table: 'customers',
        data: customer.toJson(),
        branchId: customer.branchId ?? '',
      ),
    );
  }

  Future<void> delete(CustomerModel customer) async {
    final branchId = customer.branchId ?? AuthService.currentBranchId ?? '';
    await ArchiveService.record(
      entityType: 'customer',
      entityId: customer.id,
      entityName: customer.name,
      entityData: customer.toJson(),
      branchId: branchId,
    );
    await _dao.softDelete(customer.id);
    SyncService.onTableUpdated?.call('customers', branchId);
    unawaited(
      SyncService.queueOperation(
        type: SyncOperationType.delete,
        table: 'customers',
        data: customer.toJson()..['is_deleted'] = true,
        branchId: branchId,
      ),
    );
  }

  Future<void> batchCreate(List<CustomerModel> customers, {bool skipSync = false}) async {
    await _dao.upsertBatch(customers.map(_toCompanion).toList());
  }

  bool _matchesSearch(CustomerModel customer, String query) {
    return customer.name.toLowerCase().contains(query) ||
        (customer.phone?.contains(query) ?? false) ||
        (customer.companyName?.toLowerCase().contains(query) ?? false);
  }

  static void dispose() {
    for (final t in _cacheTimers.values) {
      t.cancel();
    }
    _cache.clear();
    _cacheTimers.clear();
  }
}

