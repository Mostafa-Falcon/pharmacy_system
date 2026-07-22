

class ArchiveStrings {
  ArchiveStrings._();

  // Page titles
  static const String archiveDashboard = 'الأرشيف المتقدم';
  static const String sidebarAdvancedArchive = 'الأرشيف المتقدم';
  static const String archiveSubtitle = 'سجل كامل بكل العمليات المحذوفة في المنظومة';

  // Entity type section headers
  static const String medicinesArchive = 'أرشيف الأدوية';
  static const String salesArchive = 'أرشيف المبيعات الملغاة';
  static const String purchasesArchive = 'أرشيف المشتريات الملغاة';
  static const String customersArchive = 'أرشيف العملاء';
  static const String suppliersArchive = 'أرشيف الموردين';
  static const String returnsArchive = 'أرشيف المرتجعات';
  static const String customerGroupsArchive = 'أرشيف مجموعات العملاء';
  static const String supplierCustomersArchive = 'أرشيف الحسابات المشتركة';

  // Empty states
  static const String archiveEmpty = 'الأرشيف فارغ';
  static const String archiveEmptySubtitle = 'لا توجد سجلات محذوفة في هذا القسم';

  // Actions
  static const String restore = 'استعادة';
  static const String restoreItem = 'استعادة العنصر';
  static const String restoreSelected = 'استعادة المختار';
  static const String archivePermanentDelete = 'حذف نهائي';
  static const String permanentDeleteItem = 'حذف العنصر نهائياً';
  static const String editBeforeRestore = 'تعديل قبل الاستعادة';
  static const String viewArchiveDetails = 'عرض التفاصيل';

  // Dialogs
  static const String restoreConfirmTitle = 'تأكيد الاستعادة';
  static const String restoreConfirmMessage = 'هل أنت متأكد من استعادة هذا العنصر؟';
  static const String permanentDeleteConfirmTitle = 'تأكيد الحذف النهائي';
  static const String permanentDeleteConfirmMessage = 'هذا الإجراء لا يمكن التراجع عنه. هل أنت متأكد؟';
  static const String editBeforeRestoreTitle = 'تعديل البيانات قبل الاستعادة';

  // Columns
  static const String colEntityType = 'النوع';
  static const String colEntityName = 'الاسم';
  static const String colDeletedBy = 'المسح بواسطة';
  static const String colDeletedAt = 'تاريخ المسح';
  static const String colStatus = 'الحالة';
  static const String colActions = 'الإجراءات';

  // Status
  static const String statusActive = 'في الأرشيف';
  static const String statusRestored = 'تمت الاستعادة';
  static const String statusPermanentlyDeleted = 'تم الحذف النهائي';

  // Messages
  static const String restoredSuccess = 'تمت استعادة العنصر بنجاح';
  static const String permanentDeleteSuccess = 'تم حذف العنصر نهائياً';
  static const String restoreFailed = 'فشلت عملية الاستعادة';
  static const String deleteFailed = 'فشلت عملية الحذف النهائي';

  // Search
  static const String archiveSearchHint = 'ابحث في الأرشيف...';
  static const String filterByType = 'تصفية حسب النوع';
  static const String allTypes = 'جميع الأنواع';

  // Pagination
  static const String showingRecords = 'عرض';
  static const String ofRecords = 'من';
}
