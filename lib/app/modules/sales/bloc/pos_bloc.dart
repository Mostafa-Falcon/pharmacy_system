import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:window_manager/window_manager.dart';

import 'package:pharmacy_system/app/core/models/inventory/medicine_model.dart';
import 'package:pharmacy_system/app/core/models/sales/quote_model.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/core/data/services/admin/branch_data_service.dart';
import 'package:pharmacy_system/app/core/data/services/sales/cashier_shift_service.dart';
import 'package:pharmacy_system/app/core/data/services/customer/customer_ledger_service.dart';
import 'package:pharmacy_system/app/core/data/services/customer/customer_service.dart';
import 'package:pharmacy_system/app/core/data/services/print_service.dart';
import 'package:pharmacy_system/app/core/data/services/print_settings_service.dart';
import 'package:pharmacy_system/app/core/data/services/sales/quote_service.dart';
import 'package:pharmacy_system/app/core/data/services/supplier/supplier_ledger_service.dart';
import 'package:pharmacy_system/app/core/data/services/supplier/supplier_service.dart';
import 'package:pharmacy_system/app/core/data/services/theme_service.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/reusables/feedback/app_snackbar.dart';
import 'package:pharmacy_system/app/core/utils/app_utils.dart';
import 'package:pharmacy_system/app/core/constants/app_strings.dart';
import 'package:pharmacy_system/app/core/injection.dart';
import 'package:pharmacy_system/app/core/data/database/daos/suspended_sales_dao.dart';
import 'package:pharmacy_system/app/core/data/database/database.dart';
import 'package:pharmacy_system/app/modules/sales/models/pos_cart_line.dart';
import 'package:pharmacy_system/app/modules/sales/services/sale_engine.dart';
import 'package:uuid/uuid.dart';
import 'package:pharmacy_system/app/core/data/services/sound_service.dart';
import 'package:pharmacy_system/app/core/models/base/correction_model.dart';
import 'package:pharmacy_system/app/core/data/services/accounting/correction_service.dart';
import 'package:pharmacy_system/app/core/sync/sync_service.dart';
import 'package:pharmacy_system/app/core/data/repositories/medicines_repository.dart';
import 'package:pharmacy_system/app/core/data/repositories/customers_repository.dart';
import 'package:pharmacy_system/app/core/data/repositories/suppliers_repository.dart';

import 'pos_event.dart';
import 'pos_state.dart';

export 'pos_event.dart';
export 'pos_state.dart';

class PosBloc extends Bloc<PosEvent, PosState> {
  PosBloc() : super(const PosState()) {
    on<PosInitialize>(_onInit);
    on<PosRefreshData>(_onRefreshData);
    on<PosLoadCatalog>(_onLoadCatalog);
    on<PosSearchChanged>(_onSearch);
    // ... باقي الـ handlers ...
    on<PosCategoryChanged>(_onCategory);
    on<PosAddMedicine>(_onAddMedicine);
    on<PosAddByBarcode>(_onAddByBarcode);
    on<PosIncrementLine>(_onIncrement);
    on<PosDecrementLine>(_onDecrement);
    on<PosUpdateLineQuantity>(_onUpdateQty);
    on<PosRemoveLine>(_onRemoveLine);
    on<PosUpdateLineDiscount>(_onUpdateLineDiscount);
    on<PosUpdateLinePrice>(_onUpdateLinePrice);
    on<PosUpdateLineUnit>(_onUpdateLineUnit);
    on<PosToggleFullScreen>(_onToggleFullScreen);
    on<PosToggleCatalog>(_onToggleCatalog);
    on<PosUpdateCatalogWidth>(_onUpdateCatalogWidth);
    on<PosClearCart>(_onClearCart);
    on<PosSetInvoiceDiscount>(_onSetInvoiceDiscount);
    on<PosSetInvoiceTax>(_onSetInvoiceTax);
    on<PosSetPaymentMode>(_onSetPaymentMode);
    on<PosCashChanged>(_onCashChanged);
    on<PosCardChanged>(_onCardChanged);
    on<PosSelectCustomer>(_onSelectCustomer);
    on<PosSelectSupplier>(_onSelectSupplier);
    on<PosNotesChanged>(_onNotesChanged);
    on<PosOpenShift>(_onOpenShift);
    on<PosRefreshShift>(_onRefreshShift);
    on<PosCloseShift>(_onCloseShift);
    on<PosCompleteSale>(_onCompleteSale);
    on<PosCompleteSaleCash>(_onCompleteSaleCash);
    on<PosCompleteSaleCard>(_onCompleteSaleCard);
    on<PosCompleteSaleMixed>(_onCompleteSaleMixed);
    on<PosCompleteSaleCredit>(_onCompleteSaleCredit);
    on<PosPrintLastInvoice>(_onPrintLastInvoice);
    on<PosSuspendSale>(_onSuspendSale);
    on<PosResumeSale>(_onResumeSale);
    on<PosDeleteSuspendedSale>(_onDeleteSuspendedSale);
    on<PosCreateQuoteFromCart>(_onCreateQuote);
    on<PosAddExpense>(_onAddExpense);
    on<PosLoadCustomerBalance>(_onLoadCustomerBalance);
    on<PosRecordCustomerPayment>(_onRecordCustomerPayment);
    on<PosLoadSupplierBalance>(_onLoadSupplierBalance);
    on<PosRecordSupplierPayment>(_onRecordSupplierPayment);
    on<PosEditSale>(_onEditSale);
    on<PosEditQuote>(_onEditQuote);
    on<PosRemoveSelectedLine>(_onRemoveSelectedLine);
    on<PosSetPriceGroup>(_onSetPriceGroup);
    on<PosTogglePrint>(_onTogglePrint);
  }

  static const _uuid = Uuid();

  String get _branchId => AuthService.currentBranchId ?? '';
  String get _cashierId => AuthService.currentUser?.id ?? '';
  String get userName => AuthService.currentUser?.name ?? GeneralStrings.defaultUserName;

  final List<StreamSubscription> _subscriptions = [];

  void observeTables(
    List<String> tables,
    FutureOr<void> Function() onUpdate, {
    String? branchId,
    Duration debounceDuration = const Duration(milliseconds: 300),
  }) {
    Timer? debounceTimer;
    _subscriptions.add(
      SyncService.tableUpdateStream.listen((update) {
        final table = update.$1;
        final bid = update.$2;
        if (tables.contains(table) && (branchId == null || bid == branchId || bid.isEmpty)) {
          debounceTimer?.cancel();
          debounceTimer = Timer(debounceDuration, () {
            onUpdate();
          });
        }
      }),
    );
  }

  @override
  Future<void> close() async {
    for (final s in _subscriptions) {
      await s.cancel();
    }
    return super.close();
  }

  bool get isPrintEnabledInSettings => PrintSettingsService.isPrintEnabled;

  void _warn(Emitter<PosState> emit, String message) {
    SoundService.instance.play(SoundEffect.error);
    AppSnackbar.warning(message);
    emit(state.copyWith(warning: message));
  }

  void _success(Emitter<PosState> emit, String message) {
    AppSnackbar.success(message);
    emit(state.copyWith(warning: null));
  }

  void _error(Emitter<PosState> emit, String message) {
    AppSnackbar.error(message);
    emit(state.copyWith(warning: message));
  }

  Future<void> _updateShiftSummary(Emitter<PosState> emit) async {
    final shift = state.currentShift;
    if (shift == null) {
      emit(state.copyWith(shiftSummary: const {}));
      return;
    }
    final summary = await CashierShiftService.getShiftSummary(shift.id);
    emit(state.copyWith(shiftSummary: summary));
  }

  Future<void> _onInit(PosInitialize event, Emitter<PosState> emit) async {
    // تفعيل المراقبة التفاعلية للجداول
    observeTables(
      ['medicines', 'sales', 'customers', 'suppliers', 'cashier_shifts'],
      () => add(const PosRefreshData()),
      branchId: _branchId,
    );

    await _loadInitialData(emit);
  }

  Future<void> _onRefreshData(
    PosRefreshData event,
    Emitter<PosState> emit,
  ) async {
    await _loadInitialData(emit);
  }

  Future<void> _loadInitialData(Emitter<PosState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      await CashierShiftService.refresh();
      final meds = await sl<MedicinesRepository>().getMedicines(
        branchId: _branchId,
      );
      final customers = await sl<CustomersRepository>().getCustomers();
      final suppliers = await sl<SuppliersRepository>().getSuppliers();

      final shift = CashierShiftService.findOpenShift(
        cashierId: _cashierId,
        branchId: _branchId,
      );

      Map<String, dynamic> summary = const {};
      if (shift != null) {
        summary = await CashierShiftService.getShiftSummary(shift.id);
      }

      final newState = state.copyWith(
        medicines: meds.where((m) => m.isActive && !m.isDeleted).toList(),
        isLoading: false,
        customers: customers,
        suppliers: suppliers,
        currentShift: shift,
        shiftSummary: summary,
        suspendedSales: await _readSuspended(),
        isPrintEnabled: PrintSettingsService.isPrintEnabled,
      );

      emit(_recompute(newState));
      await _loadRecentSales(emit);
    } catch (e) {
      safeDebugPrint('PosBloc._loadInitialData failed: $e');
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onLoadCatalog(
    PosLoadCatalog event,
    Emitter<PosState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final meds =
        BranchDataService.getMedicines(
            branchId: _branchId,
          ).where((m) => m.isActive && !m.isDeleted).toList()
          ..sort((a, b) => a.name.compareTo(b.name));
    emit(_recompute(state.copyWith(medicines: meds, isLoading: false)));
  }

  PosState _recompute(PosState s) {
    final now = DateTime.now();

    // Computed items
    final nearExpiry = s.medicines.where((m) {
      if (m.expiryDate == null) return false;
      final diff = m.expiryDate!.difference(now).inDays;
      return diff >= 0 && diff <= 30;
    }).toList()..sort((a, b) => a.expiryDate!.compareTo(b.expiryDate!));

    final lowStock = s.medicines.where((m) => m.quantity <= m.minStock).toList()
      ..sort((a, b) => a.quantity.compareTo(b.quantity));

    final cats =
        s.medicines.map((m) => m.category).whereType<String>().toSet().toList()
          ..sort();

    // Filtered list
    final q = s.searchQuery.trim().toLowerCase();
    final cat = s.selectedCategory;
    var filtered = s.medicines.toList();
    if (cat != null) {
      filtered = filtered.where((m) => m.category == cat).toList();
    }
    if (q.isNotEmpty) {
      filtered = filtered
          .where(
            (m) =>
                m.name.toLowerCase().contains(q) ||
                (m.nameEn?.toLowerCase().contains(q) ?? false) ||
                m.barcodes.any((b) => b.toLowerCase().contains(q)),
          )
          .toList();
    }

    filtered.sort((a, b) {
      final aExpired = a.expiryDate != null && a.expiryDate!.isBefore(now);
      final bExpired = b.expiryDate != null && b.expiryDate!.isBefore(now);
      if (aExpired && !bExpired) return -1;
      if (!aExpired && bExpired) return 1;
      if (a.expiryDate == null && b.expiryDate == null) return 0;
      if (a.expiryDate == null) return 1;
      if (b.expiryDate == null) return -1;
      return a.expiryDate!.compareTo(b.expiryDate!);
    });

    return s.copyWith(
      nearExpiryItems: nearExpiry,
      lowStockItems: lowStock,
      categories: cats,
      filteredMedicines: filtered,
    );
  }

  void _onSearch(PosSearchChanged event, Emitter<PosState> emit) {
    emit(_recompute(state.copyWith(searchQuery: event.query)));
  }

  void _onCategory(PosCategoryChanged event, Emitter<PosState> emit) {
    emit(_recompute(state.copyWith(selectedCategory: event.category)));
  }

  PosCartLine? _lineFor(String id) =>
      state.cart.where((l) => l.medicine.id == id).firstOrNull;

  int availableFor(MedicineModel medicine) {
    final inCart = state.cart
        .where((l) => l.medicine.id == medicine.id)
        .fold(0, (s, l) => s + l.quantity);
    return medicine.quantity - inCart;
  }

  void _onAddMedicine(PosAddMedicine event, Emitter<PosState> emit) {
    final medicine = event.medicine;
    final price = event.unit?.sellPrice ?? medicine.sellPrice;
    final factor = event.unit?.conversionFactor ?? 
                  (medicine.units.isNotEmpty ? medicine.units.first.conversionFactor : 1.0);
    
    final available = availableFor(medicine);
    if (available <= 0 && !medicine.allowNegativeStock) {
      _warn(
        emit,
        SalesStrings.posNoStockFormat(medicine.name, medicine.quantity.toString()),
      );
      return;
    }
    final existing = _lineFor(medicine.id);
    final newQty = existing != null ? existing.quantity + 1 : 1;
    if (existing != null && event.unit == null) {
      final updated = [...state.cart];
      updated[updated.indexOf(existing)] = existing.copyWith(quantity: newQty);
      emit(_recompute(state.copyWith(cart: updated, searchQuery: '')));
    } else {
      emit(
        _recompute(
          state.copyWith(
            cart: [
              ...state.cart,
              PosCartLine(
                medicine: medicine,
                quantity: 1,
                unitPrice: price,
                unitName: event.unit?.name,
                conversionFactor: factor,
              ),
            ],
            searchQuery: '',
          ),
        ),
      );
    }
    SoundService.instance.play(SoundEffect.itemAdded);
  }

  void _onAddByBarcode(PosAddByBarcode event, Emitter<PosState> emit) {
    final q = event.code.trim().toLowerCase();
    final medicine = state.medicines.firstWhereOrNull(
      (m) => m.barcodes.any((b) => b.toLowerCase() == q),
    );
    if (medicine == null) {
      _warn(emit, SalesStrings.posBarcodeNotFoundFormat(event.code));
      return;
    }
    add(PosAddMedicine(medicine));
  }

  void _onIncrement(PosIncrementLine event, Emitter<PosState> emit) {
    final line = _lineFor(event.id);
    if (line == null) return;
    final available = availableFor(line.medicine);
    if (available <= 0 && !line.medicine.allowNegativeStock) {
      _warn(
        emit,
        SalesStrings.posNoStockFormat(line.medicine.name, line.medicine.quantity.toString()),
      );
      return;
    }
    final updated = [...state.cart];
    updated[updated.indexOf(line)] = line.copyWith(quantity: line.quantity + 1);
    emit(state.copyWith(cart: updated));
  }

  void _onDecrement(PosDecrementLine event, Emitter<PosState> emit) {
    final line = _lineFor(event.id);
    if (line == null) return;
    if (line.quantity <= 1) {
      add(PosRemoveLine(event.id));
    } else {
      final updated = [...state.cart];
      updated[updated.indexOf(line)] = line.copyWith(
        quantity: line.quantity - 1,
      );
      emit(state.copyWith(cart: updated));
    }
  }

  void _onUpdateQty(PosUpdateLineQuantity event, Emitter<PosState> emit) {
    final line = _lineFor(event.id);
    if (line == null) return;
    if (event.quantity <= 0) {
      add(PosRemoveLine(event.id));
      return;
    }
    final inCartOther = state.cart
        .where((l) => l.medicine.id == event.id && l != line)
        .fold(0, (s, l) => s + l.quantity);
    final available = line.medicine.quantity - inCartOther;
    if (event.quantity > available && !line.medicine.allowNegativeStock) {
      _warn(
        emit,
        SalesStrings.posNoStockFormat(line.medicine.name, available.toString()),
      );
      return;
    }
    final updated = [...state.cart];
    updated[updated.indexOf(line)] = line.copyWith(quantity: event.quantity);
    emit(state.copyWith(cart: updated));
  }

  void _onRemoveLine(PosRemoveLine event, Emitter<PosState> emit) {
    final newCart = state.cart.where((l) => l.medicine.id != event.id).toList();
    emit(_recompute(state.copyWith(cart: newCart)));
    SoundService.instance.play(SoundEffect.itemRemoved);
  }

  void _onUpdateLineDiscount(
    PosUpdateLineDiscount event,
    Emitter<PosState> emit,
  ) {
    final line = _lineFor(event.id);
    if (line == null) return;
    final clamped = event.percent.clamp(0, 100).toDouble();
    final updated = [...state.cart];
    updated[updated.indexOf(line)] = line.copyWith(discountPercent: clamped);
    emit(state.copyWith(cart: updated));
  }

  void _onUpdateLinePrice(PosUpdateLinePrice event, Emitter<PosState> emit) {
    final line = _lineFor(event.id);
    if (line == null) return;
    if (event.price <= 0) return;
    final updated = [...state.cart];
    updated[updated.indexOf(line)] = line.copyWith(unitPrice: event.price);
    emit(state.copyWith(cart: updated));
  }

  void _onUpdateLineUnit(PosUpdateLineUnit event, Emitter<PosState> emit) {
    final line = _lineFor(event.medicineId);
    if (line == null) return;
    final unit = line.medicine.units.firstWhereOrNull(
      (u) => u.name == event.unitName,
    );
    final price = unit?.sellPrice ?? line.medicine.sellPrice;
    final factor = unit?.conversionFactor ?? 1.0;
    
    final updated = [...state.cart];
    updated[updated.indexOf(line)] = line.copyWith(
      unitName: event.unitName,
      unitPrice: price,
      conversionFactor: factor,
    );
    emit(state.copyWith(cart: updated));
  }

  Future<void> _onToggleFullScreen(
    PosToggleFullScreen event,
    Emitter<PosState> emit,
  ) async {
    final full = !state.isFullScreen;
    emit(state.copyWith(isFullScreen: full));

    try {
      if (ThemeService.instance.isDesktop) {
        await windowManager.setFullScreen(full);
      } else {
        if (full) {
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
        } else {
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        }
      }
    } catch (e) {
      safeDebugPrint('FullScreen toggle failed: $e');
    }
  }

  void _onToggleCatalog(PosToggleCatalog event, Emitter<PosState> emit) {
    emit(state.copyWith(showProducts: !state.showProducts));
  }

  void _onUpdateCatalogWidth(
    PosUpdateCatalogWidth event,
    Emitter<PosState> emit,
  ) {
    emit(state.copyWith(catalogWidth: event.width));
  }

  void _onClearCart(PosClearCart event, Emitter<PosState> emit) {
    emit(
      state.copyWith(
        cart: const [],
        searchQuery: '',
        invoiceDiscount: 0,
        invoiceTax: 0,
        selectedCustomerId: null,
        notes: '',
        paymentMode: PaymentMode.cash,
        cashAmount: 0,
        cardAmount: 0,
      ),
    );
  }

  void _onSetInvoiceDiscount(
    PosSetInvoiceDiscount event,
    Emitter<PosState> emit,
  ) {
    if (event.isPercentage) {
      final amount = state.subtotal * (event.value / 100);
      emit(state.copyWith(invoiceDiscount: amount.clamp(0, state.subtotal)));
    } else {
      emit(
        state.copyWith(invoiceDiscount: event.value.clamp(0, state.subtotal)),
      );
    }
  }

  void _onSetInvoiceTax(PosSetInvoiceTax event, Emitter<PosState> emit) {
    if (event.isPercentage) {
      final amount =
          (state.subtotal - state.totalDiscount) * (event.value / 100);
      emit(state.copyWith(invoiceTax: amount.clamp(0, double.infinity)));
    } else {
      emit(state.copyWith(invoiceTax: event.value.clamp(0, double.infinity)));
    }
  }

  void _onSetPaymentMode(PosSetPaymentMode event, Emitter<PosState> emit) {
    var mode = event.mode;
    if (mode == PaymentMode.credit && state.selectedCustomerId == null) {
      _warn(emit, SalesStrings.posCreditNeedsCustomer);
      return;
    }
    double cash = state.cashAmount;
    double card = state.cardAmount;
    if (mode == PaymentMode.cash) {
      cash = state.grandTotal;
      card = 0;
    } else if (mode == PaymentMode.card) {
      card = state.grandTotal;
      cash = 0;
    }
    emit(state.copyWith(paymentMode: mode, cashAmount: cash, cardAmount: card));
  }

  void _onCashChanged(PosCashChanged event, Emitter<PosState> emit) {
    emit(state.copyWith(cashAmount: event.value));
  }

  void _onCardChanged(PosCardChanged event, Emitter<PosState> emit) {
    emit(state.copyWith(cardAmount: event.value));
  }

  void _onSelectCustomer(PosSelectCustomer event, Emitter<PosState> emit) {
    emit(state.copyWith(selectedCustomerId: event.customerId));
  }

  void _onSelectSupplier(PosSelectSupplier event, Emitter<PosState> emit) {
    emit(state.copyWith(selectedSupplierId: event.supplierId));
  }

  void _onNotesChanged(PosNotesChanged event, Emitter<PosState> emit) {
    emit(state.copyWith(notes: event.notes));
  }

  Future<void> _onOpenShift(PosOpenShift event, Emitter<PosState> emit) async {
    final shift = await CashierShiftService.openShift(
      openingCash: event.openingCash,
      branchId: _branchId,
    );
    await CashierShiftService.refresh();
    emit(state.copyWith(currentShift: shift));
    await _updateShiftSummary(emit);
    _success(emit, SalesStrings.posShiftOpenedFormat(shift.shiftNumber.toString()));
  }

  Future<void> _onRefreshShift(PosRefreshShift event, Emitter<PosState> emit) async {
    await CashierShiftService.refresh();
    final shift = CashierShiftService.findOpenShift(
      cashierId: _cashierId,
      branchId: _branchId,
    );
    emit(state.copyWith(currentShift: shift));
    await _updateShiftSummary(emit);
  }

  Future<void> _onCloseShift(
    PosCloseShift event,
    Emitter<PosState> emit,
  ) async {
    final shift = state.currentShift;
    if (shift == null) {
      _warn(emit, SalesStrings.posShiftNotFound);
      return;
    }
    try {
      final closed = await CashierShiftService.closeShift(
        shiftId: shift.id,
        countedCash: event.countedCash,
        notes: event.notes,
      );
      emit(state.copyWith(currentShift: closed));
      _success(
        emit,
        SalesStrings.posShiftClosedFormat(shift.shiftNumber.toString(), closed.difference?.toStringAsFixed(2) ?? '0'),
      );
    } catch (e) {
      _error(emit, SalesStrings.posShiftCloseFailedFormat(e.toString()));
    }
  }

  String _paymentMethodString() {
    switch (state.paymentMode) {
      case PaymentMode.cash:
        return 'cash';
      case PaymentMode.card:
        return 'card';
      case PaymentMode.mixed:
        return 'mixed';
      case PaymentMode.credit:
        return 'credit';
    }
  }

  Future<void> _onCompleteSale(
    PosCompleteSale event,
    Emitter<PosState> emit,
  ) async {
    if (!state.canComplete) return;
    if (state.currentShift == null) {
      _warn(emit, SalesStrings.posShiftRequired);
      return;
    }
    emit(state.copyWith(isProcessing: true));
    try {
      final customer = state.selectedCustomerId != null
          ? CustomerService.getById(state.selectedCustomerId!)
          : null;
      if (state.paymentMode == PaymentMode.credit && customer == null) {
        _warn(emit, SalesStrings.posCreditNeedsCustomer);
        emit(state.copyWith(isProcessing: false));
        return;
      }

      // فحص دقة المبالغ المدفوعة في حالة الدفع المختلط
      if (state.paymentMode == PaymentMode.mixed) {
        final totalPaid = state.cashAmount + state.cardAmount;
        if ((totalPaid - state.grandTotal).abs() > 0.01) {
          _warn(emit, SalesStrings.paymentMismatch.replaceFirst('%s', totalPaid.toStringAsFixed(2)).replaceFirst('%s', state.grandTotal.toStringAsFixed(2)));
          emit(state.copyWith(isProcessing: false));
          return;
        }
      }

      // تنفيذ المبيعة في محرك المبيعات
      final sale = await SaleEngine.execute(
        cart: state.cart.toList(),
        subtotal: state.subtotal,
        totalDiscount: state.totalDiscount,
        grandTotal: state.grandTotal,
        paymentMethod: _paymentMethodString(),
        customerId: customer?.id,
        customerName: customer?.name,
        notes: state.notes,
        cashierId: _cashierId,
        branchId: _branchId,
        paidTotal: state.paidTotal,
        shiftId: state.currentShift?.id ?? '', // إصلاح الـ String?
        onWarning: (msg) => _warn(emit, msg),
      );

      // تحديث الحالة بنجاح العملية
      final recent = [sale, ...state.recentSales.take(4)];
      emit(
        state.copyWith(
          lastInvoice: sale,
          recentSales: recent,
          isProcessing: false,
        ),
      );

      // تحديث ملخص الوردية فوراً بعد البيع
      await _updateShiftSummary(emit);

      // مسح السلة فوراً
      add(const PosClearCart());

      // تحديث قائمة الأدوية عشان تظهر الكميات الجديدة بعد الخصم
      add(const PosLoadCatalog());

      // الطباعة (إذا كانت مفعلة في الإعدادات وفي شاشة الكاشير)
      if (state.isPrintEnabled && PrintSettingsService.isPrintEnabled) {
        add(const PosPrintLastInvoice());
      }

      _success(emit, SalesStrings.posSaleSuccessFormat(sale.receiptNumber ?? ''));
    } catch (e) {
      safeDebugPrint('PosBloc: Sale execution failed: $e');
      SoundService.instance.play(SoundEffect.saleError);
      _error(
        emit,
        SalesStrings.posSaleFailedFormat(e.toString().replaceAll('Exception: ', '')),
      );
      emit(state.copyWith(isProcessing: false));
    }
  }

  Future<void> _onCompleteSaleCash(
    PosCompleteSaleCash event,
    Emitter<PosState> emit,
  ) async {
    add(const PosSetPaymentMode(PaymentMode.cash));
    add(const PosCompleteSale());
  }

  Future<void> _onCompleteSaleCard(
    PosCompleteSaleCard event,
    Emitter<PosState> emit,
  ) async {
    add(const PosSetPaymentMode(PaymentMode.card));
    add(const PosCompleteSale());
  }

  Future<void> _onCompleteSaleMixed(
    PosCompleteSaleMixed event,
    Emitter<PosState> emit,
  ) async {
    add(const PosSetPaymentMode(PaymentMode.mixed));
    emit(
      state.copyWith(
        cashAmount: state.grandTotal / 2,
        cardAmount: state.grandTotal - state.grandTotal / 2,
      ),
    );
    add(const PosCompleteSale());
  }

  Future<void> _onCompleteSaleCredit(
    PosCompleteSaleCredit event,
    Emitter<PosState> emit,
  ) async {
    add(const PosSetPaymentMode(PaymentMode.credit));
    add(const PosCompleteSale());
  }

  Future<void> _onPrintLastInvoice(
    PosPrintLastInvoice event,
    Emitter<PosState> emit,
  ) async {
    final invoice = state.lastInvoice;
    if (invoice == null) return;
    try {
      await PrintService.printSalesInvoice(invoice);
    } catch (e) {
      // تنبيه بسيط وليس خطأ قاتل لأن الطباعة اختيارية
      safeDebugPrint('Print failed: $e');
      _warn(
        emit,
        SalesStrings.posPrintWarningFormat(e.toString().split(':').last.trim()),
      );
    }
  }

  Future<List<Map<String, dynamic>>> _readSuspended() async {
    final dao = sl<SuspendedSalesDao>();
    final rows = await dao.getByBranch(_branchId);
    final items = rows.map(_suspendedRowToMap).toList();
    items.sort((a, b) {
      final aTime = a['created_at'] as String? ?? '';
      final bTime = b['created_at'] as String? ?? '';
      return bTime.compareTo(aTime);
    });
    return items;
  }

  Map<String, dynamic> _suspendedRowToMap(SuspendedSalesTableData row) => {
    'id': row.id,
    'items': jsonDecode(row.items),
    'subtotal': row.subtotal,
    'discount': row.discount,
    'total': row.total,
    'notes': row.notes,
    'created_at': row.createdAt.toIso8601String(),
  };

  Future<void> _onSuspendSale(
    PosSuspendSale event,
    Emitter<PosState> emit,
  ) async {
    if (state.cart.isEmpty) {
      _warn(emit, SalesStrings.posCartEmpty);
      return;
    }
    final dao = sl<SuspendedSalesDao>();
    final id = _uuid.v4();
    final now = DateTime.now();
    final items = jsonEncode(
      state.cart
          .map(
            (l) => {
              'medicine_id': l.medicine.id,
              'medicine_name': l.medicine.name,
              'quantity': l.quantity,
              'unit_price': l.unitPrice,
              'discount_percent': l.discountPercent,
            },
          )
          .toList(),
    );
    await dao.upsert(
      SuspendedSalesTableCompanion(
        id: Value(id),
        branchId: Value(_branchId),
        items: Value(items),
        subtotal: Value(state.subtotal),
        discount: Value(state.totalDiscount),
        total: Value(state.grandTotal),
        notes: Value(state.notes),
        createdAt: Value(now),
        isDeleted: const Value(false),
      ),
    );
    add(const PosClearCart());
    emit(state.copyWith(suspendedSales: await _readSuspended()));
    _success(emit, SalesStrings.posSaleSuspended);
  }

  Future<void> _onResumeSale(
    PosResumeSale event,
    Emitter<PosState> emit,
  ) async {
    final items = event.suspended['items'] as List<dynamic>;
    final cart = [...state.cart];
    for (final item in items) {
      final medicine = state.medicines.firstWhereOrNull(
        (m) => m.id == item['medicine_id'],
      );
      if (medicine == null) continue;
      final qty = (item['quantity'] as num).toInt();
      final idx = cart.indexWhere((l) => l.medicine.id == medicine.id);
      if (idx >= 0) {
        cart[idx] = cart[idx].copyWith(quantity: cart[idx].quantity + qty);
      } else {
        cart.add(
          PosCartLine(
            medicine: medicine,
            quantity: qty,
            unitPrice: (item['unit_price'] as num?)?.toDouble(),
            discountPercent:
                (item['discount_percent'] as num?)?.toDouble() ?? 0,
          ),
        );
      }
    }
    emit(
      state.copyWith(
        cart: cart,
        notes: event.suspended['notes'] as String? ?? state.notes,
      ),
    );
    if (event.deleteAfter) {
      await sl<SuspendedSalesDao>().softDelete(event.suspended['id']);
      emit(state.copyWith(suspendedSales: await _readSuspended()));
    }
    _success(emit, SalesStrings.posSaleResumed);
  }

  Future<void> _onDeleteSuspendedSale(
    PosDeleteSuspendedSale event,
    Emitter<PosState> emit,
  ) async {
    await sl<SuspendedSalesDao>().softDelete(event.id);
    emit(state.copyWith(suspendedSales: await _readSuspended()));
  }

  Future<void> _onCreateQuote(
    PosCreateQuoteFromCart event,
    Emitter<PosState> emit,
  ) async {
    if (state.cart.isEmpty) {
      _warn(emit, SalesStrings.posCartEmptyForQuote);
      return;
    }
    final customerName = state.selectedCustomerId != null
        ? (CustomerService.getById(state.selectedCustomerId!)?.name ?? '')
        : '';
    final items = state.cart
        .map(
          (l) => {
            'name': l.medicine.name,
            'qty': l.quantity,
            'unit_price': l.unitPrice,
            'total': l.lineTotal,
          },
        )
        .toList();
    await QuoteService.create(
      customerName: customerName.isNotEmpty ? customerName : SalesStrings.posCashCustomer,
      notes: state.notes,
      items: items,
      subtotal: state.subtotal,
      discount: state.totalDiscount,
      total: state.grandTotal,
    );
    add(const PosClearCart());
    _success(emit, SalesStrings.posQuoteCreated);
  }

  Future<void> _onAddExpense(
    PosAddExpense event,
    Emitter<PosState> emit,
  ) async {
    final shift = state.currentShift;
    if (shift == null) {
      _warn(emit, SalesStrings.posShiftRequired);
      return;
    }
    CorrectionService.record(
      referenceType: CorrectionReferenceType.shift,
      referenceId: shift.id,
      action: CorrectionAction.modified,
      details:
          SalesStrings.posExpenseRecordedFormat(shift.shiftNumber.toString(), event.description, event.amount.toString()),
    );
    _success(emit, SalesStrings.posExpenseLogged);
  }

  Future<void> _onLoadCustomerBalance(
    PosLoadCustomerBalance event,
    Emitter<PosState> emit,
  ) async {
    final bal = await CustomerLedgerService.getCustomerBalance(
      event.customerId,
      _branchId,
    );
    emit(state.copyWith(customerBalance: bal));
  }

  Future<void> _onRecordCustomerPayment(
    PosRecordCustomerPayment event,
    Emitter<PosState> emit,
  ) async {
    final customer = CustomerService.getById(event.customerId);
    if (customer == null) {
      _warn(emit, SalesStrings.posCustomerNotFound);
      return;
    }
    try {
      await CustomerLedgerService.recordCustomerPayment(
        customerId: event.customerId,
        branchId: _branchId,
        amount: event.amount,
        createdBy: _cashierId,
        notes: event.notes,
      );
      emit(
        state.copyWith(
          customerBalance: await CustomerLedgerService.getCustomerBalance(
            event.customerId,
            _branchId,
          ),
        ),
      );
      _success(
        emit,
        SalesStrings.posCustomerPaymentFormat(customer.name, event.amount.toString()),
      );
    } catch (e) {
      _error(emit, e.toString());
    }
  }

  Future<void> _onLoadSupplierBalance(
    PosLoadSupplierBalance event,
    Emitter<PosState> emit,
  ) async {
    final bal = await SupplierLedgerService.getSupplierBalance(
      event.supplierId,
      _branchId,
    );
    emit(state.copyWith(supplierBalance: bal));
  }

  Future<void> _onRecordSupplierPayment(
    PosRecordSupplierPayment event,
    Emitter<PosState> emit,
  ) async {
    final supplier = SupplierService.getById(event.supplierId);
    if (supplier == null) {
      _warn(emit, SalesStrings.posSupplierNotFound);
      return;
    }
    try {
      await SupplierLedgerService.recordSupplierPayment(
        supplierId: event.supplierId,
        branchId: _branchId,
        amount: event.amount,
        createdBy: _cashierId,
        notes: event.notes,
      );
      emit(
        state.copyWith(
          supplierBalance: await SupplierLedgerService.getSupplierBalance(
            event.supplierId,
            _branchId,
          ),
        ),
      );
      _success(
        emit,
        SalesStrings.posSupplierPaymentFormat(supplier.name, event.amount.toString()),
      );
    } catch (e) {
      _error(emit, e.toString());
    }
  }

  Future<void> _loadRecentSales(Emitter<PosState> emit) async {
    final sales = BranchDataService.getSales(branchId: _branchId)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    emit(state.copyWith(recentSales: sales.take(5).toList()));
  }

  double get shiftProfit {
    final shift = state.currentShift;
    if (shift == null) return 0;
    final medById = {for (final m in state.medicines) m.id: m};
    final sales = BranchDataService.getSales(branchId: _branchId)
        .where(
          (s) =>
              !s.isDeleted &&
              s.createdAt.isAfter(shift.openedAt) &&
              (shift.closedAt == null || s.createdAt.isBefore(shift.closedAt!)),
        )
        .toList();
    double cost = 0;
    for (final sale in sales) {
      for (final item in sale.items) {
        final med = medById[item.medicineId];
        if (med != null) cost += med.buyPrice * item.quantity;
      }
    }
    final revenue = sales.fold(0.0, (sum, s) => sum + s.finalAmount);
    return double.parse((revenue - cost).toStringAsFixed(2));
  }

  // تم حذف الـ Getters القديمة التي كانت تسبب أخطاء Future في الـ UI

  Future<void> _onEditSale(PosEditSale event, Emitter<PosState> emit) async {
    add(const PosClearCart());
    emit(
      state.copyWith(
        selectedCustomerId: event.sale.customerId,
        notes: event.sale.notes ?? '',
        invoiceDiscount: event.sale.discount ?? 0,
      ),
    );
    final cart = <PosCartLine>[];
    for (final item in event.sale.items) {
      final medicine = state.medicines.firstWhereOrNull(
        (m) => m.id == item.medicineId,
      );
      if (medicine != null) {
        cart.add(
          PosCartLine(
            medicine: medicine,
            quantity: item.quantity,
            unitPrice: item.unitPrice,
          ),
        );
      }
    }
    emit(state.copyWith(cart: cart));
    await BranchDataService.voidSale(event.sale.id, branchId: _branchId);
    _loadRecentSales(emit);
    _success(emit, SalesStrings.posEditSaleLoaded);
  }

  Future<void> _onEditQuote(PosEditQuote event, Emitter<PosState> emit) async {
    final quote = event.quote as QuoteModel;
    add(const PosClearCart());
    emit(
      state.copyWith(notes: quote.notes ?? '', invoiceDiscount: quote.discount),
    );
    final customer = state.customers.firstWhereOrNull(
      (c) => c.name == quote.customerName,
    );
    if (customer != null) emit(state.copyWith(selectedCustomerId: customer.id));
    final cart = <PosCartLine>[];
    for (final item in quote.items) {
      final medName = item['name'] as String;
      final qty = (item['qty'] as num).toInt();
      final unitPrice = (item['unit_price'] as num).toDouble();
      final medicine = state.medicines.firstWhereOrNull(
        (m) => m.name == medName,
      );
      if (medicine != null) {
        cart.add(
          PosCartLine(medicine: medicine, quantity: qty, unitPrice: unitPrice),
        );
      }
    }
    emit(state.copyWith(cart: cart));
    await QuoteService.softDelete(quote.id);
    _success(emit, SalesStrings.posEditQuoteLoaded);
  }

  Future<void> _onRemoveSelectedLine(
    PosRemoveSelectedLine event,
    Emitter<PosState> emit,
  ) async {
    if (state.cart.isEmpty) return;
    // نحذف آخر سطر في السلة (سلوك Ctrl+D الشائع في الـ POS).
    final last = state.cart.last;
    final updated = List<PosCartLine>.from(state.cart);
    updated.remove(last);
    emit(state.copyWith(cart: updated));
  }

  void _onSetPriceGroup(PosSetPriceGroup event, Emitter<PosState> emit) {
    emit(state.copyWith(selectedPriceGroup: event.priceGroup));
  }

  void _onTogglePrint(PosTogglePrint event, Emitter<PosState> emit) {
    final newVal = !state.isPrintEnabled;
    PrintSettingsService.isPrintEnabled = newVal; // حفظ الإعداد في الـ Hive
    emit(state.copyWith(isPrintEnabled: newVal));
    _success(
      emit,
      newVal ? SalesStrings.posAutoPrintEnabled : SalesStrings.posAutoPrintDisabled,
    );
  }
}









