import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:pharmacy_system/app/core/data/database/daos/expenses_dao.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import '../../../core/injection.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/core/sync/sync_service.dart';
import 'package:pharmacy_system/app/core/models/accounting/expense_model.dart';
import 'package:pharmacy_system/app/core/models/accounting/journal_entry_model.dart';
import 'package:pharmacy_system/app/core/models/accounting/account_enums.dart';
import 'journal_entry_service.dart';

class ExpensePostResult {
  final ExpenseModel expense;
  final JournalEntryModel journal;
  final bool alreadyPosted;

  const ExpensePostResult({
    required this.expense,
    required this.journal,
    this.alreadyPosted = false,
  });
}

class ExpenseService {
  static final ExpensesDao _dao = sl<ExpensesDao>();
  static List<ExpensesTableData> _cached = [];
  static bool _ready = false;

  static String get _currentBranchId => AuthService.currentBranchId ?? '';

  static Future<void> _ensureReady() async {
    if (!_ready) {
      _cached = await _dao.getAll();
      _ready = true;
    }
  }

  static Future<List<ExpenseModel>> getAll({String? branchId}) async {
    await _ensureReady();
    final bid = branchId ?? _currentBranchId;
    final expenses = _cached
        .where((e) => e.branchId == bid && !e.isDeleted)
        .map(_toModel)
        .toList();
    expenses.sort((a, b) => b.expenseDate.compareTo(a.expenseDate));
    return expenses;
  }

  static Future<ExpenseModel?> getById(String id) async {
    await _ensureReady();
    final data = _cached.where((e) => e.id == id).firstOrNull;
    if (data == null) return null;
    return _toModel(data);
  }

  static Future<ExpensePostResult> post({
    required ExpenseModel draft,
    required String actorId,
  }) async {
    _validate(draft, actorId: actorId);
    await _ensureReady();
    final existing = _cached.where((e) => e.id == draft.id).firstOrNull;
    if (existing != null) {
      return ExpensePostResult(
        expense: _toModel(existing),
        journal: JournalEntryModel(
          id: 'journal:expense:${draft.id}',
          branchId: draft.branchId,
          entryNumber: await JournalEntryService.nextNumber(draft.branchId),
          entryDate: draft.expenseDate,
          entryType: JournalEntryType.expense,
          referenceId: draft.id,
          description: draft.description ?? draft.category,
          lines: [],
          totalDebit: 0,
          totalCredit: 0,
          createdById: actorId,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        alreadyPosted: true,
      );
    }

    final occurredAt = DateTime.now();
    final expense = ExpenseModel(
      id: draft.id,
      branchId: draft.branchId,
      expenseNumber: draft.expenseNumber,
      expenseDate: draft.expenseDate,
      category: draft.category.trim(),
      description: draft.description?.trim(),
      amount: _money(draft.amount),
      paymentMethod: draft.paymentMethod,
      createdById: actorId,
      createdByName: draft.createdByName,
      notes: draft.notes?.trim().isEmpty == true ? null : draft.notes?.trim(),
      createdAt: draft.createdAt,
      updatedAt: occurredAt,
    );

    final journal = await _buildJournal(expense, actorId, occurredAt);

    final companion = ExpensesTableCompanion(
      id: Value(expense.id),
      branchId: Value(expense.branchId),
      expenseNumber: Value(expense.expenseNumber),
      expenseDate: Value(expense.expenseDate),
      category: Value(expense.category),
      description: Value(expense.description),
      amount: Value(expense.amount),
      paymentMethod: Value(expense.paymentMethod),
      createdById: Value(expense.createdById),
      createdByName: Value(expense.createdByName),
      notes: Value(expense.notes),
      createdAt: Value(expense.createdAt),
      updatedAt: Value(expense.updatedAt),
      isDeleted: const Value(false),
    );
    await _dao.upsert(companion);
    _cached.add(await _dao.getById(expense.id).then((v) => v!));

    await JournalEntryService.create(journal);

    try {
      await SyncService.queueOperation(
        type: SyncOperationType.create,
        table: 'expenses',
        data: expense.toJson(),
        branchId: _currentBranchId,
      );
    } catch (_) {}

    return ExpensePostResult(expense: expense, journal: journal);
  }

  static Future<JournalEntryModel> _buildJournal(
    ExpenseModel expense,
    String actorId,
    DateTime occurredAt,
  ) async {
    final amount = expense.amount;
    final paymentAccount = _paymentAccount(expense.paymentMethod);
    final categoryKey = expense.category.trim().toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9\u0600-\u06ff]+'), '_');

    return JournalEntryModel(
      id: 'journal:expense:${expense.id}',
      branchId: expense.branchId,
      entryNumber: await JournalEntryService.nextNumber(expense.branchId),
      entryDate: expense.expenseDate,
      entryType: JournalEntryType.expense,
      referenceId: expense.id,
      referenceNumber: expense.expenseNumber.toString(),
      description: expense.description,
      lines: [
        JournalEntryLineModel(
          id: const Uuid().v4(),
          accountId: 'system:expense:$categoryKey',
          accountName: expense.category,
          debit: amount,
          credit: 0,
          description: expense.description,
        ),
        JournalEntryLineModel(
          id: const Uuid().v4(),
          accountId: paymentAccount,
          accountName: _paymentAccountName(expense.paymentMethod),
          debit: 0,
          credit: amount,
          description: expense.description,
        ),
      ],
      totalDebit: amount,
      totalCredit: amount,
      createdById: actorId,
      createdByName: expense.createdByName,
      createdAt: occurredAt,
      updatedAt: occurredAt,
    );
  }

  static String _paymentAccount(String? method) {
    switch (method) {
      case 'card': return 'system:card_clearing';
      case 'bank_transfer': return 'system:bank';
      case 'mobile_wallet': return 'system:mobile_wallet';
      default: return 'system:cash';
    }
  }

  static String _paymentAccountName(String? method) {
    switch (method) {
      case 'card': return '?????? ????????';
      case 'bank_transfer': return '?????';
      case 'mobile_wallet': return '??????? ???????????';
      default: return '???????';
    }
  }

  static void _validate(ExpenseModel value, {required String actorId}) {
    if (value.id.trim().isEmpty) {
      throw const FormatException('???? ??????? ?????');
    }
    if (value.branchId.trim().isEmpty) {
      throw const FormatException('????? ?????');
    }
    if (value.category.trim().isEmpty) {
      throw const FormatException('????? ??????? ?????');
    }
    if (value.amount <= 0) {
      throw StateError('???? ??????? ??? ?? ???? ?????');
    }
    if (value.paymentMethod == 'credit') {
      throw StateError('????????? ?? ???? ?? ???? ????');
    }
    if (actorId.trim().isEmpty) {
      throw const FormatException('???????? ?????');
    }
  }

  static Future<int> nextNumber(String branchId) async {
    final expenses = await getAll(branchId: branchId);
    if (expenses.isEmpty) return 1;
    return expenses.map((e) => e.expenseNumber).reduce((a, b) => a > b ? a : b) + 1;
  }

  static Future<void> updateExpense(ExpenseModel updated) async {
    await _ensureReady();
    final companion = ExpensesTableCompanion(
      id: Value(updated.id),
      branchId: Value(updated.branchId),
      expenseNumber: Value(updated.expenseNumber),
      expenseDate: Value(updated.expenseDate),
      category: Value(updated.category),
      description: Value(updated.description),
      amount: Value(updated.amount),
      paymentMethod: Value(updated.paymentMethod),
      createdById: Value(updated.createdById),
      createdByName: Value(updated.createdByName),
      notes: Value(updated.notes),
      createdAt: Value(updated.createdAt),
      updatedAt: Value(DateTime.now()),
      isDeleted: const Value(false),
    );
    await _dao.upsert(companion);
    final saved = await _dao.getById(updated.id);
    if (saved != null) {
      final idx = _cached.indexWhere((e) => e.id == updated.id);
      if (idx >= 0) {
        _cached[idx] = saved;
      } else {
        _cached.add(saved);
      }
    }
    
    try {
      await SyncService.queueOperation(
        type: SyncOperationType.update,
        table: 'expenses',
        data: updated.toJson(),
        branchId: updated.branchId,
      );
    } catch (_) {}
  }

  static Future<void> deleteExpense(String id) async {
    await _ensureReady();
    final e = _cached.firstWhereOrNull((x) => x.id == id);
    if (e == null) return;
    
    await _dao.softDelete(id);
    _cached.removeWhere((x) => x.id == id);
    
    try {
      await SyncService.queueOperation(
        type: SyncOperationType.delete,
        table: 'expenses',
        data: {'id': id, 'is_deleted': true},
        branchId: e.branchId,
      );
    } catch (_) {}
  }

  static double _money(double value) => (value * 100).roundToDouble() / 100;

  static ExpenseModel _toModel(ExpensesTableData d) => ExpenseModel(
    id: d.id,
    branchId: d.branchId,
    expenseNumber: d.expenseNumber,
    expenseDate: d.expenseDate,
    category: d.category,
    description: d.description,
    amount: d.amount,
    paymentMethod: d.paymentMethod,
    createdById: d.createdById,
    createdByName: d.createdByName,
    notes: d.notes,
    createdAt: d.createdAt,
    updatedAt: d.updatedAt,
  );
}




