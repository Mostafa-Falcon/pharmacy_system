import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:pharmacy_system/app/core/data/database/daos/attendance_dao.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import '../../../core/injection.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/core/sync/sync_service.dart';
import 'package:pharmacy_system/app/modules/hr/models/attendance_model.dart';

class AttendanceService {
  static final AttendanceDao _dao = sl<AttendanceDao>();
  static List<AttendanceTableData> _cached = [];
  static bool _ready = false;

  static String get _currentBranchId => AuthService.currentBranchId ?? '';

  static Future<void> _ensureReady() async {
    if (!_ready) {
      _cached = await _dao.getAll();
      _ready = true;
    }
  }

  static Future<List<AttendanceModel>> getAll({String? branchId, String? date}) async {
    await _ensureReady();
    final bid = branchId ?? _currentBranchId;
    var records = _cached
        .where((e) => !e.isDeleted)
        .where((e) => branchId == null || e.branchId == bid)
        .map(_toModel)
        .toList();
    if (date != null) {
      final dateTime = DateTime.tryParse(date);
      if (dateTime != null) {
        records = records.where((e) {
          final d = DateTime.tryParse(e.date);
          return d != null && d == dateTime;
        }).toList();
      }
    }
    records.sort((a, b) => b.date.compareTo(a.date));
    return records;
  }

  static Future<AttendanceModel?> getById(String id) async {
    await _ensureReady();
    final data = _cached.where((e) => e.id == id).firstOrNull;
    if (data == null) return null;
    return _toModel(data);
  }

  static Future<List<AttendanceModel>> getByEmployee(String employeeId) async {
    final all = await getAll();
    return all.where((e) => e.employeeId == employeeId).toList();
  }

  static Future<AttendanceModel?> getTodayRecord(String employeeId) async {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final records = await getAll(date: today);
    return records.where((e) => e.employeeId == employeeId).firstOrNull;
  }

  static Future<String> clockIn({
    required String employeeId,
    String employeeName = '',
    String? notes,
  }) async {
    await _ensureReady();
    final id = const Uuid().v4();
    final now = DateTime.now();
    final today = now;

    final record = AttendanceModel(
      id: id,
      employeeId: employeeId,
      employeeName: employeeName,
      branchId: _currentBranchId,
      clockIn: now.toIso8601String(),
      clockOut: null,
      date: today.toIso8601String().substring(0, 10),
      status: 'present',
      notes: notes,
      createdAt: now,
      updatedAt: now,
    );

    await _dao.upsert(AttendanceTableCompanion(
      id: Value(id),
      employeeId: Value(employeeId),
      date: Value(today),
      checkIn: Value(now.toIso8601String()),
      checkOut: const Value(null),
      status: const Value('present'),
      notes: Value(notes),
      branchId: Value(_currentBranchId),
      isDeleted: const Value(false),
    ));
    final saved = await _dao.getById(id);
    if (saved != null) _cached.add(saved);

    try {
      await SyncService.queueOperation(
        type: SyncOperationType.create,
        table: 'attendance',
        data: record.toJson(),
        branchId: _currentBranchId,
      );
    } catch (_) {}

    return id;
  }

  static Future<void> clockOut(String id, {String? notes}) async {
    await _ensureReady();
    final existing = _cached.where((e) => e.id == id).firstOrNull;
    if (existing == null) return;

    final now = DateTime.now().toIso8601String();
    await _dao.upsert(AttendanceTableCompanion(
      id: Value(id),
      employeeId: Value(existing.employeeId),
      date: Value(existing.date),
      checkIn: Value(existing.checkIn),
      checkOut: Value(now),
      status: Value(existing.status),
      notes: Value(notes ?? existing.notes),
      branchId: Value(existing.branchId),
      isDeleted: Value(existing.isDeleted),
    ));
    final saved = await _dao.getById(id);
    if (saved != null) {
      final idx = _cached.indexWhere((e) => e.id == id);
      if (idx >= 0) _cached[idx] = saved;
    }

    try {
      await SyncService.queueOperation(
        type: SyncOperationType.update,
        table: 'attendance',
        data: {
          'id': id,
          'clock_out': now,
        },
        branchId: _currentBranchId,
      );
    } catch (_) {}
  }

  static Future<void> approve(String id, String approvedBy) async {
    await _ensureReady();
    final existing = _cached.where((e) => e.id == id).firstOrNull;
    if (existing == null) return;

    await _dao.upsert(AttendanceTableCompanion(
      id: Value(id),
      employeeId: Value(existing.employeeId),
      date: Value(existing.date),
      checkIn: Value(existing.checkIn),
      checkOut: Value(existing.checkOut),
      status: Value(existing.status),
      notes: Value(existing.notes),
      branchId: Value(existing.branchId),
      isDeleted: Value(existing.isDeleted),
    ));
  }

  static Future<void> reject(String id, {String? reason}) async {
    await _ensureReady();
    final existing = _cached.where((e) => e.id == id).firstOrNull;
    if (existing == null) return;

    await _dao.upsert(AttendanceTableCompanion(
      id: Value(id),
      employeeId: Value(existing.employeeId),
      date: Value(existing.date),
      checkIn: Value(existing.checkIn),
      checkOut: Value(existing.checkOut),
      status: const Value('absent'),
      notes: Value(reason ?? existing.notes),
      branchId: Value(existing.branchId),
      isDeleted: Value(existing.isDeleted),
    ));
  }

  static Future<void> delete(String id) async {
    await _ensureReady();
    await _dao.softDelete(id);
    _cached.removeWhere((e) => e.id == id);

    try {
      await SyncService.queueOperation(
        type: SyncOperationType.delete,
        table: 'attendance',
        data: {'id': id, 'is_deleted': true},
        branchId: _currentBranchId,
      );
    } catch (_) {}
  }

  static Future<List<AttendanceModel>> getByDateRange(
      String startDate, String endDate,
      {String? branchId}) async {
    final all = await getAll(branchId: branchId);
    return all.where((e) {
      final date = DateTime.tryParse(e.date);
      final start = DateTime.tryParse(startDate);
      final end = DateTime.tryParse(endDate);
      if (date == null || start == null || end == null) return false;
      return !date.isBefore(start) && !date.isAfter(end);
    }).toList();
  }

  static Future<AttendanceReport> getReport(
      {required int month, required int year, String? branchId}) async {
    final monthStr = month.toString().padLeft(2, '0');
    final startDate = '$year-$monthStr-01';
    final endDate = '$year-$monthStr-31';

    final records = await getByDateRange(startDate, endDate, branchId: branchId);

    final summary = AttendanceSummary(
      present: records.where((r) => r.status == 'present').length,
      late: records.where((r) => r.status == 'late').length,
      absent: records.where((r) => r.status == 'absent').length,
      halfDay: records.where((r) => r.status == 'half-day').length,
    );

    final employeeIds = records.map((r) => r.employeeId).toSet();
    final workingDays = records.map((r) => r.date).toSet();

    return AttendanceReport(
      month: monthStr,
      year: year,
      totalEmployees: employeeIds.length,
      totalWorkingDays: workingDays.length,
      summary: summary,
      records: records,
    );
  }

  static AttendanceModel _toModel(AttendanceTableData d) => AttendanceModel(
    id: d.id,
    employeeId: d.employeeId,
    employeeName: '',
    branchId: d.branchId,
    clockIn: d.checkIn ?? '',
    clockOut: d.checkOut,
    date: d.date.toIso8601String().substring(0, 10),
    status: d.status,
    approvedBy: null,
    notes: d.notes,
    createdAt: d.date,
    updatedAt: d.date,
  );
}




