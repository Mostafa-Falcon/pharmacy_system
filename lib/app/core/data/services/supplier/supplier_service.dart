import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/core/data/database/drift_init.dart';
import 'package:pharmacy_system/app/core/models/contacts/supplier_model.dart';
import 'package:pharmacy_system/app/shared/ui_core.dart';

class SupplierService {
  SupplierService._();
  static final SupplierService instance = SupplierService._();

  final List<SupplierModel> _cache = [];
  bool _loaded = false;

  static Future<void> init() async {
    await instance._loadCache();
  }

  static List<SupplierModel> getAll({bool activeOnly = true}) {
    if (!instance._loaded) return [];
    return instance._cache.where((s) {
      if (s.isDeleted) return false;
      if (activeOnly && !s.isActive) return false;
      return true;
    }).toList();
  }

  static SupplierModel? getById(String id) {
    if (!instance._loaded) return null;
    return instance._cache.where((s) => s.id == id && !s.isDeleted).firstOrNull;
  }

  static Future<SupplierModel> add({
    required String name,
    String? partyType,
    String? phone,
    String? address,
    String? email,
    String? contactPerson,
    String? taxId,
    String? companyName,
    double creditLimit = 0,
    double discountPercent = 0,
    int paymentTermDays = 0,
    String? notes,
    double openingBalance = 0,
    bool isSupplier = true,
  }) async {
    final model = SupplierModel(
      id: 'supplier_${const Uuid().v4()}',
      name: name,
      phone: phone,
      address: address,
      email: email,
      contactPerson: contactPerson,
      taxId: taxId,
      paymentTermDays: paymentTermDays,
      notes: notes,
      branchId: '',
    );
    try {
      final db = appDatabase;
      await db.contactsDao.upsertSupplier(SuppliersTableCompanion(
        id: Value(model.id),
        name: Value(model.name),
        phone: Value(model.phone),
        address: Value(model.address),
        email: Value(model.email),
        contactPerson: Value(model.contactPerson),
        taxId: Value(model.taxId),
        paymentTermDays: Value(model.paymentTermDays),
        isActive: Value(model.isActive),
        notes: Value(model.notes),
        branchId: Value(model.branchId),
        creditAmount: const Value(0.0),
        debitAmount: const Value(0.0),
        lastModified: Value(model.lastModified),
        isDeleted: const Value(false),
        syncVersion: const Value(1),
      ));
      instance._cache.add(model);
    } catch (e, s) {
      safeDebugPrint('SupplierService.add error: $e\n$s');
    }
    return model;
  }

  static Future<void> update(SupplierModel model) async {
    try {
      final db = appDatabase;
      await db.contactsDao.upsertSupplier(SuppliersTableCompanion(
        id: Value(model.id),
        name: Value(model.name),
        phone: Value(model.phone),
        address: Value(model.address),
        email: Value(model.email),
        contactPerson: Value(model.contactPerson),
        taxId: Value(model.taxId),
        creditAmount: Value(model.creditAmount),
        debitAmount: Value(model.debitAmount),
        paymentTermDays: Value(model.paymentTermDays),
        isActive: Value(model.isActive),
        notes: Value(model.notes),
        branchId: Value(model.branchId),
        lastModified: Value(DateTime.now()),
        isDeleted: Value(model.isDeleted),
        syncVersion: Value(model.syncVersion + 1),
      ));
      final idx = instance._cache.indexWhere((s) => s.id == model.id);
      if (idx != -1) {
        instance._cache[idx] = model;
      } else {
        instance._cache.add(model);
      }
    } catch (e, s) {
      safeDebugPrint('SupplierService.update error: $e\n$s');
    }
  }

  static Future<void> activate(String id) async {
    final model = getById(id);
    if (model != null) await update(model.copyWith(isActive: true));
  }

  static Future<void> deactivate(String id) async {
    final model = getById(id);
    if (model != null) await update(model.copyWith(isActive: false));
  }

  Future<void> _loadCache() async {
    if (_loaded) return;
    try {
      final db = appDatabase;
      final rows = await db.contactsDao.getAllSuppliers();
      _cache.clear();
      for (final r in rows) {
        _cache.add(SupplierModel(
          id: r.id,
          name: r.name,
          phone: r.phone,
          address: r.address,
          email: r.email,
          contactPerson: r.contactPerson,
          taxId: r.taxId,
          creditAmount: r.creditAmount,
          debitAmount: r.debitAmount,
          paymentTermDays: r.paymentTermDays,
          isActive: r.isActive,
          notes: r.notes,
          branchId: r.branchId,
          lastModified: r.lastModified,
          isDeleted: r.isDeleted,
          syncVersion: r.syncVersion,
        ));
      }
      _loaded = true;
    } catch (e, s) {
      safeDebugPrint('SupplierService._loadCache error: $e\n$s');
    }
  }
}
