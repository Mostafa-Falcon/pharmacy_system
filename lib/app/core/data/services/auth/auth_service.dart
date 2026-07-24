import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gotrue/gotrue.dart' show OtpType;
import 'package:supabase_flutter/supabase_flutter.dart' as supabase_pkg;
import 'package:uuid/uuid.dart';

import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/core/data/database/drift_init.dart';
import 'package:pharmacy_system/app/core/models/auth/branch_model.dart';
import 'package:pharmacy_system/app/core/models/auth/permission_model.dart';
import 'package:pharmacy_system/app/core/models/auth/user_model.dart';
import 'package:pharmacy_system/app/shared/ui_core.dart';

class AuthService {
  AuthService._();
  static final _storage = FlutterSecureStorage();
  static const _sessionKey = 'auth_session';
  static const _branchKey = 'selected_branch_id';

  static UserModel? _currentUser;
  static BranchModel? _currentBranch;
  static List<PermissionModel> _permissions = [];
  static bool _initialized = false;

  static UserModel? get currentUser => _currentUser;
  static BranchModel? get currentBranch => _currentBranch;
  static String? get currentBranchId => _currentBranch?.id;

  static Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    try {
      final sessionJson = await _storage.read(key: _sessionKey);
      if (sessionJson != null) {
        final data = jsonDecode(sessionJson) as Map<String, dynamic>;
        _currentUser = UserModel.fromJson(data['user'] as Map<String, dynamic>);
        final branchId = await _storage.read(key: _branchKey);
        if (branchId != null) {
          await _loadBranch(branchId);
        }
        _permissions = (data['permissions'] as List<dynamic>?)
                ?.map(
                  (e) => PermissionModel.fromJson(e as Map<String, dynamic>),
                )
                .toList() ??
            [];
      }
    } catch (e, s) {
      safeDebugPrint('AuthService.init restore failed: $e\n$s');
    }
  }

  static DateTime _parseCreatedAt(String? value) {
    if (value == null || value.isEmpty) return DateTime.now();
    return DateTime.tryParse(value) ?? DateTime.now();
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final supabase = supabase_pkg.Supabase.instance.client;
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final supabaseUser = response.user;
      if (supabaseUser == null) {
        return {'success': false, 'message': AuthStrings.loginInvalidCredentials};
      }
      final meta = supabaseUser.userMetadata ?? {};
      final user = UserModel(
        id: supabaseUser.id,
        name: meta['name'] as String? ?? email.split('@').first,
        email: email,
        passwordHash: '',
        role: meta['role'] == 'owner' ? UserRole.owner : UserRole.employee,
        assignedBranchId: meta['assigned_branch_id'] as String?,
        accountId: meta['account_id'] as String?,
        createdAt: _parseCreatedAt(supabaseUser.createdAt),
        lastLogin: DateTime.now(),
      );
      await _saveSession(user, _permissions);
      _currentUser = user;
      await _initDefaultBranch();
      return {'success': true, 'user': user};
    } on supabase_pkg.AuthException catch (e) {
      final msg = e.message.toLowerCase();
      if (msg.contains('email not confirmed')) {
        return {'success': false, 'message': AuthStrings.emailNotConfirmed};
      }
      if (msg.contains('invalid login credentials')) {
        return {'success': false, 'message': AuthStrings.loginInvalidCredentials};
      }
      return {'success': false, 'message': e.message};
    } catch (e, s) {
      safeDebugPrint('AuthService.login error: $e\n$s');
      return _offlineLogin(email, password);
    }
  }

  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required UserRole role,
    String? assignedBranchId,
  }) async {
    try {
      final supabase = supabase_pkg.Supabase.instance.client;
      final metadata = <String, dynamic>{
        'name': name,
        'role': role.name,
      };
      if (assignedBranchId != null) {
        metadata['assigned_branch_id'] = assignedBranchId;
      }
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
        data: metadata,
      );
      final supabaseUser = response.user;
      final emailConfirmationRequired =
          supabaseUser?.identities?.isEmpty == true ||
              response.session == null;

      if (response.session == null && supabaseUser == null) {
        return _offlineRegister(name, email, password, role,
            assignedBranchId: assignedBranchId);
      }

      if (emailConfirmationRequired) {
        if (supabaseUser != null) {
          final user = UserModel(
            id: supabaseUser.id,
            name: name,
            email: email,
            passwordHash: '',
            role: role,
            assignedBranchId: assignedBranchId,
            createdAt: _parseCreatedAt(supabaseUser.createdAt),
          );
          await _saveLocalUser(user, password);
        }
        return {'success': true, 'emailConfirmationRequired': true, 'user': null};
      }

      final user = UserModel(
        id: supabaseUser!.id,
        name: name,
        email: email,
        passwordHash: '',
        role: role,
        assignedBranchId: assignedBranchId,
        createdAt: _parseCreatedAt(supabaseUser.createdAt),
      );
      await _saveSession(user, []);
      _currentUser = user;
      if (role == UserRole.owner) {
        await _createMainBranch();
      }
      return {'success': true, 'user': user};
    } on supabase_pkg.AuthException catch (e) {
      final msg = e.message.toLowerCase();
      if (msg.contains('already registered')) {
        return {'success': false, 'message': AuthStrings.emailAlreadyRegistered};
      }
      return {'success': false, 'message': e.message};
    } catch (e, s) {
      safeDebugPrint('AuthService.register error: $e\n$s');
      return _offlineRegister(name, email, password, role,
          assignedBranchId: assignedBranchId);
    }
  }

  static Future<void> logout() async {
    try {
      await supabase_pkg.Supabase.instance.client.auth.signOut();
    } catch (_) {}
    await _storage.delete(key: _sessionKey);
    await _storage.delete(key: _branchKey);
    _currentUser = null;
    _currentBranch = null;
    _permissions = [];
  }

  static bool hasPermission(String permissionKey) {
    if (_currentUser?.isOwner == true) return true;
    final permission =
        _permissions.where((p) => p.permissionKey == permissionKey && !p.isDeleted);
    if (permission.isEmpty) return false;
    return permission.any((p) => p.isAllowed);
  }

  static Future<void> selectBranch(String branchId) async {
    await _storage.write(key: _branchKey, value: branchId);
    await _loadBranch(branchId);
  }

  static void refreshCurrentBranch() {
    if (_currentBranch?.id != null) {
      _loadBranch(_currentBranch!.id);
    }
  }

  static Future<Map<String, dynamic>> resendConfirmation(String email) async {
    try {
      await supabase_pkg.Supabase.instance.client.auth.resend(
        type: OtpType.signup,
        email: email,
      );
      return {'success': true, 'message': AuthStrings.emailConfirmationResendSent};
    } catch (e, s) {
      safeDebugPrint('AuthService.resendConfirmation error: $e\n$s');
      return {'success': false, 'message': AuthStrings.resendConfirmFailed};
    }
  }

  static Future<void> _saveSession(
    UserModel user,
    List<PermissionModel> permissions,
  ) async {
    final data = {
      'user': user.toJson(),
      'permissions': permissions.map((p) => p.toJson()).toList(),
    };
    await _storage.write(key: _sessionKey, value: jsonEncode(data));
  }

  static Future<void> _saveLocalUser(UserModel user, String password) async {
    try {
      final db = appDatabase;
      await db.systemDao.upsertUser(UsersTableCompanion(
        id: Value(user.id),
        name: Value(user.name),
        email: Value(user.email),
        role: Value(user.role.name),
        assignedBranchId: Value(user.assignedBranchId),
        accountId: Value(user.accountId),
        isActive: Value(user.isActive),
        createdAt: Value(user.createdAt),
        lastLogin: Value(user.lastLogin),
        syncVersion: Value(user.syncVersion),
        lastModified: Value(user.lastModified),
        isDeleted: Value(user.isDeleted),
      ));
    } catch (e, s) {
      safeDebugPrint('AuthService._saveLocalUser error: $e\n$s');
    }
  }

  static Future<void> _initDefaultBranch() async {
    try {
      final db = appDatabase;
      final branches = await db.systemDao.getAllBranches();
      if (branches.isEmpty) {
        await _createMainBranch();
      } else {
        final savedId = await _storage.read(key: _branchKey);
        final target = savedId != null
            ? branches.where((b) => b.id == savedId).firstOrNull
            : branches.firstOrNull;
        if (target != null) {
          _currentBranch = BranchModel(
            id: target.id,
            name: target.name,
            code: target.code,
            address: target.address,
            phone: target.phone,
            isMainBranch: target.isMainBranch,
            accountId: target.accountId,
            createdAt: target.createdAt,
            syncVersion: target.syncVersion,
            lastModified: target.lastModified,
            isDeleted: target.isDeleted,
          );
        }
      }
    } catch (e, s) {
      safeDebugPrint('AuthService._initDefaultBranch error: $e\n$s');
    }
  }

  static Future<void> _loadBranch(String branchId) async {
    try {
      final db = appDatabase;
      final data = await db.systemDao.getBranchById(branchId);
      if (data != null) {
        _currentBranch = BranchModel(
          id: data.id,
          name: data.name,
          code: data.code,
          address: data.address,
          phone: data.phone,
          isMainBranch: data.isMainBranch,
          accountId: data.accountId,
          createdAt: data.createdAt,
          syncVersion: data.syncVersion,
          lastModified: data.lastModified,
          isDeleted: data.isDeleted,
        );
      }
    } catch (e, s) {
      safeDebugPrint('AuthService._loadBranch error: $e\n$s');
    }
  }

  static Future<Map<String, dynamic>> _offlineLogin(
    String email,
    String password,
  ) async {
    try {
      final db = appDatabase;
      final list = await db.systemDao.getAllUsers();
      final match = list.where((u) => u.email == email).firstOrNull;
      if (match == null) {
        return {'success': false, 'message': AuthStrings.loginInvalidCredentials};
      }
      final user = UserModel(
        id: match.id,
        name: match.name,
        email: match.email,
        passwordHash: '',
        role: match.role == 'owner' ? UserRole.owner : UserRole.employee,
        assignedBranchId: match.assignedBranchId,
        accountId: match.accountId,
        createdAt: match.createdAt,
        lastLogin: match.lastLogin,
        syncVersion: match.syncVersion,
        lastModified: match.lastModified,
        isDeleted: match.isDeleted,
      );
      _currentUser = user;
      await _saveSession(user, []);
      await _initDefaultBranch();
      return {'success': true, 'user': user};
    } catch (e) {
      return {'success': false, 'message': AuthStrings.serverUnavailable};
    }
  }

  static Future<Map<String, dynamic>> _offlineRegister(
    String name,
    String email,
    String password,
    UserRole role, {
    String? assignedBranchId,
  }) async {
    try {
      final hash = sha256.convert(utf8.encode(password)).toString();
      final user = UserModel(
        id: 'user_${const Uuid().v4()}',
        name: name,
        email: email,
        passwordHash: hash,
        role: role,
        assignedBranchId: assignedBranchId,
        createdAt: DateTime.now(),
      );
      await _saveLocalUser(user, password);
      _currentUser = user;
      await _saveSession(user, []);
      if (role == UserRole.owner) {
        await _createMainBranch();
      }
      return {
        'success': true,
        'user': user,
        'isLocalOnly': true,
        'message': AuthStrings.registerLocalSuccess,
      };
    } catch (e, s) {
      safeDebugPrint('AuthService._offlineRegister error: $e\n$s');
      return {'success': false, 'message': AuthStrings.errorRegister};
    }
  }

  static Future<void> _createMainBranch() async {
    final branch = BranchModel(
      id: 'branch_main',
      name: 'الفرع الرئيسي',
      isMainBranch: true,
      createdAt: DateTime.now(),
    );
    try {
      final db = appDatabase;
      await db.systemDao.upsertBranch(BranchesTableCompanion(
        id: Value(branch.id),
        name: Value(branch.name),
        isMainBranch: Value(branch.isMainBranch),
        createdAt: Value(branch.createdAt),
        lastModified: Value(branch.lastModified),
        isDeleted: Value(branch.isDeleted),
        syncVersion: Value(branch.syncVersion),
      ));
      _currentBranch = branch;
      await _storage.write(key: _branchKey, value: branch.id);
    } catch (e, s) {
      safeDebugPrint('AuthService._createMainBranch error: $e\n$s');
    }
  }
}
