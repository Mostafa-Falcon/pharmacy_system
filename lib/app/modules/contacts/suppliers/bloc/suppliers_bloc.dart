import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_system/app/core/models/contacts/supplier_model.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/core/data/services/supplier/supplier_service.dart';
import 'package:pharmacy_system/app/core/data/services/supplier/supplier_ledger_service.dart';
import 'package:pharmacy_system/app/core/data/services/operations/export_service.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/components/feedback/app_snackbar.dart';
import 'package:pharmacy_system/app/core/data/repositories/suppliers_repository.dart';
import '../../../../core/injection.dart';
import 'suppliers_event.dart';
import 'suppliers_state.dart';

class SuppliersBloc extends Bloc<SuppliersEvent, SuppliersState> {
  StreamSubscription? _subscription;

  SuppliersBloc() : super(const SuppliersState()) {
    on<LoadSuppliers>(_onLoad);
    on<SearchSuppliers>(_onSearch);
    on<AddSupplier>(_onAdd);
    on<UpdateSupplier>(_onUpdate);
    on<ToggleSupplierActive>(_onToggleActive);
    on<ToggleArchivedView>(_onToggleArchived);
    on<ArchiveSupplier>(_onArchive);
    on<RestoreSupplier>(_onRestore);
    on<DeleteSupplier>(_onDelete);
    on<SelectSupplier>(_onSelect);
    on<LoadSupplierLedger>(_onLoadLedger);
    on<RecordCashPayment>(_onCashPayment);
    on<RecordSupplierAdditionNotice>(_onAddition);
    on<RecordSupplierDiscountNotice>(_onDiscount);
    on<RecordSupplierCheckPayment>(_onCheckPayment);
    on<RecordSupplierCheckReceipt>(_onCheckReceipt);
    on<NextSupplierPage>(_onNextPage);
    on<PreviousSupplierPage>(_onPrevPage);
    on<UpdateSupplierSort>(_onSort);
    on<ExportSuppliers>(_onExport);
    on<ClearSupplierLedger>(_onClearLedger);
    on<ToggleSelectSupplier>(_onToggleSelect);
    on<ToggleSelectAllSuppliers>(_onToggleSelectAll);
    on<BulkDeleteSuppliers>(_onBulkDelete);
    on<BulkToggleSuppliersActive>(_onBulkToggleActive);

    // ?????? ???? ?? ??????? ???????? ??? ??? Repository ??????
    _subscription = sl<SuppliersRepository>().watchSuppliers().listen((_) {
      if (!isClosed) add(const LoadSuppliers());
    });

    add(const LoadSuppliers());
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  void _onToggleSelect(ToggleSelectSupplier event, Emitter<SuppliersState> emit) {
    final newSelected = Set<String>.from(state.selectedIds);
    if (newSelected.contains(event.id)) {
      newSelected.remove(event.id);
    } else {
      newSelected.add(event.id);
    }
    emit(state.copyWith(selectedIds: newSelected));
  }

  void _onToggleSelectAll(ToggleSelectAllSuppliers event, Emitter<SuppliersState> emit) {
    if (event.select) {
      final allIds = state.pagedSuppliers.map((s) => s.id).toSet();
      emit(state.copyWith(selectedIds: allIds));
    } else {
      emit(state.copyWith(selectedIds: {}));
    }
  }

  Future<void> _onBulkDelete(BulkDeleteSuppliers event, Emitter<SuppliersState> emit) async {
    try {
      for (final id in state.selectedIds) {
        final s = SupplierService.getById(id);
        if (s != null) {
          await SupplierService.update(s.copyWith(isDeleted: true));
        }
      }
      emit(state.copyWith(selectedIds: {}));
      add(const LoadSuppliers());
      AppSnackbar.success(CrmStrings.msgDeletedSuccess);
    } catch (e) { AppSnackbar.error('${CrmStrings.msgDeleteFailed}$e'); }
  }

  Future<void> _onBulkToggleActive(BulkToggleSuppliersActive event, Emitter<SuppliersState> emit) async {
    try {
      for (final id in state.selectedIds) {
        final s = SupplierService.getById(id);
        if (s != null) {
          if (event.active) {
            await SupplierService.activate(id);
          } else {
            await SupplierService.deactivate(id);
          }
        }
      }
      emit(state.copyWith(selectedIds: {}));
      add(const LoadSuppliers());
      AppSnackbar.success(CrmStrings.msgUpdatedSuccess);
    } catch (e) { AppSnackbar.error('${CrmStrings.msgUpdateFailed}$e'); }
  }

  String get _branchId => AuthService.currentBranchId ?? '';

  Future<void> _onLoad(LoadSuppliers event, Emitter<SuppliersState> emit) async {
    emit(state.copyWith(status: SuppliersStatus.loading));
    try {
      final suppliers = SupplierService.getAll(activeOnly: false);
      final balances = <String, double>{};
      for (final s in suppliers) {
        balances[s.id] = await SupplierLedgerService.getSupplierBalance(s.id, _branchId);
      }
      final visible = state.showArchived
          ? suppliers.where((s) => s.isDeleted).toList()
          : suppliers.where((s) => !s.isDeleted).toList();
      final sorted = _sort(visible, state.sortColumnId, state.isSortAscending);
      final filtered = _filter(sorted, state.searchQuery);
      emit(state.copyWith(
        status: SuppliersStatus.loaded, allSuppliers: suppliers,
        filteredSuppliers: filtered, balances: balances,
        pagedSuppliers: _paginate(filtered, 0), currentPage: 0,
        totalPages: _pages(filtered),
      ));
    } catch (e) {
      emit(state.copyWith(status: SuppliersStatus.error, error: e.toString()));
    }
  }

  void _onSearch(SearchSuppliers event, Emitter<SuppliersState> emit) {
    final visible = state.showArchived
        ? state.allSuppliers.where((s) => s.isDeleted).toList()
        : state.allSuppliers.where((s) => !s.isDeleted).toList();
    final sorted = _sort(visible, state.sortColumnId, state.isSortAscending);
    final filtered = _filter(sorted, event.query);
    emit(state.copyWith(searchQuery: event.query, filteredSuppliers: filtered, currentPage: 0, totalPages: _pages(filtered), pagedSuppliers: _paginate(filtered, 0)));
  }

  void _onToggleArchived(ToggleArchivedView event, Emitter<SuppliersState> emit) {
    final show = !state.showArchived;
    final visible = show
        ? state.allSuppliers.where((s) => s.isDeleted).toList()
        : state.allSuppliers.where((s) => !s.isDeleted).toList();
    final sorted = _sort(visible, state.sortColumnId, state.isSortAscending);
    final filtered = _filter(sorted, state.searchQuery);
    emit(state.copyWith(showArchived: show, filteredSuppliers: filtered, currentPage: 0, totalPages: _pages(filtered), pagedSuppliers: _paginate(filtered, 0)));
  }

  Future<void> _onAdd(AddSupplier event, Emitter<SuppliersState> emit) async {
    try {
      final supplier = await SupplierService.add(name: event.name, partyType: event.partyType,
        phone: event.phone, address: event.address, companyName: event.companyName, email: event.email,
        taxId: event.taxId, creditLimit: event.creditLimit, discountPercent: event.discountPercent,
        paymentTermDays: event.paymentTermDays, notes: event.notes);
      if (event.openingBalance > 0) {
        if (event.openingBalanceIsDebit) {
          await SupplierLedgerService.recordOpeningBalanceDirect(supplierId: supplier.id, branchId: _branchId, amount: event.openingBalance, createdBy: AuthService.currentUser?.id ?? '');
        } else {
          await SupplierLedgerService.recordOpeningBalanceAsCredit(supplierId: supplier.id, branchId: _branchId, amount: event.openingBalance, createdBy: AuthService.currentUser?.id ?? '');
        }
      }
      add(const LoadSuppliers());
      emit(state.copyWith(status: SuppliersStatus.success));
      AppSnackbar.success(CrmStrings.msgPartyAdded);
    } catch (e) {
      emit(state.copyWith(status: SuppliersStatus.error, error: e.toString()));
      AppSnackbar.error('${CrmStrings.msgAddFailed}$e');
    }
  }

  Future<void> _onUpdate(UpdateSupplier event, Emitter<SuppliersState> emit) async {
    try {
      await SupplierService.update(event.supplier);
      add(const LoadSuppliers());
      emit(state.copyWith(status: SuppliersStatus.success));
      AppSnackbar.success(CrmStrings.msgUpdatedSuccess);
    } catch (e) {
      emit(state.copyWith(status: SuppliersStatus.error, error: e.toString()));
      AppSnackbar.error('${CrmStrings.msgUpdateFailed}$e');
    }
  }

  Future<void> _onToggleActive(ToggleSupplierActive event, Emitter<SuppliersState> emit) async {
    final s = SupplierService.getById(event.id);
    if (s != null) {
      if (s.isActive) { await SupplierService.deactivate(event.id); }
      else { await SupplierService.update(s.copyWith(isActive: true)); }
      add(const LoadSuppliers());
    }
  }

  Future<void> _onArchive(ArchiveSupplier event, Emitter<SuppliersState> emit) async {
    final s = SupplierService.getById(event.id);
    if (s != null) {
      await SupplierService.update(s.copyWith(isDeleted: true));
      add(const LoadSuppliers());
    }
  }

  Future<void> _onRestore(RestoreSupplier event, Emitter<SuppliersState> emit) async {
    final s = SupplierService.getById(event.id);
    if (s != null) {
      await SupplierService.update(s.copyWith(isDeleted: false));
      add(const LoadSuppliers());
    }
  }

  Future<void> _onDelete(DeleteSupplier event, Emitter<SuppliersState> emit) async {
    try {
      final s = SupplierService.getById(event.id);
      if (s != null) {
        await SupplierService.update(s.copyWith(isDeleted: true));
        add(const LoadSuppliers());
        AppSnackbar.success(CrmStrings.msgDeletedSuccess);
      }
    } catch (e) { AppSnackbar.error('${CrmStrings.msgDeleteFailed}$e'); }
  }

  void _onSelect(SelectSupplier event, Emitter<SuppliersState> emit) {
    emit(state.copyWith(selectedSupplier: event.supplier, clearSelected: event.supplier == null));
  }

  Future<void> _onLoadLedger(LoadSupplierLedger event, Emitter<SuppliersState> emit) async {
    emit(state.copyWith(isLoadingLedger: true));
    try {
      final entries = await SupplierLedgerService.getSupplierLedger(event.supplierId, _branchId);
      emit(state.copyWith(isLoadingLedger: false, ledgerEntries: entries, selectedSupplier: SupplierService.getById(event.supplierId)));
    } catch (e) { emit(state.copyWith(isLoadingLedger: false, error: e.toString())); }
  }

  Future<void> _onCashPayment(RecordCashPayment event, Emitter<SuppliersState> emit) async {
    try {
      await SupplierLedgerService.recordSupplierPayment(supplierId: event.supplierId, branchId: _branchId, amount: event.amount, createdBy: AuthService.currentUser?.id ?? '', notes: event.notes);
      add(LoadSupplierLedger(event.supplierId));
      AppSnackbar.success(CrmStrings.msgPaymentRecorded);
    } catch (e) { AppSnackbar.error('${CrmStrings.msgPaymentFailed}$e'); }
  }

  Future<void> _onAddition(RecordSupplierAdditionNotice event, Emitter<SuppliersState> emit) async {
    try {
      await SupplierLedgerService.recordAdditionNotice(supplierId: event.supplierId, branchId: _branchId, amount: event.amount, createdBy: AuthService.currentUser?.id ?? '', notes: event.notes);
      add(LoadSupplierLedger(event.supplierId));
      AppSnackbar.success(CrmStrings.msgAdditionRecorded);
    } catch (e) { AppSnackbar.error('${CrmStrings.msgAdditionFailed}$e'); }
  }

  Future<void> _onDiscount(RecordSupplierDiscountNotice event, Emitter<SuppliersState> emit) async {
    try {
      await SupplierLedgerService.recordDiscountNotice(supplierId: event.supplierId, branchId: _branchId, amount: event.amount, createdBy: AuthService.currentUser?.id ?? '', notes: event.notes);
      add(LoadSupplierLedger(event.supplierId));
      AppSnackbar.success(CrmStrings.msgDiscountRecorded);
    } catch (e) { AppSnackbar.error('${CrmStrings.msgDiscountFailed}$e'); }
  }

  Future<void> _onCheckPayment(RecordSupplierCheckPayment event, Emitter<SuppliersState> emit) async {
    try {
      await SupplierLedgerService.recordCheckPayment(supplierId: event.supplierId, branchId: _branchId, amount: event.amount, createdBy: AuthService.currentUser?.id ?? '', checkNumber: event.checkNumber, bankName: event.bankName, dueDate: event.dueDate, notes: event.notes);
      add(LoadSupplierLedger(event.supplierId));
      AppSnackbar.success(CrmStrings.msgCheckPaymentRecorded);
    } catch (e) { AppSnackbar.error('${CrmStrings.msgCheckPaymentFailed}$e'); }
  }

  Future<void> _onCheckReceipt(RecordSupplierCheckReceipt event, Emitter<SuppliersState> emit) async {
    try {
      await SupplierLedgerService.recordCheckReceipt(supplierId: event.supplierId, branchId: _branchId, amount: event.amount, createdBy: AuthService.currentUser?.id ?? '', checkNumber: event.checkNumber, bankName: event.bankName, dueDate: event.dueDate, notes: event.notes);
      add(LoadSupplierLedger(event.supplierId));
      AppSnackbar.success(CrmStrings.msgCheckReceiptRecorded);
    } catch (e) { AppSnackbar.error('${CrmStrings.msgCheckReceiptFailed}$e'); }
  }

  void _onNextPage(NextSupplierPage event, Emitter<SuppliersState> emit) {
    if (state.currentPage < state.totalPages - 1) {
      final p = state.currentPage + 1;
      emit(state.copyWith(currentPage: p, pagedSuppliers: _paginate(state.filteredSuppliers, p)));
    }
  }

  void _onPrevPage(PreviousSupplierPage event, Emitter<SuppliersState> emit) {
    if (state.currentPage > 0) {
      final p = state.currentPage - 1;
      emit(state.copyWith(currentPage: p, pagedSuppliers: _paginate(state.filteredSuppliers, p)));
    }
  }

  void _onSort(UpdateSupplierSort event, Emitter<SuppliersState> emit) {
    final sorted = _sort(state.filteredSuppliers, event.columnId, event.ascending);
    emit(state.copyWith(sortColumnId: event.columnId, isSortAscending: event.ascending, filteredSuppliers: sorted, currentPage: 0, totalPages: _pages(sorted), pagedSuppliers: _paginate(sorted, 0)));
  }

  Future<void> _onExport(ExportSuppliers event, Emitter<SuppliersState> emit) async {
    try {
      await ExportService.exportSuppliersToXlsx(suppliers: state.allSuppliers);
      AppSnackbar.success(CrmStrings.msgExportSuccess);
    } catch (e) { AppSnackbar.error('${CrmStrings.msgExportFailed}$e'); }
  }

  void _onClearLedger(ClearSupplierLedger event, Emitter<SuppliersState> emit) {
    emit(state.copyWith(ledgerEntries: const [], clearSelected: true));
  }

  List<SupplierModel> _filter(List<SupplierModel> suppliers, String query) {
    if (query.isEmpty) return suppliers;
    final q = query.toLowerCase();
    return suppliers.where((s) =>
      s.name.toLowerCase().contains(q) ||
      (s.phone?.contains(q) ?? false) ||
      (s.email?.toLowerCase().contains(q) ?? false) ||
      (s.taxId?.contains(q) ?? false) ||
      (s.companyName?.toLowerCase().contains(q) ?? false)
    ).toList();
  }

  List<SupplierModel> _sort(List<SupplierModel> suppliers, String col, bool asc) {
    final sorted = List<SupplierModel>.from(suppliers);
    sorted.sort((a, b) {
      int cmp;
      switch (col) {
        case 'name': cmp = a.name.compareTo(b.name);
        case 'phone': cmp = (a.phone ?? '').compareTo(b.phone ?? '');
        case 'company': cmp = (a.companyName ?? '').compareTo(b.companyName ?? '');
        case 'balance': cmp = (state.balances[a.id] ?? 0).compareTo(state.balances[b.id] ?? 0);
        case 'creditLimit': cmp = a.creditLimit.compareTo(b.creditLimit);
        case 'discount': cmp = a.discountPercent.compareTo(b.discountPercent);
        case 'type': cmp = 0;
        case 'status': cmp = (a.isActive ? 0 : 1).compareTo(b.isActive ? 0 : 1);
        default: cmp = a.name.compareTo(b.name);
      }
      return asc ? cmp : -cmp;
    });
    return sorted;
  }

  List<SupplierModel> _paginate(List<SupplierModel> items, int page) {
    final start = page * SuppliersState.pageSize;
    final end = start + SuppliersState.pageSize;
    return items.sublist(start.clamp(0, items.length), end.clamp(0, items.length));
  }

  int _pages(List<SupplierModel> items) => (items.length / SuppliersState.pageSize).ceil().clamp(1, double.maxFinite.toInt());
}





