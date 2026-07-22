// general_strings.dart — ثوابت عامة (General, أيام/شهور، enums، القيم الافتراضية)



class GeneralStrings {
  GeneralStrings._();

  // ─── General ───
  static const String appName = 'Logixa Systems';
  static const String pharmacyManagement = 'نظام إدارة الصيدليات';
  static const String currency = 'ج.م';
  static const String searchHint = 'بحث...';
  static const String loading = 'جاري التحميل...';
  static const String success = 'نجح';
  static const String error = 'خطأ';
  static const String confirm = 'تأكيد';
  static const String cancel = 'إلغاء';
  static const String delete = 'حذف';
  static const String edit = 'تعديل';
  static const String save = 'حفظ';
  static const String add = 'إضافة';
  static const String all = 'الكل';
  static const String refresh = 'إعادة المحاولة';
  static const String noData = 'لا توجد بيانات متاحة';
  static const String exit = 'خروج';
  static const String close = 'إغلاق';
  static const String continueText = 'استمرار';
  static const String date = 'التاريخ';
  static const String status = 'الحالة';
  static const String export = 'تصدير';
  static const String today = 'اليوم';
  static const String thisMonth = 'هذا الشهر';
  static const String unit = 'وحدة';
  static const String done = 'تم';
  static const String warning = 'تنبيه';
  static const String information = 'معلومة';
  static const String name = 'الاسم';
  static const String phone = 'الهاتف';
  static const String company = 'الشركة';
  static const String balance = 'الرصيد';
  static const String amount = 'المبلغ';
  static const String type = 'النوع';
  static const String notes = 'البيان';
  static const String description = 'الوصف';
  static const String total = 'الإجمالي';
  static const String subtotal = 'المجموع الفرعي';
  static const String discount = 'الخصم';
  static const String tax = 'الضريبة';
  static const String active = 'نشط';
  static const String inactive = 'غير نشط';
  static const String print = 'طباعة';
  static const String share = 'مشاركة';
  static const String filter = 'تصفية';
  static const String startDate = 'من تاريخ';
  static const String endDate = 'إلى تاريخ';
  static const String ok = 'موافق';
  static const String back = 'رجوع';
  static const String submit = 'إرسال';
  static const String update = 'تحديث';
  static const String create = 'إنشاء';
  static const String search = 'بحث';
  static const String reset = 'إعادة تعيين';
  static const String apply = 'تطبيق';
  static const String optional = 'اختياري';
  static const String required = 'إجباري';
  static const String select = 'اختر';
  static const String upload = 'رفع';
  static const String download = 'تحميل';
  static const String send = 'إرسال';
  static const String receive = 'استلام';
  static const String view = 'عرض';
  static const String hide = 'إخفاء';
  static const String show = 'عرض';
  static const String open = 'فتح';
  static const String main = 'رئيسي';
  static const String settings = 'الإعدادات';
  static const String previous = 'السابق';
  static const String nextLabel = 'التالي';
  static const String pageLabel = 'صفحة';
  static const String copyText = 'نسخ';
  static const String unexpectedError = 'حدث خطأ غير متوقع';
  static const String permissionDenied = 'غير مصرح بالوصول';
  static const String inProgress = 'جاري التنفيذ...';
  static const String loadFailed = 'فشل التحميل';
  static const String noItems = 'لا توجد عناصر';
  static const String saveData = 'حفظ البيانات';
  static const String saveAndAddAnother = 'حفظ وإضافة آخر';
  static const String processing = 'جاري المعالجة...';
  static const String addNew = 'إضافة جديد';
  static const String yesDelete = 'نعم، إحذف';
  static const String cancelUndo = 'تراجع وإلغاء';
  static const String recordPayment = 'تسجيل الدفع';
  static const String searchNoResults = 'لا توجد نتائج مطابقة';
  static const String noRecords = 'لا يوجد سجل';
  static const String noDataAvailableShort = 'لا تتوفر بيانات';

  // ─── Dialogs & Confirmation ───
  static const String confirmExitTitle = 'تأكيد الخروج';
  static const String unsavedChangesConfirm = 'لديك بيانات غير محفوظة. هل أنت متأكد من الخروج؟';
  static const String stayButton = 'البقاء';
  static const String exitAndIgnoreButton = 'خروج وتجاهل';

  // ─── Action Sheet / Menu Labels (موحّدة) ───
  static const String archive = 'أرشفة';
  static const String deactivateLabel = 'تعطيل';
  static const String restoreLabel = 'استعادة';

  // ─── Void / Cancel Actions ───
  static const String voidAndDelete = 'إلغاء وحذف';
  static const String fromDatePrefix = 'من';
  static const String toDatePrefix = 'إلى';

  // ─── Days & Months ───
  static const String sunday = 'الأحد';
  static const String monday = 'الإثنين';
  static const String tuesday = 'الثلاثاء';
  static const String wednesday = 'الأربعاء';
  static const String thursday = 'الخميس';
  static const String friday = 'الجمعة';
  static const String saturday = 'السبت';
  static const String january = 'يناير';
  static const String february = 'فبراير';
  static const String march = 'مارس';
  static const String april = 'أبريل';
  static const String may = 'مايو';
  static const String june = 'يونيو';
  static const String july = 'يوليو';
  static const String august = 'أغسطس';
  static const String september = 'سبتمبر';
  static const String october = 'أكتوبر';
  static const String november = 'نوفمبر';
  static const String december = 'ديسمبر';

  // ─── Enums & Lookups ───
  static const String enumCustomerRegular = 'آجل';
  static const String enumCustomerCash = 'نقدي';
  static const String enumSupplierTypeSupplier = 'مورد';
  static const String enumSupplierTypeBoth = 'عميل/مورد';
  static const String enumPartyTypeCompany = 'شركة';
  static const String enumPartyTypeIndividual = 'فرد';

  // ─── Lookup Defaults ───
  static const String lookupItemTypeMedicine = 'أدوية';
  static const String lookupItemTypeCosmetics = 'مستلزمات تجميل';
  static const String lookupItemTypeMedicalTools = 'أدوات طبية';
  static const String lookupGroupPainkillers = 'مسكنات';
  static const String lookupGroupVitamins = 'فيتامينات';
  static const String lookupGroupAntibiotics = 'مضادات حيوية';

  // ─── Customer Service Defaults ───
  static const String defaultCashCustomer = 'عميل نقدي';
  static const String defaultUserName = 'مستخدم';
  static const String defaultPharmacy = 'مؤسسة الدواء';
  static const String defaultUnitPiece = 'حبة';
  static const String defaultCurrency = 'ج.م';

  // ─── Customer Groups ───
  static const String groupGeneral = 'عام';
  static const String groupSilver = 'فضي';
  static const String groupGold = 'ذهبي';
  static const String groupPlatinum = 'بلاتيني';

  // ─── Financial Summary ───
  static const String finSummaryTitle = 'الملخص المالي العام';
  static const String finCustomers = 'العملاء';
  static const String finSuppliers = 'الموردين';
  static const String finCustomerDebts = 'ديون العملاء';
  static const String finSupplierDue = 'المستحق للموردين';

  // ─── Shell & Navbar ───
  static const String techSupportTitle = 'الدعم الفني عبر واتساب';
  static const String supportContactPrefix = 'للتواصل مع قسم الدعم الفني:';
  static const String copyNumber = 'نسخ الرقم';
  static const String openWhatsapp = 'فتح واتساب';
  static const String currentBranchLabel = 'الفرع الحالي';
  static const String switchBranchTooltip = 'تبديل الفرع';
  static const String mainBranchLabel = 'الفرع الرئيسي';
  static const String syncInProgress = 'جارٍ المزامنة...';
  static const String online = 'متصل';
  static const String offline = 'غير متصل';
  static const String calculator = 'آلة حاسبة';
  static const String cashier = 'الكاشير';
  static const String techSupport = 'الدعم الفني';
  static const String lightMode = 'الوضع الفاتح';
  static const String darkMode = 'الوضع الداكن';
  static const String syncError = 'خطأ في المزامنة';
  static const String synced = 'متزامن';
  static const String offlineDetailed = 'غير متصل بالإنترنت';
  static const String syncingShort = 'مزامنة';
  static const String profile = 'الملف الشخصي';
  static const String menu = 'القائمة';
  static const String openMenu = 'فتح القائمة';
  static const String closeMenu = 'طي القائمة';
}
