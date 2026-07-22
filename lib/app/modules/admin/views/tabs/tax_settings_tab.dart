import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_sizes.dart';
import '../../bloc/settings_bloc.dart';
import '../../../admin/services/settings_service.dart';
import './widgets_tabs/settings_shell.dart';
import './widgets_tabs/settings_builders.dart';

class TaxSettingsTab extends StatelessWidget {
  const TaxSettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final tax = SettingsService.to.settings.tax;
    return SettingsShell(
      title: 'إعدادات الضريبة',
      description: 'تحديد طريقة احتساب الضريبة ونسبتها',
      children: [
        SettingsFieldBuilders.buildDropdown('طريقة الضريبة', tax.taxMode,
            ['exclusive', 'inclusive'],
            ['غير شامل (يضاف على السعر)', 'شامل (مضمن في السعر)'],
            (v) => context.read<SettingsBloc>().add(UpdateTaxSettings((t) => t..taxMode = v!))),
        Row(
          children: [
            Expanded(
              child: SettingsFieldBuilders.buildField('نسبة الضريبة (%)',
                  tax.defaultTaxRate.toStringAsFixed(1), (v) {
                final val = double.tryParse(v) ?? 0;
                context.read<SettingsBloc>().add(UpdateTaxSettings((t) => t..defaultTaxRate = val));
              }),
            ),
            SizedBox(width: AppSpacing.md.w),
            Expanded(
              child: SettingsFieldBuilders.buildToggle('الأسعار شامل ضريبة',
                  tax.priceIncludesTax,
                  (v) => context.read<SettingsBloc>().add(UpdateTaxSettings((t) => t..priceIncludesTax = v))),
            ),
          ],
        ),
        SettingsFieldBuilders.buildToggle('إظهار الضريبة في الإيصال', tax.showTaxOnReceipt,
            (v) => context.read<SettingsBloc>().add(UpdateTaxSettings((t) => t..showTaxOnReceipt = v))),
      ],
    );
  }
}
