import 'dart:async';
import 'package:drift/drift.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/core/data/database/daos/contacts_dao.dart';
import 'package:pharmacy_system/app/core/injection.dart';
import 'package:pharmacy_system/app/core/models/contacts/supplier_customer_model.dart';
import 'package:pharmacy_system/app/core/sync/sync_service.dart';
import 'package:pharmacy_system/app/modules/archive/services/archive_service.dart';

/// 🤝 المستودع الموحد لإدارة الجهات المزدوجة (عميل ومورد في نفس الوقت - الصيدليات الشقيقة والشركاء التجاريين)
class SupplierCustomersRepository {
  ContactsDao get _dao => sl<ContactsDao>();
  SupplierCustomersRepository();

  static final Map<String, List<SupplierCustomerModel>> _cache = {};
  static final Map<String, Timer> _cacheTimers = {};

  List<SupplierCustomerModel> _cached(String branchId) =>
      List<SupplierCustomerModel>.from(_cache[branchId] ?? []);

  void _updateCache(String branchId, List<SupplierCustomerModel> items) {
    _cache[branchId] = items;
    _cacheTimers[branchId]?.cancel();
    _cacheTimers[branchId] = Timer(const Duration(seconds: 5), () {
      _cache.remove(branchId);
    });
  }

  SupplierCustomerModel _toModel(SupplierCustomersTableData d) {
    return SupplierCustomerModel(
      id: d.id,
      name: d.name,
      phone: d.phone,
      address: d.address,
      email: d.email,
      companyName: d.companyName,
      taxId: d.taxId,
      creditLimit: d.creditLimit,
      discountPercent: d.discountPercent,
      paymentTermDays: d.paymentTermDays,
      supplierBalance: d.supplierBalance,
      customerBalance: d.customerBalance,
      isActive: d.isActive,
      notes: d.notes,
      branchId: d.branchId,
      accountId: d.accountId,
      lastModified: d.lastModified,
      isDeleted: d.isDeleted,
    );
  }

  SupplierCustomersTableCompanion _toCompanion(SupplierCustomerModel m) {
    return SupplierCustomersTableCompanion(
      id: Value(m.id),
      name: Value(m.name),
      phone: Value(m.phone),
      address: Value(m.address),
      email: Value(m.email),
      companyName: Value(m.companyName),
      taxId: Value(m.taxId),
      creditLimit: Value(m.creditLimit),
      discountPercent: Value(m.discountPercent),
      paymentTermDays: Value(m.paymentTermDays),
      supplierBalance: Value(m.supplierBalance),
      customerBalance: Value(m.customerBalance),
      isActive: Value(m.isActive),
      notes: Value(m.notes),
      branchId: Value(m.branchId),
      accountId: Value(m.accountId),
      lastModified: Value(m.lastModified),
      isDeleted: Value(m.isDeleted),
    );
  }

  Future<List<SupplierCustomerModel>> getSupplierCustomers({
    required String branchId,
    String? searchQuery,
    bool includeActive = true,
    bool includeDeleted = false,
  }) async {
    final items = await _dao.getAllSupplierCustomers();
    var data = items.map(_toModel).toList();
    _updateCache(branchId, data);

    if (!includeDeleted) {
      data.removeWhere((c) => c.isDeleted);
    }

    if (!includeActive) {
      data.removeWhere((c) => !c.isActive);
    }

    if (searchQuery != null && searchQuery.isNotEmpty) {
      final q = searchQuery.trim().toLowerCase();
      data.removeWhere((c) => !_matchesSearch(c, q));
    }

    data.sort((a, b) => a.name.compareTo(b.name));
    return data;
  }

  List<SupplierCustomerModel> getSupplierCustomersSync({required String branchId}) {
    return _cached(branchId);
  }

  bool _matchesSearch(SupplierCustomerModel item, String query) {
    return item.name.toLowerCase().contains(query) ||
        (item.phone != null && item.phone!.contains(query)) ||
        (item.companyName != null && item.companyName!.toLowerCase().contains(query));
  }

  Future<SupplierCustomerModel?> getByIdAsync(String id) async {
    final data = await _dao.getSupplierCustomerById(id);
    return data != null ? _toModel(data) : null;
  }

  Future<void> create(SupplierCustomerModel entity, {required String branchId}) async {
    final model = entity.copyWith(branchId: branchId, lastModified: DateTime.now());
    await _dao.upsertSupplierCustomer(_toCompanion(model));
    SyncService.notifyTableUpdated('supplier_customers', branchId);
    unawaited(
      SyncService.queueOperation(
        type: SyncOperationType.create,
        table: 'supplier_customers',
        data: model.toJson(),
        branchId: branchId,
      ),
    );
  }

  Future<void> update(SupplierCustomerModel entity, {required String branchId}) async {
    final model = entity.copyWith(branchId: branchId, lastModified: DateTime.now());
    await _dao.upsertSupplierCustomer(_toCompanion(model));
    SyncService.notifyTableUpdated('supplier_customers', branchId);
    unawaited(
      SyncService.queueOperation(
        type: SyncOperationType.update,
        table: 'supplier_customers',
        data: model.toJson(),
        branchId: branchId,
      ),
    );
  }

  Future<void> delete(SupplierCustomerModel entity, {required String branchId}) async {
    await ArchiveService.record(
      entityType: 'supplier_customer',
      entityId: entity.id,
      entityName: entity.name,
      entityData: entity.toJson(),
      branchId: branchId,
    );
    await update(entity.copyWith(isDeleted: true), branchId: branchId);
  }

  static void dispose() {
    for (final t in _cacheTimers.values) {
      t.cancel();
    }
    _cache.clear();
    _cacheTimers.clear();
  }
}
