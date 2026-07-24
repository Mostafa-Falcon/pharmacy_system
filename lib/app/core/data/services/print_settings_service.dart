import 'package:pharmacy_system/app/core/injection.dart';
import 'package:pharmacy_system/app/core/data/database/daos/app_settings_dao.dart';

class PrintSettingsService {
  PrintSettingsService._();
  static bool _cachedEnabled = true;

  static Future<void> init() async {
    try {
      final dao = sl<AppSettingsDao>();
      final data = await dao.get('print_enabled');
      _cachedEnabled = data?.value == 'true';
    } catch (_) {
      _cachedEnabled = true;
    }
  }

  static bool get isPrintEnabled => _cachedEnabled;

  static set isPrintEnabled(bool value) {
    _cachedEnabled = value;
    sl<AppSettingsDao>().set('print_enabled', value.toString());
  }

  static void toggle() {
    isPrintEnabled = !isPrintEnabled;
  }
}


