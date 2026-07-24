// auth_device_lock.dart — جزء من AuthService
//
// نظام الجلسات متعدد الأجهزة (Multi-device Sessions).
//
// تم إلغاء قفل الجهاز الواحد عمداً: الحساب ممكن يتفتح على أكتر من
// جهاز في نفس الوقت. الـ RPC `acquire_session_lock` على السيرفر بقى
// يرجع TRUE دائماً ولا يمنع أي جهاز آخر. الحقل `active_device_id`
// لسه موجود في الجدول للتوافق مع النسخ القديمة، لكن مش بيُستخدم
// كقفل. بنحتفظ بـ `ensureServerSessionLock` لتحديث last_login فقط.
//
// ====================================================================
// SQL المطبّق على السيرفر (يدعم multi-device):
//
// create or replace function acquire_session_lock(
//   p_user_id text, p_device_id text
// ) returns boolean language plpgsql security definer as $$
// begin
//   update public.users set last_login = now() where id::text = p_user_id;
//   return true; -- لا يمنع أي جهاز آخر
// end; $$;
// ====================================================================

part of 'auth_service.dart';

class AuthDeviceLock {
  /// يحدّث last_login على السيرفر (لا يمنع أي جهاز). يرجع true دائماً
  /// في وضع multi-device. لو السيرفر مش متاح، بيرجع true مؤقتاً.
  static Future<bool> acquireServerSessionLock(String userId, String deviceId) async {
    if (!await AuthService._isOnline()) return true; // offline → نايش مؤقتاً
    try {
      await Supabase.instance.client.rpc(
        'acquire_session_lock',
        params: {'p_user_id': userId, 'p_device_id': deviceId},
      );
      return true;
    } catch (e) {
      safeDebugPrint('AuthService: acquire_session_lock failed (offline-tolerant): $e');
      return true; // متجنبش الدخول بسبب خطأ شبكة عابر
    }
  }

  /// يظبط قفل السيرفر في الخلفية (بدون انتظار) — يستخدم في init() عشان
  /// نتأكد إن اليوزر اللي رجع من الـ fallback بيملك القفل فعلاً.
  static Future<void> ensureServerSessionLock(String userId, String deviceId) async {
    acquireServerSessionLock(userId, deviceId); // fire and forget
  }

  /// يفك القفل على السيرفر. لو السيرفر مش متاح بنعمل queue للعملية.
  static Future<void> releaseServerSessionLock(String userId, String deviceId) async {
    if (await AuthService._isOnline()) {
      try {
        await Supabase.instance.client.rpc(
          'release_session_lock',
          params: {'p_user_id': userId, 'p_device_id': deviceId},
        );
        return;
      } catch (e) {
        safeDebugPrint('AuthService: release_session_lock failed (queued): $e');
      }
    }
    // offline أو فشل → نعمل queue عشان يتفك لما النت يرجع.
    // (multi-device: القفل مش بيمنع حاجة، بس بنظبط active_device_id = null للتوافق)
    try {
      await SyncService.queueOperation(
        type: SyncOperationType.update,
        table: 'users',
        data: {
          'id': userId,
          'active_device_id': null,
        },
        branchId: AuthService.currentBranchId ?? '',
      );
    } catch (e) {
      safeDebugPrint('AuthService: release lock queue failed: $e');
    }
  }

  /// يفك القفل على السيرفر بالقوة (تسجيل خروج عن بُعد للجهاز التاني).
  /// يستخدمه اليوزر لما يحاول يدخل والحساب مقفول على جهاز تاني.
  static Future<Map<String, dynamic>> forceReleaseLock() async {
    final userId = AuthService._currentUser?.id;
    if (userId == null) {
      return {'success': false, 'message': AuthStrings.mustLoginFirst};
    }
    if (!await AuthService._isOnline()) {
      return {
        'success': false,
        'message': AuthStrings.forceLogoutInternetRequired,
      };
    }
    try {
      await Supabase.instance.client.rpc(
        'release_session_lock',
        params: {'p_user_id': userId, 'p_device_id': '__any__'},
      );
      // نحدّث جدول users محلياً ليعكس إن مفيش قفل.
      final usersDao = sl<UsersDao>();
      final existing = await usersDao.getById(userId);
      if (existing != null) {
        final updated = AuthService._userFromTable(existing).copyWith(activeDeviceId: null);
        await usersDao.upsert(AuthService._userToCompanion(updated));
      }
      return {'success': true, 'message': AuthStrings.remoteLogoutSuccess};
    } catch (e) {
      safeDebugPrint('AuthService.forceReleaseLock failed: $e');
      return {'success': false, 'message': AuthStrings.remoteLogoutFailed};
    }
  }

  /// يرجع الـ deviceId المقفول حالياً للحساب من السيرفر (أو null).
  static Future<String?> fetchLockedDevice(String userId) async {
    if (!await AuthService._isOnline()) return null;
    try {
      final response = await Supabase.instance.client
          .from('users')
          .select('active_device_id')
          .eq('id', userId)
          .maybeSingle();
      if (response != null) return response['active_device_id'] as String?;
    } catch (e) {
      safeDebugPrint('AuthService.fetchLockedDevice failed: $e');
    }
    return null;
  }
}



