# قائمة المهام - نظام الوحدات المتعددة

- [x] تعديل الموديلات (Medicine & Unit Models)
    - [x] إضافة منطق التفكيك (Decomposition) في `MedicineModel`
    - [x] تحديث `MedicineUnitModel` لضمان دقة المعاملات
- [x] تحديث واجهات المخزون (Inventory UI)
    - [x] تعديل حساب الكمية الكلية في `MedicineFormContent`
    - [x] تحديث عرض الجدول في `MedicinesListView`
- [x] تحديث نظام البيع (POS Logic)
    - [x] إضافة معاملات التحويل في `PosCartLine`
    - [x] تحديث `CartCubit` للتعامل مع الوحدات
    - [x] تعديل `SaleEngine` لخصم المخزون بدقة
- [x] التحقق والاختبار (Verification)
    - [x] تجربة إضافة وبيع وحدات مختلفة
    - [x] التأكد من دقة الأرقام في Supabase
    - [x] إصلاح استرجاع الفواتير المعلقة (Suspended Sales Fix)
    - [x] تحديث واجهة تسوية الجرد (Stock Adjustment Alignment)
