# خطة محاذاة المزامنة مع "بذرة الموديلات" (Sync Alignment Plan)

تهدف هذه الخطة إلى جعل عملية المزامنة (Push/Pull) تعتمد بشكل كلي على الموديلات كبذرة وحيدة للحقيقة، مما يضمن توافقاً تاماً بين Supabase و Drift بعد إعادة الهيكلة.

## Proposed Changes

### 1. [Sync] - تنقية قائمة الجداول (Sync Tables Cleanup)
تحديث قائمة `_syncTables` في `SyncEngine` لتشمل فقط الجداول الرئيسية بعد دمج الجداول الفرعية (Lines/Items) كأعمدة JSON:
- إزالة `sale_items`, `purchase_items`, `invoice_return_items`, `free_return_items`, `quotation_items`, `stocktaking_items`, `stock_adjustment_items`.
- التأكد من وجود `inventory_transactions` و `receipt_counters`.

### 2. [Sync] - تطوير خدمة السحب (SyncPullService)
- **Model-Driven Mapping**: استخدام `Model.fromJson(supabaseData)` للحصول على كائن الموديل، ثم تحويله إلى `Companion` الخاص بـ Drift. هذا يضمن أن منطق معالجة الـ JSON موجود في مكان واحد فقط (الموديل).
- **إضافة الماربات الناقصة**: استكمال كافة الجداول (مثل `item_batches`, `item_categories`, `receipt_counters`, `archive_records`).

### 3. [Sync] - تطوير خدمة الدفع (SyncPushService)
- **Direct JSON Push**: التأكد من أن البيانات المرسلة لـ Supabase ناتجة دائماً من `Model.toJson()` لضمان تطابق مسميات الأعمدة (snake_case) والقيم المركبة.
- **Conflict Shield**: تفعيل حماية التعارض باستخدام `sync_version` للجداول الحيوية التي تم تحديث موديلاتها.

### 4. [Database] - محاذاة المسميات (Naming Alignment)
- التأكد من أن جداول Drift تستخدم `tableName` يطابق مسمى الجدول في Supabase (مثلاً `SalesRepsTable` يجب أن يشير لـ `sales_agents`).

## Verification Plan

### Automated Tests
- تشغيل `dart run build_runner build` للتأكد من توليد كافة الـ Companions الجديدة.
- تشغيل `flutter analyze` للتأكد من سلامة الكود.

### Manual Verification
- إضافة صنف جديد ببيانات كاملة (باركودات، مستويات وحدات) والتأكد من سحبها ورفعها بشكل ذري (Atomic).
- إنشاء فاتورة مبيعات والتأكد من تخزين سطورها كـ JSON ومزامنتها بنجاح.
