// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_definition_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RoleDefinitionModel _$RoleDefinitionModelFromJson(Map<String, dynamic> json) =>
    _RoleDefinitionModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      permissions: (json['permissions'] as List<dynamic>)
          .map((e) => e as String)
          .toSet(),
      isSystem: json['isSystem'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$RoleDefinitionModelToJson(
  _RoleDefinitionModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'permissions': instance.permissions.toList(),
  'isSystem': instance.isSystem,
  'isActive': instance.isActive,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};
