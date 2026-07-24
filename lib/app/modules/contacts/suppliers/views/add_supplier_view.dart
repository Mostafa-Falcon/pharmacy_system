import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_system/app/modules/contacts/suppliers/bloc/suppliers_state.dart';
import '../../../../shared/navigation/app_navigator.dart';

import 'package:pharmacy_system/app/core/models/contacts/supplier_model.dart';
import 'package:pharmacy_system/app/core/constants/ui/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/index.dart';
import '../bloc/suppliers_bloc.dart';
import '../bloc/suppliers_event.dart';

class AddSupplierView extends StatefulWidget {
  const AddSupplierView({super.key});

  @override
  State<AddSupplierView> createState() => _AddSupplierViewState();
}

class _AddSupplierViewState extends State<AddSupplierView> {
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
  var partyType = SupplierPartyType.company;
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<SuppliersBloc, SuppliersState>(
      listenWhen: (prev, current) => prev.status != current.status,
      listener: (context, state) {
        if (state.status == SuppliersStatus.success) {
          Navigator.pop(context);
        } else if (state.status == SuppliersStatus.error) {
          setState(() => isSaving = false);
        }
      },
      child: StandardFormLayout(
        title: SuppliersStrings.addNewSupplierTitle,
        formKey: _formKey,
        maxWidth: 550,
        isSaving: isSaving,
        onConfirm: _submit,
        onCancel: () => AppNavigator.back(),
        confirmText: GeneralStrings.save,
        cancelText: GeneralStrings.cancel,
        children: [
          const SectionHeader(
            icon: Icons.info_outline_rounded,
            title: '???????? ????????',
          ),
          ReusableInput(
            label: SuppliersStrings.nameLabelRequired,
            hint: SuppliersStrings.supplierNameHint,
            controller: nameCtrl,
            textDirection: TextDirection.rtl,
            validator: (v) => v?.trim().isEmpty == true
                ? SuppliersStrings.nameRequired
                : null,
          ),
          SizedBox(height: AppSpacing.md),
          StatefulBuilder(
          builder: (context, setLocalState) => ReusableDropdown<SupplierPartyType>(
            labelText: SuppliersStrings.partyTypeLabel,
            hintText: SuppliersStrings.selectPartyTypeHint,
            items: const [
              SupplierPartyType.company,
              SupplierPartyType.individual,
            ],
            value: partyType,
            itemAsString: (t) => t == SupplierPartyType.company
                ? GeneralStrings.enumPartyTypeCompany
                : GeneralStrings.enumPartyTypeIndividual,
            onChanged: (v) {
              if (v != null) setLocalState(() => partyType = v);
            },
          ),
          ),
          SizedBox(height: AppSpacing.md),
          ReusableInput(
            label: SuppliersStrings.phoneLabelInput,
            controller: phoneCtrl,
            keyboardType: TextInputType.phone,
            textDirection: TextDirection.rtl,
          ),
          SizedBox(height: AppSpacing.lg),
          const SectionHeader(
            icon: Icons.business_rounded,
            title: '?????? ????? ???????',
          ),
          ReusableInput(
            label: SuppliersStrings.companyLabelInput,
            controller: companyCtrl,
            textDirection: TextDirection.rtl,
          ),
          SizedBox(height: AppSpacing.md),
          ReusableInput(
            label: SuppliersStrings.emailLabelInput,
            controller: emailCtrl,
            keyboardType: TextInputType.emailAddress,
            textDirection: TextDirection.ltr,
          ),
          SizedBox(height: AppSpacing.md),
          ReusableInput(
            label: SuppliersStrings.taxIdLabelInput,
            controller: taxCtrl,
            textDirection: TextDirection.ltr,
          ),
          SizedBox(height: AppSpacing.md),
          ReusableInput(
            label: SuppliersStrings.addressLabelInput,
            controller: addressCtrl,
            maxLines: 2,
            textDirection: TextDirection.rtl,
          ),
          SizedBox(height: AppSpacing.md),
          StatefulBuilder(
            builder: (context, setLocalState) =>
                ReusableDropdown<SupplierPartyType>(
              labelText: SuppliersStrings.partyTypeLabel,
              hintText: SuppliersStrings.selectPartyTypeHint,
              items: const [
                SupplierPartyType.company,
                SupplierPartyType.individual
              ],
              value: partyType,
              itemAsString: (p) => p == SupplierPartyType.company
                  ? GeneralStrings.enumPartyTypeCompany
                  : GeneralStrings.enumPartyTypeIndividual,
              onChanged: (v) {
                if (v != null) setLocalState(() => partyType = v);
              },
            ),
          ),
          SizedBox(height: AppSpacing.lg),
          const SectionHeader(
            icon: Icons.account_balance_wallet_rounded,
            title: '???????? ??????? ?????????',
          ),
          ReusableInput(
            label: SuppliersStrings.creditLimitLabelInput,
            controller: creditLimitCtrl,
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: AppSpacing.md),
          ReusableInput(
            label: SuppliersStrings.discountPercentLabelInput,
            controller: discountCtrl,
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: AppSpacing.md),
          ReusableInput(
            label: SuppliersStrings.paymentTermDaysLabelInput,
            controller: paymentDaysCtrl,
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: ReusableInput(
                  label: SuppliersStrings.openingBalanceLabelInput,
                  controller: openingBalanceCtrl,
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: StatefulBuilder(
                  builder: (context, setLocalState) => ReusableDropdown<bool>(
                    labelText: SuppliersStrings.balanceDirectionLabel,
                    hintText: GeneralStrings.select,
                    items: const [true, false],
                    value: openingBalanceDirection,
                    itemAsString: (d) => d
                        ? SuppliersStrings.debitDirection
                        : SuppliersStrings.creditDirection,
                    onChanged: (v) {
                      if (v != null) setLocalState(() => openingBalanceDirection = v);
                    },
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.lg),
          const SectionHeader(
            icon: Icons.notes_rounded,
            title: '??????? ??????',
          ),
          ReusableInput(
            label: SuppliersStrings.notesLabelInput,
            controller: notesCtrl,
            maxLines: 3,
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isSaving = true);
    context.read<SuppliersBloc>().add(AddSupplier(
      name: nameCtrl.text.trim(),
      partyType: partyType,
      phone: phoneCtrl.text.trim().isEmpty ? null : phoneCtrl.text.trim(),
      address: addressCtrl.text.trim().isEmpty ? null : addressCtrl.text.trim(),
      companyName: companyCtrl.text.trim().isEmpty ? null : companyCtrl.text.trim(),
      email: emailCtrl.text.trim().isEmpty ? null : emailCtrl.text.trim(),
      taxId: taxCtrl.text.trim().isEmpty ? null : taxCtrl.text.trim(),
      creditLimit: double.tryParse(creditLimitCtrl.text) ?? 0,
      discountPercent: double.tryParse(discountCtrl.text) ?? 0,
      paymentTermDays: int.tryParse(paymentDaysCtrl.text) ?? 0,
      openingBalance: double.tryParse(openingBalanceCtrl.text) ?? 0,
      openingBalanceIsDebit: openingBalanceDirection,
      notes: notesCtrl.text.trim().isEmpty ? null : notesCtrl.text.trim(),
    ));
  }
}









