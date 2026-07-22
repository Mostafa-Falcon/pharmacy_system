import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:pharmacy_system/app/core/bloc/table_observer_mixin.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/reusables/feedback/app_snackbar.dart';
import 'package:pharmacy_system/app/modules/accounting/models/expense_model.dart';
import 'package:pharmacy_system/app/modules/accounting/models/journal_entry_model.dart';
import '../services/accounting_projection_service.dart';
import '../services/expense_service.dart';
import '../services/journal_entry_service.dart';

// ── أحداث المحاسبة ──
abstract class AccountingEvent extends Equatable {
  const AccountingEvent();
  @override
  List<Object?> get props => [];
}

class LoadAccounting extends AccountingEvent {
  const LoadAccounting();
}

class AddExpense extends AccountingEvent {
  final String category;
  final String? description;
  final double amount;
  final String paymentMethod;
  final String? notes;
  final DateTime expenseDate;
  AddExpense({
    required this.category,
    this.description,
    required this.amount,
    required this.paymentMethod,
    this.notes,
    DateTime? expenseDate,
  }) : expenseDate = expenseDate ?? DateTime.now();
  @override
  List<Object?> get props => [category, description, amount, paymentMethod, notes, expenseDate];
}

class UpdateExpense extends AccountingEvent {
  final String id;
  final String category;
  final String? description;
  final double amount;
  final String paymentMethod;
  final String? notes;
  final DateTime expenseDate;
  const UpdateExpense({
    required this.id,
    required this.category,
    this.description,
    required this.amount,
    required this.paymentMethod,
    this.notes,
    required this.expenseDate,
  });
  @override
  List<Object?> get props => [id, category, description, amount, paymentMethod, notes, expenseDate];
}

class DeleteExpense extends AccountingEvent {
  final String id;
  const DeleteExpense({required this.id});
  @override
  List<Object?> get props => [id];
}

class DeleteJournalEntry extends AccountingEvent {
  final String id;
  const DeleteJournalEntry({required this.id});
  @override
  List<Object?> get props => [id];
}

class LoadJournalsInRange extends AccountingEvent {
  final DateTime from;
  final DateTime to;
  const LoadJournalsInRange({required this.from, required this.to});
  @override
  List<Object?> get props => [from, to];
}

class FilterJournals extends AccountingEvent {
  final String query;
  const FilterJournals({required this.query});
  @override
  List<Object?> get props => [query];
}

class FilterExpenses extends AccountingEvent {
  final String? query;
  final DateTime? fromDate;
  final DateTime? toDate;
  const FilterExpenses({this.query, this.fromDate, this.toDate});
  @override
  List<Object?> get props => [query, fromDate, toDate];
}

// ── حالة المحاسبة ──
enum AccountingStatus { initial, loading, loaded, error }

class AccountingState extends Equatable {
  final AccountingStatus status;
  final List<JournalEntryModel> journals;
  final List<ExpenseModel> expenses;
  final List<ExpenseModel> filteredExpenses;
  final double totalRevenue;
  final double totalExpenses;
  final double netProfit;
  final List<JournalEntryModel> journalsInRange;
  final String? errorMessage;

  const AccountingState({
    this.status = AccountingStatus.initial,
    this.journals = const [],
    this.expenses = const [],
    this.filteredExpenses = const [],
    this.totalRevenue = 0,
    this.totalExpenses = 0,
    this.netProfit = 0,
    this.journalsInRange = const [],
    this.errorMessage,
  });

  AccountingState copyWith({
    AccountingStatus? status,
    List<JournalEntryModel>? journals,
    List<ExpenseModel>? expenses,
    List<ExpenseModel>? filteredExpenses,
    double? totalRevenue,
    double? totalExpenses,
    double? netProfit,
    List<JournalEntryModel>? journalsInRange,
    String? errorMessage,
  }) {
    return AccountingState(
      status: status ?? this.status,
      journals: journals ?? this.journals,
      expenses: expenses ?? this.expenses,
      filteredExpenses: filteredExpenses ?? this.filteredExpenses,
      totalRevenue: totalRevenue ?? this.totalRevenue,
      totalExpenses: totalExpenses ?? this.totalExpenses,
      netProfit: netProfit ?? this.netProfit,
      journalsInRange: journalsInRange ?? this.journalsInRange,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status, journals, expenses, filteredExpenses, totalRevenue, totalExpenses,
    netProfit, journalsInRange, errorMessage,
  ];
}

// ── Bloc المحاسبة ──
class AccountingBloc extends Bloc<AccountingEvent, AccountingState> with TableObserverMixin<AccountingEvent, AccountingState> {
  AccountingBloc() : super(const AccountingState()) {
    on<LoadAccounting>(_onLoadAccounting);
    on<AddExpense>(_onAddExpense);
    on<UpdateExpense>(_onUpdateExpense);
    on<DeleteExpense>(_onDeleteExpense);
    on<DeleteJournalEntry>(_onDeleteJournalEntry);
    on<LoadJournalsInRange>(_onLoadJournalsInRange);
    on<FilterJournals>(_onFilterJournals);
    on<FilterExpenses>(_onFilterExpenses);
  }

  String get _branchId => AuthService.currentBranchId ?? '';

  Future<void> _onLoadAccounting(
    LoadAccounting event,
    Emitter<AccountingState> emit,
  ) async {
    // تفعيل المراقبة التفاعلية
    observeTables(
      ['expenses', 'journal_entries', 'sales', 'purchases'],
      () => add(const LoadAccounting()),
      branchId: _branchId,
    );

    emit(state.copyWith(status: AccountingStatus.loading));
    try {
      final journals = await JournalEntryService.getAll(branchId: _branchId);
      final expenses = await ExpenseService.getAll(branchId: _branchId);
      final summary = await AccountingProjectionService.getSummary(branchId: _branchId);
      emit(state.copyWith(
        status: AccountingStatus.loaded,
        journals: journals,
        expenses: expenses,
        totalRevenue: summary.revenue,
        totalExpenses: summary.operatingExpenses,
        netProfit: summary.netProfit,
        journalsInRange: journals,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AccountingStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onAddExpense(
    AddExpense event,
    Emitter<AccountingState> emit,
  ) async {
    try {
      final expense = ExpenseModel(
        id: const Uuid().v4(),
        branchId: _branchId,
        expenseNumber: await ExpenseService.nextNumber(_branchId),
        category: event.category,
        description: event.description,
        amount: event.amount,
        paymentMethod: event.paymentMethod,
        createdById: AuthService.currentUser?.id ?? '',
        createdByName: AuthService.currentUser?.name,
        notes: event.notes,
        expenseDate: event.expenseDate,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await ExpenseService.post(
        draft: expense,
        actorId: AuthService.currentUser?.id ?? '',
      );
      AppSnackbar.success('تم تسجيل المصروف بنجاح');
      add(const LoadAccounting());
    } catch (e) {
      AppSnackbar.error('فشل تسجيل المصروف: $e');
    }
  }

  Future<void> _onUpdateExpense(
    UpdateExpense event,
    Emitter<AccountingState> emit,
  ) async {
    try {
      final existing = await ExpenseService.getById(event.id);
      if (existing == null) {
        AppSnackbar.error('المصروف غير موجود');
        return;
      }
      final updated = ExpenseModel(
        id: existing.id,
        branchId: existing.branchId,
        expenseNumber: existing.expenseNumber,
        category: event.category,
        description: event.description,
        amount: event.amount,
        paymentMethod: event.paymentMethod,
        createdById: existing.createdById,
        createdByName: existing.createdByName,
        notes: event.notes,
        expenseDate: event.expenseDate,
        createdAt: existing.createdAt,
        updatedAt: DateTime.now(),
      );
      await ExpenseService.updateExpense(updated);

      final journal = await JournalEntryService.getById('journal:expense:${updated.id}');
      if (journal != null) {
        final updatedJournal = JournalEntryModel(
          id: journal.id,
          branchId: journal.branchId,
          entryNumber: journal.entryNumber,
          entryDate: updated.expenseDate,
          entryType: journal.entryType,
          referenceId: journal.referenceId,
          referenceNumber: journal.referenceNumber,
          description: updated.description,
          lines: journal.lines,
          totalDebit: updated.amount,
          totalCredit: updated.amount,
          createdById: journal.createdById,
          createdByName: journal.createdByName,
          createdAt: journal.createdAt,
          updatedAt: DateTime.now(),
        );
        await JournalEntryService.create(updatedJournal);
      }
      AppSnackbar.success('تم تعديل المصروف بنجاح');
      add(const LoadAccounting());
    } catch (e) {
      AppSnackbar.error('فشل تعديل المصروف: $e');
    }
  }

  Future<void> _onDeleteExpense(
    DeleteExpense event,
    Emitter<AccountingState> emit,
  ) async {
    try {
      await ExpenseService.deleteExpense(event.id);
      AppSnackbar.success('تم حذف المصروف والقيد المحاسبي');
      add(const LoadAccounting());
    } catch (e) {
      AppSnackbar.error('فشل الحذف: $e');
    }
  }

  Future<void> _onDeleteJournalEntry(
    DeleteJournalEntry event,
    Emitter<AccountingState> emit,
  ) async {
    try {
      await JournalEntryService.delete(event.id);
      AppSnackbar.success('تم حذف القيد');
      add(const LoadAccounting());
    } catch (e) {
      AppSnackbar.error('فشل الحذف: $e');
    }
  }

  void _onLoadJournalsInRange(
    LoadJournalsInRange event,
    Emitter<AccountingState> emit,
  ) {
    final end = DateTime(event.to.year, event.to.month, event.to.day, 23, 59, 59);
    final filtered = state.journals.where((j) =>
      j.entryDate.isAfter(event.from.subtract(const Duration(seconds: 1))) &&
      j.entryDate.isBefore(end.add(const Duration(seconds: 1))),
    ).toList();
    emit(state.copyWith(journalsInRange: filtered));
  }

  void _onFilterJournals(
    FilterJournals event,
    Emitter<AccountingState> emit,
  ) {
    if (event.query.isEmpty) {
      emit(state.copyWith(journalsInRange: state.journals));
      return;
    }
    final q = event.query.toLowerCase();
    final filtered = state.journals.where((j) =>
      j.description?.toLowerCase().contains(q) == true ||
      j.entryNumber.toString().contains(q) ||
      j.entryType.name.toLowerCase().contains(q),
    ).toList();
    emit(state.copyWith(journalsInRange: filtered));
  }

  void _onFilterExpenses(
    FilterExpenses event,
    Emitter<AccountingState> emit,
  ) {
    var filtered = state.expenses;
    if (event.query != null && event.query!.isNotEmpty) {
      final q = event.query!.toLowerCase();
      filtered = filtered.where((e) =>
        e.category.toLowerCase().contains(q) ||
        e.description?.toLowerCase().contains(q) == true ||
        e.expenseNumber.toString().contains(q),
      ).toList();
    }
    if (event.fromDate != null) {
      filtered = filtered.where((e) =>
        !e.expenseDate.isBefore(event.fromDate!)).toList();
    }
    if (event.toDate != null) {
      final end = DateTime(event.toDate!.year, event.toDate!.month, event.toDate!.day, 23, 59, 59);
      filtered = filtered.where((e) =>
        !e.expenseDate.isAfter(end)).toList();
    }
    emit(state.copyWith(filteredExpenses: filtered));
  }
}

