import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/core/data/services/customer/customer_ledger_service.dart';
import 'package:pharmacy_system/app/core/data/services/customer/customer_service.dart';
import 'package:pharmacy_system/app/core/data/services/supplier/supplier_ledger_service.dart';
import 'package:pharmacy_system/app/core/data/services/supplier/supplier_service.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_colors.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_sizes.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/index.dart';
import 'package:pharmacy_system/app/core/constants/app_strings.dart';

class ContactsReportView extends StatefulWidget {
  const ContactsReportView({super.key});

  @override
  State<ContactsReportView> createState() => _ContactsReportViewState();
}

class _ContactsReportViewState extends State<ContactsReportView> {
  final _branchId = AuthService.currentBranchId ?? '';
  bool _isLoading = true;
  final _customers = <_ContactReportRow>[];
  final _suppliers = <_ContactReportRow>[];
  String _filter = 'all';

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

      _customers.clear();
      for (final c in customers) {
        final balance = await CustomerLedgerService.getCustomerBalance(c.id, _branchId);
        _customers.add(_ContactReportRow(
          id: c.id,
          name: c.name,
          phone: c.phone,
          company: c.companyName,
          type: ReportsStrings.customerType,
          kind: c.kindName,
          balance: balance,
          isActive: c.isActive,
        ));
      }

      _suppliers.clear();
      for (final s in suppliers) {
        final balance = await SupplierLedgerService.getSupplierBalance(s.id, _branchId);
        _suppliers.add(_ContactReportRow(
          id: s.id,
          name: s.name,
          phone: s.phone,
          company: null,
          type: SuppliersStrings.supplierType,
          kind: null,
          balance: balance,
          isActive: s.isActive,
        ));
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  List<_ContactReportRow> get _filteredRows {
    final all = switch (_filter) {
      'customers' => _customers,
      'suppliers' => _suppliers,
      'debtors' => [..._customers.where((r) => r.balance > 0), ..._suppliers.where((r) => r.balance > 0)],
      _ => [..._customers, ..._suppliers],
    };
    all.sort((a, b) => b.balance.compareTo(a.balance));
    return all;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final totalCustomerBalance = _customers.fold<double>(0, (s, r) => s + r.balance);
    final totalSupplierBalance = _suppliers.fold<double>(0, (s, r) => s + r.balance);

    return HomeShell(
      title: ReportsStrings.contactsReportTitle,
      child: Container(
        color: scheme.surfaceContainerLow.withValues(alpha: 0.3),
        padding: EdgeInsets.all(AppSpacing.xl.w),
        child: Column(
          children: [
            _buildSummaryCards(totalCustomerBalance, totalSupplierBalance),
            SizedBox(height: AppSpacing.lg.h),
            _buildFilters(scheme),
            SizedBox(height: AppSpacing.md.h),
            Expanded(child: _buildTable(scheme)),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards(double totalDebt, double totalCredit) {
    final debtors = _customers.where((r) => r.balance > 0).length + _suppliers.where((r) => r.balance > 0).length;
    return Wrap(
      spacing: AppSpacing.md.w,
      runSpacing: 12.h,
      alignment: WrapAlignment.end,
      children: [
        SummaryCard(icon: Icons.group_outlined, label: ReportsStrings.totalCustomersLabel, value: '${_customers.length}', color: AppColors.primary),
        SummaryCard(icon: Icons.business_outlined, label: ReportsStrings.purchasesHeader, value: '${_suppliers.length}', color: AppColors.info),
        SummaryCard(icon: Icons.account_balance_rounded, label: ReportsStrings.totalDebtsLabel, value: '${totalDebt.toStringAsFixed(0)} ${GeneralStrings.currency}', color: AppColors.warning),
        SummaryCard(icon: Icons.warning_rounded, label: ReportsStrings.debtorsCountLabel, value: '$debtors', color: AppColors.error),
        SummaryCard(icon: Icons.payments_rounded, label: ReportsStrings.dueToSuppliersLabel, value: '${totalCredit.toStringAsFixed(0)} ${GeneralStrings.currency}', color: AppColors.success),
      ],
    );
  }



  Widget _buildFilters(ColorScheme scheme) {
    final filters = [
      ('all', ReportsStrings.contactFilterAll),
      ('customers', ReportsStrings.contactFilterCustomers),
      ('suppliers', ReportsStrings.contactFilterSuppliers),
      ('debtors', ReportsStrings.contactFilterDebtors),
    ];
    return Row(
      children: [
        Row(
          children: filters.map((f) {
            final selected = _filter == f.$1;
            return QuickFilterChip(
              label: f.$2,
              isSelected: selected,
              onTap: () => setState(() => _filter = f.$1),
            );
          }).toList(),
        ),
        const Spacer(),
        ReusableButton(
          text: GeneralStrings.refresh,
          prefixIcon: Icons.refresh_rounded,
          onPressed: _load,
          type: ButtonType.outlined,
        ),
      ],
    );
  }

  Widget _buildTable(ColorScheme scheme) {
    if (_isLoading) return const LoadingIndicator();
    final rows = _filteredRows;
    if (rows.isEmpty) {
      return const EmptyState(
        icon: Icons.assessment_outlined,
        title: GeneralStrings.noData,
      );
    }
    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.35)),
      ),
      child: ListView(
        padding: EdgeInsets.all(AppSpacing.sm.w),
        children: [
          _tableHeader(scheme),
          ...rows.map((r) => _tableRow(r, scheme)),
        ],
      ),
    );
  }

  Widget _tableHeader(ColorScheme scheme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      decoration: BoxDecoration(color: scheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(6)),
      child: Row(
        children: [
          _cell(GeneralStrings.name, flex: 3),
          _cell(ReportsStrings.taxColumnType, flex: 2),
          _cell(ReportsStrings.phoneHeader, flex: 2),
          _cell(GeneralStrings.balance, flex: 2),
          _cell(GeneralStrings.status, flex: 1),
        ],
      ),
    );
  }

  Widget _tableRow(_ContactReportRow row, ColorScheme scheme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.15))),
      ),
      child: Row(
        children: [
          _cell(row.name, flex: 3),
          _cell(row.type, flex: 2),
          _cell(row.phone ?? '-', flex: 2),
          Expanded(
            flex: 2,
            child: Text(
              '${row.balance.toStringAsFixed(0)} ${GeneralStrings.currency}',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: row.balance > 0 ? AppColors.warning : AppColors.success,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 1,
            child: StatusBadge(
              label: row.isActive ? GeneralStrings.active : GeneralStrings.inactive,
              color: row.isActive ? AppColors.success : AppColors.error,
            ),
          ),
        ],
      ),
    );
  }

  Widget _cell(String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Text(text, style: TextStyle(fontSize: 11.sp), textAlign: TextAlign.center),
    );
  }
}

class _ContactReportRow {
  final String id;
  final String name;
  final String? phone;
  final String? company;
  final String type;
  final String? kind;
  final double balance;
  final bool isActive;

  const _ContactReportRow({
    required this.id,
    required this.name,
    this.phone,
    this.company,
    required this.type,
    this.kind,
    required this.balance,
    required this.isActive,
  });
}




