import 'package:drift/drift.dart';
import 'package:get_it/get_it.dart';

import 'package:pharmacy_system/app/core/data/database/daos/inventory_transactions_dao.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/modules/inventory/models/inventory_enums.dart';
import 'package:pharmacy_system/app/modules/inventory/models/stock_adjustment_model.dart';
import 'package:pharmacy_system/app/modules/inventory/models/stock_movement_model.dart';
import 'package:pharmacy_system/app/modules/inventory/models/stock_transfer_model.dart';

class InventoryTransactionService {
  static final InventoryTransactionService _instance =
      InventoryTransactionService._internal();
  factory InventoryTransactionService() => _instance;
  InventoryTransactionService._internal();

  static InventoryTransactionService get to =>
      GetIt.instance<InventoryTransactionService>();

  static InventoryTransactionsDao get _dao =>
      InventoryTransactionsDao(GetIt.instance<AppDatabase>());
  static List<StockMovementModel> _cache = [];

  static Future<void> refresh() async {
    final data = await _dao.getAll();
    _cache = data.map(_movementFromData).toList();
  }

  static StockMovementModel _movementFromData(InventoryTransactionsTableData d) {
    return StockMovementModel(
      id: d.id,
      operationId: '${d.referenceType}:${d.referenceId}',
      pharmacyId: d.branchId,
      branchId: d.branchId,
      medicineId: d.medicineId,
      medicineName: d.medicineName,
      batchId: d.batchId,
      unitId: d.unitId,
      type: _parseMovementType(d.type),
      quantity: d.quantity,
      unitCost: d.unitCost,
      beforeQuantity: d.beforeQuantity,
      afterQuantity: d.afterQuantity,
      referenceType: d.referenceType,
      referenceId: d.referenceId,
      actorId: d.actorId,
      occurredAt: d.occurredAt,
    );
  }

  static MovementType _parseMovementType(String type) {
    return MovementType.values.firstWhere(
      (e) => e.name == type,
      orElse: () => MovementType.adjustmentIncrease,
    );
  }

  static String _movementTypeToJson(MovementType type) => type.name;

  static InventoryTransactionsTableCompanion _movementToCompanion(
      StockMovementModel m) {
    return InventoryTransactionsTableCompanion(
      id: Value(m.id),
      branchId: Value(m.branchId),
      medicineId: Value(m.medicineId),
      medicineName: Value(m.medicineName),
      batchId: Value(m.batchId),
      unitId: Value(m.unitId),
      type: Value(_movementTypeToJson(m.type)),
      quantity: Value(m.quantity),
      unitCost: Value(m.unitCost),
      beforeQuantity: Value(m.beforeQuantity),
      afterQuantity: Value(m.afterQuantity),
      referenceType: Value(m.referenceType),
      referenceId: Value(m.referenceId),
      actorId: Value(m.actorId),
      occurredAt: Value(m.occurredAt),
    );
  }

  Future<void> init() async {
    await refresh();
  }

  Future<void> recordMovement(StockMovementModel movement) async {
    _cache.insert(0, movement);
    await _dao.upsert(_movementToCompanion(movement));
  }

  List<StockMovementModel> getMovements({
    String? branchId,
    String? medicineId,
    int limit = 100,
  }) {
    var all = _cache.toList();
    if (branchId != null) {
      all = all.where((m) => m.branchId == branchId).toList();
    }
    if (medicineId != null) {
      all = all.where((m) => m.medicineId == medicineId).toList();
    }
    all.sort((a, b) => b.occurredAt.compareTo(a.occurredAt));
    if (all.length > limit) all = all.sublist(0, limit);
    return all;
  }

  Future<void> adjustStock({
    required StockAdjustmentModel adjustment,
    required String actorId,
  }) async {
    for (final line in adjustment.items) {
      final movement = StockMovementModel(
        id: 'mov_${line.id}',
        operationId: 'adjustment:${adjustment.id}',
        pharmacyId: adjustment.pharmacyId,
        branchId: adjustment.branchId,
        medicineId: line.itemId,
        medicineName: line.itemName,
        batchId: line.batchId,
        unitId: line.unitId,
        type: line.type == AdjustmentType.addition
            ? MovementType.adjustmentIncrease
            : MovementType.adjustmentDecrease,
        quantity: line.type == AdjustmentType.reduction
            ? -line.quantity
            : line.quantity,
        unitCost: line.unitCost ?? 0,
        referenceType: 'stock_adjustment',
        referenceId: adjustment.id,
        actorId: actorId,
        occurredAt: DateTime.now().toUtc(),
      );
      await recordMovement(movement);
    }
  }

  Future<void> transferStock({
    required StockTransferModel transfer,
    required String actorId,
  }) async {
    for (final line in transfer.items) {
      final outMovement = StockMovementModel(
        id: 'mov_out_${line.medicineId}_${DateTime.now().millisecondsSinceEpoch}',
        operationId: 'transfer:${transfer.id}',
        pharmacyId: transfer.branchId.isNotEmpty ? transfer.branchId : '',
        branchId: transfer.fromBranchId,
        medicineId: line.medicineId,
        medicineName: line.medicineName,
        batchId: line.batchId,
        type: MovementType.transferOut,
        quantity: -line.quantity.toDouble(),
        unitCost: line.unitCost,
        referenceType: 'stock_transfer',
        referenceId: transfer.id,
        actorId: actorId,
        occurredAt: DateTime.now().toUtc(),
      );
      await recordMovement(outMovement);

      final inMovement = StockMovementModel(
        id: 'mov_in_${line.medicineId}_${DateTime.now().millisecondsSinceEpoch}',
        operationId: 'transfer:${transfer.id}',
        pharmacyId: transfer.branchId.isNotEmpty ? transfer.branchId : '',
        branchId: transfer.toBranchId,
        medicineId: line.medicineId,
        medicineName: line.medicineName,
        batchId: line.batchId,
        type: MovementType.transferIn,
        quantity: line.quantity.toDouble(),
        unitCost: line.unitCost,
        referenceType: 'stock_transfer',
        referenceId: transfer.id,
        actorId: actorId,
        occurredAt: DateTime.now().toUtc(),
      );
      await recordMovement(inMovement);
    }
  }
}

