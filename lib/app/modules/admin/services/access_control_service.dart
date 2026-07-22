import 'package:get_it/get_it.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';

class AccessControlService {
  static final AccessControlService _instance = AccessControlService._internal();
  factory AccessControlService() => _instance;
  AccessControlService._internal();

  static AccessControlService get to => GetIt.instance<AccessControlService>();

  bool can(String permission) {
    return AuthService.hasPermission(permission);
  }

  void require(String permission) {
    if (!can(permission)) {
      throw StateError('ليس لديك صلاحية: ${permission.replaceAll('.', ' ')}');
    }
  }

  bool canAny(List<String> permissions) {
    return permissions.any(can);
  }

  bool canAll(List<String> permissions) {
    return permissions.every(can);
  }

  bool get canReadSettings => can('settings.read');
  bool get canWriteSettings => can('settings.write');
  bool get canManageBranches => can('branches.write');
  bool get canManageUsers => can('users.write');
  bool get canManageRoles => can('roles.write');
  bool get canViewActivity => can('activity.read');
  bool get canUsePos => can('cashier.use');
  bool get canViewSales => can('sales.read');
  bool get canViewPurchases => can('purchases.read');
  bool get canViewInventory => can('inventory.read');
  bool get canViewContacts => can('contacts.read');
  bool get canViewReports => can('reports.read');
  bool get canViewAccounting => can('accounting.read');
}

