// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leave_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LeaveModel _$LeaveModelFromJson(Map<String, dynamic> json) => _LeaveModel(
  id: json['id'] as String,
  employeeId: json['employee_id'] as String,
  employeeName: json['employee_name'] as String? ?? '',
  leaveType: json['leave_type'] as String,
  startDate: json['start_date'] as String,
  endDate: json['end_date'] as String,
  duration: (json['duration'] as num?)?.toInt() ?? 1,
  status: json['status'] as String? ?? 'pending',
  reason: json['reason'] as String?,
  approvedBy: json['approved_by'] as String?,
  rejectionReason: json['rejection_reason'] as String?,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$LeaveModelToJson(_LeaveModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'employee_id': instance.employeeId,
      'employee_name': instance.employeeName,
      'leave_type': instance.leaveType,
      'start_date': instance.startDate,
      'end_date': instance.endDate,
      'duration': instance.duration,
      'status': instance.status,
      'reason': instance.reason,
      'approved_by': instance.approvedBy,
      'rejection_reason': instance.rejectionReason,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

_LeaveBalance _$LeaveBalanceFromJson(Map<String, dynamic> json) =>
    _LeaveBalance(
      sick: json['sick'] == null
          ? const LeaveTypeBalance(total: 30)
          : LeaveTypeBalance.fromJson(json['sick'] as Map<String, dynamic>),
      annual: json['annual'] == null
          ? const LeaveTypeBalance(total: 21)
          : LeaveTypeBalance.fromJson(json['annual'] as Map<String, dynamic>),
      emergency: json['emergency'] == null
          ? const LeaveTypeBalance(total: 7)
          : LeaveTypeBalance.fromJson(
              json['emergency'] as Map<String, dynamic>,
            ),
      unpaid: json['unpaid'] == null
          ? const LeaveTypeBalance(total: 30)
          : LeaveTypeBalance.fromJson(json['unpaid'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LeaveBalanceToJson(_LeaveBalance instance) =>
    <String, dynamic>{
      'sick': instance.sick,
      'annual': instance.annual,
      'emergency': instance.emergency,
      'unpaid': instance.unpaid,
    };

_LeaveTypeBalance _$LeaveTypeBalanceFromJson(Map<String, dynamic> json) =>
    _LeaveTypeBalance(
      total: (json['total'] as num?)?.toInt() ?? 30,
      used: (json['used'] as num?)?.toInt() ?? 0,
      remaining: (json['remaining'] as num?)?.toInt() ?? 30,
    );

Map<String, dynamic> _$LeaveTypeBalanceToJson(_LeaveTypeBalance instance) =>
    <String, dynamic>{
      'total': instance.total,
      'used': instance.used,
      'remaining': instance.remaining,
    };
