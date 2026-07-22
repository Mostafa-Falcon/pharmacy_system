# خطة استكمال المزامنة وتحسين عرض البيانات (Sync Completion & Data Visibility Plan)

يا صقر، فيه مشكلتين أساسيتين هنحلهم دلوقتي:
1. **مشكلة الـ 1000 سجل**: الـ Supabase بـ يبعت 1000 سجل بس في المرة الواحدة، وإحنا عندنا 6000. هنخلي المزامنة "تكرر" نفسها لحد ما تسحب كل الداتا اللي موجودة.
2. **مشكلة الـ 0 في الواجهة**: الأرقام مش بتظهر في صفحة المزامنة لأن الـ Bloc مش بـ يحسبها. هنضيف منطق يحسب عدد السجلات الفعلي من الداتا بيز المحلية ويعرضه.

---

## التغييرات المقترحة

### [Component] محرك المزامنة (Sync Engine)

#### [MODIFY] [sync_pull_service.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/core/data/services/sync/sync_pull_service.dart)
* تعديل ميثود `pullTable` عشان تستخدم `order` و `limit` وتعمل Loop لحد ما تسحب كل البيانات المتاحة (Pagination).
* التأكد من تحديث الـ Watermark بعد كل صفحة عشان لو العملية قطعت، تكمل من حيث توقفت.

#### [MODIFY] [sync_dao.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/core/data/database/daos/sync_dao.dart)
* إضافة ميثود `getTableCount(String tableName)` عشان نقدر نعرف عدد السجلات في أي جدول بسهولة.

### [Component] إدارة الحالة والواجهة (State Management & UI)

#### [MODIFY] [sync_status_bloc.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/modules/sync/bloc/sync_status_bloc.dart)
* تحديث الـ `SyncStatusState` ليشمل `Map<String, int> tableCounts`.
* تحديث الـ Bloc ليقوم بحساب الأعداد عند التشغيل وبعد كل عملية مزامنة ناجحة.

#### [MODIFY] [sync_status_view.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/modules/sync/views/sync_status_view.dart)
* تمرير الـ `localCount` الحقيقي من الـ State إلى الـ `SyncTableTile`.

---

## خطة التحقق (Verification Plan)

### اختبارات تقنية
- [ ] مراقبة الـ Logs للتأكد من أن المزامنة تسحب البيانات في "صفحات" (Chunks of 1000).
- [ ] التأكد من أن إجمالي السجلات المسحوبة يصل إلى 6000+ سجل.
- [ ] التأكد من ظهور الأرقام الفعلية (1000، 2000، إلخ) في بطاقات الجداول.

أنا جاهزة أبدأ، قولي "انطلقي" يا صقر! 🚀✨
