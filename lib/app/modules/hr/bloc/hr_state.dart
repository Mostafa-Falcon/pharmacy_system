part of 'hr_bloc.dart';

enum HrStatus { initial, loading, loaded, error }

class HrState extends Equatable {
  final HrStatus status;
  final List<EmployeeModel> employees;
  final List<AttendanceModel> attendanceRecords;
  final List<LeaveModel> leaveRecords;
  final List<PayrollModel> payrollRecords;
  final List<DepartmentModel> departments;
  final EmployeeModel? selectedEmployee;
  final DepartmentModel? selectedDepartment;
  final PayrollModel? selectedPayroll;
  final String? error;

  const HrState({
    this.status = HrStatus.initial,
    this.employees = const [],
    this.attendanceRecords = const [],
    this.leaveRecords = const [],
    this.payrollRecords = const [],
    this.departments = const [],
    this.selectedEmployee,
    this.selectedDepartment,
    this.selectedPayroll,
    this.error,
  });

  List<EmployeeModel> get activeEmployees => employees.where((e) => e.status == 'active').toList();

  List<LeaveModel> get pendingLeaves => leaveRecords.where((l) => l.status == 'pending').toList();

  int get todayAttendanceCount {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    return attendanceRecords.where((a) => a.date == today).length;
  }

  PayrollModel? get currentPayroll {
    final now = DateTime.now();
    final current = payrollRecords.where((p) => p.month == now.month && p.year == now.year);
    return current.isNotEmpty ? current.first : null;
  }

  double get currentMonthSalaryTotal {
    final now = DateTime.now();
    return payrollRecords
        .where((p) => p.month == now.month && p.year == now.year)
        .fold<double>(0, (sum, p) => sum + p.totalSalaries);
  }

  HrState copyWith({
    HrStatus? status,
    List<EmployeeModel>? employees,
    List<AttendanceModel>? attendanceRecords,
    List<LeaveModel>? leaveRecords,
    List<PayrollModel>? payrollRecords,
    List<DepartmentModel>? departments,
    EmployeeModel? selectedEmployee,
    bool clearSelectedEmployee = false,
    DepartmentModel? selectedDepartment,
    bool clearSelectedDepartment = false,
    PayrollModel? selectedPayroll,
    bool clearSelectedPayroll = false,
    String? error,
    bool clearError = false,
  }) {
    return HrState(
      status: status ?? this.status,
      employees: employees ?? this.employees,
      attendanceRecords: attendanceRecords ?? this.attendanceRecords,
      leaveRecords: leaveRecords ?? this.leaveRecords,
      payrollRecords: payrollRecords ?? this.payrollRecords,
      departments: departments ?? this.departments,
      selectedEmployee: clearSelectedEmployee ? null : (selectedEmployee ?? this.selectedEmployee),
      selectedDepartment: clearSelectedDepartment ? null : (selectedDepartment ?? this.selectedDepartment),
      selectedPayroll: clearSelectedPayroll ? null : (selectedPayroll ?? this.selectedPayroll),
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [
        status,
        employees,
        attendanceRecords,
        leaveRecords,
        payrollRecords,
        departments,
        selectedEmployee,
        selectedDepartment,
        selectedPayroll,
        error,
      ];
}
