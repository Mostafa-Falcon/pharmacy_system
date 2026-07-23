# قائمة المهام - نظام الوحدات المتعددة

- [ ] تعديل الموديلات (Medicine & Unit Models)
    - [ ] إضافة منطق التفكيك (Decomposition) في `MedicineModel`
    - [ ] تحديث `MedicineUnitModel` لضمان دقة المعاملات
- [ ] تحديث واجهات المخزون (Inventory UI)
    - [ ] تعديل حساب الكمية الكلية في `MedicineFormContent`
    - [ ] تحديث عرض الجدول في `MedicinesListView`
- [ ] تحديث نظام البيع (POS Logic)
    - [ ] إضافة معاملات التحويل في `PosCartLine`
    - [ ] تحديث `CartCubit` للتعامل مع الوحدات
    - [ ] تعديل `SaleEngine` لخصم المخزون بدقة
- [ ] التحقق والاختبار (Verification)
    - [ ] تجربة إضافة وبيع وحدات مختلفة
    - [ ] التأكد من دقة الأرقام في Supabase
