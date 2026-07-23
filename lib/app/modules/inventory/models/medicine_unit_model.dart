import 'package:pharmacy_system/app/core/constants/app_strings.dart';

class MedicineUnitModel {
  String id;
  String name;
  int level;
  double conversionFactor;
  double buyPrice;
  double sellPrice;
  double? oldSellPrice;
  double? discountPercent;
  bool allowSale;
  int quantity;
  String? barcode;

  MedicineUnitModel({
    required this.id,
    required this.name,
    required this.level,
    this.conversionFactor = 1,
    this.buyPrice = 0,
    this.sellPrice = 0,
    this.oldSellPrice,
    this.discountPercent,
    this.allowSale = true,
    this.quantity = 0,
    this.barcode,
  });

  bool get isMain => level == 1;

  /// إجمالي الكمية بالوحدات الصغرى (Base Units)
  double get quantityInBaseUnit {
    return quantity * conversionFactor;
  }

  static MedicineUnitModel createMain({
    required String medicineId,
    String name = AppStrings.defaultUnitBox,
  }) {
    return MedicineUnitModel(
      id: '${medicineId}_unit_main',
      name: name,
      level: 1,
      conversionFactor: 1,
    );
  }

  static MedicineUnitModel createSub({
    required String medicineId,
    required int level,
    String name = AppStrings.defaultUnitStrip,
    double conversionFactor = 10,
  }) {
    return MedicineUnitModel(
      id: '${medicineId}_unit_$level',
      name: name,
      level: level,
      conversionFactor: conversionFactor,
    );
  }

  MedicineUnitModel copyWith({
    String? id,
    String? name,
    int? level,
    double? conversionFactor,
    double? buyPrice,
    double? sellPrice,
    double? oldSellPrice,
    double? discountPercent,
    bool? allowSale,
    int? quantity,
    String? barcode,
  }) {
    return MedicineUnitModel(
      id: id ?? this.id,
      name: name ?? this.name,
      level: level ?? this.level,
      conversionFactor: conversionFactor ?? this.conversionFactor,
      buyPrice: buyPrice ?? this.buyPrice,
      sellPrice: sellPrice ?? this.sellPrice,
      oldSellPrice: oldSellPrice ?? this.oldSellPrice,
      discountPercent: discountPercent ?? this.discountPercent,
      allowSale: allowSale ?? this.allowSale,
      quantity: quantity ?? this.quantity,
      barcode: barcode ?? this.barcode,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'level': level,
    'conversion_factor': conversionFactor,
    'buy_price': buyPrice,
    'sell_price': sellPrice,
    'old_sell_price': oldSellPrice,
    'discount_percent': discountPercent,
    'allow_sale': allowSale,
    'quantity': quantity,
    'barcode': barcode,
  };

  factory MedicineUnitModel.fromJson(Map<String, dynamic> json) => MedicineUnitModel(
    id: json['id'] as String,
    name: json['name'] as String,
    level: json['level'] as int,
    conversionFactor: (json['conversion_factor'] as num).toDouble(),
    buyPrice: (json['buy_price'] as num?)?.toDouble() ?? 0,
    sellPrice: (json['sell_price'] as num?)?.toDouble() ?? 0,
    oldSellPrice: (json['old_sell_price'] as num?)?.toDouble(),
    discountPercent: (json['discount_percent'] as num?)?.toDouble(),
    allowSale: json['allow_sale'] as bool? ?? true,
    quantity: json['quantity'] as int? ?? 0,
    barcode: json['barcode'] as String?,
  );
}
