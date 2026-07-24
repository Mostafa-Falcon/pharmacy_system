// auth_session.dart — جزء من AuthService
// يدير دورة حياة الجلسة: التهيئة، تسجيل الدخول/الخروج، التسجيل،
// تغيير كلمة المرور، الفروع، والصلاحيات.

part of 'auth_service.dart';

class AuthSession {
  // ─── Initialization ───────────────────────────────────────────────

  static Future<void> init() async {
    if (AuthService._initialized && AuthService._currentUser != null) return;
    
    // 1) محاولة استرجاع الجلسة من Supabase ───────────────
    try {
      final supabaseUser = Supabase.instance.client.auth.currentUser;
      if (supabaseUser != null) {
        final cached = await AuthUserSync.loadOrCreateUser(supabaseUser);
        AuthService._currentUser = cached;
        AuthService.currentBranchId = cached.assignedBranchId;
        AuthService._currentDeviceId = await AuthService._getDeviceId();
        await _saveSession(cached);
        await _refreshPermissionCache(cached.id);
        AuthService._initialized = true;
        return;
      }
    } catch (e, s) {
      safeDebugPrint('AuthService.init supabase session failed: $e\n$s');
    }

    // 2) Fallback: الجلسة المحلية المحفوظة في SecureStorage ──────────────
    try {
      final sessionJson = await SecureStorageHelper.loadSession();
      if (sessionJson != null) {
        final user = UserModel.fromJson(jsonDecode(sessionJson));
        AuthService._currentUser = user;
        AuthService.currentBranchId = await SecureStorageHelper.getBranchId() ?? user.assignedBranchId;
        AuthService._currentDeviceId = await AuthService._getDeviceId();
        _refreshPermissionCache(user.id);
      }
    } catch (e, s) {
      safeDebugPrint('AuthService.init cached session failed: $e\n$s');
    }

    AuthService._initialized = true;
  }

  // ─── Login ────────────────────────────────────────────────────────

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      ).timeout(const Duration(seconds: 30));

      final user = response.user;
      if (user == null) {
        return {
          'success': false,
          'message': AuthStrings.loginInvalidCredentials,
        };
      }

      final deviceId = await AuthService._getDeviceId() ?? '';
      var cached = await AuthUserSync.loadOrCreateUser(user);
      final passwordHash = await PasswordHasher.hash(password);

      cached = cached.copyWith(lastLogin: DateTime.now());

      AuthService._currentUser = cached;
      AuthService.currentBranchId = cached.assignedBranchId;
      AuthService._currentDeviceId = deviceId;

      await _refreshPermissionCache(cached.id);

      await Future.wait([
        _saveSession(cached),
        if (AuthService.currentBranchId != null)
          SecureStorageHelper.saveBranchId(AuthService.currentBranchId!),
        _saveCredentials(email: email, passwordHash: passwordHash),
      ]);

      return {'success': true, 'user': cached};
    } on AuthException catch (e) {
      return {
        'success': false,
        'message': e.message,
      };
    } catch (e) {
      safeDebugPrint('AuthService.login: failed — $e');
      return {
        'success': false,
        'message': AuthStrings.loginFailed,
      };
    }
  }

  // ─── Register ─────────────────────────────────────────────────────

  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required UserRole role,
    String? assignedBranchId,
  }) async {
    try {
      final response = await Supabase.instance.client.auth.signUp(
        email: email.trim(),
        password: password,
        data: {
          'name': name.trim(),
          'full_name': name.trim(),
          'role': role.name,
        },
      );

      if (response.session == null) {
        return {
          'success': true,
          'emailConfirmationRequired': true,
          'message': AuthStrings.emailConfirmationSent,
        };
      }

      final user = response.user;
      if (user == null) {
        return {'success': false, 'message': AuthStrings.errorRegister};
      }

      var cached = await AuthUserSync.loadOrCreateUser(
        user,
        name: name,
        role: role,
        assignedBranchId: assignedBranchId,
      );

      if (cached.assignedBranchId == null || cached.assignedBranchId!.isEmpty) {
        final defaultBranch = await AuthUserSync.createDefaultBranch(cached.id, cached.name);
        cached = cached.copyWith(assignedBranchId: defaultBranch.id);
      }

      AuthService._currentUser = cached;
      AuthService.currentBranchId = cached.assignedBranchId;
      await _saveSession(cached);

      final passwordHash = await PasswordHasher.hash(password);
      await _saveCredentials(email: email, passwordHash: passwordHash);

      return {'success': true, 'user': cached};
    } on AuthException catch (e) {
      return {'success': false, 'message': e.message};
    } catch (e) {
      safeDebugPrint('AuthService.register: $e');
      return {
        'success': false,
        'message': AuthStrings.errorRegister,
      };
    }
  }

  // ─── Branch Selection ─────────────────────────────────────────────

  static Future<void> selectBranch(String branchId) async {
    AuthService.currentBranchId = branchId;
    await SecureStorageHelper.saveBranchId(branchId);
    
    final systemDao = sl<SystemDao>();
    final branchData = await systemDao.getBranchById(branchId);
    if (branchData != null) {
      AuthService._currentBranch = AuthService._branchFromTable(branchData);
    }
  }

  // ─── Logout ───────────────────────────────────────────────────────

  static Future<void> logout() async {
    AuthService._currentUser = null;
    AuthService.currentBranchId = null;
    AuthService._currentDeviceId = null;
    
    await SecureStorageHelper.clearSession();
    await SecureStorageHelper.clearCredentials();
    
    try {
      await Supabase.instance.client.auth.signOut();
    } catch (e, s) {
      safeDebugPrint('AuthService.logout signOut failed: $e\n$s');
    }
  }

  // ─── Change Password ─────────────────────────────────────────────

  static Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (AuthService._currentUser == null) {
      return {'success': false, 'message': AuthStrings.mustLoginFirst};
    }

    try {
      final savedCredentials = await SecureStorageHelper.loadCredentials();
      if (savedCredentials == null) {
        return {'success': false, 'message': AuthStrings.noDataSaved};
      }

      final savedPasswordHash = savedCredentials['password_hash']!;
      final isCorrect = await PasswordHasher.verify(currentPassword, savedPasswordHash);
      if (!isCorrect) {
        return {'success': false, 'message': AuthStrings.currentPasswordIncorrect};
      }

      await Supabase.instance.client.auth.updateUser(
        UserAttributes(password: newPassword),
      );

      final newHash = await PasswordHasher.hash(newPassword);
      await _saveCredentials(email: AuthService._currentUser!.email, passwordHash: newHash);

      return {'success': true, 'message': AuthStrings.passwordChangedSuccess};
    } catch (e) {
      safeDebugPrint('AuthService.changePassword failed: $e');
      return {'success': false, 'message': AuthStrings.errorGeneral};
    }
  }

  // ─── Permission Check ─────────────────────────────────────────────

  static final Map<String, bool> _permissionCache = {};

  static bool hasPermission(String permissionKey) {
    if (AuthService._currentUser == null) return false;
    if (AuthService._currentUser!.isOwner) return true;
    return _permissionCache[permissionKey] ?? false;
  }

  static Future<void> _refreshPermissionCache(String userId) async {
    _permissionCache.clear();
    try {
      final systemDao = sl<SystemDao>();
      final perms = await systemDao.getPermissionsByUser(userId);
      for (final p in perms) {
        _permissionCache[p.permissionKey] = p.isAllowed;
      }
    } catch (e) {
      safeDebugPrint('AuthService: _refreshPermissionCache failed: $e');
    }
  }

  // ─── Extra methods ─────────────────────────────────────────────

  static Future<List<BranchModel>> getAllBranches() async {
    final systemDao = sl<SystemDao>();
    final list = await systemDao.getAllBranches();
    return list.map(AuthService._branchFromTable).toList();
  }

  static Future<Map<String, dynamic>> getDashboardStats() async {
    final systemDao = sl<SystemDao>();
    final branches = await systemDao.getAllBranches();
    final users = await systemDao.getAllUsers();
    return {
      'total_branches': branches.length,
      'total_users': users.length,
    };
  }

  static Future<Map<String, dynamic>> resendConfirmation(String email) async {
    try {
      await Supabase.instance.client.auth.resend(
        type: OtpType.signup,
        email: email.trim(),
      );
      return {'success': true, 'message': AuthStrings.emailConfirmationResendSent};
    } catch (e) {
      safeDebugPrint('AuthService.resendConfirmation failed: $e');
      return {'success': false, 'message': AuthStrings.resendConfirmFailed};
    }
  }

  // ─── Internal Helpers ─────────────────────────────────────────────

  static Future<void> _saveSession(UserModel user) async {
    await SecureStorageHelper.saveSession(jsonEncode(user.toJson()));
  }

  static Future<void> _saveCredentials({
    required String email,
    required String passwordHash,
  }) async {
    await SecureStorageHelper.saveCredentials(
      email: email,
      passwordHash: passwordHash,
    );
  }
}
