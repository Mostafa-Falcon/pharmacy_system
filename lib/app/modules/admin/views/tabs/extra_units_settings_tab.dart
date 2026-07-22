import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_system/app/modules/admin/models/settings_model.dart';
import '../../bloc/settings_bloc.dart';
import './widgets_tabs/settings_shell.dart';
import './widgets_tabs/settings_builders.dart';

class ExtraUnitsSettingsTab extends StatelessWidget {
  const ExtraUnitsSettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final extra = context.select<SettingsBloc, ExtraUnitsSettings>(
        (bloc) => bloc.state.settings.extraUnits);
    final bloc = context.read<SettingsBloc>();
    return SettingsShell(
      title: 'الوحدات الإضافية',
      description: 'تفعيل أو إخفاء الوحدات والأنظمة الإضافية في التطبيق',
      children: [
        SettingsFieldBuilders.buildToggle('المحاسبة', extra.enableAccounting,
            (v) { bloc.add(UpdateExtraUnitsSettings((e) { e.enableAccounting = v; return e; })); }),
        SettingsFieldBuilders.buildToggle('فاتورة إلكترونية (ZATCA)', extra.enableZatca,
            (v) { bloc.add(UpdateExtraUnitsSettings((e) { e.enableZatca = v; return e; })); }),
        SettingsFieldBuilders.buildToggle('مطبخ (مطعم)', extra.enableKitchen,
            (v) { bloc.add(UpdateExtraUnitsSettings((e) { e.enableKitchen = v; return e; })); }),
        SettingsFieldBuilders.buildToggle('الموارد البشرية', extra.enableHr,
            (v) { bloc.add(UpdateExtraUnitsSettings((e) { e.enableHr = v; return e; })); }),
        SettingsFieldBuilders.buildToggle('الصيانة', extra.enableMaintenance,
            (v) { bloc.add(UpdateExtraUnitsSettings((e) { e.enableMaintenance = v; return e; })); }),
        SettingsFieldBuilders.buildToggle('مغسلة', extra.enableLaundry,
            (v) { bloc.add(UpdateExtraUnitsSettings((e) { e.enableLaundry = v; return e; })); }),
        SettingsFieldBuilders.buildToggle('صالون / كوافير', extra.enableSalon,
            (v) { bloc.add(UpdateExtraUnitsSettings((e) { e.enableSalon = v; return e; })); }),
        SettingsFieldBuilders.buildToggle('مطعم', extra.enableRestaurant,
            (v) { bloc.add(UpdateExtraUnitsSettings((e) { e.enableRestaurant = v; return e; })); }),
        SettingsFieldBuilders.buildToggle('فندق', extra.enableHotel,
            (v) { bloc.add(UpdateExtraUnitsSettings((e) { e.enableHotel = v; return e; })); }),
        SettingsFieldBuilders.buildToggle('عيادة', extra.enableClinic,
            (v) { bloc.add(UpdateExtraUnitsSettings((e) { e.enableClinic = v; return e; })); }),
        SettingsFieldBuilders.buildToggle('مدرسة', extra.enableSchool,
            (v) { bloc.add(UpdateExtraUnitsSettings((e) { e.enableSchool = v; return e; })); }),
        SettingsFieldBuilders.buildToggle('مستودع', extra.enableWarehouse,
            (v) { bloc.add(UpdateExtraUnitsSettings((e) { e.enableWarehouse = v; return e; })); }),
      ],
    );
  }
}
