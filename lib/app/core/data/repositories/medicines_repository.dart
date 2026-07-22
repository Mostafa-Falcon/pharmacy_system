import 'dart:async';

import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/core/data/database/daos/medicines_dao.dart';
import 'package:pharmacy_system/app/core/injection.dart';
import 'package:pharmacy_system/app/modules/inventory/models/medicine_model.dart';
import 'package:pharmacy_system/app/modules/inventory/models/medicine_unit_model.dart';
import 'package:pharmacy_system/app/core/data/services/sync/sync_service.dart';
import 'package:pharmacy_system/app/modules/archive/services/archive_service.dart';

class MedicinesRepository {
  MedicinesDao get _dao => sl<MedicinesDao>();
  MedicinesRepository();

  // Cache for sync reads (until full async migration)
  static final Map<String, List<MedicineModel>> _cache = {};
  static final Map<String, Timer> _cacheTimers = {};

  List<MedicineModel> _cached(String branchId) => List<MedicineModel>.from(_cache[branchId] ?? []);

  void _updateCache(String branchId, List<MedicineModel> items) {
    _cache[branchId] = items;
    _cacheTimers[branchId]?.cancel();
    _cacheTimers[branchId] = Timer(const Duration(seconds: 5), () {
      _cache.remove(branchId);
    });
  }

  // ─── Converters ──────────────────────────────────────────────────

  MedicineModel _toModel(MedicinesTableData d) {
    return MedicineModel(
      id: d.id,
      name: d.name,
      nameEn: d.nameEn,
      category: d.category,
      barcodes: d.barcodes.isNotEmpty
          ? List<String>.from(jsonDecode(d.barcodes) as List)
          : [],
      buyPrice: d.buyPrice,
      sellPrice: d.sellPrice,
      quantity: d.quantity,
      minStock: d.minStock,
      expiryDate: d.expiryDate,
      manufacturer: d.manufacturer,
      branchId: d.branchId,
      syncVersion: d.syncVersion,
      lastModified: d.lastModified,
      isDeleted: d.isDeleted,
      dosageForm: d.dosageForm,
      strength: d.strength,
      packageSize: d.packageSize,
      expiryTrackingEnabled: d.expiryTrackingEnabled,
      supplierName: d.supplierName,
      description: d.description,
      oldSellPrice: d.oldSellPrice,
      itemTypeId: d.itemTypeId,
      groupId: d.groupId,
      units: d.units.isNotEmpty
          ? (jsonDecode(d.units) as List)
              .map((e) => MedicineUnitModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
      alertEnabled: d.alertEnabled,
      dosageFormEnabled: d.dosageFormEnabled,
      imageUrl: d.imageUrl,
      containerShape: d.containerShape,
      allowNegativeStock: d.allowNegativeStock,
      isTaxable: d.isTaxable,
      taxType: d.taxType,
      taxValue: d.taxValue,
      pricesIncludeTax: d.pricesIncludeTax,
      location: d.location,
      isActive: d.isActive,
      createdAt: d.createdAt,
    );
  }

  MedicinesTableCompanion _toCompanion(MedicineModel m) {
    return MedicinesTableCompanion(
      id: Value(m.id),
      name: Value(m.name),
      nameEn: Value(m.nameEn),
      category: Value(m.category),
      barcodes: Value(jsonEncode(m.barcodes)),
      buyPrice: Value(m.buyPrice),
      sellPrice: Value(m.sellPrice),
      quantity: Value(m.quantity),
      minStock: Value(m.minStock),
      expiryDate: Value(m.expiryDate),
      manufacturer: Value(m.manufacturer),
      branchId: Value(m.branchId),
      syncVersion: Value(m.syncVersion),
      lastModified: Value(m.lastModified),
      isDeleted: Value(m.isDeleted),
      dosageForm: Value(m.dosageForm),
      strength: Value(m.strength),
      packageSize: Value(m.packageSize),
      expiryTrackingEnabled: Value(m.expiryTrackingEnabled),
      supplierName: Value(m.supplierName),
      description: Value(m.description),
      oldSellPrice: Value(m.oldSellPrice),
      itemTypeId: Value(m.itemTypeId),
      groupId: Value(m.groupId),
      units: Value(jsonEncode(m.units.map((u) => u.toJson()).toList())),
      alertEnabled: Value(m.alertEnabled),
      dosageFormEnabled: Value(m.dosageFormEnabled),
      imageUrl: Value(m.imageUrl),
      containerShape: Value(m.containerShape),
      allowNegativeStock: Value(m.allowNegativeStock),
      isTaxable: Value(m.isTaxable),
      taxType: Value(m.taxType),
      taxValue: Value(m.taxValue),
      pricesIncludeTax: Value(m.pricesIncludeTax),
      location: Value(m.location),
      isActive: Value(m.isActive),
      createdAt: Value(m.createdAt),
    );
  }

  // ─── Query Methods ───────────────────────────────────────────────

  Future<List<MedicineModel>> getMedicines({
    required String branchId,
    String? searchQuery,
    String? category,
    bool includeDeleted = false,
  }) async {
    final items = await _dao.getByBranch(branchId);
    final data = items.map<MedicineModel>(_toModel).toList();
    _updateCache(branchId, data);

    if (searchQuery != null && searchQuery.isNotEmpty) {
      final q = searchQuery.trim().toLowerCase();
      data.removeWhere((m) => !_matchesSearch(m, q));
    }

    if (category != null) {
      data.removeWhere((m) => m.category != category);
    }

    data.sort((a, b) {
      if (a.expiryDate == null && b.expiryDate == null) return 0;
      if (a.expiryDate == null) return 1;
      if (b.expiryDate == null) return -1;
      return a.expiryDate!.compareTo(b.expiryDate!);
    });

    return data;
  }

  /// Sync read from cache (migration bridge)
  List<MedicineModel> getMedicinesSync({required String branchId}) {
    return _cached(branchId);
  }

  Stream<List<MedicineModel>> watchMedicines(String branchId) {
    return _dao.watchByBranch(branchId).map((rows) {
      final result = rows.map(_toModel).toList();
      _updateCache(branchId, result);
      return result;
    });
  }

  Future<MedicineModel?> getByIdAsync(String id) async {
    final data = await _dao.getById(id);
    return data != null ? _toModel(data) : null;
  }

  /// Sync read from cache (migration bridge)
  MedicineModel? getById(String id) {
    for (final entry in _cache.entries) {
      final match = entry.value.where((m) => m.id == id);
      if (match.isNotEmpty) return match.first;
    }
    return null;
  }

  // ─── CRUD Operations ────────────────────────────────────────────

  Future<void> create(
    MedicineModel medicine, {
    required String branchId,
  }) async {
    medicine.lastModified = DateTime.now();
    await _dao.upsert(_toCompanion(medicine));
    SyncService.onTableUpdated?.call('medicines', branchId);
    unawaited(
      SyncService.queueOperation(
        type: SyncOperationType.create,
        table: 'medicines',
        data: medicine.toJson(),
        branchId: branchId,
      ),
    );
  }

  Future<void> update(
    MedicineModel medicine, {
    required String branchId,
  }) async {
    medicine.lastModified = DateTime.now();
    await _dao.upsert(_toCompanion(medicine));
    SyncService.onTableUpdated?.call('medicines', branchId);
    unawaited(
      SyncService.queueOperation(
        type: SyncOperationType.update,
        table: 'medicines',
        data: medicine.toJson(),
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

    await _dao.softDelete(medicine.id);
    SyncService.onTableUpdated?.call('medicines', branchId);
    unawaited(
      SyncService.queueOperation(
        type: SyncOperationType.delete,
        table: 'medicines',
        data: medicine.toJson()..['is_deleted'] = true,
        branchId: branchId,
      ),
    );
  }

  // ─── Stock Management ──────────────────────────────────────────

  Future<void> updateQuantity({
    required String medicineId,
    required int delta,
    required String branchId,
  }) async {
    final data = await _dao.getById(medicineId);
    if (data == null) return;

    await _dao.upsert(MedicinesTableCompanion(
      id: Value(medicineId),
      quantity: Value(data.quantity + delta),
      lastModified: Value(DateTime.now()),
    ));
  }

  Future<void> batchUpdateQuantities({
    required List<String> medicineIds,
    required List<int> deltas,
    required String branchId,
  }) async {
    if (medicineIds.length != deltas.length) return;

    final updates = <MedicinesTableCompanion>[];
    for (int i = 0; i < medicineIds.length; i++) {
      final data = await _dao.getById(medicineIds[i]);
      if (data != null) {
        updates.add(MedicinesTableCompanion(
          id: Value(medicineIds[i]),
          quantity: Value(data.quantity + deltas[i]),
          lastModified: Value(DateTime.now()),
        ));
      }
    }
    await _dao.upsertBatch(updates);
  }

  // ─── Statistics ────────────────────────────────────────────────

  Future<Map<String, int>> getStockStats(String branchId) async {
    final data = await _dao.getByBranch(branchId);
    final medicines = data.map(_toModel).toList();
    final now = DateTime.now();

    return {
      'total': medicines.length,
      'lowStock': medicines.where((m) => m.quantity <= m.minStock).length,
      'outOfStock': medicines.where((m) => m.quantity <= 0).length,
      'expiring': medicines
          .where(
            (m) =>
                m.expiryDate != null &&
                m.expiryDate!.isAfter(now) &&
                m.expiryDate!.difference(now).inDays <= 90,
          )
          .length,
      'expired': medicines
          .where((m) => m.expiryDate != null && m.expiryDate!.isBefore(now))
          .length,
    };
  }

  Future<List<String>> getCategories(String branchId) async {
    final data = await _dao.getByBranch(branchId);
    final cats = data.map((r) => r.category).whereType<String>().toSet().toList();
    cats.sort();
    return cats;
  }

  // ─── Batch Operations ──────────────────────────────────────────

  Future<void> batchCreate(List<MedicineModel> medicines, {required String branchId, bool skipSync = false}) async {
    await _dao.upsertBatch(medicines.map(_toCompanion).toList());
    
    if (!skipSync) {
      for (final m in medicines) {
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
    SyncService.onTableUpdated?.call('medicines', branchId);
  }

  Future<void> batchUpdate(List<MedicineModel> medicines, {required String branchId, bool skipSync = false}) async {
    await _dao.upsertBatch(medicines.map(_toCompanion).toList());

    if (!skipSync) {
      for (final m in medicines) {
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
    SyncService.onTableUpdated?.call('medicines', branchId);
  }

  // ─── Helpers ───────────────────────────────────────────────────

  bool _matchesSearch(MedicineModel medicine, String query) {
    return medicine.name.toLowerCase().contains(query) ||
        (medicine.nameEn?.toLowerCase().contains(query) ?? false) ||
        medicine.barcodes.any((b) => b.toLowerCase().contains(query));
  }

  static void dispose() {
    for (final t in _cacheTimers.values) {
      t.cancel();
    }
    _cache.clear();
    _cacheTimers.clear();
  }
}

