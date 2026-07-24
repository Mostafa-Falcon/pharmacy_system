import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_sizes.dart';
import '../../bloc/settings_bloc.dart';
import '../../../admin/services/settings_service.dart';
import './widgets_tabs/settings_shell.dart';
import './widgets_tabs/settings_builders.dart';

class EmailSettingsTab extends StatelessWidget {
  const EmailSettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final email = SettingsService.to.settings.email;
    return SettingsShell(
      title: 'إعدادات البريد الإلكتروني',
      description: 'إعدادات SMTP لإرسال الإشعارات والفواتير عبر البريد',
      children: [
        SettingsFieldBuilders.buildToggle('تفعيل البريد الإلكتروني', email.enabled,
            (v) => context.read<SettingsBloc>().add(UpdateEmailSettings((e) => e..enabled = v))),
        SettingsFieldBuilders.buildField('خادم SMTP', email.smtpHost,
            (v) => context.read<SettingsBloc>().add(UpdateEmailSettings((e) => e..smtpHost = v))),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: SettingsFieldBuilders.buildField('المنفذ (Port)',
                  email.smtpPort.toString(), (v) {
                final val = int.tryParse(v) ?? 587;
                context.read<SettingsBloc>().add(UpdateEmailSettings((e) => e..smtpPort = val));
              }),
            ),
            SizedBox(width: AppSpacing.md.w),
            Expanded(
              flex: 3,
              child: SettingsFieldBuilders.buildDropdown('نوع التشفير', email.encryption,
                  ['none', 'tls', 'ssl'],
                  ['بدون', 'TLS', 'SSL'],
                  (v) => context.read<SettingsBloc>().add(UpdateEmailSettings((e) => e..encryption = v!))),
            ),
          ],
        ),
        SettingsFieldBuilders.buildField('اسم المستخدم', email.smtpUsername,
            (v) => context.read<SettingsBloc>().add(UpdateEmailSettings((e) => e..smtpUsername = v))),
        SettingsFieldBuilders.buildField('كلمة المرور', email.smtpPassword,
            (v) => context.read<SettingsBloc>().add(UpdateEmailSettings((e) => e..smtpPassword = v))),
        SettingsFieldBuilders.buildField('بريد المرسل', email.senderEmail,
            (v) => context.read<SettingsBloc>().add(UpdateEmailSettings((e) => e..senderEmail = v))),
        SettingsFieldBuilders.buildField('اسم المرسل', email.senderName,
            (v) => context.read<SettingsBloc>().add(UpdateEmailSettings((e) => e..senderName = v))),
      ],
    );
  }
}



