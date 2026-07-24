// purchases_strings.dart — المشتريات، مرتجعات الشراء



class PurchasesStrings {
  PurchasesStrings._();

  static const String purchaseReturnsTitle = 'مرتجعات المشتريات';
  static const String purchaseReturnsSubtitle = 'إدارة عمليات إرجاع البضائع للموردين وتتبع مبالغها';
  static const String addNewReturn = 'إضافة مرتجع جديد';
  static const String searchReturnHint = 'بحث برقم الفاتورة أو المورد...';
  static const String totalOperations = 'إجمالي العمليات';
  static const String allPurchases = 'كل المشتريات';
  static const String totalReturnedAmounts = 'إجمالي المبالغ المستردة';
  static const String noPurchaseReturns = 'لا توجد مرتجعات مشتريات مسجلة';
  static const String noPurchaseReturnsSubtitle = 'عند تسجيل مرتجع لمورد سيظهر هنا في القائمة مع تفاصيله';
  static const String purchaseReturnInvoicePrefix = 'مرتجع فاتورة #';
  static const String supplierPrefix = 'المورد: ';
  static const String itemsCountFormat = '%s صنف';
  static const String originalInvoice = 'الفاتورة الأصلية';
  static const String reasonLabel = 'سبب الارتجاع';
  
  // ─── Add Purchase ───
  static const String newPurchaseTitle = 'فاتورة مشتريات جديدة';
  static const String editPurchaseTitle = 'تعديل فاتورة مشتريات';
  static const String emptyPurchaseError = 'لا يمكن حفظ فاتورة فارغة';
  static const String selectSupplierError = 'يرجى اختيار مورد أولاً';
  static const String confirmExitMessage = 'لديك بيانات غير محفوظة في الفاتورة الحالية. هل أنت متأكد من الخروج؟';
  static const String supplierLabel = 'المورد*';
  static const String referenceNumberLabel = 'الرقم المرجعي';
  static const String purchaseDateLabel = 'تاريخ الشراء*';
  static const String purchaseStatusLabel = 'حالة الشراء*';
  static const String selectStatusHint = 'اختر الحالة';
  static const String statusReceived = 'استلم';
  static const String statusPending = 'معلق';
  static const String statusOrdered = 'مطلوب';
  static const String paymentTermLabel = 'فترة الدفع';
  static const String days = 'أيام';
  static const String months = 'أشهر';
  static const String unitLabelShort = 'وحدة';
  static const String keyboardShortcuts = 'اختصارات لوحة المفاتيح:';
  static const String shortcutSearch = 'بحث';
  static const String shortcutSave = 'حفظ';
  static const String shortcutFocusSearch = 'تركيز على البحث';
  static const String shortcutNavigateRows = 'تنقل بين الصفوف';
  static const String shortcutItemSearch = 'بحث الصنف';
  static const String shortcutClearCancel = 'مسح / إلغاء';
  static const String addItemToInvoiceTitle = 'إضافة صنف للفاتورة';
  static const String searchItemHint = 'اكتب اسم الصنف أو باركود...';
  static const String noMatchingResults = 'لا توجد نتائج مطابقة';
  static const String barcodeLabelPrefix = 'الباركود: ';
  static const String stockLabelPrefix = 'المخزون: ';
  static const String currentStockLabelFormat = 'المخزون الحالي: %s وحدة';
  static const String incomingQuantity = 'الكمية الواردة';
  static const String buyUnitPrice = 'سعر الوحدة (شراء)';
  static const String batchNumberLabel = 'رقم التشغيلية (Batch)';
  static const String expiryDateLabel = 'تاريخ الصلاحية';
  static const String selectDate = 'اختر التاريخ';
  static const String supplyUnit = 'وحدة التوريد';
  static const String selectUnitHint = 'اختر الوحدة';
  static const String itemDiscount = 'خصم الصنف';
  static const String percentSymbol = '%';
  static const String fixedValue = 'قيمة';
  static const String itemTaxValue = 'ضريبة الصنف (قيمة)';
  static const String lastPurchasePriceInfo = 'آخر سعر شراء مسجل لهذا الصنف: ';
  static const String addToInvoiceAction = 'إضافة للفاتورة';
  static const String newMedicineAction = 'صنف جديد';
  static const String columnHash = '#';
  static const String columnItemName = 'اسم الصنف';
  static const String columnStock = 'المخزون';
  static const String columnUnit = 'الوحدة';
  static const String columnQuantity = 'الكمية';
  static const String columnBuyPrice = 'سعر الشراء';
  static const String columnDiscountPercent = 'خصم %';
  static const String columnTotal = 'اجمالي';
  static const String columnSellPrice = 'سعر البيع';
  static const String columnBatch = 'رقم التشغيلة';
  static const String columnExpiry = 'تاريخ الصلاحية';
  static const String noItemsYet = 'لا توجد أصناف بعد';
  static const String totalQuantityLabel = 'الكمية: ';
  static const String totalAmountLabel = 'الاجمالي: ';
  static const String unitPiece = 'قرص';
  static const String expiryDateFormatHint = 'سنة / شهر / يوم';
  static const String addPaymentTitle = 'إضافة الدفع';
  static const String paidAmountLabel = 'المبلغ المدفوع*';
  static const String paidOnDateLabel = 'المدفوعة على*';
  static const String paymentMethodLabel = 'طريقة الدفع*';
  static const String selectPaymentMethodHint = 'اختر طريقة الدفع';
  static const String paymentMethodCash = 'نقدا';
  static const String paymentMethodCard = 'بطاقة';
  static const String paymentMethodCredit = 'آجل';
  static const String accountLabel = 'حساب';
  static const String selectAccountHint = 'اختر الحساب';
  static const String paymentNoteLabel = 'ملاحظة الدفع';
  static const String dueAmountLabel = 'المبلغ المستحق: ';

  // Return Reasons
  static const String reasonExpired = 'منتهي الصلاحية';
  static const String reasonDamaged = 'تالف';
  static const String reasonWrongItem = 'خطأ في الصنف';
  static const String reasonOther = 'أخرى';
  
  static const String undefined = 'غير محدد';
}


