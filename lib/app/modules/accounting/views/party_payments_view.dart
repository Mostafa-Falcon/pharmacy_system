// views/party_payments_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:collection/collection.dart';
import '../bloc/party_payments_bloc.dart';
import 'package:pharmacy_system/app/modules/accounting/models/party_payment_model.dart';
import 'package:pharmacy_system/app/modules/accounting/models/party_payment_enums.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/index.dart';
import 'package:pharmacy_system/app/modules/contacts/models/customer_model.dart';
import 'package:pharmacy_system/app/modules/contacts/models/supplier_model.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_colors.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_sizes.dart';

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
                  Tab(text: 'Ã˜Â³Ã™â€ Ã˜Â¯Ã˜Â§Ã˜Âª Ã™â€¦Ã™â€šÃ˜Â¨Ã™Ë†Ã˜Â¶Ã˜Â§Ã˜Âª Ã˜Â§Ã™â€žÃ˜Â¹Ã™â€¦Ã™â€žÃ˜Â§Ã˜Â¡'),
                  Tab(text: 'Ã˜Â³Ã™â€ Ã˜Â¯Ã˜Â§Ã˜Âª Ã™â€¦Ã˜Â¯Ã™ÂÃ™Ë†Ã˜Â¹Ã˜Â§Ã˜Âª Ã˜Â§Ã™â€žÃ™â€¦Ã™Ë†Ã˜Â±Ã˜Â¯Ã™Å Ã™â€ '),
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
          title: 'Ã˜Â¥Ã™â€ Ã˜Â´Ã˜Â§Ã˜Â¡ Ã˜Â¥Ã™Å Ã˜ÂµÃ˜Â§Ã™â€ž Ã™â€¦Ã˜Â§Ã™â€žÃ™Å  Ã˜Â¬Ã˜Â¯Ã™Å Ã˜Â¯',
          headerIcon: Icon(
            Icons.payment_rounded,
            color: Theme.of(context).colorScheme.primary,
            size: 20.sp,
          ),
          children: [
            ReusableDropdown<PartyPaymentKind>(
              labelText: 'Ã™â€ Ã™Ë†Ã˜Â¹ Ã˜Â§Ã™â€žÃ˜Â³Ã™â€ Ã˜Â¯ Ã˜Â§Ã™â€žÃ™â€¦Ã˜Â§Ã™â€žÃ™Å ',
              hintText: 'Ã˜Â§Ã˜Â®Ã˜ÂªÃ˜Â± Ã™â€ Ã™Ë†Ã˜Â¹ Ã˜Â§Ã™â€žÃ˜Â³Ã™â€ Ã˜Â¯',
              items: kinds,
              value: selectedKind,
              itemAsString: (k) =>
                  k == PartyPaymentKind.customerReceipt
                      ? 'Ã˜Â³Ã™â€ Ã˜Â¯ Ã™â€šÃ˜Â¨Ã˜Â¶ Ã™â€ Ã™â€šÃ˜Â¯Ã™Å Ã˜Â© Ã™â€¦Ã™â€  Ã˜Â¹Ã™â€¦Ã™Å Ã™â€ž'
                      : 'Ã˜Â³Ã™â€ Ã˜Â¯ Ã˜ÂµÃ˜Â±Ã™Â Ã™â€ Ã™â€šÃ˜Â¯Ã™Å Ã˜Â© Ã™â€žÃ™â€¦Ã™Ë†Ã˜Â±Ã˜Â¯',
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
                labelText: isCustomer ? 'Ã˜Â§Ã™â€žÃ˜Â¹Ã™â€¦Ã™Å Ã™â€ž Ã˜Â§Ã™â€žÃ™â€¦Ã˜Â³Ã˜ÂªÃ™â€¡Ã˜Â¯Ã™Â' : 'Ã˜Â§Ã™â€žÃ™â€¦Ã™Ë†Ã˜Â±Ã˜Â¯ Ã˜Â§Ã™â€žÃ™â€¦Ã˜Â³Ã˜ÂªÃ™â€¡Ã˜Â¯Ã™Â',
                hintText: 'Ã˜Â§Ã˜Â®Ã˜ÂªÃ˜Â± Ã˜Â§Ã™â€žÃ˜Â­Ã˜Â³Ã˜Â§Ã˜Â¨ Ã˜Â§Ã™â€žÃ˜Â¬Ã˜Â§Ã˜Â±Ã™Å ',
                items: items,
                value: selectedItem,
                itemAsString: (p) =>
                    p is CustomerModel
                        ? p.name
                        : p is SupplierModel
                        ? p.name
                        : 'Ã˜Â­Ã˜Â³Ã˜Â§Ã˜Â¨ Ã™â€¦Ã˜Â¬Ã™â€¡Ã™Ë†Ã™â€ž',
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
              label: 'Ã˜Â§Ã™â€žÃ™â€¦Ã˜Â¨Ã™â€žÃ˜Âº Ã˜Â§Ã™â€žÃ™â€¦Ã˜Â³Ã˜ÂªÃ˜Â­Ã™â€š (Ã˜Â¬.Ã™â€¦)',
              hint: '0.00',
              controller: amountCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: AppSpacing.md.h),
            ReusableDropdown<String>(
              labelText: 'Ã™â€šÃ™â€ Ã˜Â§Ã˜Â© Ã˜Â§Ã™â€žÃ˜Â¥Ã™Å Ã˜Â¯Ã˜Â§Ã˜Â¹ / Ã˜Â§Ã™â€žÃ˜ÂµÃ˜Â±Ã™Â',
              hintText: 'Ã˜Â§Ã˜Â®Ã˜ÂªÃ˜Â± Ã˜Â·Ã˜Â±Ã™Å Ã™â€šÃ˜Â© Ã˜Â§Ã™â€žÃ˜ÂªÃ˜Â³Ã™Ë†Ã™Å Ã˜Â©',
              items: const ['cash', 'card', 'bank_transfer', 'mobile_wallet'],
              value: selectedMethod,
              itemAsString: (s) =>
                  s == 'cash'
                      ? 'Ã™â€ Ã™â€šÃ˜Â¯Ã˜Â§Ã™â€¹ Ã˜Â¨Ã˜Â§Ã™â€žÃ˜Â®Ã˜Â²Ã™Å Ã™â€ Ã˜Â©'
                      : s == 'card'
                      ? 'Ã™â€¦Ã˜Â¯Ã™ÂÃ™Ë†Ã˜Â¹Ã˜Â§Ã˜Âª Ã˜Â¨Ã˜Â·Ã˜Â§Ã™â€šÃ˜Â© (Ã˜Â´Ã˜Â¨Ã™Æ’Ã˜Â©)'
                      : s == 'bank_transfer'
                      ? 'Ã˜ÂªÃ˜Â­Ã™Ë†Ã™Å Ã™â€ž Ã˜Â¨Ã™â€ Ã™Æ’Ã™Å  Ã™â€¦Ã˜Â¨Ã˜Â§Ã˜Â´Ã˜Â±'
                      : 'Ã™â€¦Ã˜Â­Ã™ÂÃ˜Â¸Ã˜Â© Ã™Æ’Ã˜Â§Ã˜Â´ Ã˜Â¥Ã™â€žÃ™Æ’Ã˜ÂªÃ˜Â±Ã™Ë†Ã™â€ Ã™Å Ã˜Â©',
              onChanged: (v) {
                if (v != null) setState(() => selectedMethod = v);
              },
            ),
            SizedBox(height: AppSpacing.md.h),
            ReusableInput.text(
              label: 'Ã™â€¦Ã™â€žÃ˜Â§Ã˜Â­Ã˜Â¸Ã˜Â§Ã˜Âª Ã˜Â¥Ã˜Â¶Ã˜Â§Ã™ÂÃ™Å Ã˜Â©',
              hint: 'Ã˜Â§Ã˜Â®Ã˜ÂªÃ™Å Ã˜Â§Ã˜Â±Ã™Å ...',
              controller: notesCtrl,
            ),
            SizedBox(height: AppSpacing.lg.h),
            DialogActions(
              confirmText: 'Ã˜Â§Ã˜Â¹Ã˜ÂªÃ™â€¦Ã˜Â§Ã˜Â¯ Ã™Ë†Ã˜ÂªÃ˜Â±Ã˜Â­Ã™Å Ã™â€ž Ã˜Â§Ã™â€žÃ˜Â³Ã™â€ Ã˜Â¯',
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
        title: 'Ã™â€žÃ˜Â§ Ã˜ÂªÃ™Ë†Ã˜Â¬Ã˜Â¯ Ã˜Â¥Ã™Å Ã˜ÂµÃ˜Â§Ã™â€žÃ˜Â§Ã˜Âª Ã˜Â£Ã™Ë† Ã˜Â³Ã™â€ Ã˜Â¯Ã˜Â§Ã˜Âª Ã™â€¦Ã˜Â³Ã˜Â¬Ã™â€žÃ˜Â©',
        subtitle: 'Ã™â€žÃ™â€¦ Ã™Å Ã˜ÂªÃ™â€¦ Ã˜Â¥Ã™â€ Ã˜Â´Ã˜Â§Ã˜Â¡ Ã˜Â£Ã™Å  Ã˜Â³Ã™â€ Ã˜Â¯Ã˜Â§Ã˜Âª Ã™â€¦Ã˜Â§Ã™â€žÃ™Å Ã˜Â© Ã™â€¡Ã™â€ Ã˜Â§ Ã˜Â¨Ã˜Â¹Ã˜Â¯',
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
            title: 'Ã˜Â±Ã™â€šÃ™â€¦ Ã˜Â§Ã™â€žÃ˜Â³Ã™â€ Ã˜Â¯: #${p.number} Ã¢â‚¬â€ Ã˜Â§Ã™â€žÃ˜Â·Ã˜Â±Ã™Â: ${p.partyName} Ã¢â‚¬â€ Ã˜Â§Ã™â€žÃ™â€šÃ™Å Ã™â€¦Ã˜Â©: ${p.amount.toStringAsFixed(2)} Ã˜Â¬.Ã™â€¦',
            tags: p.notes != null && p.notes!.isNotEmpty
                ? [Tag(label: p.notes!, color: AppColors.textSecondaryOf(context))]
                : const [],
            amount: p.paymentDate.toString().substring(0, 10),
            date: 'Ã˜Â·Ã˜Â±Ã™Å Ã™â€šÃ˜Â© Ã˜Â§Ã™â€žÃ˜ÂªÃ˜Â³Ã™Ë†Ã™Å Ã˜Â©: ${p.paymentMethod}',
          ),
        );
      },
    );
  }
}


