import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:pharmacy_system/app/core/constants/ui/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/string_ext.dart';
import 'package:pharmacy_system/app/shared/presentation/widgets/index.dart';
import '../bloc/supplier_customers_bloc.dart';
import '../bloc/supplier_customers_event.dart';
import '../bloc/supplier_customers_state.dart';

class AddSupplierCustomerView extends StatefulWidget {
  const AddSupplierCustomerView({super.key});

  @override
  State<AddSupplierCustomerView> createState() => _AddSupplierCustomerViewState();
}

class _AddSupplierCustomerViewState extends State<AddSupplierCustomerView> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late final TextEditingController nameCtrl;
  late final TextEditingController phoneCtrl;
  late final TextEditingController addressCtrl;
  late final TextEditingController emailCtrl;
  late final TextEditingController companyNameCtrl;
  late final TextEditingController taxIdCtrl;
  late final TextEditingController notesCtrl;
  late final TextEditingController creditLimitCtrl;
  late final TextEditingController discountPercentCtrl;
  late final TextEditingController paymentTermDaysCtrl;
  late final TextEditingController openingBalanceCtrl;

  // Local state for dropdowns
  int _customerKindIndex = 0;
  int _supplierPartyTypeIndex = 0;
  bool _openingBalanceDirection = true; // true = debit, false = credit

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController();
    phoneCtrl = TextEditingController();
    addressCtrl = TextEditingController();
    emailCtrl = TextEditingController();
    companyNameCtrl = TextEditingController();
    taxIdCtrl = TextEditingController();
    notesCtrl = TextEditingController();
    creditLimitCtrl = TextEditingController(text: '0');
    discountPercentCtrl = TextEditingController(text: '0');
    paymentTermDaysCtrl = TextEditingController(text: '0');
    openingBalanceCtrl = TextEditingController(text: '0');
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    phoneCtrl.dispose();
    addressCtrl.dispose();
    emailCtrl.dispose();
    companyNameCtrl.dispose();
    taxIdCtrl.dispose();
    notesCtrl.dispose();
    creditLimitCtrl.dispose();
    discountPercentCtrl.dispose();
    paymentTermDaysCtrl.dispose();
    openingBalanceCtrl.dispose();
    super.dispose();
  }

  void _onSave(BuildContext context) {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    context.read<SupplierCustomersBloc>().add(AddSupplierCustomer(
          name: nameCtrl.text.trim(),
          phone: phoneCtrl.text.trim().nullIfEmpty,
          address: addressCtrl.text.trim().nullIfEmpty,
          email: emailCtrl.text.trim().nullIfEmpty,
          companyName: companyNameCtrl.text.trim().nullIfEmpty,
          taxId: taxIdCtrl.text.trim().nullIfEmpty,
          notes: notesCtrl.text.trim().nullIfEmpty,
          customerKindIndex: _customerKindIndex,
          creditLimit: double.tryParse(creditLimitCtrl.text) ?? 0,
          discountPercent: double.tryParse(discountPercentCtrl.text) ?? 0,
          paymentTermDays: int.tryParse(paymentTermDaysCtrl.text) ?? 0,
          supplierPartyTypeIndex: _supplierPartyTypeIndex,
          openingBalance: double.tryParse(openingBalanceCtrl.text) ?? 0,
          openingBalanceDirection: _openingBalanceDirection ? 'debit' : 'credit',
        ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SupplierCustomersBloc, SupplierCustomersState>(
      listenWhen: (prev, current) => prev.isSuccess != current.isSuccess,
      listener: (context, state) {
        if (state.isSuccess) {
          context.pop();
        }
      },
      child: HomeShell(
        title: CrmStrings.addNewPartyTitle,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.xl.w),
          child: Form(
            key: _formKey,
            child: Center(
              child: AppCard.form(
                maxWidth: 800,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionHeader(icon: Icons.person_add_alt_1_outlined, title: CrmStrings.personalAndBasicInfo),
                    SizedBox(height: AppSpacing.md.h),
                    _buildPersonalSection(),
                    SizedBox(height: AppSpacing.lg.h),
                    const SectionHeader(icon: Icons.business_center_outlined, title: CrmStrings.businessAndActivityDetails),
                    SizedBox(height: AppSpacing.md.h),
                    _buildBusinessSection(),
                    SizedBox(height: AppSpacing.lg.h),
                    const SectionHeader(icon: Icons.payments_outlined, title: CrmStrings.financialAndCreditPolicies),
                    SizedBox(height: AppSpacing.md.h),
                    _buildFinancialSection(),
                    SizedBox(height: AppSpacing.lg.h),
                    SectionHeader(icon: Icons.account_balance_outlined, title: CrmStrings.openingBalanceAtStart),
                    SizedBox(height: AppSpacing.md.h),
                    _buildOpeningBalanceSection(),
                    SizedBox(height: AppSpacing.lg.h),
                    AppInput(
                      label: CustomersStrings.additionalNotes,
                      controller: notesCtrl,
                      maxLines: 3,
                      textDirection: TextDirection.rtl,
                      prefixIcon: const Icon(Icons.note_alt_outlined),
                    ),
                    SizedBox(height: AppSpacing.xxl.h),
                    _buildSubmitButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPersonalSection() {
    return Column(
      children: [
        AppInput(
          label: CrmStrings.partyFullNameLabel,
          controller: nameCtrl,
          textDirection: TextDirection.rtl,
          prefixIcon: const Icon(Icons.person_outline),
          validator: (v) => v?.trim().isEmpty == true ? CrmStrings.partyNameRequiredWarning : null,
        ),
        SizedBox(height: AppSpacing.md.h),
        Row(
          children: [
            Expanded(
              child: AppInput(
                label: GeneralStrings.phone,
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
                textDirection: TextDirection.rtl,
                prefixIcon: const Icon(Icons.phone_outlined),
              ),
            ),
            SizedBox(width: AppSpacing.md.w),
            Expanded(
              child: AppInput(
                label: AuthStrings.emailLabel,
                controller: emailCtrl,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(Icons.email_outlined),
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.md.h),
        AppInput(
          label: CrmStrings.detailedAddressLabel,
          controller: addressCtrl,
          textDirection: TextDirection.rtl,
          prefixIcon: const Icon(Icons.location_on_outlined),
        ),
      ],
    );
  }

  Widget _buildBusinessSection() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: AppInput(
                label: CrmStrings.companyNameOptional,
                controller: companyNameCtrl,
                textDirection: TextDirection.rtl,
                prefixIcon: const Icon(Icons.corporate_fare_outlined),
              ),
            ),
            SizedBox(width: AppSpacing.md.w),
            Expanded(
              child: AppInput(
                label: CustomersStrings.taxIdLabel,
                controller: taxIdCtrl,
                textDirection: TextDirection.rtl,
                prefixIcon: const Icon(Icons.receipt_outlined),
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.md.h),
        AppDropdown<int>(
          labelText: CrmStrings.legalEntityType,
          hintText: CrmStrings.selectEntityTypeHint,
          items: const [0, 1],
          value: _supplierPartyTypeIndex,
          itemAsString: (i) => i == 0 ? CrmStrings.companyOrInstitutionLabel : CrmStrings.individualOrMerchantLabel,
          onChanged: (v) => setState(() => _supplierPartyTypeIndex = v!),
        ),
      ],
    );
  }

  Widget _buildFinancialSection() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: AppDropdown<int>(
                labelText: CrmStrings.defaultInteractionMethod,
                hintText: CrmStrings.selectInteractionMethodHint,
                items: const [0, 1],
                value: _customerKindIndex,
                itemAsString: (i) => i == 0 ? CrmStrings.regularCreditLabel : CrmStrings.cashOnlyLabel,
                onChanged: (v) => setState(() => _customerKindIndex = v!),
              ),
            ),
            SizedBox(width: AppSpacing.md.w),
            Expanded(
              child: AppInput(
                label: CrmStrings.agreedDiscountPercent,
                controller: discountPercentCtrl,
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(Icons.percent_rounded),
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.md.h),
        Row(
          children: [
            Expanded(
              child: AppInput(
                label: CrmStrings.maximumCreditLimit,
                controller: creditLimitCtrl,
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(Icons.money_off_csred_outlined),
              ),
            ),
            SizedBox(width: AppSpacing.md.w),
            Expanded(
              child: AppInput(
                label: CrmStrings.grantedPaymentTermDays,
                controller: paymentTermDaysCtrl,
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(Icons.date_range_outlined),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOpeningBalanceSection() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: AppInput(
              label: CrmStrings.balanceValue,
              controller: openingBalanceCtrl,
              keyboardType: TextInputType.number,
              hint: '0.00',
              prefixIcon: const Icon(Icons.account_balance_wallet_outlined),
            ),
          ),
          SizedBox(width: AppSpacing.md.w),
          Expanded(
            flex: 1,
            child: AppDropdown<bool>(
              labelText: CustomersStrings.balanceStatusLabel,
              hintText: CrmStrings.balanceStatusHint,
              items: const [true, false],
              value: _openingBalanceDirection,
              itemAsString: (v) => v ? CrmStrings.debitOurDues : CrmStrings.creditTheirDues,
              onChanged: (v) => setState(() => _openingBalanceDirection = v!),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return BlocBuilder<SupplierCustomersBloc, SupplierCustomersState>(
      builder: (context, state) {
        final isSaving = state.status == SupplierCustomersStatus.loading;
        return AppButton(
          text: CrmStrings.savePartyData,
          prefixIcon: Icons.save_rounded,
          isLoading: isSaving,
          onPressed: () => _onSave(context),
        );
      },
    );
  }
}




