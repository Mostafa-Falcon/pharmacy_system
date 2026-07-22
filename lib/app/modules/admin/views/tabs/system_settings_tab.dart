import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/settings_bloc.dart';
import '../../../admin/services/settings_service.dart';
import './widgets_tabs/settings_shell.dart';
import './widgets_tabs/settings_builders.dart';

class SystemSettingsTab extends StatelessWidget {
  const SystemSettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final system = SettingsService.to.settings.system;
    return SettingsShell(
      title: 'إعدادات النظام',
      description: 'لغة النظام، الجلسات، النسخ الاحتياطي وسجل النشاطات',
      children: [
        SettingsFieldBuilders.buildDropdown('لغة النظام', system.language,
            ['ar', 'en'],
            ['العربية', 'English'],
            (v) => context.read<SettingsBloc>().add(UpdateSystemSettings((s) => s..language = v!))),
        SettingsFieldBuilders.buildField('عدد الصفوف الافتراضي في الجداول',
            system.defaultTableRows.toString(), (v) {
          final val = int.tryParse(v) ?? 50;
          context.read<SettingsBloc>().add(UpdateSystemSettings((s) => s..defaultTableRows = val));
        }),
        SettingsFieldBuilders.buildField('مدة انتهاء الجلسة (بالدقائق)',
            system.sessionTimeoutMinutes.toString(), (v) {
          final val = int.tryParse(v) ?? 120;
          context.read<SettingsBloc>().add(UpdateSystemSettings((s) => s..sessionTimeoutMinutes = val));
        }),
        SettingsFieldBuilders.buildToggle('إظهار نصوص المساعدة', system.showHelpText,
            (v) => context.read<SettingsBloc>().add(UpdateSystemSettings((s) => s..showHelpText = v))),
        SettingsFieldBuilders.buildToggle('تفعيل سجل النشاطات (Audit Log)',
            system.enableAuditLog,
            (v) => context.read<SettingsBloc>().add(UpdateSystemSettings((s) => s..enableAuditLog = v))),
        SettingsFieldBuilders.buildToggle('التخزين المؤقت للاستخدام دون اتصال',
            system.enableOfflineCache,
            (v) => context.read<SettingsBloc>().add(UpdateSystemSettings((s) => s..enableOfflineCache = v))),
        SettingsFieldBuilders.buildToggle('النسخ الاحتياطي التلقائي', system.enableAutoBackup,
            (v) => context.read<SettingsBloc>().add(UpdateSystemSettings((s) => s..enableAutoBackup = v))),
      ],
    );
  }
}
