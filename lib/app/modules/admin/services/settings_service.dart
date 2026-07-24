import 'dart:convert';
import 'package:get_it/get_it.dart';
import 'package:pharmacy_system/app/modules/admin/models/settings_model.dart';
import 'package:pharmacy_system/app/core/data/database/daos/app_settings_dao.dart';
import '../../../core/injection.dart';

class SettingsService {
  static final SettingsService _instance = SettingsService._internal();
  factory SettingsService() => _instance;
  SettingsService._internal();

  static SettingsService get to => GetIt.instance<SettingsService>();
  static const _key = 'pharmacy_settings';

  PharmacySettings _settings = PharmacySettings();

  PharmacySettings get settings => _settings;

  Future<void> load() async {
    final result = await sl<AppSettingsDao>().get(_key);
    if (result != null && result.value.isNotEmpty) {
      final data = jsonDecode(result.value) as Map<String, dynamic>;
      _settings = PharmacySettings.fromJson(data);
    }
  }

  Future<void> save() async {
    await sl<AppSettingsDao>().set(_key, jsonEncode(_settings.toJson()));
  }

  Future<void> updateProject(ProjectSettings Function(ProjectSettings) updater) async {
    _settings = PharmacySettings(
      project: updater(_settings.project),
      tax: _settings.tax,
      items: _settings.items,
      sales: _settings.sales,
      system: _settings.system,
      email: _settings.email,
      sms: _settings.sms,
      rewards: _settings.rewards,
      shortcuts: _settings.shortcuts,
      extraUnits: _settings.extraUnits,
    );
    await save();
  }

  Future<void> updateTax(TaxSettings Function(TaxSettings) updater) async {
    _settings = PharmacySettings(
      project: _settings.project,
      tax: updater(_settings.tax),
      items: _settings.items,
      sales: _settings.sales,
      system: _settings.system,
      email: _settings.email,
      sms: _settings.sms,
      rewards: _settings.rewards,
      shortcuts: _settings.shortcuts,
      extraUnits: _settings.extraUnits,
    );
    await save();
  }

  Future<void> updateItems(ItemsSettings Function(ItemsSettings) updater) async {
    _settings = PharmacySettings(
      project: _settings.project,
      tax: _settings.tax,
      items: updater(_settings.items),
      sales: _settings.sales,
      system: _settings.system,
      email: _settings.email,
      sms: _settings.sms,
      rewards: _settings.rewards,
      shortcuts: _settings.shortcuts,
      extraUnits: _settings.extraUnits,
    );
    await save();
  }

  Future<void> updateSales(SalesSettings Function(SalesSettings) updater) async {
    _settings = PharmacySettings(
      project: _settings.project,
      tax: _settings.tax,
      items: _settings.items,
      sales: updater(_settings.sales),
      system: _settings.system,
      email: _settings.email,
      sms: _settings.sms,
      rewards: _settings.rewards,
      shortcuts: _settings.shortcuts,
      extraUnits: _settings.extraUnits,
    );
    await save();
  }

  Future<void> updateSystem(SystemSettings Function(SystemSettings) updater) async {
    _settings = PharmacySettings(
      project: _settings.project,
      tax: _settings.tax,
      items: _settings.items,
      sales: _settings.sales,
      system: updater(_settings.system),
      email: _settings.email,
      sms: _settings.sms,
      rewards: _settings.rewards,
      shortcuts: _settings.shortcuts,
      extraUnits: _settings.extraUnits,
    );
    await save();
  }

  Future<void> updateEmail(EmailSettings Function(EmailSettings) updater) async {
    _settings = PharmacySettings(
      project: _settings.project,
      tax: _settings.tax,
      items: _settings.items,
      sales: _settings.sales,
      system: _settings.system,
      email: updater(_settings.email),
      sms: _settings.sms,
      rewards: _settings.rewards,
      shortcuts: _settings.shortcuts,
      extraUnits: _settings.extraUnits,
    );
    await save();
  }

  Future<void> updateSms(SmsSettings Function(SmsSettings) updater) async {
    _settings = PharmacySettings(
      project: _settings.project,
      tax: _settings.tax,
      items: _settings.items,
      sales: _settings.sales,
      system: _settings.system,
      email: _settings.email,
      sms: updater(_settings.sms),
      rewards: _settings.rewards,
      shortcuts: _settings.shortcuts,
      extraUnits: _settings.extraUnits,
    );
    await save();
  }

  Future<void> updateRewards(RewardsSettings Function(RewardsSettings) updater) async {
    _settings = PharmacySettings(
      project: _settings.project,
      tax: _settings.tax,
      items: _settings.items,
      sales: _settings.sales,
      system: _settings.system,
      email: _settings.email,
      sms: _settings.sms,
      rewards: updater(_settings.rewards),
      shortcuts: _settings.shortcuts,
      extraUnits: _settings.extraUnits,
    );
    await save();
  }

  Future<void> updateShortcuts(ShortcutsSettings Function(ShortcutsSettings) updater) async {
    _settings = PharmacySettings(
      project: _settings.project,
      tax: _settings.tax,
      items: _settings.items,
      sales: _settings.sales,
      system: _settings.system,
      email: _settings.email,
      sms: _settings.sms,
      rewards: _settings.rewards,
      shortcuts: updater(_settings.shortcuts),
      extraUnits: _settings.extraUnits,
    );
    await save();
  }

  Future<void> updateExtraUnits(ExtraUnitsSettings Function(ExtraUnitsSettings) updater) async {
    _settings = PharmacySettings(
      project: _settings.project,
      tax: _settings.tax,
      items: _settings.items,
      sales: _settings.sales,
      system: _settings.system,
      email: _settings.email,
      sms: _settings.sms,
      rewards: _settings.rewards,
      shortcuts: _settings.shortcuts,
      extraUnits: updater(_settings.extraUnits),
    );
    await save();
  }

  Future<void> updateInvoiceLayout(InvoiceLayoutSettings Function(InvoiceLayoutSettings) updater) async {
    _settings = PharmacySettings(
      project: _settings.project,
      tax: _settings.tax,
      items: _settings.items,
      sales: _settings.sales,
      system: _settings.system,
      email: _settings.email,
      sms: _settings.sms,
      rewards: _settings.rewards,
      shortcuts: _settings.shortcuts,
      extraUnits: _settings.extraUnits,
      invoiceLayout: updater(_settings.invoiceLayout),
    );
    await save();
  }
}




