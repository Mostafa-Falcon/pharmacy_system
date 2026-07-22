// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'employee_model.freezed.dart';
part 'employee_model.g.dart';

@freezed
abstract class EmployeeModel with _$EmployeeModel {
  const EmployeeModel._();

  const factory EmployeeModel({
    required String id,
    required String name,
    @Default('') String phone,
    @Default('') String email,
    @Default('') @JsonKey(name: 'department_id') String departmentId,
    @Default('') @JsonKey(name: 'department_name') String departmentName,
    @Default('') @JsonKey(name: 'job_title') String jobTitle,
    @Default(0) double salary,
    @Default('active') String status,
    @Default('') @JsonKey(name: 'branch_id') String branchId,
    @Default('') @JsonKey(name: 'created_by_id') String createdById,
    @JsonKey(name: 'created_by_name') String? createdByName,
    String? notes,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _EmployeeModel;

  factory EmployeeModel.fromJson(Map<String, dynamic> json) =>
      _$EmployeeModelFromJson(json);
}
