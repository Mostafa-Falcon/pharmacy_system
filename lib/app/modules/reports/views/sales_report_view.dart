import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pharmacy_system/app/core/constants/ui/app_colors.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_sizes.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/index.dart';
import 'package:pharmacy_system/app/core/constants/app_strings.dart';
import '../bloc/reports_bloc.dart';

class SalesReportView extends StatelessWidget {
  const SalesReportView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<ReportsBloc>();
    return HomeShell(
      title: ReportsStrings.reportsSales,
      child: Container(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerLow.withValues(alpha: 0.3),
        padding: EdgeInsets.all(AppSpacing.xl),
        child: FutureBuilder<Map<String, dynamic>>(
          future: Future.value(controller.getSalesReport()),
          builder: (_, snapshot) {
            if (!snapshot.hasData) {
              return const LoadingIndicator();
            }
            final data = snapshot.data!;
            return _buildReportCards(context, data);
          },
        ),
      ),
    );
  }

  Widget _buildReportCards(BuildContext context, Map<String, dynamic> data) {
    final scheme = Theme.of(context).colorScheme;
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 900 ? 3 : (constraints.maxWidth > 600 ? 2 : 1);
        final totalAmount = (data['totalAmount'] as num?)?.toDouble() ?? 0.0;

        return GridView.count(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: AppSpacing.lg,
          mainAxisSpacing: AppSpacing.lg,
          childAspectRatio: 1.5,
          children: [
            ReportCard(
              title: ReportsStrings.totalInvoicesCountLabel,
              value: '${data['total'] ?? 0}',
              color: scheme.primary,
              icon: Icons.receipt_long_rounded,
            ),
            ReportCard(
              title: ReportsStrings.totalSalesAmountLabel,
              value: '${totalAmount.toStringAsFixed(2)} ${GeneralStrings.currency}',
              color: AppColors.success,
              icon: Icons.attach_money_rounded,
            ),
            ReportCard(
              title: ReportsStrings.todayInvoicesLabel,
              value: '${data['today'] ?? 0}',
              color: AppColors.info,
              icon: Icons.today_rounded,
            ),
            ReportCard(
              title: ReportsStrings.monthInvoicesLabel,
              value: '${data['month'] ?? 0}',
              color: AppColors.warning,
              icon: Icons.date_range_rounded,
            ),
          ],
        );
      },
    );
  }
}





