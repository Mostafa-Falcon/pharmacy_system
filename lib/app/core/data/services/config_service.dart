import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class ConfigService {
  ConfigService._();

  static String _supabaseUrl = '';
  static String _supabaseAnonKey = '';

  static String get supabaseUrl => _supabaseUrl;
  static String get supabaseAnonKey => _supabaseAnonKey;

  static Future<void> load() async {
    try {
      final jsonStr = await rootBundle.loadString('assets/config.json');
      final json = jsonDecode(jsonStr) as Map<String, dynamic>;
      _supabaseUrl = (json['supabaseUrl'] as String? ?? '').trim();
      _supabaseAnonKey = (json['supabaseAnonKey'] as String? ?? '').trim();
    } catch (e) {
      _supabaseUrl = '';
      _supabaseAnonKey = '';
    }
  }
}
