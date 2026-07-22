import 'package:equatable/equatable.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object?> get props => [];
}

class LoadNotifications extends NotificationsEvent {
  const LoadNotifications();
}

class MarkAsRead extends NotificationsEvent {
  final String notificationId;
  const MarkAsRead(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}

class MarkAllAsRead extends NotificationsEvent {
  const MarkAllAsRead();
}

class DeleteNotification extends NotificationsEvent {
  final String notificationId;
  const DeleteNotification(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}

class ClearAllNotifications extends NotificationsEvent {
  const ClearAllNotifications();
}

class GenerateSystemNotifications extends NotificationsEvent {
  const GenerateSystemNotifications();
}
