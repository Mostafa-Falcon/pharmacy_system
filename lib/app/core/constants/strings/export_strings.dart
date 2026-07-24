// export_strings.dart — التصدير إلى Excel والطباعة



class ExportStrings {
  ExportStrings._();

  // ─── Export ───
  static const String exportTitleLedger = 'كشف حساب';
  static const String exportCustomerLedger = 'كشف حساب العميل';
  static const String exportSupplierLedger = 'كشف حساب المورد';
  static const String exportColumnDate = 'التاريخ';
  static const String exportColumnDescription = 'البيان';
  static const String exportColumnDebit = 'مدين';
  static const String exportColumnCredit = 'دائن';
  static const String exportColumnBalance = 'الرصيد';
  static const String exportColumnName = 'الاسم';
  static const String exportColumnType = 'النوع';
  static const String exportColumnPartyType = 'نوع الكيان';
  static const String exportColumnPhone = 'الهاتف';
  static const String exportColumnCompany = 'الشركة';
  static const String exportColumnEmail = 'البريد الإلكتروني';
  static const String exportColumnTaxId = 'الرقم الضريبي';
  static const String exportColumnAddress = 'العنوان';
  static const String exportColumnCreditLimit = 'الحد الائتماني';
  static const String exportColumnDiscountPercent = 'نسبة الخصم %';
  static const String exportColumnPaymentTerm = 'فترة السداد';
  static const String exportColumnStatus = 'الحالة';
  static const String exportFileError = 'فشل في إنشاء ملف الإكسل';
  static const String exportCustomerList = 'قائمة العملاء';
  static const String exportSupplierList = 'قائمة الموردين';
  static const String exportDatePrefix = 'تاريخ التصدير: ';
  static const String exportStatusActive = 'نشط';
  static const String exportStatusInactive = 'غير نشط';

  // ─── Export: Entry Types ───
  static const String entryTypeOpeningBalance = 'رصيد افتتاحي';
  static const String entryTypeSaleInvoice = 'فاتورة بيع';
  static const String entryTypeSaleReturn = 'مرتجع بيع';
  static const String entryTypePayment = 'سداد';
  static const String entryTypeVoidInvoice = 'إلغاء فاتورة';
  static const String entryTypeManualAdjustment = 'تسوية يدوية';
  static const String entryTypeAddition = 'إشعار إضافة';
  static const String entryTypeDiscount = 'إشعار خصم';
  static const String entryTypeCheckReceipt = 'استلام شيك';
  static const String entryTypeCheckPayment = 'دفع شيك';
  static const String entryTypePurchaseInvoice = 'فاتورة مشتريات';

  // ─── Print ───
  static const String printPurchaseInvoice = 'فاتورة مشتريات';
  static const String printSalesInvoice = 'فاتورة مبيعات';
  static const String printReceiptNumber = 'رقم الإيصال: ';
  static const String printInvoiceNumber = 'رقم الفاتورة: #';
  static const String printDate = 'التاريخ: ';
  static const String printSupplier = 'المورد';
  static const String printName = 'الاسم: ';
  static const String printPhone = 'الهاتف: ';
  static const String printType = 'النوع: ';
  static const String printItems = 'الأصناف';
  static const String printColumnNumber = '#';
  static const String printColumnItem = 'الصنف';
  static const String printColumnUnit = 'الوحدة';
  static const String printColumnQuantity = 'الكمية';
  static const String printColumnPrice = 'السعر';
  static const String printColumnDiscount = 'الخصم';
  static const String printColumnTax = 'الضريبة';
  static const String printColumnTotal = 'الإجمالي';
  static const String printColumnExpiry = 'الصلاحية';
  static const String printColumnBatch = 'الباتش';
  static const String printSubtotal = 'المجموع الفرعي';
  static const String printInvoiceDiscount = 'خصم الفاتورة';
  static const String printInvoiceTax = 'ضريبة الفاتورة';
  static const String printShipping = 'الشحن';
  static const String printDelivery = 'التوصيل';
  static const String printFinalTotal = 'الإجمالي النهائي';
  static const String printPaid = 'المدفوع';
  static const String printRemaining = 'المتبقي';
  static const String printPaymentMethod = 'طريقة الدفع: ';
  static const String printPaymentAccount = 'حساب الدفع: ';
  static const String printNotes = 'ملاحظات: ';
  static const String printThankYou = 'شكراً لتعاملكم معنا';
  static const String printPurchaseReturn = 'مرتجع مشتريات';
  static const String printReturnedInvoice = 'فاتورة مرتجعة: #';
  static const String printReason = 'السبب: ';
  static const String printQuote = 'عرض سعر';
  static const String printQuoteNumber = 'رقم العرض';
  static const String printQuoteCustomer = 'العميل';
  static const String printPharmacyName = 'نظام الصيدلية';
  static const String printNotesTitle = 'ملاحظات';
  static const String printShiftReport = 'تقرير وردية كاشير';
  static const String printOpenedAt = 'فتح في: ';
  static const String printClosedAt = 'غلق في: ';
  static const String printSalesCount = 'عدد المبيعات';
  static const String printTotalSales = 'إجمالي المبيعات';
  static const String printTotalReturns = 'إجمالي المرتجعات';
  static const String printNetSales = 'صافي المبيعات';
  static const String printCashDetails = 'تفاصيل الخزينة';
  static const String printExpectedCash = 'المتوقع (سيستم)';
  static const String printActualCash = 'الفعلي (عد يدوي)';
  static const String printDifference = 'العجز / الزيادة';
  static const String printAt = 'طبع في: ';
}


