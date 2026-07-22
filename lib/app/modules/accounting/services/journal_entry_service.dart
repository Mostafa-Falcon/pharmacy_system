import 'dart:convert';

import 'package:drift/drift.dart';

import 'package:pharmacy_system/app/core/data/database/daos/journal_entries_dao.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import '../../../core/injection.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/core/data/services/sync/sync_service.dart';
import 'package:pharmacy_system/app/modules/accounting/models/account_enums.dart';
import 'package:pharmacy_system/app/modules/accounting/models/journal_entry_model.dart';

class JournalEntryService {
  static final JournalEntriesDao _dao = sl<JournalEntriesDao>();
  static List<JournalEntriesTableData> _cached = [];
  static bool _ready = false;

  static String get _currentBranchId => AuthService.currentBranchId ?? '';

  static Future<void> _ensureReady() async {
    if (!_ready) {
      _cached = await _dao.getAll();
      _ready = true;
    }
  }

  static Future<List<JournalEntryModel>> getAll({String? branchId}) async {
    await _ensureReady();
    final bid = branchId ?? _currentBranchId;
    final entries = _cached
        .where((e) => e.branchId == bid && !e.isDeleted)
        .map(_toModel)
        .toList();
    entries.sort((a, b) => b.entryDate.compareTo(a.entryDate));
    return entries;
  }

  static Future<JournalEntryModel?> getById(String id) async {
    await _ensureReady();
    final data = _cached.where((e) => e.id == id).firstOrNull;
    if (data == null) return null;
    return _toModel(data);
  }

  static Future<void> create(JournalEntryModel entry) async {
    await _ensureReady();
    final companion = JournalEntriesTableCompanion(
      id: Value(entry.id),
      branchId: Value(entry.branchId),
      entryNumber: Value(entry.entryNumber),
      entryDate: Value(entry.entryDate),
      entryType: Value(entry.entryType.name),
      referenceId: Value(entry.referenceId),
      referenceNumber: Value(entry.referenceNumber),
      description: Value(entry.description),
      lines: Value(jsonEncode(entry.lines.map((l) => l.toJson()).toList())),
      totalDebit: Value(entry.totalDebit),
      totalCredit: Value(entry.totalCredit),
      createdById: Value(entry.createdById),
      createdByName: Value(entry.createdByName),
      createdAt: Value(entry.createdAt),
      updatedAt: Value(entry.updatedAt),
      isDeleted: const Value(false),
    );
    await _dao.upsert(companion);
    final saved = await _dao.getById(entry.id);
    if (saved != null) _cached.add(saved);

    try {
      await SyncService.queueOperation(
        type: SyncOperationType.create,
        table: 'journal_entries',
        data: entry.toJson(),
        branchId: _currentBranchId,
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
        table: 'journal_entries',
        data: {'id': id, 'is_deleted': true},
        branchId: _currentBranchId,
      );
    } catch (_) {}
  }

  static Future<int> nextNumber(String branchId) async {
    final entries = await getAll(branchId: branchId);
    if (entries.isEmpty) return 1;
    return entries.map((e) => e.entryNumber).reduce((a, b) => a > b ? a : b) + 1;
  }

  static JournalEntryModel _toModel(JournalEntriesTableData d) {
    List<JournalEntryLineModel> lines = [];
    try {
      final decoded = jsonDecode(d.lines);
      if (decoded is List) {
        lines = decoded
            .map((e) => JournalEntryLineModel.fromJson(
                Map<String, dynamic>.from(e)))
            .toList();
      }
    } catch (_) {}

    return JournalEntryModel(
      id: d.id,
      branchId: d.branchId,
      entryNumber: d.entryNumber,
      entryDate: d.entryDate,
      entryType: JournalEntryType.values.firstWhere(
        (e) => e.name == d.entryType,
        orElse: () => JournalEntryType.other,
      ),
      referenceId: d.referenceId,
      referenceNumber: d.referenceNumber,
      description: d.description,
      lines: lines,
      totalDebit: d.totalDebit,
      totalCredit: d.totalCredit,
      createdById: d.createdById,
      createdByName: d.createdByName,
      createdAt: d.createdAt,
      updatedAt: d.updatedAt,
    );
  }
}

