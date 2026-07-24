// Auth_session.dart — جزء من AuthService
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
        // جلب أو تحديث بيانات المستخدم من السيرفر/المحلي
        final cached = await AuthUserSync.loadOrCreateUser(supabaseUser);
        AuthService._currentUser = cached;
        AuthService.currentBranchId = cached.assignedBranchId;
        AuthService._currentDeviceId = await AuthService._getDeviceId();
        
        if (AuthService.currentBranchId != null) {
          await selectBranch(AuthService.currentBranchId!);
        }

        // تحديث حالة الجلسة على السيرفر (last_login)
        if (AuthService._currentDeviceId != null) {
          await AuthDeviceLock.ensureServerSessionLock(cached.id, AuthService._currentDeviceId!);
        }

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
        
        if (AuthService.currentBranchId != null) {
          await selectBranch(AuthService.currentBranchId!);
        }

        await _refreshPermissionCache(user.id);
        AuthService._initialized = true;
        return;
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

      // تحديث بيانات الجلسة الأخيرة والجهاز النشط
      cached = cached.copyWith(
        lastLogin: DateTime.now(),
        activeDeviceId: deviceId,
      );

      // حفظ التحديثات محلياً وفى السيرفر (RPC acquire_session_lock يحدّث last_login أيضاً)
      final systemDao = sl<SystemDao>();
      await systemDao.upsertUser(SystemMapper.userToCompanion(cached));
      
      AuthService._currentUser = cached;
      AuthService.currentBranchId = cached.assignedBranchId;
      AuthService._currentDeviceId = deviceId;

      if (AuthService.currentBranchId != null) {
        await selectBranch(AuthService.currentBranchId!);
      }

      await _refreshPermissionCache(cached.id);

      await Future.wait([
        _saveSession(cached),
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
        
        // تحديث بيانات المستخدم في قاعدة البيانات المحلية بالفرع الجديد
        final systemDao = sl<SystemDao>();
        await systemDao.upsertUser(SystemMapper.userToCompanion(cached));
      }

      AuthService._currentUser = cached;
      AuthService.currentBranchId = cached.assignedBranchId;
      AuthService._currentDeviceId = await AuthService._getDeviceId();
      
      if (AuthService.currentBranchId != null) {
        await selectBranch(AuthService.currentBranchId!);
      }
      
      await _refreshPermissionCache(cached.id);
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
    var branchData = await systemDao.getBranchById(branchId);

    // إذا لم يوجد الفرع محلياً، نحاول جلب بياناته من السيرفر
    if (branchData == null && await AuthService._isOnline()) {
      try {
        final response = await Supabase.instance.client
            .from('branches')
            .select()
            .eq('id', branchId)
            .maybeSingle();
        if (response != null) {
          final branch = BranchModel.fromJson(response);
          await systemDao.upsertBranch(SystemMapper.branchToCompanion(branch));
          branchData = await systemDao.getBranchById(branchId);
        }
      } catch (e) {
        safeDebugPrint('AuthService.selectBranch: failed to fetch branch online: $e');
      }
    }

    if (branchData != null) {
      AuthService._currentBranch = SystemMapper.branchFromData(branchData);
    }
  }

  // ─── Logout ───────────────────────────────────────────────────────

  static Future<void> logout() async {
    AuthService._currentUser = null;
    AuthService.currentBranchId = null;
    AuthService._currentBranch = null;
    AuthService._currentDeviceId = null;
    _permissionCache.clear();
    
    await SecureStorageHelper.clearSession();
    await SecureStorageHelper.clearCredentials();
    await SecureStorageHelper.clearBranchId();
    
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
    return list.map(SystemMapper.branchFromData).toList();
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
