import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_system/app/core/constants/app_strings.dart';
import 'package:pharmacy_system/app/modules/admin/models/settings_model.dart';
import '../../bloc/settings_bloc.dart';
import 'package:pharmacy_system/app/core/data/services/print_settings_service.dart';
import './widgets_tabs/settings_shell.dart';
import './widgets_tabs/settings_builders.dart';

class InvoiceLayoutSettingsTab extends StatefulWidget {
  const InvoiceLayoutSettingsTab({super.key});

  @override
  State<InvoiceLayoutSettingsTab> createState() => _InvoiceLayoutSettingsTabState();
}

class _InvoiceLayoutSettingsTabState extends State<InvoiceLayoutSettingsTab> {
  bool _autoPrint = false;

  @override
  void initState() {
    super.initState();
    _autoPrint = PrintSettingsService.isPrintEnabled;
  }

  @override
  Widget build(BuildContext context) {
    final layout = context.select<SettingsBloc, InvoiceLayoutSettings>(
        (bloc) => bloc.state.settings.invoiceLayout);
    final bloc = context.read<SettingsBloc>();
    return SettingsShell(
      title: AdminStrings.invoiceLayoutTitle,
      description: AdminStrings.invoiceLayoutDescription,
      children: [
        SettingsFieldBuilders.buildToggle(
          AppStrings.adminAutoPrint,
          _autoPrint,
          (v) {
            setState(() => _autoPrint = v);
            PrintSettingsService.isPrintEnabled = v;
          },
        ),
        const Divider(),
        SettingsFieldBuilders.buildToggle(
          AdminStrings.invoiceLayoutShowLogo,
          layout.showLogo,
          (v) => bloc.add(UpdateInvoiceLayoutSettings((e) {
            e.showLogo = v;
            return e;
          })),
        ),
        SettingsFieldBuilders.buildToggle(
          AdminStrings.invoiceLayoutShowCustomer,
          layout.showCustomerInfo,
          (v) => bloc.add(UpdateInvoiceLayoutSettings((e) {
            e.showCustomerInfo = v;
            return e;
          })),
        ),
        SettingsFieldBuilders.buildToggle(
          AdminStrings.invoiceLayoutShowTax,
          layout.showTax,
          (v) => bloc.add(UpdateInvoiceLayoutSettings((e) {
            e.showTax = v;
            return e;
          })),
        ),
        SettingsFieldBuilders.buildToggle(
          AdminStrings.invoiceLayoutShowDiscount,
          layout.showDiscount,
          (v) => bloc.add(UpdateInvoiceLayoutSettings((e) {
            e.showDiscount = v;
            return e;
          })),
        ),
        SettingsFieldBuilders.buildToggle(
          AdminStrings.invoiceLayoutShowBarcode,
          layout.showBarcode,
          (v) => bloc.add(UpdateInvoiceLayoutSettings((e) {
            e.showBarcode = v;
            return e;
          })),
        ),
        SettingsFieldBuilders.buildToggle(
          AdminStrings.invoiceLayoutShowPrice,
          layout.showPrice,
          (v) => bloc.add(UpdateInvoiceLayoutSettings((e) {
            e.showPrice = v;
            return e;
          })),
        ),
        SettingsFieldBuilders.buildDropdown(
          AdminStrings.invoiceLayoutPaperSize,
          layout.paperSize,
          const ['80mm', 'A4', '58mm'],
          const ['80 مم (حراري)', 'A4', '58 مم (صغير)'],
          (v) => bloc.add(UpdateInvoiceLayoutSettings((e) {
            e.paperSize = v!;
            return e;
          })),
        ),
        SettingsFieldBuilders.buildDropdown(
          AdminStrings.invoiceLayoutFontSize,
          layout.fontSize,
          const ['small', 'medium', 'large'],
          const ['صغير', 'متوسط', 'كبير'],
          (v) => bloc.add(UpdateInvoiceLayoutSettings((e) {
            e.fontSize = v!;
            return e;
          })),
        ),
        SettingsFieldBuilders.buildField(
          AdminStrings.invoiceLayoutFooterText,
          layout.footerText ?? '',
          (v) => bloc.add(UpdateInvoiceLayoutSettings((e) {
            e.footerText = v.isEmpty ? null : v;
            return e;
          })),
        ),
      ],
    );
  }
}
