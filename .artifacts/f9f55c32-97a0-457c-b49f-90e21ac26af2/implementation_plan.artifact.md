# تطوير واجهة المزامنة وإصلاح رفع المعلقات

الهدف هو تحسين تجربة المستخدم في صفحة المزامنة لتكون أكثر جمالاً واحترافية، وإصلاح مشكلة ثبات عداد المعلقات أثناء عملية الرفع.

## User Review Required

> [!IMPORTANT]
> - سيتم تغيير شكل صفحة المزامنة بالكامل لتعتمد على تصميم Card-based وتوزيع أفضل للمساحات.
> - سيتم إضافة تقارير لحظية لعملية الرفع لضمان تحديث العداد سجل بسجل.

## Proposed Changes

### [Sync Module]

#### [MODIFY] [sync_push_service.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/core/data/services/sync/sync_push_service.dart)
- إضافة `onProgress` callback لدالة `processPushQueue`.
- استدعاء الـ callback بعد كل عملية رفع ناجحة أو فاشلة لتحديث الـ UI.

#### [MODIFY] [sync_engine.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/core/data/services/sync/sync_engine.dart)
- تحديث دالة `syncAll` لتمرير تحديثات التقدم من الـ `PushService` إلى الـ `progressController`.

#### [MODIFY] [sync_status_view.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/modules/sync/views/sync_status_view.dart)
- إعادة تصميم الـ `_buildCloudCommandBanner` ليكون أكثر فخامة.
- تحسين الـ `_SyncPendingList` لتكون بشكل Activity Feed مع أيقونات توضح نوع العملية (Create/Update/Delete).
- إضافة `LinearProgressIndicator` يوضح النسبة المئوية المكتملة فعلياً من إجمالي المعلقات.

#### [MODIFY] [sync_status_bloc.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/modules/sync/bloc/sync_status_bloc.dart)
- تحسين التعامل مع الـ `SyncProgress` لتحديث قائمة المعلقات والعداد بشكل أكثر سلاسة وتجنب تكرار العمليات المكلفة.

## Verification Plan

### Automated Tests
- إضافة سجلات معلقة والتأكد من أن العداد ينقص "واحد بواحد" أثناء الضغط على رفع المعلقات.
- التأكد من أن الواجهة تظهر حالة "مزامنة" لكل جدول يتم رفعه.

### Manual Verification
- فتح صفحة المزامنة والتأكد من تناسق الألوان والمساحات في التصميم الجديد.
- التأكد من أن زرار "رفع المعلقات" لا يعلق الـ UI.
