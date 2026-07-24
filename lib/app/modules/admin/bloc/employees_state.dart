part of 'employees_bloc.dart';

enum EmployeesStatus { initial, loading, loaded, error }

final class EmployeesState extends Equatable {
  final EmployeesStatus status;
  final List<UserModel> employees;
  final UserModel? selectedEmployee;
  final List<String> selectedEmployeePermissions;
  final String? error;

  const EmployeesState({
    this.status = EmployeesStatus.initial,
    this.employees = const [],
    this.selectedEmployee,
    this.selectedEmployeePermissions = const [],
    this.error,
  });

  EmployeesState copyWith({
    EmployeesStatus? status,
    List<UserModel>? employees,
    UserModel? selectedEmployee,
    List<String>? selectedEmployeePermissions,
    String? error,
    bool clearError = false,
  }) {
    return EmployeesState(
      status: status ?? this.status,
      employees: employees ?? this.employees,
      selectedEmployee: selectedEmployee ?? this.selectedEmployee,
      selectedEmployeePermissions: selectedEmployeePermissions ?? this.selectedEmployeePermissions,
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [status, employees, selectedEmployee, selectedEmployeePermissions, error];
}


