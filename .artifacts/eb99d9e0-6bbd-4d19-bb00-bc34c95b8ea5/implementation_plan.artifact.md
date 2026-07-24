# خطة تنظيم المجلد الرئيسي `lib/app/core`

بناءً على طلبك يا صقر، هنقوم بتنظيم ملفات الـ `core` عشان تكون المسؤليات واضحة ونشيل أي تكرارات أو ملفات قديمة (Legacy).

## Proposed Changes

### 📂 1. تنظيم الـ BLoCs (`lib/app/core/bloc/`)
هنقسم الـ Blocs لمجلدات فرعية حسب النوع:
*   **`base/`**: للملفات الأساسية (`base_bloc`, `base_state`, `base_paginated_bloc`).
*   **`app/`**: للـ Cubit العام للمشروع (`app_cubit`, `app_state`, `app_bloc_observer`).
*   **`import/`**: للـ Logic الخاص باستيراد البيانات (`import_data_bloc`, `import_data_event`, `import_data_state`).
*   **`mixins/`**: للـ Mixins المشتركة (`sortable_list_mixin`, `table_observer_mixin`).

> [!CAUTION]
> سيتم حذف النسخة المكررة من `correction_chain_cubit.dart` الموجودة في `lib/app/core/bloc/` والاعتماد على النسخة المحدثة في `lib/app/shared/`.

---

### 📂 2. تنظيم البيانات والقاعدة (`lib/app/core/data/`)
*   **`database/`**: هننقل `syncable_entity.dart` من مجلد الـ `sync` لهنا لأنه بيعبر عن واجهة (Interface) لجداول القاعدة.
*   **`storage/`**: حذف ملف `box_helper.dart` المكرر والقديم (Hive legacy) لأنه مبقاش مستخدم.

---

### 📂 3. تنظيم المزامنة (`lib/app/core/sync/`)
المجلد ده فيه ملفات كتير، هننظمه كالتالي:
*   **`engine/`**: للمحرك والخدمات الفرعية (`sync_engine`, `sync_pull_service`, `sync_push_service`, `sync_compaction_service`, `sync_dead_letter_service`).
*   **`models/`**: للموديلات (`sync_models`, `sync_queue_item`).
*   **`config/`**: لإعدادات المزامنة (`sync_config`).
*   **`supabase/`**: للـ Client الخاص بسوبابيز (`supabase_client`).

---

### 📂 4. تنظيم الأدوات والخدمات
*   تحديث الـ Imports في المشروع بالكامل لتعمل مع الهيكلية الجديدة.
*   إصلاح الـ Imports الضاربة الخاصة بـ `app_utils.dart` (سيتم دمجها أو إنشاء الملف المفقود).

## Verification Plan

### Automated Tests
*   التأكد من أن المشروع يعمل `Build` و `Analyze` بدون أخطاء "Target of URI doesn't exist".

### Manual Verification
1.  التأكد من أن المزامنة (Sync) لا تزال تعمل بكفاءة بعد نقل ملفات الـ Engine.
2.  التأكد من أن الـ App Cubit والـ Theme شغالين صح.
3.  التأكد من أن عمليات استيراد البيانات (Import) شغالة.
