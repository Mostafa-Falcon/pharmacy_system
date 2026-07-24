import 'dart:async';
import 'package:pharmacy_system/app/core/data/database/daos/contacts_dao.dart';
import 'package:pharmacy_system/app/core/injection.dart';
import 'package:pharmacy_system/app/core/models/contacts/customer_model.dart';
import 'package:pharmacy_system/app/core/sync/sync_service.dart';
import 'package:pharmacy_system/app/modules/archive/services/archive_service.dart';
import 'package:pharmacy_system/app/core/data/mappers/mappers.dart';

class CustomersRepository {
  ContactsDao get _dao => sl<ContactsDao>();
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
    var items = await _dao.searchCustomers(searchQuery ?? '');
    var data = items.map(ContactsMapper.customerFromData).toList();
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

    data.sort((a, b) => a.name.compareTo(b.name));
    return data;
  }

  List<CustomerModel> getCustomersSync() {
    return _cached();
  }

  Future<CustomerModel?> getByIdAsync(String id) async {
    final data = await _dao.getCustomerById(id);
    return data != null ? ContactsMapper.customerFromData(data) : null;
  }

  CustomerModel? getById(String id) {
    for (final entry in _cache.entries) {
      final match = entry.value.where((c) => c.id == id);
      if (match.isNotEmpty) return match.first;
    }
    return null;
  }

  Future<void> create(CustomerModel customer) async {
    await _dao.upsertCustomer(ContactsMapper.customerToCompanion(customer));
    SyncService.notifyTableUpdated('customers', customer.branchId ?? '');
    unawaited(
      SyncService.queueOperation(
        type: SyncOperationType.create,
        table: 'customers',
        data: customer.toJson(),
        branchId: customer.branchId,
      ),
    );
  }

  Future<void> update(CustomerModel customer) async {
    await _dao.upsertCustomer(ContactsMapper.customerToCompanion(customer));
    SyncService.notifyTableUpdated('customers', customer.branchId ?? '');
    unawaited(
      SyncService.queueOperation(
        type: SyncOperationType.update,
        table: 'customers',
        data: customer.toJson(),
        branchId: customer.branchId,
      ),
    );
  }

  Future<void> delete(CustomerModel customer) async {
    final branchId = customer.branchId ?? '';
    await ArchiveService.record(
      entityType: 'customer',
      entityId: customer.id,
      entityName: customer.name,
      entityData: customer.toJson(),
      branchId: branchId,
    );
    // Soft delete via update
    await update(
      customer.copyWith(isDeleted: true, lastModified: DateTime.now()),
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
