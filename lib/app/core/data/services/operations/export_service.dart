import 'dart:convert';
import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pharmacy_system/app/core/models/contacts/customer_ledger_model.dart';
import 'package:pharmacy_system/app/core/models/contacts/supplier_ledger_model.dart';
import 'package:pharmacy_system/app/core/models/contacts/supplier_model.dart';
import 'package:pharmacy_system/app/core/constants/app_strings.dart';

class ExportService {
  static Future<File> exportCustomerLedgerToXlsx({
    required List<ContactLedgerModel> entries,
    required String customerName,
  }) async {
    final excel = Excel.createExcel();
    final sheet = excel[ExportStrings.exportTitleLedger];

    sheet.appendRow([
      TextCellValue(ExportStrings.exportCustomerLedger),
      TextCellValue(customerName),
    ]);
    sheet.appendRow([]);
    sheet.appendRow([
      TextCellValue(ExportStrings.exportColumnDate),
      TextCellValue(ExportStrings.exportColumnDescription),
      TextCellValue(ExportStrings.exportColumnDebit),
      TextCellValue(ExportStrings.exportColumnCredit),
      TextCellValue(ExportStrings.exportColumnBalance),
    ]);

    for (final entry in entries) {
      final typeLabel = _getCustomerEntryTypeLabel(entry.type);
      sheet.appendRow([
        TextCellValue(
          '${entry.entryDate.day}/${entry.entryDate.month}/${entry.entryDate.year}',
        ),
        TextCellValue(typeLabel),
        DoubleCellValue(entry.debit),
        DoubleCellValue(entry.credit),
        DoubleCellValue(entry.balanceAfter),
      ]);
    }

    final bytes = excel.encode();
    if (bytes == null) throw Exception(ExportStrings.exportFileError);

    final directory = await getApplicationDocumentsDirectory();
    final fileName =
        'customer_ledger_${DateTime.now().millisecondsSinceEpoch}.xlsx';
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(bytes);

    return file;
  }

  static Future<File> exportSupplierLedgerToXlsx({
    required List<SupplierLedgerModel> entries,
    required String supplierName,
  }) async {
    final excel = Excel.createExcel();
    final sheet = excel[ExportStrings.exportTitleLedger];

    sheet.appendRow([
      TextCellValue(ExportStrings.exportSupplierLedger),
      TextCellValue(supplierName),
    ]);
    sheet.appendRow([]);
    sheet.appendRow([
      TextCellValue(ExportStrings.exportColumnDate),
      TextCellValue(ExportStrings.exportColumnDescription),
      TextCellValue(ExportStrings.exportColumnDebit),
      TextCellValue(ExportStrings.exportColumnCredit),
      TextCellValue(ExportStrings.exportColumnBalance),
    ]);

    for (final entry in entries) {
      final typeLabel = _getSupplierEntryTypeLabel(entry.type);
      sheet.appendRow([
        TextCellValue(
          '${entry.entryDate.day}/${entry.entryDate.month}/${entry.entryDate.year}',
        ),
        TextCellValue(typeLabel),
        DoubleCellValue(entry.debit),
        DoubleCellValue(entry.credit),
        DoubleCellValue(entry.balanceAfter),
      ]);
    }

    final bytes = excel.encode();
    if (bytes == null) throw Exception(ExportStrings.exportFileError);

    final directory = await getApplicationDocumentsDirectory();
    final fileName =
        'supplier_ledger_${DateTime.now().millisecondsSinceEpoch}.xlsx';
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(bytes);

    return file;
  }

  static Future<File> exportCustomerLedgerToHtml({
    required List<ContactLedgerModel> entries,
    required String customerName,
  }) async {
    final buffer = StringBuffer();
    buffer.write('''
<!DOCTYPE html>
<html dir="rtl" lang="ar">
<head>
    <meta charset="UTF-8">
    <title>${ExportStrings.exportTitleLedger} - $customerName</title>
    <style>
        body { font-family: Arial, sans-serif; direction: rtl; text-align: right; padding: 20px; }
        h1 { color: #333; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: center; }
        th { background-color: #f2f2f2; }
        tr:nth-child(even) { background-color: #f9f9f9; }
    </style>
</head>
<body>
    <h1>${ExportStrings.exportCustomerLedger}: $customerName</h1>
    <table>
        <tr>
            <th>${ExportStrings.exportColumnDate}</th>
            <th>${ExportStrings.exportColumnDescription}</th>
            <th>${ExportStrings.exportColumnDebit}</th>
            <th>${ExportStrings.exportColumnCredit}</th>
            <th>${ExportStrings.exportColumnBalance}</th>
        </tr>
''');

    for (final entry in entries) {
      final typeLabel = _getCustomerEntryTypeLabel(entry.type);
      buffer.write('''
        <tr>
            <td>${entry.entryDate.day}/${entry.entryDate.month}/${entry.entryDate.year}</td>
            <td>$typeLabel${entry.referenceNumber != null ? ' #${entry.referenceNumber}' : ''}</td>
            <td>${entry.debit > 0 ? entry.debit.toStringAsFixed(2) : '-'}</td>
            <td>${entry.credit > 0 ? entry.credit.toStringAsFixed(2) : '-'}</td>
            <td>${entry.balanceAfter.toStringAsFixed(2)}</td>
        </tr>
''');
    }

    buffer.write('''
    </table>
</body>
</html>
''');

    final directory = await getApplicationDocumentsDirectory();
    final fileName =
        'customer_ledger_${DateTime.now().millisecondsSinceEpoch}.html';
    final file = File('${directory.path}/$fileName');
    await file.writeAsString(buffer.toString(), encoding: utf8);

    return file;
  }

  static Future<File> exportSupplierLedgerToHtml({
    required List<SupplierLedgerModel> entries,
    required String supplierName,
  }) async {
    final buffer = StringBuffer();
    buffer.write('''
<!DOCTYPE html>
<html dir="rtl" lang="ar">
<head>
    <meta charset="UTF-8">
    <title>${ExportStrings.exportTitleLedger} - $supplierName</title>
    <style>
        body { font-family: Arial, sans-serif; direction: rtl; text-align: right; padding: 20px; }
        h1 { color: #333; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: center; }
        th { background-color: #f2f2f2; }
        tr:nth-child(even) { background-color: #f9f9f9; }
    </style>
</head>
<body>
    <h1>${ExportStrings.exportSupplierLedger}: $supplierName</h1>
    <table>
        <tr>
            <th>${ExportStrings.exportColumnDate}</th>
            <th>${ExportStrings.exportColumnDescription}</th>
            <th>${ExportStrings.exportColumnDebit}</th>
            <th>${ExportStrings.exportColumnCredit}</th>
            <th>${ExportStrings.exportColumnBalance}</th>
        </tr>
''');

    for (final entry in entries) {
      final typeLabel = _getSupplierEntryTypeLabel(entry.type);
      buffer.write('''
        <tr>
            <td>${entry.entryDate.day}/${entry.entryDate.month}/${entry.entryDate.year}</td>
            <td>$typeLabel${entry.referenceNumber != null ? ' #${entry.referenceNumber}' : ''}</td>
            <td>${entry.debit > 0 ? entry.debit.toStringAsFixed(2) : '-'}</td>
            <td>${entry.credit > 0 ? entry.credit.toStringAsFixed(2) : '-'}</td>
            <td>${entry.balanceAfter.toStringAsFixed(2)}</td>
        </tr>
''');
    }

    buffer.write('''
    </table>
</body>
</html>
''');

    final directory = await getApplicationDocumentsDirectory();
    final fileName =
        'supplier_ledger_${DateTime.now().millisecondsSinceEpoch}.html';
    final file = File('${directory.path}/$fileName');
    await file.writeAsString(buffer.toString(), encoding: utf8);

    return file;
  }

  static Future<File> exportCustomerLedgerToXml({
    required List<ContactLedgerModel> entries,
    required String customerName,
  }) async {
    final buffer = StringBuffer();
    buffer.write('''<?xml version="1.0" encoding="UTF-8"?>
<ledger>
    <title>${ExportStrings.exportCustomerLedger}: $customerName</title>
    <entries>
''');

    for (final entry in entries) {
      final typeLabel = _getCustomerEntryTypeLabel(entry.type);
      buffer.write('''
        <entry>
            <date>${entry.entryDate.toIso8601String()}</date>
            <type>$typeLabel</type>
            <debit>${entry.debit}</debit>
            <credit>${entry.credit}</credit>
            <balance>${entry.balanceAfter}</balance>
            <reference>${entry.referenceNumber ?? ''}</reference>
            <notes>${entry.notes ?? ''}</notes>
        </entry>
''');
    }

    buffer.write('''
    </entries>
</ledger>
''');

    final directory = await getApplicationDocumentsDirectory();
    final fileName =
        'customer_ledger_${DateTime.now().millisecondsSinceEpoch}.xml';
    final file = File('${directory.path}/$fileName');
    await file.writeAsString(buffer.toString(), encoding: utf8);

    return file;
  }

  static Future<File> exportSupplierLedgerToXml({
    required List<SupplierLedgerModel> entries,
    required String supplierName,
  }) async {
    final buffer = StringBuffer();
    buffer.write('''<?xml version="1.0" encoding="UTF-8"?>
<ledger>
    <title>${ExportStrings.exportSupplierLedger}: $supplierName</title>
    <entries>
''');

    for (final entry in entries) {
      final typeLabel = _getSupplierEntryTypeLabel(entry.type);
      buffer.write('''
        <entry>
            <date>${entry.entryDate.toIso8601String()}</date>
            <type>$typeLabel</type>
            <debit>${entry.debit}</debit>
            <credit>${entry.credit}</credit>
            <balance>${entry.balanceAfter}</balance>
            <reference>${entry.referenceNumber ?? ''}</reference>
            <notes>${entry.notes ?? ''}</notes>
        </entry>
''');
    }

    buffer.write('''
    </entries>
</ledger>
''');

    final directory = await getApplicationDocumentsDirectory();
    final fileName =
        'supplier_ledger_${DateTime.now().millisecondsSinceEpoch}.xml';
    final file = File('${directory.path}/$fileName');
    await file.writeAsString(buffer.toString(), encoding: utf8);

    return file;
  }

  static String _getCustomerEntryTypeLabel(CustomerLedgerEntryType type) =>
      switch (type) {
        CustomerLedgerEntryType.openingBalance => ExportStrings.entryTypeOpeningBalance,
        CustomerLedgerEntryType.saleInvoice => ExportStrings.entryTypeSaleInvoice,
        CustomerLedgerEntryType.saleReturn => ExportStrings.entryTypeSaleReturn,
        CustomerLedgerEntryType.customerPayment => ExportStrings.entryTypePayment,
        CustomerLedgerEntryType.saleVoid => ExportStrings.entryTypeVoidInvoice,
        CustomerLedgerEntryType.manualAdjustment => ExportStrings.entryTypeManualAdjustment,
        CustomerLedgerEntryType.additionNotice => ExportStrings.entryTypeAddition,
        CustomerLedgerEntryType.discountNotice => ExportStrings.entryTypeDiscount,
        CustomerLedgerEntryType.checkReceipt => ExportStrings.entryTypeCheckReceipt,
        CustomerLedgerEntryType.checkPayment => ExportStrings.entryTypeCheckPayment,
      };

  static String _getSupplierEntryTypeLabel(SupplierLedgerEntryType type) =>
      switch (type) {
        SupplierLedgerEntryType.openingBalance => ExportStrings.entryTypeOpeningBalance,
        SupplierLedgerEntryType.purchaseInvoice => ExportStrings.entryTypePurchaseInvoice,
        SupplierLedgerEntryType.supplierPayment => ExportStrings.entryTypePayment,
        SupplierLedgerEntryType.purchaseVoid => ExportStrings.entryTypeVoidInvoice,
        SupplierLedgerEntryType.manualAdjustment => ExportStrings.entryTypeManualAdjustment,
        SupplierLedgerEntryType.additionNotice => ExportStrings.entryTypeAddition,
        SupplierLedgerEntryType.discountNotice => ExportStrings.entryTypeDiscount,
        SupplierLedgerEntryType.checkReceipt => ExportStrings.entryTypeCheckReceipt,
        SupplierLedgerEntryType.checkPayment => ExportStrings.entryTypeCheckPayment,
      };

  static Future<void> shareFile(File file) async {
    // ??? ?????? ????? ?? ???? ????? ????????
  }

  static Future<File> exportToCsv({
    required String content,
    required String fileName,
  }) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');
    await file.writeAsString(content, encoding: utf8);
    return file;
  }

  static Future<File> exportCustomersToXlsx({
    required List<Map<String, dynamic>> entries,
  }) async {
    final excel = Excel.createExcel();
    final sheet = excel[CustomersStrings.customersTitle];

    sheet.appendRow([
      TextCellValue(ExportStrings.exportCustomerList),
      TextCellValue('${ExportStrings.exportDatePrefix}${DateTime.now().toString().split('.')[0]}'),
    ]);
    sheet.appendRow([]);
    sheet.appendRow([
      TextCellValue(ExportStrings.exportColumnName),
      TextCellValue(ExportStrings.exportColumnType),
      TextCellValue(ExportStrings.exportColumnPhone),
      TextCellValue(ExportStrings.exportColumnCompany),
      TextCellValue(ExportStrings.exportColumnEmail),
      TextCellValue(ExportStrings.exportColumnTaxId),
      TextCellValue(ExportStrings.exportColumnAddress),
      TextCellValue(ExportStrings.exportColumnCreditLimit),
      TextCellValue(ExportStrings.exportColumnDiscountPercent),
      TextCellValue(ExportStrings.exportColumnPaymentTerm),
      TextCellValue(GeneralStrings.balance),
      TextCellValue(ExportStrings.exportColumnStatus),
    ]);

    for (final entry in entries) {
      sheet.appendRow([
        TextCellValue(entry['name'] ?? ''),
        TextCellValue(entry['kind'] ?? ''),
        TextCellValue(entry['phone'] ?? ''),
        TextCellValue(entry['company'] ?? ''),
        TextCellValue(entry['email'] ?? ''),
        TextCellValue(entry['taxId'] ?? ''),
        TextCellValue(entry['address'] ?? ''),
        DoubleCellValue((entry['creditLimit'] as num?)?.toDouble() ?? 0),
        DoubleCellValue((entry['discountPercent'] as num?)?.toDouble() ?? 0),
        IntCellValue((entry['paymentTermDays'] as num?)?.toInt() ?? 0),
        DoubleCellValue((entry['balance'] as num?)?.toDouble() ?? 0),
        TextCellValue(entry['isActive'] == true ? ExportStrings.exportStatusActive : ExportStrings.exportStatusInactive),
      ]);
    }

    final bytes = excel.encode();
    if (bytes == null) throw Exception(ExportStrings.exportFileError);

    final directory = await getApplicationDocumentsDirectory();
    final fileName = 'customers_${DateTime.now().millisecondsSinceEpoch}.xlsx';
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(bytes);

    return file;
  }

  static Future<File> exportSuppliersToXlsx({
    required List<SupplierModel> suppliers,
  }) async {
    final excel = Excel.createExcel();
    final sheet = excel[SuppliersStrings.suppliersTitle];

    sheet.appendRow([
      TextCellValue(ExportStrings.exportSupplierList),
      TextCellValue('${ExportStrings.exportDatePrefix}${DateTime.now().toString().split('.')[0]}'),
    ]);
    sheet.appendRow([]);
    sheet.appendRow([
      TextCellValue(ExportStrings.exportColumnName),
      TextCellValue(ExportStrings.exportColumnType),
      TextCellValue(ExportStrings.exportColumnPartyType),
      TextCellValue(ExportStrings.exportColumnPhone),
      TextCellValue(ExportStrings.exportColumnCompany),
      TextCellValue(ExportStrings.exportColumnEmail),
      TextCellValue(ExportStrings.exportColumnTaxId),
      TextCellValue(ExportStrings.exportColumnAddress),
      TextCellValue(ExportStrings.exportColumnCreditLimit),
      TextCellValue(ExportStrings.exportColumnDiscountPercent),
      TextCellValue(ExportStrings.exportColumnPaymentTerm),
      TextCellValue(ExportStrings.exportColumnStatus),
    ]);

    for (final supplier in suppliers) {
      sheet.appendRow([
        TextCellValue(supplier.name),
        TextCellValue(SuppliersStrings.supplierType),
        TextCellValue(supplier.partyTypeName),
        TextCellValue(supplier.phone ?? ''),
        TextCellValue(supplier.companyName ?? ''),
        TextCellValue(supplier.email ?? ''),
        TextCellValue(supplier.taxId ?? ''),
        TextCellValue(supplier.address ?? ''),
        DoubleCellValue(supplier.creditLimit),
        DoubleCellValue(supplier.discountPercent),
        IntCellValue(supplier.paymentTermDays),
        TextCellValue(supplier.isActive ? ExportStrings.exportStatusActive : ExportStrings.exportStatusInactive),
      ]);
    }

    final bytes = excel.encode();
    if (bytes == null) throw Exception(ExportStrings.exportFileError);

    final directory = await getApplicationDocumentsDirectory();
    final fileName = 'suppliers_${DateTime.now().millisecondsSinceEpoch}.xlsx';
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(bytes);

    return file;
  }
}







