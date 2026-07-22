import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/core/data/database/daos/stocktaking_dao.dart';
import 'package:pharmacy_system/app/core/data/database/daos/stocktaking_items_dao.dart';
import 'package:pharmacy_system/app/core/injection.dart';
import 'package:pharmacy_system/app/modules/inventory/models/stocktaking_period_model.dart';
import 'package:pharmacy_system/app/modules/inventory/models/stocktaking_model.dart';
import '../auth/auth_service.dart';
import 'package:pharmacy_system/app/core/data/services/sync/sync_service.dart';
import 'stock_mutation_service.dart';

class StocktakingService {
  static final StocktakingService _instance = StocktakingService._internal();
  factory StocktakingService() => _instance;
  StocktakingService._internal();

  static StocktakingService get to => GetIt.instance<StocktakingService>();

  StocktakingDao get _periodDao => sl<StocktakingDao>();
  StocktakingItemsDao get _itemsDao => sl<StocktakingItemsDao>();

  String get _branchId => AuthService.currentBranchId ?? '';
  String get _userId => AuthService.currentUser?.id ?? '';

  // ─── Periods ───
  Future<List<StocktakingPeriodModel>> getPeriods() async {
    final rows = await _periodDao.getByBranch(_branchId);
    return rows.map(_periodFromData).toList();
  }

  Future<List<StocktakingPeriodModel>> getPeriodsPage(int page, int pageSize) async {
    final all = await getPeriods();
    final start = (page - 1) * pageSize;
    if (start >= all.length) return [];
    return all.sublist(start, (start + pageSize).clamp(0, all.length));
  }

  Future<StocktakingPeriodModel?> getPeriod(String id) async {
    final data = await _periodDao.getById(id);
    return data != null ? _periodFromData(data) : null;
  }

  Future<StocktakingPeriodModel> createPeriod({
    required String name,
    String? notes,
  }) async {
    final id = const Uuid().v4();
    final now = DateTime.now();
    final period = StocktakingPeriodModel(
      id: id,
      branchId: _branchId,
      name: name,
      status: 'open',
      startedAt: now,
      createdBy: _userId,
      notes: notes,
    );
    await _periodDao.upsert(_toPeriodCompanion(period));
    await SyncService.queueOperation(
      type: SyncOperationType.create,
      table: 'stocktaking_periods',
      data: period.toJson(),
      branchId: _branchId,
    );
    return period;
  }

  Future<void> updatePeriod(
    String id, {
    String? name,
    String? status,
    String? notes,
  }) async {
    final existing = await _periodDao.getById(id);
    if (existing == null) return;

    final decoded = _decodePeriodNotes(existing.notes);
    if (name != null) decoded['n'] = name;
    if (status != null) decoded['st'] = status;
    if (notes != null) decoded['notes'] = notes;

    final now = DateTime.now();
    await _periodDao.upsert(StocktakingTableCompanion(
      id: Value(id),
      status: status != null ? Value(status) : Value(existing.status),
      notes: Value(jsonEncode(decoded)),
      lastModified: Value(now),
    ));

    final period = StocktakingPeriodModel(
      id: id,
      branchId: existing.branchId,
      name: decoded['n'] as String? ?? '',
      status: decoded['st'] as String? ?? existing.status,
      startedAt: existing.startDate,
      closedAt: existing.endDate,
      notes: decoded['notes'] as String?,
      createdBy: existing.createdBy,
      syncVersion: existing.syncVersion + 1,
      lastModified: now,
    );
    await SyncService.queueOperation(
      type: SyncOperationType.update,
      table: 'stocktaking_periods',
      data: period.toJson(),
      branchId: _branchId,
    );
  }

  Future<void> deletePeriod(String id) async {
    await _periodDao.softDelete(id);
    final period = await _periodDao.getById(id);
    if (period != null) {
      await SyncService.queueOperation(
        type: SyncOperationType.delete,
        table: 'stocktaking_periods',
        data: _periodFromData(period).toJson(),
        branchId: _branchId,
      );
    }
  }

  // ─── Close Period ───
  Future<void> closePeriod(String periodId, {String? notes}) async {
    final existing = await _periodDao.getById(periodId);
    if (existing == null) throw Exception('Period not found');
    if (existing.status == 'closed') throw Exception('Period is already closed');
    if (existing.status == 'cancelled') throw Exception('Cannot close a cancelled period');

    final items = await _itemsDao.getByStocktaking(periodId);
    double totalDiff = 0;

    for (final item in items) {
      final extra = _decodeItemNotes(item.notes);
      final bp = (extra['bp'] as num?)?.toDouble() ?? 0.0;
      totalDiff += item.difference * bp;

      if (item.difference != 0) {
        await StockMutationService.adjustStock(
          medicineId: item.medicineId,
          delta: item.difference,
          branchId: existing.branchId,
        );
      }
    }

    final decoded = _decodePeriodNotes(existing.notes);
    final now = DateTime.now();
    await _periodDao.upsert(StocktakingTableCompanion(
      id: Value(periodId),
      status: const Value('closed'),
      endDate: Value(now),
      notes: Value(jsonEncode({...decoded, 'td': totalDiff})),
      lastModified: Value(now),
    ));

    final period = StocktakingPeriodModel(
      id: periodId,
      branchId: existing.branchId,
      name: decoded['n'] as String? ?? '',
      status: 'closed',
      startedAt: existing.startDate,
      closedAt: now,
      notes: decoded['notes'] as String?,
      createdBy: existing.createdBy,
      syncVersion: existing.syncVersion + 1,
      lastModified: now,
    );
    await SyncService.queueOperation(
      type: SyncOperationType.update,
      table: 'stocktaking_periods',
      data: period.toJson(),
      branchId: _branchId,
    );
  }

  Future<void> cancelPeriod(String periodId) async {
    final existing = await _periodDao.getById(periodId);
    if (existing == null) throw Exception('Period not found');
    if (existing.status == 'closed') throw Exception('Cannot cancel a closed period');

    final now = DateTime.now();
    await _periodDao.upsert(StocktakingTableCompanion(
      id: Value(periodId),
      status: const Value('cancelled'),
      endDate: Value(now),
      lastModified: Value(now),
    ));

    final decoded = _decodePeriodNotes(existing.notes);
    final period = StocktakingPeriodModel(
      id: periodId,
      branchId: existing.branchId,
      name: decoded['n'] as String? ?? '',
      status: 'cancelled',
      startedAt: existing.startDate,
      closedAt: now,
      notes: decoded['notes'] as String?,
      createdBy: existing.createdBy,
      syncVersion: existing.syncVersion + 1,
      lastModified: now,
    );
    await SyncService.queueOperation(
      type: SyncOperationType.update,
      table: 'stocktaking_periods',
      data: period.toJson(),
      branchId: _branchId,
    );
  }

  // ─── Counts ───
  Future<List<StocktakingCountModel>> getCounts(String periodId) async {
    final rows = await _itemsDao.getByStocktaking(periodId);
    return rows.map(_itemFromData).toList();
  }

  Future<StocktakingCountModel?> getCount(String id) async {
    final data = await _itemsDao.getById(id);
    return data != null ? _itemFromData(data) : null;
  }

  Future<StocktakingCountModel> recordCount({
    required String periodId,
    required String itemId,
    required String itemName,
    String? sku,
    String unit = 'وحدة',
    required int systemQuantity,
    required int actualQuantity,
    double buyPrice = 0,
    String? notes,
  }) async {
    final id = const Uuid().v4();
    final now = DateTime.now();
    final diff = actualQuantity - systemQuantity;

    final count = StocktakingCountModel(
      id: id,
      periodId: periodId,
      itemId: itemId,
      itemName: itemName,
      sku: sku,
      unit: unit,
      systemQuantity: systemQuantity,
      actualQuantity: actualQuantity,
      buyPrice: buyPrice,
      notes: notes,
      createdBy: _userId,
    );

    final extraJson = <String, dynamic>{
      's': sku,
      'u': unit,
      'bp': buyPrice,
      'dv': diff * buyPrice,
      'cb': _userId,
      'ca': now.millisecondsSinceEpoch,
      'ua': now.millisecondsSinceEpoch,
    };
    if (notes != null) extraJson['notes'] = notes;

    await _itemsDao.upsert(StocktakingItemsTableCompanion(
      id: Value(id),
      stocktakingId: Value(periodId),
      medicineId: Value(itemId),
      medicineName: Value(itemName),
      systemQuantity: Value(systemQuantity),
      countedQuantity: Value(actualQuantity),
      difference: Value(diff),
      notes: Value(jsonEncode(extraJson)),
      syncVersion: const Value(1),
      lastModified: Value(now),
      isDeleted: const Value(false),
    ));

    // Update period counters
    final existing = await _periodDao.getById(periodId);
    if (existing != null) {
      final decoded = _decodePeriodNotes(existing.notes);
      final itemsCount = (await _itemsDao.getByStocktaking(periodId)).length;
      decoded['ci'] = itemsCount;
      final prevTd = (decoded['td'] as num?)?.toDouble() ?? 0;
      decoded['td'] = prevTd + diff * buyPrice;
      if (existing.status == 'open') decoded['st'] = 'inProgress';

      await _periodDao.upsert(StocktakingTableCompanion(
        id: Value(periodId),
        status: existing.status == 'open' ? const Value('inProgress') : Value(existing.status),
        notes: Value(jsonEncode(decoded)),
        lastModified: Value(now),
      ));
    }

    return count;
  }

  Future<void> updateCount(
    String id, {
    int? actualQuantity,
    String? notes,
  }) async {
    final existing = await _itemsDao.getById(id);
    if (existing == null) return;

    final extraJson = _decodeItemNotes(existing.notes);
    final bp = (extraJson['bp'] as num?)?.toDouble() ?? 0.0;
    final oldDiff = existing.difference.toDouble() * bp;
    final now = DateTime.now();

    int newActual = existing.countedQuantity;
    if (actualQuantity != null) newActual = actualQuantity;
    final newDiff = newActual - existing.systemQuantity;

    if (notes != null) extraJson['notes'] = notes;
    extraJson['ua'] = now.millisecondsSinceEpoch;

    await _itemsDao.upsert(StocktakingItemsTableCompanion(
      id: Value(id),
      countedQuantity: actualQuantity != null ? Value(actualQuantity) : Value(existing.countedQuantity),
      difference: actualQuantity != null ? Value(newDiff) : Value(existing.difference),
      notes: Value(jsonEncode(extraJson)),
      lastModified: Value(now),
    ));

    // Adjust period total
    final period = await _periodDao.getById(existing.stocktakingId);
    if (period != null) {
      final pDecoded = _decodePeriodNotes(period.notes);
      final prevTd = (pDecoded['td'] as num?)?.toDouble() ?? 0.0;
      final bpVal = (extraJson['bp'] as num?)?.toDouble() ?? 0.0;
      final newTd = prevTd - oldDiff + newDiff * bpVal;
      pDecoded['td'] = newTd;
      await _periodDao.upsert(StocktakingTableCompanion(
        id: Value(existing.stocktakingId),
        notes: Value(jsonEncode(pDecoded)),
        lastModified: Value(now),
      ));
    }
  }

  Future<void> deleteCount(String id) async {
    final existing = await _itemsDao.getById(id);
    if (existing == null) return;
    await _itemsDao.softDelete(id);

    // Recalculate period
    final period = await _periodDao.getById(existing.stocktakingId);
    if (period != null) {
      final pDecoded = _decodePeriodNotes(period.notes);
      final extraJson = _decodeItemNotes(existing.notes);
      final bp = (extraJson['bp'] as num?)?.toDouble() ?? 0.0;
      final diffVal = existing.difference.toDouble() * bp;
      final prevTd = (pDecoded['td'] as num?)?.toDouble() ?? 0.0;
      pDecoded['td'] = prevTd - diffVal;

      final itemsCount = (await _itemsDao.getByStocktaking(existing.stocktakingId)).length;
      pDecoded['ci'] = itemsCount;

      await _periodDao.upsert(StocktakingTableCompanion(
        id: Value(existing.stocktakingId),
        notes: Value(jsonEncode(pDecoded)),
        lastModified: Value(DateTime.now()),
      ));
    }
  }

  Future<void> deleteCountAndRestore(String id) async {
    final existing = await _itemsDao.getById(id);
    if (existing == null) return;

    if (existing.difference != 0) {
      await StockMutationService.adjustStock(
        medicineId: existing.medicineId,
        delta: -existing.difference,
        branchId: _branchId,
      );
    }

    await deleteCount(id);
  }

  // ─── Migration ───
  Future<void> migrateFromOldModel(StocktakingModel old) async {
    final period = StocktakingPeriodModel(
      id: old.id,
      branchId: old.branchId,
      name: 'جرد ${old.startDate.toString().substring(0, 10)}',
      status: old.status == StocktakingStatus.confirmed ? 'closed' : 'open',
      startedAt: old.startDate,
      closedAt: old.endDate,
      createdBy: old.createdBy,
    );
    await _periodDao.upsert(_toPeriodCompanion(period));
  }

  // ─── Converters ───

  StocktakingPeriodModel _periodFromData(StocktakingTableData d) {
    final decoded = _decodePeriodNotes(d.notes);
    return StocktakingPeriodModel(
      id: d.id,
      branchId: d.branchId,
      name: decoded['n'] as String? ?? '',
      status: decoded['st'] as String? ?? d.status,
      totalItems: (decoded['ti'] as num?)?.toInt() ?? 0,
      countedItems: (decoded['ci'] as num?)?.toInt() ?? 0,
      totalDifference: (decoded['td'] as num?)?.toDouble() ?? 0,
      startedAt: d.startDate,
      closedAt: d.endDate,
      notes: decoded['notes'] as String?,
      createdBy: d.createdBy,
      syncVersion: d.syncVersion,
      lastModified: d.lastModified,
      isDeleted: d.isDeleted,
    );
  }

  StocktakingTableCompanion _toPeriodCompanion(StocktakingPeriodModel m) {
    final extra = <String, dynamic>{
      'n': m.name,
      'st': m.status,
      'ti': m.totalItems,
      'ci': m.countedItems,
      'td': m.totalDifference,
    };
    if (m.notes != null) extra['notes'] = m.notes;
    return StocktakingTableCompanion(
      id: Value(m.id),
      branchId: Value(m.branchId),
      startDate: Value(m.startedAt),
      endDate: Value(m.closedAt),
      status: Value(m.status),
      notes: Value(jsonEncode(extra)),
      createdBy: Value(m.createdBy),
      syncVersion: Value(m.syncVersion),
      lastModified: Value(m.lastModified),
      isDeleted: Value(m.isDeleted),
    );
  }

  StocktakingCountModel _itemFromData(StocktakingItemsTableData d) {
    final extra = _decodeItemNotes(d.notes);
    return StocktakingCountModel(
      id: d.id,
      periodId: d.stocktakingId,
      itemId: d.medicineId,
      itemName: d.medicineName,
      sku: extra['s'] as String?,
      unit: extra['u'] as String? ?? 'وحدة',
      systemQuantity: d.systemQuantity,
      actualQuantity: d.countedQuantity,
      difference: d.difference,
      buyPrice: (extra['bp'] as num?)?.toDouble() ?? 0,
      differenceValue: (extra['dv'] as num?)?.toDouble() ?? (d.difference * ((extra['bp'] as num?)?.toDouble() ?? 0)),
      notes: extra['notes'] as String?,
      createdBy: extra['cb'] as String? ?? '',
      createdAt: extra['ca'] != null ? DateTime.fromMillisecondsSinceEpoch(extra['ca'] as int) : d.lastModified,
      updatedAt: extra['ua'] != null ? DateTime.fromMillisecondsSinceEpoch(extra['ua'] as int) : d.lastModified,
      syncVersion: d.syncVersion,
      lastModified: d.lastModified,
      isDeleted: d.isDeleted,
    );
  }

  Map<String, dynamic> _decodePeriodNotes(String? notes) {
    if (notes == null || notes.isEmpty) return {};
    try {
      final decoded = jsonDecode(notes);
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
    } catch (_) {}
    return {};
  }

  Map<String, dynamic> _decodeItemNotes(String? notes) {
    if (notes == null || notes.isEmpty) return {};
    try {
      final decoded = jsonDecode(notes);
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
    } catch (_) {}
    return {};
  }
}

