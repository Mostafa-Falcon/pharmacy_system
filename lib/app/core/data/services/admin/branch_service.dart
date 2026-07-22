import 'package:get_it/get_it.dart';
import 'package:drift/drift.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/core/data/database/daos/branches_dao.dart';
import 'package:pharmacy_system/app/core/injection.dart';
import 'package:pharmacy_system/app/modules/auth/models/branch_model.dart';

/// [BranchService] - الخدمة الأساسية لإدارة وجلب الفروع المتاحة في النظام
/// مُصممة كـ Singleton ومتوافقة مع GetIt لتسهيل عملية حقن الاعتماديات.
class BranchService {
  static final BranchService _instance = BranchService._internal();
  factory BranchService() => _instance;
  BranchService._internal();

  BranchesDao get _dao => sl<BranchesDao>();

  /// الحصول على النسخة المشتركة من الخدمة عبر GetIt
  static BranchService get to => GetIt.instance<BranchService>();

  /// جلب كافة الفروع المخزنة محلياً في قاعدة البيانات
  Future<List<BranchModel>> getBranches() async {
    final all = await _dao.getAll();
    return all.where((b) => !b.isDeleted).map(_toModel).toList();
  }

  Future<List<BranchModel>> getActiveBranches() async {
    final all = await _dao.getAll();
    return all
        .where((b) => b.isActive && !b.isDeleted)
        .map(_toModel)
        .toList();
  }

  Future<BranchModel?> getById(String id) async {
    final data = await _dao.getById(id);
    return data != null ? _toModel(data) : null;
  }

  Future<void> save(BranchModel branch) async {
    await _dao.upsert(_toCompanion(branch));
  }

  Future<void> softDelete(String id) async {
    await _dao.softDelete(id);
  }

  BranchModel _toModel(BranchesTableData d) {
    return BranchModel(
      id: d.id,
      name: d.name,
      address: d.address,
      phone: d.phone,
      isActive: d.isActive,
      createdAt: d.createdAt,
      syncVersion: d.syncVersion,
      lastModified: d.lastModified,
      isDeleted: d.isDeleted,
    );
  }

  BranchesTableCompanion _toCompanion(BranchModel m) {
    return BranchesTableCompanion(
      id: Value(m.id),
      name: Value(m.name),
      address: Value(m.address),
      phone: Value(m.phone),
      isActive: Value(m.isActive),
      createdAt: Value(m.createdAt),
      syncVersion: Value(m.syncVersion),
      lastModified: Value(m.lastModified),
      isDeleted: Value(m.isDeleted),
    );
  }
}

