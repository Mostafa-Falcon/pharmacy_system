import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/core/data/database/daos/item_batches_dao.dart';
import 'package:pharmacy_system/app/core/injection.dart';
import 'package:pharmacy_system/app/core/models/inventory/item_batch_model.dart';
import 'package:pharmacy_system/app/core/utils/app_utils.dart';

class BatchService {
  static final BatchService _instance = BatchService._internal();
  factory BatchService() => _instance;
  BatchService._internal();

  static BatchService get to => GetIt.instance<BatchService>();

  ItemBatchesDao get _dao => sl<ItemBatchesDao>();

  List<ItemBatchModel> _cache = [];

  List<ItemBatchModel> _cached() => List.unmodifiable(_cache);

  void _updateCache(List<ItemBatchModel> items) {
    _cache = items;
  }

  Future<void> init() async {
    final all = await _dao.getAll();
    _updateCache(all.map(_toModel).toList());
    await _autoExpiryCheck();
  }

  List<ItemBatchModel> getBatches(String medicineId) {
    return _cached()
        .where((b) => b.medicineId == medicineId && !b.isDeleted)
        .toList()
      ..sort((a, b) {
        if (a.expiryDate == null && b.expiryDate == null) return 0;
        if (a.expiryDate == null) return 1;
        if (b.expiryDate == null) return -1;
        return a.expiryDate!.compareTo(b.expiryDate!);
      });
  }

  List<ItemBatchModel> getActiveBatches(String medicineId) {
    return getBatches(medicineId).where((b) => b.isActive).toList();
  }

  int getTotalQuantity(String medicineId) {
    return getActiveBatches(medicineId)
        .fold(0, (sum, b) => sum + b.availableQuantity);
  }

  int getDamagedQuantity(String medicineId) {
    return getActiveBatches(medicineId)
        .fold(0, (sum, b) => sum + b.damagedQuantity);
  }

  int getExpiredQuantity(String medicineId) {
    return getBatches(medicineId)
        .where((b) => b.isActive && b.isExpired)
        .fold(0, (sum, b) => sum + b.remainingQuantity);
  }

  ItemBatchModel? getNearestExpiry(String medicineId) {
    final active = getActiveBatches(medicineId)
        .where((b) => b.expiryDate != null && b.remainingQuantity > 0)
        .toList();
    if (active.isEmpty) return null;
    active.sort((a, b) => a.expiryDate!.compareTo(b.expiryDate!));
    return active.first;
  }

  Future<ItemBatchModel> addBatch({
    required String medicineId,
    String? batchNumber,
    DateTime? expiryDate,
    int quantity = 0,
    double? purchasePrice,
  }) async {
    final batch = ItemBatchModel(
      id: const Uuid().v4(),
      medicineId: medicineId,
      batchNumber: batchNumber,
      expiryDate: expiryDate,
      quantity: quantity,
      purchasePrice: purchasePrice,
    );
    await _dao.upsert(_toCompanion(batch));
    _cache.add(batch);
    return batch;
  }

  Future<void> updateBatch(ItemBatchModel batch) async {
    await _dao.upsert(_toCompanion(batch));
    final idx = _cache.indexWhere((b) => b.id == batch.id);
    if (idx != -1) _cache[idx] = batch;
  }

  Future<void> deleteBatch(String batchId) async {
    await _dao.softDelete(batchId);
    _cache.removeWhere((b) => b.id == batchId);
  }

  Future<ItemBatchModel?> findById(String id) async {
    final data = await _dao.getById(id);
    return data != null ? _toModel(data) : null;
  }

  List<ItemBatchAllocation> fefoPick({
    required String medicineId,
    required int quantity,
  }) {
    final batches = getActiveBatches(medicineId)
        .where((b) => b.availableQuantity > 0)
        .toList();
    batches.sort((a, b) {
      if (a.expiryDate == null && b.expiryDate == null) return 0;
      if (a.expiryDate == null) return 1;
      if (b.expiryDate == null) return -1;
      return a.expiryDate!.compareTo(b.expiryDate!);
    });

    final picked = <ItemBatchAllocation>[];
    int remaining = quantity;

    for (final batch in batches) {
      if (remaining <= 0) break;
      final take = remaining < batch.availableQuantity
          ? remaining
          : batch.availableQuantity;
      picked.add(ItemBatchAllocation(batch: batch, quantity: take));
      remaining -= take;
    }

    return picked;
  }

  Future<void> consumeFromBatches({
    required String medicineId,
    required int quantity,
  }) async {
    final allocations = fefoPick(medicineId: medicineId, quantity: quantity);
    for (final alloc in allocations) {
      alloc.batch.quantity -= alloc.quantity;
      await _dao.upsert(_toCompanion(alloc.batch));
      final idx = _cache.indexWhere((b) => b.id == alloc.batch.id);
      if (idx != -1) _cache[idx] = alloc.batch;
    }
  }

  Future<void> addToBatch({
    required String batchId,
    required int quantity,
  }) async {
    final batch = await findById(batchId);
    if (batch == null) return;
    batch.quantity += quantity;
    await _dao.upsert(_toCompanion(batch));
    final idx = _cache.indexWhere((b) => b.id == batchId);
    if (idx != -1) _cache[idx] = batch;
  }

  Future<void> markBatchAsDamaged({
    required String batchId,
    required int damagedQty,
  }) async {
    final batch = await findById(batchId);
    if (batch == null) return;
    if (damagedQty > batch.remainingQuantity) {
      throw StateError('?????? ??????? ???? ?? ?????? ???????? ?? ????????');
    }
    batch.damagedQuantity += damagedQty;
    await _dao.upsert(_toCompanion(batch));
    final idx = _cache.indexWhere((b) => b.id == batchId);
    if (idx != -1) _cache[idx] = batch;
  }

  Future<void> markExpiredBatches(String medicineId) async {
    final batches = getBatches(medicineId).where((b) => b.isExpired).toList();
    for (final batch in batches) {
      batch.damagedQuantity = batch.remainingQuantity;
      await _dao.upsert(_toCompanion(batch));
      final idx = _cache.indexWhere((b) => b.id == batch.id);
      if (idx != -1) _cache[idx] = batch;
    }
  }

  Future<ExpiryTrackingResult> runExpiryTracking() async {
    int checked = 0;
    int withExpired = 0;
    int marked = 0;

    final medicineIds = _cached().map((b) => b.medicineId).toSet();

    for (final medId in medicineIds) {
      final expired = getBatches(medId).where((b) => b.isExpired && b.isActive).toList();
      if (expired.isEmpty) continue;
      checked++;
      withExpired++;
      for (final batch in expired) {
        final remaining = batch.remainingQuantity;
        if (remaining > 0) {
          batch.damagedQuantity += remaining;
          await _dao.upsert(_toCompanion(batch));
          marked++;
        }
      }
    }

    return ExpiryTrackingResult(
      itemsChecked: checked,
      itemsWithExpiredBatches: withExpired,
      batchesMarkedAsDamaged: marked,
    );
  }

  Future<void> _autoExpiryCheck() async {
    final result = await runExpiryTracking();
    if (result.hasChanges) {
      safeDebugPrint('[BatchService] Expiry tracking: ${result.batchesMarkedAsDamaged} batches auto-marked');
    }
  }

  ItemBatchModel _toModel(ItemBatchesTableData d) {
    return ItemBatchModel(
      id: d.id,
      medicineId: d.medicineId,
      batchNumber: d.batchNumber,
      expiryDate: d.expiryDate,
      quantity: d.quantity,
      damagedQuantity: d.damagedQuantity,
      purchasePrice: d.purchasePrice,
      isActive: d.isActive,
      isDeleted: d.isDeleted,
      createdAt: d.createdAt,
    );
  }

  ItemBatchesTableCompanion _toCompanion(ItemBatchModel m) {
    return ItemBatchesTableCompanion(
      id: Value(m.id),
      medicineId: Value(m.medicineId),
      batchNumber: Value(m.batchNumber),
      expiryDate: Value(m.expiryDate),
      quantity: Value(m.quantity),
      damagedQuantity: Value(m.damagedQuantity),
      purchasePrice: Value(m.purchasePrice),
      isActive: Value(m.isActive),
      isDeleted: Value(m.isDeleted),
      createdAt: Value(m.createdAt),
    );
  }
}

class ItemBatchAllocation {
  final ItemBatchModel batch;
  final int quantity;

  const ItemBatchAllocation({required this.batch, required this.quantity});
}

class ExpiryTrackingResult {
  final int itemsChecked;
  final int itemsWithExpiredBatches;
  final int batchesMarkedAsDamaged;

  const ExpiryTrackingResult({
    required this.itemsChecked,
    required this.itemsWithExpiredBatches,
    required this.batchesMarkedAsDamaged,
  });

  bool get hasChanges => batchesMarkedAsDamaged > 0;
}




