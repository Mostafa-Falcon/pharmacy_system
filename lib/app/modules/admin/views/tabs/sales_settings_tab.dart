import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/settings_bloc.dart';
import '../../../admin/services/settings_service.dart';
import './widgets_tabs/settings_shell.dart';
import './widgets_tabs/settings_builders.dart';

class SalesSettingsTab extends StatelessWidget {
  const SalesSettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final sales = SettingsService.to.settings.sales;
    return SettingsShell(
      title: 'إعدادات البيع',
      description: 'التحكم في سياسات البيع والخصم',
      children: [
        SettingsFieldBuilders.buildToggle('تمكين الخصم', sales.enableDiscount,
            (v) => context.read<SettingsBloc>().add(UpdateSalesSettings((s) => s..enableDiscount = v))),
        SettingsFieldBuilders.buildField('أقصى نسبة خصم (%)',
            sales.maxDiscountPercent.toStringAsFixed(1), (v) {
          final val = double.tryParse(v) ?? 0;
          context.read<SettingsBloc>().add(UpdateSalesSettings((s) => s..maxDiscountPercent = val));
        }),
        SettingsFieldBuilders.buildToggle('طلب موافقة على الخصم',
            sales.requireDiscountApproval,
            (v) => context.read<SettingsBloc>().add(UpdateSalesSettings((s) => s..requireDiscountApproval = v))),
        SettingsFieldBuilders.buildToggle('البيع بالآجل (تقسيط)', sales.enableCreditSales,
            (v) => context.read<SettingsBloc>().add(UpdateSalesSettings((s) => s..enableCreditSales = v))),
        SettingsFieldBuilders.buildToggle('الدفع المختلط', sales.enableMixedPayment,
            (v) => context.read<SettingsBloc>().add(UpdateSalesSettings((s) => s..enableMixedPayment = v))),
        SettingsFieldBuilders.buildToggle('إظهار تاريخ السعر', sales.showPriceHistory,
            (v) => context.read<SettingsBloc>().add(UpdateSalesSettings((s) => s..showPriceHistory = v))),
        SettingsFieldBuilders.buildDropdown('نوع البيع الافتراضي', sales.defaultSaleType,
            ['cash', 'card', 'credit'],
            ['نقدي', 'بطاقة', 'آجل'],
            (v) => context.read<SettingsBloc>().add(UpdateSalesSettings((s) => s..defaultSaleType = v!))),
      ],
    );
  }
}
