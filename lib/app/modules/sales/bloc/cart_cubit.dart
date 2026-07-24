import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pharmacy_system/app/core/models/inventory/medicine_unit_model.dart';
import 'package:pharmacy_system/app/modules/sales/models/pos_cart_line.dart';
import 'package:pharmacy_system/app/core/models/inventory/medicine_model.dart';
import 'package:collection/collection.dart';
import 'package:pharmacy_system/app/modules/sales/bloc/pos_state.dart';

class CartState extends Equatable {
  final List<PosCartLine> items;
  final double invoiceDiscount;
  final double invoiceTax;
  final String? selectedCustomerId;
  final PaymentMode paymentMode;
  final double cashAmount;
  final double cardAmount;
  final String notes;

  const CartState({
    this.items = const [],
    this.invoiceDiscount = 0,
    this.invoiceTax = 0,
    this.selectedCustomerId,
    this.paymentMode = PaymentMode.cash,
    this.cashAmount = 0,
    this.cardAmount = 0,
    this.notes = '',
  });

  double get subtotal => double.parse(
    items.fold(0.0, (sum, l) => sum + l.lineGross).toStringAsFixed(2),
  );

  double get lineDiscountTotal => double.parse(
    items.fold(0.0, (sum, l) => sum + l.discountAmount).toStringAsFixed(2),
  );

  double get totalDiscount =>
      double.parse((lineDiscountTotal + invoiceDiscount).toStringAsFixed(2));

  double get taxTotal => double.parse(
    (items.fold(0.0, (sum, l) => sum + l.taxAmount) + invoiceTax)
        .toStringAsFixed(2),
  );

  double get grandTotal {
    final afterDiscount = (subtotal - totalDiscount).clamp(0, double.infinity);
    return double.parse((afterDiscount + taxTotal).toStringAsFixed(2));
  }

  double get paidTotal {
    if (paymentMode == PaymentMode.cash) return grandTotal;
    if (paymentMode == PaymentMode.card) return grandTotal;
    if (paymentMode == PaymentMode.credit) return 0;
    return double.parse((cashAmount + cardAmount).toStringAsFixed(2));
  }

  double get change => (paidTotal - grandTotal).clamp(0, double.infinity);
  double get dueAmount => (grandTotal - paidTotal).clamp(0, double.infinity);

  CartState copyWith({
    List<PosCartLine>? items,
    double? invoiceDiscount,
    double? invoiceTax,
    String? selectedCustomerId,
    PaymentMode? paymentMode,
    double? cashAmount,
    double? cardAmount,
    String? notes,
  }) {
    return CartState(
      items: items ?? this.items,
      invoiceDiscount: invoiceDiscount ?? this.invoiceDiscount,
      invoiceTax: invoiceTax ?? this.invoiceTax,
      selectedCustomerId: selectedCustomerId ?? this.selectedCustomerId,
      paymentMode: paymentMode ?? this.paymentMode,
      cashAmount: cashAmount ?? this.cashAmount,
      cardAmount: cardAmount ?? this.cardAmount,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [
    items,
    invoiceDiscount,
    invoiceTax,
    selectedCustomerId,
    paymentMode,
    cashAmount,
    cardAmount,
    notes,
  ];
}

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState());

  void addMedicine(MedicineModel medicine, {MedicineUnitModel? unit}) {
    final price = unit?.sellPrice ?? medicine.sellPrice;
    final factor = unit?.conversionFactor.toDouble() ?? 
                  (medicine.units.isNotEmpty ? medicine.units.first.factor.toDouble() : 1.0);
    
    final existingIdx = state.items.indexWhere(
      (l) => l.medicine.id == medicine.id && l.unitName == (unit?.name ?? medicine.itemLevels.unit1Name),
    );

    if (existingIdx >= 0) {
      final updated = List<PosCartLine>.from(state.items);
      updated[existingIdx] = updated[existingIdx].copyWith(
        quantity: updated[existingIdx].quantity + 1,
      );
      emit(state.copyWith(items: updated));
    } else {
      emit(
        state.copyWith(
          items: [
            ...state.items,
            PosCartLine(
              medicine: medicine,
              quantity: 1,
              unitPrice: price,
              unitName: unit?.name ?? medicine.itemLevels.unit1Name,
              conversionFactor: factor,
              costPrice: unit?.buyPrice ?? medicine.buyPrice,
            ),
          ],
        ),
      );
    }
  }

  void updateQuantity(String id, int quantity) {
    if (quantity <= 0) {
      removeLine(id);
      return;
    }
    final updated = state.items
        .map((l) => l.medicine.id == id ? l.copyWith(quantity: quantity) : l)
        .toList();
    emit(state.copyWith(items: updated));
  }

  void incrementLine(String id) {
    final idx = state.items.indexWhere((l) => l.medicine.id == id);
    if (idx < 0) return;
    final updated = List<PosCartLine>.from(state.items);
    updated[idx] = updated[idx].copyWith(quantity: updated[idx].quantity + 1);
    emit(state.copyWith(items: updated));
  }

  void decrementLine(String id) {
    final idx = state.items.indexWhere((l) => l.medicine.id == id);
    if (idx < 0) return;
    if (state.items[idx].quantity <= 1) {
      removeLine(id);
    } else {
      final updated = List<PosCartLine>.from(state.items);
      updated[idx] = updated[idx].copyWith(quantity: updated[idx].quantity - 1);
      emit(state.copyWith(items: updated));
    }
  }

  void removeLine(String id) {
    emit(
      state.copyWith(
        items: state.items.where((l) => l.medicine.id != id).toList(),
      ),
    );
  }

  void updateLineDiscount(String id, double percent) {
    final updated = state.items
        .map(
          (l) => l.medicine.id == id
              ? l.copyWith(
                  discountPercent: percent.clamp(0, 100),
                  discountAmount: (l.unitPrice * l.quantity) * (percent.clamp(0, 100) / 100),
                )
              : l,
        )
        .toList();
    emit(state.copyWith(items: updated));
  }

  void updateLinePrice(String id, double price) {
    final updated = state.items
        .map((l) => l.medicine.id == id ? l.copyWith(unitPrice: price) : l)
        .toList();
    emit(state.copyWith(items: updated));
  }

  void updateLineUnit(String medicineId, String unitName) {
    final updated = state.items.map((l) {
      if (l.medicine.id == medicineId) {
        final unit = l.medicine.units
            .where((u) => u.name == unitName)
            .firstOrNull;
        final price = unit?.sellPrice ?? l.medicine.sellPrice;
        final factor = unit?.factor.toDouble() ?? 1.0;
        return l.copyWith(
          unitName: unitName,
          unitPrice: price,
          conversionFactor: factor,
        );
      }
      return l;
    }).toList();
    emit(state.copyWith(items: updated));
  }

  void setInvoiceDiscount(double value, {bool isPercentage = false}) {
    final amount = isPercentage ? state.subtotal * (value / 100) : value;
    emit(state.copyWith(invoiceDiscount: amount.clamp(0, state.subtotal)));
  }

  void setInvoiceTax(double value, {bool isPercentage = false}) {
    final amount = isPercentage
        ? (state.subtotal - state.totalDiscount) * (value / 100)
        : value;
    emit(state.copyWith(invoiceTax: amount.clamp(0, double.infinity)));
  }

  void setPaymentMode(PaymentMode mode) {
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

  void updateCash(double value) {
    emit(state.copyWith(cashAmount: value));
  }

  void updateCard(double value) {
    emit(state.copyWith(cardAmount: value));
  }

  void selectCustomer(String? customerId) {
    emit(state.copyWith(selectedCustomerId: customerId));
  }

  void updateNotes(String notes) {
    emit(state.copyWith(notes: notes));
  }

  void clear() {
    emit(const CartState());
  }

  void loadFromSuspended(
    Map<String, dynamic> suspended,
    List<MedicineModel> catalog,
  ) {
    final items = suspended['items'] as List<dynamic>;
    final newItems = <PosCartLine>[];
    for (final item in items) {
      final medicine = catalog
          .where((m) => m.id == item['medicine_id'])
          .firstOrNull;
      if (medicine != null) {
        final savedFactor = (item['conversion_factor'] as num?)?.toDouble();
        final unitName = item['unit_name'] as String?;
        
        double factor = savedFactor ?? 1.0;
        if (savedFactor == null && unitName != null) {
          final unit = medicine.units.firstWhereOrNull((u) => u.name == unitName);
          if (unit != null) factor = unit.factor.toDouble();
        } else if (savedFactor == null && medicine.units.isNotEmpty) {
          factor = medicine.units.first.factor.toDouble();
        }

        newItems.add(
          PosCartLine(
            medicine: medicine,
            quantity: (item['quantity'] as num).toInt(),
            unitPrice: (item['unit_price'] as num?)?.toDouble() ?? medicine.sellPrice,
            discountPercent: (item['discount_percent'] as num?)?.toDouble() ?? 0,
            unitName: unitName ?? medicine.itemLevels.unit1Name,
            conversionFactor: factor,
            costPrice: medicine.buyPrice,
          ),
        );
      }
    }
    emit(
      state.copyWith(
        items: newItems,
        notes: suspended['notes'] as String? ?? '',
        invoiceDiscount: (suspended['discount'] as num?)?.toDouble() ?? 0,
      ),
    );
  }
}
