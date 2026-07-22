import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pharmacy_system/app/core/presentation/theme/app_colors.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_sizes.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/index.dart';
import 'package:pharmacy_system/app/core/constants/app_strings.dart';
import '../bloc/reports_bloc.dart';

class PurchaseReportView extends StatelessWidget {
  const PurchaseReportView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<ReportsBloc>();
    return HomeShell(
      title: ReportsStrings.reportsPurchases,
      child: Container(
        color: Theme.of(context).colorScheme.surfaceContainerLow.withValues(alpha: 0.3),
        padding: EdgeInsets.all(AppSpacing.xl.w),
        child: FutureBuilder<Map<String, dynamic>>(
          future: Future.value(controller.getPurchasesReport()),
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
    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: AppSpacing.lg.w,
      mainAxisSpacing: AppSpacing.lg.h,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        ReportCard(
          title: ReportsStrings.totalReceiptsLabel,
          value: '${data['total']}',
          color: AppColors.info,
          icon: Icons.inventory_2_outlined,
        ),
        ReportCard(
          title: ReportsStrings.totalPurchasesAmountLabel,
          value: '${(data['totalAmount'] as double).toStringAsFixed(2)} ${AppStrings.currency}',
          color: AppColors.primary,
          icon: Icons.shopping_cart_checkout_rounded,
        ),
        ReportCard(
          title: ReportsStrings.monthPurchasesLabel,
          value: '${data['month']}',
          color: AppColors.warning,
          icon: Icons.date_range_rounded,
        ),
      ],
    );
  }
}

