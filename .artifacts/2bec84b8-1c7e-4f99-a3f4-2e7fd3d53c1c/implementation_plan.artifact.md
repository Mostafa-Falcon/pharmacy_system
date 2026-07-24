# Implementation Plan - Auth Unified Block

هظبطلك مرحلة الـ Auth من أول الـ UI لحد الـ Database (Local & Remote) والموديلات عشان يكونوا شغالين كـ "كتلة واحدة" متناغمة، مع التأكد من كمال الـ `copyWith` وتوحيد الرسايل.

## User Review Required
> [!IMPORTANT]
> - الـ Auth بيعتمد على Supabase (Remote) و Drift (Local).
> - المزامنة بتتم عن طريق `AuthUserSync` اللي بيحدث الـ Local DB بمجرد تسجيل الدخول.
> - الـ `copyWith` موجود في الـ Models الأساسية، وهتأكد لو فيه أي Nested Models محتاجة تظبيط.

## Proposed Changes

### 1. Models Layer (النماذج)
مراجعة الـ Models الأساسية للتأكد من شمولية الـ `copyWith` وتوافقها مع الـ JSON والـ Database Companions.

#### [MODIFY] [user_model.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/core/models/auth/user_model.dart)
- التأكد من أن `copyWith` يشمل كل الحقول الجديدة.

#### [MODIFY] [branch_model.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/core/models/auth/branch_model.dart)
- إضافة أو تحسين `copyWith` لو لزم الأمر.

#### [MODIFY] [permission_model.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/core/models/auth/permission_model.dart)
- التأكد من وجود `copyWith` متكامل.

---

### 2. Service Layer (الخدمات والربط مع قاعدة البيانات)
تحديث منطق الجلسة والمزامنة لضمان التدفق السلس للبيانات.

#### [MODIFY] [auth_service.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/core/data/services/auth/auth_service.dart)
- تحسين إدارة الحالة الثابتة (Static state) للمستخدم والفرع الحالي.

#### [MODIFY] [auth_session.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/core/data/services/auth/auth_session.dart)
- ربط الـ Login والـ Register بشكل أعمق مع الـ `AuthUserSync` لضمان أن البيانات المحلية دائمًا محدثة فور النجاح.

#### [MODIFY] [auth_user_sync.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/core/data/services/auth/auth_user_sync.dart)
- التأكد من أن الـ `upsert` للبيانات المحلية بيتم بشكل صحيح وبدون تعارضات (Conflict Resolution).

---

### 3. Presentation Layer (منطق الواجهة)
تحديث الـ `AuthBloc` ليكون هو المايسترو اللي بيحرك الـ "كتلة الواحدة".

#### [MODIFY] [auth_bloc.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/modules/auth/bloc/auth_bloc.dart)
- التأكد من أن كل الـ Events (Login, Register, Logout) بتمر بدورة حياة كاملة (Remote -> Local -> State).
- استخدام `AuthStrings` حصرياً لكل التنبيهات.

## Verification Plan

### Automated Tests
- تشغيل `test/bloc/auth_bloc_test.dart` للتأكد من عدم وجود تراجعات (Regressions).

### Manual Verification
1. **Login Flow:** إدخال بيانات صحيحة -> التأكد من الحفظ في Drift -> الانتقال للـ Home.
2. **Offline Support:** فصل الإنترنت بعد تسجيل الدخول -> التأكد من أن الـ Session ما زالت شغالة من الـ Cache.
3. **Register Flow:** إنشاء حساب جديد -> التأكد من إنشاء الـ Main Branch محلياً ومزامنته مع Supabase.
4. **Error Handling:** إدخال بيانات غلط -> التأكد من ظهور الرسالة الصحيحة من `AuthStrings`.
