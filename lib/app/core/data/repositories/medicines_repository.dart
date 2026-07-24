import 'dart:async';
import 'package:pharmacy_system/app/core/data/database/daos/inventory_dao.dart';
import 'package:pharmacy_system/app/core/injection.dart';
import 'package:pharmacy_system/app/core/models/inventory/medicine_model.dart';
import 'package:pharmacy_system/app/core/sync/sync_service.dart';
import 'package:pharmacy_system/app/modules/archive/services/archive_service.dart';
import 'package:pharmacy_system/app/core/data/mappers/mappers.dart';

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

  Future<List<MedicineModel>> getMedicines({
    required String branchId,
    String? searchQuery,
    bool includeDeleted = false,
  }) async {
    final items = await _dao.getAllMedicines();
    var data = items.map(InventoryMapper.medicineFromData).toList();
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
      final result = rows.map(InventoryMapper.medicineFromData).toList();
      _updateCache(branchId, result);
      return result;
    });
  }

  Future<MedicineModel?> getByIdAsync(String id) async {
    final data = await _dao.getMedicineById(id);
    return data != null ? InventoryMapper.medicineFromData(data) : null;
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
    await _dao.upsertMedicine(InventoryMapper.medicineToCompanion(model));
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
    await _dao.upsertMedicine(InventoryMapper.medicineToCompanion(model));
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
      await _dao.upsertMedicine(InventoryMapper.medicineToCompanion(m));
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
      await _dao.upsertMedicine(InventoryMapper.medicineToCompanion(m));
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
