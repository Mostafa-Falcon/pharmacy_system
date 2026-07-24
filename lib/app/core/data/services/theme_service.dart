import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:pharmacy_system/app/core/injection.dart';
import 'package:pharmacy_system/app/shared/ui_core.dart';
import 'package:pharmacy_system/app/core/data/database/daos/system_dao.dart';

class ThemeService extends ChangeNotifier {
  static final ThemeService instance = ThemeService._();
  ThemeService._();

  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get currentThemeMode => _themeMode;

  bool get isDesktop => !kIsWeb && (
    defaultTargetPlatform == TargetPlatform.windows || 
    defaultTargetPlatform == TargetPlatform.macOS || 
    defaultTargetPlatform == TargetPlatform.linux
  );

  bool get isDark {
    if (_themeMode == ThemeMode.system) {
      return PlatformDispatcher.instance.platformBrightness == Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }

  Future<void> init() async {
    try {
      final dao = sl<AppSettingsDao>();
      final saved = await dao.get('themeMode');
      _themeMode = _themeModeFromString(saved?.value ?? 'light');
      safeDebugPrint('ThemeService: Initialized with mode: $_themeMode');
    } catch (e) {
      safeDebugPrint('ThemeService: Init error: $e');
    }
    notifyListeners();
  }

  void toggleTheme() {
    final next = isDark ? ThemeMode.light : ThemeMode.dark;
    safeDebugPrint('ThemeService: Toggling theme to: $next');
    _apply(next);
  }

  void setThemeMode(ThemeMode mode) {
    safeDebugPrint('ThemeService: Setting theme mode to: $mode');
    _apply(mode);
  }

  void _apply(ThemeMode mode) {
    if (_themeMode == mode) return;
    _themeMode = mode;
    sl<AppSettingsDao>().set('themeMode', mode.name);
    notifyListeners();
  }

  ThemeMode _themeModeFromString(String value) {
    switch (value) {
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.light;
    }
  }
}


