import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pharmacy_system/app/core/models/base/correction_model.dart';
import 'package:pharmacy_system/app/core/data/services/system/correction_service.dart';
import 'package:pharmacy_system/app/shared/ui_core.dart';

class CorrectionChainWidget extends StatefulWidget {
  final CorrectionReferenceType referenceType;
  final String referenceId;
  final int maxEntries;

  const CorrectionChainWidget({
    super.key,
    required this.referenceType,
    required this.referenceId,
    this.maxEntries = 20,
  });

  @override
  State<CorrectionChainWidget> createState() => _CorrectionChainWidgetState();
}

class _CorrectionChainWidgetState extends State<CorrectionChainWidget> {
  List<CorrectionEntry>? _entries;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final entries = await CorrectionService.getChain(
      referenceType: widget.referenceType,
      referenceId: widget.referenceId,
    );
    if (mounted) setState(() => _entries = entries);
  }

  @override
  Widget build(BuildContext context) {
    final entries = _entries;
    if (entries == null) return const SizedBox.shrink();

    if (entries.isEmpty) return const SizedBox.shrink();

    final display = entries.take(widget.maxEntries).toList();
    final scheme = Theme.of(context).colorScheme;
    final isDark = AppColors.isDark(context);

    return Container(
      padding: EdgeInsets.all(AppSpacing.md.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(AppRadius.lg.r),
        border: Border.all(
          color: AppColors.borderOf(
            context,
          ).withValues(alpha: isDark ? 0.25 : 0.45),
          width: 1.w,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.history_rounded, size: 18.sp, color: scheme.primary),
              SizedBox(width: AppSpacing.sm.w),
              ReusableText(
                WidgetStrings.correctionHistory,
                style: TextStyle(
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md.h),

          ...List.generate(display.length, (i) {
            final entry = display[i];
            final isLast = i == display.length - 1;
            return _ChainEntry(entry: entry, isLast: isLast);
          }),

          if (entries.length > widget.maxEntries)
            Padding(
              padding: EdgeInsetsDirectional.only(
                top: AppSpacing.sm.h,
                start: 32.w,
              ),
              child: ReusableText(
                WidgetStrings.correctionMore.replaceFirst(
                  '%s',
                  '${entries.length - widget.maxEntries}',
                ),
                style: TextStyle(
                  fontSize: 11.sp,
                  color: AppColors.textSecondaryOf(context),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ChainEntry extends StatelessWidget {
  final CorrectionEntry entry;
  final bool isLast;

  const _ChainEntry({required this.entry, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = AppColors.isDark(context);

    final (IconData icon, String label, Color color) = switch (entry.action) {
      CorrectionAction.created => (
        Icons.add_circle_rounded,
        WidgetStrings.correctionCreated,
        AppColors.success,
      ),
      CorrectionAction.modified => (
        Icons.edit_rounded,
        WidgetStrings.correctionModified,
        scheme.primary,
      ),
      CorrectionAction.voided => (
        Icons.cancel_rounded,
        WidgetStrings.correctionVoided,
        AppColors.error,
      ),
      CorrectionAction.returned => (
        Icons.currency_exchange_rounded,
        WidgetStrings.correctionReturned,
        AppColors.warning,
      ),
      CorrectionAction.paymentUpdated => (
        Icons.payment_rounded,
        WidgetStrings.correctionPaymentUpdated,
        AppColors.info,
      ),
    };

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24.w,
            child: Column(
              children: [
                Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: isDark ? 0.15 : 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 12.sp, color: color),
                ),
                if (!isLast)
                  Expanded(
                    child: VerticalDivider(
                      width: 2.w,
                      thickness: 1.2.w,
                      color: AppColors.borderOf(
                        context,
                      ).withValues(alpha: isDark ? 0.2 : 0.4),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(width: 10.w),

          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 14.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ReusableText(
                        label,
                        style: TextStyle(
                          fontSize: 12.5.sp,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      const Spacer(),
                      ReusableText(
                        _formatTime(entry.timestamp),
                        style: TextStyle(
                          fontSize: 10.5.sp,
                          color: AppColors.textSecondaryOf(context),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  ReusableText(
                    entry.userDisplayName,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimaryOf(context),
                    ),
                  ),
                  if (entry.details != null && entry.details!.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: 4.h),
                      child: ReusableText(
                        entry.details!,
                        style: TextStyle(
                          fontSize: 11.sp,
                          height: 1.35,
                          color: AppColors.textSecondaryOf(
                            context,
                          ).withValues(alpha: 0.85),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return ActivityLogStrings.activityNow;
    if (diff.inHours < 1) {
      return ActivityLogStrings.activityMinutesAgo.replaceFirst(
        '%s',
        '${diff.inMinutes}',
      );
    }
    if (diff.inDays < 1) {
      return ActivityLogStrings.activityHoursAgo.replaceFirst(
        '%s',
        '${diff.inHours}',
      );
    }
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}
