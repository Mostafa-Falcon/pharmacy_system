import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pharmacy_system/app/core/models/base/correction_model.dart';
import 'package:pharmacy_system/app/core/data/services/accounting/correction_service.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_colors.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_sizes.dart';
import '../../../core/utils/format_utils.dart';
import '../../../core/constants/strings/activity_log_strings.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/index.dart';

class ActivityLogView extends StatefulWidget {
  const ActivityLogView({super.key});

  @override
  State<ActivityLogView> createState() => _ActivityLogViewState();
}

class _ActivityLogViewState extends State<ActivityLogView> {
  var _entries = <CorrectionEntry>[];
  var _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final entries = await CorrectionService.getAll(limit: 200);
    setState(() {
      _entries = entries;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return HomeShell(
      title: ActivityLogStrings.activityTitle,
      child: _isLoading
          ? const LoadingIndicator()
          : _entries.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.history_rounded, size: 48.sp, color: Colors.grey.shade300),
                      SizedBox(height: 8.h),
                      ReusableText(ActivityLogStrings.activityEmpty,
                          style: TextStyle(fontSize: 14.sp, color: Colors.grey)),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async => _load(),
                  child: ListView.separated(
                    padding: EdgeInsets.all(AppSpacing.md.w),
                    itemCount: _entries.length,
                    separatorBuilder: (_, _) => SizedBox(height: 6.h),
                    itemBuilder: (_, i) => _buildEntry(_entries[i]),
                  ),
                ),
    );
  }

  String _relativeTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return ActivityLogStrings.activityNow;
    if (diff.inMinutes < 60) return ActivityLogStrings.activityMinutesAgo.replaceAll('%s', '${diff.inMinutes}');
    if (diff.inHours < 24) return ActivityLogStrings.activityHoursAgo.replaceAll('%s', '${diff.inHours}');
    if (diff.inDays < 7) return ActivityLogStrings.activityDaysAgo.replaceAll('%s', '${diff.inDays}');
    return FormatUtils.date(dt);
  }

  Widget _buildEntry(CorrectionEntry entry) {
    final (icon, color) = switch (entry.action) {
      CorrectionAction.created => (Icons.add_circle_outline, AppColors.success),
      CorrectionAction.modified => (Icons.edit_outlined, AppColors.info),
      CorrectionAction.voided => (Icons.cancel_outlined, AppColors.error),
      CorrectionAction.returned => (Icons.restore_outlined, Colors.amber.shade700),
      CorrectionAction.paymentUpdated => (Icons.payment_outlined, Colors.blue.shade600),
    };

    final typeLabel = switch (entry.referenceType) {
      CorrectionReferenceType.sale => ActivityLogStrings.typeSale,
      CorrectionReferenceType.purchase => ActivityLogStrings.typePurchase,
      CorrectionReferenceType.saleReturn => ActivityLogStrings.typeSaleReturn,
      CorrectionReferenceType.purchaseReturn => ActivityLogStrings.typePurchaseReturn,
      CorrectionReferenceType.shift => ActivityLogStrings.typeShift,
    };

    final actionLabel = switch (entry.action) {
      CorrectionAction.created => ActivityLogStrings.actionCreated,
      CorrectionAction.modified => ActivityLogStrings.actionModified,
      CorrectionAction.voided => ActivityLogStrings.actionVoided,
      CorrectionAction.returned => ActivityLogStrings.actionReturned,
      CorrectionAction.paymentUpdated => ActivityLogStrings.actionPaymentUpdated,
    };

    return AppCard(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.12),
          radius: 18.r,
          child: Icon(icon, color: color, size: 18.sp),
        ),
        title: ReusableText('$actionLabel $typeLabel',
            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (entry.details != null && entry.details!.isNotEmpty)
              ReusableText(entry.details!, style: TextStyle(fontSize: 10.sp, color: Colors.grey.shade600)),
            ReusableText(entry.userDisplayName,
                style: TextStyle(fontSize: 9.sp, color: Colors.grey.shade400)),
          ],
        ),
        trailing: ReusableText(
          _relativeTime(entry.timestamp),
          style: TextStyle(fontSize: 9.sp, color: Colors.grey.shade400),
        ),
      ),
    );
  }
}



