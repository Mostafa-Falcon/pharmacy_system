import 'dart:async';
import 'package:drift/drift.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pharmacy_system/app/core/models/system/app_notification_model.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/core/injection.dart';

sealed class NotificationsEvent extends Equatable {
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

class NotificationsState extends Equatable {
  final bool isLoading;
  final List<AppNotificationModel> notifications;
  final int unreadCount;
  final String? error;

  const NotificationsState({
    this.isLoading = false,
    this.notifications = const [],
    this.unreadCount = 0,
    this.error,
  });

  NotificationsState copyWith({
    bool? isLoading,
    List<AppNotificationModel>? notifications,
    int? unreadCount,
    String? error,
    bool clearError = false,
  }) {
    return NotificationsState(
      isLoading: isLoading ?? this.isLoading,
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [isLoading, notifications, unreadCount, error];
}

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  NotificationsBloc() : super(const NotificationsState()) {
    on<LoadNotifications>(_onLoad);
    on<MarkAsRead>(_onMarkAsRead);
  }

  Future<void> _onLoad(
    LoadNotifications event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final db = sl<AppDatabase>();
      final rows =
          await (db.select(db.notificationsTable)
                ..where((t) => t.isRead.equals(false))
                ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
              .get();
      final notifications = rows
          .map(
            (r) => AppNotificationModel(
              id: r.id,
              title: r.title,
              message: r.message,
              type: r.type,
              isRead: r.isRead,
              createdAt: r.createdAt,
            ),
          )
          .toList();
      final unread = notifications.where((n) => !n.isRead).length;
      emit(
        state.copyWith(
          isLoading: false,
          notifications: notifications,
          unreadCount: unread,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onMarkAsRead(
    MarkAsRead event,
    Emitter<NotificationsState> emit,
  ) async {
    try {
      final db = sl<AppDatabase>();
      await (db.update(db.notificationsTable)
            ..where((t) => t.id.equals(event.notificationId)))
          .write(const NotificationsTableCompanion(isRead: Value(true)));
      add(const LoadNotifications());
    } catch (_) {}
  }
}
