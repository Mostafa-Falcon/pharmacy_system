import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:pharmacy_system/app/core/data/database/daos/leaves_dao.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import '../../../core/injection.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/core/sync/sync_service.dart';
import 'package:pharmacy_system/app/modules/hr/models/leave_model.dart';

class LeaveService {
  static final LeavesDao _dao = sl<LeavesDao>();
  static List<LeavesTableData> _cached = [];
  static bool _ready = false;

  static Future<void> _ensureReady() async {
    if (!_ready) {
      _cached = await _dao.getAll();
      _ready = true;
    }
  }

  static Future<List<LeaveModel>> getAll({String? status, String? employeeId}) async {
    await _ensureReady();
    var records = _cached
        .where((e) => !e.isDeleted)
        .map(_toModel)
        .toList();
    if (status != null) {
      records = records.where((e) => e.status == status).toList();
    }
    if (employeeId != null) {
      records = records.where((e) => e.employeeId == employeeId).toList();
    }
    records.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return records;
  }

  static Future<LeaveModel?> getById(String id) async {
    await _ensureReady();
    final data = _cached.where((e) => e.id == id).firstOrNull;
    if (data == null) return null;
    return _toModel(data);
  }

  static int _calculateDuration(String startDate, String endDate) {
    final start = DateTime.tryParse(startDate);
    final end = DateTime.tryParse(endDate);
    if (start == null || end == null) return 1;
    return (end.difference(start).inDays + 1).clamp(1, 365);
  }

  static Future<String> create({
    required String employeeId,
    String employeeName = '',
    required String leaveType,
    required String startDate,
    required String endDate,
    String? reason,
  }) async {
    await _ensureReady();
    final id = const Uuid().v4();
    final duration = _calculateDuration(startDate, endDate);
    final now = DateTime.now();
    final start = DateTime.tryParse(startDate) ?? now;
    final end = DateTime.tryParse(endDate) ?? now;

    final record = LeaveModel(
      id: id,
      employeeId: employeeId,
      employeeName: employeeName,
      leaveType: leaveType,
      startDate: startDate,
      endDate: endDate,
      duration: duration,
      status: 'pending',
      reason: reason,
      createdAt: now,
      updatedAt: now,
    );

    await _dao.upsert(LeavesTableCompanion(
      id: Value(id),
      employeeId: Value(employeeId),
      type: Value(leaveType),
      startDate: Value(start),
      endDate: Value(end),
      status: const Value('pending'),
      reason: Value(reason),
      approvedBy: const Value(null),
      branchId: Value(AuthService.currentBranchId ?? ''),
      isDeleted: const Value(false),
      lastModified: Value(now),
    ));
    final saved = await _dao.getById(id);
    if (saved != null) _cached.add(saved);

    try {
      await SyncService.queueOperation(
        type: SyncOperationType.create,
        table: 'leaves',
        data: record.toJson(),
        branchId: AuthService.currentBranchId ?? '',
      );
    } catch (_) {}

    return id;
  }

  static Future<void> approve(String id, String approvedBy) async {
    await _ensureReady();
    final existing = _cached.where((e) => e.id == id).firstOrNull;
    if (existing == null) return;
    final now = DateTime.now();

    await _dao.upsert(LeavesTableCompanion(
      id: Value(id),
      employeeId: Value(existing.employeeId),
      type: Value(existing.type),
      startDate: Value(existing.startDate),
      endDate: Value(existing.endDate),
      status: const Value('approved'),
      reason: Value(existing.reason),
      approvedBy: Value(approvedBy),
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
        table: 'leaves',
        data: {'id': id, 'status': 'approved', 'approved_by': approvedBy},
        branchId: AuthService.currentBranchId ?? '',
      );
    } catch (_) {}
  }

  static Future<void> reject(String id, {String? reason}) async {
    await _ensureReady();
    final existing = _cached.where((e) => e.id == id).firstOrNull;
    if (existing == null) return;
    final now = DateTime.now();

    await _dao.upsert(LeavesTableCompanion(
      id: Value(id),
      employeeId: Value(existing.employeeId),
      type: Value(existing.type),
      startDate: Value(existing.startDate),
      endDate: Value(existing.endDate),
      status: const Value('rejected'),
      reason: Value(reason ?? existing.reason),
      approvedBy: Value(existing.approvedBy),
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
        table: 'leaves',
        data: {'id': id, 'status': 'rejected', 'rejection_reason': reason},
        branchId: AuthService.currentBranchId ?? '',
      );
    } catch (_) {}
  }

  static Future<void> delete(String id) async {
    await _ensureReady();
    await _dao.softDelete(id);
    _cached.removeWhere((e) => e.id == id);

    try {
      await SyncService.queueOperation(
        type: SyncOperationType.delete,
        table: 'leaves',
        data: {'id': id, 'is_deleted': true},
        branchId: AuthService.currentBranchId ?? '',
      );
    } catch (_) {}
  }

  static Future<LeaveBalance> getBalance(String employeeId) async {
    final approvedRecords =
        await getAll(status: 'approved', employeeId: employeeId);

    final sickDays = approvedRecords
        .where((r) => r.leaveType == 'sick')
        .fold<int>(0, (sum, r) => sum + r.duration);
    final annualDays = approvedRecords
        .where((r) => r.leaveType == 'annual')
        .fold<int>(0, (sum, r) => sum + r.duration);
    final emergencyDays = approvedRecords
        .where((r) => r.leaveType == 'emergency')
        .fold<int>(0, (sum, r) => sum + r.duration);
    final unpaidDays = approvedRecords
        .where((r) => r.leaveType == 'unpaid')
        .fold<int>(0, (sum, r) => sum + r.duration);

    return LeaveBalance(
      sick: LeaveTypeBalance(total: 30, used: sickDays),
      annual: LeaveTypeBalance(total: 21, used: annualDays),
      emergency: LeaveTypeBalance(total: 7, used: emergencyDays),
      unpaid: LeaveTypeBalance(total: 30, used: unpaidDays),
    );
  }

  static LeaveModel _toModel(LeavesTableData d) => LeaveModel(
    id: d.id,
    employeeId: d.employeeId,
    employeeName: '',
    leaveType: d.type,
    startDate: d.startDate.toIso8601String().substring(0, 10),
    endDate: d.endDate.toIso8601String().substring(0, 10),
    duration: _calculateDuration(
      d.startDate.toIso8601String().substring(0, 10),
      d.endDate.toIso8601String().substring(0, 10),
    ),
    status: d.status,
    reason: d.reason,
    approvedBy: d.approvedBy,
    rejectionReason: null,
    createdAt: d.lastModified,
    updatedAt: d.lastModified,
  );
}




