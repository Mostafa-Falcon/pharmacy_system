// activity_log_strings.dart — سجل النشاطات والعمليات



class ActivityLogStrings {
  ActivityLogStrings._();

  static const String activityTitle = 'سجل النشاطات';
  static const String activityEmpty = 'لا توجد نشاطات مسجلة بعد';
  static const String activityNow = 'الآن';
  static const String activityMinutesAgo = 'منذ %s د';
  static const String activityHoursAgo = 'منذ %s س';
  static const String activityDaysAgo = 'منذ %s يوم';

  static const String typeSale = 'بيع';
  static const String typePurchase = 'مشتريات';
  static const String typeSaleReturn = 'مرتجع بيع';
  static const String typePurchaseReturn = 'مرتجع مشتريات';
  static const String typeShift = 'وردية';

  static const String actionCreated = 'إنشاء';
  static const String actionModified = 'تعديل';
  static const String actionVoided = 'إلغاء';
  static const String actionReturned = 'مرتجع';
  static const String actionPaymentUpdated = 'تحديث دفعة';

  // ─── Facade Aliases ───
  static const String actionCreatedLog = actionCreated;
  static const String actionModifiedLog = actionModified;
  static const String actionVoidedLog = actionVoided;
  static const String actionReturnedLog = actionReturned;
  static const String actionPaymentUpdatedLog = actionPaymentUpdated;
}
