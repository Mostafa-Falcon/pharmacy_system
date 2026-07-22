// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicine_brand_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MedicineBrandModel _$MedicineBrandModelFromJson(Map<String, dynamic> json) =>
    _MedicineBrandModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      logo: json['logo'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$MedicineBrandModelToJson(_MedicineBrandModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'logo': instance.logo,
      'created_at': instance.createdAt.toIso8601String(),
    };
