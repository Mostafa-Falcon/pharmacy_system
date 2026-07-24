class MedicineUnitModel {
  final String id;
  final String name;
  final double buyPrice;
  final double sellPrice;
  final int conversionFactor;

  const MedicineUnitModel({
    required this.id,
    required this.name,
    required this.buyPrice,
    required this.sellPrice,
    required this.conversionFactor,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'buy_price': buyPrice,
        'sell_price': sellPrice,
        'conversion_factor': conversionFactor,
      };

  factory MedicineUnitModel.fromJson(Map<String, dynamic> json) =>
      MedicineUnitModel(
        id: json['id'] as String,
        name: json['name'] as String,
        buyPrice: (json['buy_price'] as num?)?.toDouble() ?? 0.0,
        sellPrice: (json['sell_price'] as num?)?.toDouble() ?? 0.0,
        conversionFactor: (json['conversion_factor'] as num?)?.toInt() ?? 1,
      );
}
