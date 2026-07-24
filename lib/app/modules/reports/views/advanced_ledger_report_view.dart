import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import 'package:pharmacy_system/app/core/models/contacts/customer_ledger_model.dart';
import 'package:pharmacy_system/app/core/models/contacts/supplier_ledger_model.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/core/data/services/customer/customer_ledger_service.dart';
import 'package:pharmacy_system/app/core/data/services/customer/customer_service.dart';
import 'package:pharmacy_system/app/core/data/services/supplier/supplier_ledger_service.dart';
import 'package:pharmacy_system/app/core/data/services/supplier/supplier_service.dart';
import '../../contacts/supplier_customers/services/supplier_customer_service.dart';
import 'package:pharmacy_system/app/core/data/services/party_ledger_service.dart';
import 'package:pharmacy_system/app/core/data/services/operations/export_service.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_colors.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/index.dart';

class AdvancedLedgerReportView extends StatefulWidget {
  const AdvancedLedgerReportView({super.key});

  @override
  State<AdvancedLedgerReportView> createState() =>
      _AdvancedLedgerReportViewState();
}

class _AdvancedLedgerReportViewState extends State<AdvancedLedgerReportView> {
  final _branchId = AuthService.currentBranchId ?? '';
  bool _isLoading = true;
  final _rows = <_LedgerReportRow>[];
  String _sortField = 'balance';
  bool _sortDesc = true;
  DateTime? _fromDate;
  DateTime? _toDate;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    try {
      final customers = CustomerService.getAll(activeOnly: false);
      final suppliers = SupplierService.getAll(activeOnly: false);
      final supplierCustomers = SupplierCustomerService.getAll(
        activeOnly: false,
      );

      final rows = <_LedgerReportRow>[];

      for (final c in customers) {
        if (!_inRange(c.lastModified)) continue;
        final balance = await CustomerLedgerService.getCustomerBalance(
          c.id,
          _branchId,
        );
        final ledger = await CustomerLedgerService.getCustomerLedger(
          c.id,
          _branchId,
        );
        final unpaidPurchases = ledger
            .where(
              (e) =>
                  e.type == CustomerLedgerEntryType.saleInvoice && e.debit > 0,
            )
            .fold(0.0, (s, e) => s + e.debit);
        final returns = ledger
            .where((e) => e.type == CustomerLedgerEntryType.saleReturn)
            .fold(0.0, (s, e) => s + e.credit);
        rows.add(
          _LedgerReportRow(
            id: c.id,
            name: c.name,
            company: c.companyName ?? '',
            phone: c.phone ?? '',
            address: c.address ?? '',
            openingBalance: 0,
            prepaid: 0,
            createdAt: c.lastModified,
            unpaidPurchases: unpaidPurchases,
            purchaseReturns: returns,
            finalDue: balance,
            type: ReportsStrings.customerType,
          ),
        );
      }

      for (final s in suppliers) {
        if (!_inRange(s.lastModified)) continue;
        final balance = await SupplierLedgerService.getSupplierBalance(
          s.id,
          _branchId,
        );
        final ledger = await SupplierLedgerService.getSupplierLedger(
          s.id,
          _branchId,
        );
        final unpaidPurchases = ledger
            .where(
              (e) =>
                  e.type == SupplierLedgerEntryType.purchaseInvoice &&
                  e.credit > 0,
            )
            .fold(0.0, (s, e) => s + e.credit);
        final returns = ledger
            .where((e) => e.type == SupplierLedgerEntryType.purchaseVoid)
            .fold(0.0, (s, e) => s + e.debit);
        rows.add(
          _LedgerReportRow(
            id: s.id,
            name: s.name,
            company: s.companyName ?? '',
            phone: s.phone ?? '',
            address: s.address ?? '',
            openingBalance: 0,
            prepaid: 0,
            createdAt: s.lastModified,
            unpaidPurchases: unpaidPurchases,
            purchaseReturns: returns,
            finalDue: balance,
            type: SuppliersStrings.supplierType,
          ),
        );
      }

      for (final c in supplierCustomers) {
        if (!_inRange(c.lastModified)) continue;
        final balance = await PartyLedgerService.getCombinedBalance(c.id);
        rows.add(
          _LedgerReportRow(
            id: c.id,
            name: c.name,
            company: c.companyName ?? '',
            phone: c.phone ?? '',
            address: c.address ?? '',
            openingBalance: 0,
            prepaid: 0,
            createdAt: c.lastModified,
            unpaidPurchases: 0,
            purchaseReturns: 0,
            finalDue: balance,
            type: ReportsStrings.supplierCustomerType,
          ),
        );
      }

      rows.sort((a, b) {
        int cmp;
        switch (_sortField) {
          case 'name':
            cmp = a.name.compareTo(b.name);
            break;
          case 'balance':
            cmp = a.finalDue.compareTo(b.finalDue);
            break;
          case 'date':
            cmp = a.createdAt.compareTo(b.createdAt);
            break;
          default:
            cmp = a.finalDue.compareTo(b.finalDue);
        }
        return _sortDesc ? -cmp : cmp;
      });

      _rows.clear();
      _rows.addAll(rows);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  bool _inRange(DateTime date) {
    if (_fromDate != null) {
      final from = DateTime(_fromDate!.year, _fromDate!.month, _fromDate!.day);
      if (date.isBefore(from)) return false;
    }
    if (_toDate != null) {
      final to = DateTime(
        _toDate!.year,
        _toDate!.month,
        _toDate!.day,
        23,
        59,
        59,
      );
      if (date.isAfter(to)) return false;
    }
    return true;
  }

  Future<void> _pickDate(bool isFrom) async {
    final initial = isFrom
        ? (_fromDate ?? DateTime.now())
        : (_toDate ?? DateTime.now());
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: Theme.of(
          context,
        ).copyWith(colorScheme: Theme.of(context).colorScheme),
        child: child ?? const SizedBox.shrink(),
      ),
    );
    if (picked == null) return;
    setState(() {
      if (isFrom) {
        _fromDate = picked;
      } else {
        _toDate = picked;
      }
    });
    _load();
  }

  Future<void> _exportCsv() async {
    try {
      final csv = StringBuffer();
      csv.writeln(
        'ID,Name,Company,Phone,Address,Opening,Prepaid,AddedAt,Unpaid,Returns,FinalDue,Type',
      );
      for (final r in _rows) {
        csv.writeln(
          '${r.id},"${r.name}","${r.company}","${r.phone}","${r.address}",${r.openingBalance},${r.prepaid},${DateFormat('yyyy-MM-dd').format(r.createdAt)},${r.unpaidPurchases},${r.purchaseReturns},${r.finalDue},${r.type}',
        );
      }
      await ExportService.exportToCsv(
        content: csv.toString(),
        fileName:
            'ledger_report_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.csv',
      );
      AppSnackbar.success(ReportsStrings.exportSuccess);
    } catch (e) {
      AppSnackbar.error(ReportsStrings.exportFailedFormat.replaceFirst('%s', e.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return HomeShell(
      title: ReportsStrings.advancedLedgerReportTitle,
      child: Container(
        color: scheme.surfaceContainerLow.withValues(alpha: 0.3),
        padding: EdgeInsets.all(AppSpacing.xl.w),
        child: Column(
          children: [
            _buildHeader(context),
            SizedBox(height: AppSpacing.lg.h),
            Expanded(child: _buildTable(scheme)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        ReusableButton(
          text: GeneralStrings.refresh,
          prefixIcon: Icons.refresh_rounded,
          onPressed: _load,
          type: ButtonType.outlined,
        ),
        SizedBox(width: AppSpacing.md.w),
        ReusableButton(
          text: GeneralStrings.export,
          prefixIcon: Icons.download_rounded,
          onPressed: _exportCsv,
          type: ButtonType.outlined,
        ),
        ReusableButton(
          text: _fromDate != null
              ? DateFormat('yyyy-MM-dd').format(_fromDate!)
              : ReportsStrings.fromDateLabel,
          prefixIcon: Icons.date_range_rounded,
          onPressed: () => _pickDate(true),
          type: ButtonType.outlined,
        ),
        SizedBox(width: AppSpacing.md.w),
        ReusableButton(
          text: _toDate != null
              ? DateFormat('yyyy-MM-dd').format(_toDate!)
              : ReportsStrings.toDateLabel,
          prefixIcon: Icons.date_range_rounded,
          onPressed: () => _pickDate(false),
          type: ButtonType.outlined,
        ),
        const Spacer(),
        SizedBox(
          width: 180.w,
          child: ReusableDropdown<String>(
            hintText: ReportsStrings.sortLabel,
            value: _sortField,
            items: const ['balance', 'name', 'date'],
            itemAsString: (v) => switch (v) {
              'balance' => ReportsStrings.sortByBalance,
              'name' => ReportsStrings.sortByName,
              'date' => ReportsStrings.sortByDate,
              _ => v,
            },
            onChanged: (v) {
              if (v == null) return;
              setState(() {
                if (_sortField == v) {
                  _sortDesc = !_sortDesc;
                } else {
                  _sortField = v;
                  _sortDesc = true;
                }
                _load();
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTable(ColorScheme scheme) {
    if (_isLoading) return const LoadingIndicator();
    if (_rows.isEmpty) {
      return const EmptyState(
        icon: Icons.assessment_outlined,
        title: GeneralStrings.noData,
      );
    }
    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      child: ListView(
        padding: EdgeInsets.all(AppSpacing.sm.w),
        children: [
          _tableHeader(scheme),
          ..._rows.map((r) => _tableRow(r, scheme)),
        ],
      ),
    );
  }

  Widget _tableHeader(ColorScheme scheme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          _cell('ID', flex: 1),
          _cell(GeneralStrings.name, flex: 2),
          _cell(GeneralStrings.company, flex: 2),
          _cell(GeneralStrings.phone, flex: 1),
          _cell(CustomersStrings.address, flex: 2),
          _cell(ReportsStrings.openingBalanceLabel, flex: 1, align: TextAlign.center),
          _cell(ReportsStrings.prepaidLabel, flex: 1, align: TextAlign.center),
          _cell(ReportsStrings.addedDateLabel, flex: 1, align: TextAlign.center),
          _cell(ReportsStrings.unpaidPurchasesLabel, flex: 1, align: TextAlign.center),
          _cell(ReportsStrings.purchaseReturnsLabel, flex: 1, align: TextAlign.center),
          _cell(ReportsStrings.finalDueLabel, flex: 1, align: TextAlign.center),
          _cell(GeneralStrings.type, flex: 1, align: TextAlign.center),
        ],
      ),
    );
  }

  Widget _tableRow(_LedgerReportRow row, ColorScheme scheme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: scheme.outlineVariant.withValues(alpha: 0.15),
          ),
        ),
      ),
      child: Row(
        children: [
          _cell(row.id, flex: 1),
          _cell(row.name, flex: 2),
          _cell(row.company, flex: 2),
          _cell(row.phone, flex: 1),
          _cell(row.address, flex: 2),
          _cell(
            row.openingBalance.toStringAsFixed(2),
            flex: 1,
            align: TextAlign.center,
          ),
          _cell(
            row.prepaid.toStringAsFixed(2),
            flex: 1,
            align: TextAlign.center,
          ),
          _cell(
            '${row.createdAt.day}/${row.createdAt.month}/${row.createdAt.year}',
            flex: 1,
            align: TextAlign.center,
          ),
          _cell(
            row.unpaidPurchases.toStringAsFixed(2),
            flex: 1,
            align: TextAlign.center,
            color: AppColors.warning,
          ),
          _cell(
            row.purchaseReturns.toStringAsFixed(2),
            flex: 1,
            align: TextAlign.center,
            color: AppColors.info,
          ),
          _cell(
            row.finalDue.toStringAsFixed(2),
            flex: 1,
            align: TextAlign.center,
            color: row.finalDue > 0 ? AppColors.error : AppColors.success,
          ),
          _cell(row.type, flex: 1, align: TextAlign.center),
        ],
      ),
    );
  }

  Widget _cell(
    String text, {
    int flex = 1,
    TextAlign align = TextAlign.start,
    Color? color,
  }) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: TextStyle(fontSize: 10.sp, color: color),
        textAlign: align,
      ),
    );
  }
}

class _LedgerReportRow {
  final String id;
  final String name;
  final String company;
  final String phone;
  final String address;
  final double openingBalance;
  final double prepaid;
  final DateTime createdAt;
  final double unpaidPurchases;
  final double purchaseReturns;
  final double finalDue;
  final String type;

  const _LedgerReportRow({
    required this.id,
    required this.name,
    required this.company,
    required this.phone,
    required this.address,
    required this.openingBalance,
    required this.prepaid,
    required this.createdAt,
    required this.unpaidPurchases,
    required this.purchaseReturns,
    required this.finalDue,
    required this.type,
  });
}






