import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_system/app/modules/admin/models/settings_model.dart';
import '../../bloc/settings_bloc.dart';
import './widgets_tabs/settings_shell.dart';
import './widgets_tabs/settings_builders.dart';

class ShortcutsSettingsTab extends StatelessWidget {
  const ShortcutsSettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final shortcuts = context.select<SettingsBloc, ShortcutsSettings>(
        (bloc) => bloc.state.settings.shortcuts);
    final bloc = context.read<SettingsBloc>();
    return SettingsShell(
      title: 'اختصارات المستندات',
      description: 'البادئات المستخدمة في ترميز المستندات والفواتير',
      children: [
        SettingsFieldBuilders.buildField('أمر شراء (PO)', shortcuts.purchaseOrder,
            (v) { bloc.add(UpdateShortcutsSettings((s) { s.purchaseOrder = v; return s; })); }),
        SettingsFieldBuilders.buildField('إشعار دائن (CN)', shortcuts.creditNote,
            (v) { bloc.add(UpdateShortcutsSettings((s) { s.creditNote = v; return s; })); }),
        SettingsFieldBuilders.buildField('تحويل مخزون (ST)', shortcuts.stockTransfer,
            (v) { bloc.add(UpdateShortcutsSettings((s) { s.stockTransfer = v; return s; })); }),
        SettingsFieldBuilders.buildField('فاتورة بيع (SI)', shortcuts.salesInvoice,
            (v) { bloc.add(UpdateShortcutsSettings((s) { s.salesInvoice = v; return s; })); }),
        SettingsFieldBuilders.buildField('مرتجع مشتريات (PR)', shortcuts.purchaseReturn,
            (v) { bloc.add(UpdateShortcutsSettings((s) { s.purchaseReturn = v; return s; })); }),
        SettingsFieldBuilders.buildField('مرتجع مبيعات (SR)', shortcuts.salesReturn,
            (v) { bloc.add(UpdateShortcutsSettings((s) { s.salesReturn = v; return s; })); }),
        SettingsFieldBuilders.buildField('عرض سعر (QT)', shortcuts.quotation,
            (v) { bloc.add(UpdateShortcutsSettings((s) { s.quotation = v; return s; })); }),
        SettingsFieldBuilders.buildField('تسوية مخزون (SA)', shortcuts.stockAdjustment,
            (v) { bloc.add(UpdateShortcutsSettings((s) { s.stockAdjustment = v; return s; })); }),
      ],
    );
  }
}
