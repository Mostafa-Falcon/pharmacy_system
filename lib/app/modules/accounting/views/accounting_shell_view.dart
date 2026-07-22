import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../bloc/accounting_bloc.dart';
import '../bloc/party_payments_bloc.dart';
import 'accounts_view.dart';
import 'expenses_view.dart';
import 'journal_view.dart';
import 'party_payments_view.dart';
import 'financial_statements_view.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_colors.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/shareds/home_shell.dart';

class AccountingShellView extends StatefulWidget {
  const AccountingShellView({super.key});

  @override
  State<AccountingShellView> createState() => _AccountingShellViewState();
}

class _AccountingShellViewState extends State<AccountingShellView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AccountingBloc>().add(const LoadAccounting());
      context.read<PartyPaymentsBloc>().add(const LoadPayments());
    });
  }

  @override
  Widget build(BuildContext context) {
    return HomeShell(
      title: 'النظام المحاسبي الموحد',
      subtitle: 'إدارة الحسابات، المصروفات، والقيود المالية للفرع',
      child: DefaultTabController(
        length: 5,
        child: Column(
          children: [
            Container(
              color: AppColors.surfaceOf(context),
              child: TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                indicatorColor: Theme.of(context).colorScheme.primary,
                labelColor: Theme.of(context).colorScheme.primary,
                unselectedLabelColor: AppColors.textSecondaryOf(context),
                labelStyle: TextStyle(fontFamily: 'Cairo', fontSize: 13.sp, fontWeight: FontWeight.bold),
                unselectedLabelStyle: TextStyle(fontFamily: 'Cairo', fontSize: 13.sp, fontWeight: FontWeight.w500),
                tabs: const [
                  Tab(text: 'التقارير المالية'),
                  Tab(text: 'المؤشرات المالية'),
                  Tab(text: 'إدارة المصروفات'),
                  Tab(text: 'دفتر اليومية العامة'),
                  Tab(text: 'سندات القبض والصرف'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  const FinancialStatementsView(),
                  BlocProvider.value(value: context.read<AccountingBloc>(), child: const AccountsView()),
                  BlocProvider.value(value: context.read<AccountingBloc>(), child: const ExpensesView()),
                  BlocProvider.value(value: context.read<AccountingBloc>(), child: const JournalView()),
                  BlocProvider.value(value: context.read<PartyPaymentsBloc>(), child: const PartyPaymentsView()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
