import 'package:equatable/equatable.dart';
import 'package:pharmacy_system/app/modules/sales/models/cashier_shift_model.dart';
import 'package:pharmacy_system/app/modules/inventory/models/medicine_model.dart';
import 'package:pharmacy_system/app/modules/sales/models/sale_model.dart';
import 'package:pharmacy_system/app/modules/contacts/models/supplier_model.dart';
import 'package:pharmacy_system/app/modules/contacts/models/customer_model.dart';
import '../models/pos_cart_line.dart';

enum PaymentMode { cash, card, mixed, credit }

class PosState extends Equatable {
  final bool isLoading;
  final bool isProcessing;
  final List<MedicineModel> medicines;
  final List<PosCartLine> cart;
  final String searchQuery;
  final String? selectedCategory;
  final PaymentMode paymentMode;
  final double cashAmount;
  final double cardAmount;
  final double invoiceDiscount;
  final double invoiceTax;
  final String notes;
  final bool showProducts;
  final double catalogWidth;
  final bool isFullScreen;
  final String? selectedCustomerId;
  final String? selectedSupplierId;
  final List<CustomerModel> customers;
  final List<SupplierModel> suppliers;
  final CashierShiftModel? currentShift;
  final SaleModel? lastInvoice;
  final double customerBalance;
  final double supplierBalance;
  final List<MedicineModel> nearExpiryItems;
  final List<MedicineModel> lowStockItems;
  final List<String> categories;
  final List<MedicineModel> filteredMedicines;
  final List<SaleModel> recentSales;
  final List<Map<String, dynamic>> suspendedSales;
  final String? warning;
  final String selectedPriceGroup;
  final bool isPrintEnabled;
  final Map<String, dynamic> shiftSummary;

  const PosState({
    this.isLoading = true,
    this.isProcessing = false,
    this.medicines = const [],
    this.cart = const [],
    this.searchQuery = '',
    this.selectedCategory,
    this.paymentMode = PaymentMode.cash,
    this.cashAmount = 0,
    this.cardAmount = 0,
    this.invoiceDiscount = 0,
    this.invoiceTax = 0,
    this.notes = '',
    this.showProducts = false,
    this.catalogWidth = 400.0,
    this.isFullScreen = false,
    this.selectedCustomerId,
    this.selectedSupplierId,
    this.customers = const [],
    this.suppliers = const [],
    this.currentShift,
    this.lastInvoice,
    this.customerBalance = 0,
    this.supplierBalance = 0,
    this.nearExpiryItems = const [],
    this.lowStockItems = const [],
    this.categories = const [],
    this.filteredMedicines = const [],
    this.recentSales = const [],
    this.suspendedSales = const [],
    this.warning,
    this.selectedPriceGroup = 'default',
    this.isPrintEnabled = true,
    this.shiftSummary = const {},
  });

  PosState copyWith({
    bool? isLoading,
    bool? isProcessing,
    List<MedicineModel>? medicines,
    List<PosCartLine>? cart,
    String? searchQuery,
    String? selectedCategory,
    PaymentMode? paymentMode,
    double? cashAmount,
    double? cardAmount,
    double? invoiceDiscount,
    double? invoiceTax,
    String? notes,
    bool? showProducts,
    double? catalogWidth,
    bool? isFullScreen,
    String? selectedCustomerId,
    String? selectedSupplierId,
    List<CustomerModel>? customers,
    List<SupplierModel>? suppliers,
    CashierShiftModel? currentShift,
    SaleModel? lastInvoice,
    double? customerBalance,
    double? supplierBalance,
    List<MedicineModel>? nearExpiryItems,
    List<MedicineModel>? lowStockItems,
    List<String>? categories,
    List<MedicineModel>? filteredMedicines,
    List<SaleModel>? recentSales,
    List<Map<String, dynamic>>? suspendedSales,
    String? warning,
    String? selectedPriceGroup,
    bool? isPrintEnabled,
    Map<String, dynamic>? shiftSummary,
  }) {
    return PosState(
      isLoading: isLoading ?? this.isLoading,
      isProcessing: isProcessing ?? this.isProcessing,
      medicines: medicines ?? this.medicines,
      cart: cart ?? this.cart,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      paymentMode: paymentMode ?? this.paymentMode,
      cashAmount: cashAmount ?? this.cashAmount,
      cardAmount: cardAmount ?? this.cardAmount,
      invoiceDiscount: invoiceDiscount ?? this.invoiceDiscount,
      invoiceTax: invoiceTax ?? this.invoiceTax,
      notes: notes ?? this.notes,
      showProducts: showProducts ?? this.showProducts,
      catalogWidth: catalogWidth ?? this.catalogWidth,
      isFullScreen: isFullScreen ?? this.isFullScreen,
      selectedCustomerId: selectedCustomerId ?? this.selectedCustomerId,
      selectedSupplierId: selectedSupplierId ?? this.selectedSupplierId,
      customers: customers ?? this.customers,
      suppliers: suppliers ?? this.suppliers,
      currentShift: currentShift ?? this.currentShift,
      lastInvoice: lastInvoice ?? this.lastInvoice,
      customerBalance: customerBalance ?? this.customerBalance,
      supplierBalance: supplierBalance ?? this.supplierBalance,
      nearExpiryItems: nearExpiryItems ?? this.nearExpiryItems,
      lowStockItems: lowStockItems ?? this.lowStockItems,
      categories: categories ?? this.categories,
      filteredMedicines: filteredMedicines ?? this.filteredMedicines,
      recentSales: recentSales ?? this.recentSales,
      suspendedSales: suspendedSales ?? this.suspendedSales,
      warning: warning ?? this.warning,
      selectedPriceGroup: selectedPriceGroup ?? this.selectedPriceGroup,
      isPrintEnabled: isPrintEnabled ?? this.isPrintEnabled,
      shiftSummary: shiftSummary ?? this.shiftSummary,
    );
  }

  double get subtotal => double.parse(
    cart.fold(0.0, (sum, l) => sum + l.lineGross).toStringAsFixed(2),
  );
  double get lineDiscountTotal => double.parse(
    cart.fold(0.0, (sum, l) => sum + l.discountAmount).toStringAsFixed(2),
  );
  double get totalDiscount => double.parse(
    (lineDiscountTotal + invoiceDiscount).toStringAsFixed(2),
  );
  double get taxTotal => double.parse(
    (cart.fold(0.0, (sum, l) => sum + l.taxAmount) + invoiceTax).toStringAsFixed(2),
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

  bool get canComplete => cart.isNotEmpty && grandTotal >= 0;
  bool get hasSaleCompleted => lastInvoice != null;

  double get invoiceDiscountTotal => invoiceDiscount;
  int get nearExpiryCount => nearExpiryItems.length;
  int get lowStockCount => lowStockItems.length;
  int get expiredCount => medicines.where((m) => m.expiryDate != null && m.expiryDate!.isBefore(DateTime.now())).length;
  int get itemCount => cart.fold(0, (sum, l) => sum + l.quantity);

  // ملخصات الوردية من الـ state مباشرة (أمان ولحظية)
  int get shiftSalesCount => (shiftSummary['sales_count'] as int?) ?? 0;
  double get shiftTotalSales => (shiftSummary['total_sales'] as num?)?.toDouble() ?? 0.0;
  double get shiftCashSales => (shiftSummary['cash_sales'] as num?)?.toDouble() ?? 0.0;
  double get shiftCardSales => (shiftSummary['card_sales'] as num?)?.toDouble() ?? 0.0;
  double get shiftCreditSales => (shiftSummary['credit_sales'] as num?)?.toDouble() ?? 0.0;

  @override
  List<Object?> get props => [
    isLoading,
    isProcessing,
    medicines,
    cart,
    searchQuery,
    selectedCategory,
    paymentMode,
    cashAmount,
    cardAmount,
    invoiceDiscount,
    invoiceTax,
    notes,
    showProducts,
    catalogWidth,
    isFullScreen,
    selectedCustomerId,
    selectedSupplierId,
    customers,
    suppliers,
    currentShift,
    lastInvoice,
    customerBalance,
    supplierBalance,
    nearExpiryItems,
    lowStockItems,
    categories,
    recentSales,
    suspendedSales,
    warning,
    selectedPriceGroup,
    isPrintEnabled,
    shiftSummary,
  ];
}

