import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pharmacy_system/app/shared/ui_core.dart';

import '../display/app_text.dart';

class SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color? color;

  const SectionHeader({
    super.key,
    required this.icon,
    required this.title,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = AppColors.isDark(context);

    // سحب لون الهوية بذكاء من الثيم الديناميكي
    final activeColor = color ?? scheme.primary;

    return Padding(
      // مسافات منسقة تمنع الاختناق البصري ومطابقة للـ Spacing System
      padding: EdgeInsets.only(top: 16.h, bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center, // سنترة عمودية مثالية هندسياً
        children: [
          // الـ Indicator الرأسي الأنيق
          Container(
            width: 4.w,
            height: 16.0, // ترك الارتفاع ثابت بدون .h لمنع تمدد المؤشر عشوائياً ولضمان توازيه مع الخط
            decoration: BoxDecoration(
              color: activeColor,
              borderRadius: BorderRadius.circular(AppRadius.sm.r), // توحيد الحواف بـ .r
              boxShadow: [
                BoxShadow(
                  color: activeColor.withValues(alpha: 0.25),
                  blurRadius: 4,
                  offset: const Offset(1, 0),
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),

          // الأيقونة المبهجة بلون القسم
          Icon(
            icon,
            size: AppIconSize.md.value,
            color: activeColor,
          ),
          SizedBox(width: 8.w),

          // النص الموحد الفخم بخط القاهرة الجريء
          AppText(
            title,
            style: AppTextStyles.body(context).copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimaryOf(context),
            ),
          ),
          SizedBox(width: 12.w),

          // الـ Divider الانسيابي المتدرج بذكاء يدعم الـ RTL والـ LTR تلقائياً
          Expanded(
            child: Container(
              height: 1.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.borderOf(context).withValues(alpha: isDark ? 0.25 : 0.45), // بيبدأ ناعم ومتناسق
                    AppColors.borderOf(context).withValues(alpha: 0.0), // وبيختفي في الهوا بنعومة كاملة
                  ],
                  // استخدام الاتجاهات الديناميكية (Directional) لثبات هندسي في اللغة العربية
                  begin: AlignmentDirectional.centerStart,
                  end: AlignmentDirectional.centerEnd,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



