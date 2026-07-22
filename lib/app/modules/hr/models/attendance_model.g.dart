// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AttendanceModel _$AttendanceModelFromJson(Map<String, dynamic> json) =>
    _AttendanceModel(
      id: json['id'] as String,
      employeeId: json['employee_id'] as String,
      employeeName: json['employee_name'] as String? ?? '',
      branchId: json['branch_id'] as String? ?? '',
      clockIn: json['clock_in'] as String? ?? '',
      clockOut: json['clock_out'] as String?,
      date: json['date'] as String,
      status: json['status'] as String? ?? 'present',
      approvedBy: json['approved_by'] as String?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$AttendanceModelToJson(_AttendanceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'employee_id': instance.employeeId,
      'employee_name': instance.employeeName,
      'branch_id': instance.branchId,
      'clock_in': instance.clockIn,
      'clock_out': instance.clockOut,
      'date': instance.date,
      'status': instance.status,
      'approved_by': instance.approvedBy,
      'notes': instance.notes,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

_AttendanceReport _$AttendanceReportFromJson(Map<String, dynamic> json) =>
    _AttendanceReport(
      month: json['month'] as String,
      year: (json['year'] as num).toInt(),
      totalEmployees: (json['total_employees'] as num?)?.toInt() ?? 0,
      totalWorkingDays: (json['total_working_days'] as num?)?.toInt() ?? 0,
      summary: json['summary'] == null
          ? const AttendanceSummary()
          : AttendanceSummary.fromJson(json['summary'] as Map<String, dynamic>),
      records:
          (json['records'] as List<dynamic>?)
              ?.map((e) => AttendanceModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$AttendanceReportToJson(_AttendanceReport instance) =>
    <String, dynamic>{
      'month': instance.month,
      'year': instance.year,
      'total_employees': instance.totalEmployees,
      'total_working_days': instance.totalWorkingDays,
      'summary': instance.summary,
      'records': instance.records,
    };

_AttendanceSummary _$AttendanceSummaryFromJson(Map<String, dynamic> json) =>
    _AttendanceSummary(
      present: (json['present'] as num?)?.toInt() ?? 0,
      late: (json['late'] as num?)?.toInt() ?? 0,
      absent: (json['absent'] as num?)?.toInt() ?? 0,
      halfDay: (json['half_day'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$AttendanceSummaryToJson(_AttendanceSummary instance) =>
    <String, dynamic>{
      'present': instance.present,
      'late': instance.late,
      'absent': instance.absent,
      'half_day': instance.halfDay,
    };
