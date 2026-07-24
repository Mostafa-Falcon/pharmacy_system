part of 'employees_bloc.dart';

sealed class EmployeesEvent extends Equatable {
  const EmployeesEvent();

  @override
  List<Object?> get props => [];
}

final class LoadEmployees extends EmployeesEvent {
  const LoadEmployees();
}

final class AddEmployee extends EmployeesEvent {
  final String name;
  final String email;
  final String password;
  final String? assignedBranchId;

  const AddEmployee({
    required this.name,
    required this.email,
    required this.password,
    this.assignedBranchId,
  });

  @override
  List<Object?> get props => [name, email, password, assignedBranchId];
}

final class UpdateEmployee extends EmployeesEvent {
  final String id;
  final String? name;
  final String? email;

  const UpdateEmployee({required this.id, this.name, this.email});

  @override
  List<Object?> get props => [id, name, email];
}

final class DeleteEmployee extends EmployeesEvent {
  final String id;

  const DeleteEmployee({required this.id});

  @override
  List<Object?> get props => [id];
}

final class SelectEmployee extends EmployeesEvent {
  final String id;

  const SelectEmployee({required this.id});

  @override
  List<Object?> get props => [id];
}

final class LoadEmployeePermissions extends EmployeesEvent {
  final String userId;
  const LoadEmployeePermissions(this.userId);

  @override
  List<Object?> get props => [userId];
}


