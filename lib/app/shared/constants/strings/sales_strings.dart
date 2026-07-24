// sales_strings.dart — المبيعات، نقطة البيع (POS)، السلة، تقرير الوردية



class SalesStrings {
  SalesStrings._();

  // ─── Sales ───
  static const String salesTitle = 'كل المبيعات';
  static String saleSuccessFormat(String amount) => 'فاتورة بيع بقيمة $amount ج.م';
  static const String salesSubtitle =
      'متابعة وإدارة كافة عمليات البيع والتحصيلات وحالات الشحن.';
  static const String allSales = 'كل المبيعات';
  static const String shippingStatus = 'حالة الشحن';
  static const String paymentStatus = 'حالة الدفع';
  static const String shippingPending = 'في الانتظار';
  static const String shippingDelivered = 'تم التوصيل';
  static const String paymentPaid = 'مدفوع';
  static const String paymentPartial = 'جزئي';
  static const String paymentUnpaid = 'غير مدفوع';
  static const String addedBy = 'أضيفت بواسطة';
  static const String contactNumber = 'رقم الاتصال';
  static const String paidAmount = 'مدفوعات المبيعات';
  static const String dueAmount = 'بلغ مستحق';
  static const String viewColumns = 'رؤية العمود';
  static const String inspect = 'فحص';
  static const String invoicePayments = 'دفعات الفاتورة';
  static const String invoiceViewLink = 'رابط عرض الفاتورة';
  static const String createReturn = 'إنشاء مرتجع';
  static const String editShipping = 'تعديل الشحن والتوصيل';
  static const String deliveryNote = 'إشعار التسليم';
  static const String convertToCredit = 'تحويل لآجل';
  static const String newSale = 'فاتورة بيع جديدة';
  static const String posTitle = 'نقطة البيع (الكاشير)';
  static const String invoiceNumberLabel = 'رقم الفاتورة';
  static const String customerNameLabel = 'اسم العميل';
  static const String paymentMethodLabel = 'طريقة الدفع';
  static const String finalTotal = 'الإجمالي النهائي';
  static const String totalInvoices = 'إجمالي الفواتير';
  static const String todaySales = 'مبيعات اليوم';
  static const String thisMonthSales = 'مبيعات الشهر';
  static const String creditSales = 'البيع الآجل';
  static const String quickFilter = 'تصفية سريعة:';
  static const String emptySalesTitle = 'سجل المبيعات فارغ';
  static const String emptySalesSubtitle =
      'سوف تظهر فواتير المبيعات هنا بمجرد إتمام عمليات البيع.';
  static const String noMatchingResults = 'لا توجد نتائج مطابقة لبحثك';
  static const String cashCustomer = 'عميل نقدي (عام)';
  static const String totalValue = 'القيمة الإجمالية';
  static const String dateTime = 'التاريخ والوقت';
  static const String viewDetails = 'عرض التفاصيل';
  static const String voidInvoice = 'إلغاء الفاتورة';
  static const String voidInvoiceTitle = 'إلغاء فاتورة بيع';
  static const String voidInvoiceConfirmPrefix =
      'هل أنت متأكد من إلغاء الفاتورة #';
  static const String voidInvoiceWarning =
      'سيتم استرجاع المخزون وتعديل القيود المالية.';
  static const String yesVoidNow = 'نعم، إلغاء الآن';

  // ─── POS Toolbar ───
  static const String posAddExpenses = 'إضافة المصاريف';
  static const String posItemInquiry = 'الاستعلام عن الأصناف';
  static const String posQuickItems = 'الأصناف السريعة';
  static const String posSuspendedSales = 'المبيعات المعلقة';
  static const String posRecentTransactions = 'آخر الحركات';
  static const String posCustomerPayment = 'تحصيل من عميل';
  static const String posLoadFromCustomer = 'تحميل من عميل';
  static const String posSupplierPayment = 'دفعة لمورد';
  static const String posSalesReturn = 'مرتجع المبيعات';
  static const String posCalculator = 'آلة حاسبة';
  static const String posHideProducts = 'إخفاء المنتجات';
  static const String posShowProducts = 'عرض المنتجات';
  static const String posExitFullScreen = 'خروج من الشاشة الكاملة';
  static const String posFullScreen = 'شاشة كاملة';
  static const String posSessionDetails = 'تفاصيل الجلسة';
  static const String posCloseShift = 'إنهاء الجلسة';

  // ─── POS Cart ───
  static const String cartTitle = 'السلة';
  static const String cartProduct = 'المنتج';
  static const String cartQuantity = 'الكمية';
  static const String cartPrice = 'السعر';
  static const String cartTotal = 'الإجمالي';
  static const String cartDiscount = 'الخصم';
  static const String cartItemsCount = 'البنود';
  static const String cartPaymentCash = 'نقداً';
  static const String cartPaymentCard = 'بطاقة';
  static const String cartPaymentCredit = 'آجل';
  static const String cartPaymentMixed = 'مختلط';
  static const String cartSuspend = 'تعليق';
  static const String cartPurchaseOrder = 'أمر شراء';
  static const String cartSalesOrder = 'أمر بيع';
  static const String cartPay = 'دفع';
  static const String cartVoid = 'إلغاء';
  static const String cartEditItem = 'تعديل';
  static const String cartDiscountPercent = 'نسبة';
  static const String cartDiscountFixed = 'قيمة مقطوعة';
  static const String cartSearchProduct = 'البحث عن منتج';
  static const String cartAddCustomer = 'إضافة عميل جديد';

  // ─── POS Cart Table ───
  static const String cartTableProduct = 'الصنف';
  static const String cartTableUnit = 'الوحدة';
  static const String cartEmptyTitle = 'السلة فارغة، ابدأ بإضافة المنتجات';

  // ─── POS Cart Panel (نصوص الواجهة الموحّدة) ───
  static const String cartEmptyHint = 'أضف أصناف من القائمة على اليسار';
  static const String discountOnInvoice = 'خصم على الفاتورة';
  static const String quickValuesLabel = 'قيم سريعة:';
  static const String taxOnInvoice = 'ضريبة على الفاتورة';
  static const String paymentMethodLabelCart = 'طريقة الدفع';
  static const String editUnitPrice = 'تعديل سعر الوحدة';

  // ─── POS Dialogs ───
  static const String noMatchingSearchResults = 'لا توجد نتائج بحث مطابقة';
  static const String addToCart = 'إضافة للسلة';
  static const String addExpensesFromCashier = 'إضافة مصاريف من الخزينة';
  static const String recordExpense = 'تسجيل المصروف';
  static const String invalidExpenseInput = 'يرجى إدخال وصف ومبلغ صحيح';
  static const String topRequestedItems = 'الأصناف الأكثر طلباً';
  static const String noItemsAvailable = 'لا توجد أصناف متوفرة حالياً';
  static const String noPendingSales = 'لا توجد مبيعات معلقة';
  static const String resumeSale = 'استئناف';
  static const String selectCustomerFirst = 'يرجى اختيار عميل أولاً من القائمة';
  static const String selectSupplierFirst = 'يرجى اختيار مورد أولاً من القائمة';
  static const String customerPaymentTitle = 'دفعة من عميل';
  static const String supplierPaymentTitle = 'دفعة لمورد';
  static const String recordPayment = 'تسجيل الدفعة';
  static const String additionalDiscount = 'خصم إضافي على الفاتورة';
  static const String cashDiscountValue = 'قيمة الخصم النقدي';
  static const String cancelDiscount = 'إلغاء الخصم';
  static const String applyDiscount = 'تطبيق الخصم';
  static const String recentOperations = 'آخر العمليات المسجلة';
  static const String salesInvoices = 'الفواتير';
  static const String priceQuotes = 'عروض الأسعار';
  static const String drafts = 'المسودات';
  static const String noSalesInvoices = 'لا توجد فواتير مبيعات مسجلة';
  static const String cashCustomerLabel = 'زبون نقدي';
  static const String noPriceQuotes = 'لا توجد عروض أسعار';
  static const String confirmDeleteQuote = 'هل أنت متأكد من حذف عرض السعر هذا؟';
  static const String noDraftsPending = 'لا توجد مسودات معلقة';
  static const String untitledDraft = 'مسودة بدون عنوان';
  static const String confirmDelete = 'تأكيد الحذف';
  static const String permanentDelete = 'حذف نهائي';

  // ─── Price Quotes (عروض الأسعار) ───
  static const String createQuoteTitle = 'إنشاء عرض سعر جديد';
  static const String quoteCustomerLabel = 'اسم العميل الموجه إليه العرض *';
  static const String quoteCustomerHint = 'مثلاً: شركة النور أو أحمد محمد';
  static const String quoteNotesLabel = 'ملاحظات إضافية';
  static const String quoteNotesHint = 'تظهر في أسفل العرض...';
  static const String quoteItemsSection = 'أصناف عرض السعر';
  static const String itemNameOrService = 'اسم الصنف / الخدمة';
  static const String quantityLabel = 'الكمية';
  static const String unitPriceLabel = 'سعر الوحدة';
  static const String totalLabel = 'الإجمالي';
  static const String addNewItemLine = 'إضافة سطر جديد للأصناف';
  static const String subtotalBeforeDiscount = 'المجموع قبل الخصم:';
  static const String discountValueLabel = 'قيمة الخصم:';
  static const String finalNetTotal = 'الصافي النهائي:';
  static const String saveAndIssueQuote = 'حفظ واصدار عرض السعر';
  static const String enterCustomerNameWarning = 'يرجى إدخال اسم العميل';
  static const String addAtLeastOneItemWarning = 'أضف صنف واحد صالح على الأقل';
  static const String deleteLineTooltip = 'حذف السطر';
  static const String itemOrSearchHint = 'اسم الصنف أو بحث...';
  static const String priceStockFormat = 'السعر: %s | المخزون: %s';

  // ─── Quote Status Labels ───
  static const String statusDraft = 'مسودة';
  static const String statusSent = 'مرسل';
  static const String statusAccepted = 'مقبول';
  static const String statusRejected = 'مرفوض';
  static const String quotesTitle = 'عروض الأسعار';
  static const String errorLoadingQuotes = 'خطأ في تحميل عروض الأسعار';
  static const String createQuoteAction = 'إنشاء عرض سعر';
  static const String quoteNumberTitleFormat = 'عرض سعر #%s — %s';
  static const String deleteQuoteTitle = 'حذف عرض السعر';
  static const String deleteQuoteConfirmFormat =
      'هل أنت متأكد من حذف عرض السعر رقم #%s؟';
  static const String packing = 'التغليف';
  static const String printInvoice = 'طباعة الفاتورة';
  static const String paymentInfo = 'معلومات الدفع:';
  static const String itemsTitle = 'الأصناف:';
  static const String saleDetailsTitle =
      'تفاصيل المبيعات ( الفاتورة رقم : %s )';
  static const String amountPaid = 'المبلغ المدفوع';
  static const String method = 'طريقة الدفع';

  // ─── POS Layout & Messages ───
  static const String stockLimitExceeded =
      'الكمية المطلوبة تتجاوز المخزون المتاح';
  static const String barcodeOrNameSearch = 'بحث بالباركود / الاسم...';
  static const String startTypingOrScan = 'ابدأ الكتابة أو امسح الباركود';
  static const String quickNavTooltip = 'التنقل السريع';
  static const String homeAction = 'الرئيسية';
  static const String hideCatalog = 'إخفاء الكتالوج';
  static const String showCatalog = 'عرض الكتالوج';
  static const String shiftInfoFormat = 'الوردية #%s — %s';
  static const String shiftIsClosed = 'الوردية مغلقة';
  static const String closeShiftTitle = 'غلق الوردية';
  static const String cashSalesLabel = 'المبيعات النقدية';
  static const String expectedCashLabel = 'النقدية المتوقعة';
  static const String actualCashLabel = 'النقدية الفعلية';
  static const String optionalNotesLabel = 'ملاحظات (اختياري)';
  static const String defaultSellPriceGroup = 'سعر البيع الافتراضي';
  static const String regularPriceLabel = 'السعر العادي (جمهور)';
  static const String wholesalePriceLabel = 'سعر الجملة المعتمد';
  static const String semiWholesalePriceLabel = 'سعر نصف الجملة';
  static const String fastCashCustomer = 'زبون نقدي (سريع)';
  static const String balanceFormat = 'الرصيد: %s';

  // ─── Sales Returns ───
  static const String salesReturnsTitle = 'مرتجعات المبيعات';
  static const String createReturnAction = 'إنشاء مرتجع';
  static const String searchReturnHintSales = 'بحث عن مرتجع أو فاتورة...';
  static const String totalReturnsLabel = 'إجمالي المرتجعات';
  static const String totalReturnedAmountsSales = 'إجمالي المبالغ المرتجعة';
  static const String returnNumberPrefix = 'مرتجع #';
  static const String createSalesReturnTitle = 'إنشاء مرتجع بيع';
  static const String selectOriginalInvoiceHint =
      'اختر الفاتورة الأصلية لإنشاء المرتجع';
  static const String selectInvoiceHint = 'اختر الفاتورة';
  static const String invoiceNumberDateFormat = 'فاتورة #%s - %s';
  static const String returnReasonLabel = 'سبب المرتجع';
  static const String reasonWrongItemSales = 'صنف خاطئ';
  static const String reasonCustomerReturn = 'مرتجع عميل';
  static const String confirmReturnAction = 'تأكيد المرتجع';
  static const String selectAtLeastOneItemError =
      'يرجى اختيار صنف واحد على الأقل';

  // ─── Open Shift ───
  static const String startNewShift = 'بدء وردية جديدة';
  static const String enterInitialCashHint =
      'يرجى إدخال الرصيد النقدي المتوفر في الدرج الآن';
  static const String openShiftAction = 'فتح وردية';
  static const String enterOpeningBalanceHint = 'أدخل الرصيد الافتتاحي';
  static const String shiftOpenedSuccess = 'تم فتح الوردية بنجاح';
  static const String shiftClosedSuccess = 'تم غلق الوردية بنجاح';
  static const String paymentMismatch = 'إجمالي المبلغ المدفوع (%s) يجب أن يتطابق مع إجمالي الفاتورة (%s)';
  static const String printEnabled = 'الطباعة: مفعلة';
  static const String printDisabled = 'الطباعة: معطلة';
  static const String shiftOpenFailedFormat = 'فشل فتح الوردية: %s';

  // ─── Cashier Register (سجل الكاشير) ───
  static const String cashierShiftsSubtitle = 'إدارة ورديات الصندوق والمقبوضات اليومية';
  static const String openShiftsLabel = 'الورديات المفتوحة';
  static const String closedShiftsLabel = 'الورديات المغلقة';
  static const String totalRecordsLabel = 'إجمالي السجلات';
  static const String noShiftsMessage = 'لم يتم بدء أي وردية كاشير حتى الآن، اضغط على زر جديد لبدء العمل';
  static const String startFirstShift = 'بدء أول وردية';
  static const String openedAtLabel = 'الفتح:';
  static const String shiftLabel = 'وردية';
  static const String cashierShiftsTitle = 'سجل الكاشير';
  static const String startNewSession = 'جلسة جديدة';
  static const String openCashier = 'فتح الكاشير';
  static const String openingDate = 'تاريخ الفتح';
  static const String openingCash = 'النقدية الافتتاحية';
  static const String closingDate = 'تاريخ الإغلاق';
  static const String closingCash = 'النقدية الختامية';
  static const String invoiceCount = 'عدد الفواتير';
  static const String totalReturns = 'إجمالي المرتجعات';
  static const String netAmount = 'الصافي';
  static const String saleType = 'بيع';
  static const String returnType = 'مرجع';

  // ─── Shift Report ───
  static const String shiftReportTitle = 'تقرير الوردية';
  static const String shiftCashSales = 'المبيعات النقدية';
  static const String shiftCardSales = 'مبيعات البطاقة';
  static const String shiftTotalSales = 'إجمالي المبيعات';
  static const String shiftExpenses = 'المصروفات';
  static const String shiftExpectedCash = 'المبلغ المتوقع';
  static const String shiftCountedCash = 'المبلغ الموجود';
  static const String shiftDifference = 'الفارق';
  static const String shiftClosed = 'الوردية مغلقة';
  static const String shiftOpened = 'الوردية مفتوحة';
  static const String shiftNoOpen = 'لا توجد وردية مفتوحة';
  static const String shiftOpenTitle = 'إدارة الورديات';
  static const String shiftViewDetails = 'عرض التفاصيل';

  static const String allReturns = 'كل المرتجعات';
  static const String cardSalesLabelShifts = 'مبيعات الشبكة';
  static const String creditSalesLabelShifts = 'مبيعات الآجل';
  static const String openLabel = 'مفتوحة';
  static const String closedLabel = 'مغلقة';
  static const String openingLabelShifts = 'الافتتاحي';
  static const String actualAmountPrefix = 'الفعلي';
  static const String noShiftsYet = 'لا توجد ورديات سابقة';
  static const String itemNameLabel = 'اسم الصنف';

  static const String searchSalesInvoicesHint =
      'بحث برقم الفاتورة، اسم العميل، أو صنف محدد...';
  static const String itemsLabelSales = 'الأصناف';
  static const String resetFilters = 'إعادة ضبط الفلاتر';
  static const String showEntries = 'عرض الإدخالات:';
  static const String exportCsv = 'تصدير CSV';
  static const String exportExcel = 'تصدير Excel';
  static const String options = 'خيارات';
  static const String back = 'تراجع';
  static const String saleInvoiceDetails = 'تفاصيل فاتورة البيع';
  static const String errorInvalidInvoice = 'لم يتم تمرير فاتورة صحيحة';
  static const String invoiceLabelSales = 'فاتورة';

  // ─── Promotions ───
  static const String promotionsTitle = 'العروض والترقيات';
  static const String createPromotion = 'إنشاء عرض جديد';
  static const String promotionNameLabel = 'اسم العرض';
  static const String promotionTypeLabel = 'نوع العرض';
  static const String promotionValueLabel = 'قيمة الخصم';
  static const String promotionStartDate = 'تاريخ البدء';
  static const String promotionEndDate = 'تاريخ الانتهاء';
  static const String promotionActiveLabel = 'نشط';
  static const String promotionInactiveLabel = 'غير نشط';
  static const String noPromotions = 'لا توجد عروض نشطة';
  static const String promotionDeleted = 'تم حذف العرض';
  static const String promotionCreated = 'تم إنشاء العرض';
  static const String promotionUpdated = 'تم تحديث العرض';
  static const String discountTypeLabel = 'نوع الخصم';
  static const String percentageLabel = 'نسبة';
  static const String fixedAmountLabel = 'قيمة ثابتة';
  static const String applyPromotion = 'تطبيق العرض';
  static const String removePromotion = 'إزالة العرض';
  static const String promotionApplied = 'تم تطبيق العرض';

  // ─── Damaged Stock ───
  static const String damagedStockTitle = 'الأصناف التالفة';
  static const String recordDamage = 'تسجيل تالف';
  static const String damageReasonLabel = 'سبب التلف';
  static const String damageQuantityLabel = 'الكمية التالفة';
  static const String damageNotesLabel = 'ملاحظات';
  static const String noDamagedStock = 'لا توجد أصناف تالفة مسجلة';
  static const String damageRecorded = 'تم تسجيل التلف';
  static const String damageDeleted = 'تم حذف سجل التالف';

  // ─── Opening Stock ───
  static const String openingStockTitle = 'الرصيد الافتتاحي';
  static const String recordOpeningStock = 'تسجيل رصيد افتتاحي';
  static const String openingQuantityLabel = 'الكمية الافتتاحية';
  static const String openingBuyPriceLabel = 'سعر الشراء';
  static const String noOpeningStock = 'لا توجد أرصدة افتتاحية مسجلة';
  static const String openingRecorded = 'تم تسجيل الرصيد الافتتاحي';
  static const String openingDeleted = 'تم حذف الرصيد الافتتاحي';

  // ─── POS Messages (Success/Warning/Error) ───
  static const String posNoStockFormat = 'لا يوجد مخزون كافٍ من "%s"، المتاح: %s';
  static const String posBarcodeNotFoundFormat = 'لا يوجد دواء بهذا الباركود: %s';
  static const String posCreditNeedsCustomer = 'يرجى اختيار عميل للبيع الآجل';
  static const String posShiftOpenedFormat = 'تم فتح الوردية رقم #%s بنجاح';
  static const String posShiftNotFound = 'لا توجد وردية مفتوحة للإغلاق';
  static const String posShiftClosedFormat = 'تم إغلاق الوردية #%s - الفرق: %s';
  static const String posShiftCloseFailedFormat = 'فشل إغلاق الوردية: %s';
  static const String posShiftRequired = 'يجب فتح وردية أولاً';
  static const String posSaleSuccessFormat = 'تمت العملية بنجاح (فاتورة #%s)';
  static const String posSaleFailedFormat = 'فشل في تسجيل الفاتورة: %s';
  static const String posPrintWarningFormat = 'تنبيه: فشلت الطباعة ولكن العملية مسجلة (%s)';
  static const String posCartEmpty = 'السلة فارغة';
  static const String posSaleSuspended = 'تم تعليق الفاتورة وحفظها';
  static const String posSaleResumed = 'تم استعادة الفاتورة المعلقة';
  static const String posCartEmptyForQuote = 'السلة فارغة — أضف أصنافاً لعرض السعر';
  static const String posQuoteCreated = 'تم إنشاء عرض السعر بنجاح';
  static const String posExpenseRequiredShift = 'يجب فتح وردية أولاً';
  static const String posExpenseRecordedFormat = 'مصروف على وردية #%s: %s — %s';
  static const String posExpenseLogged = 'تم تسجيل المصروف على الوردية';
  static const String posCustomerNotFound = 'العميل غير موجود';
  static const String posCustomerPaymentFormat = 'تم تسجيل دفعة العميل %s بمبلغ %s';
  static const String posSupplierNotFound = 'المورد غير موجود';
  static const String posSupplierPaymentFormat = 'تم تسجيل دفعة للمورد %s بمبلغ %s';
  static const String posEditSaleLoaded = 'تم إلغاء الفاتورة القديمة وتحميل محتوياتها للتعديل';
  static const String posEditQuoteLoaded = 'تم تحميل عرض السعر للتعديل وأرشفة القديم';
  static const String posAutoPrintEnabled = 'تم تفعيل الطباعة التلقائية';
  static const String posAutoPrintDisabled = 'تم تعطيل الطباعة التلقائية';
  static const String posCashCustomer = 'عميل نقدي';

  // ─── POS Nav Drawer ───
  static const String saleScreenNav = 'شاشة البيع';
  static const String salesInvoicesNav = 'فواتير البيع';
  static const String salesReturnNav = 'مرتجع البيع';
  static const String shiftsNav = 'الورديات';
  static const String inventoryNav = 'المخزون';
  static const String purchasesNav = 'المشتريات';
  static const String customersNav = 'العملاء';
  static const String suppliersNav = 'الموردون';
  static const String salesReportsNav = 'تقارير المبيعات';
  static const String accountingNav = 'الحسابات';
  static const String homeNav = 'الرئيسية';

  // ─── POS Totals Bar ───
  static const String grandTotalLabel = 'المجموع الإجمالي';
  static const String collapseLabel = 'أقل';
  static const String itemCountFormat = 'العدد: %s';
  static const String detailsLabel = 'التفاصيل';

  // ─── Edit Cart Line Dialog ───
  static const String unitPriceFieldLabel = 'سعر الوحدة';
  static const String discountTypeFieldLabel = 'نوع الخصم';
  static const String fixedAmountShort = 'ثابت';
  static const String discountAmountFieldLabel = 'مبلغ الخصم';
  static const String itemNotesFieldLabel = 'ملاحظات الصنف';

  // ─── POS Catalog Panel ───
  static const String searchItemsHint = 'بحث في الأصناف...';
  static const String noItemsFound = 'لا توجد أصناف';

  // ─── Shift Report Dialog ───
  static const String noOpenShiftWarning = 'لا توجد وردية مفتوحة حالياً';
  static const String noOpenShiftEndWarning = 'لا توجد وردية مفتوحة حالياً لإنهاء الجلسة';
  static const String sessionDetailsTitle = 'تفاصيل الجلسة الحالية';
  static const String printReportLabel = 'طباعة التقرير';
  static const String endSessionTitle = 'إنهاء الجلسة وغلق الوردية';
  static const String endSessionNowLabel = 'إنهاء الجلسة الآن';
  static const String enterValidAmountMsg = 'يرجى إدخال مبلغ صحيح';
  static const String sessionClosedSuccessMsg = 'تم إنهاء الجلسة بنجاح وغلق الوردية';
  static const String actualCashFieldLabel = 'مجموع النقد الفعلي بالدرج *';
  static const String closingNoteFieldLabel = 'ملاحظة ختامية (اختياري)';
  static const String returnsLabel = 'المرتجع';
  static const String paymentSummaryTitle = 'ملخص طرق الدفع';
  static const String salesColumnHeader = 'المبيعات';
  static const String expenseColumnHeader = 'مصروف';
  static const String paymentCashRow = 'الدفع نقداً';
  static const String paymentCardRow = 'الدفع بالبطاقة';
  static const String creditSaleRow = 'بيع آجل';
  static const String mixedPaymentRow = 'دفع متعدد';
  static const String expectedDrawerTotalRow = 'إجمالي المتوقع في الدرج';
  static const String soldItemsSectionTitle = 'تفاصيل الأصناف المباعة';
  static const String noSalesInShiftMsg = 'لا توجد مبيعات في هذه الوردية';
  static const String drawerDetailsSectionTitle = 'تفاصيل الخزينة (الدرج)';
  static const String openingBalanceRow = '+ رصيد افتتاحي';
  static const String cashSalesRow = '+ مبيعات نقدية';
  static const String customerCollectionsRow = '+ تحصيلات عملاء';
  static const String cashExpensesRow = '- مصاريف نقدية';
  static const String finalExpectedTotalRow = '= المجموع النهائي المتوقع';

  // ─── Desktop Dialogs ───
  static const String addTaxTitle = 'إضافة ضريبة';
  static const String addInvoiceDiscountTitle = 'إضافة خصم الفاتورة';
  static const String taxAmountFieldLabel = 'مبلغ الضريبة';
  static const String fixedAmountChipLabel = 'مبلغ ثابت';
  static const String currentBalanceFormat = 'الرصيد الحالي: %s';
  static const String selectCustomerFirstWarning = 'يرجى اختيار عميل أولاً للبحث عن مسوداته أو عروض أسعاره.';
  static const String noDataForCustomerTitle = 'لا توجد بيانات لهذا العميل';
  static const String noDataForCustomerSubtitle = 'لم يتم العثور على عروض أسعار أو مسودات مرتبطة بهذا العميل.';
  static const String customerQuotesSectionTitle = 'عروض أسعار العميل';
  static const String pendingDraftsSectionTitle = 'المسودات المعلقة';
  static const String invoiceItemSummaryFormat = '%s — %s صنف — %s';
  static const String confirmVoidInvoiceMsg = 'هل أنت متأكد من إلغاء وحذف هذه الفاتورة؟ سيتم إرجاع الكميات للمخزن.';
  static const String quickExpensesLabel = 'مصاريف سريعة:';
  static const String expenseDescriptionLabel = 'وصف المصروف *';
  static const String expenseDescriptionHint = 'أدخل الوصف يدوياً أو اختر من الأعلى';
  static const String expenseAmountLabel = 'المبلغ المسحوب *';
  static const String quoteNumberFormatShort = 'عرض سعر #%s';
  static const String discountPercentFormat = '%s% خصم';
  static const String discountFixedFormat = '%s خصم';
  static const String unnamedCustomer = 'عميل غير مسمى';
  static const String jointSupplierCustomer = '(مورد/عميل)';
  static const String creditLimitFormat = ' [سقف: %s]';
  static const List<String> quickExpenseOptions = ['كهرباء', 'مياه', 'إيجار', 'رواتب', 'نظافة', 'بوفيه', 'أدوات مكتبية', 'صيانة'];
}


