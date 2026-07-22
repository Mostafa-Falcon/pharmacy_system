// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_notification_model.freezed.dart';
part 'app_notification_model.g.dart';

enum NotificationPriority { low, medium, high, critical }

enum NotificationCategory { expiry, stock, system, task, crm }

NotificationPriority _priorityFromJson(Object? json) {
  final value = json as String? ?? '';
  return NotificationPriority.values.firstWhere(
      (e) => e.name == value,
      orElse: () => NotificationPriority.medium);
}

String _priorityToJson(NotificationPriority priority) => priority.name;

NotificationCategory _categoryFromJson(Object? json) {
  final value = json as String? ?? '';
  return NotificationCategory.values.firstWhere(
      (e) => e.name == value,
      orElse: () => NotificationCategory.system);
}

String _categoryToJson(NotificationCategory category) => category.name;

@freezed
abstract class AppNotification with _$AppNotification {
  const AppNotification._();

  const factory AppNotification({
    required String id,
    required String title,
    required String message,
    required DateTime timestamp,
    @JsonKey(fromJson: _categoryFromJson, toJson: _categoryToJson)
    @Default(NotificationCategory.system) NotificationCategory category,
    @JsonKey(fromJson: _priorityFromJson, toJson: _priorityToJson)
    @Default(NotificationPriority.medium) NotificationPriority priority,
    @Default(false) bool isRead,
    Map<String, dynamic>? metadata,
    String? actionRoute,
  }) = _AppNotification;

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationFromJson(json);
}
