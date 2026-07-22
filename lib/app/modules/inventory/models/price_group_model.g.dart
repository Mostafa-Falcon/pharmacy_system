// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price_group_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PriceGroupModel _$PriceGroupModelFromJson(Map<String, dynamic> json) =>
    _PriceGroupModel(
      id: json['id'] as String,
      name: json['name'] as String,
      markupPercentage: (json['markup_percentage'] as num?)?.toDouble() ?? 0,
      discountPercentage:
          (json['discount_percentage'] as num?)?.toDouble() ?? 0,
      isDefault: json['is_default'] as bool? ?? false,
    );

Map<String, dynamic> _$PriceGroupModelToJson(_PriceGroupModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'markup_percentage': instance.markupPercentage,
      'discount_percentage': instance.discountPercentage,
      'is_default': instance.isDefault,
    };
