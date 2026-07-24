import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/settings_bloc.dart';
import '../../../admin/services/settings_service.dart';
import './widgets_tabs/settings_shell.dart';
import './widgets_tabs/settings_builders.dart';

class ProjectSettingsTab extends StatelessWidget {
  const ProjectSettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SettingsBloc>();
    final project = SettingsService.to.settings.project;
    return SettingsShell(
      title: 'بيانات المشروع',
      description: 'البيانات الأساسية للصيدلية',
      children: [
        SettingsFieldBuilders.buildField('اسم الصيدلية', project.pharmacyName, (v) => bloc.add(UpdateProjectSettings((p) => p..pharmacyName = v))),
        SettingsFieldBuilders.buildField('الاسم بالإنجليزية', project.pharmacyNameEn, (v) => bloc.add(UpdateProjectSettings((p) => p..pharmacyNameEn = v))),
        SettingsFieldBuilders.buildField('العملة', project.currency, (v) => bloc.add(UpdateProjectSettings((p) => p..currency = v))),
        SettingsFieldBuilders.buildDropdown('طريقة التسعير', project.costingMethod,
            ['weighted_average', 'fifo', 'lifo', 'manual'],
            ['متوسط مرجح', 'وارد أولاً', 'وارد أخيراً', 'يدوي'],
            (v) => bloc.add(UpdateProjectSettings((p) => p..costingMethod = v!))),
        SettingsFieldBuilders.buildField('الرقم الضريبي', project.taxNumber ?? '', (v) => bloc.add(UpdateProjectSettings((p) => p..taxNumber = v))),
        SettingsFieldBuilders.buildField('السجل التجاري', project.commercialRegister ?? '', (v) => bloc.add(UpdateProjectSettings((p) => p..commercialRegister = v))),
      ],
    );
  }
}


