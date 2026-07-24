# تنظيم موديول Shared وإزالة التكرارات

الهدف هو تنظيف مجلد `lib/app/shared` من الملفات المكررة وتوحيد الهيكلية لضمان سهولة الوصول والصيانة، مع الالتزام بمعايير "الصقر".

## User Review Required

> [!IMPORTANT]
> سيتم إعادة تسمية مجلد `shareds` إلى `layouts` ليكون الاسم معبراً عن محتواه (AppScaffold, Sidebar, ModuleLayouts).

> [!WARNING]
> سيتم حذف الملفات التالية لأنها نسخ مكررة تماماً من ملفات أخرى:
> - `shared_module_layout.dart` (مكرر لـ `standard_module_layout.dart`)
> - `shared_form_layout.dart` (مكرر لـ `standard_form_layout.dart`)

## Proposed Changes

### [Presentation Layer] `lib/app/shared/presentation/widgets`

سيتم إعادة تنظيم المجلد ليكون أكثر منطقية:
1. **layouts**: للهياكل الكبيرة (Scaffold, Sidebar, Module Layouts).
2. **components**: (بدلاً من reusables) للقطع الصغيرة (Buttons, Inputs, Cards).
3. **blocs**: للـ Blocs المشتركة (كما هي).

#### [DELETE] [shared_module_layout.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/shared/presentation/widgets/shareds/shared_module_layout.dart)
#### [DELETE] [shared_form_layout.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/shared/presentation/widgets/shareds/shared_form_layout.dart)

#### [MODIFY] [shareds -> layouts](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/shared/presentation/widgets/shareds)
- نقل كل محتويات `shareds` إلى `layouts`.
- تحديث الـ `index.dart` والـ `barrel files`.

#### [MODIFY] [reusables -> components](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/shared/presentation/widgets/reusables)
- إعادة تسمية المجلد ليكون أكثر دقة برمجياً.

### [Constants] `lib/app/shared/constants`

#### [MODIFY] [app_strings.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/shared/constants/strings/app_strings.dart)
- التأكد من أن كل نصوص النظام تمر من خلاله (barrel file).

## Verification Plan

### Automated Tests
- تشغيل `flutter analyze` للتأكد من عدم كسر أي مراجع (Imports) بعد النقل والحذف.

### Manual Verification
- فتح شاشات موديول `contacts` (مثل الموردين) لأنها تستخدم `StandardModuleLayout` للتأكد من أنها تعمل بشكل صحيح.
- التأكد من أن الـ `Barrel files` (index.dart) تعمل بشكل سليم.
