// reports_strings.dart — التقارير (مبيعات، مشتريات، أرباح، مخزون، ضرائب، نشاط، جهات اتصال)

class ReportsStrings {
  ReportsStrings._();

  static const String reportsTitle = 'التقارير';
  static const String reportsExtra = 'التقارير الإضافية';
  static const String reportsSales = 'تقرير المبيعات';
  static const String reportsPurchases = 'تقرير المشتريات';
  static const String reportsProfit = 'تقرير الأرباح';
  static const String reportsInventory = 'تقرير المخزون';
  static const String reportsStocktake = 'الجرد المخزني';
  static const String reportsPopularItems = 'الأصناف الشائعة';
  static const String reportsItemMovement = 'حركة الأصناف';
  static const String reportsTaxSummary = 'ملخص الضريبة';
  static const String reportsEmployeeActivity = 'نشاطات الموظفين';
  static const String reportsCustomRange = 'نطاق مخصص';
  static const String reportsThisWeek = 'هذا الأسبوع';
  static const String reportsThisMonth = 'هذا الشهر';
  static const String reportsThisYear = 'هذا العام';
  static const String reportsCustom = 'مخصص';
  static const String reportsOperationalExpenses = 'المصروفات التشغيلية';
  static const String reportsJournalIntegrity = 'سلامة دفتر اليومية';
  static const String reportsDailyBalance = 'رصيد اليوم';
  static const String reportsInventoryValue = 'قيمة المخزون بسعر الشراء والبيع';
  static const String reportsInventoryMovement =
      'إجمالي الداخل والخارج من المخزون';
  static const String reportsBestSelling = 'الأصناف الأكثر مبيعاً';
  static const String reportsItemTransactionMovements =
      'حركة صنف ناتجة عن البيع والشراء والمرتجعات';
  static const String reportsTaxDetails = 'تفاصيل ضرائب المبيعات والمشتريات';
  static const String reportsEmployeeActivityLog = 'سجل مبسط لحركات الموظفين';

  // ─── Reports: Tax Summary ───
  static const String taxSummaryEmpty = 'لا توجد ضرائب مسجلة';
  static const String taxSummarySalesTax = 'ضريبة المبيعات';
  static const String taxSummaryPurchaseTax = 'ضريبة المشتريات';
  static const String taxSummaryExpenseTax = 'ضريبة النفقات';
  static const String taxSummaryNet = 'الصافي الضريبي';
  static const String taxColumnDate = 'التاريخ';
  static const String taxColumnType = 'النوع';
  static const String taxColumnRef = 'المرجع';
  static const String taxColumnParty = 'الطرف';
  static const String taxColumnMethod = 'طريقة الدفع';
  static const String taxColumnBase = 'الأساس';

  // ─── Reports: Activity ───
  static const String activityEmpty = 'لا توجد أنشطة موظفين';
  static const String activityCount = 'عدد الأنشطة';
  static const String activityShifts = 'مناوبات الكاشير';
  static const String activityUsers = 'المستخدمين';
  static const String activityEmployee = 'موظف';

  // ─── Reports: Inventory ───
  static const String invReportEmpty = 'لا توجد أصناف مخزنية';
  static const String invReportPotentialProfit = 'الربح المحتمل';
  static const String invReportTotalUnits = 'إجمالي الوحدات';
  static const String invReportBuyPrice = 'سعر الشراء';
  static const String invReportSellPrice = 'سعر البيع';
  static const String invReportBuyValue = 'قيمة الشراء';
  static const String invReportSellValue = 'قيمة البيع';
  static const String invReportProfit = 'الربح';
  static const String invReportBuyLabel = 'شراء';
  static const String invReportSellLabel = 'بيع';

  // ─── Reports: Contacts ───
  static const String contactReportTitle = 'تقرير جهات الاتصال';
  static const String contactFilterAll = 'الكل';
  static const String contactFilterCustomers = 'العملاء';
  static const String contactFilterSuppliers = 'الموردين';
  static const String contactFilterDebtors = 'المدينون';

  // ─── Reports: Advanced Ledger ───
  static const String advancedLedgerReportTitle = 'تقرير كشوف الحسابات المتقدم';
  static const String customerType = 'عميل';
  static const String supplierCustomerType = 'مورد/عميل';
  static const String exportSuccess = 'تم تصدير التقرير بنجاح';
  static const String exportFailedFormat = 'فشل في التصدير: %s';
  static const String fromDateLabel = 'من';
  static const String toDateLabel = 'إلى';
  static const String sortLabel = 'ترتيب';
  static const String sortByBalance = 'ترتيب بالرصيد';
  static const String sortByName = 'ترتيب بالاسم';
  static const String sortByDate = 'ترتيب بالتاريخ';
  static const String openingBalanceLabel = 'الرصيد الافتتاحي';
  static const String prepaidLabel = 'المدفوع مقدمًا';
  static const String addedDateLabel = 'تاريخ الإضافة';
  static const String unpaidPurchasesLabel = 'المشتريات غير المدفوعة';
  static const String purchaseReturnsLabel = 'مرتجع المشتريات';
  static const String finalDueLabel = 'المستحق النهائي';

  // ─── Reports: Extra Reports UI ───
  static const String reportsExtraTitle = 'تقارير إضافية';
  static const String dateRangePrefix = 'الفترة: %s';
  static const String selectItemTitle = 'اختر الصنف';
  static const String selectItemHint = 'اختر صنفاً من القائمة لعرض حركته';
  static const String selectItemPlaceholder = 'اختر صنفاً';
  static const String noMovementsTitle = 'لا توجد حركات';
  static const String noMovementsSubtitle = 'لا توجد حركات لهذا الصنف';
  static const String movementCountLabel = 'عدد الحركات';
  static const String totalQuantityLabel = 'إجمالي الكميات';
  static const String totalValueLabel = 'إجمالي القيمة';
  static const String soldItemsCountLabel = 'عدد الأصناف المباعة';
  static const String soldUnitsTotalLabel = 'مجموع الوحدات المباعة';
  static const String totalSalesAmountLabel = 'إجمالي المبيعات';
  static const String itemHeader = 'الصنف';
  static const String salesHeader = 'المبيعات';
  static const String avgPriceHeader = 'متوسط السعر';
  static const String invoicesCountHeader = 'عدد الفواتير';
  static const String customerCountLabel = 'عدد العملاء';
  static const String netPurchasesLabel = 'صافي المشتريات';
  static const String groupsLabel = 'المجموعات';
  static const String groupHeader = 'المجموعة';
  static const String customerHeader = 'العميل';
  static const String phoneHeader = 'الهاتف';
  static const String visitsHeader = 'الزيارات';
  static const String purchasesHeader = 'المشتريات';
  static const String returnsHeader = 'المرتجعات';
  static const String netHeader = 'الصافي';
  static const String receiptsCountLabel = 'عدد السندات';
  static const String totalAmountsLabel = 'إجمالي المبالغ';
  static const String noReceiptsTitle = 'لا توجد سندات';
  static const String noReceiptsSubtitle = 'لا توجد سندات مسجلة في الفترة المحددة';
  static const String notesHeader = 'ملاحظات';
  static const String repsCountLabel = 'عدد المندوبين';
  static const String totalCustomersLabel = 'إجمالي العملاء';
  static const String repHeader = 'المندوب';
  static const String noRepsTitle = 'لا توجد بيانات';
  static const String noRepsSubtitle = 'لا يوجد مندوبي مبيعات مسجلين';
  static const String noCustomersSubtitle = 'لا يوجد عملاء مسجلين لعرض التحليل';
  static const String noInventoryData = 'لا توجد بيانات جرد';
  static const String noTaxRecords = 'لا توجد سجلات ضريبية';
  static const String noEmployeeActivityData = 'لا يوجد نشاط موظفين تسجيلي';
  static const String loadingReportMessage = 'جاري تحميل التقرير...';
  static const String noSalesTitle = 'لا توجد مبيعات';
  static const String noSalesSubtitle = 'لا توجد مبيعات لعرض الأصناف الشائعة';
  static const String unitPriceHeader = 'سعر الوحدة';
  static const String amountHeader = 'المبلغ';
  static const String netProfitLabel = 'صافي الربح';
  static const String revenueLabel = 'الإيرادات';
  static const String cogsLabel = 'تكلفة البضاعة المباعة';
  static const String grossProfitLabel = 'مجمل الربح';
  static const String operatingExpensesLabel = 'المصروفات التشغيلية';
  static const String netSalesLabel = 'صافي المبيعات';
  static const String totalDebitLabel = 'إجمالي المدين';
  static const String totalCreditLabel = 'إجمالي الدائن';
  static const String journalBalancedMsg = 'القيود متوازنة خلال الفترة.';
  static const String journalUnbalancedMsg = 'يوجد فرق في القيود ويجب مراجعته.';
  static const String reportLoadError = 'حدث خطأ أثناء تحميل التقرير';
  static const String totalReceiptsLabel = 'إجمالي الاستلامات';
  static const String totalPurchasesAmountLabel = 'إجمالي المشتريات';
  static const String monthPurchasesLabel = 'مشتريات الشهر';
  static const String totalInvoicesCountLabel = 'إجمالي الفواتير';
  static const String todayInvoicesLabel = 'فواتير اليوم';
  static const String monthInvoicesLabel = 'فواتير الشهر';
  static const String contactsReportTitle = 'تقرير العملاء والموردين';
  static const String totalDebtsLabel = 'إجمالي الذمم';
  static const String debtorsCountLabel = 'عدد المدينون';
  static const String dueToSuppliersLabel = 'المستحق للموردين';
  static const String periodPrefix = 'الفترة: %s';
  static const String todayLabel = 'اليوم';
  static const String thisMonthLabel = 'هذا الشهر';
  static const String retryButton = 'إعادة المحاولة';

  // ─── Extra Reports: Type Labels ───
  static const String typeCustomerGroups = 'مجموعات العملاء';
  static const String typeReceipts = 'سجل السندات';
  static const String typeSalesRepPerformance = 'أداء المندوبين';

  // ─── Extra Reports: Type Subtitles ───
  static const String subtitleInventory = 'قيمة المخزون الحالية بسعر الشراء والبيع مع الربح المحتمل';
  static const String subtitleInventoryCount = 'إجمالي الداخل والخارج من سجل حركة المخزون';
  static const String subtitlePopularItems = 'الأصناف الأكثر مبيعاً حسب عدد الوحدات وقيمة البيع';
  static const String subtitleItemMovement = 'حركة صنف ناتجة عن البيع أو الشراء أو المرتجعات';
  static const String subtitleTaxSummary = 'تفاصيل ضرائب المبيعات والمشتريات والمصاريف';
  static const String subtitleEmployeeActivity = 'سجل مبسط للحركات التي تمت بواسطة الموظفين';
  static const String subtitleCustomerGroups = 'تحليل مجموعات العملاء حسب المشتريات والمرتجعات';
  static const String subtitleReceipts = 'سجل السندات: مبيعات، مشتريات، مرتجعات';
  static const String subtitleSalesRepPerformance = 'أداء مندوبي المبيعات حسب العملاء والمبيعات والمرتجعات';

  // ─── Extra Reports: Types ───
  static const String movementTypeSale = 'بيع';
  static const String movementTypePurchase = 'شراء';
  static const String movementTypeSaleReturn = 'مرتجع بيع';
  static const String movementTypePurchaseReturn = 'مرتجع شراء';

  // ─── Extra Reports: Titles ───
  static const String receiptTypeSaleInvoice = 'فاتورة بيع';
  static const String receiptTypePurchaseInvoice = 'فاتورة شراء';

  // ─── Extra Reports: Taxes ───
  static const String taxTypeVatSales = 'ضريبة القيمة المضافة (المبيعات)';
  static const String taxTypeIncomePurchase = 'ضريبة الدخل (شراء)';
  static const String taxTypeExpense = 'ضريبة النفقات';

  // ─── Extra Reports: Shifts ───
  static const String activityShiftOpen = 'فتح مناوبة';
  static const String activityShiftClose = 'إغلاق مناوبة';
  static const String activitySubjectShift = 'مناوبة كاشير';
  static const String activitySubjectEmployee = 'موظف';
  static const String activityActionAddUser = 'إضافة مستخدم';
  static const String activityRoleOwner = 'مالك';
  static const String activityRoleEmployee = 'موظف';
  static const String activityNotesShiftFormat = 'رقم المناوبة: %s';

  // ─── Extra Reports: Defaults ───
  static const String defaultNoGroup = 'بدون مجموعة';
  static const String paymentCash = 'نقدي';
  static const String paymentCard = 'بطاقة';
  static const String paymentCredit = 'آجل';
  static const String paymentWallet = 'محفظة';
  static const String paymentBankTransfer = 'تحويل بنكي';
  static const String unitAndInvoiceFormat = '%s وحدة — %s فاتورة';
  static const String visitsLabel = 'الزيارات';
  static const String inventoryMovementReportTitleFormat = 'تقرير جرد حركة الأصناف (%s)';
  static const String inventoryReportTitle = 'تقرير جرد المخزون';
  static const String customerGroupAnalysisTitle = 'تحليل العملاء حسب المجموعات';
  static const String receiptSummaryTitle = 'ملخص السندات';
  static const String salesRepPerformanceTitle = 'أداء مندوبي المبيعات';
}
