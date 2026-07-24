import 'package:uuid/uuid.dart';
import 'package:pharmacy_system/app/core/models/contacts/supplier_model.dart';
import 'package:pharmacy_system/app/core/data/repositories/suppliers_repository.dart';
import 'package:pharmacy_system/app/core/injection.dart';
import 'package:pharmacy_system/app/core/utils/app_utils.dart';

class SupplierService {
  static SuppliersRepository get _repo => sl<SuppliersRepository>();
  static const _uuid = Uuid();

  static Future<void> init() async {
  }

  static List<SupplierModel> getAll({bool activeOnly = true}) {
    final items = _repo.getSuppliersSync().toList();
    if (activeOnly) {
      return items.where((s) => s.isActive).toList();
    }
    return items;
  }

  static SupplierModel? getById(String? id) {
    if (id == null) return null;
    return _repo.getById(id);
  }

  static String? getNameById(String? id) {
    return getById(id)?.name;
  }

  static Future<SupplierModel> add({
    required String name,
    SupplierPartyType partyType = SupplierPartyType.company,
    String? phone,
    String? address,
    String? companyName,
    String? email,
    String? taxId,
    double creditLimit = 0,
    double discountPercent = 0,
    int paymentTermDays = 0,
    String? notes,
  }) async {
    try {
      final supplier = SupplierModel(
        id: _uuid.v4(),
        name: name,
        partyType: partyType,
        phone: phone,
        address: address,
        companyName: companyName,
        email: email,
        taxId: taxId,
        creditLimit: creditLimit,
        discountPercent: discountPercent,
        paymentTermDays: paymentTermDays,
        notes: notes,
      );
      supplier.lastModified = DateTime.now();
      await _repo.create(supplier);
      return supplier;
    } catch (e, s) {
      safeDebugPrint('SupplierService.add failed: $e\n$s');
      rethrow;
    }
  }

  static Future<void> update(SupplierModel supplier) async {
    try {
      supplier.lastModified = DateTime.now();
      await _repo.update(supplier);
    } catch (e, s) {
      safeDebugPrint('SupplierService.update failed: $e\n$s');
      rethrow;
    }
  }

  static Future<void> deactivate(String id) async {
    try {
      final supplier = getById(id);
      if (supplier != null) {
        await update(supplier.copyWith(isActive: false));
      }
    } catch (e, s) {
      safeDebugPrint('SupplierService.deactivate failed: $e\n$s');
      rethrow;
    }
  }

  static Future<void> activate(String id) async {
    try {
      final supplier = getById(id);
      if (supplier != null) {
        await update(supplier.copyWith(isActive: true));
      }
    } catch (e, s) {
      safeDebugPrint('SupplierService.activate failed: $e\n$s');
      rethrow;
    }
  }

  static Future<void> delete(String id) async {
    try {
      final supplier = getById(id);
      if (supplier != null) {
        await _repo.delete(supplier);
      }
    } catch (e, s) {
      safeDebugPrint('SupplierService.delete failed: $e\n$s');
      rethrow;
    }
  }

  static bool nameExists(String name, {String? excludeId}) {
    final all = _repo.getSuppliersSync();
    return all.any((s) =>
        s.name.toLowerCase() == name.toLowerCase().trim() &&
        s.id != excludeId
    );
  }
}




