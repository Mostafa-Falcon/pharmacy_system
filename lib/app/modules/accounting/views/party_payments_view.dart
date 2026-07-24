// views/party_payments_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:collection/collection.dart';
import '../bloc/party_payments_bloc.dart';
import 'package:pharmacy_system/app/core/models/accounting/party_payment_model.dart';
import 'package:pharmacy_system/app/core/models/accounting/party_payment_enums.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/index.dart';
import 'package:pharmacy_system/app/core/models/contacts/customer_model.dart';
import 'package:pharmacy_system/app/core/models/contacts/supplier_model.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_colors.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_sizes.dart';

class PartyPaymentsView extends StatelessWidget {
  const PartyPaymentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PartyPaymentsBloc, PartyPaymentsState>(
      builder: (context, state) {
        if (state.status == PartyPaymentsStatus.loading) {
          return const LoadingIndicator();
        }
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: AppColors.backgroundOf(context),
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(40.h),
              child: TabBar(
                tabs: const [
                  Tab(text: 'Ø³Ù†Ø¯Ø§Øª Ù…Ù‚Ø¨ÙˆØ¶Ø§Øª Ø§Ù„Ø¹Ù…Ù„Ø§Ø¡'),
                  Tab(text: 'Ø³Ù†Ø¯Ø§Øª Ù…Ø¯ÙÙˆØ¹Ø§Øª Ø§Ù„Ù…ÙˆØ±Ø¯ÙŠÙ†'),
                ],
                labelStyle: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
                indicatorColor: Theme.of(context).colorScheme.primary,
                labelColor: Theme.of(context).colorScheme.primary,
                unselectedLabelColor: AppColors.textSecondaryOf(context),
              ),
            ),
            body: TabBarView(
              children: [
                _PaymentList(
                  payments: state.customerReceipts,
                  icon: Icons.archive_rounded,
                  color: AppColors.success,
                ),
                _PaymentList(
                  payments: state.supplierPayments,
                  icon: Icons.unarchive_rounded,
                  color: AppColors.error,
                ),
              ],
            ),
            floatingActionButton: ReusableFab(
              icon: Icons.add_rounded,
              onPressed: () => _showAddPaymentDialog(context),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          ),
        );
      },
    );
  }

  void _showAddPaymentDialog(BuildContext context) {
    final bloc = context.read<PartyPaymentsBloc>();
    final amountCtrl = TextEditingController();
    final notesCtrl = TextEditingController();

    PartyPaymentKind selectedKind = PartyPaymentKind.customerReceipt;
    String selectedPartyId = '';
    String selectedPartyName = '';
    String selectedMethod = 'cash';

    final kinds = [
      PartyPaymentKind.customerReceipt,
      PartyPaymentKind.supplierPayment,
    ];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => ReusableDialog(
          title: 'Ø¥Ù†Ø´Ø§Ø¡ Ø¥ÙŠØµØ§Ù„ Ù…Ø§Ù„ÙŠ Ø¬Ø¯ÙŠØ¯',
          headerIcon: Icon(
            Icons.payment_rounded,
            color: Theme.of(context).colorScheme.primary,
            size: 20.sp,
          ),
          children: [
            ReusableDropdown<PartyPaymentKind>(
              labelText: 'Ù†ÙˆØ¹ Ø§Ù„Ø³Ù†Ø¯ Ø§Ù„Ù…Ø§Ù„ÙŠ',
              hintText: 'Ø§Ø®ØªØ± Ù†ÙˆØ¹ Ø§Ù„Ø³Ù†Ø¯',
              items: kinds,
              value: selectedKind,
              itemAsString: (k) =>
                  k == PartyPaymentKind.customerReceipt
                      ? 'Ø³Ù†Ø¯ Ù‚Ø¨Ø¶ Ù†Ù‚Ø¯ÙŠØ© Ù…Ù† Ø¹Ù…ÙŠÙ„'
                      : 'Ø³Ù†Ø¯ ØµØ±Ù Ù†Ù‚Ø¯ÙŠØ© Ù„Ù…ÙˆØ±Ø¯',
              onChanged: (v) {
                if (v != null) {
                  setState(() {
                    selectedKind = v;
                    selectedPartyId = '';
                    selectedPartyName = '';
                  });
                }
              },
            ),
            SizedBox(height: AppSpacing.md.h),
            () {
              final isCustomer = selectedKind == PartyPaymentKind.customerReceipt;
              final items =
                  isCustomer
                      ? bloc.state.customers.toList()
                      : bloc.state.suppliers.toList();
              final selectedItem = items.firstWhereOrNull(
                (p) =>
                    (p is CustomerModel && p.id == selectedPartyId) ||
                    (p is SupplierModel && p.id == selectedPartyId),
              );

              return ReusableDropdown<dynamic>(
                labelText: isCustomer ? 'Ø§Ù„Ø¹Ù…ÙŠÙ„ Ø§Ù„Ù…Ø³ØªÙ‡Ø¯Ù' : 'Ø§Ù„Ù…ÙˆØ±Ø¯ Ø§Ù„Ù…Ø³ØªÙ‡Ø¯Ù',
                hintText: 'Ø§Ø®ØªØ± Ø§Ù„Ø­Ø³Ø§Ø¨ Ø§Ù„Ø¬Ø§Ø±ÙŠ',
                items: items,
                value: selectedItem,
                itemAsString: (p) =>
                    p is CustomerModel
                        ? p.name
                        : p is SupplierModel
                        ? p.name
                        : 'Ø­Ø³Ø§Ø¨ Ù…Ø¬Ù‡ÙˆÙ„',
                onChanged: (v) {
                  if (v != null) {
                    setState(() {
                      if (v is CustomerModel) {
                        selectedPartyId = v.id;
                        selectedPartyName = v.name;
                      } else if (v is SupplierModel) {
                        selectedPartyId = v.id;
                        selectedPartyName = v.name;
                      }
                    });
                  }
                },
              );
            }(),
            SizedBox(height: AppSpacing.md.h),
            ReusableInput(
              label: 'Ø§Ù„Ù…Ø¨Ù„Øº Ø§Ù„Ù…Ø³ØªØ­Ù‚ (Ø¬.Ù…)',
              hint: '0.00',
              controller: amountCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: AppSpacing.md.h),
            ReusableDropdown<String>(
              labelText: 'Ù‚Ù†Ø§Ø© Ø§Ù„Ø¥ÙŠØ¯Ø§Ø¹ / Ø§Ù„ØµØ±Ù',
              hintText: 'Ø§Ø®ØªØ± Ø·Ø±ÙŠÙ‚Ø© Ø§Ù„ØªØ³ÙˆÙŠØ©',
              items: const ['cash', 'card', 'bank_transfer', 'mobile_wallet'],
              value: selectedMethod,
              itemAsString: (s) =>
                  s == 'cash'
                      ? 'Ù†Ù‚Ø¯Ø§Ù‹ Ø¨Ø§Ù„Ø®Ø²ÙŠÙ†Ø©'
                      : s == 'card'
                      ? 'Ù…Ø¯ÙÙˆØ¹Ø§Øª Ø¨Ø·Ø§Ù‚Ø© (Ø´Ø¨ÙƒØ©)'
                      : s == 'bank_transfer'
                      ? 'ØªØ­ÙˆÙŠÙ„ Ø¨Ù†ÙƒÙŠ Ù…Ø¨Ø§Ø´Ø±'
                      : 'Ù…Ø­ÙØ¸Ø© ÙƒØ§Ø´ Ø¥Ù„ÙƒØªØ±ÙˆÙ†ÙŠØ©',
              onChanged: (v) {
                if (v != null) setState(() => selectedMethod = v);
              },
            ),
            SizedBox(height: AppSpacing.md.h),
            ReusableInput.text(
              label: 'Ù…Ù„Ø§Ø­Ø¸Ø§Øª Ø¥Ø¶Ø§ÙÙŠØ©',
              hint: 'Ø§Ø®ØªÙŠØ§Ø±ÙŠ...',
              controller: notesCtrl,
            ),
            SizedBox(height: AppSpacing.lg.h),
            DialogActions(
              confirmText: 'Ø§Ø¹ØªÙ…Ø§Ø¯ ÙˆØªØ±Ø­ÙŠÙ„ Ø§Ù„Ø³Ù†Ø¯',
              onConfirm: () async {
                final amount = double.tryParse(amountCtrl.text);
                if (amount == null || amount <= 0 || selectedPartyId.isEmpty) {
                  return;
                }
                if (selectedKind == PartyPaymentKind.customerReceipt) {
                  bloc.add(
                    PostCustomerReceipt(
                      customerId: selectedPartyId,
                      customerName: selectedPartyName,
                      amount: amount,
                      paymentMethod: selectedMethod,
                      notes: notesCtrl.text.isNotEmpty ? notesCtrl.text : null,
                    ),
                  );
                } else {
                  bloc.add(
                    PostSupplierPayment(
                      supplierId: selectedPartyId,
                      supplierName: selectedPartyName,
                      amount: amount,
                      paymentMethod: selectedMethod,
                      notes: notesCtrl.text.isNotEmpty ? notesCtrl.text : null,
                    ),
                  );
                }
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentList extends StatelessWidget {
  final List<PartyPaymentModel> payments;
  final IconData icon;
  final Color color;

  const _PaymentList({required this.payments, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    if (payments.isEmpty) {
      return EmptyState(
        icon: Icons.receipt_long_rounded,
        title: 'Ù„Ø§ ØªÙˆØ¬Ø¯ Ø¥ÙŠØµØ§Ù„Ø§Øª Ø£Ùˆ Ø³Ù†Ø¯Ø§Øª Ù…Ø³Ø¬Ù„Ø©',
        subtitle: 'Ù„Ù… ÙŠØªÙ… Ø¥Ù†Ø´Ø§Ø¡ Ø£ÙŠ Ø³Ù†Ø¯Ø§Øª Ù…Ø§Ù„ÙŠØ© Ù‡Ù†Ø§ Ø¨Ø¹Ø¯',
      );
    }
    return ListView.builder(
      padding: EdgeInsets.all(AppSpacing.md.w),
      physics: const BouncingScrollPhysics(),
      itemCount: payments.length,
      itemBuilder: (context, index) {
        final p = payments[index];
        return Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: TransactionCard(
            icon: Icons.payments_rounded,
            iconColor: color,
            title: 'Ø±Ù‚Ù… Ø§Ù„Ø³Ù†Ø¯: #${p.number} â€” Ø§Ù„Ø·Ø±Ù: ${p.partyName} â€” Ø§Ù„Ù‚ÙŠÙ…Ø©: ${p.amount.toStringAsFixed(2)} Ø¬.Ù…',
            tags: p.notes != null && p.notes!.isNotEmpty
                ? [Tag(label: p.notes!, color: AppColors.textSecondaryOf(context))]
                : const [],
            amount: p.paymentDate.toString().substring(0, 10),
            date: 'Ø·Ø±ÙŠÙ‚Ø© Ø§Ù„ØªØ³ÙˆÙŠØ©: ${p.paymentMethod}',
          ),
        );
      },
    );
  }
}






