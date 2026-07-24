/// 🔔 نوع التنبيه/الإشعار في المنظومة
enum NotificationType {
  lowStock,      // تنبيه نواقص المخزون
  expiryWarning, // تنبيه قرب انتهاء صلاحية الأدوية
  newOrder,      // تنبيه إذن شحن أو طلب دليفري جديد
  systemAlert,   // تنبيه نظافي أو مالي
}

/// 🔔 موديل إشعارات وتنبيهات المنظومة (System Notification Model)
class AppNotificationModel {
  // 🆔 المعرف الفريد للإشعار (Primary Key)
  final String id;

  // 🏷️ عنوان الإشعار والتنبيه (مثل: تنبيه نقص صنف / تنبيه صلاحية)
  final String title;

  // 📝 نص وتفاصيل الإشعار (مثل: صنف باي الكوفان وصل الحد الأدنى للمخزون)
  final String message;

  // 🔔 نوع الإشعار (نواقص lowStock / صلاحيات expiryWarning / طلبات newOrder / نظام systemAlert)
  final NotificationType type;

  // 🔗 رابط أو مسار الانتقال المباشر للحدث (مثل: /inventory/medicines/123)
  final String? targetRoute;

  // 👁️ هل تم قراءة الإشعار من قبل المستخدم؟
  final bool isRead;

  // 🏢 معرف الحساب الرئيسي / المؤسسة
  final String? accountId;

  // 🏬 معرف الفرع المرتبط
  final String? branchId;

  // 🕒 تاريخ ووقت صدور الإشعار
  final DateTime createdAt;

  // ─── Backward Compatibility Getters ───
  DateTime get timestamp => createdAt;
  NotificationType get category => type;

  AppNotificationModel({
    required this.id,
    required this.title,
    required this.message,
    this.type = NotificationType.systemAlert,
    this.targetRoute,
    this.isRead = false,
    this.accountId,
    this.branchId,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  AppNotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    NotificationType? type,
    String? targetRoute,
    bool? isRead,
    String? accountId,
    String? branchId,
    DateTime? createdAt,
  }) {
    return AppNotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      targetRoute: targetRoute ?? this.targetRoute,
      isRead: isRead ?? this.isRead,
      accountId: accountId ?? this.accountId,
      branchId: branchId ?? this.branchId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'message': message,
    'type': type.name,
    'target_route': targetRoute,
    'is_read': isRead,
    'account_id': accountId,
    'branch_id': branchId,
    'created_at': createdAt.toIso8601String(),
  };

  factory AppNotificationModel.fromJson(Map<String, dynamic> json) => AppNotificationModel(
    id: json['id'] as String,
    title: json['title'] as String,
    message: json['message'] as String,
    type: json['type'] == 'lowStock'
        ? NotificationType.lowStock
        : json['type'] == 'expiryWarning'
            ? NotificationType.expiryWarning
            : json['type'] == 'newOrder'
                ? NotificationType.newOrder
                : NotificationType.systemAlert,
    targetRoute: json['target_route'] as String?,
    isRead: json['is_read'] as bool? ?? false,
    accountId: json['account_id'] as String?,
    branchId: json['branch_id'] as String?,
    createdAt: json['created_at'] != null
        ? DateTime.tryParse(json['created_at'] as String) ?? DateTime.now()
        : DateTime.now(),
  );
}

// ─── Backward Compatibility Typedefs ───
typedef AppNotification = AppNotificationModel;
typedef NotificationCategory = NotificationType;


