import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:pharmacy_system/app/core/models/hr/attendance_model.dart';
import 'package:pharmacy_system/app/core/models/hr/payroll_model.dart';
import 'package:pharmacy_system/app/core/models/hr/employee_message_model.dart';

import '../database/database.dart';

class HrMapper {
  static AttendanceModel attendanceFromData(AttendanceTableData d) => AttendanceModel(
    id: d.id,
    employeeId: d.employeeId,
    employeeName: d.employeeName,
    date: d.date,
    checkInTime: d.checkInTime,
    checkOutTime: d.checkOutTime,
    workHours: d.workHours,
    overtimeHours: d.overtimeHours,
    lateMinutes: d.lateMinutes,
    status: d.status,
    accountId: d.accountId,
    branchId: d.branchId,
    notes: d.notes,
  );

  static AttendanceTableCompanion attendanceToCompanion(AttendanceModel m) => AttendanceTableCompanion(
    id: Value(m.id),
    employeeId: Value(m.employeeId),
    employeeName: Value(m.employeeName),
    date: Value(m.date),
    checkInTime: Value(m.checkInTime),
    checkOutTime: Value(m.checkOutTime),
    workHours: Value(m.workHours),
    overtimeHours: Value(m.overtimeHours),
    lateMinutes: Value(m.lateMinutes),
    status: Value(m.status),
    accountId: Value(m.accountId),
    branchId: Value(m.branchId),
    notes: Value(m.notes),
    lastModified: const Value.absent(),
    isDeleted: const Value.absent(),
    syncVersion: const Value.absent(),
  );

  static PayrollModel payrollFromData(PayrollTableData d) => PayrollModel(
    id: d.id,
    employeeId: d.employeeId,
    employeeName: d.employeeName,
    monthYear: d.period,
    basicSalary: d.basicSalary,
    allowances: d.allowances,
    deductions: d.deductions,
    advances: d.advances,
    netSalary: d.netSalary,
    isPaid: d.isPaid,
    paidAt: d.paidAt,
    accountId: d.accountId,
    branchId: d.branchId,
    notes: d.notes,
  );

  static PayrollTableCompanion payrollToCompanion(PayrollModel m) => PayrollTableCompanion(
    id: Value(m.id),
    employeeId: Value(m.employeeId),
    employeeName: Value(m.employeeName),
    period: Value(m.monthYear),
    basicSalary: Value(m.basicSalary),
    allowances: Value(m.allowances),
    deductions: Value(m.deductions),
    advances: Value(m.advances),
    netSalary: Value(m.netSalary),
    isPaid: Value(m.isPaid),
    paidAt: Value(m.paidAt),
    accountId: Value(m.accountId),
    branchId: Value(m.branchId),
    notes: Value(m.notes),
    lastModified: const Value.absent(),
    isDeleted: const Value.absent(),
    syncVersion: const Value.absent(),
  );

  static EmployeeMessageModel employeeMessageFromData(EmployeeMessagesTableData d) => EmployeeMessageModel(
    id: d.id,
    title: d.title,
    content: d.content,
    senderName: d.senderName,
    recipientEmployeeIds: d.recipientEmployeeIds != null ? (jsonDecode(d.recipientEmployeeIds!) as List).cast<String>() : null,
    isBroadcast: d.isBroadcast,
    readByEmployeeIds: (jsonDecode(d.readByEmployeeIds) as List).cast<String>(),
    accountId: d.accountId,
    branchId: d.branchId,
    sentAt: d.sentAt,
  );

  static EmployeeMessagesTableCompanion employeeMessageToCompanion(EmployeeMessageModel m) => EmployeeMessagesTableCompanion(
    id: Value(m.id),
    title: Value(m.title),
    content: Value(m.content),
    senderName: Value(m.senderName),
    recipientEmployeeIds: Value(m.recipientEmployeeIds != null ? jsonEncode(m.recipientEmployeeIds) : null),
    isBroadcast: Value(m.isBroadcast),
    readByEmployeeIds: Value(jsonEncode(m.readByEmployeeIds)),
    accountId: Value(m.accountId),
    branchId: Value(m.branchId),
    sentAt: Value(m.sentAt),
    lastModified: const Value.absent(),
    isDeleted: const Value.absent(),
    syncVersion: const Value.absent(),
  );
}