import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_sizes.dart';
import '../../bloc/settings_bloc.dart';
import '../../../admin/services/settings_service.dart';
import './widgets_tabs/settings_shell.dart';
import './widgets_tabs/settings_builders.dart';

class RewardsSettingsTab extends StatelessWidget {
  const RewardsSettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final rewards = SettingsService.to.settings.rewards;
    return SettingsShell(
      title: 'نقاط المكافآت وولاء العملاء',
      description: 'إعدادات برنامج نقاط المكافآت للعملاء',
      children: [
        SettingsFieldBuilders.buildToggle('تفعيل نظام المكافآت', rewards.enabled,
            (v) => context.read<SettingsBloc>().add(UpdateRewardsSettings((r) => r..enabled = v))),
        Row(
          children: [
            Expanded(
              child: SettingsFieldBuilders.buildField('نقاط لكل (مبلغ)',
                  rewards.pointsPerAmount.toStringAsFixed(1), (v) {
                final val = double.tryParse(v) ?? 10;
                context.read<SettingsBloc>().add(UpdateRewardsSettings((r) => r..pointsPerAmount = val));
              }),
            ),
            SizedBox(width: AppSpacing.md.w),
            Expanded(
              child: SettingsFieldBuilders.buildField('قيمة النقطة الواحدة',
                  rewards.amountPerPoint.toStringAsFixed(2), (v) {
                final val = double.tryParse(v) ?? 1;
                context.read<SettingsBloc>().add(UpdateRewardsSettings((r) => r..amountPerPoint = val));
              }),
            ),
          ],
        ),
        SettingsFieldBuilders.buildField('أيام انتهاء صلاحية النقاط',
            rewards.expiryDays.toString(), (v) {
          final val = int.tryParse(v) ?? 365;
          context.read<SettingsBloc>().add(UpdateRewardsSettings((r) => r..expiryDays = val));
        }),
        SettingsFieldBuilders.buildToggle('السماح بالاستبدال الجزئي',
            rewards.allowPartialRedeem,
            (v) => context.read<SettingsBloc>().add(UpdateRewardsSettings((r) => r..allowPartialRedeem = v))),
      ],
    );
  }
}



