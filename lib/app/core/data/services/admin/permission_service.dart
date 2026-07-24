import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/core/data/database/drift_init.dart';
import 'package:pharmacy_system/app/shared/ui_core.dart';

class PermissionService {
  PermissionService._();

  static const List<String> defaultOwnerPermissions = [
    'dashboard',
    'pos',
    'sales',
    'purchases',
    'inventory',
    'medicines',
    'categories',
    'stock',
    'customers',
    'suppliers',
    'contacts',
    'reports',
    'settings',
    'admin_panel',
    'employees',
    'branches',
    'permissions',
    'create_invoice',
    'cancel_invoice',
    'refund',
    'adjust_stock',
    'delete_medicine',
    'manage_users',
    'manage_branches',
    'view_reports',
    'export_data',
    'manage_permissions',
    'cashier.use',
    'settings.read',
    'settings.write',
    'branches.write',
    'users.write',
    'roles.write',
    'activity.read',
    'sales.read',
    'purchases.read',
    'inventory.read',
    'contacts.read',
    'reports.read',
    'accounting.read',
  ];

  static Future<List<String>> getPermissionsForUser(String userId) async {
    try {
      final db = appDatabase;
      final list = await db.systemDao.getPermissionsByUser(userId);
      return list
          .where((p) => p.isAllowed && !p.isDeleted)
          .map((p) => p.permissionKey)
          .toList();
    } catch (e, s) {
      safeDebugPrint('PermissionService.getPermissionsForUser error: $e\n$s');
      return [];
    }
  }

  static Future<void> grantPermission(String userId, String permissionKey) async {
    try {
      final db = appDatabase;
      final existing = await db.systemDao.getPermissionsByUser(userId);
      final found = existing.where((p) => p.permissionKey == permissionKey).firstOrNull;

      if (found != null) {
        await db.systemDao.upsertPermission(PermissionsTableCompanion(
          id: Value(found.id),
          userId: Value(found.userId),
          permissionKey: Value(found.permissionKey),
          isAllowed: const Value(true),
          isDeleted: const Value(false),
          lastModified: Value(DateTime.now()),
          syncVersion: Value(found.syncVersion + 1),
        ));
      } else {
        await db.systemDao.upsertPermission(PermissionsTableCompanion(
          id: Value('perm_${const Uuid().v4()}'),
          userId: Value(userId),
          permissionKey: Value(permissionKey),
          isAllowed: const Value(true),
          isDeleted: const Value(false),
          createdAt: Value(DateTime.now()),
          lastModified: Value(DateTime.now()),
          syncVersion: const Value(1),
        ));
      }
    } catch (e, s) {
      safeDebugPrint('PermissionService.grantPermission error: $e\n$s');
    }
  }

  static Future<void> revokePermission(String userId, String permissionKey) async {
    try {
      final db = appDatabase;
      final existing = await db.systemDao.getPermissionsByUser(userId);
      final found = existing.where((p) => p.permissionKey == permissionKey).firstOrNull;

      if (found != null) {
        await db.systemDao.upsertPermission(PermissionsTableCompanion(
          id: Value(found.id),
          userId: Value(found.userId),
          permissionKey: Value(found.permissionKey),
          isAllowed: const Value(false),
          accountId: Value(found.accountId),
          createdAt: Value(found.createdAt),
          lastModified: Value(DateTime.now()),
          syncVersion: Value(found.syncVersion + 1),
        ));
      }
    } catch (e, s) {
      safeDebugPrint('PermissionService.revokePermission error: $e\n$s');
    }
  }
}
