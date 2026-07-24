import 'dart:async';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/core/data/database/daos/damaged_stock_dao.dart';
import 'package:pharmacy_system/app/core/data/database/daos/inventory_dao.dart';
import 'package:pharmacy_system/app/core/models/inventory/damaged_stock_model.dart';
import 'package:pharmacy_system/app/core/injection.dart';
import 'package:pharmacy_system/app/core/utils/app_utils.dart';

class DamagedStockService {
  static DamagedStockDao get _dao => sl<DamagedStockDao>();
  static InventoryDao get _medDao => sl<InventoryDao>();
  static final _uuid = const Uuid();

  static Future<List<DamagedStockModel>> getAll({String? branchId}) async {
    try {
      final items = branchId != null
          ? await _dao.getByBranch(branchId)
          : await _dao.getAll();
      return items.map(_toModel).toList();
    } catch (e, s) {
      safeDebugPrint('DamagedStockService.getAll failed: $e\n$s');
      return [];
    }
  }

  static Future<List<DamagedStockModel>> getByMedicine(String medicineId) async {
    try {
      final all = await getAll();
      return all.where((d) => d.medicineId == medicineId).toList();
    } catch (e, s) {
      safeDebugPrint('DamagedStockService.getByMedicine failed: $e\n$s');
      return [];
    }
  }

  static Future<DamagedStockModel> record({
    required String medicineId,
    required String medicineName,
    required int quantity,
    required String reason,
    String? notes,
    required String branchId,
    required String recordedBy,
  }) async {
    try {
      final damaged = DamagedStockModel(
        id: _uuid.v4(),
        medicineId: medicineId,
        medicineName: medicineName,
        quantity: quantity,
        reason: reason,
        notes: notes,
        branchId: branchId,
        recordedBy: recordedBy,
      );
      await _dao.upsert(_toCompanion(damaged));

      final medData = await _medDao.getById(medicineId);
      if (medData != null) {
        final newQty = (medData.quantity - quantity).clamp(0, double.infinity).toInt();
        await _medDao.upsert(MedicinesTableCompanion(
          id: Value(medData.id),
          quantity: Value(newQty),
          lastModified: Value(DateTime.now()),
        ));
      }

      return damaged;
    } catch (e, s) {
      safeDebugPrint('DamagedStockService.record failed: $e\n$s');
      rethrow;
    }
  }

  static Future<void> delete(String id) async {
    try {
      await _dao.delete(id);
    } catch (e, s) {
      safeDebugPrint('DamagedStockService.delete failed: $e\n$s');
      rethrow;
    }
  }

  static DamagedStockModel _toModel(DamagedStockTableData d) {
    return DamagedStockModel(
      id: d.id,
      medicineId: d.medicineId,
      medicineName: d.medicineName,
      quantity: d.quantity,
      reason: d.reason,
      notes: d.notes,
      branchId: d.branchId,
      recordedBy: d.recordedBy,
      recordedAt: d.recordedAt,
      lastModified: d.lastModified,
    );
  }

  static DamagedStockTableCompanion _toCompanion(DamagedStockModel m) {
    return DamagedStockTableCompanion(
      id: Value(m.id),
      medicineId: Value(m.medicineId),
      medicineName: Value(m.medicineName),
      quantity: Value(m.quantity),
      reason: Value(m.reason),
      notes: Value(m.notes),
      branchId: Value(m.branchId),
      recordedBy: Value(m.recordedBy),
      recordedAt: Value(m.recordedAt),
      lastModified: Value(m.lastModified),
    );
  }
}





