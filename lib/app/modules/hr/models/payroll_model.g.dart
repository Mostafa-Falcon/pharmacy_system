// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payroll_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PayrollModel _$PayrollModelFromJson(Map<String, dynamic> json) =>
    _PayrollModel(
      id: json['id'] as String,
      month: (json['month'] as num).toInt(),
      year: (json['year'] as num).toInt(),
      branchId: json['branch_id'] as String? ?? '',
      status: json['status'] as String? ?? 'draft',
      totalSalaries: (json['total_salaries'] as num?)?.toDouble() ?? 0,
      totalAdjustments: (json['total_adjustments'] as num?)?.toDouble() ?? 0,
      netTotal: (json['net_total'] as num?)?.toDouble() ?? 0,
      employeeCount: (json['employee_count'] as num?)?.toInt() ?? 0,
      processedAt: json['processed_at'] as String?,
      approvedAt: json['approved_at'] as String?,
      approvedBy: json['approved_by'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$PayrollModelToJson(_PayrollModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'month': instance.month,
      'year': instance.year,
      'branch_id': instance.branchId,
      'status': instance.status,
      'total_salaries': instance.totalSalaries,
      'total_adjustments': instance.totalAdjustments,
      'net_total': instance.netTotal,
      'employee_count': instance.employeeCount,
      'processed_at': instance.processedAt,
      'approved_at': instance.approvedAt,
      'approved_by': instance.approvedBy,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

_PayrollLineModel _$PayrollLineModelFromJson(Map<String, dynamic> json) =>
    _PayrollLineModel(
      id: json['id'] as String,
      payrollId: json['payroll_id'] as String,
      employeeId: json['employee_id'] as String,
      employeeName: json['employee_name'] as String? ?? '',
      baseSalary: (json['base_salary'] as num?)?.toDouble() ?? 0,
      workingDays: (json['working_days'] as num?)?.toInt() ?? 0,
      absentDays: (json['absent_days'] as num?)?.toInt() ?? 0,
      overtime: (json['overtime'] as num?)?.toDouble() ?? 0,
      bonuses: (json['bonuses'] as num?)?.toDouble() ?? 0,
      deductions: (json['deductions'] as num?)?.toDouble() ?? 0,
      netSalary: (json['net_salary'] as num?)?.toDouble() ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$PayrollLineModelToJson(_PayrollLineModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'payroll_id': instance.payrollId,
      'employee_id': instance.employeeId,
      'employee_name': instance.employeeName,
      'base_salary': instance.baseSalary,
      'working_days': instance.workingDays,
      'absent_days': instance.absentDays,
      'overtime': instance.overtime,
      'bonuses': instance.bonuses,
      'deductions': instance.deductions,
      'net_salary': instance.netSalary,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
