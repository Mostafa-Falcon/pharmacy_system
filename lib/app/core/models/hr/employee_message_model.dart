/// ✉️ موديل رسائل وتوجيهات الموظفين الداخليّة (Employee Message Model)
class EmployeeMessageModel {
  // 🆔 المعرف الفريد للرسالة (Primary Key)
  final String id;

  // 🏷️ عنوان الرسالة / التعميم (مثل: تعليمات شفت الجرد / تغيير مواعيد العمل)
  final String title;

  // 📝 نص ومحتوى الرسالة
  final String content;

  // 👤 اسم/معرف الراسل (مثل: د. مصطفى - المدير)
  final String senderName;

  // 👥 قائمة معرفات الموظفين المستهدفين بالرسالة (فارغة = تعميم للكل)
  final List<String>? recipientEmployeeIds;

  // 🟢 هل الرسالة تعميم عام لكل موظفي الصيدلية؟
  final bool isBroadcast;

  // 👁️ قائمة معرفات الموظفين الذين قرؤوا الرسالة
  final List<String> readByEmployeeIds;

  // 🏢 معرف الحساب الرئيسي / المؤسسة
  final String? accountId;

  // 🏬 معرف الفرع
  final String? branchId;

  // 🕒 تاريخ ووقت إرسال الرسالة
  final DateTime sentAt;

  EmployeeMessageModel({
    required this.id,
    required this.title,
    required this.content,
    required this.senderName,
    this.recipientEmployeeIds,
    this.isBroadcast = true,
    List<String>? readByEmployeeIds,
    this.accountId,
    this.branchId,
    DateTime? sentAt,
  })  : readByEmployeeIds = readByEmployeeIds ?? [],
        sentAt = sentAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'sender_name': senderName,
    'recipient_employee_ids': recipientEmployeeIds,
    'is_broadcast': isBroadcast,
    'read_by_employee_ids': readByEmployeeIds,
    'account_id': accountId,
    'branch_id': branchId,
    'sent_at': sentAt.toIso8601String(),
  };

  EmployeeMessageModel copyWith({
    String? id,
    String? title,
    String? content,
    String? senderName,
    List<String>? recipientEmployeeIds,
    bool? isBroadcast,
    List<String>? readByEmployeeIds,
    String? accountId,
    String? branchId,
    DateTime? sentAt,
  }) {
    return EmployeeMessageModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      senderName: senderName ?? this.senderName,
      recipientEmployeeIds: recipientEmployeeIds ?? this.recipientEmployeeIds,
      isBroadcast: isBroadcast ?? this.isBroadcast,
      readByEmployeeIds: readByEmployeeIds ?? this.readByEmployeeIds,
      accountId: accountId ?? this.accountId,
      branchId: branchId ?? this.branchId,
      sentAt: sentAt ?? this.sentAt,
    );
  }

  factory EmployeeMessageModel.fromJson(Map<String, dynamic> json) => EmployeeMessageModel(
    id: json['id'] as String,
    title: json['title'] as String,
    content: json['content'] as String,
    senderName: json['sender_name'] as String? ?? 'الإدارة',
    recipientEmployeeIds: (json['recipient_employee_ids'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
    isBroadcast: json['is_broadcast'] as bool? ?? true,
    readByEmployeeIds: (json['read_by_employee_ids'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    accountId: json['account_id'] as String?,
    branchId: json['branch_id'] as String?,
    sentAt: DateTime.tryParse(json['sent_at'] as String? ?? '') ?? DateTime.now(),
  );
}


