// auth_session.dart — جزء من AuthService
// يدير دورة حياة الجلسة: التهيئة، تسجيل الدخول/الخروج، التسجيل،
// تغيير كلمة المرور، الفروع، والصلاحيات.

part of 'auth_service.dart';

class AuthSession {
  // ─── Initialization ───────────────────────────────────────────────

  static Future<void> init() async {
    if (AuthService._initialized && AuthService._currentUser != null) return;
    final settingsDao = sl<AppSettingsDao>();
    final sessionResult = await settingsDao.get('current_session');
    final session = sessionResult?.value;

    // ─── 1) محاولة استرجاع الجلسة من Supabase ───────────────
    // على الويب/ديسكتوب، currentUser ممكن يرجع null مؤقتاً بعد الـ
    // reload لحد ما الـ auth stream يطلق. عشان كدة بنستخدم
    // currentSession (اللي بيشوف الـ persisted session) ونعمل refresh
    // عشان نتأكد إن الـ token لسه صالح قبل ما نعتبر اليوزر داخل.
    try {
      final supabaseSession =
          Supabase.instance.client.auth.currentSession;
      // لو مفيش session محفوظ في Supabase، جرب نعمل restore
      // من الـ localStorage (بيحصل أحياناً بعد الـ hot reload).
      if (supabaseSession == null) {
        try {
          await Supabase.instance.client.auth.getSessionFromUrl(Uri.base);
        } catch (_) {
          // تجاهل - مفيش deep link ده مجرد refresh عادي.
        }
      }

      // نعمل refresh للتأكد إن الـ token لسه صالح (مش منتهي).
      // ده لا يرمي استثناء عادةً، بس لو فشل (token منتهي/مفيش
      // refresh token) فبناخد الـ currentUser زي ما هو.
      User? supabaseUser;
      try {
        supabaseUser =
            (await Supabase.instance.client.auth.refreshSession()).user;
      } catch (_) {
        supabaseUser = Supabase.instance.client.auth.currentUser;
      }

      // نعتبر اليوزر داخل فقط لو الـ refresh/restore نجح فعلاً
      // (supabaseUser مش null). لو فشل، منعملش return ونكمل
      // للـ fallback بتاع الـ Hive عشان ما نطردش اليوزر اللي
      // عنده session محلي صالح بس السيرفر مش متاح/مفيش token.
      if (supabaseUser != null) {
        final cached = await AuthUserSync.loadOrCreateUser(supabaseUser);
        AuthService._currentUser = cached;
        final branchIdResult = await settingsDao.get('current_branch_id');
        AuthService.currentBranchId =
            branchIdResult?.value ?? cached.assignedBranchId;
        // نحفظ الـ deviceId الحالي عشان الـ logout يعرف أي جهاز بيسجل خروج
        // (مهم لمنع كسر جلسة الجهاز التاني لو نفس الحساب متفتوح على جهازين).
        AuthService._currentDeviceId = await AuthService._getDeviceId();
        await _saveSession(cached);
        // نحدّث كاش الصلاحيات
        await _refreshPermissionCache(cached.id);
        // نتأكد إن قفل الجهاز على السيرفر متظبط لهذا الجهاز.
        AuthDeviceLock.ensureServerSessionLock(cached.id, AuthService._currentDeviceId!);
        return;
      }
    } catch (e, s) {
      safeDebugPrint('AuthService.init supabase session failed: $e\n$s');
    }

    // ─── 2) Fallback: الجلسة المحلية المحفوظة ──────────────
    // ده بيخلي اليوزر يفضل داخل بعد الـ refresh حتي لو السيرفر
    // مش متاح، طالما الـ session المحلي لسه صالح. منعملش تهيئة
    // تانية للـ deviceId لأنه اتحفظ من قبل.
    if (session != null) {
      try {
        final user = UserModel.fromJson(jsonDecode(session));
        AuthService._currentUser = user;
        final branchIdResult = await settingsDao.get('current_branch_id');
        AuthService.currentBranchId =
            branchIdResult?.value ?? user.assignedBranchId;
        AuthService._currentDeviceId = await AuthService._getDeviceId();
        // لو رجعنا للـ fallback بسبب إن السيرفر مش متاح، منحاول
        // نظبط قفل السيرفر في الخلفية لما النت يرجع (queue).
        // لو السيرفر متاح دلوقتي، نتأكد إن القفل مسجل باسم جهازنا.
        if (AuthService._currentDeviceId != null && await AuthService._isOnline()) {
          AuthDeviceLock.ensureServerSessionLock(user.id, AuthService._currentDeviceId!);
        }
        // نحدّث كاش الصلاحيات (في الخلفية)
        _refreshPermissionCache(user.id);
      } catch (e, s) {
        safeDebugPrint('AuthService.init cached session failed: $e\n$s');
      }
    }
    AuthService._initialized = true;
  }

  // ─── Login ────────────────────────────────────────────────────────

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    if (AuthService._isLoginThrottled()) {
      return {
        'success': false,
        'message': AppStrings.tooManyAttempts,
      };
    }

    if (!await AuthService._isOnline()) {
      AuthService._startLoginThrottle();
      return {
        'success': false,
        'message': AppStrings.loginRequiresInternet,
      };
    }

    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      ).timeout(const Duration(seconds: 30));

      final user = response.user;
      if (user == null) {
        AuthService._startLoginThrottle();
        return {
          'success': false,
          'message': AppStrings.loginInvalidCredentials,
        };
      }

      // تشغيل جلب المعرف وتحميل بيانات اليوزر وتشفير الباسورد بالتوازي لتسريع العملية
      final results = await Future.wait([
        AuthService._getDeviceId(),
        AuthUserSync.loadOrCreateUser(user),
        PasswordHasher.hash(password),
      ]);

      final deviceId = results[0] as String;
      var cached = results[1] as UserModel;
      final passwordHash = results[2] as String;

      // تحديث last_login في الخلفية بدون انتظار
      AuthDeviceLock.ensureServerSessionLock(user.id, deviceId);

      cached = cached.copyWith(lastLogin: DateTime.now());

      if (cached.assignedBranchId == null || cached.assignedBranchId!.isEmpty) {
        final defaultBranch = await AuthUserSync.createDefaultBranch(cached.id, cached.name);
        cached = cached.copyWith(assignedBranchId: defaultBranch.id);

        // تحديث بيانات المستخدم في السيرفر لربط الفرع (في الخلفية)
        AuthUserSync.pushUserToSupabase(cached.toJson()).catchError((e) {
          safeDebugPrint('AuthService: Background user update failed: $e');
        });
      }

      AuthService._currentUser = cached;
      AuthService.currentBranchId = cached.assignedBranchId;
      AuthService._currentDeviceId = deviceId;

      // تحديث كاش الصلاحيات
      await _refreshPermissionCache(cached.id);

      // تنفيذ الحفظ والمهام الجانبية بالتوازي
      await Future.wait([
        if (AuthService.currentBranchId != null)
          sl<AppSettingsDao>().set('current_branch_id', AuthService.currentBranchId!),
        _saveSession(cached),
        _saveActiveSession(user.id, deviceId),
        _saveCredentials(email: email, passwordHash: passwordHash),
      ]);

      return {'success': true, 'user': cached};
    } on AuthException catch (e) {
      AuthService._startLoginThrottle();
      if (_isEmailNotConfirmed(e)) {
        return {
          'success': false,
          'message': AppStrings.emailNotConfirmed,
        };
      }
      return {
        'success': false,
        'message': AppStrings.loginInvalidCredentials,
      };
    } on FormatException catch (e) {
      AuthService._startLoginThrottle();
      safeDebugPrint('AuthService.login: format error — $e');
      return {
        'success': false,
        'message': AppStrings.serverUnavailable,
      };
    } catch (e) {
      AuthService._startLoginThrottle();
      safeDebugPrint('AuthService.login: online attempt failed — $e');
      final msg = e.toString().toLowerCase();
      if (msg.contains('socketexception') ||
          msg.contains('handshake') ||
          msg.contains('connection refused') ||
          msg.contains('timeout') ||
          msg.contains('500') ||
          msg.contains('502') ||
          msg.contains('503')) {
        return {
          'success': false,
          'message': AppStrings.serverNotAvailable,
        };
      }
      return {
        'success': false,
        'message': AppStrings.loginFailed,
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
    if (AuthService._isRegisterThrottled()) {
      return {
        'success': false,
        'message': AppStrings.tooManyAttempts,
      };
    }

    if (!await AuthService._isOnline()) {
      AuthService._startRegisterThrottle();
      return {
        'success': false,
        'message': AppStrings.registerRequiresInternet,
      };
    }

    try {
      // نبعت metadata مبسّطة (name + full_name + role) بس، من غير
      // assigned_branch_id — عشان نتجنب أي تعارض مع قيود الـ trigger/الجدول
      // أثناء لحظة التسجيل الحرجة. الفرع بيتعمل ويتربط بعد نجاح الـ signUp.
      final response = await Supabase.instance.client.auth.signUp(
        email: email.trim(),
        password: password,
        data: {
          'name': name.trim(),
          'full_name': name.trim(),
          'role': role.name,
        },
        emailRedirectTo: _buildRedirectUrl(),
      );

      // لو Confirm email مفعّل في Supabase، الـ session هيكون null
      // والـ user مختلِق بس الإيميل لسه متأكّدش — نوقف هنا ونطلب التأكيد.
      if (response.session == null) {
        return {
          'success': true,
          'emailConfirmationRequired': true,
          'message': AppStrings.emailConfirmationSent,
        };
      }

      final user = response.user;
      if (user == null) {
        AuthService._startRegisterThrottle();
        return {'success': false, 'message': AppStrings.errorRegister};
      }

      // ننشئ المستخدم محلياً (مؤقتاً من غير فرع) عشان نكمل التدفق.
      var cached = await AuthUserSync.loadOrCreateUser(
        user,
        name: name,
        role: role,
        assignedBranchId: assignedBranchId,
      );

      // إنشاء الفرع الرئيسي + ربطه بالمستخدم — مفصول عن لحظة التسجيل.
      // لو فشل (شبكة/صلاحيات) مش بنفشل التسجيل، بنكمل عادي والـ sync
      // هيربطه لاحقاً عبر الـ queue.
      if (cached.assignedBranchId == null || cached.assignedBranchId!.isEmpty) {
        try {
          final defaultBranch = await AuthUserSync.createDefaultBranch(cached.id, cached.name);
          cached = cached.copyWith(assignedBranchId: defaultBranch.id);
          await AuthUserSync.pushUserToSupabase(cached.toJson());
        } catch (e) {
          safeDebugPrint('AuthService: branch link deferred (will sync later): $e');
        }
      }

      AuthService._currentUser = cached;
      AuthService.currentBranchId = cached.assignedBranchId;
      if (AuthService.currentBranchId != null) {
        await sl<AppSettingsDao>().set('current_branch_id', AuthService.currentBranchId!);
      }
      await _saveSession(cached);

      // مزامنة بيانات المستخدم لجدول users في Supabase عبر الـ queue (مرة واحدة).
      // الـ id موحّد = auth.uid() فمفيش تكرار، والـ trigger في Supabase بيعمل
      // الصف تلقائياً عند signUp، فالـ upsert بيحدّث مش بيضيف. نعتمد على
      // queueOperation + syncAll بدل upsert مباشر عشان نمنع تكرار الإرسال.
      final userJson = cached.toJson();
      try {
        await SyncService.queueOperation(
          type: SyncOperationType.create,
          table: 'users',
          data: userJson,
          branchId: cached.assignedBranchId ?? '',
        );
      } catch (e) {
        safeDebugPrint('AuthService: User queue failed: $e');
      }

      // دفع الـ queue فوراً لضمان وصول الصف لجدول users في Supabase.
      try {
        if (SyncService.isOnline) await SyncService.syncAll();
      } catch (e) {
        safeDebugPrint('AuthService: post-register sync failed: $e');
      }

      final passwordHash = await PasswordHasher.hash(password);
      await _saveCredentials(email: email, passwordHash: passwordHash);

      return {'success': true, 'user': cached};
    } on AuthException catch (e) {
      AuthService._startRegisterThrottle();
      if (_isAlreadyRegistered(e)) {
        return {
          'success': false,
          'message': AppStrings.emailAlreadyRegistered,
        };
      }
      return {'success': false, 'message': e.message};
    } on FormatException catch (_) {
      AuthService._startRegisterThrottle();
      return {
        'success': false,
        'message': AppStrings.serverUnavailable,
      };
    } catch (e) {
      AuthService._startRegisterThrottle();
      safeDebugPrint('AuthService.register: $e');
      final msg = e.toString().toLowerCase();
      if (msg.contains('email provider') ||
          msg.contains('not enabled') ||
          msg.contains('signup disabled') ||
          msg.contains('anonymous')) {
        final cached = await _registerLocal(
          name: name,
          email: email,
          password: password,
          role: role,
          assignedBranchId: assignedBranchId,
          providerDisabled: true,
        );
        if (cached != null) return cached;
        return {
          'success': false,
          'message': AppStrings.registerDisabled,
        };
      }
      if (msg.contains('weak password') ||
          (msg.contains('password') && msg.contains('characters'))) {
        return {
          'success': false,
          'message': AppStrings.weakPassword,
        };
      }
      if (_isNetworkError(msg)) {
        final cached = await _registerLocal(
          name: name,
          email: email,
          password: password,
          role: role,
          assignedBranchId: assignedBranchId,
        );
        if (cached != null) return cached;
      }
      return {
        'success': false,
        'message': '${AppStrings.errorServer}${e.runtimeType}',
      };
    }
  }

  static Future<Map<String, dynamic>?> _registerLocal({
    required String name,
    required String email,
    required String password,
    required UserRole role,
    String? assignedBranchId,
    bool providerDisabled = false,
  }) async {
    try {
      final usersDao = sl<UsersDao>();
      final localId = const Uuid().v4();

      final passwordHash = await PasswordHasher.hash(password);

      String? effectiveBranchId = assignedBranchId;
      if (effectiveBranchId == null || effectiveBranchId.isEmpty) {
        try {
          final defaultBranch = await AuthUserSync.createDefaultBranch(localId, name);
          effectiveBranchId = defaultBranch.id;
        } catch (e) {
          safeDebugPrint('AuthService._registerLocal: default branch creation failed: $e');
        }
      }

      final user = UserModel(
        id: localId,
        name: name.trim(),
        email: email.trim(),
        passwordHash: passwordHash,
        role: role,
        assignedBranchId: effectiveBranchId,
        createdAt: DateTime.now(),
      );

      await usersDao.upsert(AuthService._userToCompanion(user));
      AuthService._currentUser = user;
      AuthService.currentBranchId = effectiveBranchId;
      await _saveSession(user);
      await _saveCredentials(email: email, passwordHash: passwordHash);

      return {
        'success': true,
        'user': user,
        'isLocalOnly': true,
        'message': providerDisabled
            ? AppStrings.registerLocalProviderDisabled
            : AppStrings.registerLocalSuccess,
      };
    } catch (e) {
      safeDebugPrint('AuthService._registerLocal: $e');
      return null;
    }
  }

  // ─── Branch Selection ─────────────────────────────────────────────

  static Future<void> selectBranch(String branchId) async {
    AuthService.currentBranchId = branchId;
    await sl<AppSettingsDao>().set('current_branch_id', branchId);
    
    // تحديث الموديل الحالي للفرع للتسهيل على الواجهات
    try {
      final branch = await sl<BranchesDao>().getById(branchId);
      if (branch != null) {
        AuthService._currentBranch = AuthService._branchFromTable(branch);
      }
    } catch (_) {}
  }

  // ─── Logout ───────────────────────────────────────────────────────

  static Future<void> logout() async {
    final userId = AuthService._currentUser?.id;
    final currentDevice = AuthService._currentDeviceId;
    AuthService._currentUser = null;
    AuthService.currentBranchId = null;
    AuthService._currentDeviceId = null;
    final settingsDao = sl<AppSettingsDao>();
    await settingsDao.delete('current_session');
    await settingsDao.delete('current_branch_id');
    await SecureStorageHelper.clearCredentials();
    if (userId != null) {
      // نمسح الـ active_session المحلي بتاع الجهاز ده بس (لو لسه بيساويه).
      // ده بيخلي لو نفس الحساب متفتوح على جهاز تاني، الـ logout من
      // جهازنا ما يكسرش الجلسة بتاعة الجهاز التاني — وكل جهاز بيسجل
      // خروج بيمسح قفله هو بس، فالمنع متعدد الأجهزة بيشتغل صح.
      if (currentDevice != null) {
        final activeResult = await settingsDao.get('active_session_$userId');
        final active = activeResult?.value;
        if (active == currentDevice) {
          await _clearActiveSession(userId);
        }
      } else {
        await _clearActiveSession(userId);
      }
      // نفك القفل على السيرفر (ذري) عشان الجهاز التاني يقدر يدخل.
      await AuthDeviceLock.releaseServerSessionLock(
        userId,
        currentDevice ?? (await AuthService._getDeviceId())!,
      );
    }
    try {
      await Supabase.instance.client.auth.signOut();
    } catch (e, s) {
      safeDebugPrint('AuthService.logout signOut failed: $e\n$s');
    }
    // تنظيف الـ StreamControllers والكاش في الـ repositories عشان ما يحصلش
    // تسرب للذاكرة (memory leak) عند تبديل المستخدم/الفرع.
    await disposeInjection();
    await initInjection();
  }

  // ─── Change Password ─────────────────────────────────────────────

  static Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (!await AuthService._isOnline()) {
      return {
        'success': false,
        'message': AppStrings.changePasswordRequiresInternet,
      };
    }

    if (AuthService._currentUser == null) {
      return {'success': false, 'message': AppStrings.mustLoginFirst};
    }

    try {
      final email = AuthService._currentUser!.email;
      if (email.isEmpty) {
        return {'success': false, 'message': AppStrings.emailNotAvailable};
      }

      final savedCredentials = await SecureStorageHelper.loadCredentials();
      if (savedCredentials == null) {
        return {'success': false, 'message': AppStrings.noDataSaved};
      }

      final savedPasswordHash = savedCredentials['password_hash']!;
      final isCorrect = await PasswordHasher.verify(currentPassword, savedPasswordHash);
      if (!isCorrect) {
        return {'success': false, 'message': AppStrings.currentPasswordIncorrect};
      }

      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        await Supabase.instance.client.auth.updateUser(
          UserAttributes(password: newPassword),
        );
      }

      final newHash = await PasswordHasher.hash(newPassword);
      await _saveCredentials(email: email, passwordHash: newHash);

      return {'success': true, 'message': AppStrings.passwordChangedSuccess};
    } catch (e) {
      safeDebugPrint('AuthService.changePassword failed: $e');
      return {'success': false, 'message': AppStrings.errorGeneral};
    }
  }

  // ─── Permission Check ─────────────────────────────────────────────

  static bool hasPermission(String permissionKey) {
    if (AuthService._currentUser == null) return false;
    if (AuthService._currentUser!.isOwner) return true;
    return _permissionCache[permissionKey] ?? false;
  }

  static final Map<String, bool> _permissionCache = {};

  static Future<void> _refreshPermissionCache(String userId) async {
    try {
      final list = await sl<PermissionsDao>().getByUser(userId);
      _permissionCache.clear();
      for (final p in list) {
        _permissionCache[p.permissionKey] = p.isAllowed;
      }
    } catch (e) {
      safeDebugPrint('AuthService: _refreshPermissionCache failed: $e');
    }
  }

  // ─── Extra methods ─────────────────────────────────────────────

  static Future<List<BranchModel>> getAllBranches() async {
    final list = await sl<BranchesDao>().getAll();
    return list.map(AuthService._branchFromTable).toList();
  }

  static Future<Map<String, dynamic>> getDashboardStats() async {
    final branches = await sl<BranchesDao>().getAll();
    final users = await sl<UsersDao>().getAll();
    return {
      'total_branches': branches.length,
      'total_users': users.length,
    };
  }

  // ─── Resend Confirmation Email ───────────────────────────────

  static Future<Map<String, dynamic>> resendConfirmation(String email) async {
    if (!await AuthService._isOnline()) {
      return {
        'success': false,
        'message': AppStrings.resendConfirmRequiresInternet,
      };
    }
    try {
      // Supabase بترسل رابط تأكيد جديد لنفس الإيميل
      await Supabase.instance.client.auth.resend(
        type: OtpType.signup,
        email: email.trim(),
        emailRedirectTo: _buildRedirectUrl(),
      );
      return {'success': true, 'message': AppStrings.emailConfirmationResendSent};
    } catch (e) {
      safeDebugPrint('AuthService.resendConfirmation failed: $e');
      return {'success': false, 'message': AppStrings.resendConfirmFailed};
    }
  }

  // ─── Internal Helpers ─────────────────────────────────────────────

  static String? _buildRedirectUrl() {
    try {
      final uri = Uri.base;
      if (uri.scheme == 'http' || uri.scheme == 'https') {
        return '${uri.origin}/auth/callback';
      }
    } catch (_) {}
    // production fallback: Firebase Hosting
    return 'https://pharmacy-system-flutter.web.app/auth/callback';
  }

  static Future<void> _saveSession(UserModel user) async {
    await sl<AppSettingsDao>().set('current_session', jsonEncode(user.toJson()));
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

  static Future<void> _saveActiveSession(String userId, String deviceId) async {
    await sl<AppSettingsDao>().set('active_session_$userId', deviceId);
  }

  static Future<void> _clearActiveSession(String userId) async {
    await sl<AppSettingsDao>().delete('active_session_$userId');
  }

  // ─── Error Helpers ────────────────────────────────────────────────

  static bool _isEmailNotConfirmed(AuthException e) {
    final code = (e.code ?? e.statusCode ?? '').toLowerCase();
    final message = e.message.toLowerCase();
    return code == 'email_not_confirmed' ||
        code == 'email-not-confirmed' ||
        message.contains('email not confirmed') ||
        message.contains('confirm your email');
  }

  static bool _isAlreadyRegistered(AuthException e) {
    final code = (e.code ?? e.statusCode ?? '').toLowerCase();
    final message = e.message.toLowerCase();
    return code == 'user_already_exists' ||
        code == 'email-already-in-use' ||
        code == 'email_exists' ||
        message.contains('already registered') ||
        message.contains('already exists') ||
        message.contains('user already registered');
  }

  static bool _isNetworkError(String msg) {
    return msg.contains('socketexception') ||
        msg.contains('handshake') ||
        msg.contains('connection refused') ||
        msg.contains('timeout') ||
        msg.contains('500') ||
        msg.contains('502') ||
        msg.contains('503');
  }
}
