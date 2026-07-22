# خطة تفعيل سحب البيانات (Full Sync Pull Activation Plan)

النظام حالياً يقوم برفع البيانات فقط (Push) ولا يقوم بسحب البيانات الموجودة على السيرفر (Pull)، مما يجعل صفحة المزامنة تظهر أصفاراً رغم وجود بيانات في السحاب.

## المشاكل المكتشفة (Root Causes)
1. **Engine Logic**: دالة `pullAllTables` تقوم باستدعاء عملية الرفع فقط وتتجاهل استدعاء خدمة السحب.
2. **Column Mismatch**: خدمة السحب تبحث عن عمود `updated_at` بينما العمود الصحيح هو `last_modified`.
3. **Missing Tables**: خدمة السحب تدعم جدولين فقط (`medicines`, `sales`) وتتجاهل باقي المنظومة.
4. **Watermark Inaccuracy**: يتم تسجيل تاريخ المزامنة كـ `DateTime.now()` بدلاً من أحدث تاريخ تعديل قادم من السيرفر.

## التغييرات المقترحة

### 1. تطوير محرك المزامنة (Sync Engine Upgrade)
- **الملف**: [sync_engine.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/core/data/services/sync/sync_engine.dart)
- **الإجراء**:
    - إضافة قائمة بكافة الجداول المطلوب مزامنتها.
    - تحديث `pullAllTables` لتقوم فعلياً باستدعاء `pullService.pullTable` لكل جدول بشكل تسلسلي.

---

### 2. إصلاح خدمة سحب البيانات (Pull Service Refactor)
- **الملف**: [sync_pull_service.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/core/data/services/sync/sync_pull_service.dart)
- **الإجراء**:
    - تصحيح اسم عمود الفلترة إلى `last_modified`.
    - إضافة منطق الـ `Mapping` والـ `Upsert` لكافة الجداول:
        - `customers`, `suppliers`, `customer_suppliers`
        - `branches`, `users`, `permissions`
        - `purchases`, `returns`, `inventory`
        - إلخ...
    - تحديث الـ `Watermark` ليعتمد على أحدث `last_modified` تم سحبه فعلياً.

---

## قائمة الجداول المستهدفة (Target Tables)
1. `branches`, `users`, `permissions` (أساسيات)
2. `customers`, `suppliers`, `customer_groups` (جهات اتصال)
3. `medicines`, `medicine_units`, `item_batches` (أصناف)
4. `inventory`, `stock_transfers` (مخازن)
5. `sales`, `purchases`, `returns`, `quotes` (حركات مالية)

---

## خطة التحقق (Verification Plan)
- مسح قاعدة البيانات المحلية (أو استخدام جهاز جديد).
- تسجيل الدخول بنفس الحساب.
- الضغط على "سحب البيانات" والتأكد من تحول الأصفار في صفحة المزامنة إلى أرقام تعكس داتا السيرفر.
