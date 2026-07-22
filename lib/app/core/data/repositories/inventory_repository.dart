import 'dart:async';
import 'package:drift/drift.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/core/data/database/daos/inventory_dao.dart';
import 'package:pharmacy_system/app/core/injection.dart';
import 'package:pharmacy_system/app/modules/inventory/models/inventory_model.dart';
import 'package:pharmacy_system/app/core/data/services/sync/sync_service.dart';

class InventoryRepository {
  InventoryDao get _dao => sl<InventoryDao>();
  InventoryRepository();

  static final Map<String, List<InventoryItemModel>> _cache = {};
  static final Map<String, Timer> _cacheTimers = {};

  List<InventoryItemModel> _cached(String branchId) =>
      List<InventoryItemModel>.from(_cache[branchId] ?? []);

  void _updateCache(String branchId, List<InventoryItemModel> items) {
    _cache[branchId] = items;
    _cacheTimers[branchId]?.cancel();
    _cacheTimers[branchId] = Timer(const Duration(seconds: 5), () {
      _cache.remove(branchId);
    });
  }

  InventoryItemModel _toModel(InventoryTableData d) {
    return InventoryItemModel(
      id: d.id,
      medicineId: d.medicineId,
      branchId: d.branchId,
      currentQuantity: d.currentQuantity,
      minStock: d.minStock,
      maxStock: d.maxStock,
      lastRestocked: d.lastRestocked,
      syncVersion: d.syncVersion,
      lastModified: d.lastModified,
    );
  }

  InventoryTableCompanion _toCompanion(InventoryItemModel m) {
    return InventoryTableCompanion(
      id: Value(m.id),
      medicineId: Value(m.medicineId),
      branchId: Value(m.branchId),
      currentQuantity: Value(m.currentQuantity),
      minStock: Value(m.minStock),
      maxStock: Value(m.maxStock),
      lastRestocked: Value(m.lastRestocked),
      syncVersion: Value(m.syncVersion),
      lastModified: Value(m.lastModified),
    );
  }

  Future<List<InventoryItemModel>> getInventory({required String branchId}) async {
    final items = await _dao.getByBranch(branchId);
    final data = items.map(_toModel).toList();
    _updateCache(branchId, data);
    return data;
  }

  List<InventoryItemModel> getInventorySync({required String branchId}) {
    return _cached(branchId);
  }

  Stream<List<InventoryItemModel>> watchInventory(String branchId) {
    return _dao.db.select(_dao.db.inventoryTable).watch().map((rows) {
      final filtered = rows.where((r) => r.branchId == branchId);
      final result = filtered.map(_toModel).toList();
      _updateCache(branchId, result);
      return result;
    });
  }

  Future<InventoryItemModel?> getByIdAsync(String id) async {
    final data = await _dao.getById(id);
    return data != null ? _toModel(data) : null;
  }

  InventoryItemModel? getById(String id) {
    for (final entry in _cache.entries) {
      final match = entry.value.where((i) => i.id == id);
      if (match.isNotEmpty) return match.first;
    }
    return null;
  }

  Future<InventoryItemModel?> getByMedicine(
    String medicineId,
    String branchId,
  ) async {
    final data = await _dao.getByMedicineAndBranch(medicineId, branchId);
    return data != null ? _toModel(data) : null;
  }

  Future<void> upsert(InventoryItemModel item) async {
    await _dao.upsert(_toCompanion(item));
    SyncService.onTableUpdated?.call('inventory', item.branchId);
    unawaited(
      SyncService.queueOperation(
        type: SyncOperationType.create,
        table: 'inventory',
        data: item.toJson(),
        branchId: item.branchId,
      ),
    );
  }

  Future<void> delete(String id) async {
    await _dao.delete(id);
    SyncService.onTableUpdated?.call('inventory', '');
    unawaited(
      SyncService.queueOperation(
        type: SyncOperationType.delete,
        table: 'inventory',
        data: {'id': id, 'is_deleted': true},
        branchId: '',
      ),
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

