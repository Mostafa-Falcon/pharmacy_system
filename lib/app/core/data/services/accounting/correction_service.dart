import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'package:pharmacy_system/app/core/data/database/daos/audit_logs_dao.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/core/injection.dart';
import 'package:pharmacy_system/app/core/models/base/correction_model.dart';
import '../auth/auth_service.dart';
import 'package:pharmacy_system/app/core/sync/sync_service.dart';

class CorrectionService {
  static final _uuid = const Uuid();
  static final AuditLogsDao _dao = sl<AuditLogsDao>();

  static Future<void> record({
    required CorrectionReferenceType referenceType,
    required String referenceId,
    required CorrectionAction action,
    String? details,
  }) async {
    final id = _uuid.v4();
    final branchId = AuthService.currentBranchId ?? '';
    final userId = AuthService.currentUser?.id ?? 'unknown';
    final userDisplayName = AuthService.currentUser?.name ?? 'غير معروف';
    final now = DateTime.now();

    final entry = CorrectionEntry(
      id: id,
      referenceType: referenceType,
      referenceId: referenceId,
      action: action,
      userId: userId,
      userDisplayName: userDisplayName,
      timestamp: now,
      details: details,
    );

    await _dao.upsert(AuditLogsTableCompanion(
      id: Value(id),
      userId: Value(userId),
      action: Value(action.name),
      entityType: Value(referenceType.name),
      entityId: Value(referenceId),
      details: Value(jsonEncode(entry.toJson())),
      branchId: Value(branchId),
      createdAt: Value(now),
    ));

    try {
      await SyncService.queueOperation(
        type: SyncOperationType.create,
        table: 'audit_logs',
        data: {
          'id': id,
          'user_id': userId,
          'action': action.name,
          'entity_type': referenceType.name,
          'entity_id': referenceId,
          'details': jsonEncode(entry.toJson()),
          'branch_id': branchId,
          'created_at': now.toIso8601String(),
        },
        branchId: branchId,
      );
    } catch (_) {}
  }

  static Future<List<CorrectionEntry>> getChain({
    required CorrectionReferenceType referenceType,
    required String referenceId,
  }) async {
    final rows = await _dao.getAll();
    final all = _parseEntries(rows);
    final entries = all.where((e) =>
      e.referenceType == referenceType && e.referenceId == referenceId,
    ).toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return entries;
  }

  static Future<List<CorrectionEntry>> getByReferenceId(
      String referenceId) async {
    final rows = await _dao.getAll();
    final all = _parseEntries(rows);
    final entries = all.where((e) => e.referenceId == referenceId).toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return entries;
  }

  static Future<List<CorrectionEntry>> getAll({int? limit}) async {
    final rows = await _dao.getAll();
    final entries = _parseEntries(rows);
    entries.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return limit != null ? entries.take(limit).toList() : entries;
  }

  static List<CorrectionEntry> _parseEntries(List<AuditLogsTableData> rows) {
    final entries = <CorrectionEntry>[];
    for (final row in rows) {
      if (row.details == null) continue;
      try {
        final json = jsonDecode(row.details!);
        entries.add(CorrectionEntry.fromJson(Map<String, dynamic>.from(json)));
      } catch (_) {}
    }
    return entries;
  }
}



