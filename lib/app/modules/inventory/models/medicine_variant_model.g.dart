// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicine_variant_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MedicineVariantModel _$MedicineVariantModelFromJson(
  Map<String, dynamic> json,
) => _MedicineVariantModel(
  id: json['id'] as String,
  medicineId: json['medicine_id'] as String,
  name: json['name'] as String,
  price: (json['price'] as num).toDouble(),
  cost: (json['cost'] as num).toDouble(),
  sku: json['sku'] as String,
  attributes: json['attributes'] == null
      ? const {}
      : _stringMapFromJson(json['attributes'] as Map<String, dynamic>?),
);

Map<String, dynamic> _$MedicineVariantModelToJson(
  _MedicineVariantModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'medicine_id': instance.medicineId,
  'name': instance.name,
  'price': instance.price,
  'cost': instance.cost,
  'sku': instance.sku,
  'attributes': _stringMapToJson(instance.attributes),
};
