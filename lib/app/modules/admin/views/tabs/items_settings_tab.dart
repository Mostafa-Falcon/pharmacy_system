import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_sizes.dart';
import 'package:pharmacy_system/app/modules/admin/models/settings_model.dart';
import '../../bloc/settings_bloc.dart';
import './widgets_tabs/settings_shell.dart';
import './widgets_tabs/settings_builders.dart';

class ItemsSettingsTab extends StatelessWidget {
  const ItemsSettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final items = context.select<SettingsBloc, ItemsSettings>(
        (bloc) => bloc.state.settings.items);
    final bloc = context.read<SettingsBloc>();
    return SettingsShell(
      title: 'إعدادات الأصناف',
      description: 'التحكم في تتبع الصلاحية والكميات',
      children: [
        SettingsFieldBuilders.buildToggle('تتبع تاريخ الصلاحية', items.enableExpiryTracking,
            (v) { bloc.add(UpdateItemsSettings((i) { i.enableExpiryTracking = v; return i; })); }),
        SettingsFieldBuilders.buildToggle('تتبع رقم التشغيلة (Batch)', items.enableBatchTracking,
            (v) { bloc.add(UpdateItemsSettings((i) { i.enableBatchTracking = v; return i; })); }),
        SettingsFieldBuilders.buildToggle('الوحدات المتعددة', items.enableUnits,
            (v) { bloc.add(UpdateItemsSettings((i) { i.enableUnits = v; return i; })); }),
        SettingsFieldBuilders.buildToggle('باركود متعدد', items.enableMultipleBarcodes,
            (v) { bloc.add(UpdateItemsSettings((i) { i.enableMultipleBarcodes = v; return i; })); }),
        Row(
          children: [
            Expanded(
              child: SettingsFieldBuilders.buildField('حد المخزون المنخفض',
                  items.lowStockThreshold.toString(), (v) {
                final val = int.tryParse(v) ?? 10;
                bloc.add(UpdateItemsSettings((i) { i.lowStockThreshold = val; return i; }));
              }),
            ),
            SizedBox(width: AppSpacing.md.w),
            Expanded(
              child: SettingsFieldBuilders.buildField('أيام ما قبل انتهاء الصلاحية',
                  items.nearExpiryDays.toString(), (v) {
                final val = int.tryParse(v) ?? 30;
                bloc.add(UpdateItemsSettings((i) { i.nearExpiryDays = val; return i; }));
              }),
            ),
          ],
        ),
      ],
    );
  }
}



