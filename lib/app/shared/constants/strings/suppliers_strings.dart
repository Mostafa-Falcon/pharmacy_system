// suppliers_strings.dart — الموردين والقيود المالية



class SuppliersStrings {
  SuppliersStrings._();

  static const String suppliersTitle = 'الموردين';
  static const String addSupplier = 'إضافة مورد';
  static const String totalSuppliers = 'إجمالي الموردين';
  static const String activeSuppliers = 'نشط';
  static const String totalBalances = 'إجمالي الأرصدة';
  static const String searchSupplierHint = 'بحث عن مورد...';
  static const String supplierLabelTable = 'المورد';
  static const String phoneLabel = 'الهاتف';
  static const String companyLabel = 'الشركة';
  static const String balanceLabel = 'الرصيد';
  static const String creditLimitLabel = 'الحد الائتماني';
  static const String discountLabelTable = 'الخصم';
  static const String typeLabel = 'النوع';
  static const String statusLabel = 'الحالة';
  static const String noSuppliersTitle = 'لا يوجد موردون';
  static const String noSuppliersSubtitle = 'يمكنك إضافة مورد جديد من زر "إضافة مورد"';
  static const String accountStatement = 'كشف حساب';
  static const String currentBalanceLabel = 'الرصيد الحالي: ';
  static const String amountLabel = 'المبلغ';
  static const String notesLabel = 'البيان / الملاحظات';
  static const String cashPayment = 'سند صرف';
  static const String additionNotice = 'إشعار إضافة';
  static const String discountNotice = 'إشعار خصم';
  static const String checkPayment = 'شيك دفع';
  static const String checkReceipt = 'شيك قبض';
  static const String recentLedgerEntries = 'القيود المالية الأخيرة';
  static const String noLedgerEntries = 'لا توجد قيود مالية مسجلة.';

  // ─── Add Supplier ───
  static const String addNewSupplierTitle = 'إضافة مورد جديد';
  static const String nameLabelRequired = 'الاسم *';
  static const String supplierNameHint = 'اسم المورد';
  static const String nameRequired = 'الاسم مطلوب';
  static const String typeLabelDropdown = 'النوع';
  static const String selectTypeHint = 'اختر النوع';
  static const String supplierType = 'مورد';
  static const String supplierCustomerType = 'مورد/عميل';
  static const String phoneLabelInput = 'الهاتف';
  static const String companyLabelInput = 'الشركة';
  static const String emailLabelInput = 'البريد الإلكتروني';
  static const String taxIdLabelInput = 'الرقم الضريبي';
  static const String addressLabelInput = 'العنوان';
  static const String partyTypeLabel = 'نوع الطرف';
  static const String selectPartyTypeHint = 'اختر نوع الطرف';
  static const String creditLimitLabelInput = 'الحد الائتماني';
  static const String discountPercentLabelInput = 'نسبة الخصم %';
  static const String paymentTermDaysLabelInput = 'مدة السداد (يوم)';
  static const String openingBalanceLabelInput = 'الرصيد الافتتاحي';
  static const String balanceDirectionLabel = 'اتجاه الرصيد';
  static const String debitDirection = 'مدين (عليه)';
  static const String creditDirection = 'دائن (له)';
  static const String notesLabelInput = 'ملاحظات';

  // ─── Supplier Dialog ───
  static const String addNewApprovedSupplier = 'إضافة مورد جديد معتمد';
  static const String companyOrSupplierNameRequired = 'اسم الشركة أو المورد *';
  static const String supplyType = 'نوع التوريد';
  static const String supplierOnly = 'مورد فقط';
  static const String supplierCustomerJoint = 'مورد / عميل مشترك';
  static const String cancelAction = 'إلغاء الأمر';
  static const String saveSupplier = 'حفظ المورد';

  // ─── Supplier List & Actions ───
  static const String errorLoadingSuppliers = 'خطأ في تحميل الموردين';
  static const String activeLabel = 'نشط';
  static const String inactiveLabel = 'غير نشط';
  static const String deleteSupplierConfirmTitle = 'تأكيد الحذف';
  static const String deleteSupplierPermanentMessage = 'هل أنت متأكد تماماً من رغبتك في حذف هذا المورد نهائياً؟';
  static const String permanentDeleteAction = 'حذف نهائي';
  static const String enterTransactionDetailsHint = 'أدخل تفاصيل العملية...';
  static const String checkPaymentDataTitle = 'بيانات شيك الدفع';
  static const String checkReceiptDataTitle = 'بيانات شيك القبض';
  static const String confirmOperationAction = 'تأكيد العملية';
  static const String enterCorrectAmountFirstError = 'يرجى إدخال مبلغ صحيح في الحقل المخصص أولاً';
}


