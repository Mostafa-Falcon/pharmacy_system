import 'dart:async';
import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:pharmacy_system/app/core/data/database/daos/notifications_dao.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/modules/notifications/models/app_notification_model.dart';
import '../../../core/constants/app_strings.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/core/data/services/admin/branch_data_service.dart';
import 'notifications_event.dart';
import 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  NotificationsBloc() : super(const NotificationsState()) {
    on<LoadNotifications>(_onLoad);
    on<MarkAsRead>(_onMarkAsRead);
    on<MarkAllAsRead>(_onMarkAllAsRead);
    on<DeleteNotification>(_onDelete);
    on<ClearAllNotifications>(_onClearAll);
    on<GenerateSystemNotifications>(_onGenerateSystem);

    add(const LoadNotifications());
  }

  static NotificationsDao get _dao =>
      NotificationsDao(GetIt.instance<AppDatabase>());

  static AppNotification _fromData(NotificationsTableData d) {
    return AppNotification(
      id: d.id,
      title: d.title,
      message: d.message,
      timestamp: d.timestamp,
      category: _parseCategory(d.category),
      priority: _parsePriority(d.priority),
      isRead: d.isRead,
      metadata: d.metadata != null && d.metadata!.isNotEmpty
          ? Map<String, dynamic>.from(jsonDecode(d.metadata!))
          : null,
      actionRoute: d.actionRoute,
    );
  }

  static NotificationsTableCompanion _toCompanion(AppNotification n) {
    return NotificationsTableCompanion(
      id: Value(n.id),
      title: Value(n.title),
      message: Value(n.message),
      timestamp: Value(n.timestamp),
      category: Value(n.category.name),
      priority: Value(n.priority.name),
      isRead: Value(n.isRead),
      metadata: Value(n.metadata != null ? jsonEncode(n.metadata) : null),
      actionRoute: Value(n.actionRoute),
      branchId: Value(AuthService.currentBranchId),
    );
  }

  static NotificationCategory _parseCategory(String value) {
    return NotificationCategory.values.firstWhere(
      (e) => e.name == value,
      orElse: () => NotificationCategory.system,
    );
  }

  static NotificationPriority _parsePriority(String value) {
    return NotificationPriority.values.firstWhere(
      (e) => e.name == value,
      orElse: () => NotificationPriority.medium,
    );
  }

  Future<void> _onLoad(
      LoadNotifications event, Emitter<NotificationsState> emit) async {
    emit(state.copyWith(status: NotificationsStatus.loading));
    final saved = (await _dao.getAll()).map(_fromData).toList();
    emit(state.copyWith(
      status: NotificationsStatus.loaded,
      notifications: saved,
    ));
    add(const GenerateSystemNotifications());
  }

  Future<void> _onMarkAsRead(
      MarkAsRead event, Emitter<NotificationsState> emit) async {
    final updated = state.notifications.map((n) {
      if (n.id == event.notificationId) {
        return n.copyWith(isRead: true);
      }
      return n;
    }).toList();
    emit(state.copyWith(notifications: updated));
    await _dao.markAsRead(event.notificationId);
  }

  Future<void> _onMarkAllAsRead(
      MarkAllAsRead event, Emitter<NotificationsState> emit) async {
    final updated =
        state.notifications.map((n) => n.copyWith(isRead: true)).toList();
    emit(state.copyWith(notifications: updated));
    for (final n in updated) {
      await _dao.markAsRead(n.id);
    }
  }

  Future<void> _onDelete(
      DeleteNotification event, Emitter<NotificationsState> emit) async {
    final updated = state.notifications
        .where((n) => n.id != event.notificationId)
        .toList();
    emit(state.copyWith(notifications: updated));
    await _dao.softDelete(event.notificationId);
  }

  Future<void> _onClearAll(
      ClearAllNotifications event, Emitter<NotificationsState> emit) async {
    emit(state.copyWith(notifications: const []));
    final all = await _dao.getAll();
    for (final n in all) {
      await _dao.softDelete(n.id);
    }
  }

  Future<void> _onGenerateSystem(GenerateSystemNotifications event,
      Emitter<NotificationsState> emit) async {
    final branchId = AuthService.currentBranchId ?? '';
    final allMedicines = BranchDataService.getMedicines(branchId: branchId);
    final now = DateTime.now();

    final List<AppNotification> systemNotifications = [];

    final expired =
        allMedicines.where((m) =>
            m.expiryDate != null && m.expiryDate!.isBefore(now));
    for (final m in expired) {
      systemNotifications.add(AppNotification(
        id: 'expired_${m.id}',
        title: NotificationsStrings.expiryTitle,
        message: NotificationsStrings.expiryMessageFormat
            .replaceFirst('%s', m.name)
            .replaceFirst('%s', m.expiryDate!.toString().split(' ')[0]),
        timestamp: m.expiryDate!,
        category: NotificationCategory.expiry,
        priority: NotificationPriority.critical,
        actionRoute: '/admin/inventory/edit/${m.id}',
        metadata: {'medicineId': m.id},
      ));
    }

    final nearExpiry = allMedicines.where((m) =>
        m.expiryDate != null &&
        !m.expiryDate!.isBefore(now) &&
        m.expiryDate!.difference(now).inDays <= 60);
    for (final m in nearExpiry) {
      final days = m.expiryDate!.difference(now).inDays;
      systemNotifications.add(AppNotification(
        id: 'near_expiry_${m.id}',
        title: NotificationsStrings.nearExpiryTitle,
        message: NotificationsStrings.nearExpiryMessageFormat
            .replaceFirst('%s', m.name)
            .replaceFirst('%s', days.toString()),
        timestamp: now,
        category: NotificationCategory.expiry,
        priority: NotificationPriority.high,
        actionRoute: '/admin/inventory/edit/${m.id}',
        metadata: {'medicineId': m.id},
      ));
    }

    final lowStock =
        allMedicines.where((m) => m.quantity <= m.minStock);
    for (final m in lowStock) {
      systemNotifications.add(AppNotification(
        id: 'low_stock_${m.id}',
        title: NotificationsStrings.lowStockTitle,
        message: NotificationsStrings.lowStockMessageFormat
            .replaceFirst('%s', m.name)
            .replaceFirst('%s', m.quantity.toString())
            .replaceFirst('%s', m.minStock.toString()),
        timestamp: now,
        category: NotificationCategory.stock,
        priority: NotificationPriority.medium,
        actionRoute: '/admin/inventory/edit/${m.id}',
        metadata: {'medicineId': m.id},
      ));
    }

    final existingIds = state.notifications.map((n) => n.id).toSet();
    final newOnes =
        systemNotifications.where((n) => !existingIds.contains(n.id)).toList();

    final all = [...state.notifications, ...newOnes]
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    emit(state.copyWith(
      status: NotificationsStatus.loaded,
      notifications: all,
    ));
    for (final n in newOnes) {
      await _dao.upsert(_toCompanion(n));
    }
  }
}




