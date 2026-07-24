// views/document_control_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/index.dart';
import 'package:pharmacy_system/app/core/models/base/correction_model.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_colors.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_sizes.dart';
import '../../../core/constants/strings/admin_strings.dart';
import 'package:pharmacy_system/app/core/data/services/accounting/correction_service.dart';

class DocumentControlView extends StatelessWidget {
  const DocumentControlView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return HomeShell(
      title: AdminStrings.docControlTitle,
      subtitle: AdminStrings.docControlSubtitle,
      child: Container(
        color: scheme.surfaceContainerLow.withValues(alpha: 0.3),
        padding: EdgeInsets.all(AppSpacing.xl.w),
        child: Column(
          children: [
            _buildHeader(context, scheme),
            SizedBox(height: AppSpacing.lg.h),
            Expanded(child: _buildCorrectionsList(context, scheme)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ColorScheme scheme) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: AppColors.info.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppRadius.md.r),
          ),
          child: Icon(Icons.assignment_outlined, color: AppColors.info, size: 24.sp), // تعديل للـ .sp لثبات الأبعاد
        ),
        SizedBox(width: AppSpacing.md.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(AdminStrings.docControlHeader, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
              SizedBox(height: 4.h),
              AppText(AdminStrings.docControlHeaderSubtitle, style: TextStyle(fontSize: 12.sp, color: scheme.onSurfaceVariant)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCorrectionsList(BuildContext context, ColorScheme scheme) {
    return FutureBuilder<List<CorrectionEntry>>(
      future: _loadCorrections(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingIndicator();
        }

        final corrections = snapshot.data ?? [];

        if (corrections.isEmpty) {
          return AppStateView.empty(
            icon: Icons.assignment_outlined,
            title: AdminStrings.docControlEmpty,
          );
        }

        return ListView.separated(
          itemCount: corrections.length,
          physics: const BouncingScrollPhysics(),
          separatorBuilder: (_, _) => SizedBox(height: AppSpacing.sm.h),
          itemBuilder: (_, i) {
            final correction = corrections[i];
            return AppCard(
              padding: EdgeInsets.zero,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: _getActionColor(correction.action).withValues(alpha: 0.15),
                  child: Icon(_getActionIcon(correction.action), color: _getActionColor(correction.action), size: 18.sp),
                ),
                title: AppText(
                  _getActionLabel(correction.action),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText('${correction.referenceType.name} | ${correction.details ?? ''}', style: TextStyle(fontSize: 11.sp, color: scheme.onSurfaceVariant)),
                    SizedBox(height: 2.h),
                    AppText('${correction.timestamp.day}/${correction.timestamp.month}/${correction.timestamp.year} - الموظف: ${correction.userDisplayName}', style: TextStyle(fontSize: 10.sp, color: scheme.onSurfaceVariant.withValues(alpha: 0.7))),
                  ],
                ),
                trailing: Icon(Icons.chevron_left_rounded, color: scheme.onSurfaceVariant.withValues(alpha: 0.5), size: 20.sp),
              ),
            );
          },
        );
      },
    );
  }

  Future<List<CorrectionEntry>> _loadCorrections() async {
    try {
      return await CorrectionService.getAll();
    } catch (e) {
      return [];
    }
  }

  Color _getActionColor(CorrectionAction action) => switch (action) {
    CorrectionAction.created => AppColors.success,
    CorrectionAction.modified => AppColors.info,
    CorrectionAction.voided => AppColors.error,
    CorrectionAction.returned => AppColors.warning,
    CorrectionAction.paymentUpdated => AppColors.info,
  };

  IconData _getActionIcon(CorrectionAction action) => switch (action) {
    CorrectionAction.created => Icons.add_circle_rounded,
    CorrectionAction.modified => Icons.edit_rounded,
    CorrectionAction.voided => Icons.cancel_rounded,
    CorrectionAction.returned => Icons.undo_rounded,
    CorrectionAction.paymentUpdated => Icons.payments_rounded,
  };

  String _getActionLabel(CorrectionAction action) => switch (action) {
    CorrectionAction.created => AdminStrings.docActionCreated,
    CorrectionAction.modified => AdminStrings.docActionModified,
    CorrectionAction.voided => AdminStrings.docActionCancelled,
    CorrectionAction.returned => AdminStrings.docActionRestored,
    CorrectionAction.paymentUpdated => AdminStrings.docActionPaymentModified,
  };
}



