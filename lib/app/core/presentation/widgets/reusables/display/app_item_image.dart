import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pharmacy_system/app/core/presentation/theme/app_colors.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_images.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_sizes.dart';

class ReusableItemImage extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final double? borderRadius;
  final BoxFit fit;

  const ReusableItemImage({
    super.key,
    this.imageUrl,
    this.size = 48.0,
    this.borderRadius,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null && imageUrl!.trim().isNotEmpty;
    final radius = borderRadius ?? AppRadius.md;

    return Container(
      width: size.w,
      height: size.w, // تثبيت الـ .w للارتفاع والعرض لضمان شكل مربع مثالي
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius.r),
        border: Border.all(
          color: AppColors.borderOf(context).withValues(alpha: 0.25),
          width: 1.w,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular((radius - 1).r), // لفة ناعمة ومظبوطة هندسياً بالـ .r
        child: hasImage ? _buildImage(context) : _placeholder(context),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    // رابط إنترنت؟ نستخدم المحرك الأقوى والأسرع في الكاش والتحميل
    if (imageUrl!.startsWith('http://') || imageUrl!.startsWith('https://')) {
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        width: size.w,
        height: size.w,
        fit: fit,
        // تأثير شيمر ناعم وراقي جداً يمنح المستخدم تجربة بصرية بريميوم
        placeholder: (context, url) => Container(
          color: scheme.surfaceContainerLow,
          child: _buildShimmerLoading(scheme),
        ),
        errorWidget: (context, url, error) => _placeholder(context),
      );
    }

    // ملف محلي؟ نرفعه بأمان
    if (kIsWeb) {
      return Image.network(
        imageUrl!,
        width: size.w,
        height: size.w,
        fit: fit,
        errorBuilder: (_, _, _) => _placeholder(context),
      );
    }

    return Image.file(
      File(imageUrl!),
      width: size.w,
      height: size.w,
      fit: fit,
      errorBuilder: (_, _, _) => _placeholder(context),
    );
  }

  Widget _placeholder(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = AppColors.isDark(context);

    return Container(
      width: size.w,
      height: size.w,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            scheme.surfaceContainerLow,
            scheme.surfaceContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Image.asset(
        AppImages.itemPlaceholder,
        width: size.w,
        height: size.w,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => Center(
          child: Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: scheme.primary.withValues(alpha: isDark ? 0.12 : 0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.medication_rounded,
              size: AppIconSize.md.value,
              color: scheme.primary.withValues(alpha: 0.8),
            ),
          ),
        ),
      ),
    );
  }

  // محاكاة يدوية سريعة للشيمر لضمان خفة المكون وثبات حركته البصرية
  Widget _buildShimmerLoading(ColorScheme scheme) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                scheme.surfaceContainerLow,
                scheme.surfaceContainerHigh.withValues(alpha: 0.5),
                scheme.surfaceContainerLow,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        );
      },
    );
  }
}
