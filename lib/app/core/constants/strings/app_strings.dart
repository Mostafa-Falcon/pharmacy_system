// app_strings.dart — نقطة وصول مركزية لكل نصوص المنظومة (Barrel File).
//
// الثوابت مُوزّعة على أقسام في مجلد [strings/] لسهولة الصيانة ومنع الملفات الضخمة.
// يتم الوصول إليها الآن مباشرة عبر كلاسات الموديولات (مثل: SalesStrings.title).

export 'accounting_strings.dart';
export 'activity_log_strings.dart';
export 'admin_strings.dart';
export 'archive_strings.dart';
export 'auth_strings.dart';
export 'crm_strings.dart';
export 'customers_strings.dart';
export 'excel_strings.dart';
export 'export_strings.dart';
export 'general_strings.dart';
export 'home_strings.dart';
export 'hr_strings.dart';
export 'inventory_strings.dart';
export 'notifications_strings.dart';
export 'purchases_strings.dart';
export 'reports_strings.dart';
export 'sales_strings.dart';
export 'stocktaking_strings.dart';
export 'suppliers_strings.dart';
export 'sync_strings.dart';
export 'tasks_strings.dart';
export 'void_operations_strings.dart';
export 'widget_strings.dart';

/// كلاس تجمعي لضمان عدم كسر أي مراجع قديمة إن وجدت.
abstract final class AppStrings {}
