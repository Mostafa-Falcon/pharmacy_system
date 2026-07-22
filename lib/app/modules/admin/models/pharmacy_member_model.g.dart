// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pharmacy_member_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PharmacyMemberModel _$PharmacyMemberModelFromJson(Map<String, dynamic> json) =>
    _PharmacyMemberModel(
      id: json['id'] as String,
      userId: json['userId'] as String?,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      roleId: json['roleId'] as String,
      branchIds: (json['branchIds'] as List<dynamic>)
          .map((e) => e as String)
          .toSet(),
      permissions: (json['permissions'] as List<dynamic>)
          .map((e) => e as String)
          .toSet(),
      isActive: json['isActive'] as bool? ?? true,
      invitationStatus: json['invitationStatus'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$PharmacyMemberModelToJson(
  _PharmacyMemberModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'name': instance.name,
  'email': instance.email,
  'phone': instance.phone,
  'roleId': instance.roleId,
  'branchIds': instance.branchIds.toList(),
  'permissions': instance.permissions.toList(),
  'isActive': instance.isActive,
  'invitationStatus': instance.invitationStatus,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};
