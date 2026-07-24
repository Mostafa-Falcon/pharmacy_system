/// 📦 موديل أصناف الموردين والعملاء (Supplied Items Model)
class SuppliedItemModel {
  // 🆔 المعرف الفريد لسطر الأصناف الموردة (Primary Key)
  final String id;

  // 👤 معرف جهة التعامل (المورد أو العميل)
  final String contactId;

  // 💊 معرف الصنف/الدواء من جدول الأدوية
  final String medicineId;

  // 🏷️ اسم الصنف/الدواء بالعربي (مثل: بارامول، باي الكوفان)
  final String medicineName;

  // 🔢 مستوى الوحدة الموردة (1 = علبة، 2 = شريط، 3 = قرص)
  final int unitLevel;

  // 🏷️ اسم الوحدة الموردة (علبة، شريط، قرص)
  final String unitName;

  // 📦 الكمية الموردة
  final double quantity;

  // 💵 سعر الوحدة قبل الضريبة والخصم
  final double unitPrice;

  // ٪ نوع الخصم المورد (نسبة مئوية % أم مبلغ ثابت ج.م)
  final String discountType;

  // ٪ قيمة الخصم المعتمدة من المورد (نسبة % أو مبلغ)
  final double discountValue;

  // 🧾 قيمة الضريبة المضافة
  final double taxAmount;

  // 🏷️ السعر النهائي للوحدة شامل الضريبة والخصم
  final double priceWithTax;

  // 💰 الإجمالي النهائي للسطر (الكمية × السعر شامل الضريبة)
  final double totalAmount;

  // 📅 تاريخ التوريد / الشراء
  final DateTime date;

  SuppliedItemModel({
    required this.id,
    required this.contactId,
    required this.medicineId,
    required this.medicineName,
    this.unitLevel = 1,
    this.unitName = 'علبة',
    required this.quantity,
    required this.unitPrice,
    this.discountType = 'percent',
    this.discountValue = 0.0,
    this.taxAmount = 0.0,
    required this.priceWithTax,
    required this.totalAmount,
    DateTime? date,
  }) : date = date ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'contact_id': contactId,
    'medicine_id': medicineId,
    'medicine_name': medicineName,
    'unit_level': unitLevel,
    'unit_name': unitName,
    'quantity': quantity,
    'unit_price': unitPrice,
    'discount_type': discountType,
    'discount_value': discountValue,
    'tax_amount': taxAmount,
    'price_with_tax': priceWithTax,
    'total_amount': totalAmount,
    'date': date.toIso8601String(),
  };

  factory SuppliedItemModel.fromJson(Map<String, dynamic> json) => SuppliedItemModel(
    id: json['id'] as String,
    contactId: json['contact_id'] as String,
    medicineId: json['medicine_id'] as String,
    medicineName: json['medicine_name'] as String,
    unitLevel: (json['unit_level'] as num?)?.toInt() ?? 1,
    unitName: (json['unit_name'] as String?) ?? 'علبة',
    quantity: (json['quantity'] as num?)?.toDouble() ?? 0.0,
    unitPrice: (json['unit_price'] as num?)?.toDouble() ?? 0.0,
    discountType: json['discount_type'] as String? ?? 'percent',
    discountValue: (json['discount_value'] as num?)?.toDouble() ?? 0.0,
    taxAmount: (json['tax_amount'] as num?)?.toDouble() ?? 0.0,
    priceWithTax: (json['price_with_tax'] as num?)?.toDouble() ?? 0.0,
    totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
    date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
  );
}


