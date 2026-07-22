part of 'extra_reports_bloc.dart';

class ExtraReportsState extends Equatable {
  final ExtraReportType selectedType;
  final DateTime fromDate;
  final DateTime toDate;
  final bool isLoading;
  final String dateLabel;
  final String typeLabel;
  final List<InventoryRow> inventoryRows;
  final List<PopularItemRow> popularItemRows;
  final List<MovementRow> movementRows;
  final List<TaxSummaryRow> taxSummaryRows;
  final List<EmployeeActivityRow> employeeActivityRows;
  final List<CustomerGroupRow> customerGroupRows;
  final List<ReceiptRow> receiptRows;
  final List<SalesRepPerformanceRow> salesRepPerformanceRows;
  final String? selectedMedicineId;

  ExtraReportsState({
    this.selectedType = ExtraReportType.inventory,
    DateTime? fromDate,
    DateTime? toDate,
    this.isLoading = false,
    this.dateLabel = '',
    this.typeLabel = '',
    this.inventoryRows = const [],
    this.popularItemRows = const [],
    this.movementRows = const [],
    this.taxSummaryRows = const [],
    this.employeeActivityRows = const [],
    this.customerGroupRows = const [],
    this.receiptRows = const [],
    this.salesRepPerformanceRows = const [],
    this.selectedMedicineId,
  })  : fromDate = fromDate ?? DateTime(DateTime.now().year, DateTime.now().month, 1),
        toDate = toDate ?? DateTime.now();

  ExtraReportsState copyWith({
    ExtraReportType? selectedType,
    DateTime? fromDate,
    DateTime? toDate,
    bool? isLoading,
    String? dateLabel,
    String? typeLabel,
    List<InventoryRow>? inventoryRows,
    List<PopularItemRow>? popularItemRows,
    List<MovementRow>? movementRows,
    List<TaxSummaryRow>? taxSummaryRows,
      List<EmployeeActivityRow>? employeeActivityRows,
      List<CustomerGroupRow>? customerGroupRows,
      List<ReceiptRow>? receiptRows,
      List<SalesRepPerformanceRow>? salesRepPerformanceRows,
      String? selectedMedicineId,
  }) {
    return ExtraReportsState(
      selectedType: selectedType ?? this.selectedType,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      isLoading: isLoading ?? this.isLoading,
      dateLabel: dateLabel ?? this.dateLabel,
      typeLabel: typeLabel ?? this.typeLabel,
      inventoryRows: inventoryRows ?? this.inventoryRows,
      popularItemRows: popularItemRows ?? this.popularItemRows,
      movementRows: movementRows ?? this.movementRows,
      taxSummaryRows: taxSummaryRows ?? this.taxSummaryRows,
      employeeActivityRows: employeeActivityRows ?? this.employeeActivityRows,
      customerGroupRows: customerGroupRows ?? this.customerGroupRows,
      receiptRows: receiptRows ?? this.receiptRows,
      salesRepPerformanceRows: salesRepPerformanceRows ?? this.salesRepPerformanceRows,
      selectedMedicineId: selectedMedicineId ?? this.selectedMedicineId,
    );
  }

  String _pad(int n) => n.toString().padLeft(2, '0');

  String get _dateLabel => '${fromDate.year}/${_pad(fromDate.month)}/${_pad(fromDate.day)} — ${toDate.year}/${_pad(toDate.month)}/${_pad(toDate.day)}';

  String get typeSubtitle {
    switch (selectedType) {
      case ExtraReportType.inventory:
        return ReportsStrings.subtitleInventory;
      case ExtraReportType.inventoryCount:
        return ReportsStrings.subtitleInventoryCount;
      case ExtraReportType.popularItems:
        return ReportsStrings.subtitlePopularItems;
      case ExtraReportType.itemMovement:
        return ReportsStrings.subtitleItemMovement;
      case ExtraReportType.taxSummary:
        return ReportsStrings.subtitleTaxSummary;
      case ExtraReportType.employeeActivity:
        return ReportsStrings.subtitleEmployeeActivity;
      case ExtraReportType.customerGroups:
        return ReportsStrings.subtitleCustomerGroups;
      case ExtraReportType.receipts:
        return ReportsStrings.subtitleReceipts;
      case ExtraReportType.salesRepPerformance:
        return ReportsStrings.subtitleSalesRepPerformance;
    }
  }

  @override
  List<Object?> get props => [
        selectedType,
        fromDate,
        toDate,
        isLoading,
        dateLabel,
        typeLabel,
        inventoryRows,
        popularItemRows,
        movementRows,
        taxSummaryRows,
        employeeActivityRows,
        customerGroupRows,
        receiptRows,
        salesRepPerformanceRows,
        selectedMedicineId,
      ];
}
