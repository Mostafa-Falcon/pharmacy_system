# Task List - تطوير منظومة الـ State Management

- `[ ]` تحديث الـ `SyncPullService` لتفعيل نظام التنبيهات (`onTableUpdated`)
- `[ ]` تحديث الـ `BaseBloc` والـ `BaseState` لدعم الـ Effects والـ Table Observation
- `[ ]` تفعيل الـ Streams في الـ `MedicinesRepository` والـ `SalesRepository`
- `[ ]` إنشاء الـ `CatalogCubit` لفصل منطق البحث والكتالوج في الـ POS
- `[ ]` إنشاء الـ `CartCubit` لفصل منطق السلة والحسابات في الـ POS
- `[ ]` إعادة هيكلة الـ `PosBloc` ليكون المنسق (Coordinator) بين الـ Cubits الجدد
- `[ ]` تحديث واجهة شاشة الـ POS لتعمل مع الـ Cubits الجديدة
- `[ ]` التحقق النهائي من دقة المزامنة وتحديث الـ UI التلقائي
