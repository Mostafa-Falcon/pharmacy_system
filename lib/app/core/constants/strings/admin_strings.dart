// admin_strings.dart — الإدارة، الموظفين، الأدوار، الملف الشخصي، الصلاحيات، مراقبة المستندات



class AdminStrings {
  AdminStrings._();

  // ─── Admin ───
  static const String adminDashboard = 'لوحة تحكم المدير';
  static const String adminSettings = 'إعدادات المنظومة';
  static const String adminSettingsSubtitle = 'تخصيص خيارات العمل والضرائب والطباعة.';
  static const String adminSearchSettings = 'بحث عن إعداد...';
  static const String adminQuickControl = 'التحكم السريع';
  static const String adminEnableSounds = 'تفعيل أصوات التنبيهات';
  static const String adminAutoPrint = 'طباعة الفواتير تلقائياً';

  // ─── Branches Management ───
  static const String branchesManagementTitle = 'إدارة فروع الصيدلية';
  static const String branchesManagementSubtitle = 'إضافة وتعديل فروع صيدلياتك والتحكم بها';
  static const String activeBranchesListLabel = 'قائمة الفروع النشطة';
  static const String addBranchAction = 'إضافة فرع جديد';
  static const String noBranchesFound = 'لا توجد فروع مضافة حالياً بالسيستم';
  static const String noAddressDefined = 'لم يحدد عنوان';
  static const String editBranchTooltip = 'تعديل الفرع';
  static const String deleteBranchTooltip = 'حذف الفرع';
  static const String addBranchDialogTitle = 'إضافة فرع جديد للشركة';
  static const String branchFullNameLabel = 'اسم الفرع بالكامل';
  static const String branchNameExampleHint = 'مثال: فرع التجمع الخامس';
  static const String branchDetailedAddressLabel = 'عنوان الفرع بالتفصيل';
  static const String branchAddressExampleHint = 'مثال: شارع التسعين، بجوار كذا';
  static const String branchPhoneLabel = 'رقم هاتف الفرع';
  static const String branchPhoneExampleHint = 'مثال: 010xxxxxxxx';
  static const String cancelAddBranchAction = 'تراجع وإلغاء';
  static const String confirmAddBranchAction = 'تأكيد الإضافة';
  static const String enterBranchNameWarning = 'برجاء كتابة اسم الفرع أولاً!';
  static const String importantWarningTitle = 'تنبيه هام';
  static const String editBranchDialogTitle = 'تعديل بيانات الفرع';
  static const String cancelEditBranchAction = 'إلغاء التعديل';
  static const String saveBranchChangesAction = 'حفظ التغييرات';
  static const String cannotClearBranchNameWarning = 'لا يمكن مسح اسم الفرع بالكامل!';
  static const String importantSecurityWarningTitle = 'تحذير أمان هام!';
  static const String deleteBranchConfirmFormat = 'هل أنت متأكد تماماً من رغبتك في حذف فرع "%s" بالكامل من النظام؟ هذا الإجراء لا يمكن التراجع عنه!';
  static const String confirmDeleteBranchAction = 'نعم، إحذف الفرع';

  // ─── Permissions ───
  static const String permissionsTitle = 'إدارة صلاحيات الوصول';
  static const String permissionsSubtitle = 'تحديد صلاحيات العمل للموظفين على أقسام النظام.';
  static const String permissionsSelectEmployee = 'اختر موظف الصيدلية:';
  static const String permissionsEmployeeHint = 'اضغط لاختيار اسم الموظف';
  static const String permissionsEmpty = 'برجاء اختيار موظف أولاً.';
  static const String permissionsBoardPrefix = 'لوحة صلاحيات: ';
  static const String permissionsGrantAll = 'إعطاء الكل';
  static const String permissionsRevokeAll = 'سحب الكل';

  // ─── Document Control ───
  static const String docControlTitle = 'مراقبة المستندات';
  static const String docControlSubtitle = 'سجل عمليات الإلغاء والتراجع والتعديلات';
  static const String docControlHeader = 'سجل المستندات المفصل';
  static const String docControlHeaderSubtitle = 'تتبع عمليات الإلغاء والتراجع على المستندات.';
  static const String docControlEmpty = 'لا توجد عمليات تعديل مسجلة.';
  static const String docActionCreated = 'تم الإنشاء';
  static const String docActionModified = 'تم التعديل';
  static const String docActionCancelled = 'تم الإلغاء';
  static const String docActionRestored = 'تم الاسترجاع';
  static const String docActionPaymentModified = 'تم تعديل السداد';

  // ─── Employees Management ───
  static const String empManagement = 'إدارة الموظفين والصلاحيات';
  static const String empManagementSubtitle = 'التحكم في حسابات الموظفين، الأدوار، وتعيين فروع العمل لهم';
  static const String empAdd = 'إضافة موظف جديد';
  static const String empTotalFormat = 'إجمالي الطاقم: %s موظف';
  static const String empNoAccounts = 'لا توجد حسابات موظفين مسجلة حالياً';
  static const String empAddStartHint = 'اضغط على زر "إضافة موظف جديد" للبدء بتعيين فريق العمل';
  static const String empAddDialog = 'إضافة موظف جديد للنظام';
  static const String empFullName = 'الاسم الكامل للموظف';
  static const String empEmailLabel = 'البريد الإلكتروني';
  static const String empDefaultPassword = 'كلمة المرور الافتراضية';
  static const String empRole = 'الدور والمهام الوظيفية';
  static const String empRoleHint = 'اختر دور الموظف';
  static const String empRolePharmacist = 'صيدلي مناوب';
  static const String empRoleCashier = 'كاشير مبيعات';
  static const String empRoleInventoryManager = 'مدير مخزون وأدوية';
  static const String empRoleGeneral = 'موظف عام';
  static const String empBranch = 'الفرع المعين للعمل به';
  static const String empBranchHint = 'اختر الفرع الحالي للعمل';
  static const String empNoBranch = 'بدون فرع نشط حالياً';
  static const String empUnknownBranch = 'فرع مجهول';
  static const String empCancel = 'تراجع وإلغاء';
  static const String empConfirm = 'تأكيد الحساب';
  static const String empFieldsRequired = 'برجاء كتابة كافة الحقول والبيانات لتأمين الحساب المضاف!';
  static const String empSecurityAlert = 'تنبيه أمان هام';
  static const String empEdit = 'تعديل بيانات الموظف';
  static const String empEditName = 'الاسم الكامل المحدث';
  static const String empEditEmail = 'البريد الإلكتروني المحدث';
  static const String empEditRole = 'تعديل الدور الوظيفي';
  static const String empEditRoleHint = 'اختر الدور المحدث للعمل';
  static const String empEditBranchHint = 'اختر الفرع للعمل';
  static const String empSaveChanges = 'حفظ التغييرات';
  static const String empFieldsError = 'الاسم والبريد حقول إجبارية لا يمكن تركها فارغة!';
  static const String empDeactivateTitle = 'تأكيد إيقاف الحساب الموظف';
  static const String empDeactivateConfirmFormat = 'هل أنت متأكد تماماً من رغبتك في حذف الحساب الموظف "%s" بالكامل من النظام وتعطيل وصوله للصيدلية؟';
  static const String empDeactivateYes = 'نعم، إحذف الحساب';
  static const String empActivatedFormat = 'تم تنشيط حساب الموظف %s بنجاح';
  static const String empDeactivatedFormat = 'تم تجميد وتعطيل حساب الموظف %s';
  static const String empStatusUpdate = 'تحديث الحالة النشطة';
  static const String empBadgeOwner = 'المالك والمشرف';
  static const String empBadgeActive = 'نشط بالنظام';
  static const String empBadgeFrozen = 'معطل ومجمد';
  static const String empFreeze = 'تجميد الحساب';
  static const String empActivate = 'تنشيط الحساب';

  // ─── Employee Actions (أكشنات القوائم الموحّدة) ───
  static const String editData = 'تعديل البيانات';
  static const String deleteEmployee = 'حذف الموظف';

  // ─── Roles ───
  static const String roleOwner = 'مالك الصيدلية';
  static const String roleManager = 'مدير';
  static const String rolePharmacist = 'صيدلي';
  static const String roleAccountant = 'محاسب';
  static const String roleCashier = 'كاشير';
  static const String roleSupervisor = 'المالك والمشرف العام';
  static const String roleShiftPharmacist = 'صيدلي مسئول مناوب';

  // ─── User Profile ───
  static const String profileTitle = 'الملف الشخصي للعمل';
  static const String profileSubtitle = 'عرض وتعديل بياناتك الشخصية المسجلة وتأمين الحساب';
  static const String profilePersonalInfo = 'البيانات الشخصية والوظيفية للسيستم';
  static const String profileFullName = 'الاسم الكامل المعتمد';
  static const String profileEmail = 'البريد الإلكتروني للعمل';
  static const String profileRole = 'الصلاحية والمسئولية الحالية';
  static const String profileBranch = 'الفرع التابع له حالياً';
  static const String profileDefaultBranch = 'الفرع الرئيسي';
  static const String profileDeviceManagement = 'إدارة الأجهزة النشطة للحساب';
  static const String profileSecurity = 'إجراءات الأمان وتأمين الحساب الشخصي';
  static const String profileEditData = 'تعديل البيانات الأساسية بالحساب';
  static const String profileChangePassword = 'تحديث كلمة المرور الخاصة بك دورياً';
  static const String profileEditDialog = 'تعديل البيانات الشخصية';
  static const String profileEditName = 'الاسم الحالي المسجل بالكامل';
  static const String profileSaveEdit = 'حفظ التعديل';
  static const String profileNameRequired = 'اسم المستخدم لا يمكن تركه فارغاً!';
  static const String profileEditSuccess = 'تم تعديل الملف الشخصي بنجاح!';
  static const String profileChangePasswordDialog = 'تغيير كلمة المرور الشخصية';
  static const String profileCurrentPassword = 'كلمة المرور الحالية';
  static const String profileNewPassword = 'كلمة المرور الجديدة';
  static const String profileConfirmPassword = 'تأكيد تطابق كلمة المرور الجديدة';
  static const String profileSecurityAlert = 'تنبيه أمان';
  static const String deviceAccountOpen = 'الحساب مفتوح على هذا الجهاز';
  static const String multiDeviceInfo = 'يمكن تسجيل الدخول إلى هذا الحساب على أكثر من جهاز في نفس الوقت. جميع العمليات تُزامَن تلقائياً.';
  static const String profileUpdateAccount = 'تحديث حسابي الآمن';
  static const String profilePasswordFieldsRequired = 'الرجاء ملء حقول الأمان لتبديل كلمة المرور!';
  static const String profilePasswordChanged = 'تم تحديث كلمة المرور بنجاح!';

  // ─── Permission Names ───
  static const String permDashboard = 'لوحة التحكم العامة';
  static const String permPos = 'نقطة البيع (الكاشير)';
  static const String permInventory = 'إدارة المخازن';
  static const String permAddEditItems = 'إضافة وتعديل الأدوية';
  static const String permCategories = 'تصنيفات الأدوية';
  static const String permStocktake = 'جرد الكميات والمخزون';
  static const String permCustomers = 'سجلات العملاء';
  static const String permSuppliers = 'سجلات الموردين';
  static const String permReports = 'التقارير الحسابية';
  static const String permSettings = 'إعدادات النظام العامة';
  static const String permAdminPanel = 'لوحة الإدارة والملاك';
  static const String permEmployeeData = 'بيانات الموظفين';
  static const String permManageBranches = 'إدارة فروع الصيدليات';
  static const String permManagePermissions = 'تعديل الصلاحيات والأدوار';
  static const String permCreateInvoices = 'إنشاء وطباعة الفواتير';
  static const String permVoidInvoices = 'إلغاء وحذف الفواتير';
  static const String permSalesReturns = 'إجراء مرتجعات المبيعات';
  static const String permAdjustStock = 'تعديل الكميات';
  static const String permDeleteItem = 'حذف دواء نهائياً';
  static const String permManageTeam = 'إدارة صلاحيات الطاقم';
  static const String permManageBranchesFull = 'إضافة وحذف الفروع';
  static const String permProfitReports = 'عرض تقارير الأرباح والخسائر';
  static const String permExportInventory = 'تصدير جرد المخزون إكسيل';
  static const String permManageRoles = 'إدارة رتب الموظفين';

  // ─── Settings Tabs ───
  static const String settingsTabProject = 'المشروع';
  static const String settingsTabTax = 'الضريبة';
  static const String settingsTabItem = 'الصنف';
  static const String settingsTabSale = 'البيع';
  static const String settingsTabSystem = 'النظام';
  static const String settingsTabEmail = 'البريد الإلكتروني';
  static const String settingsTabSms = 'الرسائل النصية';
  static const String settingsTabRewards = 'نقاط المكافآت';
  static const String settingsTabShortcuts = 'الاختصارات';
  static const String settingsTabExtraUnits = 'وحدات إضافية';
  static const String settingsTabInvoiceLayout = 'تنسيق الفاتورة';
  static const String invoiceLayoutTitle = 'تنسيق الفاتورة';
  static const String invoiceLayoutDescription = 'تخصيص محتوى وتصميم الفاتورة المطبوعة';
  static const String invoiceLayoutShowLogo = 'إظهار الشعار';
  static const String invoiceLayoutShowCustomer = 'إظهار بيانات العميل';
  static const String invoiceLayoutShowTax = 'إظهار الضريبة';
  static const String invoiceLayoutShowDiscount = 'إظهار الخصم';
  static const String invoiceLayoutShowBarcode = 'إظهار الباركود';
  static const String invoiceLayoutShowPrice = 'إظهار السعر';
  static const String invoiceLayoutPaperSize = 'حجم الورق';
  static const String invoiceLayoutFontSize = 'حجم الخط';
  static const String invoiceLayoutFooterText = 'نص التذييل';

  // ─── Notifications (أكشنات القوائم الموحّدة) ───
  static const String deleteAllNotifications = 'حذف جميع الإشعارات';
  static const String deleteAll = 'حذف الكل';

  // ─── Admin Sidebar Groups ───
  static const String sidebarGroupSales = 'المبيعات';
  static const String sidebarGroupPurchases = 'المشتريات';
  static const String sidebarGroupInventory = 'الأصناف';
  static const String sidebarGroupReports = 'التقارير';
  static const String sidebarGroupAdmin = 'إعدادات';

  // ─── Admin Sidebar Items ───
  static const String sidebarItemCustomersContacts = 'العملاء والجهات';
  static const String sidebarItemCustomerDirectory = 'دليل العملاء';
  static const String sidebarItemStocktaking = 'الجرد المخزوني';
  static const String sidebarItemInventoryTools = 'أدوات المخزون';
  static const String sidebarItemStockTransfer = 'تبادل أصناف';
  static const String sidebarItemStockAdjustment = 'تسوية المخزون';
  static const String sidebarItemBulkPriceUpdate = 'تحديث الأسعار';
  static const String sidebarItemPromotions = 'العروض والترقيات';
  static const String sidebarItemImportItems = 'استيراد بيانات الاصناف';
  static const String sidebarItemItemsArchive = 'أرشيف الأصناف';
  static const String sidebarItemInventorySettings = 'إعدادات الأصناف';
  static const String sidebarItemBrands = 'ماركات الاصناف';
  static const String sidebarItemPriceGroups = 'مجموعات الأسعار';
  static const String sidebarItemVariants = 'متغيرات الاصناف';
  static const String sidebarItemReportsHub = 'التقارير';
  static const String sidebarItemExtraReports = 'تقارير إضافية';
  static const String sidebarItemAdvancedLedger = 'الأستاذ المتقدم';
  static const String sidebarItemAccounting = 'ادارة الحسابات';
  static const String sidebarItemAccountingDashboard = 'لوحة المحاسبة';
  static const String sidebarItemHr = 'الموارد البشرية';
  static const String sidebarItemAdminTools = 'أدوات الإدارة';
  static const String sidebarItemAdminTasks = 'المهام الإدارية';
  static const String sidebarItemVoidOperations = 'السجلات الممسوحة';
  static const String sidebarItemNotifications = 'الإشعارات';
  static const String sidebarItemSyncStatus = 'حالة المزامنة';
}


