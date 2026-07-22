import 'dart:convert';
import 'package:flutter/services.dart';

class ConfigService {
  static Map<String, String>? _values;

  static Future<void> load() async {
    if (_values != null) return;
    try {
      final raw = await rootBundle.loadString('assets/config.json');
      final map = jsonDecode(raw) as Map<String, dynamic>;
      _values = map.map((k, v) => MapEntry(k, v.toString()));
    } catch (e) {
      throw StateError('ConfigService: failed to load assets/config.json: $e');
    }
  }

  static String get supabaseUrl => _values?['supabaseUrl'] ?? '';
  static String get supabaseAnonKey => _values?['supabaseAnonKey'] ?? '';

  static bool get isConfigured =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
}
