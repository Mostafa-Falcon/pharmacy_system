import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_system/app/shared/ui_core.dart';

class AuthLayout extends StatelessWidget {
  final Widget child;
  final String title;
  final String subtitle;
  final IconData promoIcon;
  final String promoTitle;
  final String promoSubtitle;
  final List<Color>? promoGradient;
  final bool showBackButton;

  const AuthLayout({
    super.key,
    required this.child,
    required this.title,
    required this.subtitle,
    this.promoIcon = Icons.local_pharmacy_rounded,
    this.promoTitle = AuthStrings.promoTitleDefault,
    this.promoSubtitle = AuthStrings.promoSubtitleDefault,
    this.promoGradient,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWeb = size.width >= 900;
    final scheme = Theme.of(context).colorScheme;

    return AppScaffold(
      showBackButton: showBackButton,
      body: Row(
        children: [
          if (isWeb)
            Expanded(
              flex: 10,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: promoGradient ?? [scheme.primary, scheme.tertiary],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(40.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          promoIcon,
                          size: 80.sp,
                          color: Colors.white,
                        ),
                        SizedBox(height: 24.h),
                        ReusableText(
                          promoTitle,
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        ReusableText(
                          promoSubtitle,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          Expanded(
            flex: 8,
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(32.w),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 420.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ReusableText.h2(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: AppSpacing.xs.h),
                      ReusableText.caption(
                        subtitle,
                      ),
                      SizedBox(height: AppSpacing.xl.h),
                      child,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
