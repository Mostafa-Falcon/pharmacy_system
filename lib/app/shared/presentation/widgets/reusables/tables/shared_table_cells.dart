import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_system/app/shared/ui_core.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/index.dart';

/// صندوق أيقونة مميز للاستخدام داخل خلايا الجدول [TableIconBox].
class TableIconBox extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;

  const TableIconBox({
    super.key,
    required this.icon,
    required this.color,
    this.size = 18,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Icon(
        icon,
        size: size.sp,
        color: color,
      ),
    );
  }
}

/// خلية عرض هوية جهة التعامل (أيقونة + اسم + وصف) [TableContactNameCell].
class TableContactNameCell extends StatelessWidget {
  final String name;
  final String? subtitle;
  final IconData icon;
  final Color iconColor;

  const TableContactNameCell({
    super.key,
    required this.name,
    this.subtitle,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TableIconBox(icon: icon, color: iconColor),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ReusableText(
                name,
                style: AppTextStyles.bodyBold(context).copyWith(fontSize: 13.sp),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (subtitle != null && subtitle!.isNotEmpty)
                Text(
                  subtitle!,
                  style: AppTextStyles.caption(context).copyWith(
                    fontSize: 11.sp,
                    color: scheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// خلية عرض المبالغ المالية والعملات داخل الجدول [TableMoneyCell].
class TableMoneyCell extends StatelessWidget {
  final double amount;
  final String currency;
  final bool isNegative;
  final bool isHighlight;

  const TableMoneyCell({
    super.key,
    required this.amount,
    required this.currency,
    this.isNegative = false,
    this.isHighlight = true,
  });

  @override
  Widget build(BuildContext context) {
    final color = isNegative ? AppColors.error : AppColors.success;
    
    return ReusableText(
      '${amount.toStringAsFixed(0)} $currency',
      style: AppTextStyles.caption(context).copyWith(
        fontWeight: isHighlight ? FontWeight.w700 : FontWeight.w500,
        color: isHighlight ? color : null,
      ),
    );
  }
}

/// زر خيارات موحد لصفوف الجدول [TableOptionsButton].
class TableOptionsButton extends StatelessWidget {
  final List<PopupMenuItem<String>> menuItems;
  final ValueChanged<String> onSelected;
  final String label;

  const TableOptionsButton({
    super.key,
    required this.menuItems,
    required this.onSelected,
    this.label = 'خيارات',
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return PopupMenuButton<String>(
      offset: const Offset(0, 36),
      onSelected: onSelected,
      itemBuilder: (_) => menuItems,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.button),
          border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.5)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ReusableText(
              label,
              style: AppTextStyles.caption(context).copyWith(
                fontWeight: FontWeight.bold,
                color: scheme.primary,
              ),
            ),
            SizedBox(width: 4.w),
            Icon(Icons.more_vert_rounded, size: 14.sp, color: scheme.primary),
          ],
        ),
      ),
    );
  }
}



