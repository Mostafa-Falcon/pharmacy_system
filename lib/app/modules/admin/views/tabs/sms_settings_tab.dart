import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/settings_bloc.dart';
import '../../../admin/services/settings_service.dart';
import './widgets_tabs/settings_shell.dart';
import './widgets_tabs/settings_builders.dart';

class SmsSettingsTab extends StatelessWidget {
  const SmsSettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final sms = SettingsService.to.settings.sms;
    return SettingsShell(
      title: 'إعدادات الرسائل النصية',
      description: 'إعدادات بوابة SMS لإرسال التنبيهات والإشعارات',
      children: [
        SettingsFieldBuilders.buildToggle('تفعيل الرسائل النصية', sms.enabled,
            (v) => context.read<SettingsBloc>().add(UpdateSmsSettings((s) => s..enabled = v))),
        SettingsFieldBuilders.buildField('مزود الخدمة (Provider)', sms.provider,
            (v) => context.read<SettingsBloc>().add(UpdateSmsSettings((s) => s..provider = v))),
        SettingsFieldBuilders.buildField('رابط API', sms.apiUrl,
            (v) => context.read<SettingsBloc>().add(UpdateSmsSettings((s) => s..apiUrl = v))),
        SettingsFieldBuilders.buildField('مفتاح API', sms.apiKey,
            (v) => context.read<SettingsBloc>().add(UpdateSmsSettings((s) => s..apiKey = v))),
        SettingsFieldBuilders.buildField('اسم المرسل', sms.senderName,
            (v) => context.read<SettingsBloc>().add(UpdateSmsSettings((s) => s..senderName = v))),
      ],
    );
  }
}


