// auth_user_sync.dart — جزء من AuthService
// مزامنة بيانات المستخدم مع Supabase وجلبها/إنشاؤها محلياً،
// وأنشاء الفرع الافتراضي.

part of 'auth_service.dart';

class AuthUserSync {
  /// جلب بيانات اليوزر من السيرفر أو المحلي، أو إنشاؤه لو مش موجود.
  static Future<UserModel> loadOrCreateUser(
    User user, {
    String? name,
    UserRole? role,
    String? assignedBranchId,
  }) async {
    final usersDao = sl<UsersDao>();

    final existingData = await usersDao.getById(user.id);
    UserModel? existing = existingData != null
        ? AuthService._userFromTable(existingData)
        : null;

    // إذا كان اليوزر موجود محلياً، نرجعه فوراً ونحدثه في الخلفية عشان سرعة الدخول
    if (existing != null) {
      _refreshUserInBackground(user.id);
      return existing;
    }

    // 1. محاولة جلب بيانات المستخدم من جدول users في Supabase أولاً إذا كنا أونلاين
    UserModel? remoteUser;
    if (await AuthService._isOnline()) {
      try {
        final response = await Supabase.instance.client
            .from('users')
            .select()
            .eq('id', user.id)
            .maybeSingle();
        if (response != null) {
          remoteUser = UserModel.fromJson(response);
        }
      } catch (e) {
        safeDebugPrint('AuthService: Error fetching remote user data: $e');
      }
    }

    final base = remoteUser; // هنا existing أكيد null

    if (base == null) {
      final metaRole = user.userMetadata?['role']?.toString().toLowerCase();
      UserRole effectiveRole;
      if (metaRole == 'owner') {
        effectiveRole = UserRole.owner;
      } else if (metaRole == 'employee') {
        effectiveRole = UserRole.employee;
      } else if (role != null) {
        effectiveRole = role;
      } else {
        effectiveRole = UserRole.employee;
      }

      final newUser = UserModel(
        id: user.id,
        name: name ?? user.userMetadata?['name']?.toString() ?? '',
        email: user.email ?? '',
        passwordHash: '',
        role: effectiveRole,
        assignedBranchId: assignedBranchId,
        createdAt: DateTime.now(),
      );
      await usersDao.upsert(AuthService._userToCompanion(newUser));
      return newUser;
    }

    final updated = base.copyWith(
      name: name ?? base.name,
      email: user.email ?? base.email,
      assignedBranchId: assignedBranchId ?? base.assignedBranchId,
      lastModified: DateTime.now(),
    );

    await usersDao.upsert(AuthService._userToCompanion(updated));
    return updated;
  }

  static void _refreshUserInBackground(String userId) async {
    if (!await AuthService._isOnline()) return;
    try {
      final response = await Supabase.instance.client
          .from('users')
          .select()
          .eq('id', userId)
          .maybeSingle();
      if (response != null) {
        final usersDao = sl<UsersDao>();
        final remoteUser = UserModel.fromJson(response);
        await usersDao.upsert(AuthService._userToCompanion(remoteUser));
      }
    } catch (e) {
      safeDebugPrint('AuthService: Background user refresh failed: $e');
    }
  }

  /// كتابة/تحديث صف المستخدم في جدول public.users بـ Supabase.
  /// الـ trigger بيعمل الصف تلقائياً عند signUp، والـ upsert هنا بيحدّث
  /// (يربط الفرع مثلاً). الـ RLS تسمح للمستخدم المصادق بكتابة صفه فقط
  /// (id = auth.uid())، لذا نضمن تطابق الـ id مع الـ auth user.
  static Future<void> pushUserToSupabase(Map<String, dynamic> data) async {
    final payload = Map<String, dynamic>.from(data);
    if (!payload.containsKey('last_modified')) {
      payload['last_modified'] = DateTime.now().toIso8601String();
    }
    // نتأكد إن الـ id يتطابق مع مستخدم المصادقة الحالي (يحل مشكلة RLS).
    final authUid = Supabase.instance.client.auth.currentUser?.id;
    if (authUid != null && authUid.isNotEmpty) {
      payload['id'] = authUid;
    }
    await Supabase.instance.client.from('users').upsert(payload);
  }

  /// ينشئ الفرع الافتراضي (الفرع الرئيسي) ويربطه باليوزر.
  static Future<BranchModel> createDefaultBranch(String userId, String userName) async {
    final branchesDao = sl<BranchesDao>();

    final existingData = await branchesDao.getById('main_$userId');
    if (existingData != null) {
      return AuthService._branchFromTable(existingData);
    }

    // 2. إذا كنا أونلاين، نحاول جلب الفرع من السيرفر قبل إنشاء فرع جديد
    if (await AuthService._isOnline()) {
      try {
        final response = await Supabase.instance.client
            .from('branches')
            .select()
            .eq('id', 'main_$userId')
            .maybeSingle();

        if (response != null) {
          final branch = BranchModel.fromJson(response);
          await branchesDao.upsert(AuthService._branchToCompanion(branch));
          return branch;
        }
      } catch (e) {
        safeDebugPrint('AuthService: Error checking existing branches online: $e');
      }
    }

    // 3. إنشاء الفرع الرئيسي
    final branchId = 'main_$userId';
    final branch = BranchModel(
      id: branchId,
      name: 'الفرع الرئيسي',
      address: null,
      phone: null,
      isActive: true,
      createdAt: DateTime.now(),
    );

    await branchesDao.upsert(AuthService._branchToCompanion(branch));

    // مزامنة الفرع الجديد
    try {
      await SyncService.queueOperation(
        type: SyncOperationType.create,
        table: 'branches',
        data: branch.toJson(),
        branchId: branchId,
      );
    } catch (e) {
      safeDebugPrint('AuthService: Default branch sync queue failed: $e');
    }

    return branch;
  }
}
