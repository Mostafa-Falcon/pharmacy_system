import 'dart:convert';
import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pharmacy_system/app/modules/contacts/models/customer_ledger_model.dart';
import 'package:pharmacy_system/app/modules/contacts/models/supplier_ledger_model.dart';
import 'package:pharmacy_system/app/modules/contacts/models/supplier_model.dart';
import 'package:pharmacy_system/app/core/constants/app_strings.dart';

class ExportService {
  static Future<File> exportCustomerLedgerToXlsx({
    required List<CustomerLedgerModel> entries,
    required String customerName,
  }) async {
    final excel = Excel.createExcel();
    final sheet = excel[AppStrings.exportTitleLedger];

    sheet.appendRow([
      TextCellValue(AppStrings.exportCustomerLedger),
      TextCellValue(customerName),
    ]);
    sheet.appendRow([]);
    sheet.appendRow([
      TextCellValue(AppStrings.exportColumnDate),
      TextCellValue(AppStrings.exportColumnDescription),
      TextCellValue(AppStrings.exportColumnDebit),
      TextCellValue(AppStrings.exportColumnCredit),
      TextCellValue(AppStrings.exportColumnBalance),
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
    if (bytes == null) throw Exception(AppStrings.exportFileError);

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
    final sheet = excel[AppStrings.exportTitleLedger];

    sheet.appendRow([
      TextCellValue(AppStrings.exportSupplierLedger),
      TextCellValue(supplierName),
    ]);
    sheet.appendRow([]);
    sheet.appendRow([
      TextCellValue(AppStrings.exportColumnDate),
      TextCellValue(AppStrings.exportColumnDescription),
      TextCellValue(AppStrings.exportColumnDebit),
      TextCellValue(AppStrings.exportColumnCredit),
      TextCellValue(AppStrings.exportColumnBalance),
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
    if (bytes == null) throw Exception(AppStrings.exportFileError);

    final directory = await getApplicationDocumentsDirectory();
    final fileName =
        'supplier_ledger_${DateTime.now().millisecondsSinceEpoch}.xlsx';
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(bytes);

    return file;
  }

  static Future<File> exportCustomerLedgerToHtml({
    required List<CustomerLedgerModel> entries,
    required String customerName,
  }) async {
    final buffer = StringBuffer();
    buffer.write('''
<!DOCTYPE html>
<html dir="rtl" lang="ar">
<head>
    <meta charset="UTF-8">
    <title>${AppStrings.exportTitleLedger} - $customerName</title>
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
    <h1>${AppStrings.exportCustomerLedger}: $customerName</h1>
    <table>
        <tr>
            <th>${AppStrings.exportColumnDate}</th>
            <th>${AppStrings.exportColumnDescription}</th>
            <th>${AppStrings.exportColumnDebit}</th>
            <th>${AppStrings.exportColumnCredit}</th>
            <th>${AppStrings.exportColumnBalance}</th>
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
    <title>${AppStrings.exportTitleLedger} - $supplierName</title>
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
    <h1>${AppStrings.exportSupplierLedger}: $supplierName</h1>
    <table>
        <tr>
            <th>${AppStrings.exportColumnDate}</th>
            <th>${AppStrings.exportColumnDescription}</th>
            <th>${AppStrings.exportColumnDebit}</th>
            <th>${AppStrings.exportColumnCredit}</th>
            <th>${AppStrings.exportColumnBalance}</th>
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
    required List<CustomerLedgerModel> entries,
    required String customerName,
  }) async {
    final buffer = StringBuffer();
    buffer.write('''<?xml version="1.0" encoding="UTF-8"?>
<ledger>
    <title>${AppStrings.exportCustomerLedger}: $customerName</title>
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
    <title>${AppStrings.exportSupplierLedger}: $supplierName</title>
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
        CustomerLedgerEntryType.openingBalance => AppStrings.entryTypeOpeningBalance,
        CustomerLedgerEntryType.saleInvoice => AppStrings.entryTypeSaleInvoice,
        CustomerLedgerEntryType.saleReturn => AppStrings.entryTypeSaleReturn,
        CustomerLedgerEntryType.customerPayment => AppStrings.entryTypePayment,
        CustomerLedgerEntryType.saleVoid => AppStrings.entryTypeVoidInvoice,
        CustomerLedgerEntryType.manualAdjustment => AppStrings.entryTypeManualAdjustment,
        CustomerLedgerEntryType.additionNotice => AppStrings.entryTypeAddition,
        CustomerLedgerEntryType.discountNotice => AppStrings.entryTypeDiscount,
        CustomerLedgerEntryType.checkReceipt => AppStrings.entryTypeCheckReceipt,
        CustomerLedgerEntryType.checkPayment => AppStrings.entryTypeCheckPayment,
      };

  static String _getSupplierEntryTypeLabel(SupplierLedgerEntryType type) =>
      switch (type) {
        SupplierLedgerEntryType.openingBalance => AppStrings.entryTypeOpeningBalance,
        SupplierLedgerEntryType.purchaseInvoice => AppStrings.entryTypePurchaseInvoice,
        SupplierLedgerEntryType.supplierPayment => AppStrings.entryTypePayment,
        SupplierLedgerEntryType.purchaseVoid => AppStrings.entryTypeVoidInvoice,
        SupplierLedgerEntryType.manualAdjustment => AppStrings.entryTypeManualAdjustment,
        SupplierLedgerEntryType.additionNotice => AppStrings.entryTypeAddition,
        SupplierLedgerEntryType.discountNotice => AppStrings.entryTypeDiscount,
        SupplierLedgerEntryType.checkReceipt => AppStrings.entryTypeCheckReceipt,
        SupplierLedgerEntryType.checkPayment => AppStrings.entryTypeCheckPayment,
      };

  static Future<void> shareFile(File file) async {
    // يتم مشاركة الملف من خلال واجهة المستخدم
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
    final sheet = excel[AppStrings.customersTitle];

    sheet.appendRow([
      TextCellValue(AppStrings.exportCustomerList),
      TextCellValue('${AppStrings.exportDatePrefix}${DateTime.now().toString().split('.')[0]}'),
    ]);
    sheet.appendRow([]);
    sheet.appendRow([
      TextCellValue(AppStrings.exportColumnName),
      TextCellValue(AppStrings.exportColumnType),
      TextCellValue(AppStrings.exportColumnPhone),
      TextCellValue(AppStrings.exportColumnCompany),
      TextCellValue(AppStrings.exportColumnEmail),
      TextCellValue(AppStrings.exportColumnTaxId),
      TextCellValue(AppStrings.exportColumnAddress),
      TextCellValue(AppStrings.exportColumnCreditLimit),
      TextCellValue(AppStrings.exportColumnDiscountPercent),
      TextCellValue(AppStrings.exportColumnPaymentTerm),
      TextCellValue(AppStrings.balance),
      TextCellValue(AppStrings.exportColumnStatus),
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
        TextCellValue(entry['isActive'] == true ? AppStrings.exportStatusActive : AppStrings.exportStatusInactive),
      ]);
    }

    final bytes = excel.encode();
    if (bytes == null) throw Exception(AppStrings.exportFileError);

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
    final sheet = excel[AppStrings.suppliersTitle];

    sheet.appendRow([
      TextCellValue(AppStrings.exportSupplierList),
      TextCellValue('${AppStrings.exportDatePrefix}${DateTime.now().toString().split('.')[0]}'),
    ]);
    sheet.appendRow([]);
    sheet.appendRow([
      TextCellValue(AppStrings.exportColumnName),
      TextCellValue(AppStrings.exportColumnType),
      TextCellValue(AppStrings.exportColumnPartyType),
      TextCellValue(AppStrings.exportColumnPhone),
      TextCellValue(AppStrings.exportColumnCompany),
      TextCellValue(AppStrings.exportColumnEmail),
      TextCellValue(AppStrings.exportColumnTaxId),
      TextCellValue(AppStrings.exportColumnAddress),
      TextCellValue(AppStrings.exportColumnCreditLimit),
      TextCellValue(AppStrings.exportColumnDiscountPercent),
      TextCellValue(AppStrings.exportColumnPaymentTerm),
      TextCellValue(AppStrings.exportColumnStatus),
    ]);

    for (final supplier in suppliers) {
      sheet.appendRow([
        TextCellValue(supplier.name),
        TextCellValue(AppStrings.supplierType),
        TextCellValue(supplier.partyTypeName),
        TextCellValue(supplier.phone ?? ''),
        TextCellValue(supplier.companyName ?? ''),
        TextCellValue(supplier.email ?? ''),
        TextCellValue(supplier.taxId ?? ''),
        TextCellValue(supplier.address ?? ''),
        DoubleCellValue(supplier.creditLimit),
        DoubleCellValue(supplier.discountPercent),
        IntCellValue(supplier.paymentTermDays),
        TextCellValue(supplier.isActive ? AppStrings.exportStatusActive : AppStrings.exportStatusInactive),
      ]);
    }

    final bytes = excel.encode();
    if (bytes == null) throw Exception(AppStrings.exportFileError);

    final directory = await getApplicationDocumentsDirectory();
    final fileName = 'suppliers_${DateTime.now().millisecondsSinceEpoch}.xlsx';
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(bytes);

    return file;
  }
}

