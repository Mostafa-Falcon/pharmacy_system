// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppNotification _$AppNotificationFromJson(Map<String, dynamic> json) =>
    _AppNotification(
      id: json['id'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      category: json['category'] == null
          ? NotificationCategory.system
          : _categoryFromJson(json['category']),
      priority: json['priority'] == null
          ? NotificationPriority.medium
          : _priorityFromJson(json['priority']),
      isRead: json['isRead'] as bool? ?? false,
      metadata: json['metadata'] as Map<String, dynamic>?,
      actionRoute: json['actionRoute'] as String?,
    );

Map<String, dynamic> _$AppNotificationToJson(_AppNotification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'message': instance.message,
      'timestamp': instance.timestamp.toIso8601String(),
      'category': _categoryToJson(instance.category),
      'priority': _priorityToJson(instance.priority),
      'isRead': instance.isRead,
      'metadata': instance.metadata,
      'actionRoute': instance.actionRoute,
    };
