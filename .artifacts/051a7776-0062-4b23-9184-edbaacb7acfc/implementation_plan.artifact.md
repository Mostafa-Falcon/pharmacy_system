# تطوير منظومة الـ State Management وتفاعلية البيانات

تهدف هذه الخطة إلى تحويل نظام إدارة الحالة في التطبيق من نظام "اللقطات" (Snapshots) إلى نظام "تفاعلي" (Reactive)، مما يضمن تحديث واجهة المستخدم فوراً عند حدوث أي تغيير في قاعدة البيانات المحلية، سواء كان التغيير ناتجاً عن عملية مزامنة في الخلفية أو تعديل من جزء آخر في التطبيق.

## User Review Required

> [!IMPORTANT]
> سيتم إعادة هيكلة `PosBloc` وتقسيمه إلى أجزاء أصغر. هذا سيؤدي إلى تغيير طريقة استدعاء الـ Blocs في واجهة شاشة الـ POS، مما قد يتطلب تعديلات بسيطة في الـ View.

## Proposed Changes

### 1. [Core] تعزيز نظام التنبيهات (Notification System)

سيتم تفعيل نظام `onTableUpdated` بشكل كامل ليربط بين عملية المزامنة والـ Blocs.

#### [MODIFY] [sync_pull_service.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/core/data/services/sync/sync_pull_service.dart)
- استدعاء `SyncService.onTableUpdated` بعد كل عملية `upsert` ناجحة لجدول معين أثناء السحب (Pull).

#### [MODIFY] [base_bloc.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/core/bloc/base_bloc.dart)
- إضافة نظام `Effect` لإرسال أحداث عابرة (مثل الـ Snackbars) دون تغيير الـ State الأساسية.
- إضافة `TableObserverMixin` لتمكين الـ Bloc من الاستماع لتحديثات جداول معينة وعمل `refresh` تلقائي.

---

### 2. [Sales Module] إعادة هيكلة الـ POS (The POS Transformation)

تحويل شاشة نقطة البيع لتكون "حية" تماماً.

#### [MODIFY] [pos_bloc.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/modules/sales/bloc/pos_bloc.dart)
- استبدال القوائم الساكنة (`medicines`, `recentSales`) بـ `Streams`.
- استخدام `emit.forEach` لربط حالة الـ Bloc بتدفق البيانات من الـ Repository.
- فصل المنطق الخاص بالبحث (Catalog) في Cubit منفصل لتقليل الـ Rebuilds.

#### [NEW] [catalog_cubit.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/modules/sales/bloc/catalog_cubit.dart)
- Cubit مخصص فقط للبحث، التصفية، وعرض قائمة المنتجات المتوفرة.

#### [NEW] [cart_cubit.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/modules/sales/bloc/cart_cubit.dart)
- Cubit مخصص لإدارة سلة المشتريات والحسابات (الخصومات، الضرائب، الإجماليات).

---

### 3. [Repositories] تفعيل الـ Streams

#### [MODIFY] [repositories](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/core/data/repositories/)
- التأكد من أن جميع الـ Repositories الأساسية (Sales, Inventory, Customers) توفر `watch` methods مبنية على Drift Streams.

## Verification Plan

### Automated Tests
- اختبار الـ `SyncEngine` للتأكد من إرسال التنبيهات عند سحب البيانات.
- اختبار الـ `CartCubit` للتأكد من دقة الحسابات الرياضية (Tax/Discount).

### Manual Verification
- فتح شاشة الـ POS على جهازين، والقيام بعملية بيع من أحدهما والتأكد من تحديث الكمية المتاحة في الجهاز الآخر تلقائياً (بعد المزامنة).
- التأكد من عدم حدوث "تجميد" (Lag) في واجهة المستخدم أثناء عمليات المزامنة المكثفة.
