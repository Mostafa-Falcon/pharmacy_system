// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EmployeeModel _$EmployeeModelFromJson(Map<String, dynamic> json) =>
    _EmployeeModel(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String? ?? '',
      departmentId: json['department_id'] as String? ?? '',
      departmentName: json['department_name'] as String? ?? '',
      jobTitle: json['job_title'] as String? ?? '',
      salary: (json['salary'] as num?)?.toDouble() ?? 0,
      status: json['status'] as String? ?? 'active',
      branchId: json['branch_id'] as String? ?? '',
      createdById: json['created_by_id'] as String? ?? '',
      createdByName: json['created_by_name'] as String?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$EmployeeModelToJson(_EmployeeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'email': instance.email,
      'department_id': instance.departmentId,
      'department_name': instance.departmentName,
      'job_title': instance.jobTitle,
      'salary': instance.salary,
      'status': instance.status,
      'branch_id': instance.branchId,
      'created_by_id': instance.createdById,
      'created_by_name': instance.createdByName,
      'notes': instance.notes,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
