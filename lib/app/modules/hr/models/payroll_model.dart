// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'payroll_model.freezed.dart';
part 'payroll_model.g.dart';

@freezed
abstract class PayrollModel with _$PayrollModel {
  const PayrollModel._();

  const factory PayrollModel({
    required String id,
    required int month,
    required int year,
    @Default('') @JsonKey(name: 'branch_id') String branchId,
    @Default('draft') String status,
    @Default(0) @JsonKey(name: 'total_salaries') double totalSalaries,
    @Default(0) @JsonKey(name: 'total_adjustments') double totalAdjustments,
    @Default(0) @JsonKey(name: 'net_total') double netTotal,
    @Default(0) @JsonKey(name: 'employee_count') int employeeCount,
    @JsonKey(name: 'processed_at') String? processedAt,
    @JsonKey(name: 'approved_at') String? approvedAt,
    @JsonKey(name: 'approved_by') String? approvedBy,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _PayrollModel;

  factory PayrollModel.fromJson(Map<String, dynamic> json) =>
      _$PayrollModelFromJson(json);
}

@freezed
abstract class PayrollLineModel with _$PayrollLineModel {
  const PayrollLineModel._();

  const factory PayrollLineModel({
    required String id,
    @JsonKey(name: 'payroll_id') required String payrollId,
    @JsonKey(name: 'employee_id') required String employeeId,
    @Default('') @JsonKey(name: 'employee_name') String employeeName,
    @Default(0) @JsonKey(name: 'base_salary') double baseSalary,
    @Default(0) @JsonKey(name: 'working_days') int workingDays,
    @Default(0) @JsonKey(name: 'absent_days') int absentDays,
    @Default(0) double overtime,
    @Default(0) double bonuses,
    @Default(0) double deductions,
    @Default(0) @JsonKey(name: 'net_salary') double netSalary,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _PayrollLineModel;

  factory PayrollLineModel.fromJson(Map<String, dynamic> json) =>
      _$PayrollLineModelFromJson(json);
}
