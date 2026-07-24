import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pharmacy_system/app/shared/ui_core.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/index.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    this.title,
    this.subtitle,
    required this.body,
    this.actions,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.showBackButton = true,
    this.backgroundColor,
  });

  final String? title;
  final String? subtitle;
  final Widget body;
  final List<Widget>? actions;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final bool showBackButton;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = AppColors.isDark(context);
    final appBarBg = AppColors.surfaceOf(context);

    // توحيد الحواف بـ .r لضمان استقرار بصري كامل للزرار المخصص
    final radius = BorderRadius.circular(AppRadius.sm.r);

    return Scaffold(
      backgroundColor: backgroundColor ?? AppColors.backgroundOf(context),
      appBar: title != null
          ? AppBar(
              backgroundColor: appBarBg,
              elevation: 0,
              scrolledUnderElevation: 0,
              automaticallyImplyLeading: false,

              // ضبط دقيق وشامل لشريط الحالة الفوقاني متوافق مع iOS وأندرويد بدقة كاملة
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: isDark
                    ? Brightness.light
                    : Brightness.dark, // للأندرويد
                statusBarBrightness: isDark
                    ? Brightness.dark
                    : Brightness.light, // للـ iOS
              ),

              // زرار الرجوع المخصص والمحدد الأبعاد هندسياً لمنع أي تداخل بصري
              leadingWidth: showBackButton ? 56.w : 0,
              leading: showBackButton
                  ? Center(
                      child: SizedBox(
                        width: 32.w,
                        height: 32.w, // تثبيت المقاس بشكل مربع مثالي هندسياً
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => Navigator.maybePop(context),
                            borderRadius: radius,
                            hoverColor: scheme.primary.withValues(alpha: 0.03),
                            splashColor: scheme.primary.withValues(alpha: 0.06),
                            child: Ink(
                              padding: EdgeInsets.all(6.w),
                              decoration: BoxDecoration(
                                color: scheme.primary.withValues(
                                  alpha: isDark ? 0.12 : 0.05,
                                ),
                                borderRadius: radius,
                              ),
                              child: Icon(
                                Icons.arrow_back_ios_new_rounded,
                                size:
                                    14.sp, // مقاس ناعم وعصري متناسق مع الأبعاد
                                color: scheme.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : null,

              // مسافة مريحة ومستقرة للعنوان تمنع التصاقه بالأطراف
              titleSpacing: showBackButton ? 4.w : AppSpacing.lg.w,

              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ReusableText(
                    title!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.textPrimaryOf(context),
                      fontSize: 16.sp,
                      fontWeight: FontWeight
                          .bold, // Cairo Bold المعتمد لعناوين الصفحات الرئيسية
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 2.h),
                    ReusableText(
                      subtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.textSecondaryOf(context),
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),

              // الأزرار الجانبية مع مسافات حماية هندسية من الأطراف
              actions: actions != null
                  ? [
                      ...actions!.map(
                        (action) => Padding(
                          padding: EdgeInsetsDirectional.only(end: 4.w),
                          child: action,
                        ),
                      ),
                      SizedBox(
                        width: 12.w,
                      ), // هامش الحماية الأخير من حافة الشاشة
                    ]
                  : null,

              // خط سفلي ناعم بيفصل الـ AppBar بانسيابية ومطابق للـ Spacing System
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(1.h),
                child: Container(
                  color: AppColors.borderOf(
                    context,
                  ).withValues(alpha: isDark ? 0.25 : 0.45),
                  height: 1.h,
                ),
              ),
            )
          : null,

      body: SafeArea(top: title == null, bottom: false, child: body),
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
    );
  }
}



