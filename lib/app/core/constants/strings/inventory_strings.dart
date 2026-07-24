// inventory_strings.dart — المخزون، استيراد Excel، صحة المخزون، الوحدات

class InventoryStrings {
  InventoryStrings._();

  // ─── Import Medicines (Excel) ───
  static const String importMedicinesTitle = 'استيراد الأدوية من Excel';
  static const String importMedicinesDesc =
      'اختر ملف Excel (xlsx) بصيغة الأصناف لتحميله إلى قاعدة البيانات.';
  static const String importMedicinesNoFile = 'لم يتم اختيار ملف بعد';
  static const String importProgress = 'جاري الرفع... ';
  static const String importButton = 'اختيار ملف واستيراد';
  static const String importButtonLoading = 'جاري الاستيراد...';
  static const String importNewImport = 'استيراد ملف جديد';
  static const String importSuccessPrefix = 'تم استيراد ';
  static const String importSuccessSuffix = ' صنف بنجاح';
  static const String importNoData =
      'لم يتم العثور على بيانات صالحة للاستيراد في الملف.';
  static const String importFailPrefix = 'فشل الاستيراد: ';
  static const String importSnackbarTitleSuccess = 'نجح';
  static const String importSnackbarTitleWarning = 'تنبيه';
  static const String importSnackbarSuccessPrefix = 'تم استيراد ';
  static const String importSnackbarSuccessSuffix = ' بنجاح';
  static const String importSnackbarNoData =
      'لم يتم العثور على بيانات صالحة للاستيراد في الملف';
  static const String importSnackbarTitleError = 'خطأ في الاستيراد';
  static const String importSnackbarErrorPrefix = 'فشل في استيراد البيانات: ';
  static const String importBranchMissing =
      'لم يتم العثور على معرف الفرع الحالي.';
  static const String importFileMissing = 'يجب توفير مسار الملف أو محتواه.';
  static const String importFileEmpty = 'ملف Excel فارغ أو غير صالح.';
  static const String importFileNoData = 'لا توجد بيانات في ملف Excel.';
  static const String importStepReading = 'جاري فتح الملف وقراءة البيانات...';
  static const String importStepParsing =
      'جاري تحليل البيانات واستخراج الأصناف...';
  static const String importStepSaving =
      'جاري حفظ الأصناف في قاعدة البيانات...';
  static const String importStepDone = 'تم الانتهاء!';
  static const String importStatsFound = 'الأصناف الموجودة';
  static const String importStatsNew = 'جديد';
  static const String importStatsUpdated = 'محدث';
  static const String importStatsSkipped = 'متخطى';
  static const String importStatsSaved = 'محفوظ';
  static const String importStatsTotal = 'الإجمالي';
  static const String sidebarItemItemUnits = 'وحدات الاصناف';
  static const String sidebarItemItemGroups = 'مجموعات الاصناف';
  static const String sidebarItemItemWarranties = 'ضمانات الاصناف';
  static const String sidebarItemImportOpeningStock = 'استيراد كميات افتتاحية';
  static const String sidebarItemSwapItems = 'تبادل أصناف';

  // ─── Inventory ───
  static const String inventoryTitle = 'قائمة الأدوية والمخزون';
  static const String inventorySubtitle =
      'إدارة الأصناف والأسعار والكميات المتوفرة في المخزن';
  static const String addMedicine = 'إضافة دواء جديد';
  static const String editMedicine = 'تعديل بيانات الدواء';
  static const String medicineNotFound = 'لم يتم العثور على الدواء المطلوب';
  static const String editMedicineFor = 'تعديل صنف: ';
  static const String basicInfo = 'البيانات الأساسية للصنف';
  static const String itemVisualImage = 'صورة الصنف';
  static const String itemVisualImageOptional = 'صورة الصنف (اختياري)';
  static const String imageNotSelected = 'لم يتم تحديد صورة';
  static const String imageUrlHint = 'لم يتم إدخال رابط صورة';
  static const String imageUploadHint = 'أدخل رابط الصورة للعرض في النظام.';
  static const String imageUrlTitle = 'رابط الصورة';
  static const String imageUrlLabel = 'أدخل رابط الصورة (URL)';
  static const String extraOptionsToggle = 'تفعيل الخيارات الإضافية';
  static const String strength = 'التركيز الفعال';
  static const String packageSize = 'مواصفات العبوة الخارجية';
  static const String dosageFormHint = 'اختر الشكل الصيدلاني...';
  static const String dosageFormLabel = 'الشكل الصيدلاني';
  static const String containerShapeHint = 'اختر شكل العبوة الخارجي...';
  static const String containerShapeLabel = 'شكل العبوة الخارجي';
  static const String storageLocation = 'موقع التخزين';
  static const String classificationAndBarcode = 'التصنيف والباركود';
  static const String itemTypeLabel = 'نوع الصنف';
  static const String groupLabel = 'المجموعة العلاجية';
  static const String generateBarcode = 'توليد باركود آلي';
  static const String generateBarcodeTooltip = 'توليد باركود تلقائي من النظام';
  static const String barcodeGeneratedSuccess = 'تم توليد باركود تلقائي: ';
  static const String linkExtraBarcode = 'ربط باركود إضافي';
  static const String mainBarcode = 'الباركود الرئيسي';
  static const String barcodeLabel = 'الباركود';
  static const String barcodeMainLabel = 'الباركود الرئيسي';
  static const String extraBarcodePrefix = 'باركود إضافي رقم ';
  static const String addExtraBarcodePrefix = 'إضافة باركود إضافي رقم ';
  static const String supplierLabel = 'المورد المعتمد';
  static const String supplierHint = 'اربط الدواء بشركة التوزيع الافتراضية.';
  static const String pricingAndUnits = 'الأسعار ومستويات الوحدات';
  static const String pricingAndUnitsAdd = 'التسعير وتدرج الوحدات للبيع';
  static const String dualPricingToggle = 'تفعيل السعر المزدوج (قديم + جديد)';
  static const String addSubUnit = 'إضافة وحدة فرعية (شريط)';
  static const String addSubUnitSimple = 'إضافة وحدة تجزئة (شريط)';
  static const String addSubSubUnit = 'إضافة مستوى تجزئة أصغر (قرص)';
  static const String profitMarginPrefix = 'هامش الربح: ';
  static const String profitMarginSimplePrefix = 'هامش الربح: ';
  static const String taxAndAdvanced = 'الضرائب والإعدادات المتقدمة';
  static const String taxAndAdvancedSimple = 'الضرائب والإعدادات';
  static const String isTaxable = 'خاضع للضريبة المضافة';
  static const String isTaxableSimple = 'خاضع للضريبة';
  static const String allowNegativeStock = 'السماح بالرصيد السالب';
  static const String allowNegativeStockSimple = 'السماح بالرصيد السالب';
  static const String taxType = 'نوع الضريبة';
  static const String taxPercentage = 'نسبة الضريبة %';
  static const String fixedTax = 'قيمة الضريبة المضافة';
  static const String pricesIncludeTax = 'الأسعار شاملة الضريبة';
  static const String pricesIncludeTaxSimple = 'الأسعار شاملة الضريبة';
  static const String isActiveItem = 'الصنف نشط وفعال (متاح للبيع والشراء)';
  static const String isActiveSimple = 'الصنف نشط';
  static const String isActiveLabel = 'الصنف نشط';
  static const String datePickerHint = 'اختر التاريخ من التقويم...';
  static const String inventorySecurity = 'مراقبة المخزون وتواريخ الصلاحية';
  static const String inventorySecurityAdd = 'مراقبة النواقص وتواريخ الصلاحية';
  static const String lowStockAlert = 'تنبيه حد النواقص';
  static const String lowStockAlertOptional = 'تنبيه حد النواقص (اختياري)';
  static const String minStockLimit = 'الحد الأدنى للنواقص';
  static const String minStockLimitSimple = 'الحد الأدنى للنواقص';
  static const String expiryTracking = 'تتبع تاريخ انتهاء الصلاحية';
  static const String expiryTrackingOptional =
      'تتبع تاريخ انتهاء الصلاحية (اختياري)';
  static const String currentExpiryDate = 'تاريخ انتهاء الصلاحية';
  static const String currentExpiryDateAdd = 'تاريخ انتهاء الصلاحية';
  static const String notesAndFormulas = 'ملاحظات وتراكيب';
  static const String notesAndFormulasAdd = 'ملاحظات إضافية وتراكيب';
  static const String cancelEdit = 'إلغاء التعديل';
  static const String confirmCancelEdit = 'تأكيد إلغاء التغييرات';
  static const String unsavedChangesMessage =
      'لديك تعديلات غير محفوظة. هل تريد الخروج وإهمالها؟';
  static const String unsavedChangesSimple =
      'لديك تغييرات غير محفوظة. هل تريد الخروج؟';
  static const String continueEditing = 'استمرار التعديل';
  static const String exitWithoutSave = 'خروج بدون حفظ';
  static const String saveAllChanges = 'حفظ كل التعديلات';
  static const String submittingChanges = 'جاري تحديث بيانات الصنف...';
  static const String saveMedicineFull = 'حفظ الصنف في النظام';
  static const String submittingMedicine = 'جاري حفظ الصنف...';
  static const String importExcel = 'استيراد Excel';
  static const String totalItems = 'الإجمالي';
  static const String lowStock = 'نواقص';
  static const String outOfStock = 'نفذت';
  static const String expired = 'منتهي';
  static const String expiringSoon = 'وشك ينتهي';
  static const String searchInventoryHint = 'بحث بالاسم أو الباركود...';
  static const String displayCategory = 'تصنيف العرض';
  static const String itemLabel = 'صنف';
  static const String emptyInventoryTitle = 'المخزن فارغ حالياً';
  static const String emptyInventorySubtitle = 'ابدأ بإضافة أصناف أدوية جديدة.';
  static const String importingData = 'جاري استيراد البيانات...';
  static const String doNotClosePage =
      'برجاء عدم إغلاق الصفحة حتى اكتمال العملية';
  static const String medicineNameAr = 'اسم الدواء (عربي) *';
  static const String medicineNameEn = 'اسم الدواء (إنجليزي)';

  // ─── Inventory Health ───
  static const String inventoryHealthTitle = 'صحة المخزون';
  static const String expiredItems = 'منتهي الصلاحية';
  static const String expires30Days = 'ينتهي خلال 30 يوماً';
  static const String expires90Days = 'ينتهي خلال 90 يوماً';
  static const String lowStockItems = 'مخزون منخفض';
  static const String outOfStockItems = 'نفد المخزون';
  static const String expiredItemsDetailed = 'أدوية منتهية الصلاحية';
  static const String expires30DaysDetailed = 'تنتهي خلال 30 يوماً';
  static const String expires90DaysDetailed = 'تنتهي خلال 90 يوماً';
  static const String lowStockItemsDetailed = 'مخزون منخفض';
  static const String outOfStockItemsDetailed = 'أصناف نفدت تماماً';
  static const String cleanSectionMessage = 'القسم نظيف ولا توجد تحذيرات!';
  static const String stockBalanceLabel = 'الرصيد: ';
  static const String safetyLimitLabel = 'حد الأمان: ';
  static const String expiryLabel = 'صلاحية: ';
  static const String quickPurchaseRequest = 'طلب شراء سريع';

  // ─── Units ───
  static const String mainUnitTitle = 'العبوة الرئيسية (العلبة)';
  static const String mainUnitTitleSimple = 'العبوة الرئيسية (العلبة)';
  static const String subUnitTitle = 'الوحدة الفرعية للتجزئة';
  static const String subUnitTitleSimple = 'الوحدة الفرعية (التجزئة)';
  static const String conversionFactorInfoPrefix = 'معامل التفكيك: تحتوي على ';
  static const String conversionFactorInfoSimplePrefix =
      'معامل التعبئة: تحتوي على ';
  static const String mainUnitNameLabel = 'اسم وحدة البيع (علبة)';
  static const String mainUnitNameLabelSimple = 'اسم الوحدة (علبة)';
  static const String subUnitNameLabel = 'اسم الوحدة الفرعية (شريط/قرص)';
  static const String subUnitNameLabelSimple = 'اسم الوحدة الفرعية (شريط/قرص)';
  static const String factorLabel = 'معامل التحويل';
  static const String factorLabelSimple = 'معامل التفكيك';
  static const String buyPriceLabel = 'سعر الشراء';
  static const String buyPriceLabelSimple = 'سعر الشراء';
  static const String sellPriceLabel = 'سعر البيع';
  static const String sellPriceLabelSimple = 'سعر البيع';
  static const String oldSellPriceLabel = 'سعر بيع قديم';
  static const String oldSellPriceLabelSimple = 'سعر بيع قديم';
  static const String currentStockLabel = 'الرصيد الحالي';
  static const String currentStockLabelSimple = 'الرصيد الحالي';
  static const String discountLabel = 'نسبة الخصم % (اختياري)';
  static const String discountLabelSimple = 'نسبة الخصم %';
  static const String allowSaleLabel = 'مسموح بالبيع';
  static const String blockSaleLabel = 'محظور من البيع';
  static const String blockSaleLabelSimple = 'محظور من البيع';

  // ─── Stock Adjustment ───
  static const String stockAdjustmentTitle = 'تسوية رصيد جرد';
  static const String stockAdjustmentSubtitle =
      'تعديل كمية المخزون يدوياً لتطابق الكمية الفعلية على الرف';
  static const String currentSystemStock = 'الرصيد الحالي بالسيستم';
  static const String approveNewQuantity = 'اعتماد الكمية الجديدة';
  static const String invalidStockQuantity =
      'يرجى إدخال كمية جرد صحيحة أكبر من أو تساوي الصفر';

  // ─── Barcode Settings ───
  static const String barcodeSettingsTitle = 'إعدادات طباعة الباركود';
  static const String barcodeSettingsSubtitle =
      'تخصيص أبعاد ملصقات الباركود والبيانات المعروضة عليها للطباعة الحرارية أو الورقية';
  static const String saveBarcodeSettings = 'حفظ وتطبيق الإعدادات النهائية';
  static const String generationAlgorithm = 'خوارزمية توليد الأكواد';
  static const String barcodePrefixLabel = 'بادئة الباركود (Prefix)';
  static const String serialLengthLabel = 'طول التسلسل المولد';
  static const String encodingFormatLabel = 'صيغة التشفير (Encoding)';
  static const String encodingFormatHint =
      'اختر المعيار المناسب لماكينة الطباعة';
  static const String code128Desc = 'Code 128 (عالي الكثافة - موصى به)';
  static const String ean13Desc = 'EAN-13 (معياري صيدليات عالمي)';
  static const String pharmacySignatureTitle = 'توقيع الصيدلية الذكي';
  static const String pharmacySignatureSubtitle =
      'توليد بادئة فريدة بناءً على اسم الصيدلية لتمييز أصنافك';
  static const String pharmacyNameSignature = 'اسم الصيدلية للتوقيع';
  static const String pharmacyNameSignatureHint = 'ادخل الاسم الرسمي للصيدلية';
  static const String visualLabelDesign = 'تصميم الملصق المرئي';
  static const String labelWidthMm = 'عرض الملصق (مم)';
  static const String labelHeightMm = 'ارتفاع الملصق (مم)';
  static const String labelContents = 'المحتويات المعروضة على الملصق:';
  static const String showSellPrice = 'سعر البيع';
  static const String showItemName = 'اسم الصنف';
  static const String showBarcodeCode = 'كود الباركود';
  static const String printLayoutTitle = 'إعدادات الطباعة الافتراضية';
  static const String pageLayoutLabel = 'تخطيط الصفحة';
  static const String thermalPrinterDesc = 'طابعة ملصقات حرارية (Thermal)';
  static const String a4PaperDesc = 'ورق A4 (ملصقات متعددة)';
  static const String defaultCopiesPerItem = 'عدد النسخ الافتراضي لكل صنف';
  static const String barcodePreviewTitle = 'معاينة ملصق الطباعة الحقيقي';
  static const String barcodePreviewNote =
      'تنبيه: المعاينة أعلاه معروضة بنسبة تكبير ٣:١ لتسهيل المراجعة البصرية. أبعاد الملصق الحقيقية ستكون %s × %s مم عند الطباعة.';

  // ─── Barcode Label Printing ───
  static const String barcodePrintTitle = 'طباعة ملصقات الباركود';
  static const String barcodePrintSubtitle =
      'تحديد الأصناف وكمية الملصقات المطلوب طباعتها للمخزن';
  static const String labelSettingsAndSizes = 'إعدادات الملصق والمقاسات';
  static const String labelSizeCopiesFormat = 'المقاس: %s × %s مم | النسخ: %s';
  static const String copiesPerItemLabel = 'عدد النسخ الافتراضية لكل صنف';
  static const String showNameLabel = 'إظهار الاسم';
  static const String showPriceLabel = 'إظهار السعر';
  static const String showUnitLabel = 'إظهار الوحدة';
  static const String showBarcodeLabel = 'إظهار الباركود';
  static const String searchMedicineToPrintHint =
      'بحث عن صنف لإضافته لقائمة الطباعة...';
  static const String noBarcode = 'بدون باركود';
  static const String emptyPrintListTitle = 'قائمة الطباعة فارغة';
  static const String emptyPrintListSubtitle =
      'استخدم محرك البحث أعلاه لإضافة الأصناف المطلوب طباعة ملصقات لها.';
  static const String stockBalanceFormat = 'رصيد: %s';
  static String totalLabelsFormat(String total) => 'إجمالي الملصقات: $total';
  static String differentItemsFormat(String count) => 'لعدد $count صنف مختلف';
  static const String startPrinting = 'بدء الطباعة';
  static const String labelPreviewDialogTitle = 'معاينة شكل الملصق';
  static const String closePreview = 'إغلاق المعاينة';
  static const String previewMagnifiedNote =
      '* المعاينة معروضة بضعف الحجم للتوضيح';
  static const String selectAtLeastOneMedicine = 'اختر دواء واحد على الأقل';

  // ─── Add Medicine Form & UI ───
  static const String medicineNameArRequired = 'اسم الدواء بالعربية إجباري';
  static const String addNewItemType = 'إضافة نوع صنف جديد';
  static const String addNewGroup = 'إضافة مجموعة جديدة';
  static const String newNameLabel = 'الاسم الجديد';
  static const String confirmSave = 'تأكيد الحفظ';
  static const String defaultUnitBox = 'علبة';
  static const String defaultUnitStrip = 'شريط';
  static const String defaultUnitPill = 'قرص';
  static const String unitLevelPrefix = 'وحدة ';
  static const String barcodeTakenError = 'الباركود الرئيسي مستخدم بالفعل!';
  static const String inventorySystemSecurity = 'أمان نظام الأدوية';
  static const String medicineNameArLabel = 'اسم الدواء (عربي) *';
  static const String medicineNameEnLabel = 'اسم الدواء (إنجليزي)';

  // Dosage Forms
  static const String dosageFormTablets = 'أقراص';
  static const String dosageFormCapsules = 'كبسولات';
  static const String dosageFormSyrup = 'شرب (شراب)';
  static const String dosageFormInjection = 'حقن';
  static const String dosageFormCream = 'كريم';
  static const String dosageFormDrops = 'قطرات';
  static const String dosageFormPowder = 'مسحوق';
  static const String dosageFormInhaler = 'مستحضرات التنفس';
  static const String dosageFormPatch = 'لواصق (لصقات)';
  static const String dosageFormSuppository = 'تحاميل';
  static const String dosageFormOther = 'أخرى';

  // Container Shapes
  static const String containerShapeBox = 'صندوق (كارتون)';
  static const String containerShapeStrip = 'شريط (بليستر)';
  static const String containerShapeBottle = 'زجاجة';
  static const String containerShapeTube = 'أنبوبة';
  static const String containerShapePlastic = 'عبوة بلاستيك';
  static const String containerShapeAmpoule = 'أمبولة';
  static const String containerShapeVial = 'فيال';
  static const String containerShapePreFilledSyringe = 'سرنجة مملوءة';
  static const String containerShapeSachet = 'كيس';
  static const String containerShapeSpray = 'بخاخ';
  static const String containerShapeDropper = 'قطارة';
  static const String containerShapeMetalCan = 'علبة معدنية';
  static const String containerShapeOther = 'أخرى';

  static const String updateExpiryDateHelp = 'تحديث تاريخ الصلاحية للدواء';
  static const String selectNewExpiryDateHint = 'اختر تاريخ الصلاحية الجديد...';
  static const String barcodeTakenElsewhereError =
      'الباركود "%s" مستخدم بالفعل في دواء آخر!';
  static const String internalConversionFactorLabel =
      'معامل التحويل الداخلي وتفتيت العبوة';
  static const String confirmDateAction = 'اعتماد التاريخ';

  static const String openingShortageInvoicesFormat =
      'جاري فتح فواتير النواقص لطلب %s...';
  static const String advancedPurchaseRequest = 'طلب الشراء المطور';

  // ─── Price Groups & Variants (أكشنات القوائم الموحّدة) ───
  static const String setAsDefault = 'تعيين كافتراضي';
  static const String editItem = 'تعديل';

  static const String itemsRestoredSuccess =
      'عادت الأصناف المحددة إلى دليل الأصناف.';
  static const String itemsRestorePartial =
      'تم استعادة الأصناف بنجاح مع بعض الاستثناءات.';
  static const String itemsDeletedPermanently =
      'تم حذف الأصناف المحددة نهائيًا.';
  static const String itemsDeletePartial =
      'تم الحذف النهائي مع بعض الاستثناءات.';

  static const String executingOperation = 'جاري تنفيذ العملية...';

  static const String initialQuantityLabel = 'الكمية الأولية';
  static const String saveChangesAction = 'حفظ التعديلات';
  static const String addMedicineAction = 'إضافة الصنف';
  static const String editMedicineSuccess = 'تم حفظ التعديلات بنجاح';
  static const String addMedicineSuccess = 'تم إضافة الدواء للمخزون بنجاح';
  static const String addMedicineToInventoryTitle =
      'إضافة دواء جديد إلى المخزون';

  static const String fromThisSubUnit = ' من هذه الوحدة الفرعية';

  // ─── Inventory List ───
  static const String importExcelProducts = 'استيراد منتجات (Excel)';
  static const String deleteAllMedicines = 'مسح الكل';
  static const String confirmDeleteAllTitle = 'تأكيد مسح الكل';
  static const String confirmDeleteAllMessage =
      'هل تريد حذف كل الأدوية (%s)؟ هذا الإجراء لا يمكن التراجع عنه.';
  static const String confirmDeleteSelectedTitle = 'تأكيد الحذف';
  static const String confirmDeleteSelectedMessage =
      'هل تريد حذف %s دواء محدّد؟';
  static const String confirmDeleteItemTitle = 'حذف صنف';
  static const String confirmDeleteItemMessage = 'هل أنت متأكد من حذف %s؟';
  static const String options = 'خيارات';
  static const String editPrice = 'تعديل السعر';

  // ─── Bulk Price Update ───
  static const String bulkPriceUpdateTitle = 'تحديث الأسعار الجماعي';
  static const String bulkPriceUpdateDesc =
      'تعديل أسعار الشراء والبيع لمجموعة من الأدوية دفعة واحدة';
  static const String bulkPriceUpdateApplyTo = 'تطبيق على';
  static const String bulkPriceUpdateAllItems = 'جميع الأصناف';
  static const String bulkPriceUpdateSelectedCategory = 'تصنيف محدد';
  static const String bulkPriceUpdateCategory = 'التصنيف';
  static const String bulkPriceUpdateCategoryHint = 'اختر التصنيف';
  static const String bulkPriceUpdateField = 'الحقل المطلوب';
  static const String bulkPriceUpdateFieldHint = 'اختر الحقل';
  static const String bulkPriceUpdateOperation = 'نوع العملية';
  static const String bulkPriceUpdateOperationHint = 'اختر نوع التعديل';
  static const String bulkPriceUpdateValue = 'القيمة';
  static const String bulkPriceUpdateValueHint = 'أدخل القيمة';
  static const String bulkPriceUpdatePercentage = 'نسبة مئوية (%)';
  static const String bulkPriceUpdateApply = 'تطبيق التحديث';
  static const String bulkPriceUpdatePreview = 'معاينة النتائج';
  static const String bulkPriceUpdateAffectedItems = 'الأصناف المتأثرة';
  static const String bulkPriceUpdateNoItems = 'لم يتم العثور على أصناف';
  static const String bulkPriceUpdateSuccess = 'تم تحديث أسعار %s صنف بنجاح';
  static const String bulkPriceUpdateConfirm =
      'هل أنت متأكد من تحديث أسعار %s صنف؟';
  static const String bulkPriceUpdateFieldBuyPrice = 'سعر الشراء';
  static const String bulkPriceUpdateFieldSellPrice = 'سعر البيع';
  static const String bulkPriceUpdateFieldBoth = 'سعر الشراء والبيع';
  static const String bulkPriceUpdateOpSet = 'تعيين قيمة محددة';
  static const String bulkPriceUpdateOpIncrease = 'زيادة بقيمة';
  static const String bulkPriceUpdateOpDecrease = 'خصم بقيمة';
  static const String bulkPriceUpdateOpIncreasePercent = 'زيادة بنسبة %';
  static const String bulkPriceUpdateOpDecreasePercent = 'خصم بنسبة %';
}
