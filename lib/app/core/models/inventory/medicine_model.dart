import 'package:collection/collection.dart';
import 'package:pharmacy_system/app/core/sync/syncable_entity.dart';

/// ٪ نوع الخصم الخاص بوحدة الدواء (نسبة مئوية % أم مبلغ ثابت ج.م)
enum DiscountType {
  percent, // نسبة مئوية %
  amount, // مبلغ ثابت (قيمة)
}

/// 🏷️ موديل نوع الصنف (دواء / مستلزمات / تجميل)
class ItemTypeModel {
  final String id; // المعرف الفريد لنوع الصنف
  final String name; // اسم النوع (مثال: دواء، مستلزمات طبية)

  ItemTypeModel({required this.id, required this.name});

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
  factory ItemTypeModel.fromJson(Map<String, dynamic> json) =>
      ItemTypeModel(id: json['id'] as String, name: json['name'] as String);
}

/// 📂 موديل المجموعة العلاجية (مسكنات / مضادات حيوية / أدوية ضغط)
class TherapeuticGroupModel {
  final String id; // المعرف الفريد للمجموعة العلاجية
  final String name; // اسم المجموعة العلاجية (مثال: مسكنات وأدوية برد)

  TherapeuticGroupModel({required this.id, required this.name});

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
  factory TherapeuticGroupModel.fromJson(Map<String, dynamic> json) =>
      TherapeuticGroupModel(
        id: json['id'] as String,
        name: json['name'] as String,
      );
}

/// 📊 موديل بيانات الباركود الخاص بالصنف ككل
class BarcodeModel {
  final String code; // رقم أو نص الباركود الممسوح
  final bool isPrimary; // هل هو الباركود الرئيسي للصنف

  BarcodeModel({required this.code, this.isPrimary = false});

  Map<String, dynamic> toJson() => {'code': code, 'is_primary': isPrimary};
  factory BarcodeModel.fromJson(Map<String, dynamic> json) => BarcodeModel(
    code: json['code'] as String,
    isPrimary: json['is_primary'] as bool? ?? false,
  );
}

/// 📐 موديل المستويات والوحدات الثلاثة المباشرة والصريحة
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
  final DiscountType
  unit1DiscountType; // نوع الخصم للوحدة 1 (نسبة % أم مبلغ ثابت)
  final double? unit1DiscountValue; // قيمة الخصم للوحدة 1 (نسبة أو مبلغ)

  // ─── 📦 الوحدة 2: الوحدة الفرعية الأولى (مثال: شريط) ───
  final bool unit2Enabled; // تفعيل المستوى الثاني (الوحدة 2)
  final String? unit2Name; // اسم الوحدة 2 (شريط)
  final int? unit2Count; // معامل التفكيك (كم وحدة 2 داخل العبوة 1)
  final int? unit2Quantity; // رصيد/كمية الوحدة 2
  final double? unit2BuyPrice; // سعر شراء الوحدة 2
  final double? unit2SellPrice; // سعر بيع الوحدة 2
  final bool unit2IsNewSellPriceActive; // تفعيل السعر الجديد للوحدة 2
  final double? unit2NewSellPrice; // سعر البيع الجديد للوحدة 2
  final bool unit2IsSaleAllowed; // مسموح بالبيع للوحدة 2
  final DiscountType? unit2DiscountType; // نوع الخصم للوحدة 2
  final double? unit2DiscountValue; // قيمة الخصم للوحدة 2

  // ─── 📦 الوحدة 3: الوحدة الفرعية الثانية (مثال: قرص) ───
  final bool unit3Enabled; // تفعيل المستوى الثالث (الوحدة 3)
  final String? unit3Name; // اسم الوحدة 3 (قرص)
  final int? unit3Count; // معامل التفكيك (كم وحدة 3 داخل الوحدة 2)
  final int? unit3Quantity; // رصيد/كمية الوحدة 3
  final double? unit3BuyPrice; // سعر شراء الوحدة 3
  final double? unit3SellPrice; // سعر بيع الوحدة 3
  final bool unit3IsNewSellPriceActive; // تفعيل السعر الجديد للوحدة 3
  final double? unit3NewSellPrice; // سعر البيع الجديد للوحدة 3
  final bool unit3IsSaleAllowed; // مسموح بالبيع للوحدة 3
  final DiscountType? unit3DiscountType; // نوع الخصم للوحدة 3
  final double? unit3DiscountValue; // قيمة الخصم للوحدة 3

  ItemLevelsModel({
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

  Map<String, dynamic> toJson() => {
    'unit_1_name': unit1Name,
    'unit_1_count': unit1Count,
    'unit_1_quantity': unit1Quantity,
    'unit_1_buy_price': unit1BuyPrice,
    'unit_1_sell_price': unit1SellPrice,
    'unit_1_is_new_sell_price_active': unit1IsNewSellPriceActive,
    'unit_1_new_sell_price': unit1NewSellPrice,
    'unit_1_is_sale_allowed': unit1IsSaleAllowed,
    'unit_1_discount_type': unit1DiscountType.name,
    'unit_1_discount_value': unit1DiscountValue,

    'unit_2_enabled': unit2Enabled,
    'unit_2_name': unit2Name,
    'unit_2_count': unit2Count,
    'unit_2_quantity': unit2Quantity,
    'unit_2_buy_price': unit2BuyPrice,
    'unit_2_sell_price': unit2SellPrice,
    'unit_2_is_new_sell_price_active': unit2IsNewSellPriceActive,
    'unit_2_new_sell_price': unit2NewSellPrice,
    'unit_2_is_sale_allowed': unit2IsSaleAllowed,
    'unit_2_discount_type': unit2DiscountType?.name,
    'unit_2_discount_value': unit2DiscountValue,

    'unit_3_enabled': unit3Enabled,
    'unit_3_name': unit3Name,
    'unit_3_count': unit3Count,
    'unit_3_quantity': unit3Quantity,
    'unit_3_buy_price': unit3BuyPrice,
    'unit_3_sell_price': unit3SellPrice,
    'unit_3_is_new_sell_price_active': unit3IsNewSellPriceActive,
    'unit_3_new_sell_price': unit3NewSellPrice,
    'unit_3_is_sale_allowed': unit3IsSaleAllowed,
    'unit_3_discount_type': unit3DiscountType?.name,
    'unit_3_discount_value': unit3DiscountValue,
  };

  factory ItemLevelsModel.fromJson(Map<String, dynamic> json) =>
      ItemLevelsModel(
        unit1Name: (json['unit_1_name'] as String?) ?? 'علبة',
        unit1Count: (json['unit_1_count'] as num?)?.toInt() ?? 1,
        unit1Quantity: (json['unit_1_quantity'] as num?)?.toInt() ?? 0,
        unit1BuyPrice: (json['unit_1_buy_price'] as num?)?.toDouble() ?? 0,
        unit1SellPrice: (json['unit_1_sell_price'] as num?)?.toDouble() ?? 0,
        unit1IsNewSellPriceActive:
            json['unit_1_is_new_sell_price_active'] as bool? ?? false,
        unit1NewSellPrice: (json['unit_1_new_sell_price'] as num?)?.toDouble(),
        unit1IsSaleAllowed: json['unit_1_is_sale_allowed'] as bool? ?? true,
        unit1DiscountType: json['unit_1_discount_type'] == 'amount'
            ? DiscountType.amount
            : DiscountType.percent,
        unit1DiscountValue: (json['unit_1_discount_value'] as num?)?.toDouble(),

        unit2Enabled: json['unit_2_enabled'] as bool? ?? false,
        unit2Name: json['unit_2_name'] as String?,
        unit2Count: (json['unit_2_count'] as num?)?.toInt(),
        unit2Quantity: (json['unit_2_quantity'] as num?)?.toInt(),
        unit2BuyPrice: (json['unit_2_buy_price'] as num?)?.toDouble(),
        unit2SellPrice: (json['unit_2_sell_price'] as num?)?.toDouble(),
        unit2IsNewSellPriceActive:
            json['unit_2_is_new_sell_price_active'] as bool? ?? false,
        unit2NewSellPrice: (json['unit_2_new_sell_price'] as num?)?.toDouble(),
        unit2IsSaleAllowed: json['unit_2_is_sale_allowed'] as bool? ?? true,
        unit2DiscountType: json['unit_2_discount_type'] == 'amount'
            ? DiscountType.amount
            : DiscountType.percent,
        unit2DiscountValue: (json['unit_2_discount_value'] as num?)?.toDouble(),

        unit3Enabled: json['unit_3_enabled'] as bool? ?? false,
        unit3Name: json['unit_3_name'] as String?,
        unit3Count: (json['unit_3_count'] as num?)?.toInt(),
        unit3Quantity: (json['unit_3_quantity'] as num?)?.toInt(),
        unit3BuyPrice: (json['unit_3_buy_price'] as num?)?.toDouble(),
        unit3SellPrice: (json['unit_3_sell_price'] as num?)?.toDouble(),
        unit3IsNewSellPriceActive:
            json['unit_3_is_new_sell_price_active'] as bool? ?? false,
        unit3NewSellPrice: (json['unit_3_new_sell_price'] as num?)?.toDouble(),
        unit3IsSaleAllowed: json['unit_3_is_sale_allowed'] as bool? ?? true,
        unit3DiscountType: json['unit_3_discount_type'] == 'amount'
            ? DiscountType.amount
            : DiscountType.percent,
        unit3DiscountValue: (json['unit_3_discount_value'] as num?)?.toDouble(),
      );
}

/// 💊 موديل بيانات الدواء الموحد الشامل الخاص برؤيتك المعمارية المعتمدة
class MedicineModel implements SyncableEntity {
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

  // ⚙️ حقول الإدارة والمزامنة
  final String? accountId;
  final String? branchId;
  final int syncVersion;
  @override
  final DateTime lastModified;
  @override
  final bool isDeleted;

  // ─── Backward Compatibility Getters ───
  double get buyPrice => itemLevels.unit1BuyPrice;
  double get sellPrice => itemLevels.unit1IsNewSellPriceActive
      ? (itemLevels.unit1NewSellPrice ?? itemLevels.unit1SellPrice)
      : itemLevels.unit1SellPrice;
  int get quantity => itemLevels.unit1Quantity;
  String? get primaryBarcode => barcodes.isEmpty
      ? null
      : (barcodes.firstWhereOrNull((b) => b.isPrimary)?.code ??
            barcodes.first.code);
  String? get category => therapeuticGroup.name;
  DateTime? get expiryDate => expiryDates?.firstOrNull;
  DateTime get createdAt => lastModified;

  @override
  String? get syncBranchId => branchId;

  MedicineModel({
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
    this.accountId,
    this.branchId,
    this.syncVersion = 1,
    DateTime? lastModified,
    this.isDeleted = false,
  }) : lastModified = lastModified ?? DateTime.now();

  MedicineModel copyWith({
    String? id,
    String? name,
    String? nameEn,
    List<ItemTypeModel>? itemTypes,
    TherapeuticGroupModel? therapeuticGroup,
    String? supplierId,
    String? manufacturer,
    List<BarcodeModel>? barcodes,
    String? dosageForm,
    String? strength,
    String? packageSize,
    String? containerShape,
    String? location,
    bool? isTaxable,
    String? taxType,
    double? taxValue,
    bool? pricesIncludeTax,
    bool? alertEnabled,
    int? minStock,
    bool? expiryTrackingEnabled,
    List<DateTime>? expiryDates,
    bool? allowNegativeStock,
    bool? isActive,
    String? imageUrl,
    String? description,
    ItemLevelsModel? itemLevels,
    String? accountId,
    String? branchId,
    int? syncVersion,
    DateTime? lastModified,
    bool? isDeleted,
  }) {
    return MedicineModel(
      id: id ?? this.id,
      name: name ?? this.name,
      nameEn: nameEn ?? this.nameEn,
      itemTypes: itemTypes ?? this.itemTypes,
      therapeuticGroup: therapeuticGroup ?? this.therapeuticGroup,
      supplierId: supplierId ?? this.supplierId,
      manufacturer: manufacturer ?? this.manufacturer,
      barcodes: barcodes ?? this.barcodes,
      dosageForm: dosageForm ?? this.dosageForm,
      strength: strength ?? this.strength,
      packageSize: packageSize ?? this.packageSize,
      containerShape: containerShape ?? this.containerShape,
      location: location ?? this.location,
      isTaxable: isTaxable ?? this.isTaxable,
      taxType: taxType ?? this.taxType,
      taxValue: taxValue ?? this.taxValue,
      pricesIncludeTax: pricesIncludeTax ?? this.pricesIncludeTax,
      alertEnabled: alertEnabled ?? this.alertEnabled,
      minStock: minStock ?? this.minStock,
      expiryTrackingEnabled: expiryTrackingEnabled ?? this.expiryTrackingEnabled,
      expiryDates: expiryDates ?? this.expiryDates,
      allowNegativeStock: allowNegativeStock ?? this.allowNegativeStock,
      isActive: isActive ?? this.isActive,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      itemLevels: itemLevels ?? this.itemLevels,
      accountId: accountId ?? this.accountId,
      branchId: branchId ?? this.branchId,
      syncVersion: syncVersion ?? this.syncVersion,
      lastModified: lastModified ?? this.lastModified,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  /// 📦 نص عرض الرصيد التراكمي في الواجهات (مثال: 2 علبة + 1 شريط + 4 قرص)
  String get formattedQuantity {
    List<String> parts = [];
    parts.add('${itemLevels.unit1Quantity} ${itemLevels.unit1Name}');
    if (itemLevels.unit2Enabled && itemLevels.unit2Name != null) {
      parts.add('${itemLevels.unit2Quantity ?? 0} ${itemLevels.unit2Name}');
    }
    if (itemLevels.unit3Enabled && itemLevels.unit3Name != null) {
      parts.add('${itemLevels.unit3Quantity ?? 0} ${itemLevels.unit3Name}');
    }
    return parts.join(' + ');
  }

  /// 📦 قائمة الوحدات المتاحة للصنف للتعامل معها في القوائم المنسدلة
  List<
    ({String id, String name, double buyPrice, double sellPrice, int factor})
  >
  get units {
    List<
      ({String id, String name, double buyPrice, double sellPrice, int factor})
    >
    list = [];

    list.add((
      id: 'unit1',
      name: itemLevels.unit1Name,
      buyPrice: itemLevels.unit1BuyPrice,
      sellPrice: itemLevels.unit1IsNewSellPriceActive
          ? (itemLevels.unit1NewSellPrice ?? itemLevels.unit1SellPrice)
          : itemLevels.unit1SellPrice,
      factor: 1,
    ));

    if (itemLevels.unit2Enabled && itemLevels.unit2Name != null) {
      list.add((
        id: 'unit2',
        name: itemLevels.unit2Name!,
        buyPrice: itemLevels.unit2BuyPrice ?? 0,
        sellPrice: itemLevels.unit2IsNewSellPriceActive
            ? (itemLevels.unit2NewSellPrice ?? itemLevels.unit2SellPrice ?? 0)
            : (itemLevels.unit2SellPrice ?? 0),
        factor: itemLevels.unit2Count ?? 1,
      ));
    }

    if (itemLevels.unit3Enabled && itemLevels.unit3Name != null) {
      list.add((
        id: 'unit3',
        name: itemLevels.unit3Name!,
        buyPrice: itemLevels.unit3BuyPrice ?? 0,
        sellPrice: itemLevels.unit3IsNewSellPriceActive
            ? (itemLevels.unit3NewSellPrice ?? itemLevels.unit3SellPrice ?? 0)
            : (itemLevels.unit3SellPrice ?? 0),
        factor: (itemLevels.unit2Count ?? 1) * (itemLevels.unit3Count ?? 1),
      ));
    }

    return list;
  }

  /// 📦 إجمالي الرصيد بوحدة "التجزئة الصغرى" (أصغر وحدة ممكنة)
  int get totalQuantityInSmallestUnit {
    int total = itemLevels.unit1Quantity;
    if (itemLevels.unit2Enabled) {
      total =
          (total * (itemLevels.unit2Count ?? 1)) +
          (itemLevels.unit2Quantity ?? 0);
      if (itemLevels.unit3Enabled) {
        total =
            (total * (itemLevels.unit3Count ?? 1)) +
            (itemLevels.unit3Quantity ?? 0);
      }
    }
    return total;
  }

  /// 🔄 تحويل الكائن بالكامل إلى JSON ليُرسل ويُخزن مباشرة في Supabase و Drift
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'name_en': nameEn,
    'item_types': itemTypes.map((t) => t.toJson()).toList(),
    'therapeutic_group': therapeuticGroup.toJson(),
    'supplier_id': supplierId,
    'manufacturer': manufacturer,
    'barcodes': barcodes.map((b) => b.toJson()).toList(),
    'dosage_form': dosageForm,
    'strength': strength,
    'package_size': packageSize,
    'container_shape': containerShape,
    'location': location,
    'is_taxable': isTaxable,
    'tax_type': taxType,
    'tax_value': taxValue,
    'prices_include_tax': pricesIncludeTax,
    'alert_enabled': alertEnabled,
    'min_stock': minStock,
    'expiry_tracking_enabled': expiryTrackingEnabled,
    'expiry_dates': expiryDates?.map((d) => d.toIso8601String()).toList(),
    'allow_negative_stock': allowNegativeStock,
    'is_active': isActive,
    'image_url': imageUrl,
    'description': description,
    'item_levels': itemLevels.toJson(),
    'account_id': accountId,
    'branch_id': branchId,
    'sync_version': syncVersion,
    'last_modified': lastModified.toIso8601String(),
    'is_deleted': isDeleted,
  };

  /// 🔄 استعادة الكائن بالكامل من JSON القادم من Supabase و Drift
  factory MedicineModel.fromJson(Map<String, dynamic> json) => MedicineModel(
    id: json['id'] as String,
    name: json['name'] as String,
    nameEn: json['name_en'] as String?,
    itemTypes:
        (json['item_types'] as List<dynamic>?)
            ?.map((e) => ItemTypeModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    therapeuticGroup: TherapeuticGroupModel.fromJson(
      json['therapeutic_group'] as Map<String, dynamic>,
    ),
    supplierId: json['supplier_id'] as String?,
    manufacturer: json['manufacturer'] as String?,
    barcodes:
        (json['barcodes'] as List<dynamic>?)
            ?.map((e) => BarcodeModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    dosageForm: json['dosage_form'] as String?,
    strength: json['strength'] as String?,
    packageSize: json['package_size'] as String?,
    containerShape: json['container_shape'] as String?,
    location: json['location'] as String?,
    isTaxable: json['is_taxable'] as bool? ?? false,
    taxType: json['tax_type'] as String?,
    taxValue: (json['tax_value'] as num?)?.toDouble(),
    pricesIncludeTax: json['prices_include_tax'] as bool? ?? false,
    alertEnabled: json['alert_enabled'] as bool? ?? true,
    minStock: (json['min_stock'] as num?)?.toInt() ?? 10,
    expiryTrackingEnabled: json['expiry_tracking_enabled'] as bool? ?? true,
    expiryDates: (json['expiry_dates'] as List<dynamic>?)
        ?.map((e) => DateTime.parse(e as String))
        .toList(),
    allowNegativeStock: json['allow_negative_stock'] as bool? ?? false,
    isActive: json['is_active'] as bool? ?? true,
    imageUrl: json['image_url'] as String?,
    description: json['description'] as String?,
    itemLevels: ItemLevelsModel.fromJson(
      json['item_levels'] as Map<String, dynamic>,
    ),
    accountId: json['account_id'] as String?,
    branchId: json['branch_id'] as String?,
    syncVersion: (json['sync_version'] as num?)?.toInt() ?? 1,
    lastModified: json['last_modified'] != null
        ? DateTime.tryParse(json['last_modified'] as String) ?? DateTime.now()
        : DateTime.now(),
    isDeleted: json['is_deleted'] as bool? ?? false,
  );
}
