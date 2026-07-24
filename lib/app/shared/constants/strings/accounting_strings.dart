// accounting_strings.dart — النظام المحاسبي، سندات العملاء/الموردين، الحسابات



class AccountingStrings {
  AccountingStrings._();

  // ─── Accounting ───
  static const String accountingTitle = 'النظام المحاسبي الموحد';
  static const String accountingIndicators = 'المؤشرات المالية';
  static const String accountingExpenses = 'إدارة المصروفات';
  static const String accountingJournal = 'دفتر اليومية العامة';
  static const String accountingPayments = 'سندات القبض والصرف';
  static const String accountingError = 'حدث خطأ أثناء تحميل البيانات المالية';
  static const String accountingTotalRevenue = 'إجمالي الإيرادات';
  static const String accountingTotalExpenses = 'إجمالي المصروفات';
  static const String accountingNetProfit = 'صافي الربح التشغيلي';
  static const String accountingRecentJournals = 'أحدث قيود اليومية العامة';
  static const String accountingNoJournals = 'لا توجد قيود يومية';
  static const String accountingNoJournalsSubtitle = 'سوف تظهر القيود الآلية واليدوية هنا بمجرد بدء المعاملات.';
  static const String accountingJournalPrefix = 'قيد يومية رقم #';
  static const String accountingBalanced = 'مدين / دائن متوازن';
  static const String accountingEntrySale = 'مبيعات';
  static const String accountingEntryPurchase = 'مشتريات';
  static const String accountingEntryExpense = 'مصروفات';
  static const String accountingEntryPayment = 'سداد';
  static const String accountingEntryReceipt = 'تحصيل';
  static const String accountingNoExpenses = 'لا توجد مصروفات مسجلة';
  static const String accountingNoExpensesSubtitle = 'لم يتم تسجيل أي عمليات صرف مالي بعد.';
  static const String accountingExpensePrefix = 'مصروف #';
  static const String accountingExpenseCategoryRent = 'إيجار الفرع';
  static const String accountingExpenseCategorySalaries = 'مرتبات موظفين';
  static const String accountingExpenseCategoryBills = 'فواتير ومرافق';
  static const String accountingExpenseCategoryMaintenance = 'صيانة وتجهيزات';
  static const String accountingExpenseCategoryMarketing = 'تسويق ودعاية';
  static const String accountingExpenseCategoryShipping = 'نقل وشحن';
  static const String accountingExpenseCategoryOther = 'أخرى';
  static const String accountingAddExpense = 'تسجيل مصروفات جديد';
  static const String accountingExpenseCategory = 'تصنيف المصروف';
  static const String accountingExpenseCategoryHint = 'اختر التصنيف الرئيسي';
  static const String accountingExpenseDescription = 'البيان والتفاصيل';
  static const String accountingExpenseAmount = 'القيمة المالية (ج.م)';
  static const String accountingExpensePaymentMethod = 'طريقة الدفع';
  static const String accountingExpensePaymentHint = 'اختر حساب الدفع';
  static const String accountingSaveEntry = 'حفظ وترحيل القيد';
  static const String expenseImportExcel = 'استيراد مصاريف من Excel';
  static const String expenseSearchHint = 'بحث في المصروفات...';
  static const String expenseSearchHelper = 'تصنيف، بيان، رقم';
  static const String expenseFilterFromDate = 'من تاريخ';
  static const String expenseFilterToDate = 'إلى تاريخ';
  static const String expensePaymentCash = 'خزينة الصيدلية (نقدي)';
  static const String expensePaymentCard = 'شبكة / بطاقة بنكية';
  static const String expensePaymentBank = 'تحويل بنكي';
  static const String expensePaymentWallet = 'محفظة إلكترونية';
  static const String expenseDescHint = 'اكتب تفاصيل المصروف هنا...';
  static const String expenseAmountHint = '0.00';
  static const String accountingValidAmount = 'يرجى إدخال مبلغ صحيح';
  static const String accountingJournalNoEntries = 'لا توجد قيود في هذه الفترة';
  static const String accountingJournalNoEntriesSubtitle = 'يرجى اختيار نطاق زمني آخر.';
  static const String accountingJournalEntryPrefix = 'قيد رقم #';
  static const String accountingJournalBalancedLabel = 'متوازن';
  static const String accountingJournalDescription = 'البيان: ';

  // ─── Accounting: Party Payments ───
  static const String partyPaymentsReceipts = 'سندات مقبوضات العملاء';
  static const String partyPaymentsPayments = 'سندات مدفوعات الموردين';
  static const String partyPaymentsNew = 'إنشاء إيصال مالي جديد';
  static const String partyPaymentsType = 'نوع السند المالي';
  static const String partyPaymentsTypeHint = 'اختر نوع السند';
  static const String partyPaymentsCustomerReceipt = 'سند قبض نقدية من عميل';
  static const String partyPaymentsSupplierPayment = 'سند صرف نقدية لمورد';
  static const String partyPaymentsCustomerTarget = 'العميل المستهدف';
  static const String partyPaymentsSupplierTarget = 'المورد المستهدف';
  static const String partyPaymentsAccountHint = 'اختر الحساب الجاري';
  static const String partyPaymentsUnknownAccount = 'حساب مجهول';
  static const String partyPaymentsAmount = 'المبلغ المستحق (ج.م)';
  static const String partyPaymentsChannel = 'قناة الإيداع / الصرف';
  static const String partyPaymentsChannelHint = 'اختر طريقة التسوية';
  static const String partyPaymentsCashMethod = 'نقداً بالخزينة';
  static const String partyPaymentsCardMethod = 'مدفوعات بطاقة (شبكة)';
  static const String partyPaymentsBankMethod = 'تحويل بنكي مباشر';
  static const String partyPaymentsWalletMethod = 'محفظة كاش إلكترونية';
  static const String partyPaymentsNotes = 'ملاحظات إضافية';
  static const String partyPaymentsConfirm = 'اعتماد وترحيل السند';
  static const String partyPaymentsEmpty = 'لا توجد إيصالات أو سندات مسجلة';
  static const String partyPaymentsEmptySubtitle = 'لم يتم إنشاء أي سندات مالية هنا بعد.';
  static const String partyPaymentsNumberPrefix = 'رقم السند: #';

  // ─── Accounting: Bloc Messages ───
  static const String msgExpenseSaved = 'تم تسجيل المصروف بنجاح';
  static const String msgExpenseFailed = 'فشل تسجيل المصروف';
  static const String msgExpenseDeleted = 'تم حذف المصروف';
  static const String msgJournalDeleted = 'تم حذف القيد';
  static const String msgDeleteFailed = 'فشل الحذف';
  static const String msgReceiptSaved = 'تم تسجيل سند القبض بنجاح';
  static const String msgPaymentSaved = 'تم تسجيل سند الصرف بنجاح';
  static const String msgBondDeleted = 'تم حذف السند';

  // ─── Accounting: Account Names ───
  static const String accountCash = 'الخزينة الرئيسية';
  static const String accountBank = 'البنك';
  static const String accountCardClearing = 'تسويات البطاقات';
  static const String accountMobileWallet = 'المحافظ الإلكترونية';
  static const String accountReceivables = 'العملاء';
  static const String accountPayables = 'الموردون';
  static const String accountInventory = 'المخزون';
  static const String accountSalesRevenue = 'إيرادات المبيعات';
  static const String accountTaxPayable = 'ضريبة مستحقة';
  static const String accountCostOfGoodsSold = 'تكلفة البضاعة المباعة';
  static const String accountInventoryGain = 'أرباح تسويات المخزون';
  static const String accountInventoryLoss = 'عجز وتالف المخزون';
  static const String accountSupplierAdjustments = 'تسويات موردين';
  static const String accountPurchaseDiscounts = 'خصومات مشتريات';
  static const String accountOpeningEquity = 'حقوق ملكية افتتاحية';

  // ─── Accounting: Entry Descriptions ───
  static const String entryDefaultJournal = 'قيد يومي';
  static const String entrySalesRevenue = 'إيراد مبيعات';
  static const String entryCostOfGoodsSold = 'تكلفة البضاعة المباعة';
  static const String entryInventoryReduction = 'تخفيض المخزون';
  static const String entryInventoryIn = 'مخزون وارد';
  static const String entrySupplierPayment = 'مدفوعات للمورد';
  static const String entrySupplierDue = 'مستحق للمورد';
  static const String entrySalesReturn = 'مرتجع بيع';
  static const String entryInventoryReturn = 'مخزون مرتجع';
  static const String entryRevenueReversal = 'عكس إيراد مبيعات';
  static const String entryCostReversal = 'عكس تكلفة البضاعة';
  static const String entrySupplierDueReduction = 'تخفيض مستحق المورد';
  static const String entryInventoryReturnToSupplier = 'مخزون مرتجع للمورد';
  static const String entryInventoryGain = 'أرباح تسوية مخزون';
  static const String entryInventoryLoss = 'خسائر تسوية مخزون';
  static const String entryInventoryAdjustment = 'تسوية مخزون';
  static const String entrySalesInvoice = 'فاتورة بيع #';
  static const String entryPurchaseInvoice = 'فاتورة شراء #';
  static const String entrySalesReturnInvoice = 'مرتجع بيع #';
  static const String entryPurchaseReturnInvoice = 'مرتجع شراء #';
  static const String entryBalanceError = 'قيود غير متزنة';
  static const String entryPaymentCash = 'نقدية';
  static const String entryPaymentCard = 'بطاقة';
  static const String entryPaymentBank = 'تحويل بنكي';
  static const String entryPaymentWallet = 'محفظة إلكترونية';

  // ─── Accounting: Payment Kind Labels ───
  static const String kindCustomerReceipt = 'مقبوضات عميل';
  static const String kindSupplierPayment = 'مدفوعات مورد';
  static const String kindSupplierReceipt = 'مقبوضات مورد';
  static const String kindSupplierOpeningBalance = 'رصيد افتتاحي مورد';
  static const String kindSupplierAddition = 'إشعار إضافة مورد';
  static const String kindSupplierDiscount = 'إشعار خصم مورد';

  // ─── Accounting: Validation Error Messages ───
  static const String errorPaymentMustBePositive = 'قيمة السداد يجب أن تكون أكبر من صفر';
  static const String errorAdditionMustBePositive = 'قيمة الإضافة يجب أن تكون أكبر من صفر';
  static const String errorDiscountMustBePositive = 'قيمة الخصم يجب أن تكون أكبر من صفر';
  static const String errorCheckMustBePositive = 'قيمة الشيك يجب أن تكون أكبر من صفر';
  static const String errorOpeningMustBePositive = 'قيمة الرصيد الافتتاحي يجب أن تكون أكبر من صفر';
}


