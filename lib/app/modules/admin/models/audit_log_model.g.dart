// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_log_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuditLogModel _$AuditLogModelFromJson(Map<String, dynamic> json) =>
    _AuditLogModel(
      id: json['id'] as String,
      action: json['action'] as String,
      entityType: json['entityType'] as String,
      entityId: json['entityId'] as String,
      actorId: json['actorId'] as String,
      actorName: json['actorName'] as String?,
      branchId: json['branchId'] as String?,
      summary: json['summary'] as Map<String, dynamic>?,
      occurredAt: DateTime.parse(json['occurredAt'] as String),
    );

Map<String, dynamic> _$AuditLogModelToJson(_AuditLogModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'action': instance.action,
      'entityType': instance.entityType,
      'entityId': instance.entityId,
      'actorId': instance.actorId,
      'actorName': instance.actorName,
      'branchId': instance.branchId,
      'summary': instance.summary,
      'occurredAt': instance.occurredAt.toIso8601String(),
    };
