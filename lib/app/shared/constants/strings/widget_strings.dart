// widget_strings.dart — نصوص خاصة بالـ Widgets القابلة لإعادة الاستخدام



class WidgetStrings {
  WidgetStrings._();

  // ─── Correction Chain ───
  static const String correctionHistory = 'سجل التعديلات';
  static const String correctionMore = '+ %s تعديلات أخرى';
  static const String correctionCreated = 'تم الإنشاء';
  static const String correctionModified = 'تعديل المعاملة';
  static const String correctionVoided = 'إلغاء تماماً';
  static const String correctionReturned = 'مرتجع للفرع';
  static const String correctionPaymentUpdated = 'تحديث الدفع';

  // ─── Barcode Scanner ───
  static const String barcodeScannerTitle = 'مسح الباركود للكاشير';
  static const String barcodeScannerHint = 'وجه كاميرا الجهاز مباشرة وبثبات نحو الباركود';
  static const String barcodeCameraDenied = 'صلاحية الوصول للكاميرا مرفوضة';
  static const String barcodeCameraError = 'خطأ في تشغيل الكاميرا: %s';

  // ─── Payment Dialog ───
  static const String paymentAmountLabel = 'المبلغ *';
  static const String paymentAmountRequired = 'المبلغ مطلوب';
  static const String paymentValidNumber = 'يرجى إدخال رقم صحيح ومظبوط';
  static const String paymentNotesLabel = 'ملاحظات إضافية';
  static const String paymentNotesHint = 'اكتب تفاصيل المعاملة هنا...';
  static const String paymentRecordButton = 'تسجيل الدفع';

  // ─── Sale Details Dialog ───
  static const String saleResponsibleEmployee = 'الموظف المسؤول';
  static const String saleShipping = 'شحن وتوصيل';
  static const String salePayments = 'مدفوعات المبيعات';
  static const String saleRemaining = 'المتبقي';
  static const String saleCurrentStore = 'المخزن الحالي';
  static const String saleActions = 'إجراءات';
  static const String saleNoRecords = 'لا يوجد سجل';

  // ─── State Views ───
  static const String stateViewError = 'حدث خطأ غير متوقع';
  static const String stateViewPermissionDenied = 'غير مصرح بالوصول';

  // ─── Progress Overlay ───
  static const String progressInProgress = 'جاري التنفيذ...';

  // ─── Medicine Search ───
  static const String medicineSearchHint = 'ابحث عن صنف أو امسح الباركود...';
  static const String medicineSearchPlaceholder = 'اكتب اسم الصنف أو الباركود...';
  static const String medicineSearchStock = 'الباركود: %s | المخزون: %s';
  static const String medicineSearchBuyPrice = 'شراء: %s';

  // ─── Pagination ───
  static const String paginationItemLabel = 'عنصر';
  static const String paginationPageSize = 'حجم الصفحة';
  static const String paginationPageFormat = 'صفحة %s من %s';
  static const String paginationLoadedAll = 'تم تحميل جميع العناصر';
  static const String paginationFooterFormat = 'عرض %s–%s من %s %s';
  static const String paginationSelectedFormat = 'تم تحديد %s %s';
  static const String paginationDeselect = 'إلغاء التحديد';
  static const String paginationNoData = 'لا توجد بيانات متاحة حالياً';

  // ─── Table ───
  static const String tableError = 'حدث خطأ';
  static const String tableLoadError = 'تعذّر تحميل البيانات';
  static const String tableSearchHint = 'بحث سريع في الجدول...';
  static const String tableColumnsVisibility = 'تخصيص الأعمدة';
  static const String tableDensity = 'كثافة العرض';
  static const String tableDensityCompact = 'مكثف (صغير)';
  static const String tableDensityMedium = 'متوسط (قياسي)';
  static const String tableDensityComfortable = 'مريح (واسع)';
  static const String tableExport = 'تصدير البيانات';
  static const String tableExportCsv = 'تصدير CSV';
  static const String tableExportExcel = 'تصدير Excel';
  static const String tablePrint = 'طباعة الجدول';
  static const String tableSelectAll = 'تحديد الكل';
  static const String tableDeselectAll = 'إلغاء التحديد';
  static const String tableTotalSummary = 'المجموع والإجمالي';
  static const String tableAllRows = 'الكل';

  // ─── Calculator ───
  static const String calculatorTitle = 'آلة حاسبة احترافية';
  static const String calculatorResultCopied = 'تم نسخ النتيجة: %s';
  static const String calculatorCopy = 'نسخ';

  // ─── Filter Bar ───
  static const String filterClearFormat = 'مسح الفلاتر (%s)';
  static const String filterViewTable = 'عرض كجدول';
  static const String filterViewGrid = 'عرض كشبكة';

  // ─── Form Layouts ───
  static const String formSaveData = 'حفظ البيانات';
  static const String formSaveAndAddAnother = 'حفظ وإضافة آخر';

  // ─── Confirm Delete ───
  static const String confirmDeleteYes = 'نعم، إحذف';
  static const String confirmCancelUndo = 'تراجع وإلغاء';

  // ─── Buttons ───
  static const String buttonAddNew = 'إضافة جديد';

  // ─── Shared Layouts ───
  static const String listNoData = 'لا تتوفر بيانات';
  static const String listLoading = 'جاري تحميل البيانات...';

  // ─── App Module Layout ───
  static const String moduleProcessing = 'جاري المعالجة...';
}


