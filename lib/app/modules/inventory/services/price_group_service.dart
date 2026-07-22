import 'package:drift/drift.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

import 'package:pharmacy_system/app/core/data/database/daos/price_groups_dao.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/modules/inventory/models/price_group_model.dart';

class PriceGroupService {
  static PriceGroupsDao get _dao =>
      PriceGroupsDao(GetIt.instance<AppDatabase>());
  static const _uuid = Uuid();
  static List<PriceGroupModel> _cache = [];

  static Future<void> refresh() async {
    final data = await _dao.getAll();
    _cache = data.map(_fromData).toList();
  }

  static PriceGroupModel _fromData(PriceGroupsTableData d) {
    return PriceGroupModel(
      id: d.id,
      name: d.name,
      markupPercentage: d.markupPercentage,
      discountPercentage: d.discountPercentage,
      isDefault: d.isDefault,
    );
  }

  static PriceGroupsTableCompanion _toCompanion(PriceGroupModel m) {
    return PriceGroupsTableCompanion(
      id: Value(m.id),
      name: Value(m.name),
      markupPercentage: Value(m.markupPercentage),
      discountPercentage: Value(m.discountPercentage),
      isDefault: Value(m.isDefault),
    );
  }

  static List<PriceGroupModel> getAll() {
    return List.unmodifiable(_cache);
  }

  static PriceGroupModel? getById(String? id) {
    if (id == null) return null;
    try {
      return _cache.firstWhere((g) => g.id == id);
    } catch (_) {
      return null;
    }
  }

  static PriceGroupModel? getDefault() {
    try {
      return _cache.firstWhere((g) => g.isDefault);
    } catch (_) {
      return null;
    }
  }

  static Future<PriceGroupModel> add({
    required String name,
    double markupPercentage = 0,
    double discountPercentage = 0,
    bool isDefault = false,
  }) async {
    if (isDefault) await _clearDefault();
    final group = PriceGroupModel(
      id: _uuid.v4(),
      name: name,
      markupPercentage: markupPercentage,
      discountPercentage: discountPercentage,
      isDefault: isDefault,
    );
    _cache.add(group);
    await _dao.upsert(_toCompanion(group));
    return group;
  }

  static Future<void> update(PriceGroupModel group) async {
    if (group.isDefault) await _clearDefault(excludeId: group.id);
    final idx = _cache.indexWhere((g) => g.id == group.id);
    if (idx != -1) _cache[idx] = group;
    await _dao.upsert(_toCompanion(group));
  }

  static Future<void> delete(String id) async {
    _cache.removeWhere((g) => g.id == id);
    await _dao.delete(id);
  }

  static Future<void> _clearDefault({String? excludeId}) async {
    for (final g in _cache) {
      if (g.id == excludeId || !g.isDefault) continue;
      final updated = g.copyWith(isDefault: false);
      final idx = _cache.indexWhere((x) => x.id == g.id);
      if (idx != -1) _cache[idx] = updated;
      await _dao.upsert(_toCompanion(updated));
    }
  }

  static bool nameExists(String name, {String? excludeId}) {
    return _cache.any((g) =>
        g.name.toLowerCase() == name.toLowerCase().trim() &&
        g.id != excludeId);
  }

  static double applyMarkup(double basePrice, String priceGroupId) {
    final group = getById(priceGroupId);
    if (group == null) return basePrice;
    final markedUp = basePrice * (1 + group.markupPercentage / 100);
    return markedUp * (1 - group.discountPercentage / 100);
  }
}

