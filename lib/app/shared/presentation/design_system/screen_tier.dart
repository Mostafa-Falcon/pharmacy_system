import 'package:flutter/material.dart';

/// تصنيف الجهاز بناءً على عرض الشاشة (مش المنصة).
///
/// بنقاط التوقف (Bootstrap 5):
/// md = 768 للتابلت، lg = 992 للديسكتوب.
enum ScreenTier { mobile, tablet, desktop }

/// كاشف الجهاز — كل المنطق في الكور، متستخدمش جوه الـ views.
///
/// الاستخدام في أي حتة: [ScreenTierResolver.of] أو [ScreenTierResolver.isDesktop].
class ScreenTierResolver {
  const ScreenTierResolver._();

  /// نقاط التوقف (متطابقة مع README و Bootstrap 5):
  /// md = 768 للتابلت، lg = 992 للديسكتوب.
  static const double md = 768.0; // تابلت
  static const double lg = 992.0; // ديسكتوب

  /// يحدد الـ tier بناءً على عرض الشاشة الحالي بأعلى كفاءة بصرية.
  static ScreenTier of(BuildContext context) {
    // استخدام sizeOf المطور لمنع الـ Rebuild العشوائي للشاشات وحماية أداء البروسيسور
    final width = MediaQuery.sizeOf(context).width;
    if (width >= lg) return ScreenTier.desktop;
    if (width >= md) return ScreenTier.tablet;
    return ScreenTier.mobile;
  }

  /// هل الجهاز ديسكتوب (ويب/كمبيوتر)؟
  static bool isDesktop(BuildContext context) =>
      of(context) == ScreenTier.desktop;

  /// هل الجهاز تابلت؟
  static bool isTablet(BuildContext context) =>
      of(context) == ScreenTier.tablet;

  /// هل الجهاز موبايل؟
  static bool isMobile(BuildContext context) =>
      of(context) == ScreenTier.mobile;
}


