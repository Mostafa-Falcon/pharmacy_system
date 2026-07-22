import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_system/app/modules/contacts/customers/bloc/customers_state.dart';

import 'package:pharmacy_system/app/modules/contacts/models/customer_model.dart';
import 'package:pharmacy_system/app/core/presentation/theme/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/string_ext.dart';
import 'package:pharmacy_system/app/core/presentation/widgets/index.dart';
import '../bloc/customers_bloc.dart';
import '../bloc/customers_event.dart';

class AddCustomerView extends StatefulWidget {
  const AddCustomerView({super.key});

  @override
  State<AddCustomerView> createState() => _AddCustomerViewState();
}

class _AddCustomerViewState extends State<AddCustomerView> {
  final _formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final companyCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final taxCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final notesCtrl = TextEditingController();
  final creditLimitCtrl = TextEditingController(text: '0');
  final discountCtrl = TextEditingController(text: '0');
  final paymentDaysCtrl = TextEditingController(text: '0');
  final openingBalanceCtrl = TextEditingController();
  var kind = CustomerKind.regular;
  var openingBalanceDirection = true;
  var isSaving = false;

  @override
  void dispose() {
    nameCtrl.dispose();
    phoneCtrl.dispose();
    companyCtrl.dispose();
    emailCtrl.dispose();
    taxCtrl.dispose();
    addressCtrl.dispose();
    notesCtrl.dispose();
    creditLimitCtrl.dispose();
    discountCtrl.dispose();
    paymentDaysCtrl.dispose();
    openingBalanceCtrl.dispose();
    super.dispose();
  }

  Future<bool> _confirmExit() async {
    if (nameCtrl.text.isEmpty && phoneCtrl.text.isEmpty) return true;
    final res = await showDialog<bool>(
      context: context,
      builder: (context) => ReusableDialog(
        title: AppStrings.confirmExitTitle,
        children: [
          const ReusableText(AppStrings.unsavedChangesConfirm),
          SizedBox(height: 16.h),
          DialogActions(
            cancelText: AppStrings.stayButton,
            confirmText: AppStrings.exitAndIgnoreButton,
            onCancel: () => Navigator.pop(context, false),
            onConfirm: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );
    return res ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CustomersBloc, CustomersState>(
      listenWhen: (prev, current) => prev.isSuccess != current.isSuccess || prev.errorMessage != current.errorMessage,
      listener: (context, state) {
        if (state.isSuccess) {
          Navigator.pop(context);
        } else if (state.errorMessage != null) {
          setState(() => isSaving = false);
        }
      },
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;
          final navigator = Navigator.of(context);
          final shouldPop = await _confirmExit();
          if (shouldPop && mounted) {
            navigator.pop();
          }
        },
        child: StandardFormLayout(
          title: AppStrings.addNewCustomerTitle,
          subtitle: AppStrings.addNewCustomerSubtitle,
          formKey: _formKey,
          maxWidth: 650,
          isSaving: isSaving,
          confirmText: AppStrings.saveCustomerData,
          onConfirm: _submit,
          onCancel: () => Navigator.pop(context),
          children: [
            const SectionHeader(
              icon: Icons.person_outline_rounded,
              title: 'البيانات الشخصية والأساسية',
            ),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: ReusableInput(
                    label: AppStrings.fullNameRequired,
                    hint: AppStrings.customerNameExampleHint,
                    controller: nameCtrl,
                    textDirection: TextDirection.rtl,
                    validator: (v) => v?.trim().isEmpty == true
                        ? AppStrings.nameIsRequired
                        : null,
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: ReusableDropdown<CustomerKind>(
                    labelText: AppStrings.interactionType,
                    hintText: AppStrings.selectInteractionType,
                    items: const [CustomerKind.regular, CustomerKind.cash],
                    value: kind,
                    itemAsString: (k) => k == CustomerKind.regular
                        ? AppStrings.regularInteraction
                        : AppStrings.cashInteraction,
                    onChanged: (v) {
                      if (v != null) {
                        setState(() => kind = v);
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: ReusableInput(
                    label: AppStrings.phone,
                    controller: phoneCtrl,
                    keyboardType: TextInputType.phone,
                    prefixIcon: const Icon(Icons.phone_android_rounded),
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: ReusableInput(
                    label: AppStrings.companyOrInstitution,
                    controller: companyCtrl,
                    prefixIcon: const Icon(Icons.business_rounded),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: ReusableInput(
                    label: AppStrings.emailLabel,
                    controller: emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: ReusableInput(
                    label: AppStrings.taxIdLabel,
                    controller: taxCtrl,
                    prefixIcon: const Icon(Icons.assignment_ind_outlined),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.md),
            ReusableInput(
              label: AppStrings.detailedAddress,
              controller: addressCtrl,
              prefixIcon: const Icon(Icons.location_on_outlined),
            ),
            SizedBox(height: AppSpacing.lg),
            const SectionHeader(
              icon: Icons.account_balance_wallet_rounded,
              title: AppStrings.financialSettings,
            ),
            Row(
              children: [
                Expanded(
                  child: ReusableInput(
                    label: AppStrings.creditLimit,
                    controller: creditLimitCtrl,
                    keyboardType: TextInputType.number,
                    prefixIcon: const Icon(Icons.speed_rounded),
                    hint: '0.00',
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: ReusableInput(
                    label: AppStrings.discountPercentLabel,
                    controller: discountCtrl,
                    keyboardType: TextInputType.number,
                    prefixIcon: const Icon(Icons.percent_rounded),
                    hint: '0',
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: ReusableInput(
                    label: AppStrings.paymentTermDaysLabel,
                    controller: paymentDaysCtrl,
                    keyboardType: TextInputType.number,
                    prefixIcon: const Icon(Icons.calendar_today_rounded),
                    hint: '0',
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: ReusableInput(
                    label: AppStrings.openingBalanceLabel,
                    controller: openingBalanceCtrl,
                    keyboardType: TextInputType.number,
                    hint: '0.00',
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: ReusableDropdown<bool>(
                    labelText: AppStrings.balanceStatusLabel,
                    hintText: AppStrings.select,
                    items: const [true, false],
                    value: openingBalanceDirection,
                    itemAsString: (v) =>
                        v ? AppStrings.debitLabel : AppStrings.creditLabel,
                    onChanged: (v) {
                      if (v != null) {
                        setState(() => openingBalanceDirection = v);
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.lg),
            const SectionHeader(
              icon: Icons.notes_rounded,
              title: AppStrings.additionalNotes,
            ),
            ReusableInput(
              label: AppStrings.additionalNotes,
              controller: notesCtrl,
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => isSaving = true);
    context.read<CustomersBloc>().add(AddCustomer(
          name: nameCtrl.text.trim(),
          kind: kind,
          phone: phoneCtrl.text.trim().nullIfEmpty,
          companyName: companyCtrl.text.trim().nullIfEmpty,
          email: emailCtrl.text.trim().nullIfEmpty,
          taxId: taxCtrl.text.trim().nullIfEmpty,
          address: addressCtrl.text.trim().nullIfEmpty,
          notes: notesCtrl.text.trim().nullIfEmpty,
          creditLimit: double.tryParse(creditLimitCtrl.text) ?? 0,
          discountPercent: double.tryParse(discountCtrl.text) ?? 0,
          paymentTermDays: int.tryParse(paymentDaysCtrl.text) ?? 0,
          openingBalance: double.tryParse(openingBalanceCtrl.text) ?? 0,
          openingBalanceIsDebit: openingBalanceDirection,
        ));
  }
}

