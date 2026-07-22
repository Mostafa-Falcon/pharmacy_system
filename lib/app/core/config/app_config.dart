import 'package:flutter/foundation.dart';
import 'package:pharmacy_system/app/core/data/services/config_service.dart';

class AppConfig {
  static Future<void> load() async {
    await ConfigService.load();
  }

  static String get supabaseUrl => ConfigService.supabaseUrl;
  static String get supabaseAnonKey => ConfigService.supabaseAnonKey;

  static String get effectiveUrl {
    if (kDebugMode) {
      const fromDefine = String.fromEnvironment('SUPABASE_URL');
      if (fromDefine.isNotEmpty) return fromDefine;
    }
    return supabaseUrl;
  }

  static String get effectiveAnonKey {
    if (kDebugMode) {
      const fromDefine = String.fromEnvironment('SUPABASE_ANON_KEY');
      if (fromDefine.isNotEmpty) return fromDefine;
    }
    return supabaseAnonKey;
  }
}
