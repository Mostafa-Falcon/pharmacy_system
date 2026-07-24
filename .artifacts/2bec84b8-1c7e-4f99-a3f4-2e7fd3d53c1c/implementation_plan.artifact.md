# استكمال وتطوير نظام الـ Mappers لتوافق كامل مع الموديلات

الهدف هو استكمال ملفات الـ Mappers في مجلد `lib/app/core/data/mappers` لتغطية جميع الجداول الموجودة في قاعدة البيانات (Drift) وضمان توافقها الكامل مع الـ Models المستخدمة في التطبيق. سيتم أيضاً توحيد نمط التحويل لتسهيل استخدامه في الـ Repositories.

## User Review Required

> [!IMPORTANT]
> سيتم إضافة المappers للجداول الجديدة التي تم إضافتها مؤخراً في النسخة الرابعة من قاعدة البيانات (v4) مثل `Returns`, `AuditLogs`, `Lookups`, `ErrorLogs`, وغيرها.

> [!NOTE]
> سيتم الالتزام بنمط الـ Static Methods الحالي لسهولة الاستخدام المباشر دون الحاجة لعمل Instance من الـ Mapper، مع التأكد من مطابقة أسماء الحقول بدقة بين الـ TableData والـ Model.

## Proposed Changes

### [Mappers Layer]

#### [MODIFY] [inventory_mapper.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/core/data/mappers/inventory_mapper.dart)
- إضافة تحويل لـ `BarcodeSettingsTable` -> `BarcodeSettingsModel`.
- إضافة تحويل لـ `MedicineBarcodesTable` -> `MedicineBarcodeModel`.
- إضافة تحويل لـ `MedicineUnitsTable` -> `MedicineUnitModel`.
- تحديث `medicineFromData` ليشمل حقل `created_at`.

#### [MODIFY] [sales_mapper.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/core/data/mappers/sales_mapper.dart)
- إضافة تحويل لـ `ReturnsTable` -> `ReturnModel`.

#### [MODIFY] [system_mapper.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/core/data/mappers/system_mapper.dart)
- إضافة تحويل لـ `AuditLogsTable` -> `AuditLogModel`.
- إضافة تحويل لـ `NotificationsTable` -> `AppNotificationModel`.
- إضافة تحويل لـ `LookupsTable` -> `LookupModel`.
- إضافة تحويل لـ `ErrorLogsTable` -> `ErrorLogModel`.
- إضافة تحويل لـ `CorrectionsTable` -> `CorrectionEntry`.

#### [MODIFY] [accounting_mapper.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/core/data/mappers/accounting_mapper.dart)
- تحديث التحويلات للتأكد من شمول جميع الحقول المحدثة في الموديلات.

## Verification Plan

### Automated Tests
- التأكد من عدم وجود أخطاء compile بعد إضافة التحويلات الجديدة.
- التحقق من توافق أنواع البيانات (Data Types) بين الموديلات والجداول.

### Manual Verification
- مراجعة الكود للتأكد من أن جميع الجداول الـ 53 المذكورة في `AppDatabase` لها ما يقابلها في الـ Mappers.
