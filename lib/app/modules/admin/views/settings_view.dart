import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_system/app/core/injection.dart';

import 'package:pharmacy_system/app/shared/presentation/design_system/screen_tier.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/index.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_sizes.dart';
import 'package:pharmacy_system/app/core/data/services/sound_service.dart';
import 'package:pharmacy_system/app/core/data/services/print_settings_service.dart';
import '../../../core/constants/app_strings.dart';
import '../bloc/settings_bloc.dart';
import '../data/settings_tabs_data.dart';
import 'tabs/project_settings_tab.dart';
import 'tabs/tax_settings_tab.dart';
import 'tabs/items_settings_tab.dart';
import 'tabs/sales_settings_tab.dart';
import 'tabs/system_settings_tab.dart';
import 'tabs/email_settings_tab.dart';
import 'tabs/sms_settings_tab.dart';
import 'tabs/rewards_settings_tab.dart';
import 'tabs/shortcuts_settings_tab.dart';
import 'tabs/extra_units_settings_tab.dart';
import 'tabs/invoice_layout_settings_tab.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<SettingsBloc>(),
      child: const _SettingsBody(),
    );
  }
}

class _SettingsBody extends StatelessWidget {
  const _SettingsBody();

  @override
  Widget build(BuildContext context) {
    final isWide = ScreenTierResolver.isDesktop(context);
    final scheme = Theme.of(context).colorScheme;

    return HomeShell(
      title: AdminStrings.adminSettings,
      subtitle: AdminStrings.adminSettingsSubtitle,
      child: Container(
        color: scheme.surfaceContainerLow.withValues(alpha: 0.15),
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            if (state.status == SettingsStatus.loading &&
                state.activeTab == 'project') {
              return const LoadingIndicator();
            }
            return Padding(
              padding: EdgeInsets.all(AppSpacing.lg.w),
              child: isWide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _TabSelector(width: 260.w),
                        SizedBox(width: AppSpacing.lg.w),
                        Expanded(child: _TabContent()),
                      ],
                    )
                  : Column(
                      children: [
                        _TabSelector(width: double.infinity),
                        SizedBox(height: AppSpacing.md.h),
                        Expanded(child: _TabContent()),
                      ],
                    ),
            );
          },
        ),
      ),
    );
  }
}

class _TabSelector extends StatelessWidget {
  final double width;

  const _TabSelector({required this.width});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bloc = context.read<SettingsBloc>();
    return SizedBox(
      width: width,
      child: AppCard(
        padding: EdgeInsets.all(AppSpacing.sm.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(AppSpacing.xs.w),
              child: ReusableInput(
                hint: AdminStrings.adminSearchSettings,
                prefixIcon: const Icon(Icons.search_rounded, size: 20),
                onChanged: (value) => bloc.add(SetSearchQuery(value)),
                textDirection: TextDirection.rtl,
              ),
            ),
            SizedBox(height: AppSpacing.xs.h),
            SizedBox(
              height: width > 300 ? null : 220.h,
              child: ListView(
                shrinkWrap: true,
                physics: width > 300
                    ? const NeverScrollableScrollPhysics()
                    : const BouncingScrollPhysics(),
                children: settingsTabs
                    .where((tab) => _matchesSearch(context, tab))
                    .map((tab) {
                      final active = _activeTab(context) == tab.id;
                      return Padding(
                        padding: EdgeInsets.only(bottom: 4.h),
                        child: Material(
                          color: active ? scheme.primary : Colors.transparent,
                          borderRadius: BorderRadius.circular(AppRadius.md.r),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(AppRadius.md.r),
                            onTap: () => bloc.add(SetActiveTab(tab.id)),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 12.h,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    tab.icon,
                                    size: 18.sp,
                                    color: active
                                        ? scheme.onPrimary
                                        : scheme.onSurfaceVariant,
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: ReusableText(
                                      tab.label,
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: active
                                            ? FontWeight.bold
                                            : FontWeight.w500,
                                        color: active
                                            ? scheme.onPrimary
                                            : scheme.onSurface,
                                      ),
                                    ),
                                  ),
                                  if (active)
                                    Icon(
                                      Icons.chevron_left_rounded,
                                      size: 16.sp,
                                      color: scheme.onPrimary,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    })
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _activeTab(BuildContext context) {
    return context.select<SettingsBloc, String>((bloc) => bloc.state.activeTab);
  }

  bool _matchesSearch(BuildContext context, SettingsTab tab) {
    final query = context
        .select<SettingsBloc, String>((bloc) => bloc.state.searchQuery)
        .trim()
        .toLowerCase();
    if (query.isEmpty) return true;
    return tab.label.toLowerCase().contains(query) ||
        tab.keywords.any((k) => k.contains(query));
  }
}

class _TabContent extends StatelessWidget {
  const _TabContent();

  @override
  Widget build(BuildContext context) {
    final tabId = context.select<SettingsBloc, String>(
      (bloc) => bloc.state.activeTab,
    );
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          _buildTabBody(tabId),
          SizedBox(height: AppSpacing.md.h),
          const _LegacySections(),
        ],
      ),
    );
  }

  Widget _buildTabBody(String tabId) {
    switch (tabId) {
      case 'project':
        return const ProjectSettingsTab();
      case 'tax':
        return const TaxSettingsTab();
      case 'items':
        return const ItemsSettingsTab();
      case 'sales':
        return const SalesSettingsTab();
      case 'system':
        return const SystemSettingsTab();
      case 'email':
        return const EmailSettingsTab();
      case 'sms':
        return const SmsSettingsTab();
      case 'rewards':
        return const RewardsSettingsTab();
      case 'shortcuts':
        return const ShortcutsSettingsTab();
      case 'extraUnits':
        return const ExtraUnitsSettingsTab();
      case 'invoiceLayout':
        return const InvoiceLayoutSettingsTab();
      default:
        return const ProjectSettingsTab();
    }
  }
}

class _LegacySections extends StatefulWidget {
  const _LegacySections();

  @override
  State<_LegacySections> createState() => _LegacySectionsState();
}

class _LegacySectionsState extends State<_LegacySections> {
  bool _systemSounds = false;
  bool _autoPrint = false;

  @override
  void initState() {
    super.initState();
    _systemSounds = SoundService.instance.enabled;
    _autoPrint = PrintSettingsService.isPrintEnabled;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSection(
          title: AdminStrings.adminQuickControl,
          children: [
            _buildSwitchTile(
              AdminStrings.adminEnableSounds,
              'system_sounds',
              Icons.volume_up_rounded,
              _systemSounds,
              (v) {
                setState(() => _systemSounds = v);
                SoundService.instance.enabled = v;
              },
            ),
            _buildSwitchTile(
              AdminStrings.adminAutoPrint,
              'auto_print',
              Icons.print_rounded,
              _autoPrint,
              (v) {
                setState(() => _autoPrint = v);
                PrintSettingsService.isPrintEnabled = v;
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(icon: Icons.settings_suggest_rounded, title: title),
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(children: children),
        ),
        SizedBox(height: AppSpacing.lg.h),
      ],
    );
  }

  Widget _buildSwitchTile(
    String title,
    String key,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return SettingsToggleTile(
      title: title,
      icon: icon,
      value: value,
      onChanged: onChanged,
    );
  }
}





