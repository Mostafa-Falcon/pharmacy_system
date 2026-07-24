// sync_strings.dart — المزامنة السحابية وحالة الجداول والاتصال



class SyncStrings {
  SyncStrings._();

  static const String syncStatusTitle = 'تفاصيل المزامنة والسحابة';
  static const String syncStatusSubtitle = 'مراقبة حالة اتصال الفروع ومزامنة البيانات اللحظية';
  static const String loadingSyncStatus = 'جاري تحميل حالة المزامنة...';
  static const String syncDataProgress = 'مزامنة البيانات';
  static const String syncDataSubtitle = 'يتم الآن رفع العمليات المعلقة وتحديث الجداول';
  static const String tablesStatus = 'حالة الجداول';
  static const String pendingQueueFormat = 'طابور العمليات (%s)';
  static const String tablesStatusFormat = 'حالة جداول البيانات (%s)';
  static const String tablePrefix = 'جدول: ';
  static const String localRecordsFormat = '%s سجل محلي';
  static const String errorDetailsPrefix = 'تفاصيل الخطأ: ';
  static const String syncErrorPrefix = 'حدث خطأ أثناء مزامنة جدول %s:';
  static const String unknownError = 'خطأ غير معروف';
  static const String syncErrorTip = 'نصيحة: تأكد من وجود العمود المذكور في قاعدة البيانات السحابية أو قم بإعادة محاولة المزامنة.';
  
  // Status Labels
  static const String statusPending = 'بالطابور';
  static const String statusSynced = 'مزامن';
  static const String statusError = 'خطأ';
  static const String statusIdle = 'هادئ';

  // Table Names
  static const String tableMedicines = 'الأدوية';
  static const String tableSales = 'المبيعات';
  static const String tablePurchases = 'المشتريات';
  static const String tableShifts = 'ورديات الكاشير';
  static const String tableQuotes = 'عروض الأسعار';
  static const String tableInventory = 'المخزون';
  static const String tableReturns = 'المرتجعات';
  static const String tableBranches = 'الفروع';
  static const String tableUsers = 'الموظفين';
  static const String tablePermissions = 'الصلاحيات';
  static const String tableCustomers = 'العملاء';
  static const String tableSuppliers = 'الموردين';
  static const String tableSupplierCustomers = 'موردين/عملاء';
  static const String tableCustomerLedgers = 'دفاتر العملاء';
  static const String tableSupplierLedgers = 'دفاتر الموردين';

  // UI Redesign Labels & Actions
  static const String connectionStatusLabel = 'حالة الاتصال بالسحابة';
  static const String onlineState = 'متصل بالسحابة';
  static const String offlineState = 'وضع الأوفلاين';
  static const String lastSyncLabel = 'آخر مزامنة: ';
  static const String pendingOperationsLabel = 'العمليات المعلقة';
  static const String pendingOperationsSubtitle = 'عمليات تنتظر الرفع بالسحابة';
  static const String syncErrorsLabel = 'أخطاء المزامنة';
  static const String syncErrorsSubtitle = 'عمليات فشلت وتحتاج مراجعة';

  static const String pullDataBtn = 'سحب البيانات';
  static const String pushPendingBtn = 'رفع المعلقات';
  static const String fullSyncBtn = 'مزامنة شاملة';
  static const String retryFailedBtn = 'إعادة محاولة الأخطاء';
  static const String clearQueueBtn = 'إخلاء الطابور';
  static const String syncInProgressMsg = 'جاري المزامنة وتحديث البيانات الآن...';
  static const String syncIdleMsg = 'يمكنك بدء مزامنة يدوية أو دمج البيانات في أي وقت.';

  static const String pendingQueueTitle = 'طابور العمليات المعلقة';
  static const String allOperationsDone = 'طابور المزامنة مكتمل وفارغ بالكامل!';
  static const String allOperationsDoneDesc = 'تم رفع وحفظ جميع العمليات المحلية بالسحابة بنجاح.';
  static const String noMatchSearch = 'لا توجد عناصر مطابقة لبحثك.';
  static const String noMatchSearchDesc = 'جرب البحث باسم جدول آخر أو كلمة مفتاحية مختلفة.';
  static const String searchPendingHint = 'تصفية طابور المعلقات بكلمة مفتاحية...';
  static const String allTablesFilter = 'الكل';

  static const String dataPreviewTitle = 'معاينة تفاصيل البيانات المعلقة';
  static const String operationType = 'نوع العملية';
  static const String targetTable = 'الجدول المستهدف';
  static const String recordIdLabel = 'معرف السجل';
  static const String createdAtLabel = 'تاريخ الإضافة';
  static const String retryCountLabel = 'عدد المحاولات';
  static const String lastErrorLabel = 'تفاصيل الخطأ';
  static const String closeBtn = 'إغلاق';

  static const String createOp = 'إنشاء جديد';
  static const String updateOp = 'تعديل سجل';
  static const String deleteOp = 'حذف سجل';
}



