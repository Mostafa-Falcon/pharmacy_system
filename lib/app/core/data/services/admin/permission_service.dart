import 'package:drift/drift.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/core/data/database/daos/permissions_dao.dart';
import 'package:pharmacy_system/app/core/injection.dart';
import 'package:pharmacy_system/app/modules/auth/models/permission_model.dart';
import 'package:pharmacy_system/app/core/utils/app_utils.dart';
import '../auth/auth_service.dart';

class PermissionService {
  static PermissionsDao get _dao => sl<PermissionsDao>();

  static const List<String> defaultOwnerPermissions = [
    'dashboard', 'pos', 'inventory', 'medicines', 'categories', 'stock',
    'customers', 'suppliers', 'reports', 'settings',
    'admin_panel', 'employees', 'branches', 'permissions',
    'create_invoice', 'cancel_invoice', 'refund', 'adjust_stock',
    'delete_medicine', 'manage_users', 'manage_branches',
    'view_reports', 'export_data', 'manage_permissions',
  ];

  static const List<String> defaultEmployeePermissions = [
    'dashboard', 'pos', 'customers',
    'create_invoice', 'refund',
  ];

  static List<PermissionModel> _cache = [];

  static List<PermissionModel> _cached() => List.unmodifiable(_cache);

  static void _updateCache(List<PermissionModel> items) {
    _cache = items;
  }

  static Future<void> _refreshCache() async {
    final all = await _dao.getAll();
    _updateCache(all.map(_toModel).toList());
  }

  static Future<void> grantPermission(String userId, String permissionKey) async {
    try {
      await _refreshCache();

      PermissionModel? existing;
      try {
        existing = _cache.firstWhere(
          (p) => p.userId == userId && p.permissionKey == permissionKey,
        );
      } catch (_) {
        existing = null;
      }

      if (existing != null) {
        final perm = existing;
        perm.isAllowed = true;
        await _dao.upsert(_toCompanion(perm));
        final idx = _cache.indexWhere((p) => p.id == perm.id);
        if (idx != -1) _cache[idx] = perm;
      } else {
        final permission = PermissionModel(
          id: '${userId}_$permissionKey',
          userId: userId,
          permissionKey: permissionKey,
          isAllowed: true,
          createdAt: DateTime.now(),
        );
        await _dao.upsert(_toCompanion(permission));
        _cache.add(permission);
      }
    } catch (e, s) {
      safeDebugPrint('PermissionService.grantPermission failed: $e\n$s');
      rethrow;
    }
  }

  static Future<void> revokePermission(String userId, String permissionKey) async {
    try {
      await _refreshCache();

      PermissionModel? existing;
      try {
        existing = _cache.firstWhere(
          (p) => p.userId == userId && p.permissionKey == permissionKey,
        );
      } catch (_) {
        existing = null;
      }

      if (existing != null) {
        final perm = existing;
        perm.isAllowed = false;
        await _dao.upsert(_toCompanion(perm));
        final idx = _cache.indexWhere((p) => p.id == perm.id);
        if (idx != -1) _cache[idx] = perm;
      }
    } catch (e, s) {
      safeDebugPrint('PermissionService.revokePermission failed: $e\n$s');
      rethrow;
    }
  }

  static Future<void> setPermissions(String userId, List<String> permissions) async {
    try {
      await _refreshCache();

      final existing = _cache.where((p) => p.userId == userId).toList();
      for (final p in existing) {
        await _dao.softDelete(p.id);
      }
      _cache.removeWhere((p) => p.userId == userId);

      final now = DateTime.now();
      for (final perm in permissions) {
        final permission = PermissionModel(
          id: '${userId}_$perm',
          userId: userId,
          permissionKey: perm,
          isAllowed: true,
          createdAt: now,
        );
        await _dao.upsert(_toCompanion(permission));
        _cache.add(permission);
      }
    } catch (e, s) {
      safeDebugPrint('PermissionService.setPermissions failed: $e\n$s');
      rethrow;
    }
  }

  static List<String> getPermissionsForUser(String userId) {
    try {
      return _cached()
          .where((p) => p.userId == userId && p.isAllowed)
          .map((p) => p.permissionKey)
          .toList();
    } catch (e, s) {
      safeDebugPrint('PermissionService.getPermissionsForUser failed: $e\n$s');
      return [];
    }
  }

  static bool hasPermission(String permissionKey) {
    try {
      final user = AuthService.currentUser;
      if (user == null) return false;
      if (user.isOwner) return true;

      final permissions = getPermissionsForUser(user.id);
      return permissions.contains(permissionKey);
    } catch (e, s) {
      safeDebugPrint('PermissionService.hasPermission failed: $e\n$s');
      return false;
    }
  }

  static bool hasPageAccess(String page) {
    return hasPermission(page);
  }

  static bool hasActionPermission(String action) {
    return hasPermission(action);
  }

  static PermissionModel _toModel(PermissionsTableData d) {
    return PermissionModel(
      id: d.id,
      userId: d.userId,
      permissionKey: d.permissionKey,
      isAllowed: d.isAllowed,
      createdAt: d.createdAt,
      syncVersion: d.syncVersion,
      isDeleted: d.isDeleted,
      lastModified: d.lastModified,
    );
  }

  static PermissionsTableCompanion _toCompanion(PermissionModel m) {
    return PermissionsTableCompanion(
      id: Value(m.id),
      userId: Value(m.userId),
      permissionKey: Value(m.permissionKey),
      isAllowed: Value(m.isAllowed),
      createdAt: Value(m.createdAt),
      syncVersion: Value(m.syncVersion),
      isDeleted: Value(m.isDeleted),
      lastModified: Value(m.lastModified),
    );
  }
}

