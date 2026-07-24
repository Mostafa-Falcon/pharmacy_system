import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService extends ChangeNotifier {
  ThemeService._();
  static final ThemeService instance = ThemeService._();

  static const _key = 'theme_mode';

  ThemeMode _currentThemeMode = ThemeMode.light;
  bool _isDesktop = false;

  ThemeMode get currentThemeMode => _currentThemeMode;
  bool get isDesktop => _isDesktop;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key);
    if (saved != null) {
      _currentThemeMode = ThemeMode.values.firstWhere(
        (e) => e.name == saved,
        orElse: () => ThemeMode.light,
      );
    }
    _isDesktop = _detectDesktop();
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _currentThemeMode = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, mode.name);
  }

  void setDesktop(bool value) {
    _isDesktop = value;
    notifyListeners();
  }

  bool _detectDesktop() {
    try {
      return Theme.of(
        WidgetsBinding.instance.rootElement!,
      ).platform == TargetPlatform.windows ||
          Theme.of(
            WidgetsBinding.instance.rootElement!,
          ).platform == TargetPlatform.macOS ||
          Theme.of(
            WidgetsBinding.instance.rootElement!,
          ).platform == TargetPlatform.linux;
    } catch (_) {
      return false;
    }
  }
}
