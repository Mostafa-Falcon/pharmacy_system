class SyncConfig {
  SyncConfig._();

  /// حجم صفحة السحب (Pull Page Size)
  /// تم تقليلها لضمان خفة المعالجة وتقليل استهلاك الرام
  static const int pullPageSize = 500;

  /// الفاصل الزمني للمزامنة الدورية
  /// رفعه لـ 90 ثانية لزيادة كفاءة استهلاك البطارية
  static const Duration periodicInterval = Duration(seconds: 90);

  /// أدنى فاصل بين عمليتي سحب متتاليتين
  /// رفعه لـ 15 ثانية لمنع حدوث اختناقات في الشبكة
  static const Duration minPullGap = Duration(seconds: 15);

  /// اسم صندوق الميتا لعلامات المزامنة
  static const String metaBoxName = '_sync_meta';

  /// أقصى عدد لمحاولات إعادة إرسال العملية الفاشلة
  /// تقليله لـ 3 لضمان الفشل السريع وعدم تعليق الموارد
  static const int maxRetryCount = 3;

  /// تأخير السحب بين الجداول لتخفيف ضغط الشبكة وضمان سلاسة الواجهة (ميلي ثانية)
  static const int pullTableDelayMs = 200;

  /// مهلة الإرسال (Push Timeout)
  static const Duration pushTimeout = Duration(seconds: 20);

  /// مهلة السحب (Pull Timeout)
  static const Duration pullTimeout = Duration(seconds: 45);
}


