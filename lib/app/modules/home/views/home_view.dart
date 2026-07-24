import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/injection.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/shareds/home_shell.dart';
import '../bloc/monitoring_dashboard_bloc.dart';
import 'dashboard_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<MonitoringDashboardBloc>(),
      child: HomeShell(
        title: 'لوحة المتابعة',
        child: const DashboardView(),
      ),
    );
  }
}



