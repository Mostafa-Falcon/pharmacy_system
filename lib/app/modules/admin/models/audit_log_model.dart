import 'package:freezed_annotation/freezed_annotation.dart';

part 'audit_log_model.freezed.dart';
part 'audit_log_model.g.dart';

@freezed
abstract class AuditLogModel with _$AuditLogModel {
  const factory AuditLogModel({
    required String id,
    required String action,
    required String entityType,
    required String entityId,
    required String actorId,
    String? actorName,
    String? branchId,
    Map<String, dynamic>? summary,
    required DateTime occurredAt,
  }) = _AuditLogModel;

  const AuditLogModel._();

  factory AuditLogModel.fromJson(Map<String, dynamic> json) =>
      _$AuditLogModelFromJson(json);

  String get actionLabelAr {
    switch (action) {
      case 'branch.saved':
        return 'حفظ فرع';
      case 'member.saved':
        return 'حفظ مستخدم';
      case 'role.saved':
        return 'حفظ دور';
      case 'sale.created':
        return 'إنشاء فاتورة بيع';
      case 'sale.voided':
        return 'إلغاء فاتورة بيع';
      case 'purchase.created':
        return 'إنشاء فاتورة شراء';
      case 'return.created':
        return 'إنشاء مرتجع';
      default:
        return action;
    }
  }
}
