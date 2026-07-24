import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

import 'package:pharmacy_system/app/core/data/database/daos/medicine_variants_dao.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/core/models/inventory/medicine_variant_model.dart';

class VariantService {
  static MedicineVariantsDao get _dao =>
      MedicineVariantsDao(GetIt.instance<AppDatabase>());
  static AppDatabase get _db => GetIt.instance<AppDatabase>();
  static const _uuid = Uuid();
  static List<MedicineVariantModel> _cache = [];

  static Future<void> refresh() async {
    final data = await _db.select(_db.medicineVariantsTable).get();
    _cache = data.map(_fromData).toList();
  }

  static MedicineVariantModel _fromData(MedicineVariantsTableData d) {
    return MedicineVariantModel(
      id: d.id,
      medicineId: d.medicineId,
      name: d.name,
      price: d.price,
      cost: d.cost,
      sku: d.sku,
      attributes: _parseAttributes(d.attributes),
    );
  }

  static MedicineVariantsTableCompanion _toCompanion(MedicineVariantModel m) {
    return MedicineVariantsTableCompanion(
      id: Value(m.id),
      medicineId: Value(m.medicineId),
      name: Value(m.name),
      price: Value(m.price),
      cost: Value(m.cost),
      sku: Value(m.sku),
      attributes: Value(_encodeAttributes(m.attributes)),
    );
  }

  static Map<String, String> _parseAttributes(String json) {
    if (json.isEmpty) return {};
    try {
      return (jsonDecode(json) as Map<String, dynamic>)
          .map((k, v) => MapEntry(k, v.toString()));
    } catch (_) {
      return {};
    }
  }

  static String _encodeAttributes(Map<String, String> map) {
    return jsonEncode(map);
  }

  static List<MedicineVariantModel> getByMedicine(String medicineId) {
    return _cache
        .where((v) => v.medicineId == medicineId)
        .toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }

  static MedicineVariantModel? getById(String? id) {
    if (id == null) return null;
    try {
      return _cache.firstWhere((v) => v.id == id);
    } catch (_) {
      return null;
    }
  }

  static MedicineVariantModel? getBySku(String sku) {
    try {
      return _cache.firstWhere(
          (v) => v.sku.toLowerCase() == sku.toLowerCase().trim());
    } catch (_) {
      return null;
    }
  }

  static bool skuExists(String sku, {String? excludeId}) {
    return _cache.any((v) =>
        v.sku.toLowerCase() == sku.toLowerCase().trim() &&
        v.id != excludeId);
  }

  static Future<MedicineVariantModel> add({
    required String medicineId,
    required String name,
    required String sku,
    required double price,
    required double cost,
    Map<String, String>? attributes,
  }) async {
    final variant = MedicineVariantModel(
      id: _uuid.v4(),
      medicineId: medicineId,
      name: name,
      sku: sku,
      price: price,
      cost: cost,
      attributes: attributes ?? {},
    );
    _cache.add(variant);
    await _dao.upsert(_toCompanion(variant));
    return variant;
  }

  static Future<void> update(MedicineVariantModel variant) async {
    final idx = _cache.indexWhere((v) => v.id == variant.id);
    if (idx != -1) _cache[idx] = variant;
    await _dao.upsert(_toCompanion(variant));
  }

  static Future<void> delete(String id) async {
    _cache.removeWhere((v) => v.id == id);
    await _dao.delete(id);
  }

  static Future<void> deleteByMedicine(String medicineId) async {
    final toRemove = _cache.where((v) => v.medicineId == medicineId).toList();
    for (final v in toRemove) {
      _cache.removeWhere((x) => x.id == v.id);
      await _dao.delete(v.id);
    }
  }
}




