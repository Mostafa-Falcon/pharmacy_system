# تنظيم موديول Shared لزيادة القابلية للاستخدام (Reusability) والاتساق

الهدف هو توحيد التسميات، تقليل الاعتماد على الـ Wrappers القديمة، وتحويل الـ Layouts الضخمة إلى مكونات أصغر قابلة للتركيب (Composable Components).

## User Review Required

> [!IMPORTANT]
> سيتم تغيير أسماء الكلاسات من `Reusable*` إلى `App*` (مثل `ReusableButton` -> `AppButton`) لتوحيد الهوية البرمجية للمشروع. هذا التغيير سيؤثر على أغلب ملفات المشروع.

> [!NOTE]
> سيتم تحويل `StandardModuleLayout` ليعتمد على مكونات فرعية مثل `AppPageHeader` و `AppFilterBar` لسهولة استخدامها بشكل منفصل.

## Proposed Changes

### [Naming & Consistency] توحيد التسميات والقطع

سيتم تحديث كافة المكونات في مجلد `components` لتتبع نمط تسمية واحد:
- `ReusableButton` -> `AppButton`
- `ReusableInput` -> `AppInput`
- `ReusableText` -> `AppText`
- `ReusableDialog` -> `AppDialog`
- `ReusableTable` -> `AppTable`
- `ReusableProgressOverlay` -> `AppProgressOverlay`

سيتم إزالة الـ Wrappers القديمة واستبدال استخداماتها:
- `EmptyState` / `ReusableStateView` -> `AppStateView`
- `FormCard` / `SectionCard` -> `AppCard.form` / `AppCard.section`

### [Decomposition] تفكيك الـ Layouts الضخمة

#### [NEW] [app_page_header.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/shared/presentation/widgets/components/layout/app_page_header.dart)
استخراج منطق الهيدر (العنوان + الأزرار + الإحصائيات) في مكون منفصل تماماً لاستخدامه في الصفحات التي لا تحتاج للـ `StandardModuleLayout` بالكامل.

#### [MODIFY] [standard_module_layout.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/shared/presentation/widgets/layouts/standard_module_layout.dart)
تحديث التخطيط ليعتمد على `AppPageHeader` و `AppProgressOverlay`.

### [Organization] تنظيم مجلد Layouts

سيتم تقسيم المجلد داخلياً:
- `layouts/core/`: للقطع الأساسية (Scaffold, Sidebar, Navbar).
- `layouts/templates/`: للقوالب الجاهزة (Module, Form, Auth).

### [Refactoring] نقل المكونات المتفرقة

- نقل `CorrectionChainWidget` إلى `components/tools/`.
- دمج `sidebar_theme.dart` داخل `app_theme.dart` لتقليل تشتت إعدادات الثيم.

## Verification Plan

### Automated Tests
- تشغيل `flutter analyze` بعد كل مرحلة تغيير (الأسماء أولاً، ثم الهيكلة).

### Manual Verification
- التحقق من عمل شاشة المبيعات (Sales List) والمخازن (Inventory List) لأنهم الأكثر استخداماً للـ Layouts المعدلة.
- التأكد من أن الـ `AppStateView` يظهر بشكل صحيح في حالة عدم وجود بيانات.
