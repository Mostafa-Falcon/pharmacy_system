part of 'hr_bloc.dart';

abstract class HrEvent extends Equatable {
  const HrEvent();
  @override
  List<Object?> get props => [];
}

class LoadHrData extends HrEvent {
  const LoadHrData();
}

class AddEmployee extends HrEvent {
  final String name;
  final String phone;
  final String email;
  final String departmentId;
  final String departmentName;
  final String jobTitle;
  final double salary;
  final String? notes;
  const AddEmployee({
    required this.name,
    this.phone = '',
    this.email = '',
    this.departmentId = '',
    this.departmentName = '',
    this.jobTitle = '',
    this.salary = 0,
    this.notes,
  });
  @override
  List<Object?> get props => [name, phone, email, departmentId, departmentName, jobTitle, salary, notes];
}

class UpdateEmployee extends HrEvent {
  final String id;
  final String? name;
  final String? phone;
  final String? email;
  final String? departmentId;
  final String? departmentName;
  final String? jobTitle;
  final double? salary;
  final String? status;
  final String? notes;
  const UpdateEmployee({
    required this.id,
    this.name,
    this.phone,
    this.email,
    this.departmentId,
    this.departmentName,
    this.jobTitle,
    this.salary,
    this.status,
    this.notes,
  });
  @override
  List<Object?> get props => [id, name, phone, email, departmentId, departmentName, jobTitle, salary, status, notes];
}

class DeleteEmployee extends HrEvent {
  final String id;
  const DeleteEmployee(this.id);
  @override
  List<Object?> get props => [id];
}

class SelectEmployee extends HrEvent {
  final String id;
  const SelectEmployee(this.id);
  @override
  List<Object?> get props => [id];
}

class ClockIn extends HrEvent {
  final String employeeId;
  final String employeeName;
  final String? notes;
  const ClockIn({required this.employeeId, this.employeeName = '', this.notes});
  @override
  List<Object?> get props => [employeeId, employeeName, notes];
}

class ClockOut extends HrEvent {
  final String id;
  final String? notes;
  const ClockOut(this.id, {this.notes});
  @override
  List<Object?> get props => [id, notes];
}

class ApproveAttendance extends HrEvent {
  final String id;
  const ApproveAttendance(this.id);
  @override
  List<Object?> get props => [id];
}

class RejectAttendance extends HrEvent {
  final String id;
  final String? reason;
  const RejectAttendance(this.id, {this.reason});
  @override
  List<Object?> get props => [id, reason];
}

class RequestLeave extends HrEvent {
  final String employeeId;
  final String employeeName;
  final String leaveType;
  final String startDate;
  final String endDate;
  final String? reason;
  const RequestLeave({
    required this.employeeId,
    this.employeeName = '',
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    this.reason,
  });
  @override
  List<Object?> get props => [employeeId, employeeName, leaveType, startDate, endDate, reason];
}

class ApproveLeave extends HrEvent {
  final String id;
  const ApproveLeave(this.id);
  @override
  List<Object?> get props => [id];
}

class RejectLeave extends HrEvent {
  final String id;
  final String? reason;
  const RejectLeave(this.id, {this.reason});
  @override
  List<Object?> get props => [id, reason];
}

class CreatePayroll extends HrEvent {
  final int month;
  final int year;
  const CreatePayroll(this.month, this.year);
  @override
  List<Object?> get props => [month, year];
}

class ProcessPayroll extends HrEvent {
  final String id;
  const ProcessPayroll(this.id);
  @override
  List<Object?> get props => [id];
}

class ApprovePayroll extends HrEvent {
  final String id;
  const ApprovePayroll(this.id);
  @override
  List<Object?> get props => [id];
}

class SelectPayroll extends HrEvent {
  final String id;
  const SelectPayroll(this.id);
  @override
  List<Object?> get props => [id];
}

class AddDepartment extends HrEvent {
  final String name;
  final String? managerId;
  final String? managerName;
  final String? description;
  const AddDepartment({required this.name, this.managerId, this.managerName, this.description});
  @override
  List<Object?> get props => [name, managerId, managerName, description];
}

class UpdateDepartment extends HrEvent {
  final String id;
  final String? name;
  final String? managerId;
  final String? managerName;
  final String? description;
  const UpdateDepartment({required this.id, this.name, this.managerId, this.managerName, this.description});
  @override
  List<Object?> get props => [id, name, managerId, managerName, description];
}

class DeleteDepartment extends HrEvent {
  final String id;
  const DeleteDepartment(this.id);
  @override
  List<Object?> get props => [id];
}

class SelectDepartment extends HrEvent {
  final String id;
  const SelectDepartment(this.id);
  @override
  List<Object?> get props => [id];
}
