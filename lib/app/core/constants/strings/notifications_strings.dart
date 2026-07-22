// notifications_strings.dart — إشعارات النظام وتنبيهات المخزون والصلاحية



class NotificationsStrings {
  NotificationsStrings._();

  static const String notificationsCenterTitle = 'مركز التنبيهات الذكي';
  static const String notificationsCenterSubtitle = 'إدارة جميع إشعارات النظام، المخزون، والصلاحية في مكان واحد';
  static const String unreadNotificationsFormat = 'لديك %s تنبيهات غير مقروءة';
  static const String markAllAsRead = 'تحديد الكل كمقروء';
  static const String clearAll = 'مسح الكل';
  static const String all = 'الكل';
  static const String expiry = 'الصلاحية';
  static const String stock = 'المخزون';
  static const String system = 'النظام';
  static const String clearAllConfirm = 'هل أنت متأكد من رغبتك في حذف جميع الإشعارات من المركز؟';
  static const String noNotifications = 'لا توجد تنبيهات';
  static const String noNotificationsSubtitle = 'كل شيء يبدو جيداً! لا توجد تنبيهات في هذا القسم حالياً.';
  static const String viewDetails = 'عرض التفاصيل';
  static const String deleteNotification = 'حذف التنبيه';
  static const String notificationsTooltip = 'الإشعارات';
  static const String newNotifications = 'جديد';
  static const String noNotificationsCurrent = 'لا توجد تنبيهات حالية';
  static const String viewAll = 'عرض الكل';
  static const String agoMinutes = 'منذ %s دقيقة';
  static const String agoHours = 'منذ %s ساعة';

  // ─── System-generated notification titles ───
  static const String expiryTitle = 'دواء منتهي الصلاحية';
  static const String nearExpiryTitle = 'قرب انتهاء الصلاحية';
  static const String lowStockTitle = 'نواقص / مخزون منخفض';

  // ─── System-generated notification messages ───
  static const String expiryMessageFormat = 'الصنف "%s" انتهت صلاحيته في %s';
  static const String nearExpiryMessageFormat =
      'الصنف "%s" سيقترب من الانتهاء خلال %s يوم';
  static const String lowStockMessageFormat =
      'الكمية الحالية للصنف "%s" هي %s، وهي أقل من الحد الأدنى (%s)';
}
