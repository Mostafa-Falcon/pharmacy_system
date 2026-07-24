import 'dart:async';
import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:pharmacy_system/app/core/data/database/daos/inventory_dao.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/core/injection.dart';
import 'package:pharmacy_system/app/core/models/inventory/medicine_model.dart';
import 'package:pharmacy_system/app/core/sync/sync_service.dart';
import 'package:pharmacy_system/app/modules/archive/services/archive_service.dart';

class MedicinesRepository {
  InventoryDao get _dao => sl<InventoryDao>();
  MedicinesRepository();

  static final Map<String, List<MedicineModel>> _cache = {};
  static final Map<String, Timer> _cacheTimers = {};

  List<MedicineModel> _cached(String branchId) =>
      List<MedicineModel>.from(_cache[branchId] ?? []);

  void _updateCache(String branchId, List<MedicineModel> items) {
    _cache[branchId] = items;
    _cacheTimers[branchId]?.cancel();
    _cacheTimers[branchId] = Timer(const Duration(seconds: 5), () {
      _cache.remove(branchId);
    });
  }

  MedicineModel _toModel(MedicinesTableData d) {
    return MedicineModel.fromJson({
      'id': d.id,
      'name': d.name,
      'name_en': d.nameEn,
      'item_types': jsonDecode(d.itemTypes),
      'therapeutic_group': jsonDecode(d.therapeuticGroup),
      'barcodes': jsonDecode(d.barcodes),
      'item_levels': jsonDecode(d.itemLevels),
      'expiry_dates': d.expiryDates != null ? jsonDecode(d.expiryDates!) : null,
      'supplier_id': d.supplierId,
      'manufacturer': d.manufacturer,
      'dosage_form': d.dosageForm,
      'strength': d.strength,
      'package_size': d.packageSize,
      'container_shape': d.containerShape,
      'location': d.location,
      'is_taxable': d.isTaxable,
      'tax_type': d.taxType,
      'tax_value': d.taxValue,
      'prices_include_tax': d.pricesIncludeTax,
      'alert_enabled': d.alertEnabled,
      'min_stock': d.minStock,
      'expiry_tracking_enabled': d.expiryTrackingEnabled,
      'allow_negative_stock': d.allowNegativeStock,
      'is_active': d.isActive,
      'image_url': d.imageUrl,
      'description': d.description,
      'account_id': d.accountId,
      'branch_id': d.branchId,
      'sync_version': d.syncVersion,
      'last_modified': d.lastModified.toIso8601String(),
      'is_deleted': d.isDeleted,
      'created_at': d.createdAt.toIso8601String(),
    });
  }

  MedicinesTableCompanion _toCompanion(MedicineModel m) {
    final json = m.toJson();
    return MedicinesTableCompanion(
      id: Value(m.id),
      name: Value(m.name),
      nameEn: Value(m.nameEn),
      itemTypes: Value(jsonEncode(json['item_types'])),
      therapeuticGroup: Value(jsonEncode(json['therapeutic_group'])),
      barcodes: Value(jsonEncode(json['barcodes'])),
      itemLevels: Value(jsonEncode(json['item_levels'])),
      expiryDates: m.expiryDates != null
          ? Value(jsonEncode(json['expiry_dates']))
          : const Value.absent(),
      supplierId: Value(m.supplierId),
      manufacturer: Value(m.manufacturer),
      dosageForm: Value(m.dosageForm),
      strength: Value(m.strength),
      packageSize: Value(m.packageSize),
      containerShape: Value(m.containerShape),
      location: Value(m.location),
      isTaxable: Value(m.isTaxable),
      taxType: Value(m.taxType),
      taxValue: Value(m.taxValue),
      pricesIncludeTax: Value(m.pricesIncludeTax),
      alertEnabled: Value(m.alertEnabled),
      minStock: Value(m.minStock),
      expiryTrackingEnabled: Value(m.expiryTrackingEnabled),
      allowNegativeStock: Value(m.allowNegativeStock),
      isActive: Value(m.isActive),
      imageUrl: Value(m.imageUrl),
      description: Value(m.description),
      accountId: Value(m.accountId),
      branchId: Value(m.branchId),
      syncVersion: Value(m.syncVersion),
      lastModified: Value(m.lastModified),
      isDeleted: Value(m.isDeleted),
      createdAt: Value(DateTime.now()), // Or keep original
    );
  }

  Future<List<MedicineModel>> getMedicines({
    required String branchId,
    String? searchQuery,
    bool includeDeleted = false,
  }) async {
    final items = await _dao.getAllMedicines();
    var data = items.map(_toModel).toList();
    _updateCache(branchId, data);

    if (searchQuery != null && searchQuery.isNotEmpty) {
      final q = searchQuery.trim().toLowerCase();
      data = data.where((m) => _matchesSearch(m, q)).toList();
    }

    return data;
  }

  List<MedicineModel> getMedicinesSync({required String branchId}) {
    return _cached(branchId);
  }

  Stream<List<MedicineModel>> watchMedicines(String branchId) {
    return _dao.watchAllMedicines().map((rows) {
      final result = rows.map(_toModel).toList();
      _updateCache(branchId, result);
      return result;
    });
  }

  Future<MedicineModel?> getByIdAsync(String id) async {
    final data = await _dao.getMedicineById(id);
    return data != null ? _toModel(data) : null;
  }

  MedicineModel? getById(String id) {
    for (final entry in _cache.entries) {
      final match = entry.value.where((m) => m.id == id);
      if (match.isNotEmpty) return match.first;
    }
    return null;
  }

  Future<void> create(
    MedicineModel medicine, {
    required String branchId,
  }) async {
    final model = medicine.copyWith(lastModified: DateTime.now());
    await _dao.upsertMedicine(_toCompanion(model));
    SyncService.notifyTableUpdated('medicines', branchId);
    unawaited(
      SyncService.queueOperation(
        type: SyncOperationType.create,
        table: 'medicines',
        data: model.toJson(),
        branchId: branchId,
      ),
    );
  }

  Future<void> update(
    MedicineModel medicine, {
    required String branchId,
  }) async {
    final model = medicine.copyWith(lastModified: DateTime.now());
    await _dao.upsertMedicine(_toCompanion(model));
    SyncService.notifyTableUpdated('medicines', branchId);
    unawaited(
      SyncService.queueOperation(
        type: SyncOperationType.update,
        table: 'medicines',
        data: model.toJson(),
        branchId: branchId,
      ),
    );
  }

  Future<void> delete(
    MedicineModel medicine, {
    required String branchId,
  }) async {
    await ArchiveService.record(
      entityType: 'medicine',
      entityId: medicine.id,
      entityName: medicine.name,
      entityData: medicine.toJson(),
      branchId: branchId,
    );
    await update(medicine.copyWith(isDeleted: true), branchId: branchId);
  }

  Future<void> batchCreate(
    List<MedicineModel> medicines, {
    required String branchId,
    bool skipSync = false,
  }) async {
    for (var m in medicines) {
      await _dao.upsertMedicine(_toCompanion(m));
      if (!skipSync) {
        unawaited(
          SyncService.queueOperation(
            type: SyncOperationType.create,
            table: 'medicines',
            data: m.toJson(),
            branchId: branchId,
          ),
        );
      }
    }
    SyncService.notifyTableUpdated('medicines', branchId);
  }

  Future<void> batchUpdate(
    List<MedicineModel> medicines, {
    required String branchId,
    bool skipSync = false,
  }) async {
    for (var m in medicines) {
      await _dao.upsertMedicine(_toCompanion(m));
      if (!skipSync) {
        unawaited(
          SyncService.queueOperation(
            type: SyncOperationType.update,
            table: 'medicines',
            data: m.toJson(),
            branchId: branchId,
          ),
        );
      }
    }
    SyncService.notifyTableUpdated('medicines', branchId);
  }

  bool _matchesSearch(MedicineModel medicine, String query) {
    return medicine.name.toLowerCase().contains(query) ||
        (medicine.nameEn?.toLowerCase().contains(query) ?? false) ||
        medicine.barcodes.any((b) => b.code.toLowerCase().contains(query));
  }

  static void dispose() {
    for (final t in _cacheTimers.values) {
      t.cancel();
    }
    _cache.clear();
    _cacheTimers.clear();
  }
}
