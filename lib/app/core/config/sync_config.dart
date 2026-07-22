class SyncConfig {
  SyncConfig._();

  /// حجم صفحة السحب (Pull Page Size)
  static const int pullPageSize = 1000;

  /// الفاصل الزمني للمزامنة الدورية
  static const Duration periodicInterval = Duration(seconds: 60);

  /// أدنى فاصل بين عمليتي سحب متتاليتين
  static const Duration minPullGap = Duration(seconds: 8);

  /// اسم صندوق الميتا لعلامات المزامنة
  static const String metaBoxName = '_sync_meta';

  /// أقصى عدد لمحاولات إعادة إرسال العملية الفاشلة
  static const int maxRetryCount = 5;

  /// تأخير السحب بين الجداول لتخفيف ضغط الشبكة (ميلي ثانية)
  static const int pullTableDelayMs = 120;
}
