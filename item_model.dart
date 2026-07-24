//  enum لتحديد نوع الخصم (نسبة مئوية % أو مبلغ ثابت ج.م)
enum DiscountType {
  percent, // نسبة مئوية %
  amount,  // مبلغ ثابت (قيمة)
}

class ItemModel {
  // 🆔 المعرف الفريد للصنف (Primary Key)
  final String id;

  // 🏷️ اسم الصنف باللغة العربية (مثال: بنادول إكسترا)
  final String name;

  // 🔤 اسم الصنف باللغة الإنجليزية (مثال: Panadol Extra)
  final String? nameEn;

  // 🏷️ أنواع الأصناف المسجلة (مثال: دواء، مستلزمات طبية، مستحضرات تجميل)
  final List<ItemTypeModel> itemTypes;

  // 📂 المجموعة العلاجية أو الفئة الطبية التابع لها الصنف (مثال: مسكنات، مضادات حيوية)
  final TherapeuticGroupModel therapeuticGroup;

  // 🚚 المورد أو الشركة الموردة
  final String? supplierId;

  // 🏢 الشركة المصنعة (مثال: نوڤارتس)
  final String? manufacturer;

  // 📊 قائمة الباركودات المسجلة لهذا الصنف ككل
  final List<BarcodeModel> barcodes;

  // 💊 الشكل الدوائي والمواصفات
  final String? dosageForm; // شكل الدواء (أقراص، كبسولات...)
  final String? strength; // التركيز (500mg)
  final String? packageSize; // حجم العبوة (24 قرص)
  final String? containerShape; // شكل الحاوية (زجاجة، أنبوبة)

  // 📍 مكان الدواء في الصيدلية (الرف A1 / الثلاجة)
  final String? location;

  // 🧾 إعدادات الضرائب
  final bool isTaxable; // هل خاضع للضريبة
  final String? taxType; // نوع الضريبة
  final double? taxValue; // قيمة أو نسبة الضريبة
  final bool pricesIncludeTax; // السعر شامل الضريبة

  // ⏳ التنبيهات والصلاحيات والمخزون
  final bool alertEnabled; // تفعيل تنبيه النواقص
  final int minStock; // حد النواقص (الأدنى)
  final bool expiryTrackingEnabled; // تفعيل تتبع الصلاحية
  final List<DateTime>? expiryDates; // تواريخ الصلاحيات المسجلة
  final bool allowNegativeStock; // السماح بالبيع بالسالب بدون رصيد
  final bool isActive; // حالة التفعيل في النظام

  // 🖼️ ووصف وصورة الصنف
  final String? imageUrl;
  final String? description;

  // 📐 مستويات ووحدات الصنف الثلاثة (العبوة الرئيسية 1، الفرعية 2، التجزئة 3)
  final ItemLevelsModel itemLevels;

  ItemModel({
    required this.id,
    required this.name,
    this.nameEn,
    required this.itemTypes,
    required this.therapeuticGroup,
    this.supplierId,
    this.manufacturer,
    required this.barcodes,
    this.dosageForm,
    this.strength,
    this.packageSize,
    this.containerShape,
    this.location,
    this.isTaxable = false,
    this.taxType,
    this.taxValue,
    this.pricesIncludeTax = false,
    this.alertEnabled = true,
    this.minStock = 10,
    this.expiryTrackingEnabled = true,
    this.expiryDates,
    this.allowNegativeStock = false,
    this.isActive = true,
    this.imageUrl,
    this.description,
    required this.itemLevels,
  });
}

// 🏷️ موديل نوع الصنف (دواء / مستلزمات / تجميل)
class ItemTypeModel {
  final String id; // المعرف الفريد لنوع الصنف
  final String name; // اسم النوع (مثال: دواء، مستلزمات طبية)

  ItemTypeModel({required this.id, required this.name});
}

// 📂 موديل المجموعة العلاجية (مسكنات / مضادات حيوية / أدوية ضغط)
class TherapeuticGroupModel {
  final String id; // المعرف الفريد للمجموعة العلاجية
  final String name; // اسم المجموعة العلاجية (مثال: مسكنات وأدوية برد)

  TherapeuticGroupModel({required this.id, required this.name});
}

// 📊 موديل بيانات الباركود الخاص بالصنف ككل
class BarcodeModel {
  final String code; // رقم أو نص الباركود الممسوح
  final bool isPrimary; // هل هو الباركود الرئيسي للصنف

  BarcodeModel({
    required this.code,
    this.isPrimary = false,
  });
}

// 📐 موديل المستويات والوحدات الثلاثة بالكامل (العبوة الرئيسية 1، الفرعية 2، التجزئة 3)
class ItemLevelsModel {
  // ─── 📦 الوحدة 1: العبوة الرئيسية (مثال: علبة) ───
  final String unit1Name; // اسم الوحدة 1 (علبة)
  final int unit1Count; // عدد العبوات الرئيسية
  final int unit1Quantity; // رصيد/كمية الوحدة 1
  final double unit1BuyPrice; // سعر شراء الوحدة 1 (التكلفة)
  final double unit1SellPrice; // سعر بيع الوحدة 1
  final bool unit1IsNewSellPriceActive; // تفعيل السعر الجديد للوحدة 1
  final double? unit1NewSellPrice; // سعر البيع الجديد للوحدة 1
  final bool unit1IsSaleAllowed; // مسموح بالبيع للوحدة 1
  final DiscountType unit1DiscountType; // نوع الخصم للوحدة 1 (نسبة % أم مبلغ ثابت)
  final double? unit1DiscountValue; // قيمة الخصم للوحدة 1 (نسبة أو مبلغ)

  // ─── 📦 الوحدة 2: الوحدة الفرعية الأولى (مثال: شريط) ───
  final bool unit2Enabled; // تفعيل المستوى الثاني (الوحدة 2)
  final String? unit2Name; // اسم الوحدة 2 (شريط)
  final int? unit2Count; // معامل التفكيك (كم قطعة من هذه الوحدة داخل العبوة 1)
  final int? unit2Quantity; // رصيد/كمية الوحدة 2
  final double? unit2BuyPrice; // سعر شراء الوحدة 2
  final double? unit2SellPrice; // سعر بيع الوحدة 2
  final bool unit2IsNewSellPriceActive; // تفعيل السعر الجديد للوحدة 2
  final double? unit2NewSellPrice; // سعر البيع الجديد للوحدة 2
  final bool unit2IsSaleAllowed; // مسموح بالبيع للوحدة 2
  final DiscountType? unit2DiscountType; // نوع الخصم للوحدة 2 (نسبة % أم مبلغ ثابت)
  final double? unit2DiscountValue; // قيمة الخصم للوحدة 2

  // ─── 📦 الوحدة 3: الوحدة الفرعية الثانية (مثال: قرص) ───
  final bool unit3Enabled; // تفعيل المستوى الثالث (الوحدة 3)
  final String? unit3Name; // اسم الوحدة 3 (قرص)
  final int? unit3Count; // معامل التفكيك (كم قطعة من هذه الوحدة داخل الوحدة 2)
  final int? unit3Quantity; // رصيد/كمية الوحدة 3
  final double? unit3BuyPrice; // سعر شراء الوحدة 3
  final double? unit3SellPrice; // سعر بيع الوحدة 3
  final bool unit3IsNewSellPriceActive; // تفعيل السعر الجديد للوحدة 3
  final double? unit3NewSellPrice; // سعر البيع الجديد للوحدة 3
  final bool unit3IsSaleAllowed; // مسموح بالبيع للوحدة 3
  final DiscountType? unit3DiscountType; // نوع الخصم للوحدة 3 (نسبة % أم مبلغ ثابت)
  final double? unit3DiscountValue; // قيمة الخصم للوحدة 3

  ItemLevelsModel({
    // الوحدة 1 (إجباري)
    required this.unit1Name,
    required this.unit1Count,
    required this.unit1Quantity,
    required this.unit1BuyPrice,
    required this.unit1SellPrice,
    this.unit1IsNewSellPriceActive = false,
    this.unit1NewSellPrice,
    this.unit1IsSaleAllowed = true,
    this.unit1DiscountType = DiscountType.percent,
    this.unit1DiscountValue,

    // الوحدة 2 (اختياري حسب التفعيل)
    this.unit2Enabled = false,
    this.unit2Name,
    this.unit2Count,
    this.unit2Quantity,
    this.unit2BuyPrice,
    this.unit2SellPrice,
    this.unit2IsNewSellPriceActive = false,
    this.unit2NewSellPrice,
    this.unit2IsSaleAllowed = true,
    this.unit2DiscountType,
    this.unit2DiscountValue,

    // الوحدة 3 (اختياري حسب التفعيل)
    this.unit3Enabled = false,
    this.unit3Name,
    this.unit3Count,
    this.unit3Quantity,
    this.unit3BuyPrice,
    this.unit3SellPrice,
    this.unit3IsNewSellPriceActive = false,
    this.unit3NewSellPrice,
    this.unit3IsSaleAllowed = true,
    this.unit3DiscountType,
    this.unit3DiscountValue,
  });
}
