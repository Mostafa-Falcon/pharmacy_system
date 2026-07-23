import 'dart:async';
import 'package:collection/collection.dart';
import 'package:uuid/uuid.dart';

import 'package:drift/drift.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/core/data/database/daos/supplier_customers_dao.dart';
import 'package:pharmacy_system/app/modules/contacts/models/supplier_customer_model.dart';
import 'package:pharmacy_system/app/core/data/services/sync/sync_service.dart';
import '../../../../core/injection.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/core/data/services/party_ledger_service.dart';
import '../../../../modules/archive/services/archive_service.dart';
import '../../../../core/utils/app_utils.dart';

class SupplierCustomerService {
  static SupplierCustomersDao get _dao => sl<SupplierCustomersDao>();
  static const _uuid = Uuid();

  static List<SupplierCustomerModel>? _cachedList;
  static Timer? _cacheTimer;

  static List<SupplierCustomerModel> _cached() =>
      List<SupplierCustomerModel>.from(_cachedList ?? []);

  static void _updateCache(List<SupplierCustomerModel> items) {
    _cachedList = items;
    _cacheTimer?.cancel();
    _cacheTimer = Timer(const Duration(seconds: 5), () {
      _cachedList = null;
    });
  }

  static SupplierCustomerModel _toModel(SupplierCustomersTableData d) {
    return SupplierCustomerModel(
      id: d.id,
      name: d.name,
      phone: d.phone,
      address: d.address,
      email: d.email,
      companyName: d.companyName,
      taxId: d.taxId,
      isActive: d.isActive,
      notes: d.notes,
      customerKindIndex: d.customerKindIndex,
      creditLimit: d.creditLimit,
      discountPercent: d.discountPercent,
      paymentTermDays: d.paymentTermDays,
      supplierPartyTypeIndex: d.supplierPartyTypeIndex,
      lastModified: d.lastModified,
      isDeleted: d.isDeleted,
      branchId: d.branchId,
    );
  }

  static SupplierCustomersTableCompanion _toCompanion(SupplierCustomerModel m) {
    return SupplierCustomersTableCompanion(
      id: Value(m.id),
      name: Value(m.name),
      phone: Value(m.phone),
      address: Value(m.address),
      email: Value(m.email),
      companyName: Value(m.companyName),
      taxId: Value(m.taxId),
      isActive: Value(m.isActive),
      notes: Value(m.notes),
      customerKindIndex: Value(m.customerKindIndex),
      creditLimit: Value(m.creditLimit),
      discountPercent: Value(m.discountPercent),
      paymentTermDays: Value(m.paymentTermDays),
      supplierPartyTypeIndex: Value(m.supplierPartyTypeIndex),
      lastModified: Value(m.lastModified),
      isDeleted: Value(m.isDeleted),
      branchId: Value(m.branchId ?? AuthService.currentBranchId ?? ''),
    );
  }

  static Future<void> init() async {
    final items = await _dao.getAll();
    _updateCache(items.map(_toModel).toList());
  }

  static Stream<List<SupplierCustomerModel>> watchAll() {
    return _dao.watchAll().map((list) => list.map(_toModel).toList());
  }

  static List<SupplierCustomerModel> getAll({bool activeOnly = true, bool includeDeleted = false}) {
    var items = _cached();
    // ذكاء مهندسة: لو الكاش لسه فاضي، جرب تقرأ الداتا من الداتابيز مباشرة
    // عشان ما تظهرش "لا يوجد سجلات" واليوزر لسه ضايف حاجة.
    if (items.isEmpty) {
       // ملحوظة: getAll() في الـ DAO هي Sync في Drift عادةً، بس هنا محتاجة await
       // فبنكتفي بإرجاع الكاش ونعمل تريجر للـ init في الخلفية.
       init();
    }
    if (!includeDeleted) {
      items = items.where((c) => !c.isDeleted).toList();
    }
    if (activeOnly) {
      items = items.where((c) => c.isActive).toList();
    }
    return items;
  }

  static SupplierCustomerModel? getById(String? id) {
    if (id == null) return null;
    return _cached().firstWhereOrNull((c) => c.id == id);
  }

  static Future<SupplierCustomerModel> add({
    required String name,
    String? phone,
    String? address,
    String? email,
    String? companyName,
    String? taxId,
    String? notes,
    int customerKindIndex = 0,
    double creditLimit = 0,
    double discountPercent = 0,
    int paymentTermDays = 0,
    int supplierPartyTypeIndex = 0,
    double openingBalance = 0,
    String openingBalanceDirection = 'debit',
  }) async {
    try {
      final branchId = AuthService.currentBranchId ?? '';
      final model = SupplierCustomerModel(
        id: _uuid.v4(),
        name: name,
        phone: phone,
        address: address,
        email: email,
        companyName: companyName,
        taxId: taxId,
        notes: notes,
        customerKindIndex: customerKindIndex,
        creditLimit: creditLimit,
        discountPercent: discountPercent,
        paymentTermDays: paymentTermDays,
        supplierPartyTypeIndex: supplierPartyTypeIndex,
        branchId: branchId,
      );
      await _dao.upsert(_toCompanion(model));
      _cachedList = null; // Invalidate cache

      // Queue for Sync
      unawaited(
        SyncService.queueOperation(
          type: SyncOperationType.create,
          table: 'supplier_customers',
          data: model.toJson(),
          branchId: branchId,
        ),
      );

      if (openingBalance > 0) {
        await PartyLedgerService.recordOpeningBalance(
          partyId: model.id,
          amount: openingBalance,
          createdBy: AuthService.currentUser?.id ?? 'system',
          direction: openingBalanceDirection,
          notes: notes,
        );
      }

      return model;
    } catch (e, s) {
      safeDebugPrint('SupplierCustomerService.add failed: $e\n$s');
      rethrow;
    }
  }

  static Future<void> update(SupplierCustomerModel model) async {
    try {
      model.lastModified = DateTime.now();
      model.branchId ??= AuthService.currentBranchId;
      await _dao.upsert(_toCompanion(model));
      _cachedList = null; // Invalidate cache

      // Queue for Sync
      unawaited(
        SyncService.queueOperation(
          type: SyncOperationType.update,
          table: 'supplier_customers',
          data: model.toJson(),
          branchId: model.branchId ?? '',
        ),
      );
    } catch (e, s) {
      safeDebugPrint('SupplierCustomerService.update failed: $e\n$s');
      rethrow;
    }
  }

  static Future<void> delete(String id) async {
    try {
      final model = getById(id);
      if (model != null) {
        final branchId = model.branchId ?? AuthService.currentBranchId ?? '';
        await ArchiveService.record(
          entityType: 'supplier_customer',
          entityId: model.id,
          entityName: model.name,
          entityData: model.toJson(),
          branchId: branchId,
        );
        await _dao.softDelete(id);

        // Queue for Sync
        unawaited(
          SyncService.queueOperation(
            type: SyncOperationType.delete,
            table: 'supplier_customers',
            data: model.toJson()..['is_deleted'] = true,
            branchId: branchId,
          ),
        );
      }
    } catch (e, s) {
      safeDebugPrint('SupplierCustomerService.delete failed: $e\n$s');
      rethrow;
    }
  }
}

