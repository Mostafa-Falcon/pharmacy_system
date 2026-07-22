// customers_strings.dart — إدارة العملاء وكشوف الحسابات



class CustomersStrings {
  CustomersStrings._();

  static const String customersTitle = 'العملاء';
  static const String errorLoadingCustomers = 'خطأ في تحميل العملاء';
  static const String customerTitle = 'العميل';
  static const String addCustomer = 'إضافة عميل';
  static const String totalCustomers = 'إجمالي العملاء';
  static const String totalDebt = 'إجمالي المديونية';
  static const String customerItemLabel = 'عميل';
  static const String customerNameHint = 'اسم العميل';
  static const String deleteCustomer = 'حذف العميل';
  static const String editCustomer = 'تعديل بيانات العميل';
  static const String paymentTerm = 'السداد';
  static const String creditLimit = 'الحد الائتماني';
  static const String inactiveLabel = 'موقوف';
  static const String deactivate = 'إيقاف';
  static const String activate = 'تفعيل';
  static const String address = 'العنوان';
  static const String notesLabel = 'ملاحظات';
  static const String emailLabel = 'البريد الإلكتروني';
  static const String taxIdLabel = 'الرقم الضريبي';
  static const String selectType = 'اختر النوع';
  static const String ledgerTitle = 'كشف حساب';
  static const String cashReceipt = 'سند قبض';
  static const String additionNotice = 'إشعار إضافة';
  static const String discountNotice = 'إشعار خصم';
  static const String checkReceipt = 'استلام شيك';
  static const String checkPayment = 'دفع شيك';
  static const String exportSuccess = 'تم تصدير الكشف بنجاح';
  static const String noFinancialMovements = 'لا توجد حركات مالية';
  static const String invalidAmount = 'يرجى إدخال مبلغ صحيح';
  static const String checkNumber = 'رقم الشيك';
  static const String bankName = 'اسم البنك';
  static const String dueDate = 'تاريخ الاستحقاق';
  static const String saleInvoice = 'فاتورة بيع';
  static const String saleReturn = 'مرتجع بيع';
  static const String customerPayment = 'سداد';
  static const String saleVoid = 'إلغاء فاتورة';
  static const String openingBalance = 'رصيد افتتاحي';
  static const String manualAdjustment = 'تسوية يدوية';

  // ─── Add Customer ───
  static const String addNewCustomerTitle = 'إضافة عميل جديد';
  static const String addNewCustomerSubtitle = 'إدخال بيانات عميل جديد في النظام وتحديد حد الائتمان';
  static const String fullNameRequired = 'الاسم الكامل *';
  static const String customerNameExampleHint = 'مثلاً: شركة الصفا أو أحمد محمد';
  static const String nameIsRequired = 'الاسم مطلوب';
  static const String interactionType = 'نوع التعامل';
  static const String selectInteractionType = 'اختر النوع';
  static const String regularInteraction = 'آجل';
  static const String cashInteraction = 'نقدي';
  static const String companyOrInstitution = 'الشركة / المؤسسة';
  static const String detailedAddress = 'العنوان بالتفصيل';
  static const String financialSettings = 'الإعدادات المالية';
  static const String discountPercentLabel = 'نسبة الخصم %';
  static const String paymentTermDaysLabel = 'فترة السداد (أيام)';
  static const String openingBalanceLabel = 'الرصيد الافتتاحي';
  static const String balanceStatusLabel = 'حالة الرصيد';
  static const String debitLabel = 'مدين (عليه مبلغ)';
  static const String creditLabel = 'دائن (له مبلغ)';
  static const String additionalNotes = 'ملاحظات إضافية';
  static const String saveCustomerData = 'حفظ بيانات العميل';

  // ─── Customer List & Actions ───
  static const String searchCustomerHintInput = 'بحث عن عميل...';
  static const String deleteCustomerConfirmMessageFormat = 'هل أنت متأكد من حذف العميل "%s"؟';
  static const String exportLedgerFailedFormat = 'فشل في تصدير الكشف: %s';
  static const String daySuffix = 'ي';
}
