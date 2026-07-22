import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_colors.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/index.dart';

class SettingsShell extends StatelessWidget {
  final String title;
  final String description;
  final List<Widget> children;

  const SettingsShell({
    super.key,
    required this.title,
    required this.description,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ReusableText(
                title,
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4.h),
              ReusableText(
                description,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondaryOf(context),
                ),
              ),
            ],
          ),
        ),
        AppCard(
          padding: EdgeInsets.all(16.w),
          child: Column(children: children),
        ),
      ],
    );
  }
}
