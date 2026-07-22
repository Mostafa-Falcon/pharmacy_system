import 'dart:async';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/core/data/database/daos/promotions_dao.dart';
import 'package:pharmacy_system/app/modules/inventory/models/promotion_model.dart';
import '../auth/auth_service.dart';
import 'package:pharmacy_system/app/core/injection.dart';
import 'package:pharmacy_system/app/core/utils/app_utils.dart';

class PromotionService {
  static PromotionsDao get _dao => sl<PromotionsDao>();
  static final _uuid = const Uuid();

  static Future<List<PromotionModel>> getAll({String? branchId}) async {
    try {
      final items = branchId != null
          ? await _dao.getByBranch(branchId)
          : await _dao.getAll();
      return items.map(_toModel).toList();
    } catch (e, s) {
      safeDebugPrint('PromotionService.getAll failed: $e\n$s');
      return [];
    }
  }

  static Future<List<PromotionModel>> getActive({String? branchId}) async {
    try {
      final bid = branchId ?? AuthService.currentBranchId ?? '';
      final items = await _dao.getActive(bid);
      return items.map(_toModel).toList();
    } catch (e, s) {
      safeDebugPrint('PromotionService.getActive failed: $e\n$s');
      return [];
    }
  }

  static Future<PromotionModel?> getById(String id) async {
    try {
      final data = await _dao.getById(id);
      return data != null ? _toModel(data) : null;
    } catch (e, s) {
      safeDebugPrint('PromotionService.getById failed: $e\n$s');
      return null;
    }
  }

  static Future<PromotionModel> create(PromotionModel promotion) async {
    try {
      final branchId = AuthService.currentBranchId ?? '';
      final newPromotion = promotion.copyWith(
        id: _uuid.v4(),
        branchId: branchId,
        lastModified: DateTime.now(),
      );
      await _dao.upsert(_toCompanion(newPromotion));
      return newPromotion;
    } catch (e, s) {
      safeDebugPrint('PromotionService.create failed: $e\n$s');
      rethrow;
    }
  }

  static Future<PromotionModel> update(PromotionModel promotion) async {
    try {
      final updated = promotion.copyWith(lastModified: DateTime.now());
      await _dao.upsert(_toCompanion(updated));
      return updated;
    } catch (e, s) {
      safeDebugPrint('PromotionService.update failed: $e\n$s');
      rethrow;
    }
  }

  static Future<void> delete(String id) async {
    try {
      await _dao.delete(id);
    } catch (e, s) {
      safeDebugPrint('PromotionService.delete failed: $e\n$s');
      rethrow;
    }
  }

  static Future<void> toggleActive(String id, bool isActive) async {
    try {
      final data = await _dao.getById(id);
      if (data != null) {
        final model = _toModel(data);
        final updated = model.copyWith(isActive: isActive, lastModified: DateTime.now());
        await _dao.upsert(_toCompanion(updated));
      }
    } catch (e, s) {
      safeDebugPrint('PromotionService.toggleActive failed: $e\n$s');
      rethrow;
    }
  }

  static Future<List<PromotionModel>> getForMedicine(String medicineId, String? category, String? customerGroupId, {String? branchId}) async {
    try {
      final active = await getActive(branchId: branchId);
      return active.where((p) => p.appliesToMedicine(medicineId, category, customerGroupId)).toList();
    } catch (e, s) {
      safeDebugPrint('PromotionService.getForMedicine failed: $e\n$s');
      return [];
    }
  }

  static Future<PromotionModel?> getBestForMedicine(String medicineId, String? category, String? customerGroupId, {String? branchId}) async {
    try {
      final applicable = await getForMedicine(medicineId, category, customerGroupId, branchId: branchId);
      if (applicable.isEmpty) return null;
      applicable.sort((a, b) {
        final aDiscount = a.isPercentage ? a.value : (a.value / 100);
        final bDiscount = b.isPercentage ? b.value : (b.value / 100);
        return bDiscount.compareTo(aDiscount);
      });
      return applicable.first;
    } catch (e, s) {
      safeDebugPrint('PromotionService.getBestForMedicine failed: $e\n$s');
      return null;
    }
  }

  static PromotionModel _toModel(PromotionsTableData d) {
    return PromotionModel(
      id: d.id,
      name: d.name,
      description: d.description,
      type: PromotionType.values.firstWhere(
        (e) => e.name == d.type,
        orElse: () => PromotionType.discount,
      ),
      value: d.value,
      isPercentage: d.isPercentage,
      startDate: d.startDate,
      endDate: d.endDate,
      medicineIds: _decodeList(d.medicineIds),
      categoryFilters: _decodeList(d.categoryFilters),
      customerGroupId: d.customerGroupId,
      branchId: d.branchId,
      isActive: d.isActive,
      lastModified: d.lastModified,
    );
  }

  static PromotionsTableCompanion _toCompanion(PromotionModel m) {
    return PromotionsTableCompanion(
      id: Value(m.id),
      name: Value(m.name),
      description: Value(m.description),
      type: Value(m.type.name),
      value: Value(m.value),
      isPercentage: Value(m.isPercentage),
      startDate: Value(m.startDate),
      endDate: Value(m.endDate),
      medicineIds: Value(_encodeList(m.medicineIds)),
      categoryFilters: Value(_encodeList(m.categoryFilters)),
      customerGroupId: Value(m.customerGroupId),
      branchId: Value(m.branchId),
      isActive: Value(m.isActive),
      lastModified: Value(m.lastModified),
    );
  }

  static List<String> _decodeList(String json) {
    if (json.isEmpty) return [];
    return json.split(',').where((s) => s.isNotEmpty).toList();
  }

  static String _encodeList(List<String> list) {
    return list.join(',');
  }
}

