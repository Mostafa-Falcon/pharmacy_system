import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' hide TextDirection;
import '../bloc/accounting_bloc.dart';
import 'package:pharmacy_system/app/modules/accounting/models/expense_model.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/index.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_colors.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_sizes.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../core/constants/app_strings.dart';

class ExpensesView extends StatefulWidget {
  const ExpensesView({super.key});

  @override
  State<ExpensesView> createState() => _ExpensesViewState();
}

class _ExpensesViewState extends State<ExpensesView> {
  final _searchCtrl = TextEditingController();
  DateTime? _filterFrom;
  DateTime? _filterTo;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountingBloc, AccountingState>(
      builder: (context, state) {
        if (state.status == AccountingStatus.loading) {
          return const Center(child: LoadingIndicator());
        }

        return StandardModuleLayout(
          useShell: false,
          padding: EdgeInsets.zero,
          title: 'إدارة المصروفات',
          actions: _buildHeaderActions(context),
          filters: _buildFilters(context),
          content: _buildContent(context, state),
        );
      },
    );
  }

  List<Widget> _buildHeaderActions(BuildContext context) {
    return [
      ReusableButton(
        text: AccountingStrings.expenseImportExcel,
        prefixIcon: Icons.file_upload_rounded,
        type: ButtonType.outlined,
        onPressed: () => context.push(Routes.ACCOUNTING_EXPENSES_IMPORT),
      ),
    ];
  }

  Widget _buildFilters(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          ReusableInput(
            label: AccountingStrings.expenseSearchHint,
            hint: AccountingStrings.expenseSearchHelper,
            controller: _searchCtrl,
            prefixIcon: const Icon(Icons.search_rounded, size: 18),
            onChanged: (v) {
              _applyFilters();
            },
          ),
          SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: _DateFilterChip(
                  label: _filterFrom != null
                      ? DateFormat('yyyy/MM/dd').format(_filterFrom!)
                      : AccountingStrings.expenseFilterFromDate,
                  onSelected: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _filterFrom ??
                          DateTime.now().subtract(const Duration(days: 30)),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                      helpText: AccountingStrings.expenseFilterFromDate,
                    );
                    if (picked != null) {
                      setState(() => _filterFrom = picked);
                      _applyFilters();
                    }
                  },
                  onClear: () {
                    setState(() => _filterFrom = null);
                    _applyFilters();
                  },
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _DateFilterChip(
                  label: _filterTo != null
                      ? DateFormat('yyyy/MM/dd').format(_filterTo!)
                      : AccountingStrings.expenseFilterToDate,
                  onSelected: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _filterTo ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                      helpText: AccountingStrings.expenseFilterToDate,
                    );
                    if (picked != null) {
                      setState(() => _filterTo = picked);
                      _applyFilters();
                    }
                  },
                  onClear: () {
                    setState(() => _filterTo = null);
                    _applyFilters();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, AccountingState state) {
    final displayExpenses = state.filteredExpenses.isNotEmpty
        ? state.filteredExpenses
        : state.expenses;

    if (displayExpenses.isEmpty) {
      return const EmptyState(
        icon: Icons.receipt_long_rounded,
        title: AccountingStrings.accountingNoExpenses,
        subtitle: AccountingStrings.accountingNoExpensesSubtitle,
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListView.builder(
        padding: EdgeInsets.only(bottom: 80.h),
        physics: const BouncingScrollPhysics(),
        itemCount: displayExpenses.length,
        itemBuilder: (context, index) {
          final e = displayExpenses[index];
          return Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.sm.h),
            child: TransactionCard(
              icon: Icons.receipt_long_rounded,
              iconColor: AppColors.error,
              title:
                  '${AccountingStrings.accountingExpensePrefix}${e.expenseNumber} - ${e.category}',
              tags: e.description != null && e.description!.isNotEmpty
                  ? [
                      Tag(
                          label: e.description!,
                          color: AppColors.textSecondaryOf(context))
                    ]
                  : const [],
              amount: '${e.amount.toStringAsFixed(2)} ${AppStrings.currency}',
              date: _formatPaymentMethod(e.paymentMethod),
              amountSubtext: e.expenseDate.toString().substring(0, 10),
              menuItems: [
                const PopupMenuItem(value: 'edit', child: Text('تعديل المصروف')),
                const PopupMenuItem(value: 'delete', child: Text('حذف المصروف')),
              ],
              onMenuSelected: (action) {
                if (action == 'edit') {
                  _showEditExpenseDialog(context, e);
                } else if (action == 'delete') {
                  _confirmDeleteExpense(context, e);
                }
              },
            ),
          );
        },
      ),
      floatingActionButton: ReusableFab(
        icon: Icons.add_rounded,
        onPressed: () => _showAddExpenseDialog(context),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  String _formatPaymentMethod(String method) => switch (method) {
    'cash' => 'نقدي (الخزينة)',
    'card' => 'بطاقة بنكية',
    'bank_transfer' => 'تحويل بنكي',
    'mobile_wallet' => 'محفظة إلكترونية',
    _ => method,
  };

  void _showAddExpenseDialog(BuildContext context) {
    final descCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    String selectedMethod = 'cash';
    DateTime selectedDate = DateTime.now();
    final categories = [
      'إيجار الفرع',
      'مرتبات موظفين',
      'فواتير ومرافق',
      'صيانة وتجهيزات',
      'تسويق ودعاية',
      'نقل وشحن',
      'أخرى',
    ];
    String selectedCategory = categories.first;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => ReusableDialog(
          title: 'تسجيل مصروفات جديد',
          headerIcon: const Icon(Icons.add_card_rounded),
          children: [
            ReusableDropdown<String>(
              labelText: 'تصنيف المصروف',
              hintText: 'اختر التصنيف الرئيسي',
              items: categories,
              value: selectedCategory,
              itemAsString: (s) => s,
              onChanged: (v) {
                if (v != null) setState(() => selectedCategory = v);
              },
            ),
            SizedBox(height: AppSpacing.sm.h),
            ReusableInput(
              label: 'البيان والتفاصيل',
              hint: 'اكتب تفاصيل المصروف هنا...',
              controller: descCtrl,
              maxLines: 2,
              textDirection: TextDirection.rtl,
            ),
            SizedBox(height: AppSpacing.sm.h),
            ReusableInput(
              label: 'ملاحظات',
              hint: 'ملاحظات إضافية...',
              controller: notesCtrl,
              maxLines: 2,
              textDirection: TextDirection.rtl,
            ),
            SizedBox(height: AppSpacing.sm.h),
            ReusableInput(
              label: 'القيمة المالية (${AppStrings.currency})',
              hint: '0.00',
              controller: amountCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              prefixIcon: const Icon(Icons.payments_rounded, size: 18),
            ),
            SizedBox(height: AppSpacing.sm.h),
            ReusableDropdown<String>(
              labelText: 'طريقة الدفع',
              hintText: 'اختر حساب الدفع',
              items: const ['cash', 'card', 'bank_transfer', 'mobile_wallet'],
              value: selectedMethod,
              itemAsString: (s) =>
                  s == 'cash'
                      ? 'خزينة الصيدلية (نقدي)'
                      : s == 'card'
                      ? 'شبكة / بطاقة بنكية'
                      : s == 'bank_transfer'
                      ? 'تحويل بنكي'
                      : 'محفظة إلكترونية',
              onChanged: (v) {
                if (v != null) setState(() => selectedMethod = v);
              },
            ),
            SizedBox(height: AppSpacing.sm.h),
            Row(
              children: [
                const Text('تاريخ المصروف: '),
                TextButton.icon(
                  icon: const Icon(Icons.calendar_today, size: 16),
                  label: Text(DateFormat('yyyy/MM/dd').format(selectedDate)),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() => selectedDate = picked);
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: AppSpacing.lg.h),
            DialogActions(
              confirmText: 'حفظ وترحيل القيد',
              onConfirm: () async {
                final amount = double.tryParse(amountCtrl.text);
                if (amount == null || amount <= 0) {
                  AppSnackbar.error('يرجى إدخال مبلغ صحيح');
                  return;
                }
                context.read<AccountingBloc>().add(
                  AddExpense(
                    category: selectedCategory,
                    description: descCtrl.text.isNotEmpty ? descCtrl.text : null,
                    amount: amount,
                    paymentMethod: selectedMethod,
                    notes: notesCtrl.text.isNotEmpty ? notesCtrl.text : null,
                    expenseDate: selectedDate,
                  ),
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showEditExpenseDialog(BuildContext context, ExpenseModel expense) {
    final descCtrl = TextEditingController(text: expense.description ?? '');
    final amountCtrl = TextEditingController(text: expense.amount.toString());
    final notesCtrl = TextEditingController(text: expense.notes ?? '');
    String selectedMethod = expense.paymentMethod;
    DateTime selectedDate = expense.expenseDate;
    final categories = [
      'إيجار الفرع',
      'مرتبات موظفين',
      'فواتير ومرافق',
      'صيانة وتجهيزات',
      'تسويق ودعاية',
      'نقل وشحن',
      'أخرى',
    ];
    String selectedCategory = categories.contains(expense.category)
        ? expense.category
        : 'أخرى';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => ReusableDialog(
          title: 'تعديل المصروف #${expense.expenseNumber}',
          headerIcon: const Icon(Icons.edit_rounded),
          children: [
            ReusableDropdown<String>(
              labelText: 'تصنيف المصروف',
              hintText: 'اختر التصنيف الرئيسي',
              items: categories,
              value: selectedCategory,
              itemAsString: (s) => s,
              onChanged: (v) {
                if (v != null) setState(() => selectedCategory = v);
              },
            ),
            SizedBox(height: AppSpacing.sm.h),
            ReusableInput(
              label: 'البيان والتفاصيل',
              hint: 'اكتب تفاصيل المصروف هنا...',
              controller: descCtrl,
              maxLines: 2,
              textDirection: TextDirection.rtl,
            ),
            SizedBox(height: AppSpacing.sm.h),
            ReusableInput(
              label: 'ملاحظات',
              hint: 'ملاحظات إضافية...',
              controller: notesCtrl,
              maxLines: 2,
              textDirection: TextDirection.rtl,
            ),
            SizedBox(height: AppSpacing.sm.h),
            ReusableInput(
              label: 'القيمة المالية (${AppStrings.currency})',
              hint: '0.00',
              controller: amountCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              prefixIcon: const Icon(Icons.payments_rounded, size: 18),
            ),
            SizedBox(height: AppSpacing.sm.h),
            ReusableDropdown<String>(
              labelText: 'طريقة الدفع',
              hintText: 'اختر حساب الدفع',
              items: const ['cash', 'card', 'bank_transfer', 'mobile_wallet'],
              value: selectedMethod,
              itemAsString: (s) =>
                  s == 'cash'
                      ? 'خزينة الصيدلية (نقدي)'
                      : s == 'card'
                      ? 'شبكة / بطاقة بنكية'
                      : s == 'bank_transfer'
                      ? 'تحويل بنكي'
                      : 'محفظة إلكترونية',
              onChanged: (v) {
                if (v != null) setState(() => selectedMethod = v);
              },
            ),
            SizedBox(height: AppSpacing.sm.h),
            Row(
              children: [
                const Text('تاريخ المصروف: '),
                TextButton.icon(
                  icon: const Icon(Icons.calendar_today, size: 16),
                  label: Text(DateFormat('yyyy/MM/dd').format(selectedDate)),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() => selectedDate = picked);
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: AppSpacing.lg.h),
            DialogActions(
              confirmText: 'حفظ التعديلات',
              onConfirm: () async {
                final amount = double.tryParse(amountCtrl.text);
                if (amount == null || amount <= 0) {
                  AppSnackbar.error('يرجى إدخال مبلغ صحيح');
                  return;
                }
                context.read<AccountingBloc>().add(
                  UpdateExpense(
                    id: expense.id,
                    category: selectedCategory,
                    description: descCtrl.text.isNotEmpty ? descCtrl.text : null,
                    amount: amount,
                    paymentMethod: selectedMethod,
                    notes: notesCtrl.text.isNotEmpty ? notesCtrl.text : null,
                    expenseDate: selectedDate,
                  ),
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _applyFilters() {
    if (!mounted) return;
    context.read<AccountingBloc>().add(FilterExpenses(
      query: _searchCtrl.text.isNotEmpty ? _searchCtrl.text : null,
      fromDate: _filterFrom,
      toDate: _filterTo,
    ));
  }

  void _confirmDeleteExpense(BuildContext context, ExpenseModel expense) {
    showDialog(
      context: context,
      builder: (ctx) => ReusableDialog(
        title: 'حذف المصروف',
        headerIcon: const Icon(Icons.warning_rounded, color: Colors.red),
        children: [
          Text('هل أنت متأكد من حذف المصروف "${AccountingStrings.accountingExpensePrefix}${expense.expenseNumber}"؟'),
          Text('سيتم أيضًا حذف القيد المحاسبي المرتبط.', style: AppTextStyles.caption(context)),
          SizedBox(height: AppSpacing.lg.h),
          DialogActions(
            confirmText: 'حذف',
            confirmType: ButtonType.error,
            cancelText: 'إلغاء',
            onConfirm: () {
              context.read<AccountingBloc>().add(DeleteExpense(id: expense.id));
              Navigator.pop(ctx);
            },
          ),
        ],
      ),
    );
  }
}

class _DateFilterChip extends StatelessWidget {
  final String label;
  final VoidCallback onSelected;
  final VoidCallback onClear;

  const _DateFilterChip({
    required this.label,
    required this.onSelected,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return InputChip(
      label: Text(label, style: const TextStyle(fontSize: 12)),
      onPressed: onSelected,
      deleteIcon: const Icon(Icons.close, size: 14),
      onDeleted: onClear,
    );
  }
}

