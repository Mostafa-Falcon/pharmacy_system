import 'dart:async';
import 'package:pharmacy_system/app/core/models/inventory/medicine_model.dart';
import 'package:pharmacy_system/app/core/data/repositories/medicines_repository.dart';
import 'package:pharmacy_system/app/core/injection.dart';
import 'package:pharmacy_system/app/core/sync/sync_service.dart';

/// Serializes stock mutations per medicine to prevent race conditions.
/// Uses a simple FIFO queue + in-flight flag per medicine ID.
class StockMutationService {
  static final Map<String, bool> _inFlight = {};
  static final Map<String, List<Function()>> _queues = {};

  static Future<T> _withLock<T>(
    String medicineId,
    Future<T> Function() action,
  ) async {
    if (_inFlight[medicineId] != true) {
      _inFlight[medicineId] = true;
      try {
        return await action();
      } finally {
        _inFlight[medicineId] = false;
        _processQueue(medicineId);
      }
    } else {
      final completer = Completer<T>();
      _queues.putIfAbsent(medicineId, () => []).add(() {
        action().then(completer.complete).catchError(completer.completeError);
      });
      return completer.future;
    }
  }

  static void _processQueue(String medicineId) {
    final queue = _queues[medicineId];
    if (queue == null || queue.isEmpty) return;
    final next = queue.removeAt(0);
    if (queue.isEmpty) _queues.remove(medicineId);
    _inFlight[medicineId] = true;
    next().whenComplete(() {
      _inFlight[medicineId] = false;
      _processQueue(medicineId);
    });
  }

  /// ????? ???? ?????? (????? ??????? ??????????)
  static Future<void> adjustStock({
    required String medicineId,
    required int delta,
    required String branchId,
  }) async {
    final repo = sl<MedicinesRepository>();
    await _withLock(medicineId, () async {
      final medicine = await repo.getByIdAsync(medicineId);
      if (medicine == null) return;

      final newQty = medicine.quantity + delta;
      if (newQty < 0 && !medicine.allowNegativeStock) {
        throw StateError('Insufficient stock for $medicineId');
      }
      final clamped = newQty.clamp(0, 1 << 30);

      final updatedMedicine = medicine.copyWith(
        quantity: clamped,
        lastModified: DateTime.now(),
      );

      await repo.update(updatedMedicine, branchId: branchId);

      // ????? ???????? ?????? ???????? ?????? ??? UI ??????
      SyncService.onTableUpdated?.call('medicines', branchId);

      _queueStockUpdate(updatedMedicine, branchId);
    });
  }

  /// ??? ???? ?????? ??????
  static Future<void> setStock({
    required String medicineId,
    required int quantity,
    required String branchId,
  }) async {
    final repo = sl<MedicinesRepository>();
    await _withLock(medicineId, () async {
      final medicine = await repo.getByIdAsync(medicineId);
      if (medicine == null) return;

      final newQty = quantity.clamp(0, 1 << 30);

      final updatedMedicine = medicine.copyWith(
        quantity: newQty,
        lastModified: DateTime.now(),
      );

      await repo.update(updatedMedicine, branchId: branchId);

      // ????? ???????? ?????? ???????? ?????? ??? UI ??????
      SyncService.onTableUpdated?.call('medicines', branchId);

      // ????? ????????
      _queueStockUpdate(updatedMedicine, branchId);
    });
  }

  /// ????? ??????? ???????? ??? ???? ??? queue ??????? ?? SyncService.
  /// ?? ?????: dedupe ???? id (??? ?????? ?????? ??? ????? ?? ??????)?
  /// retry ?????? ?? backoff? ???? ?? batch upsert ??? ????? — ??? ?????.
  static Future<void> _queueStockUpdate(MedicineModel medicine, String branchId) async {
    final data = Map<String, dynamic>.from(medicine.toJson());
    data['last_modified'] = DateTime.now().toIso8601String();

    await SyncService.update(
      boxName: 'medicines',
      entity: medicine,
      branchId: branchId,
      toJson: data,
    );
  }
}





