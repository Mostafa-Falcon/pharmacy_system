import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:pharmacy_system/app/modules/contacts/supplier_customers/services/supplier_customer_service.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/core/data/services/admin/branch_data_service.dart';
import 'package:pharmacy_system/app/core/data/services/accounting/correction_service.dart';
import 'package:pharmacy_system/app/core/domain/models/base/correction_model.dart';
import 'package:pharmacy_system/app/core/data/services/operations/export_service.dart';
import 'package:pharmacy_system/app/core/data/services/supplier/supplier_ledger_service.dart';
import 'package:pharmacy_system/app/core/data/services/supplier/supplier_service.dart';
import 'package:pharmacy_system/app/core/data/services/inventory/stock_mutation_service.dart';
import 'package:pharmacy_system/app/core/data/services/sound_service.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/reusables/feedback/app_snackbar.dart';
import 'package:pharmacy_system/app/core/data/repositories/purchases_repository.dart';
import 'package:pharmacy_system/app/modules/sales/models/purchase_model.dart';
import '../../../core/injection.dart';
import 'purchases_event.dart';
import 'purchases_state.dart';

class PurchasesBloc extends Bloc<PurchasesEvent, PurchasesState> {
  static final _uuid = Uuid();
  StreamSubscription? _subscription;
  StreamSubscription? _vendorsSubscription;

  String get _branchId => AuthService.currentBranchId ?? '';

  PurchasesBloc() : super(PurchasesState()) {
    on<LoadPurchases>(_onLoad);
    on<SearchPurchases>(_onSearch);
    on<SetPurchasesFilter>(_onSetFilter);
    on<SetPurchaseDateFrom>(_onSetDateFrom);
    on<SetPurchaseDateTo>(_onSetDateTo);
    on<AddPurchaseLine>(_onAddLine);
    on<UpdatePurchaseLineQuantity>(_onUpdateQty);
    on<UpdatePurchaseLineUnitPrice>(_onUpdatePrice);
    on<UpdatePurchaseLineDiscount>(_onUpdateDiscount);
    on<UpdatePurchaseLineTax>(_onUpdateTax);
    on<UpdatePurchaseLineBatch>(_onUpdateBatch);
    on<UpdatePurchaseLineExpiry>(_onUpdateExpiry);
    on<UpdatePurchaseLineUnit>(_onUpdateUnit);
    on<RemovePurchaseLine>(_onRemoveLine);
    on<SetPurchaseSupplier>(_onSetSupplier);
    on<SetPurchaseSourceType>(_onSetSourceType);
    on<SetPurchasePaymentMethod>(_onSetPaymentMethod);
    on<SetPurchasePaymentDate>(_onSetPaymentDate);
    on<SetPurchaseInvoiceDiscount>(_onSetInvoiceDiscount);
    on<SetPurchaseInvoiceTax>(_onSetInvoiceTax);
    on<SetPurchaseShipping>(_onSetShipping);
    on<SetPurchaseDelivery>(_onSetDelivery);
    on<SetPurchasePaidAmount>(_onSetPaidAmount);
    on<SetPurchasePaymentAccount>(_onSetPaymentAccount);
    on<UpdatePurchaseLineSellPrice>(_onUpdateSellPrice);
    on<SetPurchaseNotes>(_onSetNotes);
    on<PayInFull>(_onPayInFull);
    on<SubmitPurchase>(_onSubmit);
    on<VoidPurchase>(_onVoid);
    on<ExportPurchasesCsv>(_onExportCsv);
    on<LoadPurchaseForEdit>(_onLoadForEdit);
    on<ResetPurchaseForm>(_onResetForm);
    on<SetPurchaseReferenceNumber>(_onSetReferenceNumber);
    on<SetPurchaseStatus>(_onSetStatus);
    on<SetPurchaseDate>(_onSetDate);
    on<SetPurchasePaymentTerm>(_onSetPaymentTerm);
    on<LoadReferenceData>(_onLoadReferenceData);

    // اشتراك لحظي في تحديثات المشتريات
    _subscription = sl<PurchasesRepository>().watchPurchases(_branchId).listen((_) {
      if (!isClosed) add(const LoadPurchases());
    });

    // ذكاء مهندسة: مراقبة حية للموردين لضمان تحديث القائمة فوراً
    _vendorsSubscription = SupplierCustomerService.watchAll().listen((_) {
       if (!isClosed) add(const LoadReferenceData());
    });

    add(const LoadPurchases());
    add(const LoadReferenceData());
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    _vendorsSubscription?.cancel();
    return super.close();
  }

  Future<void> _onLoadReferenceData(LoadReferenceData event, Emitter<PurchasesState> emit) async {
    final list = <Map<String, String>>[];
    
    // 1. الموردين العاديين
    final suppliers = SupplierService.getAll();
    for (final s in suppliers) {
      list.add({'id': s.id, 'name': s.name, 'type': 'supplier'});
    }
    
    // 2. العملاء/الموردين الموحدين
    final contacts = SupplierCustomerService.getAll();
    for (final sc in contacts) {
      list.add({'id': sc.id, 'name': sc.name, 'type': 'contact'});
    }
    
    emit(state.copyWith(vendors: list));
  }

  void _onSetReferenceNumber(SetPurchaseReferenceNumber event, Emitter<PurchasesState> emit) {
    emit(state.copyWith(referenceNumber: event.reference));
  }

  void _onSetStatus(SetPurchaseStatus event, Emitter<PurchasesState> emit) {
    emit(state.copyWith(purchaseStatus: event.status));
  }

  void _onSetDate(SetPurchaseDate event, Emitter<PurchasesState> emit) {
    emit(state.copyWith(purchaseDate: event.date));
  }

  void _onSetPaymentTerm(SetPurchasePaymentTerm event, Emitter<PurchasesState> emit) {
    emit(state.copyWith(
      paymentTerm: event.term,
      paymentTermUnit: event.unit ?? state.paymentTermUnit,
    ));
  }

  Future<void> _onLoad(LoadPurchases event, Emitter<PurchasesState> emit) async {
    emit(state.copyWith(status: PurchasesStatus.loading));
    try {
      final all = BranchDataService.getPurchases(branchId: _branchId);
      final sorted = all.where((p) => !p.isDeleted).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      final filtered = _applyFilters(sorted, state.searchQuery, state.selectedFilter, state.dateFrom, state.dateTo);
      emit(state.copyWith(status: PurchasesStatus.loaded, allPurchases: sorted, filteredPurchases: filtered));
    } catch (e) {
      emit(state.copyWith(status: PurchasesStatus.error, error: e.toString()));
    }
  }

  void _onSearch(SearchPurchases event, Emitter<PurchasesState> emit) {
    final filtered = _applyFilters(state.allPurchases, event.query, state.selectedFilter, state.dateFrom, state.dateTo);
    emit(state.copyWith(searchQuery: event.query, filteredPurchases: filtered));
  }

  void _onSetFilter(SetPurchasesFilter event, Emitter<PurchasesState> emit) {
    final filtered = _applyFilters(state.allPurchases, state.searchQuery, event.filter, state.dateFrom, state.dateTo);
    emit(state.copyWith(selectedFilter: event.filter, filteredPurchases: filtered));
  }

  void _onSetDateFrom(SetPurchaseDateFrom event, Emitter<PurchasesState> emit) {
    final filtered = _applyFilters(state.allPurchases, state.searchQuery, state.selectedFilter, event.date, state.dateTo);
    emit(state.copyWith(dateFrom: event.date, filteredPurchases: filtered, clearDateFrom: event.date == null));
  }

  void _onSetDateTo(SetPurchaseDateTo event, Emitter<PurchasesState> emit) {
    final filtered = _applyFilters(state.allPurchases, state.searchQuery, state.selectedFilter, state.dateFrom, event.date);
    emit(state.copyWith(dateTo: event.date, filteredPurchases: filtered, clearDateTo: event.date == null));
  }

  void _onAddLine(AddPurchaseLine event, Emitter<PurchasesState> emit) {
    final line = PurchaseLine(
      medicineId: event.medicineId, medicineName: event.medicineName,
      quantity: event.quantity, unitPrice: event.unitPrice,
      batchNumber: event.batchNumber, expiryDate: event.expiryDate,
      discount: event.discount, discountType: event.discountType ?? '%',
      taxAmount: event.taxAmount, taxType: event.taxType ?? 'fixed',
      unitId: event.unitId, unitName: event.unitName,
      units: event.units,
    );
    emit(state.copyWith(receiptLines: [...state.receiptLines, line]));
  }

  void _onUpdateQty(UpdatePurchaseLineQuantity event, Emitter<PurchasesState> emit) {
    final lines = List<PurchaseLine>.from(state.receiptLines);
    if (event.index >= 0 && event.index < lines.length) {
      lines[event.index].quantity = event.quantity;
      emit(state.copyWith(receiptLines: lines));
    }
  }

  void _onUpdatePrice(UpdatePurchaseLineUnitPrice event, Emitter<PurchasesState> emit) {
    final lines = List<PurchaseLine>.from(state.receiptLines);
    if (event.index >= 0 && event.index < lines.length) {
      lines[event.index].unitPrice = event.unitPrice;
      emit(state.copyWith(receiptLines: lines));
    }
  }

  void _onUpdateDiscount(UpdatePurchaseLineDiscount event, Emitter<PurchasesState> emit) {
    final lines = List<PurchaseLine>.from(state.receiptLines);
    if (event.index >= 0 && event.index < lines.length) {
      lines[event.index].discount = event.discount;
      if (event.discountType != null) lines[event.index].discountType = event.discountType;
      emit(state.copyWith(receiptLines: lines));
    }
  }

  void _onUpdateTax(UpdatePurchaseLineTax event, Emitter<PurchasesState> emit) {
    final lines = List<PurchaseLine>.from(state.receiptLines);
    if (event.index >= 0 && event.index < lines.length) {
      lines[event.index].taxAmount = event.tax;
      if (event.taxType != null) lines[event.index].taxType = event.taxType;
      emit(state.copyWith(receiptLines: lines));
    }
  }

  void _onUpdateBatch(UpdatePurchaseLineBatch event, Emitter<PurchasesState> emit) {
    final lines = List<PurchaseLine>.from(state.receiptLines);
    if (event.index >= 0 && event.index < lines.length) {
      lines[event.index].batchNumber = event.batch;
      emit(state.copyWith(receiptLines: lines));
    }
  }

  void _onUpdateExpiry(UpdatePurchaseLineExpiry event, Emitter<PurchasesState> emit) {
    final lines = List<PurchaseLine>.from(state.receiptLines);
    if (event.index >= 0 && event.index < lines.length) {
      lines[event.index].expiryDate = event.expiry;
      emit(state.copyWith(receiptLines: lines));
    }
  }

  void _onUpdateUnit(UpdatePurchaseLineUnit event, Emitter<PurchasesState> emit) {
    final lines = List<PurchaseLine>.from(state.receiptLines);
    if (event.index >= 0 && event.index < lines.length) {
      lines[event.index].unitId = event.unitId;
      lines[event.index].unitName = event.unitName;
      emit(state.copyWith(receiptLines: lines));
    }
  }

  void _onRemoveLine(RemovePurchaseLine event, Emitter<PurchasesState> emit) {
    if (event.index >= 0 && event.index < state.receiptLines.length) {
      final lines = List<PurchaseLine>.from(state.receiptLines);
      lines.removeAt(event.index);
      emit(state.copyWith(receiptLines: lines));
    }
  }

  void _onSetSupplier(SetPurchaseSupplier event, Emitter<PurchasesState> emit) {
    emit(state.copyWith(
      selectedSupplierId: event.id,
      selectedSupplierName: event.name,
    ));
    if (event.id != null) {
      SupplierLedgerService.getSupplierBalance(event.id!, _branchId).then((b) {
        if (!isClosed) emit(state.copyWith(supplierBalance: b));
      });
    }
  }

  void _onSetSourceType(SetPurchaseSourceType event, Emitter<PurchasesState> emit) {
    emit(state.copyWith(sourceType: event.type));
  }

  void _onSetPaymentMethod(SetPurchasePaymentMethod event, Emitter<PurchasesState> emit) {
    emit(state.copyWith(paymentMethod: event.method));
  }

  void _onSetPaymentDate(SetPurchasePaymentDate event, Emitter<PurchasesState> emit) {
    emit(state.copyWith(paymentDate: event.date));
  }

  void _onUpdateSellPrice(UpdatePurchaseLineSellPrice event, Emitter<PurchasesState> emit) {
    try {
      BranchDataService.getMedicine(
        state.receiptLines[event.index].medicineId,
      )?.sellPrice = event.sellPrice;
    } catch (_) {}
  }

  void _onSetInvoiceDiscount(SetPurchaseInvoiceDiscount event, Emitter<PurchasesState> emit) {
    emit(state.copyWith(invoiceDiscountType: event.type, invoiceDiscountValue: event.value));
  }

  void _onSetInvoiceTax(SetPurchaseInvoiceTax event, Emitter<PurchasesState> emit) {
    emit(state.copyWith(invoiceTaxType: event.type, invoiceTaxValue: event.value));
  }

  void _onSetShipping(SetPurchaseShipping event, Emitter<PurchasesState> emit) {
    emit(state.copyWith(shippingAmount: event.amount));
  }

  void _onSetDelivery(SetPurchaseDelivery event, Emitter<PurchasesState> emit) {
    emit(state.copyWith(deliveryAmount: event.amount));
  }

  void _onSetPaidAmount(SetPurchasePaidAmount event, Emitter<PurchasesState> emit) {
    emit(state.copyWith(paidAmount: event.amount));
  }

  void _onSetPaymentAccount(SetPurchasePaymentAccount event, Emitter<PurchasesState> emit) {
    emit(state.copyWith(paymentAccountId: event.id, paymentAccountName: event.name));
  }

  void _onSetNotes(SetPurchaseNotes event, Emitter<PurchasesState> emit) {
    emit(state.copyWith(notes: event.notes));
  }

  void _onPayInFull(PayInFull event, Emitter<PurchasesState> emit) {
    emit(state.copyWith(paidAmount: state.finalAmount));
  }

  Future<void> _onSubmit(SubmitPurchase event, Emitter<PurchasesState> emit) async {
    if (state.selectedSupplierId == null) {
      AppSnackbar.warning('الرجاء اختيار المورد');
      return;
    }
    if (state.receiptLines.isEmpty) {
      AppSnackbar.warning('الرجاء إضافة أصناف للفاتورة');
      return;
    }

    emit(state.copyWith(status: PurchasesStatus.submitting));
    try {
      final supplier = SupplierService.getById(state.selectedSupplierId!);
      if (supplier == null) {
        AppSnackbar.error('المورد غير موجود');
        emit(state.copyWith(status: PurchasesStatus.loaded));
        return;
      }

      final now = DateTime.now();
      final purchase = PurchaseModel(
        id: state.editingPurchaseId ?? _uuid.v4(),
        branchId: _branchId,
        supplierName: supplier.name,
        supplierPhone: supplier.phone,
        supplierId: supplier.id,
        sourceType: state.sourceType,
        receiptNumber: 'PO-${now.millisecondsSinceEpoch.toString().substring(6)}',
        items: state.receiptLines.map((l) => l.toItemModel()).toList(),
        totalAmount: state.subtotal,
        shippingAmount: state.shippingAmount > 0 ? state.shippingAmount : null,
        deliveryAmount: state.deliveryAmount > 0 ? state.deliveryAmount : null,
        invoiceDiscountType: state.calcInvoiceDiscountAmount > 0 ? state.invoiceDiscountType : null,
        invoiceDiscountValue: state.invoiceDiscountValue > 0 ? state.invoiceDiscountValue : null,
        invoiceDiscountAmount: state.calcInvoiceDiscountAmount > 0 ? state.calcInvoiceDiscountAmount : null,
        invoiceTaxType: state.calcInvoiceTaxAmount > 0 ? state.invoiceTaxType : null,
        invoiceTaxValue: state.invoiceTaxValue > 0 ? state.invoiceTaxValue : null,
        invoiceTaxAmount: state.calcInvoiceTaxAmount > 0 ? state.calcInvoiceTaxAmount : null,
        discount: state.itemsDiscountTotal > 0 ? state.itemsDiscountTotal : null,
        tax: state.itemsTaxTotal > 0 ? state.itemsTaxTotal : null,
        finalAmount: state.finalAmount,
        paymentMethod: state.paymentMethod,
        paidAmount: state.paymentMethod == 'credit'
            ? (state.paidAmount > 0 ? state.paidAmount : null)
            : state.finalAmount,
        notes: state.notes,
        paymentAccountId: state.paymentAccountId,
        paymentAccountName: state.paymentAccountName,
        createdBy: AuthService.currentUser?.id ?? '',
        createdAt: DateTime.now(),
        status: 'completed',
      );

      if (state.editingPurchaseId != null) {
        final oldPurchase = BranchDataService.getPurchase(state.editingPurchaseId!);
        if (oldPurchase != null) {
          final oldItems = {for (final i in oldPurchase.items) i.medicineId: i.quantity};
          for (final line in purchase.items) {
            final oldQty = oldItems[line.medicineId] ?? 0;
            final delta = line.quantity - oldQty;
            if (delta != 0) {
              await StockMutationService.adjustStock(
                medicineId: line.medicineId,
                delta: delta,
                branchId: _branchId,
              );
            }
          }
        }
        await BranchDataService.updatePurchase(purchase);
        CorrectionService.record(
          referenceType: CorrectionReferenceType.purchase,
          referenceId: purchase.id,
          action: CorrectionAction.modified,
          details: 'تعديل فاتورة مشتريات — ${supplier.name}',
        );
      } else {
        await BranchDataService.addPurchase(purchase);
        CorrectionService.record(
          referenceType: CorrectionReferenceType.purchase,
          referenceId: purchase.id,
          action: CorrectionAction.created,
          details: 'فاتورة مشتريات بقيمة ${purchase.finalAmount.toStringAsFixed(2)} ج.م — ${supplier.name}',
        );
        // إضافة الكميات المستلمة للمخزون عبر نظام StockMutationService الموحّد
        // (قفل FIFO + sync queue) — ده بيقفل الدورة: الشراء يرفع المخزون
        // عشان البيع يقدر يسحب منه من غير ما يفشل بـ Insufficient stock.
        for (final line in purchase.items) {
          await StockMutationService.adjustStock(
            medicineId: line.medicineId,
            delta: line.quantity,
            branchId: _branchId,
          );
        }
        if (purchase.paymentMethod == 'credit' && purchase.supplierId != null) {
          await SupplierLedgerService.recordPurchaseInvoice(
            supplierId: purchase.supplierId!,
            branchId: _branchId,
            purchaseId: purchase.id,
            invoiceNumber: purchase.receiptNumber ?? purchase.id,
            dueAmount: purchase.finalAmount - (purchase.paidAmount ?? 0),
            createdBy: purchase.createdBy,
          );
        }
      }

      add(const LoadPurchases());
      emit(state.copyWith(status: PurchasesStatus.loaded, receiptLines: const []));
      SoundService.instance.play(SoundEffect.itemAdded);
      AppSnackbar.success('تم تسجيل فاتورة المشتريات بنجاح');
    } catch (e) {
      SoundService.instance.play(SoundEffect.error);
      AppSnackbar.error('فشل في تسجيل الفاتورة: $e');
      emit(state.copyWith(status: PurchasesStatus.loaded));
    }
  }

  Future<void> _onVoid(VoidPurchase event, Emitter<PurchasesState> emit) async {
    try {
      await BranchDataService.voidPurchase(event.purchaseId);
      CorrectionService.record(
        referenceType: CorrectionReferenceType.purchase,
        referenceId: event.purchaseId,
        action: CorrectionAction.voided,
        details: 'تم إلغاء فاتورة المشتريات',
      );
      add(const LoadPurchases());
      AppSnackbar.warning('تم إلغاء الفاتورة');
    } catch (e) {
      AppSnackbar.error('فشل في الإلغاء: $e');
    }
  }

  Future<void> _onExportCsv(ExportPurchasesCsv event, Emitter<PurchasesState> emit) async {
    try {
      final items = state.filteredPurchases;
      final csv = StringBuffer();
      csv.writeln('ID,Supplier,Date,Items,Discount,Tax,Final,Payment,Status');
      for (final p in items) {
        csv.writeln('${p.id},"${p.supplierName}","${DateFormat('yyyy-MM-dd').format(p.createdAt)}",${p.items.length},${p.totalDiscount},${p.totalTax},${p.finalAmount},${p.paymentMethod},${p.status}');
      }
      await ExportService.exportToCsv(
        content: csv.toString(),
        fileName: 'purchases_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.csv',
      );
      AppSnackbar.success('تم تصدير الفواتير بنجاح');
    } catch (e) {
      AppSnackbar.error('فشل في التصدير: $e');
    }
  }

  void _onLoadForEdit(LoadPurchaseForEdit event, Emitter<PurchasesState> emit) {
    final p = event.purchase;
    final lines = p.items.map((item) {
      final med = BranchDataService.getMedicine(item.medicineId);
      return PurchaseLine(
        medicineId: item.medicineId, medicineName: item.medicineName,
        quantity: item.quantity, unitPrice: item.unitPrice,
        batchNumber: item.batchNumber, expiryDate: item.expiryDate,
        discount: item.discount, discountType: item.discountType,
        taxAmount: item.taxAmount, unitId: item.unitId, unitName: item.unitName,
        units: med?.units ?? [],
      );
    }).toList();

    emit(state.copyWith(
      editingPurchaseId: p.id,
      receiptLines: lines,
      selectedSupplierId: p.supplierId,
      selectedSupplierName: p.supplierName,
      sourceType: p.sourceType ?? 'مباشرة',
      paymentMethod: p.paymentMethod,
      invoiceDiscountType: p.invoiceDiscountType ?? 'fixed',
      invoiceDiscountValue: p.invoiceDiscountValue ?? 0,
      invoiceTaxType: p.invoiceTaxType ?? 'fixed',
      invoiceTaxValue: p.invoiceTaxValue ?? 0,
      shippingAmount: p.shippingAmount ?? 0,
      deliveryAmount: p.deliveryAmount ?? 0,
      paidAmount: p.paidAmount ?? 0,
      notes: p.notes ?? '',
      paymentAccountId: p.paymentAccountId,
      paymentAccountName: p.paymentAccountName,
    ));
    if (p.supplierId != null) {
      SupplierLedgerService.getSupplierBalance(p.supplierId!, _branchId).then((b) {
        if (!isClosed) emit(state.copyWith(supplierBalance: b));
      });
    }
  }

  void _onResetForm(ResetPurchaseForm event, Emitter<PurchasesState> emit) {
    emit(state.copyWith(
      receiptLines: const [],
      selectedSupplierId: null, selectedSupplierName: null, supplierBalance: 0,
      sourceType: 'مباشرة', paymentMethod: 'cash',
      invoiceDiscountType: 'fixed', invoiceDiscountValue: 0,
      invoiceTaxType: 'fixed', invoiceTaxValue: 0,
      shippingAmount: 0, deliveryAmount: 0, paidAmount: 0,
      notes: '',
      paymentAccountId: null, paymentAccountName: null,
      editingPurchaseId: null,
      paymentDate: DateTime.now(),
    ));
  }

  List<PurchaseModel> _applyFilters(List<PurchaseModel> list, String query, String filter, DateTime? dateFrom, DateTime? dateTo) {
    var result = list.toList();

    if (query.isNotEmpty) {
      final q = query.toLowerCase();
      result = result.where((p) =>
        p.supplierName.toLowerCase().contains(q) ||
        (p.supplierPhone?.contains(q) ?? false) ||
        p.id.toLowerCase().contains(q)
      ).toList();
    }

    if (dateFrom != null) {
      final from = DateTime(dateFrom.year, dateFrom.month, dateFrom.day);
      result = result.where((p) => p.createdAt.isAfter(from) || p.createdAt.isAtSameMomentAs(from)).toList();
    }

    if (dateTo != null) {
      final to = DateTime(dateTo.year, dateTo.month, dateTo.day, 23, 59, 59);
      result = result.where((p) => p.createdAt.isBefore(to) || p.createdAt.isAtSameMomentAs(to)).toList();
    }

    switch (filter) {
      case 'today':
        final today = DateTime.now();
        result = result.where((p) =>
          p.createdAt.day == today.day && p.createdAt.month == today.month && p.createdAt.year == today.year
        ).toList();
        break;
      case 'this_month':
        final now = DateTime.now();
        result = result.where((p) => p.createdAt.month == now.month && p.createdAt.year == now.year).toList();
        break;
      case 'credit':
        result = result.where((p) => p.paymentMethod == 'credit' && p.remainingAmount > 0).toList();
        break;
    }

    return result;
  }
}

