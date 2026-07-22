import 'package:drift/drift.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

import 'package:pharmacy_system/app/core/data/database/daos/medicine_brands_dao.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/modules/inventory/models/medicine_brand_model.dart';

class BrandService {
  static MedicineBrandsDao get _dao =>
      MedicineBrandsDao(GetIt.instance<AppDatabase>());
  static const _uuid = Uuid();
  static List<MedicineBrandModel> _cache = [];

  static Future<void> refresh() async {
    final data = await _dao.getAll();
    _cache = data.map(_fromData).toList();
  }

  static MedicineBrandModel _fromData(MedicineBrandsTableData d) {
    return MedicineBrandModel(
      id: d.id,
      name: d.name,
      description: d.description,
      logo: d.logo,
      createdAt: d.createdAt,
    );
  }

  static MedicineBrandsTableCompanion _toCompanion(MedicineBrandModel m) {
    return MedicineBrandsTableCompanion(
      id: Value(m.id),
      name: Value(m.name),
      description: Value(m.description),
      logo: Value(m.logo),
      createdAt: Value(m.createdAt),
    );
  }

  static List<MedicineBrandModel> getAll() {
    return List.unmodifiable(_cache);
  }

  static MedicineBrandModel? getById(String? id) {
    if (id == null) return null;
    try {
      return _cache.firstWhere((b) => b.id == id);
    } catch (_) {
      return null;
    }
  }

  static Future<MedicineBrandModel> add({
    required String name,
    String? description,
    String? logo,
  }) async {
    final brand = MedicineBrandModel(
      id: _uuid.v4(),
      name: name,
      description: description,
      logo: logo,
      createdAt: DateTime.now(),
    );
    _cache.add(brand);
    await _dao.upsert(_toCompanion(brand));
    return brand;
  }

  static Future<void> update(MedicineBrandModel brand) async {
    final idx = _cache.indexWhere((b) => b.id == brand.id);
    if (idx != -1) _cache[idx] = brand;
    await _dao.upsert(_toCompanion(brand));
  }

  static Future<void> delete(String id) async {
    _cache.removeWhere((b) => b.id == id);
    await _dao.delete(id);
  }

  static bool nameExists(String name, {String? excludeId}) {
    return _cache.any((b) =>
        b.name.toLowerCase() == name.toLowerCase().trim() &&
        b.id != excludeId);
  }
}

