import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:pharmacy_system/app/core/config/app_config.dart';
import 'package:pharmacy_system/app/shared/ui_core.dart';

class SupabaseClientService {
  // يعيد true عند النجاح، false عند الفشل (مع رمي الخطأ للأعلى عشان الـ bloc يتعامل معاه).
  // مهم: نمرّر redirectTo عشان رابط إعادة التعيين يرجّع المستخدم للتطبيق
  // (deep link) بدل ما يفتح صفحة ويب عامة. من غيره الرابط ممكن ما يشتغلش
  // خصوصاً على ديسكتوب/ويب.
  static Future<bool> resetPassword(String email) async {
    try {
      await Supabase.instance.client.auth.resetPasswordForEmail(
        email,
        redirectTo: _buildRedirectUrl(),
      );
      return true;
    } catch (e, s) {
      safeDebugPrint('SupabaseClient.resetPassword failed: $e\n$s');
      return false;
    }
  }

  // نبني رابط الإرجاع بناءً على الـ origin الحالي في المتصفح/الويب.
  // للـ resetPassword و signUp بنوجه على /auth/callback اللي بتستقبل الـ deep link
  // وتكمل تدفق المصادقة (تأكيد إيميل، إعادة تعيين كلمة المرور).
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
}

Future<void> initSupabase() async {
  final url = AppConfig.effectiveUrl.trim();
  final key = AppConfig.effectiveAnonKey.trim();

  if (url.isEmpty || key.isEmpty) {
    final missing = <String>[];
    if (url.isEmpty) missing.add('SUPABASE_URL');
    if (key.isEmpty) missing.add('SUPABASE_ANON_KEY');
    throw StateError('Supabase credentials missing: ${missing.join(', ')}. Set them in assets/config.json or pass via --dart-define.');
  }

  await Supabase.initialize(url: url, publishableKey: key);
  safeDebugPrint('Supabase: initialized OK');
}


