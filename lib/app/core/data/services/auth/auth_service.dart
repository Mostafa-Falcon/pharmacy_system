import 'dart:async';
import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:pharmacy_system/app/modules/auth/models/user_model.dart';
import 'package:pharmacy_system/app/modules/auth/models/branch_model.dart';
import 'package:pharmacy_system/app/core/data/database/daos/users_dao.dart';
import 'package:pharmacy_system/app/core/data/database/daos/branches_dao.dart';
import 'package:pharmacy_system/app/core/data/database/daos/permissions_dao.dart';
import 'package:pharmacy_system/app/core/data/database/daos/app_settings_dao.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/core/data/services/sync/sync_service.dart';
import 'password_hasher.dart';
import 'secure_storage_helper.dart';
import 'package:pharmacy_system/app/core/constants/app_strings.dart';
import 'package:pharmacy_system/app/core/utils/app_utils.dart';
import 'package:pharmacy_system/app/core/injection.dart';

part 'auth_session.dart';
part 'auth_device_lock.dart';
part 'auth_user_sync.dart';

class AuthService {
  static UserModel? _currentUser;
  static String? currentBranchId;
  static BranchModel? _currentBranch;
  static String? _currentDeviceId;
  static bool _initialized = false;

  static Timer? _loginThrottleTimer;
  static Timer? _registerThrottleTimer;
  static int _loginAttemptCount = 0;
  static int _registerAttemptCount = 0;
  static const int _maxAttempts = 5;
  static const Duration _throttleWindow = Duration(minutes: 1);

  static UserModel? get currentUser => _currentUser;
  static BranchModel? get currentBranch => _currentBranch;
  static String? get currentDeviceId => _currentDeviceId;
  static bool get isInitialized => _initialized;

  static Future<String?> _getDeviceId() async {
    final dao = sl<AppSettingsDao>();
    final result = await dao.get('device_id');
    var deviceId = result?.value;
    if (deviceId == null || deviceId.isEmpty) {
      deviceId = const Uuid().v4();
      await dao.set('device_id', deviceId);
    }
    return deviceId;
  }

  static bool _isLoginThrottled() {
    if (_loginThrottleTimer?.isActive ?? false) {
      _loginAttemptCount++;
      if (_loginAttemptCount >= _maxAttempts) {
        return true;
      }
    }
    return false;
  }

  static bool _isRegisterThrottled() {
    if (_registerThrottleTimer?.isActive ?? false) {
      _registerAttemptCount++;
      if (_registerAttemptCount >= _maxAttempts) {
        return true;
      }
    }
    return false;
  }

  static void _startLoginThrottle() {
    _loginAttemptCount = 0;
    _loginThrottleTimer?.cancel();
    _loginThrottleTimer = Timer(_throttleWindow, () {
      _loginThrottleTimer = null;
      _loginAttemptCount = 0;
    });
  }

  static void _startRegisterThrottle() {
    _registerAttemptCount = 0;
    _registerThrottleTimer?.cancel();
    _registerThrottleTimer = Timer(_throttleWindow, () {
      _registerThrottleTimer = null;
      _registerAttemptCount = 0;
    });
  }

  static Future<bool> _isOnline() async {
    return SyncService.isOnline;
  }

  static Future<void> init() => AuthSession.init();

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    if (_isLoginThrottled()) {
      return {
        'success': false,
        'message': AppStrings.tooManyAttempts,
      };
    }

    if (!await AuthService._isOnline()) {
      _startLoginThrottle();
      return {
        'success': false,
        'message': AppStrings.loginRequiresInternet,
      };
    }

    try {
      final result = await AuthSession.login(email: email, password: password);
      if (result['success'] == true) {
        _startLoginThrottle();
      } else {
        _startLoginThrottle();
      }
      return result;
    } catch (e) {
      _startLoginThrottle();
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required UserRole role,
    String? assignedBranchId,
  }) async {
    if (_isRegisterThrottled()) {
      return {
        'success': false,
        'message': AppStrings.tooManyAttempts,
      };
    }

    if (!await AuthService._isOnline()) {
      _startRegisterThrottle();
      return {
        'success': false,
        'message': AppStrings.registerRequiresInternet,
      };
    }

    try {
      final result = await AuthSession.register(
        name: name,
        email: email,
        password: password,
        role: role,
        assignedBranchId: assignedBranchId,
      );
      if (result['success'] == true) {
        _startRegisterThrottle();
      } else {
        _startRegisterThrottle();
      }
      return result;
    } catch (e) {
      _startRegisterThrottle();
      rethrow;
    }
  }

  static Future<void> logout() => AuthSession.logout();

  static Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) =>
      AuthSession.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

  static Future<void> selectBranch(String branchId) =>
      AuthSession.selectBranch(branchId);

  static void refreshCurrentBranch() {
    if (currentBranchId == null || currentBranchId!.isEmpty) return;
    try {
      final branch = _branchFromCache[currentBranchId];
      if (branch != null) {
        _currentBranch = branch;
      }
    } catch (_) {}
  }

  // ─── Converters ──────────────────────────────────────────────────

  static final Map<String, BranchModel> _branchFromCache = {};

  static UserModel _userFromTable(UsersTableData d) {
    return UserModel(
      id: d.id,
      name: d.name,
      email: d.email,
      passwordHash: d.passwordHash,
      role: UserRole.values.firstWhere(
        (r) => r.name == d.role,
        orElse: () => UserRole.employee,
      ),
      assignedBranchId: d.assignedBranchId,
      isActive: d.isActive,
      createdAt: d.createdAt,
      lastLogin: d.lastLogin,
      syncVersion: d.syncVersion,
      lastModified: d.lastModified,
      isDeleted: d.isDeleted,
      activeDeviceId: d.activeDeviceId,
    );
  }

  static UsersTableCompanion _userToCompanion(UserModel m) {
    return UsersTableCompanion(
      id: Value(m.id),
      name: Value(m.name),
      email: Value(m.email),
      passwordHash: Value(m.passwordHash),
      role: Value(m.role.name),
      assignedBranchId: Value(m.assignedBranchId),
      isActive: Value(m.isActive),
      createdAt: Value(m.createdAt),
      lastLogin: Value(m.lastLogin),
      syncVersion: Value(m.syncVersion),
      lastModified: Value(m.lastModified),
      isDeleted: Value(m.isDeleted),
      activeDeviceId: Value(m.activeDeviceId),
    );
  }

  static BranchModel _branchFromTable(BranchesTableData d) {
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

  static BranchesTableCompanion _branchToCompanion(BranchModel m) {
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

  static Future<List<BranchModel>> getAllBranches() =>
      AuthSession.getAllBranches();

  static Future<Map<String, dynamic>> getDashboardStats() =>
      AuthSession.getDashboardStats();

  static Future<Map<String, dynamic>> resendConfirmation(String email) =>
      AuthSession.resendConfirmation(email);

  static bool hasPermission(String permissionKey) =>
      AuthSession.hasPermission(permissionKey);

  static Future<void> refreshPermissionCache() =>
      AuthSession._refreshPermissionCache(
        _currentUser?.id ?? '',
      );

  // ─── Device Lock (الواجهة العامة) ───

  static Future<Map<String, dynamic>> forceReleaseLock() =>
      AuthDeviceLock.forceReleaseLock();

  static Future<String?> fetchLockedDevice(String userId) =>
      AuthDeviceLock.fetchLockedDevice(userId);
}

