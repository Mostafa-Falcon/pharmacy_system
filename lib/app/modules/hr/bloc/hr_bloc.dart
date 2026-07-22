import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/reusables/feedback/app_snackbar.dart';
import 'package:pharmacy_system/app/modules/hr/models/employee_model.dart';
import 'package:pharmacy_system/app/modules/hr/models/attendance_model.dart';
import 'package:pharmacy_system/app/modules/hr/models/leave_model.dart';
import 'package:pharmacy_system/app/modules/hr/models/payroll_model.dart';
import 'package:pharmacy_system/app/modules/hr/models/department_model.dart';
import '../services/employee_service.dart';
import '../services/attendance_service.dart';
import '../services/leave_service.dart';
import '../services/payroll_service.dart';
import '../services/department_service.dart';

part 'hr_event.dart';
part 'hr_state.dart';

class HrBloc extends Bloc<HrEvent, HrState> {
  HrBloc() : super(const HrState()) {
    on<LoadHrData>(_onLoad);
    on<AddEmployee>(_onAddEmployee);
    on<UpdateEmployee>(_onUpdateEmployee);
    on<DeleteEmployee>(_onDeleteEmployee);
    on<SelectEmployee>(_onSelectEmployee);
    on<ClockIn>(_onClockIn);
    on<ClockOut>(_onClockOut);
    on<ApproveAttendance>(_onApproveAttendance);
    on<RejectAttendance>(_onRejectAttendance);
    on<RequestLeave>(_onRequestLeave);
    on<ApproveLeave>(_onApproveLeave);
    on<RejectLeave>(_onRejectLeave);
    on<CreatePayroll>(_onCreatePayroll);
    on<ProcessPayroll>(_onProcessPayroll);
    on<ApprovePayroll>(_onApprovePayroll);
    on<SelectPayroll>(_onSelectPayroll);
    on<AddDepartment>(_onAddDepartment);
    on<UpdateDepartment>(_onUpdateDepartment);
    on<DeleteDepartment>(_onDeleteDepartment);
    on<SelectDepartment>(_onSelectDepartment);
    add(const LoadHrData());
  }

  String get _branchId => AuthService.currentBranchId ?? '';
  String get _userId => AuthService.currentUser?.id ?? '';

  Future<void> _onLoad(LoadHrData event, Emitter<HrState> emit) async {
    emit(state.copyWith(status: HrStatus.loading, clearError: true));
    try {
      final employees = await EmployeeService.getAll(branchId: _branchId);
      final attendance = await AttendanceService.getAll(branchId: _branchId);
      final leave = await LeaveService.getAll();
      final payroll = await PayrollService.getAll(branchId: _branchId);
      final departments = await DepartmentService.getAll();
      emit(state.copyWith(
        status: HrStatus.loaded,
        employees: employees,
        attendanceRecords: attendance,
        leaveRecords: leave,
        payrollRecords: payroll,
        departments: departments,
      ));
    } catch (e) {
      emit(state.copyWith(status: HrStatus.error, error: e.toString()));
    }
  }

  Future<void> _onAddEmployee(AddEmployee event, Emitter<HrState> emit) async {
    await EmployeeService.create(
      name: event.name,
      phone: event.phone,
      email: event.email,
      departmentId: event.departmentId,
      departmentName: event.departmentName,
      jobTitle: event.jobTitle,
      salary: event.salary,
      notes: event.notes,
    );
    if (event.departmentId.isNotEmpty) {
      await DepartmentService.incrementEmployeeCount(event.departmentId);
    }
    AppSnackbar.success('تم إضافة الموظف بنجاح');
    add(const LoadHrData());
  }

  Future<void> _onUpdateEmployee(UpdateEmployee event, Emitter<HrState> emit) async {
    await EmployeeService.update(
      event.id,
      name: event.name,
      phone: event.phone,
      email: event.email,
      departmentId: event.departmentId,
      departmentName: event.departmentName,
      jobTitle: event.jobTitle,
      salary: event.salary,
      status: event.status,
      notes: event.notes,
    );
    AppSnackbar.success('تم تحديث بيانات الموظف');
    add(const LoadHrData());
  }

  Future<void> _onDeleteEmployee(DeleteEmployee event, Emitter<HrState> emit) async {
    final emp = await EmployeeService.getById(event.id);
    await EmployeeService.delete(event.id);
    if (emp != null && emp.departmentId.isNotEmpty) {
      await DepartmentService.decrementEmployeeCount(emp.departmentId);
    }
    AppSnackbar.success('تم حذف الموظف');
    add(const LoadHrData());
  }

  Future<void> _onSelectEmployee(SelectEmployee event, Emitter<HrState> emit) async {
    final emp = await EmployeeService.getById(event.id);
    emit(state.copyWith(
      selectedEmployee: emp,
      clearSelectedEmployee: event.id.isEmpty,
    ));
  }

  Future<void> _onClockIn(ClockIn event, Emitter<HrState> emit) async {
    await AttendanceService.clockIn(
      employeeId: event.employeeId,
      employeeName: event.employeeName,
      notes: event.notes,
    );
    AppSnackbar.success('تم تسجيل الحضور');
    add(const LoadHrData());
  }

  Future<void> _onClockOut(ClockOut event, Emitter<HrState> emit) async {
    await AttendanceService.clockOut(event.id, notes: event.notes);
    AppSnackbar.success('تم تسجيل الانصراف');
    add(const LoadHrData());
  }

  Future<void> _onApproveAttendance(ApproveAttendance event, Emitter<HrState> emit) async {
    await AttendanceService.approve(event.id, _userId);
    add(const LoadHrData());
  }

  Future<void> _onRejectAttendance(RejectAttendance event, Emitter<HrState> emit) async {
    await AttendanceService.reject(event.id, reason: event.reason);
    add(const LoadHrData());
  }

  Future<void> _onRequestLeave(RequestLeave event, Emitter<HrState> emit) async {
    await LeaveService.create(
      employeeId: event.employeeId,
      employeeName: event.employeeName,
      leaveType: event.leaveType,
      startDate: event.startDate,
      endDate: event.endDate,
      reason: event.reason,
    );
    AppSnackbar.success('تم تقديم طلب الإجازة');
    add(const LoadHrData());
  }

  Future<void> _onApproveLeave(ApproveLeave event, Emitter<HrState> emit) async {
    await LeaveService.approve(event.id, _userId);
    AppSnackbar.success('تم الموافقة على الإجازة');
    add(const LoadHrData());
  }

  Future<void> _onRejectLeave(RejectLeave event, Emitter<HrState> emit) async {
    await LeaveService.reject(event.id, reason: event.reason);
    AppSnackbar.success('تم رفض الإجازة');
    add(const LoadHrData());
  }

  Future<void> _onCreatePayroll(CreatePayroll event, Emitter<HrState> emit) async {
    await PayrollService.create(month: event.month, year: event.year);
    AppSnackbar.success('تم إنشاء كشف الراتب');
    add(const LoadHrData());
  }

  Future<void> _onProcessPayroll(ProcessPayroll event, Emitter<HrState> emit) async {
    await PayrollService.process(event.id);
    AppSnackbar.success('تم تجهيز كشف الراتب');
    add(const LoadHrData());
  }

  Future<void> _onApprovePayroll(ApprovePayroll event, Emitter<HrState> emit) async {
    await PayrollService.approve(event.id);
    AppSnackbar.success('تم اعتماد كشف الراتب');
    add(const LoadHrData());
  }

  Future<void> _onSelectPayroll(SelectPayroll event, Emitter<HrState> emit) async {
    final payroll = await PayrollService.getById(event.id);
    emit(state.copyWith(
      selectedPayroll: payroll,
      clearSelectedPayroll: event.id.isEmpty,
    ));
  }

  Future<void> _onAddDepartment(AddDepartment event, Emitter<HrState> emit) async {
    await DepartmentService.create(
      name: event.name,
      managerId: event.managerId,
      managerName: event.managerName,
      description: event.description,
    );
    AppSnackbar.success('تم إضافة الإدارة بنجاح');
    add(const LoadHrData());
  }

  Future<void> _onUpdateDepartment(UpdateDepartment event, Emitter<HrState> emit) async {
    await DepartmentService.update(
      event.id,
      name: event.name,
      managerId: event.managerId,
      managerName: event.managerName,
      description: event.description,
    );
    AppSnackbar.success('تم تحديث الإدارة');
    add(const LoadHrData());
  }

  Future<void> _onDeleteDepartment(DeleteDepartment event, Emitter<HrState> emit) async {
    await DepartmentService.delete(event.id);
    AppSnackbar.success('تم حذف الإدارة');
    add(const LoadHrData());
  }

  Future<void> _onSelectDepartment(SelectDepartment event, Emitter<HrState> emit) async {
    final dept = await DepartmentService.getById(event.id);
    emit(state.copyWith(
      selectedDepartment: dept,
      clearSelectedDepartment: event.id.isEmpty,
    ));
  }
}

