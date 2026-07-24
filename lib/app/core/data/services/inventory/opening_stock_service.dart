import 'dart:async';
import 'package:collection/collection.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/core/data/database/daos/opening_stock_dao.dart';
import 'package:pharmacy_system/app/core/models/inventory/opening_stock_model.dart';
import 'package:pharmacy_system/app/core/injection.dart';
import 'package:pharmacy_system/app/core/utils/app_utils.dart';

class OpeningStockService {
  static OpeningStockDao get _dao => sl<OpeningStockDao>();
  static final _uuid = const Uuid();

  static Future<List<OpeningStockModel>> getAll({String? branchId}) async {
    try {
      final items = branchId != null
          ? await _dao.getByBranch(branchId)
          : await _dao.getAll();
      return items.map(_toModel).toList();
    } catch (e, s) {
      safeDebugPrint('OpeningStockService.getAll failed: $e\n$s');
      return [];
    }
  }

  static Future<OpeningStockModel?> getByMedicine(String medicineId, String branchId) async {
    try {
      final all = await getAll(branchId: branchId);
      return all.firstWhereOrNull((o) => o.medicineId == medicineId);
    } catch (e, s) {
      safeDebugPrint('OpeningStockService.getByMedicine failed: $e\n$s');
      return null;
    }
  }

  static Future<OpeningStockModel> record({
    required String medicineId,
    required String medicineName,
    required int quantity,
    required double buyPrice,
    required String branchId,
    required String recordedBy,
  }) async {
    try {
      final existing = await getByMedicine(medicineId, branchId);
      if (existing != null) {
        final updated = existing.copyWith(
          quantity: quantity,
          buyPrice: buyPrice,
          lastModified: DateTime.now(),
        );
        await _dao.upsert(_toCompanion(updated));
        return updated;
      }

      final opening = OpeningStockModel(
        id: _uuid.v4(),
        medicineId: medicineId,
        medicineName: medicineName,
        quantity: quantity,
        buyPrice: buyPrice,
        branchId: branchId,
        recordedBy: recordedBy,
      );
      await _dao.upsert(_toCompanion(opening));
      return opening;
    } catch (e, s) {
      safeDebugPrint('OpeningStockService.record failed: $e\n$s');
      rethrow;
    }
  }

  static Future<void> delete(String id) async {
    try {
      await _dao.delete(id);
    } catch (e, s) {
      safeDebugPrint('OpeningStockService.delete failed: $e\n$s');
      rethrow;
    }
  }

  static OpeningStockModel _toModel(OpeningStockTableData d) {
    return OpeningStockModel(
      id: d.id,
      medicineId: d.medicineId,
      medicineName: d.medicineName,
      quantity: d.quantity,
      buyPrice: d.buyPrice,
      branchId: d.branchId,
      recordedBy: d.recordedBy,
      recordedAt: d.recordedAt,
      lastModified: d.lastModified,
    );
  }

  static OpeningStockTableCompanion _toCompanion(OpeningStockModel m) {
    return OpeningStockTableCompanion(
      id: Value(m.id),
      medicineId: Value(m.medicineId),
      medicineName: Value(m.medicineName),
      quantity: Value(m.quantity),
      buyPrice: Value(m.buyPrice),
      branchId: Value(m.branchId),
      recordedBy: Value(m.recordedBy),
      recordedAt: Value(m.recordedAt),
      lastModified: Value(m.lastModified),
    );
  }
}




