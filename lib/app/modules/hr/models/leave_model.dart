// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'leave_model.freezed.dart';
part 'leave_model.g.dart';

@freezed
abstract class LeaveModel with _$LeaveModel {
  const LeaveModel._();

  const factory LeaveModel({
    required String id,
    @JsonKey(name: 'employee_id') required String employeeId,
    @Default('') @JsonKey(name: 'employee_name') String employeeName,
    @JsonKey(name: 'leave_type') required String leaveType,
    @JsonKey(name: 'start_date') required String startDate,
    @JsonKey(name: 'end_date') required String endDate,
    @Default(1) int duration,
    @Default('pending') String status,
    String? reason,
    @JsonKey(name: 'approved_by') String? approvedBy,
    @JsonKey(name: 'rejection_reason') String? rejectionReason,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _LeaveModel;

  factory LeaveModel.fromJson(Map<String, dynamic> json) =>
      _$LeaveModelFromJson(json);
}

@freezed
abstract class LeaveBalance with _$LeaveBalance {
  const LeaveBalance._();

  const factory LeaveBalance({
    @Default(LeaveTypeBalance(total: 30)) LeaveTypeBalance sick,
    @Default(LeaveTypeBalance(total: 21)) LeaveTypeBalance annual,
    @Default(LeaveTypeBalance(total: 7)) LeaveTypeBalance emergency,
    @Default(LeaveTypeBalance(total: 30)) LeaveTypeBalance unpaid,
  }) = _LeaveBalance;

  factory LeaveBalance.fromJson(Map<String, dynamic> json) =>
      _$LeaveBalanceFromJson(json);
}

@freezed
abstract class LeaveTypeBalance with _$LeaveTypeBalance {
  const LeaveTypeBalance._();

  const factory LeaveTypeBalance({
    @Default(30) int total,
    @Default(0) int used,
    @Default(30) int remaining,
  }) = _LeaveTypeBalance;

  factory LeaveTypeBalance.fromJson(Map<String, dynamic> json) =>
      _$LeaveTypeBalanceFromJson(json);
}
