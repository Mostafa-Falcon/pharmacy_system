/// 🔍 موديل سجل المراقبة والتدقيق الفوري (Audit Log Model)
class AuditLogModel {
  // 🆔 المعرف الفريد لسجل التدقيق (Primary Key)
  final String id;

  // ⚡ شفرة ونوع الحركة المتمة (مثل: sale.created, price.updated, medicine.deleted)
  final String action;

  // 📦 نوع الكيان المتأثر (دواء، فاتورة، عميل، مورد...)
  final String entityType;

  // 🆔 المعرف الأصلي للكيان المتأثر
  final String entityId;

  // 👤 معرف المستخدم/الموظف الذي قام بالحركة
  final String actorId;

  // 👤 اسم المستخدم/الموظف الذي قام بالحركة (مثل: د. أحمد)
  final String? actorName;

  // 🏬 معرف الفرع
  final String? branchId;

  // 📝 ملخص التغييرات أو البيانات المالية السابقة والجديدة
  final Map<String, dynamic>? summary;

  // 📅 تاريخ ووقت وقوع الحركة بالثانية
  final DateTime occurredAt;

  AuditLogModel({
    required this.id,
    required this.action,
    required this.entityType,
    required this.entityId,
    required this.actorId,
    this.actorName,
    this.branchId,
    this.summary,
    DateTime? occurredAt,
  }) : occurredAt = occurredAt ?? DateTime.now();

  // 🗣️ تسمية الحركة باللغة العربية المباشرة للعرض في شاشات المراقبة
  String get actionLabelAr {
    switch (action) {
      case 'branch.saved':
        return 'حفظ/تعديل بيانات فرع';
      case 'member.saved':
        return 'إضافة/تعديل موظف';
      case 'role.saved':
        return 'تعديل صلاحيات';
      case 'sale.created':
        return 'إصدار فاتورة مبيعات';
      case 'sale.voided':
        return 'إلغاء فاتورة مبيعات';
      case 'purchase.created':
        return 'تسجيل فاتورة مشتريات';
      case 'return.created':
        return 'إجراء عملية مرتجع';
      case 'price.updated':
        return 'تعديل أسعار أصناف';
      default:
        return action;
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'action': action,
    'entity_type': entityType,
    'entity_id': entityId,
    'actor_id': actorId,
    'actor_name': actorName,
    'branch_id': branchId,
    'summary': summary,
    'occurred_at': occurredAt.toIso8601String(),
  };

  factory AuditLogModel.fromJson(Map<String, dynamic> json) => AuditLogModel(
    id: json['id'] as String,
    action: json['action'] as String,
    entityType: json['entity_type'] as String? ?? json['entityType'] as String? ?? '',
    entityId: json['entity_id'] as String? ?? json['entityId'] as String? ?? '',
    actorId: json['actor_id'] as String? ?? json['actorId'] as String? ?? '',
    actorName: json['actor_name'] as String? ?? json['actorName'] as String?,
    branchId: json['branch_id'] as String? ?? json['branchId'] as String?,
    summary: json['summary'] as Map<String, dynamic>?,
    occurredAt: DateTime.tryParse(json['occurred_at'] as String? ?? json['occurredAt'] as String? ?? '') ?? DateTime.now(),
  );
}


