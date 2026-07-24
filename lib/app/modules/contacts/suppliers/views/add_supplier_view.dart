import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_system/app/shared/ui_core.dart';
import 'package:pharmacy_system/app/modules/contacts/suppliers/bloc/suppliers_state.dart';
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
        maxWidth: 650,
        isSaving: isSaving,
        onConfirm: _submit,
        onCancel: () => Navigator.pop(context),
        confirmText: GeneralStrings.save,
        children: [
          const SectionHeader(
            icon: Icons.info_outline_rounded,
            title: CrmStrings.personalAndBasicInfo,
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: AppInput(
                  label: SuppliersStrings.nameLabelRequired,
                  hint: SuppliersStrings.supplierNameHint,
                  controller: nameCtrl,
                  validator: (v) => v?.trim().isEmpty == true
                      ? SuppliersStrings.nameRequired
                      : null,
                ),
              ),
              SizedBox(width: AppSpacing.md.w),
              Expanded(
                child: AppDropdown<SupplierPartyType>(
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
                    if (v != null) setState(() => partyType = v);
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md.h),
          Row(
            children: [
              Expanded(
                child: AppInput(
                  label: SuppliersStrings.phoneLabelInput,
                  controller: phoneCtrl,
                  keyboardType: TextInputType.phone,
                  prefixIcon: const Icon(Icons.phone_android_rounded),
                ),
              ),
              SizedBox(width: AppSpacing.md.w),
              Expanded(
                child: AppInput(
                  label: SuppliersStrings.companyLabelInput,
                  controller: companyCtrl,
                  prefixIcon: const Icon(Icons.business_rounded),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md.h),
          Row(
            children: [
              Expanded(
                child: ReusableInput.email(
                  label: SuppliersStrings.emailLabelInput,
                  controller: emailCtrl,
                  validator: (v) => v != null && v.isNotEmpty ? AppValidators.validateEmail(v) : null,
                ),
              ),
              SizedBox(width: AppSpacing.md.w),
              Expanded(
                child: AppInput(
                  label: SuppliersStrings.taxIdLabelInput,
                  controller: taxCtrl,
                  prefixIcon: const Icon(Icons.assignment_ind_outlined),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md.h),
          AppInput(
            label: SuppliersStrings.addressLabelInput,
            controller: addressCtrl,
            prefixIcon: const Icon(Icons.location_on_outlined),
          ),
          SizedBox(height: AppSpacing.lg.h),
          const SectionHeader(
            icon: Icons.account_balance_wallet_rounded,
            title: CrmStrings.financialAndCreditPolicies,
          ),
          Row(
            children: [
              Expanded(
                child: AppInput(
                  label: SuppliersStrings.creditLimitLabelInput,
                  controller: creditLimitCtrl,
                  keyboardType: TextInputType.number,
                  prefixIcon: const Icon(Icons.speed_rounded),
                  hint: '0.00',
                ),
              ),
              SizedBox(width: AppSpacing.md.w),
              Expanded(
                child: AppInput(
                  label: SuppliersStrings.discountPercentLabelInput,
                  controller: discountCtrl,
                  keyboardType: TextInputType.number,
                  prefixIcon: const Icon(Icons.percent_rounded),
                  hint: '0',
                ),
              ),
              SizedBox(width: AppSpacing.md.w),
              Expanded(
                child: AppInput(
                  label: SuppliersStrings.paymentTermDaysLabelInput,
                  controller: paymentDaysCtrl,
                  keyboardType: TextInputType.number,
                  prefixIcon: const Icon(Icons.calendar_today_rounded),
                  hint: '0',
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md.h),
          Row(
            children: [
              Expanded(
                child: AppInput(
                  label: SuppliersStrings.openingBalanceLabelInput,
                  controller: openingBalanceCtrl,
                  keyboardType: TextInputType.number,
                  hint: '0.00',
                ),
              ),
              SizedBox(width: AppSpacing.md.w),
              Expanded(
                child: AppDropdown<bool>(
                  labelText: SuppliersStrings.balanceDirectionLabel,
                  hintText: GeneralStrings.select,
                  items: const [true, false],
                  value: openingBalanceDirection,
                  itemAsString: (d) => d
                      ? SuppliersStrings.debitDirection
                      : SuppliersStrings.creditDirection,
                  onChanged: (v) {
                    if (v != null) setState(() => openingBalanceDirection = v);
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.lg.h),
          const SectionHeader(
            icon: Icons.notes_rounded,
            title: CrmStrings.crmAdditionalNotes,
          ),
          AppInput(
            label: SuppliersStrings.notesLabelInput,
            controller: notesCtrl,
            maxLines: 3,
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
      phone: phoneCtrl.text.trim().nullIfEmpty,
      address: addressCtrl.text.trim().nullIfEmpty,
      companyName: companyCtrl.text.trim().nullIfEmpty,
      email: emailCtrl.text.trim().nullIfEmpty,
      taxId: taxCtrl.text.trim().nullIfEmpty,
      creditLimit: double.tryParse(creditLimitCtrl.text) ?? 0,
      discountPercent: double.tryParse(discountCtrl.text) ?? 0,
      paymentTermDays: int.tryParse(paymentDaysCtrl.text) ?? 0,
      openingBalance: double.tryParse(openingBalanceCtrl.text) ?? 0,
      openingBalanceIsDebit: openingBalanceDirection,
      notes: notesCtrl.text.trim().nullIfEmpty,
    ));
  }
}
