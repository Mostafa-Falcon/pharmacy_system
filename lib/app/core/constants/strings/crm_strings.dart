// crm_strings.dart — إدارة علاقات العملاء (CRM)



class CrmStrings {
  CrmStrings._();

  static const String crmTitle = 'إدارة علاقات العملاء';
  static const String crmSubtitle = 'متابعة العملاء المحتملين وتحويلهم لعملاء دائمين.';
  static const String crmError = 'خطأ في تحميل بيانات العملاء المحتملين';
  static const String crmTotal = 'الإجمالي';
  static const String crmNew = 'جديد';
  static const String crmContacted = 'تم التواصل';
  static const String crmInterested = 'مهتم';
  static const String crmConverted = 'تم التحويل';
  static const String crmNotInterested = 'غير مهتم';
  static const String crmAddLead = 'إضافة عميل محتمل';
  static const String crmEmpty = 'لا يوجد عملاء محتملون';
  static const String crmEdit = 'تعديل البيانات';
  static const String crmAddFollowUp = 'إضافة متابعة';
  static const String crmEditDialog = 'تعديل بيانات العميل';
  static const String crmAddDialog = 'إضافة عميل محتمل جديد';
  static const String crmNameHint = 'أدخل الاسم الكامل';
  static const String crmPhone = 'رقم الهاتف';
  static const String crmPhoneHint = 'أدخل رقم الجوال';
  static const String crmSource = 'المصدر';
  static const String crmSaveEdit = 'حفظ التعديلات';
  static const String crmAddNow = 'إضافة الآن';
  static const String crmNameRequired = 'يرجى إدخال اسم العميل';
  static const String crmFollowUpDate = 'تاريخ المتابعة القادم';
  static const String crmFollowUpNotes = 'ملاحظات المتابعة';
  static const String crmSaveFollowUp = 'حفظ المتابعة';
  static const String crmFollowUpRequired = 'يرجى إدخال ملاحظات المتابعة';
  static const String crmTitleAbbr = 'إدارة العملاء (CRM)';
  static const String crmSearchHint = 'بحث عن اسم أو هاتف العميل...';
  static const String crmEmptySubtitle = 'ابدأ بإضافة أول عميل محتمل لمتابعة عملية تحويله لعميل دائم.';
  static const String crmNameLabel = 'اسم العميل *';
  static const String crmSourceHint = 'مثل: فيسبوك، إعلان، ترشيح...';
  static const String crmAdditionalNotes = 'ملاحظات إضافية';
  static const String crmFollowUpTitleFormat = 'إضافة متابعة - %s';
  static const String crmFollowUpHint = 'أدخل ما تم في المتابعة أو المطلوب لاحقاً...';
  static const String crmMsgLeadAdded = 'تم إضافة العميل المحتمل';
  static const String crmMsgUpdated = 'تم تحديث البيانات';
  static const String crmMsgFollowUpAdded = 'تم إضافة المتابعة';

  // ─── Add Party (Customer/Supplier) ───
  static const String addNewPartyTitle = 'إضافة طرف جديد';
  static const String personalAndBasicInfo = 'المعلومات الشخصية والأساسية';
  static const String businessAndActivityDetails = 'تفاصيل العمل والنشاط';
  static const String financialAndCreditPolicies = 'السياسات المالية والائتمانية';
  static const String openingBalanceAtStart = 'الرصيد الافتتاحي (عند التأسيس)';
  static const String partyFullNameLabel = 'الاسم الكامل للطرف (عميل أو مورد) *';
  static const String partyNameRequiredWarning = 'الاسم مطلوب لتمييز الطرف';
  static const String detailedAddressLabel = 'العنوان التفصيلي';
  static const String companyNameOptional = 'اسم الشركة (إن وجد)';
  static const String legalEntityType = 'نوع الكيان القانوني';
  static const String selectEntityTypeHint = 'اختر نوع الكيان';
  static const String companyOrInstitutionLabel = 'شركة / مؤسسة';
  static const String individualOrMerchantLabel = 'فرد / تاجر مستخلص';
  static const String defaultInteractionMethod = 'طريقة التعامل الافتراضية';
  static const String selectInteractionMethodHint = 'اختر طريقة التعامل';
  static const String regularCreditLabel = 'آجل (فتح حساب)';
  static const String cashOnlyLabel = 'نقدي (كاش)';
  static const String agreedDiscountPercent = 'نسبة الخصم المتفق عليها %';
  static const String maximumCreditLimit = 'حد الائتمان الأقصى';
  static const String grantedPaymentTermDays = 'مدة السداد الممنوحة (بالأيام)';
  static const String balanceValue = 'قيمة الرصيد';
  static const String balanceStatusHint = 'اختر الحالة';
  static const String debitOurDues = 'مدين (مستحق لنا)';
  static const String creditTheirDues = 'دائن (مستحق له)';
  static const String savePartyData = 'حفظ بيانات الطرف';

  // ─── Party List & Ledger ───
  static const String supplierCustomersTitle = 'موردين/عملاء';
  static const String supplierCustomersSubtitle = 'إدارة جهات الاتصال الموحدة';
  static const String addAction = 'إضافة';
  static const String totalParties = 'إجمالي الأطراف';
  static const String activeParties = 'نشط';
  static const String totalBalancesParties = 'إجمالي الأرصدة';
  static const String noPartiesFound = 'لا يوجد سجلات';
  static const String selectPartyToViewLedger = 'اختر طرفاً لعرض كشف الحساب';
  static const String creditLimitLabel = 'حد ائتماني: %s';
  static const String transactionSummary = 'ملخص التعاملات';
  static const String totalSalesLabel = 'مبيعات';
  static const String totalSalesReturnsLabel = 'مرتجع مبيعات';
  static const String totalPurchasesLabel = 'مشتريات';
  static const String totalPurchaseReturnsLabel = 'مرتجع مشتريات';
  static const String totalReceiptsLabel = 'مقبوضات';
  static const String totalPaymentsLabel = 'مدفوعات';
  static const String totalAdditionsLabel = 'إضافات';
  static const String totalDiscountsLabel = 'خصومات';
  static const String totalCheckReceiptsLabel = 'شيكات مقبوضة';
  static const String totalCheckPaymentsLabel = 'شيكات مدفوعة';
  
  // Ledger Actions
  static const String cashReceiptTitle = 'سند قبض - %s';
  static const String cashPaymentTitle = 'سند صرف - %s';
  static const String additionNoticeTitle = 'إشعار إضافة - %s';
  static const String discountNoticeTitle = 'إشعار خصم - %s';
  static const String checkReceiptTitle = 'استلام شيك - %s';
  static const String checkPaymentTitle = 'دفع شيك - %s';
  static const String exportCsv = 'تصدير CSV';
  static const String exportXlsx = 'تصدير Excel (XLSX)';
  static const String exportHtml = 'تصدير HTML';
  static const String exportXml = 'تصدير XML';

  // Ledger Table Headers
  static const String dateColumn = 'التاريخ';
  static const String statementColumn = 'البيان';
  static const String debitColumn = 'مدين';
  static const String creditColumn = 'دائن';
  static const String balanceColumn = 'الرصيد';
  static const String transactionPrefix = 'حركة';

  // Dialogs
  static const String editPartyTitle = 'تعديل';
  static const String addNewPartyAction = 'إضافة جديد';
  static const String partyNameLabel = 'الاسم *';
  static const String customerTypeLabel = 'نوع العميل';
  static const String selectCustomerTypeHint = 'اختر نوع العميل';
  static const String creditLimitLabelInput = 'حد الائتمان';
  static const String entityTypeLabel = 'نوع الكيان';
  static const String entityTypeCompany = 'شركة';
  static const String entityTypeIndividual = 'فرد';
  static const String deleteConfirmMessageFormat = 'هل أنت متأكد من حذف "%s"؟';
  static const String amountRequired = 'المبلغ مطلوب';
  static const String enterCorrectNumber = 'دخل رقم مظبوط وصحيح';
  static const String processDetailsHint = 'اكتب تفاصيل العملية هنا...';
  static const String recordAdditionAction = 'تسجيل الإضافة';
  static const String recordDiscountAction = 'تسجيل الخصم';
  static const String checkValueLabel = 'قيمة الشيك *';
  static const String checkValueRequired = 'قيمة الشيك مطلوبة';
  static const String enterCheckNumberHint = 'أدخل رقم الشيك';
  static const String checkNumberLabel = 'رقم الشيك';
  static const String bankLabel = 'البنك';
  static const String bankNameHint = 'اسم البنك';
  static const String dueDateHint = 'YYYY-MM-DD';
  static const String recordReceiptAction = 'تسجيل الاستلام';
  static const String recordPaymentAction = 'تسجيل الدفع';

  // Snackbars
  static const String msgPartyAdded = 'تم إضافة الطرف بنجاح';
  static const String msgAddFailed = 'فشل في الإضافة: ';
  static const String msgUpdatedSuccess = 'تم التحديث بنجاح';
  static const String msgUpdateFailed = 'فشل في التحديث: ';
  static const String msgDeletedSuccess = 'تم الحذف بنجاح';
  static const String msgDeleteFailed = 'فشل في الحذف: ';
  static const String msgReceiptRecorded = 'تم تسجيل سند القبض';
  static const String msgReceiptFailed = 'فشل في تسجيل سند القبض: ';
  static const String msgPaymentRecorded = 'تم تسجيل سند الصرف';
  static const String msgPaymentFailed = 'فشل في تسجيل سند الصرف: ';
  static const String msgAdditionRecorded = 'تم تسجيل إشعار الإضافة';
  static const String msgAdditionFailed = 'فشل في تسجيل الإضافة: ';
  static const String msgDiscountRecorded = 'تم تسجيل إشعار الخصم';
  static const String msgDiscountFailed = 'فشل في تسجيل الخصم: ';
  static const String msgCheckReceiptRecorded = 'تم تسجيل استلام الشيك';
  static const String msgCheckReceiptFailed = 'فشل في تسجيل الشيك: ';
  static const String msgCheckPaymentRecorded = 'تم تسجيل دفع الشيك';
  static const String msgCheckPaymentFailed = 'فشل في تسجيل دفع الشيك: ';
  static const String msgExportUnsupported = 'صيغة تصدير غير مدعومة';
  static const String msgExportSuccess = 'تم تصدير الكشف بنجاح';
  static const String msgExportFailed = 'فشل في التصدير: ';
}
