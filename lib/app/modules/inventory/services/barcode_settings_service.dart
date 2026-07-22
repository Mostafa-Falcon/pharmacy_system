import 'dart:convert';
import 'package:pharmacy_system/app/core/injection.dart';
import 'package:pharmacy_system/app/core/data/database/daos/app_settings_dao.dart';
import 'package:pharmacy_system/app/modules/inventory/models/barcode_settings_model.dart';

class BarcodeSettingsService {
  static Future<BarcodeSettingsModel> getSettings() async {
    try {
      final dao = sl<AppSettingsDao>();
      final data = await dao.get('barcode_settings');
      if (data == null) return const BarcodeSettingsModel();
      final json = jsonDecode(data.value) as Map<String, dynamic>;
      return BarcodeSettingsModel.fromJson(json);
    } catch (_) {
      return const BarcodeSettingsModel();
    }
  }

  static Future<void> save(BarcodeSettingsModel settings) async {
    final dao = sl<AppSettingsDao>();
    await dao.set('barcode_settings', jsonEncode(settings.toJson()));
  }
}

