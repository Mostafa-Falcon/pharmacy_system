import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:pharmacy_system/app/core/data/database/daos/payroll_dao.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import '../../../core/injection.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/core/data/services/sync/sync_service.dart';
import 'package:pharmacy_system/app/modules/hr/models/payroll_model.dart';
import 'package:pharmacy_system/app/modules/hr/models/employee_model.dart';
import 'employee_service.dart';

class PayrollService {
  static final PayrollDao _dao = sl<PayrollDao>();
  static List<PayrollTableData> _cached = [];
  static final List<PayrollLineModel> _lineCache = [];
  static bool _ready = false;

  static String get _currentBranchId => AuthService.currentBranchId ?? '';

  static Future<void> _ensureReady() async {
    if (!_ready) {
      _cached = await _dao.getAll();
      _ready = true;
    }
  }

  static Future<List<PayrollModel>> getAll({int? month, int? year, String? branchId}) async {
    await _ensureReady();
    final bid = branchId ?? _currentBranchId;
    var records = _cached
        .where((e) => !e.isDeleted)
        .where((e) => branchId == null || e.branchId == bid)
        .map(_toModel)
        .toList();
    if (month != null) {
      records = records.where((e) => e.month == month).toList();
    }
    if (year != null) {
      records = records.where((e) => e.year == year).toList();
    }
    records.sort((a, b) {
      final c = b.year.compareTo(a.year);
      if (c != 0) return c;
      return b.month.compareTo(a.month);
    });
    return records;
  }

  static Future<PayrollModel?> getById(String id) async {
    await _ensureReady();
    final data = _cached.where((e) => e.id == id).firstOrNull;
    if (data == null) return null;
    return _toModel(data);
  }

  static Future<String> create({
    required int month,
    required int year,
  }) async {
    await _ensureReady();
    final id = const Uuid().v4();
    final now = DateTime.now();
    final period = '$year-${month.toString().padLeft(2, '0')}';

    await _dao.upsert(PayrollTableCompanion(
      id: Value(id),
      employeeId: const Value(''),
      period: Value(period),
      payDate: Value(now),
      baseSalary: const Value(0),
      bonuses: const Value(0),
      deductions: const Value(0),
      netSalary: const Value(0),
      status: const Value('draft'),
      notes: const Value(null),
      branchId: Value(_currentBranchId),
      isDeleted: const Value(false),
      lastModified: Value(now),
    ));
    final saved = await _dao.getById(id);
    if (saved != null) _cached.add(saved);

    try {
      await SyncService.queueOperation(
        type: SyncOperationType.create,
        table: 'payroll',
        data: {
          'id': id,
          'month': month,
          'year': year,
          'branch_id': _currentBranchId,
        },
        branchId: _currentBranchId,
      );
    } catch (_) {}

    return id;
  }

  static Future<void> update(String id, {
    String? status,
    double? totalSalaries,
    double? totalAdjustments,
    double? netTotal,
    int? employeeCount,
  }) async {
    await _ensureReady();
    final existing = _cached.where((e) => e.id == id).firstOrNull;
    if (existing == null) return;
    final now = DateTime.now();

    await _dao.upsert(PayrollTableCompanion(
      id: Value(id),
      employeeId: Value(existing.employeeId),
      period: Value(existing.period),
      payDate: Value(existing.payDate),
      baseSalary: Value(totalSalaries ?? existing.baseSalary),
      bonuses: Value(totalAdjustments ?? existing.bonuses),
      deductions: Value(0),
      netSalary: Value(netTotal ?? existing.netSalary),
      status: Value(status ?? existing.status),
      notes: Value(existing.notes),
      branchId: Value(existing.branchId),
      isDeleted: Value(existing.isDeleted),
      lastModified: Value(now),
    ));
    final saved = await _dao.getById(id);
    if (saved != null) {
      final idx = _cached.indexWhere((e) => e.id == id);
      if (idx >= 0) _cached[idx] = saved;
    }

    try {
      await SyncService.queueOperation(
        type: SyncOperationType.update,
        table: 'payroll',
        data: {'id': id, 'status': status ?? existing.status},
        branchId: _currentBranchId,
      );
    } catch (_) {}
  }

  static Future<void> process(String id) async {
    final existing = await getById(id);
    if (existing == null) return;

    final employees = await EmployeeService.getActive();
    double totalSalaries = 0;
    double totalAdjustments = 0;

    for (final emp in employees) {
      final line = _calculatePayrollLine(id, emp);
      totalSalaries += line.baseSalary;
      totalAdjustments += (line.bonuses - line.deductions + line.overtime);
    }

    final netTotal = totalSalaries + totalAdjustments;
    await update(
      id,
      status: 'processing',
      totalSalaries: totalSalaries,
      totalAdjustments: totalAdjustments,
      netTotal: netTotal,
      employeeCount: employees.length,
    );

    final now = DateTime.now();
    await _dao.upsert(PayrollTableCompanion(
      id: Value(id),
      employeeId: const Value(''),
      period: Value('year-month'),
      payDate: Value(now),
      baseSalary: Value(totalSalaries),
      bonuses: Value(totalAdjustments),
      deductions: const Value(0),
      netSalary: Value(netTotal),
      status: const Value('processing'),
      notes: const Value(null),
      branchId: Value(_currentBranchId),
      isDeleted: const Value(false),
      lastModified: Value(now),
    ));
  }

  static PayrollLineModel _calculatePayrollLine(
      String payrollId, EmployeeModel emp) {
    final id = '${payrollId}_${emp.id}';
    final now = DateTime.now();
    return PayrollLineModel(
      id: id,
      payrollId: payrollId,
      employeeId: emp.id,
      employeeName: emp.name,
      baseSalary: emp.salary,
      workingDays: 26,
      absentDays: 0,
      overtime: 0,
      bonuses: 0,
      deductions: 0,
      netSalary: emp.salary,
      createdAt: now,
      updatedAt: now,
    );
  }

  static Future<void> addLine(PayrollLineModel line) async {
    _lineCache.add(line);
    await _recalculatePayroll(line.payrollId);
  }

  static List<PayrollLineModel> getLines(String payrollId) {
    return _lineCache.where((e) => e.payrollId == payrollId).toList();
  }

  static Future<void> _recalculatePayroll(String payrollId) async {
    final lines = getLines(payrollId);
    final totalSalaries =
        lines.fold<double>(0, (sum, l) => sum + l.baseSalary);
    final totalAdjustments = lines.fold<double>(
        0, (sum, l) => sum + (l.bonuses - l.deductions + l.overtime));
    final netTotal = lines.fold<double>(0, (sum, l) => sum + l.netSalary);

    await update(
      payrollId,
      totalSalaries: totalSalaries,
      totalAdjustments: totalAdjustments,
      netTotal: netTotal,
      employeeCount: lines.length,
    );
  }

  static Future<void> approve(String id) async {
    final now = DateTime.now();
    await update(id, status: 'approved');
    final existing = await getById(id);
    if (existing == null) return;

    await _dao.upsert(PayrollTableCompanion(
      id: Value(id),
      employeeId: const Value(''),
      period: const Value(''),
      payDate: Value(now),
      baseSalary: const Value(0),
      bonuses: const Value(0),
      deductions: const Value(0),
      netSalary: const Value(0),
      status: const Value('approved'),
      notes: const Value(null),
      branchId: Value(_currentBranchId),
      isDeleted: const Value(false),
      lastModified: Value(now),
    ));
  }

  static Future<void> markPaid(String id) async {
    await update(id, status: 'paid');
  }

  static Future<void> delete(String id) async {
    await _ensureReady();
    await _dao.softDelete(id);
    _cached.removeWhere((e) => e.id == id);
    _lineCache.removeWhere((e) => e.payrollId == id);

    try {
      await SyncService.queueOperation(
        type: SyncOperationType.delete,
        table: 'payroll',
        data: {'id': id, 'is_deleted': true},
        branchId: _currentBranchId,
      );
    } catch (_) {}
  }

  static Future<PayrollModel?> getCurrentPeriod() async {
    final now = DateTime.now();
    final records = await getAll(month: now.month, year: now.year);
    return records.isNotEmpty ? records.first : null;
  }

  static PayrollModel _toModel(PayrollTableData d) {
    // Parse period string "YYYY-MM" back to month/year
    int month = 1;
    int year = DateTime.now().year;
    final parts = d.period.split('-');
    if (parts.length == 2) {
      year = int.tryParse(parts[0]) ?? year;
      month = int.tryParse(parts[1]) ?? month;
    }

    return PayrollModel(
      id: d.id,
      month: month,
      year: year,
      branchId: d.branchId,
      status: d.status,
      totalSalaries: d.baseSalary,
      totalAdjustments: d.bonuses,
      netTotal: d.netSalary,
      employeeCount: 0,
      processedAt: null,
      approvedAt: null,
      approvedBy: null,
      createdAt: d.lastModified,
      updatedAt: d.lastModified,
    );
  }
}

