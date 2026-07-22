import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../services/financial_statements_service.dart';
import 'package:pharmacy_system/app/core/data/services/auth/auth_service.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_colors.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_sizes.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/index.dart';

class FinancialStatementsView extends StatefulWidget {
  const FinancialStatementsView({super.key});

  @override
  State<FinancialStatementsView> createState() => _FinancialStatementsViewState();
}

class _FinancialStatementsViewState extends State<FinancialStatementsView> {
  FinancialStatementType _selectedType = FinancialStatementType.balanceSheet;
  DateTime _fromDate = DateTime(DateTime.now().year, 1, 1);
  DateTime _toDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final branchId = AuthService.currentBranchId ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.all(16.w),
          color: AppColors.surfaceOf(context),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: ReusableDropdown<FinancialStatementType>(
                      value: _selectedType,
                      hintText: 'نوع التقرير',
                      items: FinancialStatementType.values,
                      itemAsString: (type) => _typeLabel(type),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedType = value);
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _fromDate,
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setState(() => _fromDate = picked);
                        }
                      },
                      icon: Icon(Icons.calendar_today_rounded, size: AppIconSize.md.value),
                      label: Text('${_fromDate.year}/${_fromDate.month.toString().padLeft(2, '0')}/${_fromDate.day.toString().padLeft(2, '0')}'),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _toDate,
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setState(() => _toDate = picked);
                        }
                      },
                      icon: Icon(Icons.calendar_today_rounded, size: AppIconSize.md.value),
                      label: Text('${_toDate.year}/${_toDate.month.toString().padLeft(2, '0')}/${_toDate.day.toString().padLeft(2, '0')}'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              ElevatedButton.icon(
                onPressed: () => setState(() {}),
                      icon: Icon(Icons.refresh_rounded, size: AppIconSize.md.value),
                      label: Text('تحديث', style: AppTextStyles.button(context)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder<Widget>(
            future: _buildReportContent(branchId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: ReusableText('خطأ في تحميل التقرير: ${snapshot.error}'));
              }
              return snapshot.data ?? const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }

  Future<Widget> _buildReportContent(String branchId) async {
    switch (_selectedType) {
      case FinancialStatementType.balanceSheet:
        final rows = await FinancialStatementsService.getBalanceSheet(branchId, _toDate);
        return _buildBalanceSheet(rows);
      case FinancialStatementType.cashFlow:
        final rows = await FinancialStatementsService.getCashFlowStatement(branchId, _fromDate, _toDate);
        return _buildCashFlow(rows);
      case FinancialStatementType.trialBalance:
        final rows = await FinancialStatementsService.getTrialBalance(branchId, _toDate);
        return _buildTrialBalance(rows);
      case FinancialStatementType.profitAndLoss:
        final rows = await FinancialStatementsService.getProfitAndLoss(branchId, _fromDate, _toDate);
        return _buildProfitAndLoss(rows);
    }
  }

  Widget _buildBalanceSheet(List<BalanceSheetRow> rows) {
    final assets = rows.where((r) => _isAsset(r.accountId)).toList();
    final liabilities = rows.where((r) => _isLiability(r.accountId)).toList();
    final equity = rows.where((r) => !_isAsset(r.accountId) && !_isLiability(r.accountId)).toList();

    final totalAssets = assets.fold<double>(0, (s, r) => s + r.balance);
    final totalLiabilities = liabilities.fold<double>(0, (s, r) => s + r.balance);
    final totalEquity = equity.fold<double>(0, (s, r) => s + r.balance);

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSection('الأصول', assets, totalAssets),
          SizedBox(height: 24.h),
          _buildSection('الالتزامات', liabilities, totalLiabilities),
          SizedBox(height: 24.h),
          _buildSection('حقوق الملكية', equity, totalEquity),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<BalanceSheetRow> rows, double total) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ReusableText(title, style: AppTextStyles.title(context).copyWith(fontWeight: FontWeight.bold)),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.borderOf(context)),
            borderRadius: BorderRadius.circular(AppRadius.button.r),
          ),
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(AppColors.primarySoftOf(context)),
            columns: [
              DataColumn(label: ReusableText('الحساب', style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.bold))),
              DataColumn(label: ReusableText('مدين', style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.bold)), numeric: true),
              DataColumn(label: ReusableText('دائن', style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.bold)), numeric: true),
              DataColumn(label: ReusableText('الرصيد', style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.bold)), numeric: true),
            ],
            rows: rows.map((r) => DataRow(cells: [
              DataCell(ReusableText(r.accountName, style: AppTextStyles.caption(context))),
              DataCell(ReusableText(r.debit.toStringAsFixed(2), style: AppTextStyles.caption(context))),
              DataCell(ReusableText(r.credit.toStringAsFixed(2), style: AppTextStyles.caption(context))),
              DataCell(ReusableText(r.balance.toStringAsFixed(2), style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.bold))),
            ])).toList(),
          ),
        ),
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: AppColors.primarySoftOf(context),
            borderRadius: BorderRadius.circular(AppRadius.button.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ReusableText('الإجمالي', style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.bold)),
              ReusableText(total.toStringAsFixed(2), style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.bold, color: AppColors.primary)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCashFlow(List<CashFlowRow> rows) {
    final operating = rows.where((r) => r.category == 'Operating').toList();
    final investing = rows.where((r) => r.category == 'Investing').toList();
    final financing = rows.where((r) => r.category == 'Financing').toList();

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildCashFlowSection('Operating', operating),
          SizedBox(height: 24.h),
          _buildCashFlowSection('Investing', investing),
          SizedBox(height: 24.h),
          _buildCashFlowSection('Financing', financing),
        ],
      ),
    );
  }

  Widget _buildCashFlowSection(String category, List<CashFlowRow> rows) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ReusableText(category, style: AppTextStyles.title(context).copyWith(fontWeight: FontWeight.bold)),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.borderOf(context)),
            borderRadius: BorderRadius.circular(AppRadius.button.r),
          ),
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(AppColors.primarySoftOf(context)),
            columns: [
              DataColumn(label: ReusableText('الوصف', style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.bold))),
              DataColumn(label: ReusableText('المبلغ', style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.bold)), numeric: true),
            ],
            rows: rows.map((r) => DataRow(cells: [
              DataCell(ReusableText(r.description, style: AppTextStyles.caption(context))),
              DataCell(ReusableText(r.amount.toStringAsFixed(2), style: AppTextStyles.caption(context))),
            ])).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTrialBalance(List<TrialBalanceRow> rows) {
    final totalDebit = rows.fold<double>(0, (s, r) => s + r.debit);
    final totalCredit = rows.fold<double>(0, (s, r) => s + r.credit);

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.borderOf(context)),
              borderRadius: BorderRadius.circular(AppRadius.button.r),
            ),
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(AppColors.primarySoftOf(context)),
              columns: [
                DataColumn(label: ReusableText('الحساب', style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.bold))),
                DataColumn(label: ReusableText('مدين', style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.bold)), numeric: true),
                DataColumn(label: ReusableText('دائن', style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.bold)), numeric: true),
              ],
              rows: rows.map((r) => DataRow(cells: [
                DataCell(ReusableText(r.accountName, style: AppTextStyles.caption(context))),
                DataCell(ReusableText(r.debit.toStringAsFixed(2), style: AppTextStyles.caption(context))),
                DataCell(ReusableText(r.credit.toStringAsFixed(2), style: AppTextStyles.caption(context))),
              ])).toList(),
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ReusableText('إجمالي مدين', style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.bold)),
                  ReusableText(totalDebit.toStringAsFixed(2), style: AppTextStyles.body(context).copyWith(color: AppColors.success)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ReusableText('إجمالي دائن', style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.bold)),
                  ReusableText(totalCredit.toStringAsFixed(2), style: AppTextStyles.body(context).copyWith(color: AppColors.error)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfitAndLoss(List<ProfitAndLossRow> rows) {
    final revenues = rows.where((r) => r.accountId == 'total_revenue' || _isRevenue(r.accountId)).toList();
    final expenses = rows.where((r) => r.accountId == 'total_expenses' || _isExpense(r.accountId)).toList();

    final totalRevenue = revenues.fold<double>(0, (s, r) => s + r.amount);
    final totalExpenses = expenses.fold<double>(0, (s, r) => s + r.amount);

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildPLSection('الإيرادات', revenues, totalRevenue, AppColors.success),
          SizedBox(height: 24.h),
          _buildPLSection('المصروفات', expenses, totalExpenses, AppColors.error),
          SizedBox(height: 24.h),
          Container(
            padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: (totalRevenue - totalExpenses) >= 0 ? AppColors.success.withValues(alpha: 0.1) : AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.button.r),
                border: Border.all(color: (totalRevenue - totalExpenses) >= 0 ? AppColors.success : AppColors.error),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ReusableText('صافي الربح', style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.bold)),
                  ReusableText(
                    (totalRevenue - totalExpenses).toStringAsFixed(2),
                    style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.bold, color: (totalRevenue - totalExpenses) >= 0 ? AppColors.success : AppColors.error),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPLSection(String title, List<ProfitAndLossRow> rows, double total, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ReusableText(title, style: AppTextStyles.title(context).copyWith(fontWeight: FontWeight.bold, color: color)),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.borderOf(context)),
            borderRadius: BorderRadius.circular(AppRadius.button.r),
          ),
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(AppColors.primarySoftOf(context)),
            columns: [
              DataColumn(label: ReusableText('الحساب', style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.bold))),
              DataColumn(label: ReusableText('المبلغ', style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.bold)), numeric: true),
            ],
            rows: rows.map((r) => DataRow(cells: [
              DataCell(ReusableText(r.accountName, style: AppTextStyles.caption(context))),
              DataCell(ReusableText(r.amount.toStringAsFixed(2), style: AppTextStyles.caption(context).copyWith(color: color))),
            ])).toList(),
          ),
        ),
      ],
    );
  }

  bool _isAsset(String accountId) {
    return accountId.startsWith('system:inventory') ||
           accountId.startsWith('system:cash') ||
           accountId.startsWith('system:bank') ||
           accountId.startsWith('system:card') ||
           accountId.startsWith('system:wallet') ||
           accountId.startsWith('system:accounts_receivable');
  }

  bool _isLiability(String accountId) {
    return accountId.startsWith('system:accounts_payable') ||
           accountId.startsWith('system:tax_payable');
  }

  bool _isRevenue(String accountId) {
    return accountId.startsWith('system:sales_revenue');
  }

  bool _isExpense(String accountId) {
    return accountId.startsWith('system:cost_of_goods_sold') ||
           accountId.startsWith('system:expense') ||
           accountId.startsWith('system:inventory_shrinkage');
  }

  String _typeLabel(FinancialStatementType type) {
    switch (type) {
      case FinancialStatementType.balanceSheet:
        return 'الميزانية العمومية';
      case FinancialStatementType.cashFlow:
        return 'قائمة التدفقات النقدية';
      case FinancialStatementType.trialBalance:
        return 'ميزان المراجعة';
      case FinancialStatementType.profitAndLoss:
        return 'قائمة الأرباح والخسائر';
    }
  }
}

