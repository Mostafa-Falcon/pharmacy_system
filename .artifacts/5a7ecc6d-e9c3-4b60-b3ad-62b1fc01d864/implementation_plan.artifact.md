# نظام تصنيف الوحدات وتدقيق المخزون (Multi-Unit Inventory System)

تطوير نظام المخزون ليدعم (العلبة، الشريط، القرص) بشكل متكامل يضمن دقة الحسابات المالية والكميات في المخزن والمزامنة مع Supabase. سيتم تخزين الكمية الكلية بالأصغر وحدة (Base Unit) لضمان الدقة الحسابية، مع تفكيكها للعرض والتعامل مع الوحدات المختلفة في البيع.

## Proposed Changes

### 1. موديولات البيانات (Models)

#### [MODIFY] [medicine_model.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/modules/inventory/models/medicine_model.dart)
- إضافة Getter `formattedQuantity`: يقوم بتحويل الكمية الكلية (مثلاً 135 حبة) إلى نص مفصل (مثلاً: 4 علبة + 1 شريط + 5 قرص) بناءً على معاملات التحويل في الوحدات المعرفة.
- إضافة Getter `baseUnitName`: لاستخراج اسم أصغر وحدة معرفة للدواء.

#### [MODIFY] [medicine_unit_model.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/modules/inventory/models/medicine_unit_model.dart)
- التأكد من أن `conversionFactor` يمثل "عدد الوحدات الصغرى (Pills) في هذه الوحدة".

### 2. واجهة المستخدم لإدارة المخزون (Inventory UI)

#### [MODIFY] [medicine_form_content.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/modules/inventory/views/widgets/medicine_form_content.dart)
- تحديث معادلة `_totalQuantity`:
  `Total = Σ (Unit_Quantity_Input * Unit_Conversion_Factor)`
- ضمان حفظ معاملات التحويل بشكل صحيح عند إضافة دواء جديد أو تعديله.

#### [MODIFY] [medicines_list_view.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/modules/inventory/views/medicines_list_view.dart)
- استبدال عرض رقم الكمية المجرد بـ `m.formattedQuantity` في جدول الأدوية.
- تحسين منطق الألوان التحذيرية بناءً على نسبة النواقص من العلب الكاملة.

### 3. نظام المبيعات (POS Logic)

#### [MODIFY] [pos_cart_line.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/modules/sales/models/pos_cart_line.dart)
- إضافة حقل `conversionFactor` لتخزين المعامل للوحدة المختارة.
- إضافة Getter `totalPieces` لحساب `quantity * conversionFactor`.

#### [MODIFY] [cart_cubit.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/modules/sales/bloc/cart_cubit.dart)
- تحديث وظائف الإضافة والتعديل لملء `conversionFactor` بشكل صحيح من وحدات الدواء.

#### [MODIFY] [sale_engine.dart](file:///D:/projects/work/project-pharmacy/pharmacy_system/lib/app/core/data/services/sales/sale_engine.dart)
- تعديل `_decrementStock` ليتم الخصم بناءً على `totalPieces` لضمان خصم العدد الصحيح من الوحدات الصغرى من المخزن الكلي.

## Verification Plan

### Automated Tests
- اختبار منطق التفكيك في `MedicineModel` بحالات مختلفة (وحدة واحدة، وحدتين، ثلاث وحدات).
- اختبار عملية الخصم في `SaleEngine` للتأكد من أن بيع "شريط" يخصم فعلاً معامل تحويله من الإجمالي.

### Manual Verification
1. إضافة صنف بـ 3 مستويات (علبة 30، شريط 10، قرص 1).
2. إدخال رصيد ابتدائي: 2 علبة و 5 قرص.
3. التأكد من ظهور "2 علبة + 5 قرص" في الجدول.
4. بيع "1 شريط" من الـ POS.
5. العودة للجدول والتأكد من الرصيد أصبح "1 علبة + 2 شريط + 5 قرص".
