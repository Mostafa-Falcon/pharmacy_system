/// 🏷️ موديل شريحة وسعر البيع (مبيعات جملة / عملاء VIP / جمهور)
class PriceGroupModel {
  // 🆔 معرف الشريحة
  final String id;

  // 🏷️ اسم الشريحة (مثال: سعر جملة، خصم نقابة 5%)
  final String name;

  // ٪ نسبة هامش الربح المضافة على السعر
  final double markupPercentage;

  // ٪ نسبة الخصم المئوية المطبقة لهذه الشريحة
  final double discountPercentage;

  // ⭐️ هل هذه هي الشريحة الافتراضية للجمهور
  final bool isDefault;

  PriceGroupModel({
    required this.id,
    required this.name,
    this.markupPercentage = 0.0,
    this.discountPercentage = 0.0,
    this.isDefault = false,
  });

  PriceGroupModel copyWith({
    String? id,
    String? name,
    double? markupPercentage,
    double? discountPercentage,
    bool? isDefault,
  }) {
    return PriceGroupModel(
      id: id ?? this.id,
      name: name ?? this.name,
      markupPercentage: markupPercentage ?? this.markupPercentage,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'markup_percentage': markupPercentage,
    'discount_percentage': discountPercentage,
    'is_default': isDefault,
  };

  factory PriceGroupModel.fromJson(Map<String, dynamic> json) => PriceGroupModel(
    id: json['id'] as String,
    name: json['name'] as String,
    markupPercentage: (json['markup_percentage'] as num?)?.toDouble() ?? 0.0,
    discountPercentage: (json['discount_percentage'] as num?)?.toDouble() ?? 0.0,
    isDefault: json['is_default'] as bool? ?? false,
  );
}


