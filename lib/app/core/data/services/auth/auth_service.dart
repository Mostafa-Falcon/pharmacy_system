import 'dart:async';
import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:pharmacy_system/app/shared/ui_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:pharmacy_system/app/core/models/auth/user_model.dart';
import 'package:pharmacy_system/app/core/models/auth/branch_model.dart';
import 'package:pharmacy_system/app/core/data/database/daos/system_dao.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/core/sync/sync_service.dart';
import 'password_hasher.dart';
import 'secure_storage_helper.dart';
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
    return const Uuid().v4();
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

  static Future<bool> _isOnline() async => SyncService.isOnline;

  // --- Password Hashing Utility ---

  static Future<String> hashPassword(String password) =>
      PasswordHasher.hash(password);

  static Future<bool> verifyPassword(String password, String storedHash) =>
      PasswordHasher.verify(password, storedHash);

  // --- Session Delegation ---

  static Future<void> init() => AuthSession.init();

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    if (_isLoginThrottled()) {
      return {'success': false, 'message': AuthStrings.tooManyAttempts};
    }

    if (!await AuthService._isOnline()) {
      _startLoginThrottle();
      return {'success': false, 'message': AuthStrings.loginRequiresInternet};
    }

    try {
      final res = await AuthSession.login(email: email, password: password);
      if (!(res['success'] as bool? ?? false)) {
        _startLoginThrottle();
      }
      return res;
    } catch (e) {
      _startLoginThrottle();
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    UserRole role = UserRole.employee,
    String? assignedBranchId,
  }) async {
    if (_isRegisterThrottled()) {
      return {'success': false, 'message': AuthStrings.tooManyAttempts};
    }

    if (!await AuthService._isOnline()) {
      _startRegisterThrottle();
      return {'success': false, 'message': AuthStrings.loginRequiresInternet};
    }

    try {
      final res = await AuthSession.register(
        name: name,
        email: email,
        password: password,
        role: role,
        assignedBranchId: assignedBranchId,
      );
      if (!(res['success'] as bool? ?? false)) {
        _startRegisterThrottle();
      }
      return res;
    } catch (e) {
      _startRegisterThrottle();
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<void> logout() => AuthSession.logout();

  static Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) => AuthSession.changePassword(
    currentPassword: currentPassword,
    newPassword: newPassword,
  );

  static Future<void> selectBranch(String branchId) =>
      AuthSession.selectBranch(branchId);

  // --- Converters ---

  static UserModel _userFromTable(UsersTableData d) {
    return UserModel(
      id: d.id,
      name: d.name,
      email: d.email,
      passwordHash: '',
      role: UserRole.values.firstWhere(
        (r) => r.name == d.role,
        orElse: () => UserRole.employee,
      ),
      assignedBranchId: d.assignedBranchId,
      activeDeviceId: d.activeDeviceId,
      createdAt: d.createdAt,
      lastModified: d.lastModified,
      isDeleted: d.isDeleted,
      syncVersion: d.syncVersion,
    );
  }

  static UsersTableCompanion _userToCompanion(UserModel m) {
    return UsersTableCompanion(
      id: Value(m.id),
      name: Value(m.name),
      email: Value(m.email),
      role: Value(m.role.name),
      assignedBranchId: Value(m.assignedBranchId),
      activeDeviceId: Value(m.activeDeviceId),
      createdAt: Value(m.createdAt),
      lastModified: Value(m.lastModified),
      isDeleted: Value(m.isDeleted),
      syncVersion: Value(m.syncVersion),
    );
  }

  static BranchModel _branchFromTable(BranchesTableData d) {
    return BranchModel(
      id: d.id,
      name: d.name,
      address: d.address,
      phone: d.phone,
      isActive: d.isActive,
      accountId: d.accountId,
      createdAt: d.lastModified,
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
      accountId: Value(m.accountId),
      lastModified: Value(m.lastModified),
      isDeleted: Value(m.isDeleted),
    );
  }

  // --- Permissions ---

  static Future<bool> hasPermission(String permissionKey) =>
      AuthSession.hasPermission(permissionKey);

  static Future<void> refreshPermissionCache() =>
      AuthSession._refreshPermissionCache(_currentUser?.id ?? '');

  // --- Device Lock ---

  static Future<bool> acquireServerSessionLock(
    String userId,
    String deviceId,
  ) => AuthDeviceLock.acquireServerSessionLock(userId, deviceId);

  static Future<void> ensureServerSessionLock(
    String userId,
    String deviceId,
  ) => AuthDeviceLock.ensureServerSessionLock(userId, deviceId);

  static Future<void> releaseServerSessionLock(
    String userId,
    String deviceId,
  ) => AuthDeviceLock.releaseServerSessionLock(userId, deviceId);

  static Future<Map<String, dynamic>> forceReleaseLock() =>
      AuthDeviceLock.forceReleaseLock();

  static Future<String?> fetchLockedDevice(String userId) =>
      AuthDeviceLock.fetchLockedDevice(userId);
}
