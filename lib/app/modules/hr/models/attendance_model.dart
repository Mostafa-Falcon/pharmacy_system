// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'attendance_model.freezed.dart';
part 'attendance_model.g.dart';

@freezed
abstract class AttendanceModel with _$AttendanceModel {
  const AttendanceModel._();

  const factory AttendanceModel({
    required String id,
    @JsonKey(name: 'employee_id') required String employeeId,
    @Default('') @JsonKey(name: 'employee_name') String employeeName,
    @Default('') @JsonKey(name: 'branch_id') String branchId,
    @Default('') @JsonKey(name: 'clock_in') String clockIn,
    @JsonKey(name: 'clock_out') String? clockOut,
    required String date,
    @Default('present') String status,
    @JsonKey(name: 'approved_by') String? approvedBy,
    String? notes,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _AttendanceModel;

  factory AttendanceModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceModelFromJson(json);

  int get workedHours {
    if (clockIn.isEmpty || clockOut == null || clockOut!.isEmpty) return 0;
    final inTime = DateTime.tryParse(clockIn);
    final outTime = DateTime.tryParse(clockOut!);
    if (inTime == null || outTime == null) return 0;
    return (outTime.difference(inTime).inMinutes / 60).round();
  }
}

@freezed
abstract class AttendanceReport with _$AttendanceReport {
  const AttendanceReport._();

  const factory AttendanceReport({
    required String month,
    required int year,
    @Default(0) @JsonKey(name: 'total_employees') int totalEmployees,
    @Default(0) @JsonKey(name: 'total_working_days') int totalWorkingDays,
    @Default(AttendanceSummary()) AttendanceSummary summary,
    @Default([]) List<AttendanceModel> records,
  }) = _AttendanceReport;

  factory AttendanceReport.fromJson(Map<String, dynamic> json) =>
      _$AttendanceReportFromJson(json);
}

@freezed
abstract class AttendanceSummary with _$AttendanceSummary {
  const AttendanceSummary._();

  const factory AttendanceSummary({
    @Default(0) int present,
    @Default(0) int late,
    @Default(0) int absent,
    @Default(0) @JsonKey(name: 'half_day') int halfDay,
  }) = _AttendanceSummary;

  factory AttendanceSummary.fromJson(Map<String, dynamic> json) =>
      _$AttendanceSummaryFromJson(json);
}
