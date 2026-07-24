# Implementation Plan - Unifying Contacts Module

تهدف هذه الخطة إلى توحيد موديول جهات التعامل (Contacts) ليشمل العملاء والموردين والمناديب، وربطهم بشكل متكامل مع قواعد البيانات (Local & Remote) وتوحيد النصوص والواجهات.

## User Review Required
> [!IMPORTANT]
> - سيتم استخدام `ContactsDao` كمركز وحيد لإدارة كافة العمليات المحلية لجهات التعامل.
> - سيتم تفعيل المزامنة التلقائية (Sync) عبر الـ Repositories.
> - سيتم توحيد شكل الفورم (Add/Edit) والجداول لجميع جهات التعامل.

## Proposed Changes

### 1. Models Layer (النماذج)
مراجعة وتحديث النماذج لضمان التوافق التام مع نظام المزامنة.
- [MODIFY] [customer_model.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/core/models/contacts/customer_model.dart)
- [MODIFY] [supplier_model.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/core/models/contacts/supplier_model.dart)

### 2. Repositories & Services (المنطق والبيانات)
إنشاء أو تحديث المستودعات لتعمل كـ "كتلة واحدة" تربط Drift بـ Supabase.
- [MODIFY] [customers_repository.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/core/data/repositories/customers_repository.dart)
- [MODIFY] [suppliers_repository.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/core/data/repositories/suppliers_repository.dart)

### 3. Presentation Layer (الواجهات والنصوص)
توحيد الواجهات واستخدام `AppStrings` المخصصة لكل موديول.
- [MODIFY] كافة ملفات الواجهات في `lib/app/modules/contacts/views/` لاستخدام `ReusableInput`, `ReusableButton`, و `StandardModuleLayout`.
- [MODIFY] التأكد من سحب كافة النصوص من `CustomersStrings` و `SuppliersStrings`.

## Verification Plan

### Manual Verification
1. **العملاء:** إضافة عميل جديد -> التأكد من الحفظ في Drift -> التأكد من ظهوره في القائمة -> المزامنة مع Supabase.
2. **الموردين:** تعديل بيانات مورد -> التأكد من تحديث الـ `lastModified` والـ `syncVersion`.
3. **كشف الحساب:** التأكد من ربط الحركات المالية بالعميل/المورد الصحيح وظهورها في دفتر الأستاذ.
4. **النصوص:** مراجعة الواجهات للتأكد من عدم وجود نصوص Hardcoded.
